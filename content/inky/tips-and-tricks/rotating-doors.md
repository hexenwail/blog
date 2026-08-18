---
title: "Rotating doors"
subtitle: "Setting up func_door_rotating, and knowing when it is the wrong entity"
description: "Digest — origin brushes, spawnflag axes, the angle-in-the-flags-field quirk, and what to use instead when a rotating door cannot do the job."
weight: 70
kind_of_trick: "Mapping Academy"
published: "2020-08-31"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-rotating-door.html"
---

**Category: Mapping Academy.**

A door that swings rather than slides needs its own entity, `func_door_rotating`,
and three pieces of information: an origin to turn about, an axis, and how far to
turn.

## The three settings

**Origin.** Add one extra brush to the entity, made a perfect cube and textured
entirely with the special `ORIGIN` texture. Its centre of gravity becomes the
entity's pivot. The cube is discarded at compile time and never appears in game.
The same technique applies to every rotating entity — `func_rotating`, rotating
trains and so on.

**Axis.** It must be X, Y or Z; oblique axes are not available. Z is the default,
and X or Y are selected with the corresponding spawnflag checkbox.

**Angle.** The number of degrees goes in the entity's `flags` field — which, as he
says, is not where anyone would look for it. Positive and negative values swing
opposite ways.

## It does not have to be a door

Like `func_door`, the entity is really "brushwork that moves when triggered", and
he lists vanilla examples to make the point: the bars blocking the Septimus
portals that open as you approach, the collapsing beams over the lava bridge in
**meso5 — Obelisk of the Moon**, and the swinging blades in **romeric5 — Temple of
Mars**.

The other good use is levers and rotating buttons — there is one in **demo1 —
Blackmarsh**. Doors normally open on proximity, which is too eager for a lever;
the player should have to touch or shoot it. To get button behaviour, give the
`func_door_rotating` a `targetname` and wrap it in a trigger that responds to touch
by default, or to being shot if you give it a `health` value.

## Three things it cannot do

**It cannot spin continuously.** Use `func_rotating` instead — that is what drives
the sails and gears in **demo3 — The Mill**. He draws a precise distinction here:
the Temple of Mars blades *are* `func_door_rotating`, because they repeatedly open
and close rather than travelling continuously in one direction.

**It cannot rotate about more than one axis.** For compound motion — his example is
the lid of Loric's tomb — use a `func_train`.

**It cannot rotate about an oblique axis.** Again `func_train`: set the entity's
`angles` as an x y z direction vector, then use the `path_corner` angles to define
the rotation. He warns this is fiddly and needs patient tweaking, as composing
rotations in 3D always does.
