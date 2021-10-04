# Copyright 2021, Her Majesty the Queen in right of Canada

# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
find_path(MPIEXTRAS_INCLUDE_DIR
   NAMES RPN_MPI_macros.hf
   PATHS ${EC_INCLUDE_PATH})
       
# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
set(type STATIC)
find_library(MPIEXTRAS_LIBRARY
  NAMES mpi_extras
  PATHS ${EC_LD_LIBRARY_PATH})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MPIEXTRAS
   FOUND_VAR MPIEXTRAS_FOUND
   REQUIRED_VARS
      MPIEXTRAS_LIBRARY
      MPIEXTRAS_INCLUDE_DIR)

if(MPIEXTRAS_FOUND)
   set(MPIEXTRAS_INCLUDE_DIRS ${MPIEXTRAS_INCLUDE_DIR})
   set(MPIEXTRAS_LIBRARIES ${MPIEXTRAS_LIBRARY})

   add_library(MPIEXTRAS::MPIEXTRAS ${type} IMPORTED)
   set_target_properties(MPIEXTRAS::MPIEXTRAS PROPERTIES
      IMPORTED_LOCATION             ${MPIEXTRAS_LIBRARY}
      INTERFACE_INCLUDE_DIRECTORIES ${MPIEXTRAS_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_MPIEXTRAS
   )
endif()
