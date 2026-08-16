HUGO    ?= hugo
PORT    ?= 1313
PUBLIC  ?= public

# Where copyparty serves this from: /tank/josh/public -> /shared
COPYPARTY_DIR ?= /tank2/tank/josh/public/hexen2-community-site

.PHONY: help serve build portable check deploy deploy-dry publish-local clean

help:
	@echo "make serve      hugo dev server on :$(PORT)"
	@echo "make build      canonical build (absolute URLs, real domain)"
	@echo "make portable   subdirectory-safe build (relative URLs)"
	@echo "make check      build + link/consistency checks"
	@echo "make deploy     (on the server) pull from GitHub, build, check, publish"
	@echo "make deploy-dry (on the server) show what deploy would change"
	@echo "make publish-local  publish THIS working tree — bypasses GitHub, emergencies only"
	@echo "make clean      remove $(PUBLIC)/"

serve:
	$(HUGO) server --port $(PORT) --disableFastRender

# Canonical build for the real domain.
build:
	$(HUGO) --gc --cleanDestinationDir

# Portable build: every link relative to the page, so the site works from any
# subdirectory — copyparty, a USB stick, or a Wayback capture. This is the
# "servable from a plain file host" constraint, made testable.
portable:
	HUGO_RELATIVEURLS=true $(HUGO) --gc --cleanDestinationDir

check: build
	python3 scripts/check-links.py --public $(PUBLIC)

# Publishing pulls from GitHub rather than from whatever happens to be in this
# working tree — GitHub is the source of truth, and contributors reach the file
# host through a merged pull request, not through an account on the server.
# Manual by design: no timer, no webhook.
#
# `blog-deploy` is provided by the server's NixOS module, NOT by this repo, and
# deliberately so: anyone can open a pull request here, so nothing in this tree
# is allowed to become code that runs on the file host. These two targets only
# work on the server; everywhere else they will say "command not found", which
# is the correct answer.
deploy:
	blog-deploy

deploy-dry:
	blog-deploy --dry-run

# Escape hatch: publish this working tree directly, skipping GitHub. For when
# the remote is unreachable and something has to go out now. Whatever it
# publishes is overwritten by the next `make deploy`.
publish-local: portable
	python3 scripts/check-links.py --public $(PUBLIC)
	rsync -a --delete --exclude '.hist' $(PUBLIC)/ $(COPYPARTY_DIR)/
	@echo "published working tree to $(COPYPARTY_DIR) (NOT from GitHub)"

clean:
	rm -rf $(PUBLIC) resources/_gen .hugo_build.lock
