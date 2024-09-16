# Copyright 2021, Her Majesty the Queen in right of Canada

# This file is used by the build_info target and will be parsed whenever make is invoked

# When a CMake script is executed with "-P", CMAKE_SOURCE_DIR is the current dir
# Since we don't want that, we force it.  CMAKE_CURRENT_SOURCE_DIR must also be fudged
# If this isn't done, git won't be able to find the version for out-of-tree builds
set(CMAKE_SOURCE_DIR "${SOURCE_DIR}")
set(CMAKE_CURRENT_SOURCE_DIR "${SOURCE_DIR}")

include(${CMAKE_CURRENT_LIST_DIR}/ec_git_version.cmake)
ec_git_version()

set(EC_ARCH $ENV{EC_ARCH})
set(EC_USER $ENV{USER})
string(TIMESTAMP BUILD_TIMESTAMP UTC)

# Provide old behaviour if BUILD_INFO_OUTPUT_DIR is not defined
if("${BUILD_INFO_OUTPUT_DIR}" STREQUAL "")
    set(BUILD_INFO_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
endif()
set(BUILD_INFO_PATH ${BUILD_INFO_OUTPUT_DIR}/${PROJECT_NAME}_build_info.h)

message(DEBUG "(EC) BUILD_INFO_OUTPUT_DIR=${BUILD_INFO_OUTPUT_DIR}")
message(DEBUG "(EC) BUILD_INFO_PATH=${BUILD_INFO_PATH}")
message(DEBUG "(EC) PREVIOUS_GIT_COMMIT=${PREVIOUS_GIT_COMMIT}")
message(DEBUG "(EC) GIT_COMMIT=${GIT_COMMIT}")
message(DEBUG "(EC) PREVIOUS_GIT_STATUS=${PREVIOUS_GIT_STATUS}")
message(DEBUG "(EC) GIT_STATUS=${GIT_STATUS}")

if(NOT EXISTS ${BUILD_INFO_PATH})
    message(STATUS "(EC) Creating initial ${PROJECT_NAME}_build_info.h")
    configure_file(${CMAKE_CURRENT_LIST_DIR}/build_info.h.in ${BUILD_INFO_PATH} @ONLY)
else()
    message(STATUS "(EC) ${PROJECT_NAME}_build_info.h exists. Checking if it's up to date...")
    if( (NOT PREVIOUS_GIT_COMMIT MATCHES "${GIT_COMMIT}") OR (NOT PREVIOUS_GIT_STATUS MATCHES "${GIT_STATUS}") )
        message(STATUS "(EC) Repository status has changed; rebuilding ${PROJECT_NAME}_build_info.h")
        configure_file(${CMAKE_CURRENT_LIST_DIR}/build_info.h.in ${BUILD_INFO_PATH} @ONLY)
    else()
        message(STATUS "(EC) Repository status is unchanged; ${PROJECT_NAME}_build_info.h is up-to-date")
    endif()
endif()
