---
title: "Ending on a high note"
subtitle: "Building a proper intermission screen — background, font, and the full table of the twelve hardcoded intermissions"
description: "Digest — the twelve intermission numbers and what each one hardcodes, plus Inky's extended trigger_hub_intermission that makes them all usable."
weight: 140
kind_of_trick: "Mapping Academy"
published: "2020-05-06"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-intermission.html"
---

**Category: Mapping Academy. The optional entity replacement needs HexenC.**

Probably the single most reference-dense page on the site, because it contains a
table of hardcoded engine behaviour that is not documented anywhere else.

Inky's framing: Doom, Heretic and Quake used intermissions for statistics, and the
Hexen games dropped the stats but kept the storytelling screen between hubs. It
closes a narrative arc and it can carry credits — and he cannot understand why
almost no custom map or episode ships with one.

## The ingredients

An intermission is a background image, a wallpaper filling whatever the image does
not cover, some text, the font that text is drawn in, and an intermission number
that selects hardcoded engine behaviour.

**Wallpaper.** There is a default (the brown tile), so this is optional. To change
it: pull `gfx/menu/backtile.lmp` out of `data1/PAK0.PAK` with QuArK, convert it to
BMP with Fimg, edit it, convert back, and place the new file in `gfx/menu`.

**Font.** Also optional, and a bigger decision than it looks: the same font is used
for map names in the console, parts of the menus, and every trigger, door and
puzzle message in the game, so changing it changes the game's whole feel. He
changed it for his own maps, and his reason is a good one — as a non-native English
speaker he found the default red hard to read against busy backgrounds, and by the
time he had parsed a message it had gone.

The font is not a font: it is `gfx/menu/conchars.lmp`, an image divided into 8×8
pixel cells, containing two character sets — the red one and the more legible beige
one used for console output. Fimg cannot open it, because this particular lump
lacks the usual header; the Lmp2Pcx tool handles it instead. He notes that
converting *back* with Fimg works fine once you have a PCX. Because getting a
usable file the first time was painful, he offers both a clean starting copy and
his own high-contrast yellow version for download, asking for credit and a link if
you use it.

## The intermission number table

The number goes in the `level` key of a `trigger_hub_intermission` and must be
between 1 and 12 — anything else breaks. Each value selects a fixed background
image (from `gfx`), a fixed message line in `strings.txt`, and a font:

| # | Fired by in vanilla | Image | Msg # | Font |
|---|---------------------|-------|-------|------|
| 1 | Famine | meso | 396 | Red |
| 2 | Death | egypt | 397 | Red |
| 3 | Pestilence | roman | 398 | Red |
| 4 | War | castle | 399 | Red |
| 5 | Demo ending | castle | 412 | Red |
| 6 | Eidolon | end-1 | 393 | Beige |
| 7 | (same) | end-2 | 394 | Beige |
| 8 | (same) | end-3 | 395 | Beige |
| 9 | ??? | castle | 392 | Beige |
| 10 | Praevus | mpend | 539 | Red |
| 11 | Half PoP | mpmid | 546 | Red |
| 12 | New game | end-3 | 562 | Red |

The font column also determines layout: red text is centred *on* the background
image, beige text is centred *above* it, on the wallpaper.

Four behaviours attach to particular numbers. **6 chains automatically into 7**,
and **7 into 8**, after hardcoded delays — so choosing 6, 7 or 8 gives you a
three-, two- or one-page intermission respectively, while everything outside that
range is single-page. If the player fires during a page, the remaining pages and
any remaining text on the current page are skipped. And **12 runs automatically
when the player starts a new game**, always continuing to the map named `keep1`
whatever the entity says — which he points out you can exploit by naming your own
start map `keep1` rather than fighting it.

One important side effect: running an intermission ends the current map
immediately and **resets all puzzle items and cross-level triggers** before moving
on. That reset is what makes hubs feel like separate missions.

## The entity, and why he replaced it

`trigger_hub_intermission` exists in exactly one place in the shipped game — the
pillar of light at the end of the first *Portal of Praevus* hub, after the yakman
boss — and can only fire intermission 11. Inky's modified version, downloadable
from his page, exposes the rest. Without the HexenC change you are limited to
intermission 11.

His extended key set:

- **`level`** — intermission number 1–12, defaulting to 11 for backward compatibility.
- **`delay`** — minimum seconds before the player can skip. Default 2. His trick:
  set it to `999999` so the page can never be dismissed, turning the intermission
  into a true end screen. His argument is that at the end of a custom campaign the
  story is over, so dropping the player into some arbitrary map is worse than
  leaving them to choose from the menu.
- **`spawnflags`** — 1 keeps puzzle items, 2 keeps cross-level triggers. This is the
  interesting one: suppressing the usual reset converts an inter*mission* into an
  inter*map*, letting you tell a story between two maps without ending the quest.
- **`map`** — the next map. It **must differ from the current map**, or things break —
  which, to his regret, rules out using an intermission as a full-screen narration
  device that returns you where you were.
- **`target`** — the `targetname` of the `info_player_start` to spawn at next.

He supplies the matching `hexen2.fgd` definition so the keys appear properly in
TrenchBroom.

## His recommended shape for a release

The closing argument — that a released map is a gift and intermissions are the
wrapping — turns into a concrete four-step recipe: do **not** ship a shortcut that
starts the game directly, because that forces a player class; let the player start
a new game normally, which gets you intermission 12 as a free introduction; name
your start map `keep1` so it is yours that loads rather than *Eidolon's Lair*; and
close the episode with an intermission on a `999999` delay.
