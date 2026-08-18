---
title: "Unblock chains - Part 1"
subtitle: "trigger_relay, trigger_message_transfer, and scripting sequences without writing code"
description: "Digest — fanning one trigger out to many with trigger_relay, debugging long sequences, and the state machine trick behind Thysis's zodiac puzzle."
weight: 50
kind_of_trick: "Mapping Academy"
published: "2021-04-12"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-chaining.html"
---

**Category: Mapping Academy, no code required.**

He is careful about the word "scripting" here: throughout this article it means
placing entities and setting keys in TrenchBroom. No HexenC is involved.

The motivating examples are the set pieces in the shipped game — the opening of
Loric's tomb, the statue collapsing in **tower — Tower of the Dark Mage**, the
empty room in **keep1 — Eidolon's Lair** that fills with a mezzanine, stairs and
columns. His standing advice is to decompile Raven's maps with
[Bsp2mph2](../../toolbox/) and study how they were built, because they are usually
less complicated than they look.

## trigger_relay

If you take one thing from the article, this is it. A `trigger_relay` fires its own
targets when it is fired. That is all it does, and it is the mechanism by which one
player action reaches many entities with different target names: point the initial
trigger at one name, give several relays that name, and have each relay target
something different.

Because targets can be pointed at by more than one relay, an entity can take part
in several chains, and relays can cascade into relays indefinitely.

Three keys worth knowing, with a distinction he flags explicitly:

- **`delay`** — seconds to wait after being fired before firing its targets.
- **`wait`** — seconds after firing before it can be fired *again*. Not the same thing.
- **`message`** — optional text printed on screen when it fires.

**Relay versus multiple.** Anything a `trigger_relay` does, a `trigger_multiple`
can also do — the real difference is that `trigger_multiple` is a brush entity
defined by a volume the player enters, while `trigger_relay` is a dimensionless
point entity that cannot be touched and must be fired by something else. You can
press a `trigger_multiple` into relay service by putting it out of reach or setting
its *No touch* spawnflag, but drawing a brush and remembering that flag is exactly
the nuisance the relay saves you.

## Sequences, and how to debug them

The digression on long sequences is the most practically useful part. He works
from the *Portal of Praevus* set piece that switches to a camera, stops the gears,
switches to a second camera, stops the Wheel of Time, and brings in the Jewel of
Buddha on a paddle wheel — five sub-events that must land in order.

The naive approach positions each action on a timeline with `delay` values measured
from the moment the player pulls the lever. That works and is miserable to iterate
on, because testing any part of it means watching the whole thing from the start.

His fix: give each key moment its own `targetname`, creating sub-sequences with
their own zero points. The player still fires only the initial lever and sees one
continuous sequence, but during development a throwaway "debug trigger" can jump
straight to any key moment — so you can iterate on the paddle wheel without
sitting through the gears every time. Relays make this arrangement trivial.

## trigger_message_transfer

An entity he rates as one of Hexen II's genuinely clever additions and hard to grasp
from the name. When fired, it **changes its activator's target to its own target**,
without firing it. It does also support a `message` key, but he argues that is a
secondary feature which unhelpfully drove the naming — the transfer is the point.

The effect is a state machine: pressing the same button produces a different result
each time. His worked example is the Thysis zodiac puzzle. The button fires both
the wheel and a transfer entity A; A rewrites the relay's target to point at B; the
next press fires the wheel and B, then C, and so on until it wraps around. What
each step *does* is unconstrained — a different message, a door opening, or, as in
Wheel Of Karma, a statue rotating so a beam from the Finger of Buddha triggers
something new.

## The caveat, learned the hard way

He praises the Thysis puzzle for making its own repetition legible: the wheel turns
and the message advances, so the player understands they moved one step along a
zodiac with twelve of them and presses again without thinking about it.

That is the risk. A button that does something different each time is unusual in
Hexen II, and if the presentation does not telegraph it, players will not think to
press a button they have already pressed. He reports getting exactly that feedback
on Wheel Of Karma's *The Finger of Buddha* map, and having to add signposting about
multi-use buttons at the player's spawn point — a fix he is candidly unhappy with,
since he would rather the design had explained itself.
