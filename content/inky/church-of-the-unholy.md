---
title: "Church Of The Unholy"
subtitle: "Author's insights on his first Quake release — a tribute to Sandy Petersen's Episode 4"
description: "Digest of Inky's design commentary on Church Of The Unholy: its Episode 4 homages, deliberate reuse of id's source maps, the machinima Mass, and the FTE-only decision."
icon: "quake"
weight: 20
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/quake-church-of-the-unholy-insights.html"
---

A very long author's commentary on his first Quake project, written because
several people asked him to explain how he builds maps — and because, as he notes,
mappers rarely do write this sort of thing down. The mod is on
[ModDB](https://www.moddb.com/mods/church-of-the-unholy/).

It is worth reading in full if you care about map design; what follows is a map of
what is in it.

## Where the project came from

He tells the origin story honestly. He bounced off Quake in 1998 — coming from
Doom and Raven's brighter games, he found it monotonous — and only came back to it
in 2019, at which point the appeal landed: the oversized architecture, the gloom,
the low-poly monsters, and a general sense of being a small frightened thing in a
hostile place. He is clear that the combat is still not what interests him.

Three things converged in 2020. He joined the Quake Mapping Discord to promote
Wheel Of Karma's first episode and stayed to learn. He helped a machinima maker,
GroovyIntelligentReject, by producing an unofficial sequel to one of his shorts —
built in Hexen II with Quake-looking assets. And Spirit asked him to act as a
French-speaking intermediary in letting a newcomer down gently about a first map
submitted to Quaddicted; instead of declining it, Inky mentored the author,
Steviemic, at length. Having spent that time improving somebody else's map, he
wanted to build his own.

## The homage structure

The mod is explicitly a tribute to **Sandy Petersen** and Quake's Episode 4, which
he names as his favourite. He goes level by level showing where each Episode 4 map
is echoed — the tower's arches and brickwork, the Elder God Shrine's scenery, the
terracotta and heavy beams of the Palace of Hate, the diamond-shaped flame supports
from Hell's Atrium reused throughout, the blocky pillars of the Pain Maze, Azure
Agony's distinctive blue palette in three key rooms plus its backlit staircases,
and the Nameless City in the yellow city section.

There is a nice piece of self-analysis where he compares his starting room to
Azure Agony's and observes they achieve opposite effects with similar materials:
Petersen's high ceiling makes you feel small in a huge threatening space, while
his own low one makes you feel trapped.

The homages spread wider: the briefing map is a base-themed remix of Quake's start
map, an underwater structure comes from the Grisly Grotto, the chalice room
recreates Doom II's MAP32 (itself a Wolfenstein and Commander Keen reference), and
Hexen II contributes the storytelling, the written plaques and the roof bell.
Models in the torture room come from **Heretic II**, converted through QuArK, which
he reports was far easier than he expected given the engine gap. There are repeated
nods to the 1990s webcomic *[The Adventures of Dank and
Scud](http://www.dankandscud.com/)* — including the briefing cutscene starring its
characters with author Michael Houston's permission, and a recreation of its
"Pretty Head Machine".

## Reuse as a deliberate technique

One of the most interesting sections, and one he anticipates disagreement about.
Since John Romero released id's original source maps in 2006, Inky treated them as
sample material — the way a musician samples records — copying brushwork and
remixing it: the start map's geometry, a brazier, E1M1's light poles repurposed as
antennae, a platform from the Nameless City, Azure Agony's underwater glowing orb
fixtures, a button unique to the Dismal Oubliette.

His argument is that this is not laziness but a way to reach the player's memory
directly and produce a sense of familiarity — and he takes the compliment that the
map felt like it came straight out of 1996 or 1997 as evidence it worked.

## Orientation by colour

Practical design advice worth extracting. Because the map requires backtracking,
he divided it into areas with distinct sub-themes, textures **and colour schemes** —
blue start, green mines, yellow city, a red building, a brown stone-and-wood
church, and a lava-and-marble Doom hell — so players can hold the layout in their
heads. He notes brush shapes carry some of that differentiation too. He is
gently critical of Azure Agony here: he loves it, but its uniformity is not a model
to copy.

## Storytelling and structure

He is a writer by inclination (with short-story prizes in France) and structured
the mod as seven chapters, from briefing through the church, the Mass, the Chamber
Of Torments and Hell to a closing text that recontextualises everything.

He also publishes his **design diagram** — a hand-made structural chart of areas,
one-way and two-way connections, and colour-coded gating by key, button or action.
He explains why he rejected the usual bubble diagram as too coarse, and notes his
working process: no floor plans or sketches beyond that diagram, building one room
at a time to completion rather than laying out the whole map in draft, because
carrying a half-finished map in his head would demotivate him. Monster placement
and lighting are the exceptions, done near the end.

## FTE: the cautionary tale

The section most likely to be useful to other mappers, and the most painful.

He built the whole mod on the FTE engine, having heard about it constantly and
trusting its reputation for lifting engine limits and supporting Hexen II. FTE
handled everything he asked of it. It was only late — after three months of work,
exhausted — that he tested other engines, and found extensive breakage: multiple
scrolling skies in one map, framed text, camera behaviour, rotating brushes moving
at a crawl, transparent skin regions rendering pink, entities stuck or missing,
truncated messages, and outright crashes on start. Lacking the energy for a long
compatibility campaign, he shipped it as FTE-only.

The consequence was that more than half his feedback was complaints about the
engine rather than comment on the map. He is warm about the people who did play it,
and singles out **dumptruck_ds**, who promoted it on his channel.

## The detailed tour

The back half of the page walks every area of the map, and is where the
craft detail lives. Highlights:

- **The briefing map**, with the Quake HUD face repurposed as a difficulty-selection
  button texture and a flattened grenade model used as blinking instructions — a
  trick of turning non-texture graphics into wall textures that he reuses later.
- **Selective clipping** via [Preach's hack](https://tomeofpreach.wordpress.com/2015/11/18/selective-clipping/),
  making brushes solid to the player but not to monsters, so a fiend can move
  freely in a low-ceilinged arched room where it would otherwise snag.
- **A fix for pitch-black model entities**, taught to him by Bal: the visible floor is
  a `func_wall` with `_dirt` set to -1, concealing a `func_group` beneath with
  `_lightignore` set and `_minlight` at the level you want the models above lit to.
  He calls this the single biggest legibility improvement he made.
- **Skill-dependent brushwork** — grates dropping behind hard-skill players to prevent
  retreat, hint arrows shown only on easy, and a pair of buttons whose functions are
  randomised at runtime so replay memory does not help.
- **Buttons triggered by grenades and rockets**, not just touch, which he discovered
  mid-project and built a whole mechanism around.
- **The Mass**, the centrepiece: an in-engine machinima using a custom `func_puppet`
  entity — essentially a `misc_model` crossed with a `func_train`, where each
  `path_corner` selects an animation sequence — with a cast of eighteen puppets, and
  a custom `func_mover` used to slave camera movement to invisible doors for
  tracking shots. The same `func_mover` drives the roof bell.
- **The trick behind the Mass**: while the player walks downstairs, an undetectable
  teleporter moves them into a duplicate church where the puppets are replaced by
  real monsters. That is why the roof cannot be jumped from and why all exits close
  once the ceremony starts — and it is what allows the landscape outside to be
  completely different when the apse finally opens onto Hell.
- **The incantations** are in Aklo, the fictional language of the Cthulhu Mythos,
  voiced by Inky himself with processing; he edited `conchars.lmp` to add an
  umlauted character the stock set lacks. He connects the talking shambler back to
  the 1996 machinima *Ranger Gone Bad*.
- **Doom-style pickups in Hell**, done by pairing standard Quake entities with blank
  models against a `misc_model` showing the sprite, with pickup killtargeting the
  model.
- **A recreation of Doom's "texture pegging"** on a secret door, so it vanishes upward
  rather than sliding — emulating a corner case of the Doom engine in Quake, which
  he cheerfully expects nobody to notice.

## What he counts as failures

Unusually candid, and the most instructive part. The flooded temporary dead end
early in the map frustrated players so much that some quit rather than move on.
Written instructions placed on a computer terminal were ignored, so a progression
route had to be redesigned around an easier-to-spot button. He repeatedly built
tempting power-ups — a quad on a retreating elevator, a quad-and-pentagram platform
in the city — expecting players to need them under fire, and watched every
playthrough clear the area first and collect them afterwards. And the grand reveal
of Hell, which he considered his best illusion, drew almost no reaction in
playthrough videos at all.
