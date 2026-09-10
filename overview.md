---
title: Project overview
description: >-
  The straddle map of a Reticulous build: the Spangap platform underneath, the
  Reticulum stack and its interfaces, the apps, and the supported boards.
---

Everything is packaged as *straddles* — Spangap's self-contained modules, each
bundling an ESP-IDF firmware component and (where relevant) a browser app.
A Reticulous build layers the mesh stack and its apps on top of the Spangap
platform straddles, which provide the runtime, networking, web UI and LCD shell.

## The Spangap platform

See the [Spangap overview]({{ site.spangap_url }}/overview/) for detail.

- **`spangap`** — the build system and CLI: resolves dependencies, builds inside
  Docker, generates the boot glue, flashes and monitors.
- **`spangap-core`** — the base runtime: **`init`** (boot dispatcher),
  **`storage`** (device↔browser value store), **`its`** (the poll-free
  inter-task IPC everything rides on), **`fs`** (flash/SD filesystem),
  **`cli`**, **`auth`**, **`cron`**, **`logging`**, **`power-management`**,
  **`memory`** and **`ota`**.
- **`spangap-net`** — WiFi/IP: **`net`**, **`tls`**, **`ntp`**, **`mdns`**, plus
  optional remote-access services (**`acme`** certs, **`duckdns`**, **`upnp`**,
  **`wg`** WireGuard, **`sshd`**).
- **`spangap-web`** — the **`web`** HTTPS/WebDAV server, **`webrtc`**
  DataChannel plumbing and the browser-shell SPA that folds every straddle's UI
  into one web app.
- **`spangap-lcd`** — the phone-style LVGL UI (launcher, Settings/Log/CLI apps,
  VT100 terminal) that Reticulous draws its screens on.

## The Reticulous straddles

- **`reticulous`** — the buildable itself. It carries no firmware or board code,
  but ships the browser SPA, the LittleFS data image and the LCD icons, and
  pulls in the whole family below plus the Spangap platform. You build it *with*
  a board.
- **`rns`** — the Reticulum stack, centered on the `rnsd` task that owns the
  entire protocol engine: identity, destinations, the path table, the
  `Transport` state machine, `Link`s, `Resource`s and reliable in-order
  `Channel`s. It has no radio or IP of its own — interfaces plug in over `its`,
  and apps reach it through a byte-array C API.
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
- **`rnsh`** — a Reticulum remote shell (server *and* client) that bridges an
  already-encrypted mesh Channel into the device `cli` — the mesh-native
  analogue of SSH.
- **`maps`** — an offline slippy-map viewer on the LCD, blitting pre-baked,
  GPS-centered map tiles from SD. Not Reticulum-specific; it ships here as a
  feature straddle.

## Board support

These are the `--with` target, provided as Spangap-org straddles.

- **`spangap/hw-lilygo-tdeck`** — LilyGO T-Deck Plus: LoRa (SX1262), 320×240
  LCD, QWERTY keyboard, trackball, GNSS and microSD.
- **`spangap/hw-heltecv4`** — Heltec V4 LoRa board (headless).
- **`spangap/hw-meshnology-w12`** — Meshnology W12: LR2021 dual-band LoRa behind
  a 30 dBm front end, 0.96" OLED, GNSS header.
- **`spangap/hw-wismesh-tap-v2`** — RAK WisMesh TAP V2: handheld LoRa (SX1262)
  with a 2.8" capacitive touch screen, GNSS and microSD.
- **`spangap/hw-lilygo-tbeam-supreme`** — LilyGo T-Beam S3 Supreme: LoRa
  (SX1262), AXP2101-gated rails, GNSS, battery-backed RTC, 1.3" OLED, 18650
  holder.
- **`spangap/hw-waveshare-28b`** — Waveshare ESP32-S3-Touch-LCD-2.8B: a 2.8"
  480×640 RGB touch panel with an IMU, a battery-backed RTC and microSD. No
  radio beyond the SoC's own WiFi/BLE.
- **`spangap/hw-nibble-zero`** — Retia Nibble Zero: ESP32-S3-Zero + LoRa
  (SX1262), Flipper Zero add-on (headless).
- **`spangap/hw-xiao-esp32s3-sx1262`** — Seeed XIAO ESP32S3 + Wio-SX1262:
  thumb-sized LoRa (SX1262) kit (headless).
- **`spangap/hw-lilygo-t3s3-sx1262`** — LilyGo T3-S3 (LoRa32): SX1262 + microSD
  (headless).
