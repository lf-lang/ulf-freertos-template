# micro-LF FreeRTOS Template

![Header](https://micro-lf.org/assets/header/freertos.svg)

- **Git:** <https://github.com/FreeRTOS/FreeRTOS>
- **Supported Boards:** <https://www.freertos.org/Documentation/02-Kernel/03-Supported-devices/00-Supported-devices>
- **Documentation:** <https://www.freertos.org/Documentation/02-Kernel/07-Books-and-manual/01-RTOS_book>
- **micro-LF Docs:** <https://micro-lf.org>

______________________________________________________________________

This is a template for micro-LF applications targeting FreeRTOS on embedded boards.

## Supported Platforms

- **Pico (RP2040)** — [Setup Guide](platforms/pico/README.md)

## 1. Prerequisites

### 1.1. Basic

- Install platform-specific dependencies (see your platform's README)
- Set required environment variables:
  - `REACTOR_UC_PATH` — Path to reactor-uc repository
  - Platform-specific variables (see platform README)

### 1.2. micro-LF

This template is for running micro-LF applications on embedded boards using FreeRTOS. It uses [reactor-uc](https://github.com/lf-lang/reactor-uc), the runtime that facilitates the execution. Clone this repo with one of the following commands:

#### Clone via HTTPS

```bash
git clone https://github.com/lf-lang/reactor-uc.git --recurse-submodules
```

#### Or Clone via SSH

```bash
git clone git@github.com:lf-lang/reactor-uc.git --recurse-submodules
```

And make sure that the `REACTOR_UC_PATH` environment variable is pointing to it.

## 2. Build Your Project

```bash
mkdir build && cd build
cmake -DPLATFORM_TARGET=pico ..
make
```

## 3. Flash to Device

Follow your platform's specific flashing instructions in the platform README.

## Project Structure

```
lf-freertos-uc-template/
├── CMakeLists.txt                # Main CMake configuration
├── CMakePresets.json             # CMake preset configurations
├── README.md                     # This file
├── platforms/                    # Platform-specific configurations
│   └── pico/                     # Raspberry Pi Pico platform
│       ├── include/              # Platform-specific headers
│       │   ├── FreeRTOSConfig.h  # Pico-specific FreeRTOS config
│       ├── platform.cmake        # Pico-specific CMake logic
│       ├── pico_freertos_hooks.c # Compilation bridge for hooks
│       └── README.md             # Pico setup guide
├── src/                          # micro-LF source files
│   ├── Blink.ulf                 # LED blink example
│   ├── HelloFreeRTOS.ulf         # Hello world example
│   ├── Timer.ulf                 # Timer example
│   └── lib/                      # Additional reactor libraries
└── FreeRTOS/                     # FreeRTOS submodule
```

## Adding New Platforms

To add support for a new platform:

1. Create a new directory under `platforms/<platform-name>/`;
1. Add `platform.cmake` with platform-specific configuration;
1. Add `FreeRTOSConfig.h` tuned for your platform;
1. (Optional) Implement FreeRTOS hooks if needed in `platforms/<platform-name>/<platform-name>_freertos_hooks.c`;
1. Create a `README.md` with setup instructions.
