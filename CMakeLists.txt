cmake_minimum_required(VERSION 3.20.0)

# ============================================================================
# Platform Selection
# ============================================================================
# The PLATFORM_TARGET variable determines which hardware platform to build for.
# Currently supported platforms:
#   - pico: Raspberry Pi Pico (RP2040)
#
# Usage: cmake -Bbuild -DPLATFORM_TARGET=pico -DPICO_BOARD=pico_w -DLF_MAIN=Blink
# ============================================================================

if(NOT DEFINED PLATFORM_TARGET)
    message(FATAL_ERROR 
        "PLATFORM_TARGET must be specified.\n"
        "Available platforms: pico\n"
        "Usage: cmake -Bbuild -DPLATFORM_TARGET=pico -DPICO_BOARD=pico_w -DLF_MAIN=Blink")
endif()

# Set platform directory path
set(PLATFORM_DIR "${CMAKE_CURRENT_SOURCE_DIR}/platforms/${PLATFORM_TARGET}")

# Check if platform configuration exists
if(NOT EXISTS "${PLATFORM_DIR}/platform.cmake")
    message(FATAL_ERROR 
        "Platform '${PLATFORM_TARGET}' not found or not configured.\n"
        "Expected platform file: ${PLATFORM_DIR}/platform.cmake")
endif()

message(STATUS "Building for platform: ${PLATFORM_TARGET}")

# Include platform-specific configuration
# This will set up SDK initialization, toolchain, and platform-specific variables
include("${PLATFORM_DIR}/platform.cmake")

# Project definition
project(reactor-uc-freertos)
set(PLATFORM "FREERTOS" CACHE STRING "Platform to target")

if (NOT DEFINED LF_MAIN)
  set(LF_MAIN "HelloFreeRTOS")
endif()

if (NOT DEFINED LOG_LEVEL)
  set(LOG_LEVEL "LF_LOG_LEVEL_WARN")
endif()

# ============================================================================
# Lingua Franca Configuration
# ============================================================================

set(LF_MAIN_TARGET ${LF_MAIN})
add_executable(${LF_MAIN_TARGET})

# Check for Reactor-UC path
if(NOT DEFINED ENV{REACTOR_UC_PATH})
    message(FATAL_ERROR 
        "REACTOR_UC_PATH environment variable not set.\n"
        "Please set it to the path of the reactor-uc repository.")
endif()

include($ENV{REACTOR_UC_PATH}/cmake/lfc.cmake)

# Lingua Franca setup
lf_setup()
lf_run_lfc(${CMAKE_CURRENT_SOURCE_DIR}/src ${LF_MAIN})
lf_build_generated_code(${LF_MAIN_TARGET} ${CMAKE_CURRENT_SOURCE_DIR}/src-gen/${LF_MAIN})

# ============================================================================
# Platform-Specific Target Configuration
# ============================================================================
# Call the platform-specific configuration function
# This handles linking platform libraries, setting compile options, etc.
if(COMMAND platform_configure_target)
    platform_configure_target(${LF_MAIN_TARGET})
else()
    message(WARNING "platform_configure_target function not defined by platform '${PLATFORM_TARGET}'")
endif()