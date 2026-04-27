# Copyright 2021, Her Majesty the Queen in right of Canada

# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

cmake_minimum_required(VERSION 3.20)

# Set compiler presets only once (in case of projects cascades)
if (EC_INIT_DONE LESS 2)
    # CMAKE_BUILD_TYPE can be one of Debug, Release, RelWithDebInfo, MinSizeRel
    if (NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE "RelWithDebInfo")
        message(STATUS "(EC) No build type selected, default to ${CMAKE_BUILD_TYPE}")
    endif()
    message(STATUS "(EC) Configuring for ${CMAKE_BUILD_TYPE} build type")

    message(DEBUG "(EC) CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
    message(DEBUG "(EC) CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

    option(EXTRA_CHECKS "Compile with extra debug flags" OFF)
    option(WITH_PROFILING "Compile with profiling for tools like gprof" OFF)
    option(USE_ECCC_ENV_IF_AVAIL "Use ECCC's custom build environment" ON)
    option(STRICT "Enable stricter checks that may cause build-time errors on some code. Strongly recommended. Mandatory for production." OFF)
    message(DEBUG "(EC) USE_ECCC_ENV_IF_AVAIL=${USE_ECCC_ENV_IF_AVAIL}")

    # Retrieve CMake list of enabled languages.  The compiler preset files use this variable
    get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

    if(DEFINED ENV{EC_ARCH} AND USE_ECCC_ENV_IF_AVAIL)
        set(found "NOTFOUND")

        # We can use "cmake_path(HAS_FILENAME EC_ARCH hasComp)" here since if there is no "/",
        # the platform is specified in EC_ARCH but hasComp will be true. Furthermore, we can't
        # store the boolean result of the regex matches so we have this ugly construct
        set(hasComp FALSE)
        if(EC_ARCH MATCHES "/.+")
            set(hasComp TRUE)
        endif()

        if(hasComp)
            cmake_path(GET EC_ARCH FILENAME compName)
            # Try to load specified preset
            cmake_path(SET COMPILER_PRESET_PATH NORMALIZE "ECCC/$ENV{EC_ARCH}")
            include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)
        else()
            message(WARNING "(EC) WARNING: Compiler not specified, trying the compiler found by CMake")
            if("C" IN_LIST languages)
                string(TOLOWER ${CMAKE_C_COMPILER_ID} compName)
            elseif("Fortran" IN_LIST languages)
                string(TOLOWER ${CMAKE_Fortran_COMPILER_ID} compName)
            else()
                message(FATAL_ERROR "(EC) C and Fortran aren't enabled for this project; automatic compiler identification failed")
            endif()
            # Try to load a preset for the specified architecture and CMake detected compiler version
            cmake_path(SET COMPILER_PRESET_PATH NORMALIZE "ECCC/$ENV{EC_ARCH}/${compName}-${CMAKE_C_COMPILER_VERSION}")
            include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)
        endif()

        if(NOT found)
            message(WARNING "(EC) WARNING: Preset for the specific compiler version (${CMAKE_C_COMPILER_VERSION}) not found, trying without version")
            if(hasComp)
                cmake_path(GET EC_ARCH PARENT_PATH platform)
                # Strip away version, if any
                string(REGEX REPLACE "-.*" "" compName ${compName})
            else()
                set(platform "${EC_ARCH}")
            endif()
            cmake_path(SET COMPILER_PRESET_PATH NORMALIZE "ECCC/${platform}/${compName}")
            unset(platform)
            include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)
        endif()
        unset(hasComp)

        if(NOT found)
            # Final fallback to non optimized
            message(WARNING "(EC) WARNING: Specific preset $ENV{EC_ARCH} not found, falling back to non-optimized preset")
            cmake_path(SET COMPILER_PRESET_PATH NORMALIZE "ECCC/Linux_x86-64/${compName}")
            message("COMPILER_PRESET_PATH=${COMPILER_PRESET_PATH}")
            include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)
        endif()
        unset(compName)
    else()
        if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND CMAKE_SYSTEM_PROCESSOR MATCHES "unknown")
            execute_process(COMMAND ${CMAKE_UNAME} -m OUTPUT_VARIABLE CMAKE_SYSTEM_PROCESSOR_exec)
        endif()
        cmake_path(SET COMPILER_PRESET_PATH NORMALIZE "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
        include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)
    endif()

    if(NOT found)
        message(FATAL_ERROR "(EC) Failed to find a suitable compiler preset!")
    else()
        message(STATUS "(EC) Using compiler preset: ${COMPILER_PRESET_PATH}")
    endif()

    unset(languages)
endif()
