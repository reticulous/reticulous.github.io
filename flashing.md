---
title: Flashing
description: >-
  Three ways to get Reticulous onto a board: flashmon in the browser over USB,
  `spangap flash` from a workspace, or a downloaded image driven through
  esptool by hand.
---

<div class="note warning" markdown="1">
**It is really early days.** Some stuff doesn't work yet, some stuff looks ugly.
You're literally one of the very first users.
</div>

There are three ways to put an image on a board, and no others.

## From a browser

Open **[flashmon]({{ '/flashmon/' | relative_url }})** in a Chromium-based
browser (desktop Chrome, Edge, Brave or Opera), plug your board in over USB, and
click through. It auto-detects which board you have, flashes the matching image
(or a generic one), and drops into a serial monitor — no toolchain, no build to
pick, and no install.

Reaching a USB device from a page needs a secure context, which this site is.

## From a workspace

If you have already installed `spangap` to
[build for yourself]({{ '/building/' | relative_url }}), that same workspace
flashes:

```sh
spangap build reticulous/reticulous --with spangap/hw-lilygo-tdeck
spangap flash
```

## By hand, with esptool

Download an image zip from the
[catalogue]({{ '/builds/stable/' | relative_url }}) and unpack it. Inside is a
`reticulous.esptool` argfile naming every binary and the offset it belongs at,
so the whole flash is one esptool invocation:

```sh
unzip reticulous_hw-lilygo-tdeck_<stamp>.zip -d image
cd image
esptool.py --port /dev/ttyACM0 write_flash @reticulous.esptool
```

Use this when the browser route is unavailable and you don't want a workspace —
a machine with no Chromium, or a CI runner.

## Watching the console

Two ways, matching the two that flash: **flashmon** keeps the serial monitor
open in the browser tab it flashed from, and **`spangap monitor <port>`** does
the same from a terminal in a workspace. The device's command line is also
reachable over the network once it is on one — the web UI, and `ssh` — but on
the wire, serial is those two.

## After it boots

The device comes alive and presents a full-featured web interface on a built-in
access point whose SSID starts with `reticulous_`, plus — on a board with a
screen — a smartphone-like UI on the LCD.

To have the device meet you on your own WiFi network instead, go to the serial
window and type `net add <ssid> <password>` (use quotes if your password has
spaces). You can, and should, set a password for the web interface from your
browser at `https://reticulous.local` or by typing `passwd` in the serial
monitor. Setting a password also lets you log in to the device command line with
`ssh admin@reticulous.local`.

Building it yourself is
[the more interesting path]({{ '/building/' | relative_url }}).
