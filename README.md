<img src="assets/logo.svg" width="200" height="200" />

PIANOBERRY
==========


Headless* Pianoteq on Raspberry PI 5 with [pisound](https://blokas.io/pisound/) sound card.  
Tweaked for ~1.5ms latency at 96kHz sample rate.

<small>* Headless: without a monitor, keyboard, or mouse.</small>

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
