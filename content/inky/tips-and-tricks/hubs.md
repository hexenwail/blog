---
title: "Hubs not drubs"
subtitle: "Connecting maps into an episode — puzzle pieces, cross-level triggers, and what actually makes a hub cohere"
description: "Digest — trigger_changelevel routing, the full puzzle_piece reference including the puzzles.txt trap, the eight cross-level flags, and advice on naming maps."
weight: 60
kind_of_trick: "Mapping Academy"
published: "2021-02-20"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-hub.html"
---

**Category: Mapping Academy, no code required.**

If you read only one article from this collection, read this one. The hub is what
distinguishes the Hexen series from Doom and Quake — an episode is a connected
sub-adventure rather than a sequence of standalone levels — and almost everything
else in the collection assumes you understand how state moves between maps.

## Moving between maps

The minimum is two entities: a `trigger_changelevel` in the origin map, with its
`map` key set to the destination's BSP filename without the extension, and an
`info_player_start` in the destination.

Backtracking is just the same arrangement in the opposite direction — hubs are not
forward-only, and Hexen II players expect to move freely.

For multiple entry points into one map, give each `info_player_start` a distinct
`targetname` and set the `target` key of each incoming `trigger_changelevel` to the
one it should use. This works identically regardless of which map, or how many,
route into the destination.

## Puzzle pieces

A puzzle piece is Hexen II's key, with the advantage that it can be any artefact —
bones, a potion, a lens, a sceptre — which makes for more interesting puzzles than
coloured keycards.

**What can require one.** `func_door`, `func_door_rotating`, `func_door_secret`,
`trigger_activate`, `trigger_multiple` and `trigger_once`. Each names its
requirement in `puzzle_piece_1` — and can demand up to four via `puzzle_piece_1`
through `puzzle_piece_4`. Raven never used more than one, but Inky confirms the
feature works: he used it in Wheel Of Karma's *Ice Lake* for a net-and-catch
fisherman's puzzle.

Three related options on those entities:

- **`no_puzzle_msg`** — the message shown while the player lacks the piece.
- **"Remove puzzle" spawnflag** — whether using the entity consumes the piece. His
  advice is to leave it set unless one piece deliberately opens several things, and
  he is sceptical of multi-use pieces generally: a piece that lingers in the
  inventory after it is spent causes lasting confusion.
- **"No puzzle" spawnflag** — fires only if the player does *not* have the piece.
  Unused in the shipped game; he notes it as an interesting idea, since a missing
  key could spring a trap rather than merely fail to open a door.

**The piece itself** is always a `puzzle_piece` entity whatever it depicts. Its
`puzzle_id` selects the model (name only, no path or `.mdl` extension) and its
`netname` is the friendly name shown when the player picks it up — written directly
rather than as a `strings.txt` line number, so you are free to invent your own
names. His page includes a chart of every vanilla and *Portal of Praevus* puzzle
piece with its `puzzle_id`.

**The trap, and it is a good one.** Hexen II has a little-known Info/Frags display
on the `Q` key that lists the player's puzzle pieces *by name*, unlike the HUD which
shows only pictures. Those names do **not** come from `netname` — they come from
`puzzles.txt`. So custom names on stock pieces, or any custom piece at all, need a
matching `puzzles.txt` shipped with the mod. The format is simple: a first line
giving the number of lines that follow, then one `puzzle_id` and name per line
separated by a space, in any order.

He supplies an `hexen2.fgd` definition for `puzzle_piece` that uses a computed model
path, so changing `puzzle_id` updates the model shown in TrenchBroom immediately.

**Spawnflags.** *Spawn* means the piece does not exist at map start and appears only
when triggered — as with the Bones of Loric and the Mithril Transmutation in
**demo1 — Blackmarsh**. *Floating* he flags honestly as unknown. *Auto get* grants
the piece by triggering rather than touching, which is unused in vanilla but
essential to some of his own constructions, with the same 200-unit range limit that
matters in [Ticket to Ride](../trains/).

**Making your own** needs a `.mdl`, plus a 26×26 pixel inventory icon converted to
`.lmp` with Fimg. Both files share one lowercase name — which becomes the
`puzzle_id` — with the model in `models/puzzle` and the icon in `gfx/puzzle`. His
method for the icon is to view the model in QuArK against black, screenshot it and
scale it down. And update `puzzles.txt`.

**`puzzle_static_piece`** is the decorative counterpart, for showing a piece the
player has delivered to its destination — the Mazaeran skulls, the Egyptian crowns.
The mechanism behind those moments: the player trips a piece-dependent
`trigger_once` that removes the piece from inventory and triggers the static piece
to appear in place.

He also clarifies that puzzle pieces live in their own inventory, separate from
flasks, craters and glyphs — and, crucially, that both inventories follow the player
across maps. That is what makes pieces the most natural way to build a cross-map
puzzle.

## Cross-level triggers

The other mechanism, for when an action in one map should change another map with
no item involved. Place a `trigger_crosslevel` in the first map with one of its
*Trigger 1*–*Trigger 8* spawnflags set, and a `trigger_crosslevel_target` in the
second with the same flag set. Firing the first sets a server flag; on entering any
map, the game fires every `trigger_crosslevel_target` whose flag is already set.

Two consequences he is careful about. Because these are server flags rather than
addressed messages, **you cannot target a specific map** — every matching target in
the episode will fire. Any `map` key you see on these entities in an FGD is wrong
and does nothing.

And there are only **eight flags**. Enough for most maps, tight if you lean on the
mechanism heavily or attempt cross-episode triggers (which are not a vanilla
feature — see [Ending on a high note](../intermissions/)). He notes that Raven
apparently coded a way to reset the flags via a `trigger_check` entity, but it is
strange, was never used in the game, and may be a discarded idea, so he advises
against relying on it and using puzzle pieces for the extra capacity instead.

## What actually makes an episode

The closing section is design rather than mechanics, and is the most interesting
part. He argues that Doom and Heretic episodes cohere without any hub system, through
shared themes, textures, monsters and escalating difficulty — and that Hexen II's
episodes have strong identities for the same reasons: a shared continent, a
consistent visual language, distinctive portals per region (skull doors in
Blackmarsh, trapezoid doors in Mazaera), region-specific monsters, and a
sub-narrative told through plaques and chained puzzles. Each also has a gameplay
flavour: interlocking puzzles in Blackmarsh, platforming in Mazaera, direct puzzles
and hidden rewards in Septimus.

His warning is that connecting maps with portals does not by itself produce an
episode — you can just as easily get a hodgepodge. If your maps genuinely are
heterogeneous, he suggests Hexen II's own solution: build the storyline around
items gathered from very different parts of the world, which is what let one game
hold medieval Europe, Egypt, Mesoamerica and Greece together.

## Map names

A short closing note with a sharp example. Map names should point at the map's most
memorable landmark — The Mill, Stables, Reflecting Pool — so players can navigate by
them. Thysis fails this: a series of similar-looking, equally labyrinthine temples
with interchangeable proper nouns. He suggests that simply renaming them for what
they contain would have helped enormously. Proper nouns are not the problem;
over-reliance on them is, and mixing the two (his example being a village name
prefixed with "The Village of") gets you both flavour and legibility.
