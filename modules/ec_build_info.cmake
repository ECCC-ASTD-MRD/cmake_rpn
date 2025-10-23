# Copyright 2021, Her Majesty the Queen in right of Canada

# For GET_MESSAGE_LOG_LEVEL
cmake_minimum_required(VERSION 3.25)

include(${CMAKE_CURRENT_LIST_DIR}/ec_debugLog.cmake)

function(ec_build_info)
    # Parameters:
    #     ARGV0 : Path of the folder where to write ${PROJECT_NAME}_build_info.h
    #             Optional; defaults to CMAKE_CURRENT_BINARY_DIR if not specified or is empty
    #     ARGV1 : Boolean to toggle the installation of ${PROJECT_NAME}_build_info.h
    #             Optional; defaults to false.
    #             Since it's the second positional parameter, both parameters must be specified in order to change this one
    message(STATUS "(EC) Adding build_info target")

    set(BUILD_INFO_OUTPUT_DIR ${ARGV0} PARENT_SCOPE)

    cmake_language(GET_MESSAGE_LOG_LEVEL LOG_LEVEL)
    debugLogVar("ec_build_info" "LOG_LEVEL")

    string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" PROJECT_NAME_C_ID)

    # Variables from the current CMake execution environment have to be passed
    # with "-D" since they will not be available when executed with "-P"
    add_custom_target(
        "${PROJECT_NAME}_build_info"
        ALL
        COMMAND "${CMAKE_COMMAND}"
            "-DPROJECT_NAME=${PROJECT_NAME}"
            "-DPROJECT_NAME_C_ID=${PROJECT_NAME_C_ID}"
            "-DVERSION_FROM_MANIFEST=${VERSION_FROM_MANIFEST}"
            "-DPROJECT_VERSION=${PROJECT_VERSION}"
            "-DPROJECT_DESCRIPTION=${DESCRIPTION}"
            "-DSOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}"
            "-DCMAKE_C_COMPILER_ID=${CMAKE_C_COMPILER_ID}"
            "-DCMAKE_C_COMPILER_VERSION=${CMAKE_C_COMPILER_VERSION}"
            "-DCMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}"
            "-DCMAKE_CXX_COMPILER_VERSION=${CMAKE_CXX_COMPILER_VERSION}"
            "-DCMAKE_Fortran_COMPILER_ID=${CMAKE_Fortran_COMPILER_ID}"
            "-DCMAKE_Fortran_COMPILER_VERSION=${CMAKE_Fortran_COMPILER_VERSION}"
            "-DWITH_OPENMP=${WITH_OPENMP}"
            "-DMANIFEST_FILE_PATH=${MANIFEST_FILE_PATH}"
            "-DBUILD_INFO_OUTPUT_DIR=${BUILD_INFO_OUTPUT_DIR}"
            -P "${EC_CMAKE_RPN_DIR}/ec_build_info_maketime.cmake"
            "--log-level=${LOG_LEVEL}"
        BYPRODUCTS "${PROJECT_NAME}_build_info.h"
        COMMENT "Generating ${PROJECT_NAME}_build_info.h"
    )

    # We need BUILD_INFO_OUTPUT_DIR to be defined in the rest of the function
    # but we don't want to set it in the parent scope if it wasn't already done
    if("${BUILD_INFO_OUTPUT_DIR}" STREQUAL "")
        set(BUILD_INFO_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    endif()
    include_directories(${CMAKE_CURRENT_BINARY_DIR})

    if(NOT CMAKE_SKIP_INSTALL_RULES)
        if(ARGV1)
            message(STATUS "(EC) ${PROJECT_NAME}_build_info.h will be installed")
            install(FILES ${BUILD_INFO_OUTPUT_DIR}/${PROJECT_NAME}_build_info.h TYPE INCLUDE)
        endif()
    endif()
endfunction()


# Add the build_info c source file to each of the provided targets
function(ec_add_build_info_to_targets)
    # Parameters:
    # [in] List of targets to which to add the build info

    if("${BUILD_INFO_OUTPUT_DIR}" STREQUAL "")
        set(BUILD_INFO_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    endif()
    set(BUILD_INFO_PATH ${BUILD_INFO_OUTPUT_DIR}/${PROJECT_NAME}_build_info.c)

    string(MAKE_C_IDENTIFIER "${PROJECT_NAME}" PROJECT_NAME_C_ID)

    # Generate the build_info c file. Once generated, it content never changes so we can do with here
    configure_file(${CMAKE_CURRENT_FUNCTION_LIST_DIR}/build_info.c.in ${BUILD_INFO_PATH} @ONLY)

    # TODO: Figure out how to add it to the sources of all of a project's targets
    foreach(target ${ARGV})
        target_sources(${target} PRIVATE ${BUILD_INFO_PATH})
    endforeach()
endfunction()