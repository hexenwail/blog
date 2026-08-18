---
title: "Follow the Yellow Brick Road"
subtitle: "Using Portal of Praevus's trigger_objective properly, and the lifecycle rule nobody thinks about"
description: "Digest — how trigger_objective works, its undocumented quirks, and a critique of how Raven used it, with rules for doing better."
weight: 130
kind_of_trick: "Mapping Academy"
published: "2020-05-07"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-objective.html"
---

**Category: Mapping Academy.**

Half reference page, half design essay, and the most opinionated article on the
site. It is also the one with the most immediately actionable rules.

## The problem it addresses

The standing complaint about Hexen II is that you lose the thread: objective A
needs key C, which is in map D, which opens with puzzle piece E. Inky argues the
criticism lands hardest on the Thysis and Blackmarsh hubs, and that a second factor
makes it worse — both are labyrinthine and visually homogeneous, so even a player
who remembers what to do can spend a quarter of an hour finding where to do it.

His stated motto for mappers: **never lost, never stuck**.

*Never lost* is level design — enough variety and enough landmarks that the player
keeps their bearings. He notes that deliberate disorientation can work, citing
Quake's *Azure Agony*, but warns that the likely outcome of attempting it is an
undifferentiated maze, and that Hexen II's audience and pacing are not Quake's
anyway. Rather than expand, he points at the literature, specifically Sjoerd De
Jong's *[The Hows and Whys of Level
Design](http://www.hourences.com/product/the-hows-and-whys-of-level-design-2/)* —
of which he mirrors a copy on his page against link rot.

*Never stuck* is where the entity comes in. Raven added `trigger_objective` in
*Portal of Praevus* in response to exactly this criticism: an in-game to-do list
the player checks with the `o` key.

## How trigger_objective works

The reference table is the part to bookmark:

- **`targetname`** — it is a point entity with no touch function, so something else
  must fire it.
- **`frags`** — an integer selecting a message line from `infolist.txt` in the mod
  root. The trap: the index is **zero-based**, so use the line number minus one.
- **`spawnflags`** — 1 adds the objective to the list, 2 removes it.
- **`target`** — **not supported**, despite TrenchBroom offering it. He recommends
  editing the `Target` base out of the entity's definition in `Hexen2.fgd` so the
  editor stops advertising a key that does nothing.

Two behaviours worth knowing. Objectives are always displayed in `frags` order
regardless of the order the player acquired them, so `infolist.txt` must be
written in the logical order of the quest. And every objective needs **two**
entities — one to switch it on, one to switch it off — because an objective that
is added and never cleared is worse than none.

## The lifecycle rule

He identifies the real difficulty as not the entity but the state machine around
it, and gives a worked example: an objective to fetch a key, and a later objective
that depends on it. The key objective should appear when the player reads the
relevant plaque or reaches the locked gate — but if they already found the key,
neither of those should add it any more, because it is already done.

His rule: **when an objective is completed, fire its OFF trigger and also disable
its ON trigger**, in case the ON trigger has not run yet. One relief — an ON
`trigger_objective` behaves like a `trigger_once` and removes itself after firing,
so repeat activation is not something you have to handle.

## The critique, and the three syndromes

He is blunt that the feature arrived too late to help the hubs that needed it, and
that *Praevus* itself uses it poorly — which he turns into named anti-patterns:

- **Village Well syndrome** — an objective that introduces information the player has
  not encountered yet, referring to places they have never heard of. Objectives
  should *remind*; introducing new information is the plaque entity's job.
- **Get the Sphere syndrome** — objectives stating the self-evident, for items sitting
  in plain view in an unmistakable room.
- **Thaumaturgical Conveyance syndrome** — naming a destination with a term that
  appears nowhere in the level, so the reminder cannot be acted on.

His conclusion is that the entity is good and underused, and that bothering with it
is a signal to the player that you cared about details — the same argument he makes
for [intermission screens](../intermissions/).
