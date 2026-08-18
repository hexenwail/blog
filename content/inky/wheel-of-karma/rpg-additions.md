---
title: "RPG additions"
subtitle: "Dialogue choices in a Hexen II campaign, and the bindings they require"
description: "Digest of Inky's Wheel Of Karma RPG page — how the mod's conversation choices work and which impulse commands to bind."
weight: 10
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/Wheel-Of-Karma-RPG.html"
---

The most visible departure from vanilla Hexen II in [Wheel Of Karma](../) is that
you occasionally talk to people, and what you say matters. This page explains the
mechanism and — importantly, because the mod will not do it for you — the keyboard
setup it needs.

## How a conversation looks

Dialogue is presented on a text panel split by a horizontal rule. Above the rule
is what the character has said to you; below it is a numbered list of replies you
can choose from, up to four.

## Why you have to bind keys yourself

Selection is by keypress, and here the mod runs into the vanilla control scheme:
`1` through `4` are already bound to weapon selection, so they cannot be reused.
The answer is four spare keys bound to `impulse 241` through `impulse 244`, where
the last digit is the answer number. Inky's own choice is `v`, `b`, `n` and `m`,
picked because they sit in a row.

The bindings he recommends entering at the console before you start:

```
bind v "impulse 241"
bind b "impulse 242"
bind n "impulse 243"
bind m "impulse 244"
```

These impulses do nothing outside a dialogue prompt and are ignored by the base
game, so binding them costs you nothing elsewhere.

## What the choices actually do

Choices have consequences — that is the thematic point of a mod named after the
law of karma — but he sets expectations carefully in both directions. No option is
the "correct" one, and no choice can lock you out of completing the campaign.
Equally, the consequences are not on the scale of opening or closing whole
sections of a map. The intent is that replaying and answering differently shows
you something new, not that it forks the campaign.

## The caveat he leads with

He is at pains to say that this is still a Hexen II campaign and not an RPG built
on the Hexen II engine. Dialogue appears at specific scripted moments, not
continuously, and with the campaign shipping incrementally over many maps there
may be long stretches without any. Set the bindings up now, and do not expect a
conversation in the first corridor.
