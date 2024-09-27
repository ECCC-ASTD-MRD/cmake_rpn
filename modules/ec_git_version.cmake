# Copyright 2021, Her Majesty the Queen in right of Canada

# This module exports the following variables:
#  GIT_VERSION : Latest tag obtained or short commit hash obtained from Git
#  VERSION : The GIT_VERSION if it is compatible with CMake 0.0.0 otherwise
#
# This module also add a definition nammed VERSION which contains GIT_VERSION

# CMake does not deal with versions that do not follow the form
# <major>.<minor>.<patch>.<tweak> where each component is a number
# "0.0.1.0" is valid, but not "0.0.1.fe09182"

macro(ec_git_version)
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
        set(GIT_STATUS ${GIT_STATUS} CACHE STRING "Status of the git repository" FORCE)
        if(NOT VERSION_FROM_MANIFEST)
            message(DEBUG "(EC) VERSION not defined in the MANIFEST. Setting VERSION with GIT_VERSION")
            set(VERSION ${GIT_VERSION} CACHE STRING "Project's version" FORCE)
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
        set(GIT_COMMIT ${GIT_COMMIT} CACHE STRING "Repository commit hash" FORCE)
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
        set(GIT_TIMESTAMP ${GIT_TIMESTAMP} CACHE STRING "Timestamp of the commit" FORCE)
        if (EC_INIT_DONE LESS 2)
            # Print only if in a standalone git repository
            message(STATUS "(EC) Git commit timestamp: " ${GIT_COMMIT_TIMESTAMP})
        endif()
    else()
        message(WARNING "(EC) Failed to get commit timestamp from Git!\n" "Git error message:\n" ${GIT_ERROR})
    endif()
endmacro()
