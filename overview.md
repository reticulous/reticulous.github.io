---
title: Project overview
description: >-
  The straddle map of a Reticulous build: the supported boards, the Reticulum
  stack and its interfaces, the apps, and the Spangap platform underneath.
---

A Reticulous firmware is assembled from *straddles*, Spangap's modules: each is
a firmware component plus, where it has one, a browser app. The Spangap
straddles provide the runtime, networking, web UI and LCD shell; the Reticulous
straddles add the mesh stack and its apps.

## Board support

One of these goes after `--with` when you build. They live in the Spangap
GitHub organisation.

- **`spangap/hw-lilygo-tdeck`** — LilyGO T-Deck Plus: LoRa (SX1262), 320×240
  LCD, QWERTY keyboard, trackball, GNSS and microSD.
- **`spangap/hw-heltecv4`** — Heltec V4 LoRa board (headless).
- **`spangap/hw-meshnology-w12`** — Meshnology W12: LR2021 dual-band LoRa behind
  a 30 dBm front end, 0.96" OLED, GNSS header.
- **`spangap/hw-wismesh-tap-v2`** — RAK WisMesh TAP V2: handheld LoRa (SX1262)
  with a 2.8" capacitive touch screen, GNSS and microSD.
- **`spangap/hw-lilygo-tbeam-supreme`** — LilyGo T-Beam S3 Supreme: LoRa
  (SX1262), GNSS, battery-backed clock, 1.3" OLED, 18650 holder.
- **`spangap/hw-waveshare-28b`** — Waveshare ESP32-S3-Touch-LCD-2.8B: a 2.8"
  480×640 RGB touch panel with an IMU, a battery-backed RTC and microSD. No
  radio beyond the SoC's own WiFi/BLE.
- **`spangap/hw-nibble-zero`** — Retia Nibble Zero: ESP32-S3-Zero + LoRa
  (SX1262), Flipper Zero add-on (headless).
- **`spangap/hw-xiao-esp32s3-sx1262`** — Seeed XIAO ESP32S3 + Wio-SX1262:
  thumb-sized LoRa (SX1262) kit (headless).
- **`spangap/hw-lilygo-t3s3-sx1262`** — LilyGo T3-S3 (LoRa32): SX1262 + microSD
  (headless).
- **`spangap/hw-lilygo-t3s3-lr1121`** — LilyGo T3-S3 (LoRa32): dual-band LR1121
  + microSD (headless).

## The Reticulous straddles

- **`reticulous`** — the top-level straddle you build. It has no firmware code
  of its own: it ships the browser app, the data image and the LCD icons, and
  pulls in everything below plus the Spangap platform. You build it together
  with a board straddle.
- **`rns`** — the Reticulum stack: identities, destinations, the path table,
  transport, links, resources and channels, all in one `rnsd` task. It has no
  radio or IP of its own: the interface straddles below plug into it, and apps
  talk to it through a C API.
- **`iface-tcp`** — Reticulum over plain TCP/IP (outbound peers plus an inbound
  server), HDLC-framed to interop with desktop Reticulum.
- **`iface-lora`** — Reticulum over LoRa radios via RadioLib (SX126x / SX127x /
  SX128x / LR11x0 / LR2021), up to four on one SPI bus.
- **`iface-espnow`** — Reticulum over Espressif ESP-NOW using the long-range
  PHY, one RNS packet per frame.
- **`iface-auto`** — zero-config AutoInterface over the local WiFi LAN,
  wire-compatible with upstream Reticulum's `AutoInterface`.
- **`lxmf`** — the LXMF messaging mailbox: sends and receives signed messages,
  holds up to four identities, pays and enforces proof-of-work stamps, and
  interoperates wire-for-wire with Sideband, NomadNet and MeshChat.
- **`nomad`** — a Nomad Network "text web" client for browsing Micron pages and
  files hosted on `nomadnetwork.node` destinations over Reticulum Links.
- **`rnsh`** — a remote shell over Reticulum, server and client: SSH, but over
  the mesh, into the device command line.
- **`maps`** — an offline map viewer on the LCD, drawing pre-rendered tiles
  from the SD card around the GPS position.

## The Spangap platform

Underneath it all: **`spangap`**, the build system; **`spangap-core`**, the
runtime (boot, settings store, inter-task messaging, filesystem, command line,
authentication, cron, logging, power management, OTA); **`spangap-net`**, WiFi
and IP with the optional remote-access services (certificates, dynamic DNS,
port mapping, WireGuard, SSH); **`spangap-web`**, the web server and the
browser shell that folds every straddle's UI into one web app; and
**`spangap-lcd`**, the phone-style UI that Reticulous draws its screens on.
The [Spangap overview]({{ site.spangap_url }}/overview/) describes each of
them.
