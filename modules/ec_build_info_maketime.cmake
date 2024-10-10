# Copyright 2021, Her Majesty the Queen in right of Canada

# This file is used by the build_info target and will be parsed whenever make is invoked

# When a CMake script is executed with "-P", CMAKE_SOURCE_DIR is the current dir
# Since we don't want that, we force it.  CMAKE_CURRENT_SOURCE_DIR must also be fudged
# If this isn't done, git won't be able to find the version for out-of-tree builds
set(CMAKE_SOURCE_DIR "${SOURCE_DIR}")
set(CMAKE_CURRENT_SOURCE_DIR "${SOURCE_DIR}")

include(${CMAKE_CURRENT_LIST_DIR}/ec_debugLog.cmake)


function(generate_build_info)
    message(STATUS "(EC) Using ${BUILD_INFO_TMPL_PATH} to genreate ${BUILD_INFO_PATH}")
    configure_file(${BUILD_INFO_TMPL_PATH} ${BUILD_INFO_PATH} @ONLY)
endfunction()

# Even forcibly setting cache variables from here or from lower in the call stack doesn't really update CMake's cache
# This is why we create and use our own variable file

set(PREVIOUS_FILE_PATH ${CMAKE_CURRENT_BINARY_DIR}/ec_build_info.previous)
if(EXISTS ${PREVIOUS_FILE_PATH})
    file(STRINGS ${PREVIOUS_FILE_PATH} LINES)
    foreach(line ${LINES})
        if(NOT line STREQUAL "")
            string(REGEX MATCH "([^=]+)=(.+)" res ${line})
            # If the manifest isn't present, there will be nothing after the equal sign
            if(NOT CMAKE_MATCH_2 STREQUAL "")
                set(${CMAKE_MATCH_1} ${CMAKE_MATCH_2})
                debugLogVar("ec_build_info_maketime.cmake" ${CMAKE_MATCH_1})
            endif()
        endif()
    endforeach()
endif()


set(EC_ARCH $ENV{EC_ARCH})
set(EC_USER $ENV{USER})
string(TIMESTAMP BUILD_TIMESTAMP UTC)

if(NOT "${MANIFEST_FILE_PATH}" STREQUAL "")
    debugLogVar("ec_build_info_maketime.cmake" "MANIFEST_FILE_PATH")
    debugLogVar("ec_build_info_maketime.cmake" "PREVIOUS_MANIFEST_MTIME")
    file(TIMESTAMP ${MANIFEST_FILE_PATH} MANIFEST_MTIME UTC)
    debugLogVar("ec_build_info_maketime.cmake" "MANIFEST_MTIME")
    if(NOT PREVIOUS_MANIFEST_MTIME MATCHES "${MANIFEST_MTIME}")
        debugLog("ec_build_info_maketime.cmake" "MANIFEST has changed")
        # Will the variables be updated in the parent CMake context?
        get_filename_component(MANIFEST_DIR ${MANIFEST_FILE_PATH} DIRECTORY)
        debugLogVar("ec_build_info_maketime.cmake" "MANIFEST_DIR")
        include(${CMAKE_CURRENT_LIST_DIR}/ec_parse_manifest.cmake)
        ec_parse_manifest(${MANIFEST_DIR})
        unset(MANIFEST_DIR)
        set(BUILD_INFO_CHANGED ON)
    endif()
endif()

include(${CMAKE_CURRENT_LIST_DIR}/ec_git_version.cmake)
ec_git_version()

debugLogVar("ec_build_info_maketime.cmake" "GIT_COMMIT")
debugLogVar("ec_build_info_maketime.cmake" "GIT_STATUS")

# Provide old behaviour if BUILD_INFO_OUTPUT_DIR is not defined
if("${BUILD_INFO_OUTPUT_DIR}" STREQUAL "")
    set(BUILD_INFO_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
endif()
set(BUILD_INFO_PATH ${BUILD_INFO_OUTPUT_DIR}/${PROJECT_NAME}_build_info.h)

debugLogVar("ec_build_info_maketime.cmake" "BUILD_INFO_OUTPUT_DIR")
debugLogVar("ec_build_info_maketime.cmake" "BUILD_INFO_PATH")


if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/build_info.h.in")
    set(BUILD_INFO_TMPL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/build_info.h.in)
else()
    set(BUILD_INFO_TMPL_PATH ${CMAKE_CURRENT_LIST_DIR}/build_info.h.in)
endif()
debugLogVar("ec_build_info_maketime.cmake" "BUILD_INFO_TMPL_PATH")
file(TIMESTAMP ${BUILD_INFO_TMPL_PATH} BUILD_INFO_TMPL_MTIME UTC)
debugLogVar("ec_build_info_maketime.cmake" "BUILD_INFO_TMPL_MTIME")


if(NOT EXISTS ${BUILD_INFO_PATH})
    debugLog("ec_build_info_maketime.cmake" "Creating initial ${PROJECT_NAME}_build_info.h")
    generate_build_info()
else()
    debugLog("ec_build_info_maketime.cmake" "${PROJECT_NAME}_build_info.h exists. Checking if it's up to date...")

    if( (NOT PREVIOUS_GIT_COMMIT MATCHES "${GIT_COMMIT}") OR (NOT PREVIOUS_GIT_STATUS MATCHES "${GIT_STATUS}") )
        debugLog("ec_build_info_maketime.cmake" "Repository status has changed")
        set(BUILD_INFO_CHANGED ON)
    else()
        debugLog("ec_build_info_maketime.cmake" "Repository status is unchanged")
    endif()

    if(NOT PREVIOUS_BUILD_INFO_TMPL_PATH STREQUAL ${BUILD_INFO_TMPL_PATH} OR
       NOT PREVIOUS_BUILD_INFO_TMPL_MTIME STREQUAL ${BUILD_INFO_TMPL_MTIME})
        debugLog("ec_build_info_maketime.cmake" "Build info template has changed. ${PROJECT_NAME}_build_info.h must be regenerated.")
        set(BUILD_INFO_CHANGED ON)
    endif()

    if(BUILD_INFO_CHANGED)
        debugLog("ec_build_info_maketime.cmake" "Rebuilding ${PROJECT_NAME}_build_info.h")
        debugLogVar("ec_build_info_maketime.cmake" "GIT_VERSION")
        generate_build_info()
        unset(BUILD_INFO_CHANGED)
    else()
        debugLog("ec_build_info_maketime.cmake" "${PROJECT_NAME}_build_info.h is still up-to-date; doing nothing")
    endif()
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/ec_build_info.previous.in ${PREVIOUS_FILE_PATH} @ONLY)