# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

message(STATUS "CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

option(USE_ECCC_ENV_IF_AVAIL "Use ECCC's custom build environment" TRUE)
message(STATUS "USE_ECCC_ENV_IF_AVAIL=${USE_ECCC_ENV_IF_AVAIL}")

if(USE_ECCC_ENV_IF_AVAIL)
    if(DEFINED ENV{EC_ARCH})
        message(STATUS "Using ECCC presets")
        set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}")
        add_definitions(-DEC_ARCH="$ENV{EC_ARCH}")
    else()
        message(WARNING "EC_ARCH environment variable not found!  Falling back on default presets")
        set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
    endif()
else()
    message(STATUS "Using default presets")
    set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
endif()

message(STATUS "Loading preset ${COMPILER_PRESET_PATH}")
include("ec_compiler_presets/${COMPILER_PRESET_PATH}")