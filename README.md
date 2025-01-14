# This repository is archived. Future development will happen at [elektrofon/pianoberry](https://github.com/elektrofon/pianoberry). This archive is left as a guide on how to approach building a custom Raspberry OS with the official pi-gen tool

<img src="assets/logo.svg" width="200" height="200" />

PIANOBERRY
==========


Headless* [Pianoteq](https://www.modartt.com/pianoteq_overview) on Raspberry PI 5 with [Pisound](https://blokas.io/pisound/) sound card.  
Tweaked for ~10 seconds boot time and ~1.5ms latency at 96kHz sample rate.

<small>* Headless: without a monitor, keyboard, or mouse.</small>

## Trying

1. Download the [latest image](https://github.com/elektrofon/pianoberry-debian/releases/latest)
2. Flash the image to a microSD card using [Raspberry Pi Imager](https://www.raspberrypi.org/software/)
3. Insert the microSD card into the Raspberry PI 5 with a Pisound sound card
4. Connect a MIDI keyboard to the Pisound MIDI input
5. Play!

## Building

## Download Pianoteq 8

Download the Pianoteq 8 ARM64 version from the [Pianoteq website](https://www.pianoteq.com/download).  
Place the `Pianoteq 8` binary file in the `pianoberry/00-pianoberry/files` directory.

### Install dependencies and configure

```bash
./configure
```

### Building Raspberry PI image

```bash
./build.sh
```

The image will be created in the `pi-gen/deploy` directory.
