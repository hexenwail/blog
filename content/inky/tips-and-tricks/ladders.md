---
title: "Stairway to Heaven"
subtitle: "How Hexen II's ladders actually work, and three uses for CLIP brushes"
description: "Digest — the ladder is a disguised staircase; plus clip-brush staircases for climbable rock, and clip brushes to stop players snagging on architecture."
weight: 100
kind_of_trick: "Mapping trick, no code"
published: "2020-05-19"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-ladder.html"
---

**Category: mapping trick, no code required.**

One of the more satisfying articles on the site, because the answer is not what
anyone expects and he documents how he found it.

## The mystery

Hexen II lets you climb ladders — walk straight up or down, and stop partway.
Inky assumed, reasonably, that there was a trigger volume around the ladder
brushwork, the way Quoth later did it for Quake with its
[`trigger_ladder`](https://www.quaddicted.com/webarchive/kell.quaddicted.com/quoth/quoth_tutorial.html#trigger_ladder).
But decompiling the original **village3 — Stables** map with
[Bsp2mph2](../../toolbox/) turned up no such trigger. He eventually cracked it by
doing something he does not normally do — switching TrenchBroom to a 2D view.

## The answer

**A Hexen II ladder is an extremely steep staircase.** It looks vertical but is
not: each step is inset by a single unit from the one below. The player is simply
walking up stairs, which is why the movement is so smooth and why you can stop
halfway.

He points out the visible tell in the original map: at the top of the ladder there
is a small gap between the front faces of the step and the banister that is absent
at the bottom — an artefact of the one-unit-per-step lean. A mapper can hide even
that by sloping the banister to match, since it will still read as vertical.

## Second trick: clip staircases

Many custom-map ladders are visibly sloped, often because their author never knew
the false-vertical trick — and worse, the visible brushes are the only ones there,
so climbing means hopping from rung to rung.

His fix is to build the thing the player actually walks on out of brushes textured
with the special `CLIP` texture: an even, invisible staircase behind the
decorative geometry. Then the visible ladder can be broken, ornamental, whatever
you like — even the banisters can be `func_illusionary` so they cannot snag
anybody — while movement stays smooth.

The numbers matter here, and this is the most reusable fact in the article:

- His own example uses **12-unit steps**.
- **18 units is the maximum** a player can walk up without jumping.
- The step risers must be **strictly vertical**, no matter how the visible slope
  reads to the player. Even a very low step will halt movement if its rise is
  angled. If you need to change the effective slope, adjust the steps' height or
  depth — never their verticality.

The same technique makes rock faces and rubble climbable: build an invisible
staircase inside a slope so the ascent is a walk, as long as the jump is not
where you intended the challenge to be, and as long as the terrain hides the
staircase well enough that the player does not feel like they are levitating.

## Third trick: clip brushes horizontally

The last point is about comfort rather than geometry. Players in a hostile game
hug walls constantly, and a wall lined with slightly protruding columns and salient
corners catches them on every one. His practice is to run clip brushes across
those protrusions so the player is smoothly deflected past the obstruction without
noticing — with low overhead beams made `func_illusionary` for the same reason.
