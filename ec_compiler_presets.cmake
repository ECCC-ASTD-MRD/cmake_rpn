# Copyright 2021, Her Majesty the Queen in right of Canada

# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

option(USE_ECCC_ENV_IF_AVAIL "Use ECCC's custom build environment" TRUE)

if(DEFINED ENV{EC_ARCH} AND USE_ECCC_ENV_IF_AVAIL)
   set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}")
   message(STATUS "(EC) Using ECCC presets: ${COMPILER_PRESET_PATH}")
 else()
   if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND CMAKE_SYSTEM_PROCESSOR MATCHES "unknown")
     exec_program(${CMAKE_UNAME} ARGS -m OUTPUT_VARIABLE CMAKE_SYSTEM_PROCESSOR)
   endif()
   set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
   message(STATUS "(EC) Using default presets: ${COMPILER_PRESET_PATH}")
endif()

# Defaults to C99
# TODO: Fix code and enable C99
#set(CMAKE_C_STANDARD 99)
#set(CMAKE_C_EXTENSIONS OFF)

include("ec_compiler_presets/${COMPILER_PRESET_PATH}")
