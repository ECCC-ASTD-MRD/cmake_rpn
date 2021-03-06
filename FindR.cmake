# From https://github.com/Kitware/VTK/blob/master/CMake/FindR.cmake
#
# - This module locates an installed R distribution.
#
# Input:
#  R_LIB_ARCH - For windows (i386 or x64)
#
# Defines the following:
#  R_COMMAND           - Path to R command
#  R_HOME              - Path to 'R home', as reported by R
#  R_INCLUDE_DIR       - Path to R include directory
#  R_LIBRARY_BASE      - Path to R library
#  R_LIBRARY_READLINE  - Path to readline library
#  R_LIBRARIES         - Array of: R_LIBRARY_BASE, R_LIBRARY_BASE [, R_LIBRARY_READLINE]
#
#  VTK_R_HOME          - (deprecated, use R_HOME instead) Path to 'R home', as reported by R
#
# Variable search order:
#   1. Attempt to locate and set R_COMMAND
#     - If unsuccessful, generate error and prompt user to manually set R_COMMAND
#   2. Use R_COMMAND to set R_HOME
#   3. Locate other libraries in the priority:
#     1. Within a user-built instance of R at R_HOME
#     2. Within an installed instance of R
#     3. Within external system libraries
#

if(NOT R_LIB_ARCH)
  if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
    set(R_LIB_ARCH x64)
  else()
    set(R_LIB_ARCH i386)
  endif()
endif()

set(TEMP_CMAKE_FIND_APPBUNDLE ${CMAKE_FIND_APPBUNDLE})
set(CMAKE_FIND_APPBUNDLE "NEVER")
find_program(R_COMMAND R DOC "R executable.")
set(CMAKE_FIND_APPBUNDLE ${TEMP_CMAKE_FIND_APPBUNDLE})

if(R_COMMAND)
  # temporarily append ".dll" to the cmake find_library suffixes
  set(OLD_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES} ".dll")

  execute_process(WORKING_DIRECTORY .
                  COMMAND ${R_COMMAND} RHOME
                  OUTPUT_VARIABLE R_ROOT_DIR
                  OUTPUT_STRIP_TRAILING_WHITESPACE)
  # deprecated
  if(VTK_R_HOME)
    set(R_HOME ${VTK_R_HOME} CACHE PATH "R home directory obtained from R RHOME")
  else()
    set(R_HOME ${R_ROOT_DIR} CACHE PATH "R home directory obtained from R RHOME")
    set(VTK_R_HOME ${R_HOME})
  endif()
  # /deprecated
  # the following command does nothing currently, but will be used when deprecated code is removed
  set(R_HOME ${R_ROOT_DIR} CACHE PATH "R home directory obtained from R RHOME")

  find_path(R_INCLUDE_DIR R.h
            HINTS ${R_ROOT_DIR} ${R_ROOT_DIR}/bin/${R_LIB_ARCH}
            PATHS /usr/local/lib /usr/local/lib64 /usr/share
            PATH_SUFFIXES include R/include
            DOC "Path to file R.h")

  find_library(R_LIBRARY_BASE R
            HINTS ${R_ROOT_DIR}/lib ${R_ROOT_DIR}/bin/${R_LIB_ARCH}
            DOC "R library (example libR.a, libR.dylib, etc.).")

  find_library(R_LIBRARY_READLINE readline
            DOC "(Optional) system readline library. Only required if the R libraries were built with readline support.")

  # reset cmake find_library to initial value
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${OLD_SUFFIXES})
else()
  message(WARNING "FindR.cmake requires the following variables to be set: R_COMMAND")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(R DEFAULT_MSG R_HOME R_INCLUDE_DIR R_LIBRARY_BASE)

# Note: R_LIBRARY_BASE is added to R_LIBRARIES twice; this may be due to circular linking dependencies; needs further investigation
if(R_FOUND)
   set(R_LIBRARIES ${R_LIBRARY_BASE} ${R_LIBRARY_BASE})
   if(R_LIBRARY_READLINE)
      set(R_LIBRARIES ${R_LIBRARIES} ${R_LIBRARY_READLINE})
   endif()

   foreach(lib IN ITEMS BASE READLINE)
       string(LENGTH "${R_LIBRARY_${lib}}" type)
       math(EXPR type "${type}-2")
       string(SUBSTRING "${R_LIBRARY_${lib}}" ${type} -1 type)
       if(type STREQUAL CMAKE_STATIC_LIBRARY_SUFFIX)
           set(type STATIC)
       else()
           set(type SHARED)
       endif()

       add_library("R::${lib}" ${type} IMPORTED)
       set_target_properties("R::${lib}" PROPERTIES IMPORTED_LOCATION "${R_LIBRARY_${lib}}")
   endforeach()

   add_library(R::R INTERFACE IMPORTED)
   target_link_libraries(R::R INTERFACE R::BASE)
   set_target_properties(R::R PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ${R_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_R
   )
endif()


