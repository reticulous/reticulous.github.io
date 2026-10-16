---
title: Home
hero: A Reticulum node on a board in your pocket.
description: >-
  Reticulous implements the Reticulum mesh networking stack for ESP32 boards,
  with LXMF messaging, Nomad Network browsing, a web interface, an LCD shell
  and remote management over the mesh.
---

**Reticulous** implements the Reticulum mesh networking stack for ESP32 embedded
systems and boards. It does LXMF messaging and Nomad Network browsing, and adds
things embedded Reticulum nodes usually lack, such as remote shell access with
`rnsh`.

Reticulous is built on [**Spangap**]({{ site.spangap_url }}/), a new framework
for ESP32 firmware that was developed alongside it. Spangap provides the
multitasking, the web interface, the command line, SSH and the phone-style apps
on the LCD, so Reticulous only has to be about Reticulum.

<ul class="cards">
<li><a href="{{ '/flashing/' | relative_url }}"><b>Flash a board</b><span>Plug in over USB and click through in a browser. No toolchain, no install.</span></a></li>
<li><a href="{{ '/building/' | relative_url }}"><b>Build it yourself</b><span>Docker, git and Python is all the host needs. One command per board.</span></a></li>
<li><a href="{{ '/overview/' | relative_url }}"><b>What's inside</b><span>The Reticulum stack, the interfaces, the apps, and the supported boards.</span></a></li>
</ul>

<figure class="shot">
<button type="button"><img src="{{ '/assets/img/web-ui.png' | relative_url }}" width="3200" height="2400" alt="The Reticulous web interface: overlapping windows above a dock, showing the SSH settings pane, an LXMF conversation, a CLI running rnsh into another node, the Nomad Network browser on a forum page, and a live log."></button>
<figcaption>The web interface a board serves: settings, LXMF messaging, the command
line, the Nomad Network browser and the live log, all of it out of the ESP32 in
your hand. Click to enlarge.</figcaption>
</figure>

## Supported hardware

Reticulous runs on a growing list of boards: the LilyGO T-Deck Plus, the Heltec
V4, the Meshnology W12, the RAK WisMesh TAP V2, the LilyGo T-Beam S3 Supreme,
the Waveshare ESP32-S3-Touch-LCD-2.8B, the Retia Nibble Zero, the Seeed XIAO
ESP32S3 with Wio-SX1262, and the LilyGo T3-S3. They are listed with their radios
and peripherals in the [overview]({{ '/overview/' | relative_url }}).

On any other ESP32-S3 with PSRAM, the generic build has no LoRa radio but still
does Reticulum over WiFi, with the web interface, the serial console and SSH.
4 MB of PSRAM and 8 MB of flash or more is ideal. Support for more boards is
coming.

## Where to start

The fastest way to see what this is: [put a ready-made image on a
board]({{ '/flashing/' | relative_url }}) from your browser. Once you've seen
it, [building it yourself]({{ '/building/' | relative_url }}) is the more
interesting path.
