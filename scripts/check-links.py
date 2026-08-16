#!/usr/bin/env python3
"""Link and consistency checks for the built site.

Run after `hugo`. Exits non-zero on any failure so CI blocks the deploy.

Checks:
  1. Internal links resolve to a page that was actually built.
  2. Every redirect rule in _redirects points at a /moved/ page that exists.
  3. Every download entry in data/files.yaml has a checksum and >= 2 links.
  4. Every outbound link record carries a `verified:` date, and none is older
     than --max-age days (default 180). Link rot is the failure mode this whole
     site is designed around; letting it go unmeasured defeats the point.
  5. --external additionally HEADs every outbound URL. Off by default so the
     fast check stays offline and hermetic.

Usage:
  scripts/check-links.py [--public public] [--max-age 180] [--external]
"""

import argparse
import datetime as dt
import os
import posixpath
import re
import sys
import urllib.error
import urllib.request

HREF = re.compile(r'href="([^"]+)"')
# Inline <script>/<style> bodies contain string literals that look like markup
# (the search page builds result HTML in JS). Strip them before scanning.
SCRIPTISH = re.compile(r"(?is)<(script|style)\b.*?</\1>")
SKIP_SCHEMES = ("http://", "https://", "mailto:", "tel:", "#", "data:")
ASSET_SUFFIXES = (".css", ".js", ".xml", ".json", ".png", ".jpg", ".svg", ".ico", ".txt")

fails: list[str] = []
warns: list[str] = []


def fail(msg: str) -> None:
    fails.append(msg)


def warn(msg: str) -> None:
    warns.append(msg)


def load_yaml(path):
    try:
        import yaml  # type: ignore
    except ImportError:
        warn(f"PyYAML not installed — skipped data checks on {path}")
        return None
    with open(path, encoding="utf-8") as fh:
        return yaml.safe_load(fh)


def build_route_set(public: str) -> set[str]:
    routes = set()
    for dirpath, _, filenames in os.walk(public):
        for fn in filenames:
            full = os.path.join(dirpath, fn)
            rel = "/" + os.path.relpath(full, public).replace(os.sep, "/")
            routes.add(rel)
            if fn == "index.html":
                routes.add(rel[: -len("index.html")])
    return routes


def check_internal_links(public: str, routes: set[str]) -> int:
    checked = 0
    for dirpath, _, filenames in os.walk(public):
        for fn in filenames:
            if not fn.endswith(".html"):
                continue
            page = os.path.join(dirpath, fn)
            rel_page = os.path.relpath(page, public)
            with open(page, encoding="utf-8") as fh:
                html = SCRIPTISH.sub(" ", fh.read())
            # Directory of this page, as a site-absolute path ending in "/".
            page_dir = "/" + os.path.dirname(rel_page).replace(os.sep, "/")
            if not page_dir.endswith("/"):
                page_dir += "/"

            for href in HREF.findall(html):
                if href.startswith(SKIP_SCHEMES) or not href:
                    continue
                target = href.split("#")[0].split("?")[0]
                if not target:
                    continue
                checked += 1
                # Relative hrefs (the portable build emits ../../foo/) resolve
                # against the page's own directory, exactly as a browser would.
                if target.startswith("/"):
                    resolved = target
                else:
                    resolved = posixpath.normpath(page_dir + target)
                    if target.endswith("/") and not resolved.endswith("/"):
                        resolved += "/"
                if not resolved.endswith(ASSET_SUFFIXES) and not resolved.endswith("/"):
                    resolved += "/"
                if resolved not in routes:
                    fail(f"broken internal link: {rel_page} -> {href} (resolved {resolved})")
    return checked


def check_redirects(public: str, routes: set[str]) -> int:
    path = os.path.join(public, "_redirects")
    if not os.path.exists(path):
        warn("_redirects was not generated")
        return 0
    n = 0
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split()
            if len(parts) < 2:
                continue
            dest = parts[1]
            n += 1
            if dest not in routes:
                fail(f"_redirects points at a page that does not exist: {line}")
    return n


def check_aliases(oldlinks_yaml, routes: set[str]) -> int:
    """Every legacy path must have a built redirect page at the path itself.

    The _redirects/.htaccess outputs only work on hosts that read them; the
    aliases are what make an old link resolve anywhere. If an alias silently
    stops being generated, the rules keep looking correct while every twenty-
    year-old bookmark quietly 404s — so this asserts the page is really there.
    """
    if not oldlinks_yaml:
        return 0
    n = 0
    for rec in oldlinks_yaml:
        frm = rec.get("from")
        if not frm:
            fail("oldlinks: record with no `from:`")
            continue
        n += 1
        if frm not in routes:
            fail(f"legacy path '{frm}' has no redirect page (alias missing)")
    return n


