# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html

# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html

#find_path(RMN_INCLUDE_DIR
#   NAMES rpnmacros.h
#   PATHS ENV CPATH)
find_path(RMN_INCLUDE_DIR
   NAMES rpn_macros_arch.h
   PATHS ${EC_INCLUDE_PATH})

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
if("SHARED" IN_LIST RMN_FIND_COMPONENTS)
   set(type SHARED)
   if("THREADED" IN_LIST RMN_FIND_COMPONENTS)
      find_library(RMN_LIBRARY
         NAMES rmnsharedPTHRD
         PATHS ${EC_LD_LIBRARY_PATH})
   else()
      find_library(RMN_LIBRARY
         NAMES rmnshared
         PATHS ${EC_LD_LIBRARY_PATH})
   endif()
else()
   set(type STATIC)
   find_library(RMN_LIBRARY
      NAMES rmn
      PATHS ${EC_LD_LIBRARY_PATH})
endif()

string(REGEX MATCH ".*/libs/([0-9]+\\.[0-9]+)(\\.[0-9])?(-[a,b][0-9]*)?.*/" null ${RMN_LIBRARY})
set(RMN_VERSION ${CMAKE_MATCH_1}${CMAKE_MATCH_2})
set(RMN_STATE   ${CMAKE_MATCH_3})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RMN
   FOUND_VAR RMN_FOUND
   REQUIRED_VARS
      RMN_LIBRARY
      RMN_INCLUDE_DIR
   VERSION_VAR RMN_VERSION)

if(RMN_FOUND)
   set(RMN_INCLUDE_DIRS ${RMN_INCLUDE_DIR})
   set(RMN_LIBRARIES ${RMN_LIBRARY})

   mark_as_advanced(RMN_INCLUDE_DIR RMN_LIBRARY)

   add_library(RMN::RMN ${type} IMPORTED)
   set_target_properties(RMN::RMN PROPERTIES
      IMPORTED_LOCATION             ${RMN_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${RMN_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_RMN
   )
endif()

if("rpnpy" IN_LIST RMN_FIND_COMPONENTS)
   message("Component rpnpy requested")
   # Let's say we don't find it
   set(RMN_rpnpy_FOUND)
   if(${RMN_FIND_REQUIRED_rpnpy})
      message(FATAL_ERROR "Could not find required component rpnpy")
   else()
      message("Could not find component rpnpy")
   endif()
endif()
