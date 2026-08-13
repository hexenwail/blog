# Thyrion — a Hexen II community site (sketch)

A static, git-backed community hub for Hexen II. This is a working Hugo scaffold with
placeholder prose (lorem ipsum), real structure, and real architectural decisions.

Corresponds to beads epic `uhexen2-96ii`.

## Build

```sh
hugo server      # http://localhost:1313
hugo             # writes ./public
```

No theme module, no npm, no plugins. Hugo binary + this repo = the site.

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

## The two generated things worth noticing

1. **`/reference/`** — entity pages are generated at build time from `data/entities.yaml`
   by `content/reference/_content.gotmpl`. The old hexenworld.com had ~150 hand-written
   HTML pages here and they all died together. Adding an entity is now one YAML record.

2. **The entity → tutorial cross-index** — Inky's best idea, automated. Tutorials declare
   `entities: [...]` in their front matter; `layouts/reference/section.html` inverts those
   declarations into a table. It cannot disagree with the tutorials because it is derived
   from them.

## What is placeholder

- All body prose is lorem ipsum or first-draft filler.
- SHA-256 values are dummies; download URLs point at `EXAMPLE`.
- Screenshots are CSS placeholders — no images are committed.
- Domain, Discord invite and repo URL in `hugo.toml` are placeholders.

## Still to build

Client-side search (Pagefind), the old-URL redirect map for `hexenworld.com/*` and
`hexenworld.org/*`, CI link checking, and the archetypes. See the epic's child issues.
