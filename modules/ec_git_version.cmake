# Copyright 2021, Her Majesty the Queen in right of Canada

# This module exports the following variables:
#  GIT_VERSION : Latest tag obtained or short commit hash obtained from Git
#  VERSION : The GIT_VERSION if it is compatible with CMake 0.0.0 otherwise
#
# This module also add a definition nammed VERSION which contains GIT_VERSION

# CMake does not deal with versions that do not follow the form
# <major>.<minor>.<patch>.<tweak> where each component is a number
# "0.0.1.0" is valid, but not "0.0.1.fe09182"


include(${CMAKE_CURRENT_LIST_DIR}/ec_debugLog.cmake)

macro(ec_git_version)
    # This is a dirty fix for a very strange bug:
    # Sometimes `git describe` still adds dirty even if changes in the repository have been reverted.
    # As far as we known, this only happens on hpcr5-in
    # We therefore execute `git status` while ignoring all its output to force a refresh of the state.
    execute_process(
        COMMAND git status
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE GIT_RESULT
        OUTPUT_VARIABLE GIT_OUTPUT
        ERROR_VARIABLE GIT_ERROR
    )
    unset(GIT_OUTPUT)

    execute_process(
        COMMAND git describe --tags --always --dirty --broken
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE GIT_RESULT
        OUTPUT_VARIABLE GIT_VERSION
        ERROR_VARIABLE GIT_ERROR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    if(NOT ${GIT_RESULT} EQUAL 0)
        message(WARNING "(EC) Failed to get version from Git!\n" "Git error message:\n" ${GIT_ERROR})
        set(VERSION "0.0.0")
    endif()
    debugLogVar("ec_git_version" "GIT_VERSION")

    execute_process(
        COMMAND git status --porcelain
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE GIT_RESULT
        OUTPUT_VARIABLE GIT_STATUS
        ERROR_VARIABLE GIT_ERROR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    if(${GIT_RESULT} EQUAL 0)
        if(GIT_STATUS MATCHES "^$")
            set(GIT_STATUS "Clean")
        else()
            set(GIT_STATUS "Dirty")
            # `git describe --dirty` doesn't add "-dirty" if there are new untracked files
            # Because new files can be compiled if a `file(GLOB ...)` was used, we still need
            # to add "-dirty"
            if(NOT GIT_VERSION MATCHES "-dirty")
                string(APPEND GIT_VERSION "-dirty")
            endif()
        endif()
        debugLogVar("ec_git_version" "GIT_VERSION")
        if(NOT VERSION_FROM_MANIFEST)
            debugLog("ec_git_version" "VERSION_FROM_MANIFEST not defined. Setting VERSION and PROJECT_VERSION with GIT_VERSION")
            set(VERSION ${GIT_VERSION})
            set(PROJECT_VERSION ${VERSION})
        endif()
        if (EC_INIT_DONE LESS 2)
            # Print only if in a standalone git repository
            message(STATUS "(EC) Git status: " ${GIT_STATUS})
        endif()
    else()
        message(WARNING "(EC) Failed to get status from Git!\n" "Git error message:\n" ${GIT_ERROR})
    endif()

    if (EC_INIT_DONE LESS 2)
        # Print only if in a standalone git repository
        message(STATUS "(EC) Git version: " ${GIT_VERSION})
    endif()

    execute_process(
        COMMAND git rev-parse HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE GIT_RESULT
        OUTPUT_VARIABLE GIT_COMMIT
        ERROR_VARIABLE GIT_ERROR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    if(${GIT_RESULT} EQUAL 0)
        if (EC_INIT_DONE LESS 2)
            # Print only if in a standalone git repository
            message(STATUS "(EC) Git commit: " ${GIT_COMMIT})
        endif()
    else()
        message(WARNING "(EC) Failed to get commit from Git!\n" "Git error message:\n" ${GIT_ERROR})
    endif()

    execute_process(
        COMMAND git show --no-patch --format=%ci HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        RESULT_VARIABLE GIT_RESULT
        OUTPUT_VARIABLE GIT_COMMIT_TIMESTAMP
        ERROR_VARIABLE GIT_ERROR
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    if(${GIT_RESULT} EQUAL 0)
        if (EC_INIT_DONE LESS 2)
            # Print only if in a standalone git repository
            message(STATUS "(EC) Git commit timestamp: " ${GIT_COMMIT_TIMESTAMP})
        endif()
    else()
        message(WARNING "(EC) Failed to get commit timestamp from Git!\n" "Git error message:\n" ${GIT_ERROR})
    endif()
endmacro()
