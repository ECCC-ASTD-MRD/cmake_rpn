# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html

# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html

find_path(MODELUTILS_INCLUDE_DIR
   NAMES rmnlib_basics.inc
   PATHS ${EC_INCLUDE_PATH})

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
set(type STATIC)
find_library(MODELUTILS_LIBRARY
  NAMES modelutils
  PATHS ${EC_LD_LIBRARY_PATH})

string(REGEX MATCH ".*/modelutils_([0-9]+)(\\.[0-9]+)(\\.[0-9])?(-[a,b][0-9]*)?.*/" null ${MODELUTILS_LIBRARY})
set(MODELUTILS_VERSION ${CMAKE_MATCH_1}${CMAKE_MATCH_2}${CMAKE_MATCH_3}${CMAKE_MATCH_4})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MODELUTILS
   FOUND_VAR MODELUTILS_FOUND
   REQUIRED_VARS
      MODELUTILS_LIBRARY
      MODELUTILS_INCLUDE_DIR
   VERSION_VAR MODELUTILS_VERSION)

if(MODELUTILS_FOUND)
   set(MODELUTILS_INCLUDE_DIRS ${MODELUTILS_INCLUDE_DIR})
   set(MODELUTILS_LIBRARIES ${MODELUTILS_LIBRARY})

   mark_as_advanced(MODELUTILS_INCLUDE_DIR MODELUTILS_LIBRARY)

   add_library(MODELUTILS::MODELUTILS ${type} IMPORTED)
   set_target_properties(MODELUTILS::MODELUTILS PROPERTIES
      IMPORTED_LOCATION             ${MODELUTILS_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${MODELUTILS_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_MODELUTILS
   )
endif()
