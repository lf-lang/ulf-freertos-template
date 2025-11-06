# ==============================================================================
# Pico (RP2040) Platform Configuration
# ==============================================================================
# This file contains platform-specific CMake configuration for Raspberry Pi Pico
#
# Required environment variables/CMake variables:
#   - PICO_SDK_PATH: Path to the Pico SDK
#   - FREERTOS_KERNEL_PATH (optional): Path to FreeRTOS kernel with RP2040 port
#                                       (auto-detected from submodule if not set)
#   - REACTOR_UC_PATH: Path to reactor-uc repository
#
# This file:
#   1. Locates and initializes the Pico SDK
#   2. Locates and imports the FreeRTOS kernel for RP2040
#   3. Defines platform_configure_target() function for target configuration
# ==============================================================================

message(STATUS "Configuring for Pico (RP2040) platform")

# Check for pico-sdk
if(NOT DEFINED PICO_SDK_PATH)
    if(DEFINED ENV{PICO_SDK_PATH})
        set(PICO_SDK_PATH $ENV{PICO_SDK_PATH})
        message(STATUS "Using PICO_SDK_PATH from environment: ${PICO_SDK_PATH}")
    else()
        # Try to find pico-sdk as a subdirectory
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pico-sdk/pico_sdk_init.cmake")
            set(PICO_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/pico-sdk")
            message(STATUS "Found pico-sdk in project directory: ${PICO_SDK_PATH}")
        else()
            message(FATAL_ERROR 
                "PICO_SDK_PATH not found. Please:\n"
                "  1. Set PICO_SDK_PATH environment variable, or\n"
                "  2. Pass -DPICO_SDK_PATH=<path> to cmake, or\n"
                "  3. Initialize pico-sdk as a git submodule in the project root")
        endif()
    endif()
endif()

# Initialize Pico SDK
include(${PICO_SDK_PATH}/pico_sdk_init.cmake)

# Check for FreeRTOS kernel path
# First check if FREERTOS_KERNEL_PATH is already set as a CMake variable
if(NOT DEFINED FREERTOS_KERNEL_PATH)
    if(DEFINED ENV{FREERTOS_KERNEL_PATH})
        set(FREERTOS_KERNEL_PATH $ENV{FREERTOS_KERNEL_PATH})
        message(STATUS "Using FREERTOS_KERNEL_PATH from environment: ${FREERTOS_KERNEL_PATH}")
    else()
        # Try to find FreeRTOS in the project as a submodule
        if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/FreeRTOS/FreeRTOS/Source")
            set(FREERTOS_KERNEL_PATH "${CMAKE_CURRENT_SOURCE_DIR}/FreeRTOS/FreeRTOS/Source")
            message(STATUS "Found FreeRTOS kernel in project submodule: ${FREERTOS_KERNEL_PATH}")
        else()
            message(FATAL_ERROR 
                "FREERTOS_KERNEL_PATH not found. Please:\n"
                "  1. Set FREERTOS_KERNEL_PATH environment variable, or\n"
                "  2. Pass -DFREERTOS_KERNEL_PATH=<path> to cmake, or\n"
                "  3. Initialize FreeRTOS submodule: git submodule update --init --recursive")
        endif()
    endif()
endif()

# Convert to absolute path to avoid issues with FreeRTOS_Kernel_import.cmake
# which resolves paths relative to CMAKE_BINARY_DIR
get_filename_component(FREERTOS_KERNEL_PATH "${FREERTOS_KERNEL_PATH}" ABSOLUTE BASE_DIR "${CMAKE_SOURCE_DIR}")
message(STATUS "Using absolute FREERTOS_KERNEL_PATH: ${FREERTOS_KERNEL_PATH}")

# Verify the FreeRTOS kernel path is valid
if(NOT EXISTS "${FREERTOS_KERNEL_PATH}/portable/ThirdParty/GCC/RP2040")
    message(FATAL_ERROR 
        "FreeRTOS RP2040 port not found at: ${FREERTOS_KERNEL_PATH}/portable/ThirdParty/GCC/RP2040\n"
        "Please ensure you have FreeRTOS-Kernel with RP2040 support.")
endif()

# Include FreeRTOS kernel for RP2040
include("${FREERTOS_KERNEL_PATH}/portable/ThirdParty/GCC/RP2040/FreeRTOS_Kernel_import.cmake")

# Set FreeRTOS config path to platform-specific include directory
set(FREERTOS_CONFIG_PATH "${PLATFORM_DIR}/include" CACHE PATH "FreeRTOS config path for Pico")
message(STATUS "Using FreeRTOS config from: ${FREERTOS_CONFIG_PATH}")

# Initialize Pico SDK (must be done after FreeRTOS setup but before project())
pico_sdk_init()

# Platform-specific function to configure the target executable
# This should be called after the target is created
function(platform_configure_target TARGET_NAME)
    message(STATUS "Configuring ${TARGET_NAME} for Pico platform")
    
    # Add platform-specific include directory for hooks.h, FreeRTOSConfig.h, and other headers
    target_include_directories(${TARGET_NAME} PRIVATE ${PLATFORM_DIR}/include)
    message(STATUS "Added platform include directory: ${PLATFORM_DIR}/include")
    
    # Add platform-specific source files
    target_sources(${TARGET_NAME} PRIVATE ${PLATFORM_DIR}/pico_freertos_hooks.c)
    message(STATUS "Added Pico FreeRTOS hooks implementation")

    # Link Pico SDK libraries
    target_link_libraries(${TARGET_NAME} PUBLIC 
        pico_stdlib 
        pico_sync
    )
    
    # Enable WiFi support if CYW43 is supported (Pico W)
    if(PICO_CYW43_SUPPORTED)
        target_link_libraries(${TARGET_NAME} PUBLIC pico_cyw43_arch_none)
        message(STATUS "CYW43 WiFi support enabled for Pico W")
    endif()
    
    # Enable USB and UART for stdio
    pico_enable_stdio_usb(${TARGET_NAME} 1)
    pico_enable_stdio_uart(${TARGET_NAME} 1)
    message(STATUS "Enabled USB and UART stdio")
    
    # Create additional Pico-specific outputs (UF2, etc.)
    pico_add_extra_outputs(${TARGET_NAME})
    message(STATUS "Added Pico-specific output formats (UF2, hex, bin)")
    
    # Apply platform-specific compiler options
    target_compile_definitions(${TARGET_NAME} PRIVATE 
        PICO_PLATFORM=1
    )
    
    message(STATUS "Pico platform configuration complete for ${TARGET_NAME}")
endfunction()
