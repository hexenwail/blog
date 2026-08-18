---
title: "Whoso pulleth out this sword of this stone"
subtitle: "Controlling what a destroyed object drops — items, puzzle pieces, and the sword-in-the-stone weapon hack"
description: "Digest — the cnt_ reward keys and their quirks, dropping puzzle pieces, and an elaborate rig for revealing a weapon inside a breakable brush."
weight: 10
kind_of_trick: "Mapping trick, no code"
published: "2022-01-08"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-excalibur.html"
---

**Category: mapping trick, no code required.**

The newest article on the site, and the one with the most intricate construction in
it. Breaking things for loot is core to Hexen II, and this covers how to decide
what comes out.

## Items and artefacts

The headline fact is broader than most people realise: the drop keys that chests
and pots use are available on **practically any entity that can be destroyed**,
monsters included. His rule of thumb — if it can be destroyed, it can drop
something.

The `cnt_` family covers the artefacts: blast, cube of force, flight, glyph, health
and mana boosts, haste, invincibility, invisibility, polymorph, summon, teleport,
tome and torch. Each takes the number of that artefact to grant. Two behaviours
worth knowing: only one model ever spawns, so any value above 1 produces a
**backpack** instead of the artefact's own model; and the game applies internal
caps on inventory quantities, so large numbers are pointless.

`bluemana` and `greenmana` grant mana — **at most one of the two** on a given
entity, with any value you like, though again hardcoded limits may trim it, and the
model does not change size. `spawn_health` always produces exactly one standard
crystal vial worth 10 HP regardless of the value you set.

The four `armor_*` keys are the interesting failure. They need a value of exactly
**20** for anything to spawn at all — and then the reward is fake. Inky documents
that the armour model appears but grants the player nothing, because vanilla HexenC
determines the AC from the armour's classname, which is never set on a dynamically
spawned one. It looks like a reward and is not.

Two more points. When you set these keys on a **monster**, they override its normal
random drop, so you get exactly what you specified. And the trap: if the destroyed
thing is a **brush entity**, the reward spawns at the entity's origin — which by
default is the world origin, potentially somewhere else entirely or outside the
map. The fix is the usual one, an origin brush (a small cube textured `ORIGIN`,
discarded at compile time) to put the origin where you want it.

## Puzzle pieces as rewards

A destroyed entity can drop a puzzle piece instead, by setting `puzzle_id` to the
piece you want. His page carries the reference chart of every vanilla and *Portal
of Praevus* piece with its id.

Three warnings attach:

- For an **object or monster**, another unreachable copy of that piece must be hidden
  somewhere in the map so the engine precaches its model.
- Also set `puzzle_piece_1` to a friendly name, or the pickup message is left
  hanging mid-sentence.
- For a **brush entity**, `puzzle_id` does not work at all. Target a `puzzle_piece`
  with the *Spawn* spawnflag set instead — with the drawback that the spawn point is
  fixed at mapping time and will not follow a moving entity, so this only suits
  static geometry or a destruction point you know in advance.

He cross-references his [puzzle piece section](../hubs/) for keeping the names
consistent, which matters because of the `puzzles.txt` trap documented there.

## The weapon in the stone

The title trick, and he cheerfully describes it as hacky.

**The obstacle** he calls the collision issue: a weapon — or any pickup — will not
spawn into space already occupied by something solid. So a weapon cannot simply sit
inside the rock that hides it.

**The idea:** while the rock stands, the real weapon waits hidden in a pit below,
and a non-solid decoy occupies the visible position. When the rock breaks, there is
no longer anything to collide with, and a door lifts the real weapon into reach.

The rig, as he documents it:

- A **`breakable_brush`** obelisk over a hole, with low `health` and a `target`
  pointing at the door.
- A thin **`func_door`** at the bottom of the hole set to rise (`angle` -1) with a
  negative `lip` so it travels far enough to push the weapon's hitbox just proud of
  floor level, and `wait` -1 so it stays up.
- The real **weapon** sitting on that door, with `effects` **128** to make it
  invisible — so the real and decoy weapons are never both visible — and a
  `killtarget` pointing at the decoy, so picking the real one up deletes the fake.
  The pit must be deep enough that the hitbox does not protrude while down, and
  wide enough for the weapon to spawn but narrow enough that the player cannot fall
  in; he uses 32×32 on an 8-unit grid.
- A **`func_illusionary`** textured to match the surrounding floor, hiding the hole.
  Being non-solid, it does not trigger the collision issue.
- The decoy inside the obelisk: a **`func_rotating_movechain`**.

## Why func_rotating_movechain

The most interesting piece of engine archaeology in the article.
`func_rotating_movechain` is an unused entity left in the code — apparently intended
to slave one entity's rotation to another's — that Raven never shipped in a map.

What makes it useful is that it renders whatever model you name in its `model` key.
Inky uses the third weapon model for player class 1, and the trick is that **it works
for every class**: setting `flags` to **2097152** — internally `FL_CLASS_DEPENDENT` —
makes the engine rewrite the trailing class digit of the model name at runtime, so
each player sees their own class's weapon. Precaching is handled because the real
weapon is present in the map anyway. Because of its master/slave heritage the entity
also requires a `netname` shared with another entity, which is why the real weapon
carries the same one.

## Limitations he is explicit about

- It needs fixed brushwork, so monsters and moving brush entities cannot reveal
  weapons this way.
- Each class's weapon model sits differently relative to the origin, so a rock tall
  enough to conceal one class's weapon may expose another's. **Test with every
  class.**
- The decoy uses the standard weapon model, which floats and spins — so it has to be
  hidden entirely inside the breakable object, since something genuinely embedded in
  stone would not be rotating in mid-air.

He notes that a properly static weapon half-emerging from a rock or frozen in ice —
as in his own Winnowing Pass map — is achievable, but needs model work and HexenC
changes beyond this article's scope.
