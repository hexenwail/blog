---
title: "You shall not pass!"
subtitle: "Two ways to let the player through a gap while monsters stay behind"
description: "Digest — the 'cattle guard' ditch that stops walking monsters, and the CLIP func_wall with owner 1 that stops everything except the player."
weight: 80
kind_of_trick: "Mapping trick, no code"
published: "2020-07-26"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-monsterclip.html"
---

**Category: mapping trick, no code required.**

Two techniques for a barrier the player can cross and monsters cannot — one
selective, one absolute.

## The cattle guard

Named after the real thing: a ditch across a road with bars over it that people
and vehicles cross freely but livestock will not, because their hooves would slip
through.

Hexen II's walking monsters — golems, archers — behave the same way. They refuse
to advance if they believe they might fall, and the ditch that convinces them can
be small enough that the player crosses it without registering it, and hidden
entirely by a `func_illusionary` bridging the two sides so the floor looks
continuous. Inky's starting figure is **16 × 16 units** of width and depth,
adjusted to taste.

The limitation is also the feature: it only affects walking monsters. Flying,
swimming and teleporting monsters ignore it completely, which makes it a useful
*selective* barrier when you want to filter by movement type.

## The CLIP wall owned by the player

For a barrier nothing but the player can pass, the construction is shorter. Make a
`func_wall`, texture it with the hardcoded `CLIP` texture so it is invisible but
solid, and set its `owner` property to **1**.

The reasoning: entity 1 is always the player, and an entity and its owner do not
collide with each other. This is the same mechanism the game uses so that
projectiles a player fires do not immediately hit the player who fired them.
Setting the player as the wall's owner therefore makes the wall solid to
everything except the player.

He notes the obvious constraint — this assumes a single-player map with exactly
one player entity — and points at two deeper write-ups by Preach for the technical
background: a
[Func_Msgboard post](http://www.celephais.net/board/view_thread.php?id=37116&start=107&end=107#107)
and a [Tome of Preach article on selective
clipping](https://tomeofpreach.wordpress.com/2015/11/18/selective-clipping/).

## His caveat, which is the point of the article

He closes by arguing against using either technique much. Hexen II's monster
movement is already awkward and easily snarled by architecture; constraining it
further produces behaviour the player can see is wrong, with no visible reason for
it. His example is the golem that stops advancing and punches the air toward a
player it will not walk to, which just looks broken.

His preference is to remove the need instead — design the architecture so the
monster has no reason to go there, or arrange things so a monster wandering in
does no harm. He points at his own solution for keeping monsters from colliding
with puzzle pieces, in [Ticket to Ride](../trains/), as an example of the latter.
