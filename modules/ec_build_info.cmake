# Copyright 2021, Her Majesty the Queen in right of Canada

# For GET_MESSAGE_LOG_LEVEL
cmake_minimum_required(VERSION 3.25)

include(${CMAKE_CURRENT_LIST_DIR}/ec_debugLog.cmake)

function(ec_build_info)
    message(STATUS "(EC) Adding build_info target")

    set(BUILD_INFO_OUTPUT_DIR ${ARGV0})

    cmake_language(GET_MESSAGE_LOG_LEVEL LOG_LEVEL)
    debugLogVar("ec_build_info" "LOG_LEVEL")

    # Variables from the current CMake execution environment have to be passed
    # with "-D" since they will not be available when executed with "-P"
    add_custom_target(
        "${PROJECT_NAME}_build_info"
        ALL
        COMMAND "${CMAKE_COMMAND}" 
            "-DPROJECT_NAME=${PROJECT_NAME}"
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

    include_directories(${CMAKE_CURRENT_BINARY_DIR})

    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_build_info.h TYPE INCLUDE)
endfunction()
