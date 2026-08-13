HUGO    ?= hugo
PORT    ?= 1313
PUBLIC  ?= public

# Where copyparty serves this from: /tank/josh/public -> /shared
COPYPARTY_DIR ?= /tank2/tank/josh/public/hexen2-community-site

.PHONY: help serve build portable check deploy clean

help:
	@echo "make serve      hugo dev server on :$(PORT)"
	@echo "make build      canonical build (absolute URLs, real domain)"
	@echo "make portable   subdirectory-safe build (relative URLs)"
	@echo "make check      build + link/consistency checks"
	@echo "make deploy     portable build + rsync to copyparty"
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

deploy: portable
	python3 scripts/check-links.py --public $(PUBLIC)
	rsync -a --delete --exclude '.git' --exclude '.hugo_build.lock' \
		./ $(COPYPARTY_DIR)/
	@echo "deployed to $(COPYPARTY_DIR)"

clean:
	rm -rf $(PUBLIC) resources/_gen .hugo_build.lock
