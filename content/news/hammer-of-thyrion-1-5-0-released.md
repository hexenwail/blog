---
title: "Hammer of Thyrion 1.5.0 released"
date: 2011-09-19
tags: ["release"]
description: "A major release: external music, a new sound layer, a large memory corruption fix, and the move from CVS to SVN."
---

1.5.0 is the biggest release in a long while. Music can now be played from external ogg,
mp3 and wav files through a new streaming interface, sitting on top of a rewritten sound
layer with libtimidity imported into the tree.

The fix list is long: a memory corruption spanning several zones, load and save bugs,
items that failed to appear, artifacts that did not persist, respawning on nightmare
skill, software renderer crashes and OpenGL z-fighting. New arrivals include
`sys_throttle`, support for more joystick axes, a pile of HexenC gameplay corrections,
external entity files, and the `h2patch` tool. Development has also moved from CVS to
SVN. Engine 1.23, HexenWorld 0.23, gamecode 1.20.
