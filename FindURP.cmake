# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(URP_VERSION ${URP_FIND_VERSION})

find_path(URP_INCLUDE_DIR
   NAMES URP.h
   HINTS $ENV{URP_ROOT}/include ENV C_INCLUDE_PATH)

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
find_library(URP_LIBRARY
   NAMES urp
   PATHS ENV LIBRARY_PATH)
find_library(URPLC_LIBRARY
   NAMES urplc
   PATHS ENV LIBRARY_PATH)
find_library(MUT_LIBRARY
   NAMES mut
   PATHS ENV LIBRARY_PATH)
find_library(DRP_LIBRARY
   NAMES drp
   PATHS ENV LIBRARY_PATH)
find_library(DSP_LIBRARY
   NAMES dsp
   PATHS ENV LIBRARY_PATH)
find_library(CONFIG_LIBRARY
   NAMES config
   PATHS ENV LIBRARY_PATH)
find_library(ZSTD_LIBRARY
   NAMES zstd
   PATHS ENV LIBRARY_PATH)
find_library(BZ2_LIBRARY
   NAMES bz2
   PATHS ENV LIBRARY_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(URP
   FOUND_VAR URP_FOUND
   REQUIRED_VARS
      URP_LIBRARY 
      URPLC_LIBRARY 
      URP_INCLUDE_DIR 
      MUT_LIBRARY 
      DRP_LIBRARY 
      DSP_LIBRARY
   VERSION_VAR URP_VERSION)

if(URP_FOUND)
   set(URP_INCLUDE_DIRS ${URP_INCLUDE_DIR})
   set(URP_LIBRARIES ${MUT_LIBRARY} ${DRP_LIBRARY} ${URP_LIBRARY} ${DSP_LIBRARY} ${URPLC_LIBRARY} ${CONFIG_LIBRARY} ${ZSTD_LIBRARY} ${BZ2_LIBRARY})

   foreach(lib IN ITEMS MUT DRP URP URPLC DSP CONFIG ZSTD BZ2)
       string(LENGTH "${${lib}_LIBRARY}" type)
       math(EXPR type "${type}-2")
       string(SUBSTRING "${${lib}_LIBRARY}" ${type} -1 type)
       if(type STREQUAL CMAKE_STATIC_LIBRARY_SUFFIX)
           set(type STATIC)
       else()
           set(type SHARED)
       endif()

       add_library("URP::Lib${lib}" ${type} IMPORTED)
       set_target_properties("URP::Lib${lib}" PROPERTIES IMPORTED_LOCATION "${${lib}_LIBRARY}")
   endforeach()

   #----- Add the target that includes all libraries
   add_library(URP::URP INTERFACE IMPORTED)
   target_link_libraries(URP::URP INTERFACE URP::LibMUT URP::LibDRP URP::LibURP URP::LibDSP URP::LibURPLC URP::LibCONFIG URP::LibZSTD URP::LibBZ2)
   set_target_properties(URP::URP PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ${URP_INCLUDE_DIRS}
      INTERFACE_COMPILE_DEFINITIONS HAVE_URP
   )
endif()
