# Copyright 2021, Her Majesty the Queen in right of Canada

include(${CMAKE_CURRENT_LIST_DIR}/ec_debugLog.cmake)

# Parse a MANIFEST file (optional path in argument)
macro(ec_parse_manifest)
    if("${ARGV0}" STREQUAL "")
        set(MANIFEST_FILE MANIFEST)
    else()
        set(MANIFEST_FILE ${ARGV0}/MANIFEST)
    endif()
    debugLogVar("ec_parse_manifest" "MANIFEST_FILE")
    file(REAL_PATH ${MANIFEST_FILE} MANIFEST_FILE_PATH)
    debugLogVar("ec_parse_manifest" "MANIFEST_FILE_PATH")
    file(STRINGS ${MANIFEST_FILE_PATH} dependencies)

    file(TIMESTAMP ${MANIFEST_FILE_PATH} MANIFEST_MTIME UTC)
    debugLogVar("ec_parse_manifest" "MANIFEST_MTIME")

    # Unset the version in case it was obtained by ec_git_version()
    unset(VERSION)
    foreach(line ${dependencies})
        string(REGEX MATCH "[#]|([A-Z,a-z,0-9,_]+)[ ]*([<,>,=,~,:]+)[ ]*(.*)" res ${line})
        set(LBL1 ${CMAKE_MATCH_1})
        set(LBL2 ${CMAKE_MATCH_2})
        set(LBL3 ${CMAKE_MATCH_3})

        #----- Skip comment lines
        if("${res}" STREQUAL "" OR "${res}" MATCHES "#" OR "${LBL3}" STREQUAL "")
            continue()
        endif()

        if (${LBL2} MATCHES ":")
            set(${LBL1} ${LBL3}) 
        else()
            set(${LBL1}_REQ_VERSION_CHECK ${LBL2})

            #----- Parse dependencies
            string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)(.*)" null ${LBL3})
            set(${LBL1}_REQ_VERSION_MAJOR  ${CMAKE_MATCH_1})
            set(${LBL1}_REQ_VERSION_MINOR  ${CMAKE_MATCH_2})
            set(${LBL1}_REQ_VERSION_PATCH  ${CMAKE_MATCH_3})
            set(${LBL1}_REQ_VERSION_STATUS ${CMAKE_MATCH_4})
            set(${LBL1}_REQ_VERSION ${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3})
        endif()
    endforeach()

    if(VERSION)
        debugLog("ec_parse_manifest" "VERSION (${VERSION}) set in the MANIFEST")
        set(VERSION_FROM_MANIFEST ON CACHE BOOL "Version information taken from the manifest and should not be overwritten" FORCE)

        # Extract version and state
        string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)(.*)" null ${VERSION})
        if (NOT ${CMAKE_MATCH_1} STREQUAL "")
            set(VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
            set(STATE "${CMAKE_MATCH_4}")
        endif()
        set(PROJECT_VERSION ${VERSION}${STATE})
        debugLogVar("ec_parse_manifest" "PROJECT_VERSION")
    else()
        debugLog("ec_parse_manifest" "VERSION NOT set in the MANIFEST. Checking if GIT_VERSION is defined...")
        set(VERSION_FROM_MANIFEST OFF CACHE BOOL "Version information taken from the manifest and should not be overwritten" FORCE)
        unset(STATE)
        if(GIT_VERSION)
            debugLog("ec_parse_manifest" "GIT_VERSION is defined (${GIT_VERSION}). Setting VERSION with it.")
            set(VERSION ${GIT_VERSION})
        endif()
    endif()

    # Set default build type if not already defined
    if (NOT CMAKE_BUILD_TYPE AND BUILD)
        set(CMAKE_BUILD_TYPE ${BUILD})
    endif()
endmacro()


function(ec_check_version DEPENDENCY)
    message("(EC) ${${DEPENDENCY}_REQ_VERSION} ${${DEPENDENCY}_REQ_VERSION_CHECK} ${${DEPENDENCY}_VERSION}")

    set(STATUS YES)

    if (${$DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "=")
        if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_EQUAL ${$DEPENDENCY}_VERSION})
            set(STATUS NO)
            message(SEND_ERROR "(EC) Found version is different")
        endif()
    elseif (${$DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "<=")
        if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_LESS_EQUAL ${$DEPENDENCY}_VERSION})
            set(STATUS NO)
            message(SEND_ERROR "(EC) Found version greather than ${$DEPENDENCY}_VERSION}")
        endif()
    elseif (${${DEPENDENCY}_REQ_VERSION_CHECK} MATCHES ">=")
        set(STATUS NO)
        if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_GREATER_EQUAL ${$DEPENDENCY}_VERSION})
            message(SEND_ERROR "(EC) Found version is less than ${$DEPENDENCY}_VERSION}")
        endif()
    endif()

    if (NOT ${STATUS})
        if (NOT ${${DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "~")
            message(FATAL_ERROR "(EC) package is required")
        endif()
    endif()
endfunction()
