# Thyrion — a Hexen II community site (sketch)

A static, git-backed community hub for Hexen II. This is a working Hugo scaffold with
placeholder prose (lorem ipsum), real structure, and real architectural decisions.

Corresponds to beads epic `uhexen2-96ii`.

## Build

```sh
make serve       # dev server on :1313
make build       # canonical build for the real domain
make portable    # subdirectory-safe build (relative URLs)
make check       # build + link/consistency checks
```

No theme module, no npm, no plugins. Hugo binary + this repo = the site. The checker
wants PyYAML; without it the data checks are skipped with a warning rather than failing.

## Publishing

The site is built and hosted entirely by GitHub Pages. There is no server, so
contributing needs a merged pull request and nothing else — no account anywhere, no ssh
key, no shell, and nothing for anyone to hold credentials to.

```sh
gh workflow run publish --repo hexenwail/blog
```

or the **publish** workflow from the Actions tab. It builds, runs the link checks and
deploys. A failed check publishes nothing and leaves the live site standing.

**It is manual on purpose.** Merging is a conversation between contributors; publishing
is a decision, and it stays one. Adding `push: branches: [main]` to
`.github/workflows/pages.yaml` is the single line that would make every merge go live.

### Where it is served from

Until `hexenworld.org` is pointed at GitHub, the site lives at
`https://hexenwail.github.io/blog/` — a subdirectory. `hugo.toml` still names
hexenworld.org as canonical because that is the end state; the workflow's
`SITE_BASE_URL` overrides it in the meantime so that feeds, sitemap, canonical tags and
the legacy redirect pages all point at the address that actually resolves.

The cutover is two steps: add `static/CNAME` containing `hexenworld.org`, and delete the
`SITE_BASE_URL` override. Nothing else changes.

A subdirectory deployment is a genuinely different build from a root one — every
internal link gains the prefix — so CI checks that mode too, and `check-links.py
--base-path` validates it. Note that `relativeURLs` is *not* the tool for this: combined
with a subdirectory baseURL, Hugo emits the prefix twice and every link breaks. It is
for the case where the subdirectory is unknown, such as a USB stick or a Wayback
capture, and it is checked separately.

Residual risk worth knowing: Hugo renders `layouts/` from this repo, and Go templates
are not a sandbox. Content and data changes are inert; a pull request that edits
`layouts/` runs code in the build, so review it as code. The blast radius is an
ephemeral GitHub runner rather than a machine anyone owns, which is much of the reason
to host it this way.

`make publish-local` pushes the working tree straight to the file host, skipping
GitHub. It exists for when the remote is unreachable and something has to go out now;
the next `blog-deploy` overwrites whatever it published.

**Two build modes.** `build` emits root-absolute URLs for the real domain. `portable`
sets `relativeURLs`, so every link resolves relative to its own page and the site works
unchanged from a subdirectory — copyparty, a USB stick, a Wayback capture. Both modes are
checked in CI, because "servable from a plain file host" is a claim that rots silently
unless something tests it.

## Why it is built this way

Two Hexen II community hubs have died: Raven's official hexenworld.com (dynamic; absorbed
into GameSpy in 2002, gone) and hexenworld.org (WordPress; offline since ~March 2025). The
only Hexen II resource still standing after two decades is Inky's hand-written static
Mapping Corner. That is an architecture argument, and this repo takes it:

- **Static output only.** No database, no server-side code. Servable from a plain file
  host, or from the Wayback Machine, unchanged.
- **Content in git** as Markdown and YAML. Fork the repo, keep the site.
- **No JavaScript required** for any content page.
- **Nothing that rots quietly.** Every outbound link carries a `verified:` date; every
  download carries a checksum and two mirrors.

## Layout

```
hugo.toml                     site config, menus, taxonomies
content/
  news/                       dated posts, feeds RSS + Atom
  play/                       get the game → engines → config → classes → troubleshooting
  maps/                       one file per release; drives the database
  modding/                    tutorials; each declares `entities:` in front matter
  reference/_content.gotmpl   content adapter: data/entities.yaml → /reference/<name>/
  community/                  directory (data-driven)
  files/                      downloads (data-driven)
  archive/                    preservation policy, history, interviews
data/
  entities.yaml               entity schema → generated reference pages
  files.yaml                  download catalogue
  community.yaml              places / projects / people / servers
layouts/                      no theme; templates live here
static/css/main.css           one stylesheet, no external fonts
```

