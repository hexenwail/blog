---
title: "Fixing a leak"
description: "Reading the pointfile, finding the hole, and the tricks for sealing one you cannot find."
weight: 20
updated: "2026-08-13"
verified: "2026-08-13"
verifiedAgainst: "Hexenwail 0.7.9-beta.r9, ericw-tools 2.0.0-alpha9"
authors: ["Editor"]
entities: ["func_illusionary", "info_player_start"]
tags: ["no-coding", "compiling"]
---

Lorem ipsum dolor sit amet. `qbsp` says *leaked* and refuses to vis. The map still runs;
it just runs badly, fullbright, and with no working vis.

## Read the pointfile

Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. qbsp writes a `.pts`
file — a line from an entity, through the hole, to the void. Load it in the engine:

```
pointfile
```

Modern engines draw it as direction arrows rather than a dotted line, which makes the
direction of travel obvious.

## The usual holes

1. A brush that looks flush but is off by a fractional unit.
2. An entity outside the map — the leak line starts *at* it, so that is your clue.
3. A `func_illusionary` used as a wall. It is non-solid; it does not seal.

{{< note >}}
Never seal a leak with a giant box around the map. It compiles, it vises, and it will run
at a fraction of the framerate forever. Excepteur sint occaecat cupidatat non proident.
{{< /note >}}
