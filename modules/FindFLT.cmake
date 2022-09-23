# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(FLT_VERSION ${FLT_FIND_VERSION})

find_path(FLT_INCLUDE_DIR
   NAMES flt.h
   HINTS $ENV{FLT_ROOT}/include ENV C_INCLUDE_PATH)

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
find_library(FLT_LIBRARY
   NAMES flt
   PATHS $ENV{FLT_ROOT}/lib ENV LIBRARY_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FLT DEFAULT_MSG FLT_LIBRARY FLT_INCLUDE_DIR)
mark_as_advanced(FLT_INCLUDE_DIR FLT_LIBRARY)

if(FLT_FOUND)
   set(FLT_INCLUDE_DIRS ${FLT_INCLUDE_DIR})
   set(FLT_LIBRARIES ${FLT_LIBRARY})

   string(LENGTH ${FLT_LIBRARY} type)
   math(EXPR type "${type}-2")
   string(SUBSTRING ${FLT_LIBRARY} ${type} -1 type)
   if(type STREQUAL CMAKE_STATIC_LIBRARY_SUFFIX)
       set(type STATIC)
   else()
       set(type SHARED)
   endif()

   add_library(FLT::FLT ${type} IMPORTED)
   set_target_properties(FLT::FLT PROPERTIES
      IMPORTED_LOCATION             ${FLT_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${FLT_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_FLT
   )
endif()
