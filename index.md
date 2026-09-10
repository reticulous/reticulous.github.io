---
title: Home
hero: A Reticulum node on a board in your pocket.
description: >-
  Reticulous implements the Reticulum mesh networking stack for ESP32 boards,
  with LXMF messaging, Nomad Network browsing, a web interface, an LCD shell
  and remote management over the mesh.
---

**Reticulous** implements the Reticulum mesh networking stack for ESP32 embedded
systems and boards. It comes with a rich set of tools to do LXMF messaging and
Nomad micron mesh browsing, and implements some things — such as `rnsh` remote
management — not normally found on Reticulum nodes on embedded systems.

Reticulous is built on top of the brand new [**Spangap**]({{ site.spangap_url }}/)
*Device Application Framework*. In fact, it was developed in parallel with it,
yielding both a highly capable Reticulum node and a demonstration of what
Spangap can do. In a nutshell, Spangap provides layers on top of the ESP32's
RTOS/ESP-IDF that cover everything from facilities for more powerful
multitasking, via a modern web interface, a powerful CLI and SSH, all the way to
making mobile-phone-style apps for small LCD screens — so makers of embedded
firmware can start with a rich environment all ready to go.

<ul class="cards">
<li><a href="{{ '/flashing/' | relative_url }}"><b>Flash a board</b><span>Plug in over USB and click through in a browser. No toolchain, no install.</span></a></li>
<li><a href="{{ '/building/' | relative_url }}"><b>Build it yourself</b><span>Docker, git and Python is all the host needs. One command per board.</span></a></li>
<li><a href="{{ '/overview/' | relative_url }}"><b>What is in it</b><span>The straddle map: the Reticulum stack, the interfaces, the apps.</span></a></li>
</ul>

<div class="note warning" markdown="1">
**It is really early days.** Some stuff doesn't work yet, some stuff looks ugly.
You are literally one of the very first users. Things will shift, and important
bits are either missing or will change shape.
</div>

## Supported hardware

Reticulous ships ready-made hardware support modules — Spangap calls them
*straddles* — for a growing list of boards: the LilyGO T-Deck Plus, the Heltec
V4, the Meshnology W12, the RAK WisMesh TAP V2, the LilyGo T-Beam S3 Supreme,
the Waveshare ESP32-S3-Touch-LCD-2.8B, the Retia Nibble Zero, the Seeed XIAO
ESP32S3 with Wio-SX1262, and the LilyGo T3-S3. They are listed with their radios
and peripherals in the [overview]({{ '/overview/' | relative_url }}).

Without any special hardware support, the generic version will have no mesh
radio, but will still do Reticulum mesh over WiFi and let you use the system via
a browser or the command line interface, accessible over serial and SSH. It
should run on any ESP32-S3 hardware provided it has some amount of PSRAM and
flash — 4 MB or more of PSRAM and 8 MB or more of flash would be ideal. Support
for the many other ESP32-S3 boards with LoRa radios and/or LCD/touch screens can
be built and is forthcoming.

## Where to start

Much more interesting than just flashing your device is to install `spangap` and
compile for yourself — but the fastest way to see what this is is to
[put a ready-made image on a board]({{ '/flashing/' | relative_url }}).
