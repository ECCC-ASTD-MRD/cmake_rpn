# Copyright 2021, Her Majesty the Queen in right of Canada

# This file is used by the build_info target and will be parsed whenever make is invoked

include(${CMAKE_CURRENT_LIST_DIR}/ec_git_version.cmake)

# When a CMake script is executed with "-P", CMAKE_SOURCE_DIR is the current dir
# Since we don't want that, we force it.  CMAKE_CURRENT_SOURCE_DIR must also be fudged
# If this isn't done, git won't be able to find the version for out-of-tree builds
set(CMAKE_SOURCE_DIR "${SOURCE_DIR}")
set(CMAKE_CURRENT_SOURCE_DIR "${SOURCE_DIR}")

ec_git_version()

set(EC_ARCH $ENV{EC_ARCH})
set(EC_USER $ENV{USER})
string(TIMESTAMP BUILD_TIMESTAMP UTC)

# Provide old behaviour if BUILD_INFO_OUTPUT_DIR is not defined
if("${BUILD_INFO_OUTPUT_DIR}" STREQUAL "")
    set(BUILD_INFO_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
endif()
message(STATUS "(EC) BUILD_INFO_OUTPUT_DIR=${BUILD_INFO_OUTPUT_DIR}")

configure_file(${CMAKE_CURRENT_LIST_DIR}/build_info.h.in ${BUILD_INFO_OUTPUT_DIR}/${PROJECT_NAME}_build_info.h @ONLY)
