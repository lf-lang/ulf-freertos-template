# Reactor-uc FreeRTOS Template

Multi-platform template for building Lingua Franca applications with FreeRTOS.

## Supported Platforms

- **Pico (RP2040)** - [Setup Guide](platforms/pico/README.md)

## Quick Start

### 1. Prerequisites

- Install platform-specific dependencies (see your platform's README)
- Set required environment variables:
  - `REACTOR_UC_PATH` - Path to reactor-uc repository
  - Platform-specific variables (see platform README)

### 2. Build Your Project

```bash
mkdir build && cd build
cmake -DPLATFORM_TARGET=pico ..
make
```

### 3. Flash to Device

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
├── src/                          # Your Lingua Franca source files
│   ├── Blink.lf                  # LED blink example
│   ├── HelloFreeRTOS.lf          # Hello world example
│   ├── Timer.lf                  # Timer example
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

## Resources

- **Git:** <https://github.com/espressif/esp-idf>
- **Supported Boards:** <https://www.freertos.org/Documentation/02-Kernel/03-Supported-devices/00-Supported-devices>
- **Documentation:** <https://www.freertos.org/Documentation/02-Kernel/07-Books-and-manual/01-RTOS_book>
- **Additional Resources:**
  - [Reactor-uc](https://github.com/lf-lang/reactor-uc)
  - [Lingua Franca](https://github.com/lf-lang/lingua-franca)
