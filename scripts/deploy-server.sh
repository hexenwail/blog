#!/usr/bin/env bash
#
# Pull the site from GitHub and republish it. Run on the server, by hand.
#
# There is deliberately no timer, no cron entry and no webhook: publishing is a
# decision, not a side effect of someone merging. GitHub holds the source of
# truth; this script is the only thing that moves it onto the file host.
#
#   blog-deploy              pull, build, check, publish
#   blog-deploy --dry-run    show what would change, publish nothing
#
# The clone is a consumer, never an author — it is hard-reset to the remote
# branch on every run, so anything edited on the server is discarded rather
# than silently conflicting with the next pull.
#
# Overridable:
#   BLOG_REPO_URL   BLOG_SRC_DIR   BLOG_PUBLISH_DIR   BLOG_BRANCH
#   BLOG_SKIP_CHECKS=1   publish even if the link checks fail

set -euo pipefail

REPO_URL="${BLOG_REPO_URL:-https://github.com/hexenwail/blog.git}"
SRC_DIR="${BLOG_SRC_DIR:-/home/josh/srv/hexen2-blog}"
PUBLISH_DIR="${BLOG_PUBLISH_DIR:-/tank2/tank/josh/public/hexen2-community-site}"
BRANCH="${BLOG_BRANCH:-main}"
MAX_AGE="${BLOG_MAX_AGE:-180}"

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

# rsync --delete with an empty or root PUBLISH_DIR would eat the file host.
case "$PUBLISH_DIR" in
  ""|"/"|"/*") echo "refusing to publish to '$PUBLISH_DIR'" >&2; exit 2 ;;
esac

say() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }

# --- 1. get the code ---------------------------------------------------------
if [ ! -d "$SRC_DIR/.git" ]; then
  say "cloning $REPO_URL -> $SRC_DIR"
  mkdir -p "$(dirname "$SRC_DIR")"
  git clone --branch "$BRANCH" "$REPO_URL" "$SRC_DIR"
fi

cd "$SRC_DIR"

# Public repo over HTTPS: no deploy key, no server-side credential to leak.
git remote set-url origin "$REPO_URL"

OLD_REV="$(git rev-parse HEAD 2>/dev/null || echo none)"

say "fetching origin/$BRANCH"
git fetch --prune origin "$BRANCH"
NEW_REV="$(git rev-parse "origin/$BRANCH")"

if [ -n "$(git status --porcelain)" ]; then
  echo "note: discarding local modifications in $SRC_DIR (this clone is a consumer)"
fi

if [ "$OLD_REV" = "$NEW_REV" ]; then
  echo "already at $(git rev-parse --short "$NEW_REV") — rebuilding anyway"
else
  say "changes being published"
  git --no-pager log --oneline --no-decorate "$OLD_REV..$NEW_REV" 2>/dev/null || true
fi

git checkout -q -B "$BRANCH" "$NEW_REV"
git reset -q --hard "$NEW_REV"
git clean -qfd

# --- 2. build ----------------------------------------------------------------
# Portable mode: copyparty serves this from a subdirectory (/shared/...), so
# every link has to resolve relative to its own page.
say "building (portable)"
HUGO_RELATIVEURLS=true hugo --gc --cleanDestinationDir

# --- 3. check ----------------------------------------------------------------
# PyYAML is not in the system profile; without it the data checks silently
# downgrade to warnings, so reach for nix-shell before accepting that.
run_checks() {
  if python3 -c 'import yaml' 2>/dev/null; then
    python3 scripts/check-links.py --public public --max-age "$MAX_AGE"
  elif command -v nix-shell >/dev/null 2>&1; then
    nix-shell -p python3Packages.pyyaml --run \
      "python3 scripts/check-links.py --public public --max-age $MAX_AGE"
  else
    echo "warning: PyYAML unavailable — data checks will be skipped"
    python3 scripts/check-links.py --public public --max-age "$MAX_AGE"
  fi
}

say "checking"
if ! run_checks; then
  if [ "${BLOG_SKIP_CHECKS:-0}" = "1" ]; then
    echo "checks failed, publishing anyway (BLOG_SKIP_CHECKS=1)"
  else
    echo "checks failed — nothing published. Re-run with BLOG_SKIP_CHECKS=1 to override." >&2
    exit 1
  fi
fi

# --- 4. publish --------------------------------------------------------------
# Only the built output goes out. The source is on GitHub; /shared is
# world-readable, so there is no reason to mirror a working tree into it.
# .hist is copyparty's own per-volume state and must survive --delete.
mkdir -p "$PUBLISH_DIR"

if [ "$DRY_RUN" = "1" ]; then
  say "dry run — would publish to $PUBLISH_DIR"
  rsync -a --delete --itemize-changes --dry-run --exclude '.hist' public/ "$PUBLISH_DIR/"
  echo
  echo "nothing was written."
  exit 0
fi

say "publishing to $PUBLISH_DIR"
rsync -a --delete --exclude '.hist' public/ "$PUBLISH_DIR/"

say "done"
echo "commit:    $(git rev-parse --short HEAD) $(git log -1 --pretty=%s)"
echo "published: $PUBLISH_DIR"
