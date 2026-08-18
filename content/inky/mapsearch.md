---
title: "MapSearch"
subtitle: "A command-line tool for interrogating Hexen II and Quake .map files"
description: "Digest of Inky's MapSearch page — what the tool searches for, why a plain text search is not enough, and where to get it."
icon: "search"
weight: 60
original: "http://earthday.free.fr/Inkys-Hexen-II-Mapping-Corner/MapSearch.html"
---

MapSearch is Inky's own utility for finding entities inside `.map` source files.
It is a command-line program for Windows, distributed as a zip containing the
executable, a config file, a readme and a changelog. The current release
documented on his page is version 1.3. It handles both Hexen II and Quake map
files.

## The problem it solves

A general-purpose text search — he uses Notepad++ for exactly this — will find you
the string `func_door` in a map file easily enough. What it cannot do is
understand the file's structure. Entities in a `.map` are brace-delimited blocks
of key/value pairs, often with brush geometry inside them, so questions like *show
me every entity that has this key set to that value*, or *show me the entity that
owns this brush*, are structural queries that a line-oriented search cannot
express. MapSearch is built to answer that shape of question.

## Why a mapper would want it

His stated purpose is learning by example: pointing the tool at Raven's original
Hexen II maps to see how the professionals actually wired up a mechanism, rather
than guessing from documentation that may not exist. That is the same method
running through his [Tips & Tricks](../tips-and-tricks/) articles — most of them
are, at bottom, reports of what he found by reading shipped maps.

## Getting it, and one known snag

Downloads, the readme and the changelog are all linked from his page. We do not
mirror the binary — get it from him so you get the current version.

One operational note worth carrying over, because it looks like a crash and is
not: the program is a self-contained .NET executable that unpacks its runtime
files into a temporary directory. Windows eventually cleans that directory out,
after which the next launch fails with an error about a missing `.dll` under
`AppData\Local\Temp`. The fix is to delete the leftover `MapSearch1.3` temporary
folder and run the executable again, which recreates what it needs.

{{< note >}}
This is a description, not a re-implementation. There is no search box on this
page — MapSearch is Inky's software and lives on his site.
{{< /note >}}
