---
title: "Installing mods and map packs"
description: "Where files go, what -game does, and why a mod that 'does nothing' is in the wrong folder."
weight: 50
updated: "2026-08-13"
verified: "2026-08-13"
---

Lorem ipsum dolor sit amet. A mod is a folder next to `data1`. The engine loads it when you
pass `-game <foldername>`.

```
Hexen2/
├── data1/
├── portals/
└── privhold/          ← the mod
    ├── maps/
    └── progs.dat
```

```sh
./glhexen2 -game privhold
```

## Why nothing happened

Sed do eiusmod tempor incididunt:

- You extracted *into* `data1` instead of beside it.
- The archive had a nested folder, so you have `privhold/privhold/maps/`.
- The mod is a single `.bsp` and needs `map <name>` from the console, not `-game`.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.
