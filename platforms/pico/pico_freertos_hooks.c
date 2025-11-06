/**
 * @file pico_freertos_hooks.c
 * @brief FreeRTOS hook implementations for Raspberry Pi Pico (RP2040)
 * 
 * This file provides default weak implementations of FreeRTOS hook functions
 * specific to the Pico platform. Users can override these by providing their
 * own implementations.
 * 
 * Included hooks:
 * - vApplicationMallocFailedHook()   - Called on heap allocation failure
 * - vApplicationStackOverflowHook()  - Called on task stack overflow
 * - vApplicationIdleHook()           - Called during idle task execution
 * - vApplicationTickHook()           - Called on each tick interrupt
 * 
 * @note All implementations use __attribute__((weak)) and can be overridden.
 * @note This file must be compiled to ensure weak symbols are available to linker.
 * 
 * @see platforms/pico/include/hooks.h for the actual implementations
 * 
 * Platform: Raspberry Pi Pico (RP2040)
 * Date: October 31, 2025
 */

#include "hooks.h"

/* 
 * The hooks.h header contains weak implementations of all FreeRTOS hook functions.
 * This compilation unit ensures those weak symbols exist in the final binary.
 * 
 * Without this file, the linker would not find the hook function definitions,
 * resulting in undefined reference errors.
 */
