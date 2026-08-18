---
title: "Better call Mario!"
subtitle: "Diagnosing and sealing a leaking map, in escalating order of desperation"
description: "Digest — what a leak is, how to read the .pts point file in TrenchBroom, and three fixes ranked from surgical to brute force."
weight: 110
kind_of_trick: "Mapping Academy"
published: "2020-05-18"
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/mapping-tricks-leak.html"
---

**Category: Mapping Academy.**

A beginner's article, but with a good diagnostic angle: it starts from the
*symptom* rather than the compiler warning. If doors and buttons suddenly stop
responding to the player and behave as though they were `func_illusionary`, the
cause is very likely a leak — which is not an obvious deduction the first time it
happens to you.

## What a leak is

The map's world must be fully sealed by brushes. A leak is any path from the void
outside to the entities inside. His analogy is a water tank: a hole anywhere means
the contents drain away, hence the name.

## Solution 1 — read the point file

The compiler writes a `.pts` file next to your `.map` when it fails to seal.
TrenchBroom loads it via **File → Load Point File**, drawing a green line that
traces the escape route. The `.` and `,` keys step you along it. Follow it to
where it crosses from inside to outside and you have found the hole.

He is realistic about how this goes. If the leak is among axis-aligned boxes on
the grid it is obvious and was a lapse of attention — the easiest case, and the
rarest. Leaks tend instead to appear in messy geometry: terrain, caves, organic
architecture, triangles meeting at awkward angles. The point line still gets you
to the right neighbourhood.

## Solution 2 — overlap everything nearby

Sometimes the line is unhelpful, and he flags the specific case that makes people
doubt themselves: the point line appears to pass straight *through* a brush, which
cannot be what is happening, since leaks are gaps *between* brushes.

The fallback is to grow the surrounding brushes outward into the void so that they
interpenetrate rather than merely abut. The result is ugly in the editor but
leaves no interstice. The weakness is honest: because you never located the leak,
you are improving your odds rather than fixing a known hole.

## Solution 3 — the big box

If the first two fail, enclose the whole problem area in a sealed box. The leak
still exists but no longer reaches the void, because there is an airtight
container around it — with openings only where the area connects to the rest of
the map. The player cannot tell, because the scaffolding does not survive
compilation and is not visible even with `noclip`.

It works best when the area is naturally isolated — a dead end, or one way in and
one way out. Failing that, you can box the entire world.

The commonly cited costs are slightly longer compiles and a slightly larger BSP.
He says he has not really observed this himself, and leaves it as a judgement
call: your time hunting the leak versus the box's overhead.
