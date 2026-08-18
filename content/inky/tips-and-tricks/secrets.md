---
title: "Secrets a la Quake"
subtitle: "Quake-style secret discovery and a working secret counter, with no code changes"
description: "Digest — building a Quake-like 'you found a secret' notification and running count in Hexen II using only trigger_counter and strings.txt."
weight: 160
kind_of_trick: "Mapping trick, no code"
published: "2020-04-28"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-secrets.html"
---

**Category: mapping trick, no code required.**

The problem Inky sets out is one of feel rather than function. Hexen II has
secrets, but it never tells you that you found one, and because you move through
a hub chasing objectives rather than finishing discrete levels, there is no
end-of-level tally either. Quake's on-screen announcement and its secret count are
a large part of why hunting secrets there is satisfying, and Hexen II simply drops
that feedback loop.

## Why not just turn the code back on

He notes that Quake's `trigger_secret` implementation is still present in Hexen
II's `triggers.hc`, commented out and straightforward to re-enable. He tried it
and advises against it: on his machine, reactivating it made every fight crash the
game. His broader position — repeated across these articles — is that touching
HexenC introduces failure modes that are hard to predict and harder to debug, so
where a map-only solution exists, take it.

## The map-only approach

The technique fakes a countdown using `trigger_counter`, which normally fires
after being triggered N times. The construction:

1. Give every secret some trigger or button that fires when the player finds it,
   and point all of them at the same target name.
2. Place **N** `trigger_counter` entities sharing that target name, where N is your
   secret count. Set each one's `count` to a different value — 1, 2, 3 … N — so
   that exactly one of them fires on each discovery, whichever order the player
   finds them in.
3. Set the *No message* spawnflag on all of them, so the engine's built-in counter
   messages do not collide with yours.
4. Assign each counter a `message` number pointing at a custom string, arranged so
   the counter that fires on the first discovery reports the highest number
   remaining and the one that fires last reports none remaining.

## The strings.txt side

Game messages live in `strings.txt` under `data1` (or `Portals` for *Portal of
Praevus*). The file has fewer than 600 lines, so he starts custom entries at line
600, where they cannot overwrite anything — with the mnemonic that the line number
reads as "six-hundred-and-the-number-still-to-find". `@` characters in a string
act as line breaks.

He writes five messages: all found, one left, two left, three left, and a generic
"more to find" for any larger remainder. That mirrors what Raven did for the
built-in `trigger_counter` messages, which also stop being specific above three.
You can add more levels if you prefer; the message-number arithmetic just shifts
accordingly.

His wording is deliberately not Quake's "you found a secret *area*", because not
every secret is an area.

## The trade-off to know about

The one real drawback is that **the secret count must be fixed in advance**. Add a
seventeenth secret late in development and the whole ladder of `count` and
`message` values has to be renumbered. Against that, he points out an advantage
over Quake: because Hexen II gives you no intermission screen between maps, the
player is told their progress in-game at the moment of discovery, which arguably
lands better than a tally at the end.
