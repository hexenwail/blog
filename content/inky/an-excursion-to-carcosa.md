---
title: "An Excursion to Carcosa"
subtitle: "Author's insights on his second Quake release — Chambers, Lovecraft and the Re:Mobilize mod"
description: "Digest of Inky's design commentary on An Excursion to Carcosa: its King in Yellow sources, area-by-area literary references, and the progs_dump scripting behind its set pieces."
icon: "quake"
weight: 30
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/quake-carcosa-insights.html"
---

The companion commentary to [Church Of The Unholy](../church-of-the-unholy/), and
the better of the two if you are interested in how literary source material becomes
level geometry. The map ships as part of the **Re:Mobilize** mod; version 1.1 is
final, on [ModDB](https://www.moddb.com/mods/remobilize/downloads/rm1-1).

## How it came about

He opens by saying *Church Of The Unholy* did not do as well as he had hoped, and
that he had concluded Quake mapping might be a one-off for him. What changed his
mind was **EmeraldTiger**, who liked the map and invited him onto Re:Mobilize — a
mod built on **progs_dump 3.0** introducing three new movement mechanics, which
needed showcase maps.

Inky took the invitation considerably further than intended: a year's work, the map
itself plus a large amount of added code and customisation options layered onto the
progs_dump codebase.

## The literary programme

Where the previous map was a tribute to Quake's own history, this one draws on
books:

- **Robert W. Chambers, *The King in Yellow*** — the late-nineteenth-century short
  story collection that established its own cosmic horror ahead of Lovecraft.
- **Ambrose Bierce**, whom Chambers drew on — *An Inhabitant of Carcosa*, the source
  of the name, and *Haita the Shepherd*, the source of Hastur.
- **H. P. Lovecraft, *The Haunter of the Dark***, which Inky names as his favourite of
  the author's stories.
- **Alan Moore and Jacen Burrows, *Providence***, the comic series reworking both the
  Lovecraft and Chambers mythos.

The mood comes from the poem that opens Chambers's collection, and the most
interesting passage on the page is his line-by-line account of translating it into
brushwork: cloud waves rendered as fog, tinted orange because the poem's lengthening
shadows imply dusk; the lake made aerial rather than literal, so the map's bottomless
pits fall into a skybox; twin suns achieved through a wind setting (arranged for him
by **Heresy**) that makes the sky's disc slowly separate into two overlapping copies
in Ironwail; black stars in an inverted Makkon skybox; the Hyades echoed through
Taurus references, including bull switches borrowed from Hexen; and the King's
tattered banners appearing as damaged yellow cloth in the graveyard, on a tower,
and as the sail of a boat.

He never shows the King. The ambiguity is deliberate — is it a person, a god, an
idea? — and he leans into it with unsettling yellow murals, most of them generated
in [Craiyon](https://www.craiyon.com/) specifically so the uncanny-valley quality of
AI images works for the story, offset by one genuinely human-made painting in the
forge.

## The area-by-area tour

The bulk of the page. Each area exists because of a specific text, and he explains
both the reference and the gameplay reasoning.

**Swamp** (the start) teaches the Re:Mobilize mechanics, signals immediately that
this is a puzzle map rather than a flowing one, and introduces custom keys and their
HUD early. Its best moment is the starting weapon: the player must stop treating the
axe as "the melee weapon" and remember it is an axe, for cutting wood. He is
knowingly forcing the player to think inside the fiction rather than outside it.

**Hali's lake** is reachable only by falling off the map — a place that is always
below you and that you may never see, since the map can be finished without it. It
recreates Arnold Böcklin's *Isle of the Dead*, with the roles reversed: the robed
figure is in black rather than white, and in the ending cutscene it is the player,
not the ferryman, departing. Taking the boat is one of two endings; he describes it
as being gently invited to die, and links it back to Doom's E1M8.

**The kiosks** — one at the lake, one in the upper city — represent the "lethal
chambers" from Chambers's *The Repairer of Reputations*, which is also why the plaza
has topiaries, fountains and statues. *Providence* renames these "exit gardens", and
that was an additional source. In both, the player can choose life instead.

**Graveyard and pass** exist because Bierce's *An Inhabitant of Carcosa* is set in a
graveyard outside the dead city. Mechanically it introduces light panels revealed by
sliding banners aside, a shambler that erupts from the ground rather than
teleporting in, and the custom-key HUD — deliberately held back from the start area,
which he judged already overloaded. He notes a fix worth stealing: the key dropped by
the shambler was hard to spot, so he added a progs_dump particle effect and a
centred message to draw the eye.

The "bouncing cockroach" monster is a Heretic II G'Krokon model and sounds running
`monster_demon` code — a demonstration of progs_dump's monster customisation, with
Re:Mobilize adding bounding-box resizing to fit a replacement model. He is pleased
that identical code with a different body reads as a genuinely new monster.

**Court of the Dragon**, from the Chambers story of that name, is modelled on
E4M5's structure: the exit visible from the start, taunting you. The player's gold
must go either to opening that gate or to paying the ferryman — a choice they are
never told they are making, which only becomes visible on a replay. He notes the
outcome ran opposite to his intent: the "secret" exit became the one most people
used, because it looks like a Quake exit, while the intended regular exit became the
obscure one.

Carcosa is split into two cities for two reasons at once: the play in Chambers has
two sisters, Cassilda and Camilla, so two towers satisfy the lore, and the vertical
separation showcases the mod's movement mechanics.

**Pasture** is the area his Hexen II readers found funny, and he defends it — Hexen
II's assets were the right ones to reference Bierce's *Haita the Shepherd*, the
origin of Hastur as a shepherds' god, along with its shrine, valley, flock, cave and
divine wrath. The shepherd and his flock appear only if a secret is found. He
reports, with evident amusement, that players told to make an offering to Hastur
generally start by killing the boy and his sheep.

**Bathing-room** is the technical highlight. It recreates a room described in *The
Mask*, whose pool holds a petrifying solution — so monsters that see the player
wearing the mask turn to stone. He is proud of this specifically because he did not
abuse his position as a mod co-author to write himself a special power: it uses an
existing loophole in progs_dump 3.0. Every monster in the room is a knight
(shamblers included, via monster customisation). Melee monsters have no ranged
attack and therefore no `th_missile` function set, which leaves it free to override —
so he points it at the teleport function, which swaps the model to a stone version
and calls the death think. When the AI decides to use a ranged attack at distance,
the monster petrifies instead. Consequences he documents: at close range the AI
picks melee instead, so the player has to back off; the monsters are given very high
health because they cannot support both normal death and petrification; and they
appear only once the mask is taken, which is why the mask does not travel with you
out of the room.

**Cassilda's tower** contains a shooting puzzle where two buttons do different
things and which is which is decided by a `trigger_random`, so a reload or a replay
does not help — the same replayability trick he used in the previous map. Its upper
room has "burning eyes" puzzles triggered by looking at things, which he notes is
very unusual in Quake and takes players a moment. The antigravity well back down is
a wiremesh shaped as a 3D volume rather than a surface, at a third of normal speed —
effectively a fourth movement mechanic.

**Recreational area** is entirely optional and entirely scripting: a conversation
with an ogre, changing portraits, a one-door-at-a-time system he found surprisingly
hard, a shooting gallery, a slot machine and a grenade billiard table with a bounce
counter. The ogre conversation is a clever misuse of the mod's hook mechanic — an
aim-only hook whose button press raises an event caught by a `trigger_filter` rather
than pulling the player, with `trigger_random` varying the ogre's lines. The
portraits are a nod to a steakhouse he visited on Route 66 in 2016.

**Library** carries his best piece of general mapping advice. Worried about
competing with the many beautiful libraries in Quake and Hexen II maps, he concluded
that a map does not need to recreate reality: Quake mapping is abstract, a
bookshelf texture repeated is enough, and the more a map suggests rather than shows,
the more effectively it works. The room also holds the mural of the King, and a
false mural that becomes translucent with the right artefact — an idea taken from
Hexen II, as is the globe puzzle from Heretic II. The silver key is a 3D version of
Lovecraft's Elder Sign, modelled by **Mathuz** with a texture by **docjr5**, which he
was surprised to find had never been used as a Quake asset before.

**Chthon** answers the hardest design question on the page: how do you represent a
book that drives its readers mad? His solution is to teleport the player without
warning into a fight with Quake's most dangerous boss, on the grounds that it is
nonsensical, frightening and dangerous. He considered painting Chthon yellow and
decided against it, preferring the King to stay unattached to any concrete monster.

**Lower city** documents a cut. He had planned something in the spirit of E4M8 with
intertwining streets at many elevations, and dropped it under deadline pressure for
a staircase and a courtyard. In retrospect he thinks the deadline was right: it
would have been a second map inside the map with a different, more combat-led mood,
competing with an already complex puzzle chain. The turret ogre there is not a new
monster but an assembly of entities around a modified version of **Madfox**'s
fisherman ogre, using a `face_always` feature he added to the mod.

**Hawberk's forge**, named for the armourer in *The Repairer of Reputations*, is a
safe room with no enemies. He notes from playthroughs that it became a pace-killer,
because both its bull switch and the drawbridge switch are placed the Hexen way —
off to the side, colour-matched to the wall, needing attention — rather than the
Quake way of an obvious button flashing in the dark.

**Camilla's tower** is a recreation of the real St. John's Roman Catholic Church on
Federal Hill in Providence, the church in *The Haunter of the Dark* and in the
*Providence* comic, now demolished. He notes the happy accident that stock Quake
textures resemble the real building closely. He built only the steeple, since he had
already made a whole church in the previous map and Carcosa is known for towers.

The **shining trapezohedron** follows the *Providence* comic's version rather than
Lovecraft's description, since a genuinely alien object is more interesting than an
irregular sphere — though his is a random mess of spikes rather than the comic's
actual star trapezohedron. To convey its hypnotic pull he used the visual grammar
already available: teleporter textures warp slowly and are literally portals to
other worlds, and Hexen II supplies a red one. Technically it is unusually
demanding — a brush entity so it can carry a warping texture, a rotating object to
spin, converted to a train so it can take part in the map's most complex cutscene,
and represented in the puzzle-item HUD as a model with a four-step animated skin
(the skin-group technique again credited to docjr5).

**The Haunter of the Dark** boss is dozens of entities assembled: Madfox's dark
young model for the tentacled body, an eye taken from the Hexen II beta that never
shipped, and three orbiting globes standing in for the story's three-lobed burning
eye — which he also ties to a François Bourgeon comic featuring three lethal
floating tin eyes. The fight requires shooting the globes, since the Haunter itself
is invulnerable, while wooden pillars provide cover that degrades as it takes damage.
True to the story the creature hates light, so shooting out the louvres lets daylight
in and makes it close its eye and stop firing. He observes that players often work
against themselves — destroying their own cover, or continuing to shoot windows
instead of the globes.

**Treasure room** nods to Hexen II's two treasure rooms and to Smaug's hoard, with
texture work by docjr5 and a lava shambler skin by **FloofCollie**. All the chests
are brushwork rather than models, including the animated opening one.

## Four ways to finish

A nice piece of structural design he lays out plainly: with the gold bar in hand the
player can pay the ferryman directly; melt it into a gold key at the forge and pay
with that instead (the ferryman is indifferent as long as it is gold); use that key
on the Court of the Dragon door for the other exit; or first offer the bar at
Hastur's altar, collect the reward, take it back, and then do any of the above.

## The secret map

*Directions*, the companion map, is sometimes mistaken for unfinished work or a test
level left in by accident. It is deliberately minimal so that nothing distracts from
the puzzles, and is built around environmental storytelling — a quiet interlude
rather than an adventure. It was unplanned, prompted by Marc-Antoine Mathieu's comic
*Sens*, in which a character explores an abstract world of nonsensical arrows; the
French title puns on meaning, sense and direction at once, and Inky recreates some
of its scenes directly.
