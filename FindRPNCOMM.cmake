# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
find_path(RPNCOMM_INCLUDE_DIR
   NAMES RPN_COMM.inc
   PATHS ${EC_INCLUDE_PATH})
       
# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
set(type STATIC)
find_library(RPNCOMM_LIBRARY
  NAMES rpn_comm
  PATHS ${EC_LD_LIBRARY_PATH})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RPNCOMM
   FOUND_VAR RPNCOMM_FOUND
   REQUIRED_VARS
      RPNCOMM_LIBRARY
      RPNCOMM_INCLUDE_DIR)

if(RPNCOMM_FOUND)
   set(RPNCOMM_INCLUDE_DIRS ${RPNCOMM_INCLUDE_DIR})
   set(RPNCOMM_LIBRARIES ${RPNCOMM_LIBRARY})

   add_library(RPNCOMM::RPNCOMM ${type} IMPORTED)
   set_target_properties(RPNCOMM::RPNCOMM PROPERTIES
      IMPORTED_LOCATION             ${RPNCOMM_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${RPNCOMM_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_RPNCOMM
   )
endif()
