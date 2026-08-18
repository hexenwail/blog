---
title: "Toolbox"
subtitle: "The programs Inky actually uses to build Hexen II maps"
description: "Digest of Inky's toolbox page — the editor, compiler, model and image tools he relies on, with links to each."
icon: "tool"
weight: 70
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/toolbox.html"
---

A working mapper's kit list. The value of this page is that it is not a survey of
everything available — it is the specific set of programs one person reaches for,
with a sentence or two on what each is *for*, including a couple he dislikes but
keeps installed because nothing else does the job.

## Building the map

**[TrenchBroom](https://kristianduske.com/trenchbroom/)** is his editor of choice
and the one he recommends: full 3D, approachable, actively maintained, and what
most of the community already uses.

**[ericw-tools](https://ericwa.github.io/ericw-tools/)** is the compiler suite he
pairs with it — BSP compilation and light calculation, plus utilities such as
de-fullbrighting textures and skins.

**[QuArK](http://quark.sourceforge.net/)** he is blunt about disliking as a map
editor, but keeps for its side features, which have no single replacement: a PAK
explorer, a model viewer that can edit skins, a texture browser he prefers to
TrenchBroom's, and a WAD builder.

## Reading other people's work

**[Bsp2mph2](http://pa3pyx.dnsalias.org/)** decompiles a BSP back into a `.map`.
He is clear about the quality of the output — leaky, with odd brushes, and every
face turned into its own brush, which is disastrous for compilation. That is not
the point: the result is close enough to the original to open in TrenchBroom and
study, which is far easier than picking through a BSP in QuArK. Because the
author's site has been unmaintained for years, Inky hosts a backup copy on his
own page.

**[MapSearch](../mapsearch/)** — his own tool — covers the structural queries a
plain text search cannot express.

**[Notepad++](https://notepad-plus-plus.org/)** earns its place for one feature:
multi-file search. He uses it to find every occurrence of an entity or key across
the shipped Hexen II maps and source, which is how much of the [Tips &
Tricks](../tips-and-tricks/) material was worked out. He also writes HexenC in it.

## Models

**[Quake Model Editor (qME)](http://www.quaketastic.com/files/tools/QME%203.1_full%20installed.rar)**
he keeps for operations QuArK cannot do — rotating or mirroring a model, and
moving its centre of gravity.

**[Quake Model Viewer](https://www.moddb.com/games/quake/downloads/quake-1-model-viewer-v050-alpha)**
he prefers for one specific task: identifying animation frame numbers, which is
what you need when scripting cutscenes with animated characters.

## Images, lumps and audio

**[Fimg](https://drive.google.com/drive/folders/1pM92jSChQ5ujZfbzqj0sb1gBX76XkXuZ)**
converts `.lmp` files to and from standard image formats such as BMP. As with
Bsp2mph2, he keeps a local backup because the official location is a Google Drive
folder of uncertain lifespan.

**Lmp2Pcx** is a small command-line companion for one file the above cannot
handle: `conchars.lmp`, which is not laid out like other lump files. He found it
on the [idgames2 archive](http://www.gamers.org/pub/idgames2/) and mirrors a copy.

**[SLADE](http://slade.mancubus.net/)** is his route into older id-lineage games,
for pulling sounds, MIDI tracks and graphics out of Heretic or Hexen.

**Paint Shop Pro 5** — a deliberately ancient choice — is where he edits textures,
model skins and converted lump images.

**[Joshua Skelton's Quake tools](https://joshua.itch.io/quake-tools)** round out
the asset extraction and conversion side.

## Code

**[FTEQCC](http://sourceforge.net/projects/fteqw/files/QCC/V1.00/fteqcc-v100-win32.zip/download)**
is his QuakeC/HexenC compiler. Since Wheel Of Karma involves a lot of code, his
criterion is stability of the resulting `progs.dat`, and this is the compiler he
found most reliable.

{{< note >}}
Several of these links point at pages that were already fragile when he wrote the
list — which is precisely why he mirrors backup copies of Bsp2mph2, Fimg and
Lmp2Pcx himself. If a link here is dead, check his original page for the copy he
saved.
{{< /note >}}
