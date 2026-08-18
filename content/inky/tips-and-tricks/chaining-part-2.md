---
title: "Unblock chains - Part 2"
subtitle: "Multi-condition triggers — ordered counters, runtime-assigned combinations, and trigger_check"
description: "Digest — trigger_counter's ordered mode and its count-minus-one quirk, trigger_combination_assign, and the trigger_check family including func_pressure and func_angletrigger."
weight: 20
kind_of_trick: "Mapping Academy"
published: "2022-01-03"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-chaining2.html"
---

**Category: Mapping Academy, no code required.**

Where [Part 1](../chaining-part-1/) covered one action fanning out into many
events, this takes the opposite problem: triggers that wait for several conditions
before doing anything. That is what turns a press-the-button moment into a puzzle.

His standing advice repeats here — replay Hexen II, find puzzles you like, and
decompile Raven's maps with [Bsp2mph2](../../toolbox/) to see how they were built.

## trigger_counter, basic use

Set a `count`, point that many buttons at it, and you get the familiar "only N more
to go" progression ending in a completion message — silently, if you set the *No
message* spawnflag.

**The beginner's mistake** he calls out: a `trigger_counter` counts how many times
it was fired, not *what* fired it. Without precautions the player can press one
button repeatedly to satisfy a three-button sequence, leaving the other two
pointless. Set `wait` to **-1** on each button so it can only fire once. Nothing
breaks otherwise — the map just feels broken.

## Ordered counters

The more interesting mode requires the buttons to be pressed in a specific order:

1. Set the counter's **Ordered** spawnflag.
2. Give each firing button an order number in its `aflag` key — 1, 2, 3.
3. Give the counter and all its buttons the **same `netname`**.
4. Set `count` to the number of buttons **minus one**.

That last step is the trap, and Inky flags it as genuinely odd and undocumented: the
off-by-one applies to ordered counters only.

**Non-sequential orders.** If you want the required order to be something other than
ascending, there are two routes. Either swap the `aflag` values between the buttons
— simple, but the visual and logical orders no longer match, which makes your own
map harder to read — or leave `aflag` alone and set the counter's `mangle` key to
the desired sequence in vector syntax. Since `mangle` is a vector it holds three
values, so this only works for counters fired up to three times.

He points at **egypt5 — Pyramid of Anubis**, where a pharaoh bas-relief and the
panels beside it are buttons feeding an ordered counter that opens a trapdoor, with
deliberately mismatched visual and logical order.

## trigger_combination_assign

The `mangle` approach has one considerable advantage over swapping `aflag` values:
it can be **changed at runtime**, by a `trigger_combination_assign` targeting the
counter.

His illustration is a room with three buttons reachable through three archways, each
archway carrying an invisible assign entity that sets a different required order. The
combination the player needs depends on how they entered. Applied to a puzzle that
can be attempted more than once, or on a replay, that semi-randomness means the
player's memory of last time does not help and the puzzle is fresh again.

Note that the assign entity changes the required order but does **not** fire the
counter.

## Returning to the initial state

Two facilities, both of which he advises treating with suspicion:

- The counter's **Always return** spawnflag pops the firing buttons back to unpressed
  even after a successful sequence — by default they stay pressed. Only meaningful
  when buttons are doing the firing.
- **`trigger_counter_reset`** resets a counter to its untouched state, which the
  vanilla code comments describe as being for counters that must count more than
  once where the counting may be interrupted.

His caution: in the entire shipped game, the only use of either is the notorious
Thysis eye/chessboard puzzle — which is well known to be buggy and which he suggests
staying clear of as a model.

## The Baths of Demetrius as a worked example

He rates **romeric4 — Baths of Demetrius** highly, both as a map and as the best
demonstration of an advanced counter. Its elemental-button puzzle reveals the
Diamond Scepter, and teleports in a skull wizard as a penalty for a wrong
combination. Dissected, it uses: ordered mode with `count` set to 3 for four
buttons, all five entities sharing a `netname`, a success message in `message` and a
failure message in `msg2`, a **`puzzle_id`** holding the name of a target to fire on
failure (the monster spawner), buttons ordered by `aflag` with `wait` -1, and
automatic return of the buttons to unpressed after a failed attempt so the player
can try again.

## trigger_check

A looser relative of the counter. Firing entities all share a `netname` with the
trigger, as with ordered counters, but from there it diverges:

- There is **no `count`** — the trigger discovers its firing entities from the shared
  `netname`.
- Because it is not counting, it is common to see a single firing entity per
  `trigger_check`.

Instead of counting, it requires every firing entity to be in an "OK" state, and
fires its own targets only when all of them are. What counts as OK depends on the
entity type.

**`func_pressure`** is a pressure plate with a `mass` key; it is OK once the combined
mass resting on it meets that value, potentially from several objects. The only
vanilla instances are a pair in a vault in **egypt5 — Pyramid of Anubis**, both
feeding one `trigger_check`, so the way opens only when both plates are loaded.

**`func_angletrigger`** is a rotating button that turns by `cnt` degrees per
activation and becomes OK when it reaches the absolute angle named in its `mangle`.
Most of Raven's uses of `trigger_check` involve these: the sundial in **egypt6 —
Temple of Light**; the wheels of ages in **egypt2 — Ancient Temple of Nefertum** and
**egypt3 — Temple of Nefertum**, each needing alignment to a particular
constellation; and three of them on the lower floor of the Baths of Demetrius
puzzle, gating the button that frees the barrels.

He notes in passing that the Nefertum puzzle adds a second verification layer with a
[`trigger_crosslevel` pair](../hubs/) to confirm both wheels are aligned before the
crown spawns — and that the game has the Upper and Lower Egypt crowns labelled the
wrong way round throughout.

**Ordinary triggers** can also become OK, apparently just by being fired, though he
describes the relevant code as messy. Raven's only example is a `trigger_multiple` in
**tibet3 — The False Temple**, where the Staff of Emperor Lo Pan participates in a
trapdoor mechanism — and he warns it is a small part of a large, complex setup, so
this route will need trial and error.

## The closing insight

The subtle point, and the reason `trigger_check` exists at all even with one firing
entity: these entities can fire their targets **while not being OK**, and generally
do not consult their own OK state when acting. Firing targets and being OK are
related but distinct, and evaluating OK-ness is `trigger_check`'s job alone.

His practical advice, drawn from observing that Raven did it this way every time:
when an entity points at a `trigger_check`, make that the **only** thing it points
at unless you are certain of what you are doing.
