# Copyright 2021, Her Majesty the Queen in right of Canada

# This module exports the following variables:
#  GIT_VERSION : Latest tag obtained or short commit hash obtained from Git
#  VERSION : The GIT_VERSION if it is compatible with CMake 0.0.0 otherwise
#
# This module also add a definition nammed VERSION which contains GIT_VERSION

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
   if(${GIT_RESULT} EQUAL 0)
     if (EC_INIT_DONE LESS 2)
       # Print only if in a standalone git repository
       message(STATUS "(EC) Git version: " ${GIT_VERSION})
     endif()
      # CMake does not deal with versions that do not follow the form
      # <major>.<minor>.<patch>.<tweak> where each component is a number
      # "0.0.1.0" is valid, but not "0.0.1.fe09182"
      set(VERSION ${GIT_VERSION})
#      set(VERSION_SHA1 ?= $(shell git rev-parse HEAD)
      else()
      set(VERSION "0.0.0")
      message(WARNING "(EC) Failed to get version info from Git!\n" "Git error message:\n" ${GIT_ERROR})
   endif()
endmacro()
