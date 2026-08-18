---
title: "Hammer of Thyrion 1.5.9 released"
# Same day as the 1.29b game data post; the time only sets the order between them.
date: 2018-06-06T12:00:00Z
tags: ["release"]
description: "The 1.5.9 engine release, with builds for nine platforms and a long list of sound, renderer and portability work."
---

Version 1.5.9 is out, with source archives plus ready-made builds for Win32, Win64, Mac
OS X, Linux, OS/2, DOS, AROS, AmigaOS and MorphOS. The headline items are SDL support on
OS/2, refreshed copies of every bundled third-party library, and a build that once again
works with the Watcom compiler.

Audio gained tracker music playback through libxmp, and the Amiga side picked up AHI
fixes together with a native MIDI driver. There is also hand-written m68k assembler and
gcc m68k support, a batch of software renderer improvements, server-side optimisations,
a new `viewpos` command, and a fix that stops `config.cfg` being clobbered on write.
Downloads are on the [1.5.9 files
page](https://sourceforge.net/projects/uhexen2/files/Hammer%20of%20Thyrion/1.5.9/).
