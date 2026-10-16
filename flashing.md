---
title: Flashing
description: >-
  Three ways to get Reticulous onto a board: flashmon in the browser over USB,
  `spangap flash` from a workspace, or a downloaded image driven through
  esptool by hand.
---

There are three ways to put an image on a board.

## From a browser

Open **[flashmon]({{ '/flashmon/' | relative_url }})** in a Chromium-based
browser (desktop Chrome, Edge, Brave or Opera), plug your board in over USB, and
click through. It auto-detects which board you have, flashes the matching image
(or a generic one), and drops into a serial monitor — no toolchain, no build to
pick, and no install.

## After it boots

The device starts a WiFi access point whose name starts with `reticulous_`.
Connect to it and open `https://reticulous.local` for the web interface. A
board with a screen also shows a phone-like UI on the LCD.

To put the device on your own WiFi instead, type `net add <ssid> <password>`
in the serial monitor (quote the password if it has spaces). You can, and
should, set a password for the web interface from your browser at
`https://reticulous.local` or by typing `passwd` in the serial monitor. Setting
a password also lets you log in to the device command line with
`ssh admin@reticulous.local`.

flashmon keeps a serial monitor open in the tab it flashed from; in a
workspace, `spangap monitor <port>` does the same in a terminal. Once the
device is on a network you can also reach its command line from the web UI or
over `ssh`.

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

Use this on a machine without a Chromium browser, or from a CI job.

Building it yourself is
[the more interesting path]({{ '/building/' | relative_url }}).
