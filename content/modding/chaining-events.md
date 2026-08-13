---
title: "Chaining events, part 1"
description: "Building multi-step sequences out of buttons, triggers and angle checks — no HexenC required."
weight: 50
updated: "2026-08-13"
verified: "2026-08-13"
verifiedAgainst: "Hexenwail 0.7.9-beta.r9"
authors: ["Editor"]
entities: ["func_button", "func_angletrigger", "func_pressure", "trigger_once", "func_rotating", "func_train_mp"]
tags: ["no-coding", "logic"]
---

At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis. Hexen II gives
you enough brush-entity logic to build real sequences without touching HexenC.

## The primitives

| Entity | Fires when |
|---|---|
| `func_button` | pressed or shot |
| `func_pressure` | weight rests on it |
| `func_angletrigger` | a rotating entity passes an angle |
| `trigger_once` | the player enters the volume, once |

## A three-step chain

Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit:

```ini
{
"classname" "func_button"
"target" "step_2"
"wait" "-1"
}
{
"classname" "func_rotating"
"targetname" "step_2"
"speed" "45"
}
{
"classname" "func_angletrigger"
"angle" "180"
"target" "portcullis_raise"
}
```

Itaque earum rerum hic tenetur a sapiente delectus. Part 2 covers the cases where this
stops being enough and you do have to recompile `progs.dat`.