def check_downloads(files_yaml) -> int:
    if not files_yaml:
        return 0
    n = 0
    for e in files_yaml.get("entries", []):
        n += 1
        name = e.get("name", "<unnamed>")
        sha = str(e.get("sha256", ""))
        if len(sha) != 64:
            fail(f"download '{name}': sha256 must be 64 hex chars")
        links = [e.get("primary")] + [m.get("url") for m in e.get("mirrors", [])]
        links = [u for u in links if u]
        if len(links) < 2:
            fail(f"download '{name}': needs a primary plus at least one mirror")
    return n


def check_verified(community_yaml, max_age: int) -> int:
    if not community_yaml:
        return 0
    today = dt.date.today()
    n = 0
    for key in ("places", "projects", "people", "servers"):
        for rec in community_yaml.get(key, []):
            label = rec.get("name", "<unnamed>")
            v = rec.get("verified")
            if not v:
                fail(f"{key}/{label}: missing `verified:` date")
                continue
            n += 1
            try:
                when = dt.date.fromisoformat(str(v))
            except ValueError:
                fail(f"{key}/{label}: `verified: {v}` is not an ISO date")
                continue
            age = (today - when).days
            if age > max_age:
                fail(f"{key}/{label}: last verified {age} days ago (limit {max_age})")
    return n


def check_external(community_yaml, files_yaml) -> int:
    urls = set()
    for y, keys in ((community_yaml, ("places", "projects", "people")),):
        if not y:
            continue
        for key in keys:
            for rec in y.get(key, []):
                if rec.get("url"):
                    urls.add(rec["url"])
    if files_yaml:
        for e in files_yaml.get("entries", []):
            if e.get("primary"):
                urls.add(e["primary"])
            for m in e.get("mirrors", []):
                if m.get("url"):
                    urls.add(m["url"])
    for u in sorted(urls):
        if "EXAMPLE" in u:
            warn(f"placeholder URL still present: {u}")
            continue
        req = urllib.request.Request(u, method="HEAD", headers={"User-Agent": "thyrion-linkcheck"})
        try:
            urllib.request.urlopen(req, timeout=15)
        except urllib.error.HTTPError as exc:
            if exc.code in (403, 405):  # HEAD refused, not necessarily dead
                warn(f"{u} -> HTTP {exc.code} (HEAD refused)")
            else:
                fail(f"dead outbound link: {u} -> HTTP {exc.code}")
        except Exception as exc:  # noqa: BLE001
            fail(f"dead outbound link: {u} -> {type(exc).__name__}")
    return len(urls)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--public", default="public")
    ap.add_argument("--max-age", type=int, default=180)
    ap.add_argument("--external", action="store_true")
    args = ap.parse_args()

    if not os.path.isdir(args.public):
        print(f"error: {args.public}/ not found — run `hugo` first", file=sys.stderr)
        return 2

    routes = build_route_set(args.public)
    n_links = check_internal_links(args.public, routes)
    n_redir = check_redirects(args.public, routes)

    files_yaml = load_yaml("data/files.yaml") if os.path.exists("data/files.yaml") else None
    community_yaml = load_yaml("data/community.yaml") if os.path.exists("data/community.yaml") else None
    oldlinks_yaml = load_yaml("data/oldlinks.yaml") if os.path.exists("data/oldlinks.yaml") else None

    n_alias = check_aliases(oldlinks_yaml, routes)
    n_dl = check_downloads(files_yaml)
    n_ver = check_verified(community_yaml, args.max_age)
    n_ext = check_external(community_yaml, files_yaml) if args.external else 0

    print(f"routes:            {len(routes)}")
    print(f"internal links:    {n_links}")
    print(f"redirect rules:    {n_redir}")
    print(f"legacy aliases:    {n_alias}")
    print(f"downloads:         {n_dl}")
    print(f"verified records:  {n_ver} (max age {args.max_age}d)")
    if args.external:
        print(f"outbound checked:  {n_ext}")

    for w in warns:
        print(f"WARN  {w}")
    for f in fails:
        print(f"FAIL  {f}")

    if fails:
        print(f"\n{len(fails)} failure(s).")
        return 1
    print(f"\nOK — {len(warns)} warning(s), no failures.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
