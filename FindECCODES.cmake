# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(ECCODES_VERSION ${ECCODES_FIND_VERSION})
find_path(ECCODES_INCLUDE_DIR
   NAMES eccodes.h
   HINTS $ENV{ECCODES_ROOT}/include ENV C_INCLUDE_PATH)

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
find_library(ECCODES_LIBRARY
   NAMES eccodes
   PATHS $ENV{ECCODES_ROOT}/lib ENV LIBRARY_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ECCODES DEFAULT_MSG ECCODES_LIBRARY ECCODES_INCLUDE_DIR)
mark_as_advanced(ECCODES_INCLUDE_DIR ECCODES_LIBRARY)

if(ECCODES_FOUND)
   set(ECCODES_INCLUDE_DIRS ${ECCODES_INCLUDE_DIR})
   set(ECCODES_LIBRARIES ${ECCODES_LIBRARY})

   string(LENGTH ${ECCODES_LIBRARY} type)
   math(EXPR type "${type}-2")
   string(SUBSTRING ${ECCODES_LIBRARY} ${type} -1 type)
   if(type STREQUAL CMAKE_STATIC_LIBRARY_SUFFIX)
       set(type STATIC)
   else()
       set(type SHARED)
   endif()

   add_library(ECCODES::ECCODES ${type} IMPORTED)
   set_target_properties(ECCODES::ECCODES PROPERTIES
      IMPORTED_LOCATION             ${ECCODES_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${ECCODES_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_ECCODES
   )
endif()
