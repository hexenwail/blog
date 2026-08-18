---
title: "Armors Unmessed"
subtitle: "Placing an armour worth a known percentage, whatever class the player picked"
description: "Digest — why Hexen II armour values are inconsistent across classes, the full value table, and Inky's HexenC replacement entities."
weight: 150
kind_of_trick: "Mapping trick with HexenC"
published: "2020-04-30"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-armors.html"
---

**Category: mapping trick, requires HexenC and a `progs.dat` recompile.**

Hexen II's four armour items protect by different amounts depending on which class
picked them up — the manual explains, for instance, that breastplates suit the
Paladin and suit the Necromancer badly. As a player that is good design: it
changes how each class plays and rewards replaying. As a mapper it is a problem,
because when you want to hand the player a strong armour before a hard fight, you
cannot: you can only place an *item*, and what it is worth is decided at runtime.

Inky's framing of the goal is the useful bit — he wants to invert the resolution.
Instead of "place an amulet, and the bonus is resolved by class", he wants "place a
10% armour, and *which item* is resolved by class".

## The value table

The article's most quotable asset is the full matrix of what each item is actually
worth to each class, as applied by the HexenC damage code:

|             | Amulet | Bracers | Helmet | Breastplate |
|-------------|--------|---------|--------|-------------|
| Paladin     | +5     | +10     | +15    | +25         |
| Crusader    | +15    | +5      | +25    | +10         |
| Necromancer | +25    | +15     | +10    | +5          |
| Assassin    | +10    | +15     | +5     | +25         |
| Demoness    | +10    | +15     | +5     | +25         |

## Three separate inconsistencies he documents

This is where the article earns its title, and it is worth knowing about even if
you never use his solution.

First, **the table contradicts the manual**. *The Chronicle of Deeds* describes
bracers as the Assassin's speciality, strongly implying they should be that
class's +25 item. In the shipped values bracers are +25 for nobody, while the
breastplate is +25 for three of the five classes. His reading is that Raven
started with a more coherent distribution, changed it, and did not update the
documentation.

Second, **the HUD's AC counter is wrong**. That number is computed by the engine
rather than by HexenC, from a similar table with a *different* distribution — so
the armour rating shown to the player does not match the protection actually
applied. He notes that the
[uhexen2-shanjaq](https://hexenworld.org/downloads/hexen2/uhexen2-shanjaq/) engine
builds from December 2021 onward fix this.

Third, **the spawnflags trap**. The Necromancer and the Demoness share the same
spawnflag bit for per-class item presence, but their armour values are not aligned
with each other at all — the Demoness follows the Assassin's row, which is the
Necromancer's opposite for breastplates. So the conventional technique cannot
express "give the Demoness this but not the Necromancer".

## The conventional method, and why it grates

Without code, the approach is to stack all four armour items at the same spot and
use spawnflags so that each is visible only to the one class it is worth the right
amount to. It works, but you must consult the table and place four entities every
single time — and the Necromancer/Demoness collision above means it cannot always
be made correct.

## His replacement

He ships a downloadable package (on his page) implementing four new point
entities — `item_armor_05`, `item_armor_10`, `item_armor_15` and `item_armor_25` —
that name the protection directly. Installation is four steps: drop the supplied
`.mdl` files into the game's models directory so TrenchBroom can display them, add
the matching `@PointClass` lines to `hexen2.fgd`, merge the supplied
`extension_items.hc` into `items.hc` (after the vanilla armour code, or as its own
entry at the bottom of `progs.src`), and recompile `progs.dat`.

The models exist only in the editor — each is labelled with its percentage so the
map is readable at a glance. In game each entity is swapped for whichever real
armour item delivers that protection to the class in play, so an `item_armor_25`
becomes an amulet for a Necromancer and a breastplate for a Demoness.
