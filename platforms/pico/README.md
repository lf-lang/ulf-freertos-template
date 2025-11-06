# Pico (RP2040) Platform

This directory contains platform-specific configuration for the Raspberry Pi Pico (RP2040) microcontroller.

## Setup 

Create a new repository based on this template, clone it recursively to your local machine, and enter
the directory from your favorite shell.

Install a toolchain by following these instructions: <https://www.lf-lang.org/embedded-lab/Non-Nix.html#install-cmake-standard-c-library-arm-cross-compiler>

Install the picotool as described here: <https://www.lf-lang.org/embedded-lab/Non-Nix.html#install-picotool>

Make sure that the `FreeRTOS` submodule is initialized:

```sh
git submodule update --init --recursive
```


## Flashing

Before flashing the binary to your RP2040-based board, the board must be placed into `BOOTSEL` mode. On a [Raspberry Pi Pico](https://www.raspberrypi.com/products/raspberry-pi-pico/), this can be entered by holding the `BOOTSEL` button while connecting the board to the host device. Run `picotool help` for more information on its capabilities.

Run the following to flash an application binary onto your board:

```shell
picotool load -x bin/Blink.elf
```

## Platform-Specific Features

### USB and UART Output
- Both USB and UART stdio are enabled by default
- USB: Connect to your computer and use a serial terminal (e.g., `minicom`, `screen`, or PuTTY)
- UART: Connect GPIO 0 (TX) and GPIO 1 (RX) to a USB-to-serial adapter

### Pico W WiFi Support
If you're using a Pico W (with CYW43 WiFi chip), the WiFi libraries are automatically linked.

### Clock Configuration
- Default CPU clock: 133 MHz (configurable in FreeRTOSConfig.h)
- FreeRTOS tick rate: 100 Hz

### Memory Configuration
- Total heap size: 128 KB (configurable in FreeRTOSConfig.h)
- Stack depth type: uint32_t

## Additional Resources

- [Pico Getting Started Guide](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf)
- [Pico C/C++ SDK Documentation](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-c-sdk.pdf)
- [FreeRTOS Documentation](https://www.freertos.org/Documentation/02-Kernel/07-Books-and-manual/01-RTOS_book)
- [Reactor-uc Documentation](https://github.com/lf-lang/reactor-uc)
