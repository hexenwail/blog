---
title: "Entity reference"
description: "Every entity, every key, every spawnflag — generated from data, cross-indexed to the tutorials that use it."
---

The old hexenworld.com shipped roughly 150 hand-written HTML pages here. They were
comprehensive, and they all died at once.

These pages are generated at build time from `data/entities.yaml` by a Hugo content
adapter. Adding an entity is one YAML record. The cross-index at the bottom is inverted
from the tutorials' own front matter, so it cannot disagree with them.
