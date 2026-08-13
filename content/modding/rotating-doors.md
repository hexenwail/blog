---
title: "Rotating doors"
description: "Swinging doors that hinge where you want them to, not where the world origin is."
weight: 30
updated: "2026-08-13"
verified: "2026-08-13"
verifiedAgainst: "Hexenwail 0.7.9-beta.r9"
authors: ["Editor"]
entities: ["func_door_rotating", "func_door", "func_rotating"]
tags: ["no-coding", "brush-entities"]
---

Lorem ipsum dolor sit amet, consectetur adipiscing elit. A `func_door_rotating` swings
about an **origin brush**. Omit the origin brush and it hinges on the world origin, which
sends your chapel doors across the map at 100 degrees per second.

## The origin brush

Sed do eiusmod tempor incididunt ut labore. Make a small brush, texture it entirely with
`origin`, and include it in the selection when you create the entity.

```ini
{
"classname" "func_door_rotating"
"distance" "110"
"speed" "60"
"wait" "4"
"targetname" "chapel_doors"
}
```

## Double doors

Ut enim ad minim veniam. Two entities, one shared `targetname`, `REVERSE` set on one of
them. Do *not* rely on auto-linking — rotating doors do not link the way sliding ones do.

{{< warn >}}
`DOOR_DONT_LINK` exists on `func_door` and does nothing useful here. Duis aute irure dolor
in reprehenderit in voluptate velit esse cillum.
{{< /warn >}}

## Making the swing mean something

Pair with `func_angletrigger` if you want the door's position to gate something else —
covered in [Chaining events, part 1](/modding/chaining-events/).
