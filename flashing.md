---
title: Flashing
description: >-
  Three ways to get Reticulous onto a board: from a Chromium browser over USB,
  from the command line with a single-file flasher, or fully offline from a zip.
---

<div class="note warning" markdown="1">
**It is really early days.** Some stuff doesn't work yet, some stuff looks ugly.
You're literally one of the very first users.
</div>

If you just want to flash a unit, pick whichever of these fits your machine.

## From a browser

Open **[reticulous.net/flashmon](https://reticulous.net/flashmon)** in a
Chromium-based browser (desktop Chrome, Edge, Brave or Opera), plug your board in
over USB, and click through. It auto-detects which board you have, flashes the
matching image (or a generic one), and drops into a serial monitor — no
toolchain, no build to pick, and no install.

## From the command line

No Chromium browser, or you'd rather flash from a terminal? Grab the single-file
terminal flasher. It already knows where to fetch from, so it takes no
arguments:

```sh
curl -O https://reticulous.net/flashmon/reticulous-flashmon
chmod +x reticulous-flashmon
./reticulous-flashmon
```

Only Python 3.8+ is needed. On first run it sets up its own tools in a private
folder — nothing system-wide, no admin — then picks your serial port, detects
the board, flashes, and opens a monitor.

## Fully offline

No internet on the target machine, or no Python at all? Download the
self-contained
[**offline installer**](https://reticulous.net/flashmon/offline-installer/). It's
one cross-platform zip bundling the flasher, the firmware images and the
flashing tools, so it runs on a machine with no internet and no toolchain: unzip
it, run the `reticulous-flashmon` script inside, and it flashes and monitors
like the command-line flasher above.

<div class="note info" markdown="1">
On Windows, run `python reticulous-flashmon` from the unzipped folder.
</div>

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