## The generated things worth noticing

1. **`/reference/`** — entity pages are generated at build time from `data/entities.yaml`
   by `content/reference/_content.gotmpl`. The old hexenworld.com had ~150 hand-written
   HTML pages here and they all died together. Adding an entity is now one YAML record.

2. **The entity → tutorial cross-index** — Inky's best idea, automated. Tutorials declare
   `entities: [...]` in their front matter; `layouts/reference/section.html` inverts those
   declarations into a table. It cannot disagree with the tutorials because it is derived
   from them.

3. **`/moved/` — the old-link map.** `data/oldlinks.yaml` records the legacy paths people
   still link to (`hexenworld.com/h2entities/`, `/walk/`, `/siege/`, `hexenworld.org/downloads/`,
   …). From that one file Hugo generates a landing page per path, the human-readable table
   at `/moved/`, a **redirect page at each legacy path itself**, and the server rules in
   `_redirects` and `.htaccess`. They all share `partials/legacy-slug.html`, so a redirect
   can never point at a page that does not exist — CI asserts exactly that, and separately
   asserts that every legacy path really got its redirect page. Where we have an equivalent
   page the visitor is sent there; where we do not, they get the Wayback capture and an
   explanation rather than a 404.

   The redirect pages are the part that actually moves people, and they are plain HTML.
   `_redirects` and `.htaccess` are an optimisation for hosts that read them — such a host
   issues a real 301 — but nothing depends on the server understanding anything, so the old
   links keep working from nginx, a plain file server, a USB stick or a Wayback capture
   alike. The previous two Hexen II hubs died together with their server configuration.

   Deep paths under a legacy prefix (`/walk/secrets.html`) cannot be enumerated and fall
   through to `layouts/404.html`, which explains the situation and points at `/moved/`
   instead of showing a bare error.

4. **Search.** `layouts/home.searchindex.json` emits a static index at build time; the
   search page is ~90 lines of vanilla JS with no dependency and no query leaving the
   browser. Entity *key names and spawnflag names* are indexed explicitly, because those
   live in template-rendered tables rather than page text — searching `START_OPEN` or
   `mdl_debris` is the realistic case. With JS off, the page still lists every entity,
   tutorial, release, guide and tag.

## What is placeholder

- All body prose is lorem ipsum or first-draft filler.
- SHA-256 values are dummies; download URLs point at `EXAMPLE`.
- Screenshots are CSS placeholders — no images are committed.
- The Discord invite in `hugo.toml` is a placeholder.

Because of all that, `noindex = true` in `hugo.toml` keeps the site out of search
results: every page carries `<meta name="robots" content="noindex, nofollow">`. Being
the top result for "hexen 2 downloads" while the checksums are dummies would be worse
than not being found at all. **Delete that one line when the content is real.**

Note that `robots.txt` is *not* the mechanism and must not become one. It is ignored
entirely while the site is served from a subdirectory, and blocking a crawler hides the
noindex tag rather than the page — a blocked-but-linked URL can still be listed, as a
bare link with no description. `layouts/robots.txt` says so, at length, to whoever tries.

## Checks

`scripts/check-links.py` runs offline and fails the build on:

- an internal link that resolves to no built page (in *either* build mode — relative
  hrefs are resolved against the page directory, as a browser would)
- a `_redirects` rule pointing at a `/moved/` page that does not exist
- a download without a 64-char SHA-256, or with fewer than two links
- an outbound link record missing a `verified:` date, or older than `--max-age` (180d)

`--external` additionally HEADs every outbound URL. That runs on a schedule, not per
commit: a third-party host being down should not block a typo fix from merging.

## Still to build

Real prose to replace the filler, real screenshots, the walkthroughs section, and the
`.plan`/interview recovery work. See the epic's child issues.
