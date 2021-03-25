#----- Compiler selection
if(NOT DEFINED COMPILER_SUITE)
   if(DEFINED ENV{CRAYPE_VERSION})
      set(CMAKE_SYSTEM_NAME CrayLinuxEnvironment)
      # We have to leave the default compiler on Cray for cmake to be able to find MPI
      # Only force ifort since we dont want Cray's ftn flags in this case
      set(CMAKE_Fortran_COMPILER ifort)
   elseif(DEFINED ENV{INTEL_LICENSE_FILE})
      set(COMPILER_SUITE intel)
   else()
      set(COMPILER_SUITE gnu)
   endif()
endif()
message(STATUS "COMPILER_SUITE=${COMPILER_SUITE}")

if(COMPILER_SUITE MATCHES gnu)
   set(CMAKE_C_COMPILER gcc)
   set(CMAKE_CXX_COMPILER g++)
   set(CMAKE_Fortran_COMPILER gfortran)
   set(MPI_C_COMPILER mpicc)
   set(MPI_Fortran_COMPILER mpif90)
elseif(COMPILER_SUITE MATCHES intel)
   set(CMAKE_C_COMPILER icc)
   set(CMAKE_CXX_COMPILER icpc)
   set(CMAKE_Fortran_COMPILER ifort)
   set(MPI_C_COMPILER mpicc)
   set(MPI_Fortran_COMPILER mpif90)
elseif(COMPILER_SUITE MATCHES pgi)
   set(CMAKE_C_COMPILER pgcc)
   set(CMAKE_CXX_COMPILER pgc++)
   set(CMAKE_Fortran_COMPILER pgfortran)
   set(MPI_C_COMPILER mpicc)
   set(MPI_Fortran_COMPILER mpif90)
elseif(COMPILER_SUITE MATCHES nvhpc)
   set(CMAKE_C_COMPILER nvc)
   set(CMAKE_CXX_COMPILER nvc++)
   set(CMAKE_Fortran_COMPILER nvfortran)
   set(MPI_C_COMPILER mpicc)
   set(MPI_Fortran_COMPILER mpif90)
endif()

#----- Prepare some variables for the search paths
if(DEFINED ENV{EC_INCLUDE_PATH})
   string(REPLACE " " ";" EC_INCLUDE_PATH    $ENV{EC_INCLUDE_PATH})
endif()
if(DEFINED ENV{EC_LD_LIBRARY_PATH})
   string(REPLACE " " ";" EC_LD_LIBRARY_PATH $ENV{EC_LD_LIBRARY_PATH})
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "" CACHE PATH "..." FORCE)
endif()

#----- Include EC defined functions
include(ec_build_info)
include(ec_dump_cmake_variables)
include(ec_git_version)
include(ec_parse_manifest)
include(ec_shared_lib)