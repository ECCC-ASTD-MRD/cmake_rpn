# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(GDB_VERSION ${GDB_FIND_VERSION})

find_path(GDB_INCLUDE_DIR
   NAMES gdb.h
   PATHS $ENV{GDB_ROOT}/include ENV C_INCLUDE_PATH)
       
# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
find_library(GDB_LIBRARY
   NAMES gdb
   PATHS $ENV{GDB_ROOT}/lib ENV LIBRARY_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GDB DEFAULT_MSG GDB_LIBRARY GDB_INCLUDE_DIR)
mark_as_advanced(GDB_INCLUDE_DIR GDB_LIBRARY)

if(GDB_FOUND)
   set(GDB_INCLUDE_DIRS ${GDB_INCLUDE_DIR})
   set(GDB_LIBRARIES ${GDB_LIBRARY})

   string(LENGTH ${GDB_LIBRARY} type)
   math(EXPR type "${type}-2")
   string(SUBSTRING ${GDB_LIBRARY} ${type} -1 type)
   if(type STREQUAL CMAKE_STATIC_LIBRARY_SUFFIX)
       set(type STATIC)
   else()
       set(type SHARED)
   endif()

   add_library(GDB::GDB ${type} IMPORTED)
   set_target_properties(GDB::GDB PROPERTIES
      IMPORTED_LOCATION             ${GDB_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${GDB_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_GDB
   )
endif()
