---
title: "Features"
description: "What Hammer of Thyrion supports: games, platforms, video, sound, compatibility and tools."
# Not /features/ — that path belongs to hexenworld.com's articles section in
# data/oldlinks.yaml, and its generated redirect page silently overwrites any
# real page built at the same URL.
url: "/engine-features/"
updated: "2026-08-18"
---

## Games

- *Hexen II*, retail.
- The *Hexen II* shareware demo.
- The *Portal of Praevus* mission pack.
- *HexenWorld*, the client/server multiplayer variant.

## Platforms

Supported and built by the project: Linux, FreeBSD, Mac OS X, Windows, AROS, MorphOS,
AmigaOS, DOS and OS/2. Because the portable layer is SDL, it generally builds anywhere
SDL does — QNX and Nokia's Maemo internet tablets are both known to work.

Ports maintained by other people cover AmigaOS4, RISC OS, PalmOS, the GP2X and the
Pandora. See [links](/links/).

The code is correct on both 32-bit and 64-bit systems, and is tested on little-endian
and big-endian machines alike.

## Video and display

- Resolution changes from inside the game, in the OpenGL and software renderers both.
- Quick switching between fullscreen and windowed mode under X11.
- Widescreen support with automatic Hor+ field of view scaling, so a wider monitor shows
  more of the world instead of cropping it.

## Graphics

- Multitexturing.
- Glow effects.
- Brightness and gamma controls.
- Text and HUD size adjustable while playing.
- Translucent, stretchable console.
- Coloured lighting, including external `.lit` files.
- Anisotropic filtering.
- Reworked texture and model caching.

## Compatibility

- Network-compatible with Raven's 1.11 Windows release.
- Loads saved games written by Raven 1.11.
- Runs old `progs.dat` versions, from 1.03 through 1.11 and later.

## Interface and console

- Fullscreen intermission and help screens.
- Mouse wheel support.
- Line editing and tab completion in the console.
- A `maplist` command.
- Deleting saved games without leaving the game.

## Sound and music

- ALSA, OSS and SDL audio drivers on Linux; native sound support on FreeBSD, OpenBSD and
  NetBSD.
- Music from external files: ogg, mp3, opus, flac and wav.
- Tracker music, including mod and umx.
- A working music volume control.

## Unix specifics

Configuration files and saved games are kept in a per-user directory, so the game does
not need a writable install directory and several accounts can share one copy.

## Tools

The HexenC compiler and the mapping utilities are maintained alongside the engine, as
are the HexenWorld server tools: `hwmaster`, `hwmquery`, `hwrcon` and `hwterm`.

## And the rest

Many hundreds of bug fixes and a number of security fixes, accumulated across every
release listed in the [news archive](/news/).
