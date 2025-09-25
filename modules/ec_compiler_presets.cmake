# Copyright 2021, Her Majesty the Queen in right of Canada

# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

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
    option(STRICT "Enable stricter checks that may cause errors on some code. Strongly recommended. Mandatory for production." OFF)
    message(DEBUG "(EC) USE_ECCC_ENV_IF_AVAIL=${USE_ECCC_ENV_IF_AVAIL}")

    # Retrieve CMake list of enabled languages.  The compiler preset files use this variable
    get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

    if(DEFINED ENV{EC_ARCH} AND USE_ECCC_ENV_IF_AVAIL)
        set(found "NOTFOUND")
        if(${EC_ARCH} MATCHES "/")
            # Check for optimal preset
            set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}")
            include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)

            if(NOT found)
                # Otherwise default to non optimized
                message(WARNING "(EC) WARNING: Specific preset $ENV{EC_ARCH} not found, switching to default preset")
                get_filename_component(compName ${EC_ARCH} NAME)
                set(COMPILER_PRESET_PATH "ECCC/Linux_x86-64/${compName}")
                include("ec_compiler_presets/${COMPILER_PRESET_PATH}" OPTIONAL RESULT_VARIABLE found)
            endif()
        endif()

        if (NOT found)
            message(WARNING "(EC) WARNING: No compiler is loaded, looking for compiler information")
            if("C" IN_LIST languages)
                string(TOLOWER ${CMAKE_C_COMPILER_ID} compName)
            elseif("Fortran" IN_LIST languages)
                string(TOLOWER ${CMAKE_Fortran_COMPILER_ID} compName)
            else()
                message(FATAL_ERROR "C and Fortran aren't enabled for this project; automatic compiler identification failed")
            endif()
            set(COMPILER_PRESET_PATH "ECCC/$ENV{EC_ARCH}/${compName}-${CMAKE_C_COMPILER_VERSION}")
            unset(compName)
            include("ec_compiler_presets/${COMPILER_PRESET_PATH}")
        endif()

        message(STATUS "(EC) Using ECCC presets: ${COMPILER_PRESET_PATH}")
    else()
        if(CMAKE_SYSTEM_NAME MATCHES "Linux" AND CMAKE_SYSTEM_PROCESSOR MATCHES "unknown")
            execute_process(COMMAND ${CMAKE_UNAME} -m OUTPUT_VARIABLE CMAKE_SYSTEM_PROCESSOR_exec)
        endif()
        set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}")
        message(STATUS "(EC) Using default presets: ${COMPILER_PRESET_PATH}")
        include("ec_compiler_presets/${COMPILER_PRESET_PATH}")
    endif()

    unset(languages)
endif()
