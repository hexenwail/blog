---
title: "{{ replace .Name "-" " " | title }}"
description: ""
authors: [""]
released: "{{ now.Format "2006-01-02" }}"
version: "1.0"
releaseType: "Single map"        # Single map / Hub / Episode / Mod / Total conversion / DM
engine: "Any (vanilla-compatible)"
vanilla: true
needsPraevus: false
modes: ["Single-player"]
classes: []                      # empty = all four
tags: []
screenshots:
  - {file: "", caption: ""}
download:
  filename: ""
  primary: ""
  size: ""
  sha256: ""
  mirrors:
    - {label: "Internet Archive", url: ""}
sources:
  - {label: "", url: ""}
readme: |
  Paste the author's readme here, verbatim.
---
