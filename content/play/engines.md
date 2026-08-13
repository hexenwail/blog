---
title: "Pick an engine"
description: "Hexenwail, uHexen2, FTEQW and the browser ports — what each is for, and how to install it."
weight: 20
updated: "2026-08-13"
verified: "2026-08-13"
---

Nemo enim ipsam voluptatem quia voluptas sit aspernatur. The original executable does not
work well on modern systems. Pick one of these instead.

| Engine | Best for | Renderer | State |
|---|---|---|---|
| **Hexenwail** | Single-player, modern GPUs | GL 4.3 | Active |
| **uHexen2** | Maximum portability, odd platforms | GL / software | Stable |
| **FTEQW** | HexenWorld multiplayer, CSQC mods | GL / Vulkan | Active |
| Browser ports | Trying it without installing | WebGL2 | Experimental |

## Windows

At vero eos et accusamus. Extract the archive, drop `data1` beside the executable, run it.

## Linux

```sh
# distro package, if one exists
sudo apt install uhexen2

# or extract the release archive
tar xf hexenwail-linux-x86_64.tar.gz
```

Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus.

## macOS

Nam libero tempore, cum soluta nobis est eligendi optio. Note the unsigned-binary
quarantine step.

## Where the files go

```
Hexen2/
├── glhexen2            ← the engine
├── data1/
│   ├── pak0.pak
│   └── pak1.pak
└── portals/            ← Portal of Praevus, optional
    └── pak3.pak
```
