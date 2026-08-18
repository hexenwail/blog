---
title: "Pimp my model"
subtitle: "misc_modelpimp — mapper control over model effects that were previously hardcoded"
description: "Digest — Inky's custom entity and engine addition exposing spin, float, glow, dynamic light and the undocumented .mdl effect flags to mappers."
weight: 30
kind_of_trick: "Wheel Of Karma exclusive"
published: "2021-12-29"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-pimp.html"
---

**Category: Wheel Of Karma exclusive. Requires HexenC *and* an engine with his
addition.**

The most ambitious piece of work on the site: not a trick using existing features
but a new entity plus a new engine builtin, released for others to use.

## The problem

Hexen II attaches client-side effects to models — pickups and puzzle pieces float
and spin, mana and torches carry a coloured glow, projectiles trail particles, a
few cast dynamic light. All of it is hardcoded, either as flags baked into the
`.mdl` file or in the engine keyed off the model's filename. A mapper had no way
to change any of it.

## misc_modelpimp

His entity takes a model path and applies effects to **every occurrence of that
model in the map**. The scope point matters and he stresses it: this operates at
model level, not entity level.

The key set, in outline:

- **`model`** — the model to affect, e.g. a path under `models/`.
- **`spawnflags`** — *Spin*, *Float*, *Glow orb* and *Cast light*. Spin and float
  are normally welded together in vanilla behaviour; here they are independent.
  *Cast light* is a client-side dynamic light like the torch artefact, not
  precalculated lighting from light.exe.
- **`flags`** — the hardcoded `.mdl` effect bits (below).
- **`glow_color`** — colour of the glow orb and/or cast light.
- **`abslight`** — alpha for that colour. Default 0.75.
- **`view_ofs`** — offset of the glow from the model origin. This exists because
  vanilla does the same thing to move a torch's glow onto the flame rather than the
  middle of the handle.
- **`health`** — glow orb radius (default 20); **`max_health`** — cast light radius
  (default 200).
- **`style`** — the familiar light-style selector (steady, flicker, pulse and so on),
  here applied to the glow and cast light. His value list usefully marks which
  slots are free for custom styles and which the game reserves from 25 upward.
- **`wait`** — refresh interval, default 0.5s. See below; normally left alone.

## The flag list is the real contribution

`flags` exposes the effect bits that are normally set in a model editor. Inky
points out that these are almost entirely undocumented apart from the handful
inherited from Quake — and that while qME 2.x exposed them all, qME 3.x only
shows the original Quake ones, which is why he re-exposed them through his entity.
**His page carries the complete table of 25 flag values with names, and it is the
best documentation of them that exists.** Go there for it.

Two things worth knowing before you do. Most of the flags are projectile trails,
so they produce nothing on a static model — use them on projectiles, trains, or
(oddly, but it works) monsters. And among the non-trail values, three are
generally useful: *Rotate*, which is the combined float-and-spin behaviour vanilla
uses for pickups; *Holey*, for models whose skin has transparent pixels, which he
used for a fisherman's net; and *Always facing*, which makes a model turn to face
the player like a sprite.

## Showcase mode

Because auditioning 25 effects one at a time is miserable, the entity has a
demonstration mode. Give it a `targetname` and trigger it — from a button, say —
and each activation advances to the next flag and prints its name on screen as a
plaque, cycling from the first trail back around. The `flags` key is ignored while
this is running. Browse, find the one you want, then set it permanently.

## Under the hood — two consequences to plan around

**Shared models.** Because the entity works per model, every entity using that model
is affected — including across classnames. His examples are the ones that will
catch you: glow a `puzzle_piece` and the matching `puzzle_static_piece` glows too,
since they share a model; give ice imps an ice trail and fire imps get it too,
because they are the same model with a different skin. The workaround is to
duplicate the `.mdl` under a new name and pimp only that copy, which needs a HexenC
edit to point the monster at the new file.

**Effects are not saved.** This is the part he is least happy with, and he says so.
The engine saves entity state, but models are not entities and were never meant to
be modified at runtime, so the customisations vanish on map reload or save load.
After weeks of looking for something better, his solution is to make the entity
cyclic — it re-sends its instructions every `wait` seconds in case the map was just
reloaded. He is candid that this is wasted CPU almost always, and explicitly invites
a better implementation. The practical consequence is that `wait` is the entity's
reaction time: with the default of 0.5s, a player entering a map sees the vanilla
effect for half a second before it switches. Lowering it makes the change snappier
and the spam worse.

**Scope is per map.** The effects apply only in the map containing the entity, so a
copy is needed in each map that wants them. He points out the upside: this makes
per-map rule changes easy — his example is a secret map where the torches burn a
different colour than everywhere else in the hub.

## Going further

A closing idea rather than a shipped feature. Showcase mode needs a `targetname`
*and* a trigger; a `targetname` on its own is simply an anchor another entity can
use to find this one. He notes that vanilla Hexen II already does this kind of
reach-in — `trigger_activate` toggles its targets' active state without firing
them, and [`trigger_message_transfer`](../chaining-part-1/) rewrites its targets'
`target` key without firing them. So a custom entity could locate a
`misc_modelpimp` by name and change its values at runtime — switching a trail on,
resizing or recolouring a glow — with the change taking effect within `wait`
seconds, thanks to the cyclic refresh that is otherwise a nuisance. He suggests
temporarily lowering `wait` if you want the change to feel responsive.

The implementation — the entity's HexenC, the `pimpmodel` builtin it calls, and the
`glow_color` field declaration — is published in full on his page. He asks to be
credited, and told about it, if you ship it in your own progs.
