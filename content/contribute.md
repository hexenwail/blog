---
title: "Contribute"
description: "Add a map, a news post, a tutorial, or a correction — with or without git."
---

## If you do not use git

Message us on [Discord](/community/) or open an issue. Tell us what is wrong or what is
missing and we will do the git part. This is a completely normal way to contribute here and
you are not imposing.

## If you do use git

```sh
git clone https://github.com/EXAMPLE/hexen2-community-site
cd hexen2-community-site
hugo server        # http://localhost:1313
```

Then copy the relevant archetype and open a pull request.

## Adding a release to the database

One file in `content/maps/`. Required front matter:

```yaml
title:        "Your Map"
authors:      ["You"]
released:     "2026-08-13"
releaseType:  "Single map"       # or Hub / Episode / Mod / TC / DM
engine:       "Any (vanilla-compatible)"
vanilla:      true
needsPraevus: false
modes:        ["Single-player"]
download:
  filename: "yourmap-1.0.zip"
  primary:  "https://..."
  size:     "12 MB"
  sha256:   "..."
  mirrors:
    - {label: "Internet Archive", url: "https://..."}
```

## Adding a tutorial

One file in `content/modding/`. Two fields matter beyond the prose:

- `verified` / `verifiedAgainst` — the date and the engine version you actually tested on.
  An undated tutorial is how the last generation of documentation became untrustworthy.
- `entities` — the entity names the article uses. This is what generates the
  [cross-index](/reference/#cross-index); you do not edit that table by hand.

## Adding an entity

One record in `data/entities.yaml`. The page generates itself.

## Style

Lorem ipsum dolor sit amet, consectetur adipiscing elit:

- Screenshots: 1600×900 or wider, JPEG, under 400 KB.
- Credit authors by the name they use, and link their own site over ours.
- Date anything that can go stale.
- Write in plain sentences. This is documentation, not marketing.

## Licensing

Site code and prose are contributed under the repository's stated licence. Third-party
maps, mods and tools keep their own terms — we index them, we do not relicense them.
