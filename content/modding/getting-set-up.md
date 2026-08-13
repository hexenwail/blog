---
title: "Getting set up: TrenchBroom to first compile"
description: "Install the editor and compilers, configure them for Hexen II, and run your own map."
weight: 10
updated: "2026-08-13"
verified: "2026-08-13"
verifiedAgainst: "Hexenwail 0.7.9-beta.r9, TrenchBroom 2026.1, ericw-tools 2.0.0-alpha9"
authors: ["Editor"]
entities: ["info_player_start", "light"]
tags: ["setup", "trenchbroom"]
---

This is the most important page on the site. If you get to the end of it you have a map
running in Hexen II, and everything else here is a refinement.

## What you need

Lorem ipsum dolor sit amet, consectetur adipiscing elit:

1. Hexen II, installed, with its retail `data1` folder.
2. [TrenchBroom](/files/#trenchbroom) — the editor.
3. [ericw-tools](/files/#ericw-tools) — qbsp, vis, light.
4. An [engine](/play/engines/) to run the result.

## Configuring TrenchBroom for Hexen II

Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. TrenchBroom ships game
configurations for Quake; Hexen II needs one added by hand.

```
Games ▸ Hexen 2 ▸ Open Preferences
  Game Path:  C:\Games\Hexen2
  Entity definitions: hexen2.fgd
  Texture collection: data1/gfx/*.wad
```

{{< note >}}
The single most common mistake: pointing the game path at `data1` instead of at the folder
*containing* `data1`. Ut enim ad minim veniam, quis nostrud exercitation.
{{< /note >}}

## Your first room

Duis aute irure dolor in reprehenderit. Make a hollow box, texture it, and drop exactly one
`info_player_start` in it plus a `light`.

```ini
{
"classname" "info_player_start"
"origin" "0 0 32"
"angle" "90"
}
{
"classname" "light"
"origin" "0 0 128"
"light" "300"
}
```

## Compiling

Excepteur sint occaecat cupidatat non proident:

```sh
qbsp  -hexen2 mymap.map
vis   mymap.bsp
light -extra4 mymap.bsp
```

Copy the resulting `.bsp` into `data1/maps/` and launch with `map mymap` from the console.

## When it does not work

- **Leaked.** See [Fixing a leak](/modding/fixing-leaks/).
- **Black.** You forgot `light`, or you skipped the light stage.
- **Silent.** That is not a map problem — see [audio setup](/play/configuration/).
