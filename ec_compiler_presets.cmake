# Copyright 2021, Her Majesty the Queen in right of Canada

# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

#message(DEBUG "(EC) CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
#message(DEBUG "(EC) CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

option(USE_ECCC_ENV_IF_AVAIL "Use ECCC's custom build environment" TRUE)
#message(DEBUG "(EC) USE_ECCC_ENV_IF_AVAIL=${USE_ECCC_ENV_IF_AVAIL}")

if(DEFINED ENV{EC_ARCH} AND USE_ECCC_ENV_IF_AVAIL)
   set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}")
   message(STATUS "(EC) Using ECCC presets: ${COMPILER_PRESET_PATH}")
else()
   set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
   message(STATUS "(EC) Using default presets: ${COMPILER_PRESET_PATH}")
endif()

# Defaults to C99
# TODO: Fix code and enable C99
#set(CMAKE_C_STANDARD 99)
#set(CMAKE_C_EXTENSIONS OFF)

include("ec_compiler_presets/${COMPILER_PRESET_PATH}")
