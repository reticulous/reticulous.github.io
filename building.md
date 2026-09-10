---
title: Building
description: >-
  Install spangap, create a workspace, build Reticulous for your board and flash
  it. All the host needs is Docker, git and Python.
---

Much more interesting than just flashing your device is to install `spangap` and
compile for yourself.

At this very early stage of their development, both Spangap and Reticulous still
lack some of the documentation they will have soon. But to get you started if
you can't wait for everything to be finished, here is a very quick description of
how to build and flash the software.

## What the host needs

`docker`, installed and running, plus `python`, `git` and `curl`. Nothing will be
installed on your system outside of the spangap project directory you
initialize. The procedure below should work for Linux, Mac and possibly also for
Windows Subsystem for Linux — the latter untested as of now.

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

Leave `spangap monitor` running. It shows you the device log output, and once
we're done it will let you switch to CLI mode by simply typing a command.

Now open another terminal window and do:

```sh
cd reticulous && \
spangap build reticulous/reticulous --with spangap/hw-lilygo-tdeck && \
spangap flash
```

After downloading and building, it tells the monitor window to flash the
firmware. When that's done the device resets and comes alive.

## Building for a different board

Replace `hw-lilygo-tdeck` with any of the other board straddles listed in the
[overview]({{ '/overview/' | relative_url }}) — `hw-heltecv4`,
`hw-meshnology-w12`, `hw-wismesh-tap-v2` and the rest.

Leave off `--with ...` entirely to get the generic build, which works on any
ESP32-S3 with at least 4 MB of PSRAM and 8 MB of flash. To target a generic board
whose flash size you need to state, use `--flash-size <n>`, where `<n>` is the
number of megabytes of flash your ESP32-S3 has. Use `spangap probe [<serial
port>]` to find out whether your ESP32 has PSRAM and how much flash it has.

<div class="note info" markdown="1">
The build system, the straddle model and the container it all runs in are
documented on the [Spangap site](https://spangap.org/getting-started/).
</div>
