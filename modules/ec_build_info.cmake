# Copyright 2021, Her Majesty the Queen in right of Canada

function(ec_build_info)
    message(STATUS "(EC) Adding build_info target")

    set(BUILD_INFO_OUTPUT_DIR ${ARGV0})

    # Variables from the current CMake execution environment have to be passed
    # with "-D" since they will not be available when executed with "-P"
    add_custom_target(
        "${PROJECT_NAME}_build_info"
        ALL
        COMMAND "${CMAKE_COMMAND}" 
            "-DPROJECT_NAME=${PROJECT_NAME}"
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
            "-DBUILD_INFO_OUTPUT_DIR=${BUILD_INFO_OUTPUT_DIR}"
            -P "${EC_CMAKE_RPN_DIR}/ec_build_info_maketime.cmake"
        BYPRODUCTS "${PROJECT_NAME}_build_info.h"
        COMMENT "Generating ${PROJECT_NAME}_build_info.h"
    )
    include_directories(${CMAKE_CURRENT_BINARY_DIR})
endfunction()
