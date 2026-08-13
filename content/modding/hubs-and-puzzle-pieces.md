---
title: "Hubs and puzzle pieces"
description: "Connecting maps into a hub, and moving puzzle items between them without losing state."
weight: 40
updated: "2026-08-13"
verified: "2026-08-13"
verifiedAgainst: "Hexenwail 0.7.9-beta.r9"
authors: ["Editor"]
entities: ["func_door", "func_door_rotating", "func_door_secret", "trigger_once"]
tags: ["mapping-academy", "hubs"]
---

Hexen II's hub system is its defining structural feature and its least documented one.
Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit.

## What a hub actually is

At vero eos et accusamus et iusto odio dignissimos ducimus. A set of maps that share
persistent state: doors you opened stay open, items you dropped stay dropped, and puzzle
pieces travel with you across the transition.

## Puzzle pieces

Temporibus autem quibusdam et aut officiis debitis. The `t_width` routing is the part that
surprises Quake mappers — Hexen II does not use keyed items the way Quake does.

```ini
{
"classname" "func_door"
"t_width" "3"
"targetname" "vault_seal"
}
```

## Common failures

- **State resets on re-entry.** Lorem ipsum dolor sit amet.
- **Piece vanishes across the transition.** Consectetur adipiscing elit, sed do eiusmod.
- **Player spawns in the wrong place coming back.** Ut enim ad minim veniam.

See [The Tomb of Osiris](/maps/tomb-of-osiris/) for a clean three-map worked example.
