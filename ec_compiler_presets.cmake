# Copyright 2021, Her Majesty the Queen in right of Canada

# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently


# CMAKE_BUILD_TYPE can be one of Debug, Release, RelWithDebInfo, MinSizeRel
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "RelWithDebInfo")
  message(STATUS "(EC) No build type selected, default to ${CMAKE_BUILD_TYPE}")
endif()
message(STATUS "(EC) Configuring for ${CMAKE_BUILD_TYPE} build type")

#message(DEBUG "(EC) CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
#message(DEBUG "(EC) CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

option(USE_ECCC_ENV_IF_AVAIL "Use ECCC's custom build environment" TRUE)
#message(DEBUG "(EC) USE_ECCC_ENV_IF_AVAIL=${USE_ECCC_ENV_IF_AVAIL}")


if(DEFINED ENV{EC_ARCH} AND USE_ECCC_ENV_IF_AVAIL)
    if(${EC_ARCH} MATCHES "/")
        set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}")
    else()
        message(WARNING "(EC) Looks like no compiler is loaded!")
        string(TOLOWER ${CMAKE_C_COMPILER_ID} compName)
        message(STATUS "Trying to use what CMake found (${compName}-${CMAKE_C_COMPILER_VERSION})")
        set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}/${compName}-${CMAKE_C_COMPILER_VERSION}")
        unset(compName)
    endif()
    message(STATUS "(EC) Using ECCC presets: ${COMPILER_PRESET_PATH}")
else()
    if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND CMAKE_SYSTEM_PROCESSOR MATCHES "unknown")
        exec_program(${CMAKE_UNAME} ARGS -m OUTPUT_VARIABLE CMAKE_SYSTEM_PROCESSOR)
    endif()
    set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
    message(STATUS "(EC) Using default presets: ${COMPILER_PRESET_PATH}")
endif()

# TODO: Fix code and enable C99
#set(CMAKE_C_STANDARD 99)
#set(CMAKE_C_EXTENSIONS OFF)

# Retreive CMake's list of eabled languages.  The compiler preset files use this variable
get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)
include("ec_compiler_presets/${COMPILER_PRESET_PATH}")
unset(languages)
