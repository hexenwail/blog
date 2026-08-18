---
title: "Ticket to Ride"
subtitle: "func_train_mp as a general-purpose entity — 3D models, indestructible props, and safe puzzle-piece spawning"
description: "Digest — station stops, Use origin, the weaponmodel key that turns a train into any .mdl, and a fix for puzzle pieces that fail to spawn and softlock the game."
weight: 90
kind_of_trick: "Mapping trick, no code"
published: "2020-05-22"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-train.html"
---

**Category: mapping trick, no code required.**

The most consequential article in the collection, because it ends with a fix for a
bug that can make a map unfinishable.

His thesis is that trains are Hexen II's most versatile brush entity: with a
trigger and some patience, a train can imitate `breakable_brush`,
`func_angletrigger`, `func_button`, `func_door`, `func_door_rotating`,
`func_rotating` or `func_wall`. *Portal of Praevus* made this more true by
upgrading `func_train` into `func_train_mp`. The article assumes you know the
basics and covers what lies past them.

## Station stops

`func_train_mp` accepts a `wait` value of **-3**, which makes the train stop at
every `path_corner` and resume only when triggered again. That converts a train
from a two-point shuttle into a route with as many stops as you like. It works
together with spawnflag 2, and interacts with the `path_corner` entities' own
`wait` values, so expect some trial and error.

## Use origin

Spawnflag **64**, and he calls it life-changing. Classic trains are positioned by
the minimum corner of their bounding box — the corner with the lowest x, y and z —
which governs where the train spawns and how it travels, and is awkward to reason
about. *Use origin* lets you supply an origin brush instead (a small cube textured
`ORIGIN`, whose centre becomes the reference point), so you decide what the train
is measured from.

## Trains as 3D models

The key insight of the article: the **`weaponmodel`** key. Give it the path and
filename of a `.mdl` and the train's brushes become invisible while remaining solid
— representing the volume the model occupies, since models are not solid — and the
model is drawn at the train's origin, which is why the origin brush becomes
mandatory.

*Portal of Praevus* uses this repeatedly: the two halves of the opening Buddha
statue in **tibet3 — The False Temple**, the prayer wheels in **tibet4 — Courtyards
of Tsok**, and the cauldron in the hidden lab in **keep3 — The Duke's Keep**.

Anything in the PAK files is fair game — not just what TrenchBroom lists in the
entity browser, but weapons, projectiles, puzzle pieces — as are your own custom
models. The limitation is animation: models whose frames are driven programmatically
(monsters) will not animate and you cannot pick a frame without HexenC changes, so
monsters only work as statues. Models that are static, or that animate internally
like spinning items and waving flags, work fine.

One gotcha he flags: if the train's path rotates, only the invisible brushes rotate
by default. Set spawnflag **32** (*Angle match*) to make the model rotate with them.

## Two consequences worth having

**New objects with no code.** Official entities are declared in HexenC with a spawn
function that precaches their model. A `func_train_mp` with a `weaponmodel`
precaches automatically — so you can introduce a model the game has never heard of
without writing any code. The train need not move at all: give it the same `target`
and `targetname` and skip the `path_corner`, and it simply stands where you placed
it, acting as a host entity for the model.

**Indestructible props.** Players break everything in a Hexen game, on the reasonable
assumption that secrets are behind it. Inky had statues carrying a puzzle in Wheel
Of Karma that would have been ruined by being destroyed. Since a train is not a
`breakable_brush`, it cannot be broken — it only explodes if configured to — while
using the same model and looking identical. And it can move.

## Moving puzzle pieces

A `puzzle_static_piece` is, as the name says, static. Using a train instead — moving
into place at an absurd speed so it appears to teleport — lets you stage things like
a hatch opening, a cart emerging to receive the piece, and the cart carrying it back
into the wall. He is realistic that this needs careful timing and does not suit
every piece.

## Safe spawning puzzle pieces — the important part

This section describes a real softlock and how to avoid it.

First, the correction he makes to his own previous point: a `puzzle_piece` (unlike
`puzzle_static_piece`) *can* be moved by a brush entity — **tibet5 — Temple of
Kalachakra** does this, pushing the Jewel of Buddha out of a wall with a paddle
wheel. But a `puzzle_piece` standing in for a static one can be picked up again by
the player, which you would need to prevent.

Then the real problem. **A `puzzle_piece` will not spawn if there is not enough
free space for it.** That is harmless for pieces present at map start in a clear
area. It is dangerous for pieces created part-way through a puzzle — as with the
Bones of Loric and the Mithril Transmutation in **demo1 — Blackmarsh**. If a
monster happens to be standing too close at the moment the piece should appear,
the piece never spawns. There is no message and no visible failure. The puzzle
becomes unsolvable, the game becomes unfinishable, and the player will overwrite
their saves and spend hours hunting a piece that does not exist before giving up
and blaming the mapper.

His workaround uses a train and a little-known spawnflag:

1. Where the piece should appear, spawn a **train carrying the piece's model**
   instead of the real piece. Trains ignore monsters and geometry entirely, so they
   always arrive.
2. Hide the **actual `puzzle_piece`** somewhere safe nearby — under the floor, where
   monsters cannot reach.
3. Put an initially-disabled `trigger_once` around the apparent spawn point,
   enabled at the same moment. When the player touches it, the train vanishes
   instantly and the real piece is granted via **Auto get**.

**Auto get** is `puzzle_piece` spawnflag **4**, and he suspects almost nobody knows
it exists: it adds the piece to the player's inventory without the player having to
touch or even see it. The one constraint is range — the player must be within
**200 units** of the hidden piece when the trigger fires, or Auto get does nothing.
Done properly the player gets the usual screen flash and possession message and
notices nothing unusual.
