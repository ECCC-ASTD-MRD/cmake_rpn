# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(ECBUFR_VERSION ${ECBUFR_FIND_VERSION})

find_path(ECBUFR_INCLUDE_DIR
   NAMES bufr_api.h
   HINTS $ENV{ECBUFR_ROOT}/include ENV C_INCLUDE_PATH
   PATH_SUFFIXES libecbufr libecbufr${ECBUFR_VERSION})

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
find_library(ECBUFR_LIBRARY
   NAMES ecbufr
   PATHS $ENV{ECBUFR_ROOT}/lib ENV LIBRARY_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ECBUFR DEFAULT_MSG ECBUFR_LIBRARY ECBUFR_INCLUDE_DIR)
mark_as_advanced(ECBUFR_INCLUDE_DIR ECBUFR_LIBRARY)

if(ECBUFR_FOUND)
   set(ECBUFR_INCLUDE_DIRS ${ECBUFR_INCLUDE_DIR})
   set(ECBUFR_LIBRARIES ${ECBUFR_LIBRARY})

   string(LENGTH ${ECBUFR_LIBRARY} type)
   math(EXPR type "${type}-2")
   string(SUBSTRING ${ECBUFR_LIBRARY} ${type} -1 type)
   if(type STREQUAL CMAKE_STATIC_LIBRARY_SUFFIX)
       set(type STATIC)
   else()
       set(type SHARED)
   endif()

   add_library(ECBUFR::ECBUFR ${type} IMPORTED)
   set_target_properties(ECBUFR::ECBUFR PROPERTIES
      IMPORTED_LOCATION             ${ECBUFR_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${ECBUFR_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_ECBUFR
   )
endif()
