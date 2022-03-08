# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html

# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
set(type STATIC)
find_library(MASSV_LIBRARY
  NAMES massv
  PATHS ${EC_LD_LIBRARY_PATH})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MASSV
   FOUND_VAR MASSV_FOUND
   REQUIRED_VARS
      MASSV_LIBRARY )

if(MASSV_FOUND)
   set(MASSV_LIBRARIES ${MASSV_LIBRARY})

   mark_as_advanced(MASSV_LIBRARY)

   add_library(MASSV::MASSV ${type} IMPORTED)
   set_target_properties(MASSV::MASSV PROPERTIES
      IMPORTED_LOCATION             ${MASSV_LIBRARY}
      INTERFACE_COMPILE_DEFINITIONS HAVE_MASSV
   )
endif()
