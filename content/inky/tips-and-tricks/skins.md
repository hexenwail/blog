---
title: "Fashionable debris"
subtitle: "Adding a new skin to a Hexen II model, using rock chunks as the worked example"
description: "Digest — extracting and rebuilding .mdl skins in QuArK, the chunk_death / CreateModelChunks code path, and a small HexenC change to make skins selectable per entity."
weight: 120
kind_of_trick: "Mapping trick with HexenC"
published: "2020-05-10"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-skin.html"
---

**Category: mapping trick, requires HexenC and a `progs.dat` recompile.**

The example is trivially small and the technique is not: this is a general recipe
for reskinning any Hexen II model, demonstrated on something nobody will ever
notice.

## The problem

Wheel Of Karma opens on **Winnowing Pass**, which is built from red rock. When a
`breakable_brush` shatters, the debris colour, shape, count and sound all come
from its `thingtype` key — and of the predefined values, only two are stone:
grey (1) and brown (9). Picking brown, Inky got reddish-brown rock throwing off
brown-yellow fragments, which looked wrong enough to bother him.

## Reading the code path

The useful part of the article is the trace through the game code, which is a
model for how to answer this class of question yourself:

- `breakable_brush` in `breakabl.hc` sets its death function to `chunk_death`.
- `chunk_death` in `chunk.hc` is a long `if`/`else if` over `thingtype` that picks a
  death sound, then calls `CreateModelChunks`.
- `CreateModelChunks` has a matching chain that, for brown stone, randomly picks
  one of `schunk1.mdl` through `schunk4.mdl` and sets the chunk's skin index to 1.

So the models carry two skins — index 0 grey, index 1 brown — and the code selects
between them by `thingtype`. Adding a third colour means adding a third skin and
giving the code a way to ask for it.

## Making the skin

He extracts the `ttex017` rock texture with QuArK's texture browser (via
right-click → Properties → Save as, keeping the Quake 1 texture setting), then
saves the model's existing skin 1 out of QuArK as a PCX and merges the two in an
image editor. The merge looks crude at the pixel level but resolves cleanly once
projected onto the model.

He notes you could skip the extraction here and import the texture straight in as
a skin, since nobody inspects the UV alignment of a bouncing rock fragment. He
keeps the longer path because the tutorial is meant to generalise: for player
models, monsters, puzzle items and projectiles, starting from the existing skin is
the only way to know where anything lands.

## Getting it back into the .mdl

This is the section worth having, because QuArK's workflow here is genuinely
counter-intuitive and he documents it step by step. In outline: save the four
`schunk` models out of `PAK0.PAK` as standalone `.mdl` files, then **close QuArK
completely** — it treats the PAK it opened as its primary target and will not
retarget — relaunch it against a single `.mdl`, import the new PCX via *Edit →
Import files → Import (copy) files*, right-click the imported file and Open
(accepting the warning), then save. If it complains that no component is selected,
clicking *Model* in the tree view clears it. Repeat one model per QuArK session.

## The code change

With the modified models in the mod's `models` directory, he alters the brown-stone
branch of `CreateModelChunks` so the chunk's skin comes from the
`breakable_brush`'s own `skin` key when one is set, falling back to 1 when it is
not. That is a small change with a good property: the entity keeps using
`thingtype` 9 for its sound and chunk models, but a mapper can now specify any
number of skins per brush from TrenchBroom.

## His own verdict

He is refreshingly honest in closing that the effect is barely visible and nobody
will ever notice it — while arguing that this is the point, because the *wrong*
colour is what people would have noticed. He also points out that the procedure
reads long only because he explains everything; in practice it is quick once
understood, and reskinning can obviously produce far more dramatic results than
rock chips.
