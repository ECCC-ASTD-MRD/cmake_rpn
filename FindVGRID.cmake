# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(VGRID_VERSION ${VGRID_FIND_VERSION})
find_path(VGRID_INCLUDE_DIR
   NAMES vgrid.h
   PATHS ${EC_INCLUDE_PATH} NO_DEFAULT_PATH)
       
# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
if("shared" IN_LIST VGRID_FIND_COMPONENTS)
   find_library(VGRID_LIBRARY
      NAMES vgridshared
      PATHS ${EC_LD_LIBRARY_PATH} NO_DEFAULT_PATH)
else()
   find_library(VGRID_LIBRARY
      NAMES vgrid
      PATHS ${EC_LD_LIBRARY_PATH} NO_DEFAULT_PATH)
endif()

string(REGEX MATCH ".*/libs/([0-9]+\\.[0-9]+)(\\.[0-9])?(-[a,b][0-9]*)?.*/" null ${VGRID_LIBRARY})
set(VGIRD_VERSION ${CMAKE_MATCH_1}${CMAKE_MATCH_2})
set(VGRID_STATE   ${CMAKE_MATCH_3})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VGRID
   FOUND_VAR VGRID_FOUND
   REQUIRED_VARS
      VGRID_LIBRARY
      VGRID_INCLUDE_DIR
   VERSION_VAR VGRID_VERSION)

if(VGRID_FOUND)
   set(VGRID_INCLUDE_DIRS ${VGRID_INCLUDE_DIR})
   set(VGRID_LIBRARIES ${VGRID_LIBRARY})
endif()
