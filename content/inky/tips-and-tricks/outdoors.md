---
title: "Water, Air, Life."
subtitle: "Techniques for open-air maps — swimmable waterfalls, ambient-sound control, sun lighting and brush-built plants"
description: "Digest — *waterskip invisible water, vis -noambientwater, obj_ice, ericw-tools sun and bounce lighting, and making vegetation from two SKIP-textured brushes."
weight: 40
kind_of_trick: "Mapping Academy"
published: "2021-04-16"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-outdoors.html"
---

**Category: Mapping Academy, no code required.**

His framing is a comparison: Quake is dark interiors, Hexen II has real outdoors —
and modern engines have pushed the limits far enough that big valleys and long
sight lines are practical. The article collects techniques that suit that kind of
space, organised under the three words of its title.

## Water

### Waterfalls that are actually water

The neatest problem statement on the site. A brush becomes water because its
texture name starts with `*`. An animated texture's name starts with `+0`, `+1` and
so on. **A name cannot start with both**, so a waterfall can either flow or be
swimmable, not both — which is why vanilla water only ever does the hardcoded warp.

The way out comes from [ericw-tools](https://ericwa.github.io/ericw-tools/): qbsp
supports an invisible water texture, `*waterskip` (with `*slimeskip` and `*lavaskip`
alongside it), from the
[skip textures kit](http://www.quaketastic.com/files/texture_wads/skips_2018.zip).

The construction is three steps: build the water volume from `*waterskip`;
duplicate it in place; make the duplicate a `func_illusionary` textured with an
animated waterfall texture. The player now sees falling water, can walk through it,
and finds real water behind.

### Ambient water sound, and turning it off

Water textures also make the compiler add ambient water sound automatically. He is
blunt that this is sometimes a nuisance, and explains why in terms of `vis`: sound
propagation follows visibility, so the real rule is that if you are in a partition
of the world that `vis` considers connected to a partition touching water, you hear
it. Outdoors, with long sight lines, that means gurgling audible from absurd
distances with no water anywhere near.

Fixing it properly means understanding `vis` partitioning and optimising for it. His
pragmatic alternative — and he includes himself among those lacking the skill — is
`vis`'s **`-noambientwater`** switch, which suppresses the automatic sounds
entirely, after which you place `sound_ambient` entities exactly where you want them
with sensible attenuation. Equivalent options exist for slime, lava and sky — and
yes, sky brushes emit a wind sound too.

### obj_ice

A genuine piece of trivia recovery. `obj_ice` is the only **brush** entity among
dozens of point entities in the `obj_` family, which is presumably why it went
unnoticed — Inky says he only learned of it recently. Raven never used it in any
shipped map, and *Portal of Praevus* ignores it despite being the snow-and-ice
mission pack. The one use he could find in the wild is in the *Black Tower* map of
the *Fortress of Four Doors* mod.

It is worth knowing about: optionally translucent brushes that take damage and
break like a `breakable_brush`, and — uniquely — are **slippery**, bringing back the
ice floors of Heretic and Hexen.

## Air

### Skyboxes and fog

Since Hexen II is essentially a large Quake mod, the modern Quake techniques
transfer. He points at
[dumptruck_ds's tutorial](https://www.youtube.com/watch?v=vIXBcMWw_X4&t=65s) rather
than repeating it, and notes that very little in that channel's mapping series is
Quake-specific enough not to apply.

### Lazy lighting

He opens with a statistic worth remembering: Quake's *Azure Agony* contains 404
entities of all kinds, and **141 of them are lights**. Interior maps need that
density because there is no natural light.

Outdoor maps do not, and ericw-tools provides the shortcuts:

- **Sun.** Any area capped with sky brushes can simply be lit by sunlight, tuned
  through the `_sunlight` family of keys on worldspawn (documented in the
  [light.exe docs](https://ericwa.github.io/ericw-tools/doc/light.html)). His quick
  recipe: a normal `light` entity targeting an `info_null` to set the angle, with
  `_sun` set to 1. `_sunlight2` and `_sunlight3` add secondary ambient suns.
- **Bounce.** Worldspawn's `_bounce` keys simulate light reflecting off surfaces.
  His warning is a scheduling one: bouncing makes the whole map brighter, so decide
  whether you are using it **before** you light anything, or you will be
  re-balancing every light afterwards.
- **`_minlight`.** Real shadows are never pitch black; the lighting algorithm's are.
  `_minlight` sets a floor below which no part of a brush entity can go. He is
  careful here — used carelessly it flattens everything, which is why Quake mappers
  generally avoid it. His own case study is *Church Of The Unholy*, where he applied
  `_minlight` 50 to worldspawn, which sounds reckless and worked: the outdoor areas
  were already lit by `_sunlight2`, so in practice the floor only affected the
  underground sections. The lesson he draws is that the two must be combined —
  `_minlight` alone will either crush outdoor shadows or wash out interiors. He also
  mentions light's `-addmin` option.
- **Emissive textures.** Place a `light` entity and set `_surface` to a texture name.
  That light itself is discarded; instead every face in the map using that texture
  becomes a light source. Behind the scenes lights are placed every 128 units across
  those surfaces, 2 units off them. One entity to light every torch texture in the
  map.

He closes the section with a fair-minded observation: because Quake's mood depends
on lighting far more than Hexen II's does, expectations are higher there, and Hexen
II mappers get more latitude — while noting that a map lit to Quake standards will
stand out all the more.

## Life

### Vegetation from brushes

A technique borrowed from the Quake scene, which lacks Hexen II's decorative
entities and therefore had to invent it. His example is the swamp plants in Wheel Of
Karma; his proof that it scales is the palm trees in the Quake mod
[Dwell](https://www.moddb.com/mods/dwell), which are also brushes.

The recipe:

- **Two flat brushes per plant**, intersecting — one alone reads as a flat sprite.
- Made **`func_illusionary`** so the player does not bump into them.
- Textured with the special **`SKIP`** texture on every side except one, which gets
  a foliage texture.
- **`_mirrorinside` set to 1**, so faces draw on both sides. That only makes sense on
  see-through brushes, which SKIP makes these. In game the result is two
  intersecting zero-width double-sided planes.

He notes this remains useful even though Hexen II has `obj_plant`, `obj_hedge` and
`obj_tree`, because it adds variety — and because drawing a 2D texture is a great
deal less work than modelling.
