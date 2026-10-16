---
title: Building
description: >-
  Install spangap, create a workspace, build Reticulous for your board and flash
  it. All the host needs is Docker, git and Python.
---

Building Reticulous yourself takes one install and two commands. The
documentation is still catching up with the code, but this is enough to get a
build onto a board.

## What the host needs

Docker (installed and running), Python 3, git and curl. Everything else lands
inside the workspace directory you create. Linux and Mac work; Windows
Subsystem for Linux is untested.

## A worked example

Say you are in your home directory on a Mac, and want to build Reticulous and run
it on the LilyGo T-Deck Plus connected to `/dev/cu.usbmodem2101`.

First install `spangap`:

```sh
curl -fsSL https://spangap.org/install.sh | sh
```

Then create the workspace and start a serial monitor:

```sh
spangap init reticulous && \
cd reticulous && \
spangap monitor /dev/cu.usbmodem2101
```

Leave it running: it shows the device log, and later you can type commands
into it.

Now open another terminal window and do:

```sh
cd reticulous && \
spangap build reticulous/reticulous --with spangap/hw-lilygo-tdeck && \
spangap flash
```

This downloads the sources, builds, and hands the image to the monitor window
to flash. The device then reboots into Reticulous. The
[flashing page]({{ '/flashing/' | relative_url }}#after-it-boots) says how to
get it onto your WiFi and set a password.

## Building for a different board

Replace `hw-lilygo-tdeck` with any of the other board straddles listed in the
[overview]({{ '/overview/' | relative_url }}) — `hw-heltecv4`,
`hw-meshnology-w12`, `hw-wismesh-tap-v2` and the rest.

Leave off `--with ...` entirely to get the generic build, which works on any
ESP32-S3 with at least 4 MB of PSRAM and 8 MB of flash. For the generic build
you state the flash size: `--flash-size <n>`, with `<n>` the megabytes of flash
your board has. Use `spangap probe [<serial port>]` to find out whether your
ESP32 has PSRAM and how much flash it has.

<div class="note info" markdown="1">
The build system, the straddle model and the container it all runs in are
documented on the [Spangap site]({{ site.spangap_url }}/getting-started/).
</div>
