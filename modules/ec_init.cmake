# Copyright 2021, Her Majesty the Queen in right of Canada

if (DEFINED EC_INIT_DONE) # Is the initial setup already done
   message(STATUS "(EC) EC Initialisation already done")
else()
   # Do ec_init() only once (in case of projects cascades)
   # Define cmake_rpn path for module inclusion
   set (EC_CMAKE_RPN_DIR ${CMAKE_CURRENT_LIST_DIR}) 
   message(STATUS "(EC) EC_CMAKE_RPN_DIR ${EC_CMAKE_RPN_DIR}")
   # Compiler selection
   if(NOT DEFINED COMPILER_SUITE)
      # Cray are treated trhtough their CrayLinuxEnvironment
      if(DEFINED ENV{CRAYPE_VERSION})
         set(CMAKE_SYSTEM_NAME CrayLinuxEnvironment)
         # We have to leave the default compiler on Cray for cmake to be able to find MPI

         # Try to find which PrgEnv is loaded
         string(REGEX MATCH "PrgEnv-(([a-z]|[A-Z])+)/" COMPILER_SUITE $ENV{LOADEDMODULES})
         set(COMPILER_SUITE ${CMAKE_MATCH_1})
      elseif(DEFINED ENV{INTEL_LICENSE_FILE} OR ( (DEFINED ENV{CMPLR_ROOT}) AND ($ENV{CMPLR_ROOT} MATCHES .*intel.*)))
         set(COMPILER_SUITE intel)
      else()
         set(COMPILER_SUITE gnu)
      endif()

      # Use env variables if defined
      if(DEFINED ENV{CC})
         set(CMAKE_C_COMPILER $ENV{CC})
         set(COMPILER_SUITE "user env defined")
      endif()
      if(DEFINED ENV{FC})
         set(CMAKE_Fortran_COMPILER $ENV{FC})
         set(COMPILER_SUITE "user env defined")
      endif()
      if(DEFINED ENV{CXX})
         set(CMAKE_CXX_COMPILER $ENV{CXX})
         set(COMPILER_SUITE "user env defined")
      endif()
   else()
      string(TOLOWER "${COMPILER_SUITE}" COMPILER_SUITE)
   endif()
   message(STATUS "(EC) COMPILER_SUITE=${COMPILER_SUITE}")

   # Only set compilers if we are not in the CrayLinuxEnvironment
   if(NOT CMAKE_SYSTEM_NAME STREQUAL "CrayLinuxEnvironment")
      if(COMPILER_SUITE STREQUAL "gnu")
         set(CMAKE_C_COMPILER "gcc")
         set(CMAKE_CXX_COMPILER "g++")
         set(CMAKE_Fortran_COMPILER "gfortran")
      elseif(COMPILER_SUITE STREQUAL "intel")
         set(CMAKE_C_COMPILER "icc")
         set(CMAKE_CXX_COMPILER "icpc")
         set(CMAKE_Fortran_COMPILER "ifort")
         # add intel compiler library path to the install RPATH
         if(DEFINED ENV{CMPLR_ROOT})
            set(INTEL_SO_DIR $ENV{CMPLR_ROOT}/linux/compiler/lib/intel64)
         else()
            # CMPLR_ROOT environment variable isn't defined :'(
            # Hack for CMC with Intel 19
            set(INTEL_SO_DIR "/fs/ssm/main/opt/intelcomp/intelpsxe-cluster-19.0.3.199/intelpsxe-cluster_19.0.3.199_multi/compilers_and_libraries_2019.3.199/linux/compiler/lib/intel64_lin")
         endif()
         if(EXISTS ${INTEL_SO_DIR})
            list(APPEND CMAKE_INSTALL_RPATH ${INTEL_SO_DIR})
         endif()
         unset(INTEL_SO_DIR)
      elseif(COMPILER_SUITE STREQUAL "pgi")
         set(CMAKE_C_COMPILER "pgcc")
         set(CMAKE_CXX_COMPILER "pgc++")
         set(CMAKE_Fortran_COMPILER "pgfortran")
      elseif(COMPILER_SUITE STREQUAL "nvhpc")
         set(CMAKE_C_COMPILER "nvc")
         set(CMAKE_CXX_COMPILER "nvc++")
         set(CMAKE_Fortran_COMPILER "nvfortran")
      elseif(COMPILER_SUITE STREQUAL "llvm")
         set(CMAKE_C_COMPILER "clang")
         set(CMAKE_CXX_COMPILER "clang++")
         set(CMAKE_Fortran_COMPILER "flang-new")
      elseif(COMPILER_SUITE STREQUAL "xl")
         set(CMAKE_C_COMPILER "xlc")
         set(CMAKE_CXX_COMPILER "xlc++")
         set(CMAKE_Fortran_COMPILER "xlf_r")
       elseif(COMPILER_SUITE MATCHES aocc)
         set(CMAKE_C_COMPILER "clang")
         set(CMAKE_CXX_COMPILER "clang++")
         set(CMAKE_Fortran_COMPILER "flang")
       elseif(COMPILER_SUITE MATCHES "user env defined")
      else()
         message(FATAL_ERROR "(EC) Unknown compiler suite: ${COMPILER_SUITE}")
      endif()

      # Check if specified compiler suite exists
      find_program(COMPILER_FOUND ${CMAKE_C_COMPILER} NO_CACHE)
      if(NOT COMPILER_FOUND) 
         message(FATAL_ERROR "(EC) Compiler suite not found: ${COMPILER_SUITE}")
      endif()
   endif()

   #   message(DEBUG CMAKE_C_COMPILER=${CMAKE_C_COMPILER})
   #   message(DEBUG CMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER})
   #   message(DEBUG CMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER})
   #   message(DEBUG MPI_C_COMPILER=${MPI_C_COMPILER})
   #   message(DEBUG MPI_Fortran_COMPILER=${MPI_Fortran_COMPILER})

   # Prepare some variables for the search paths
   if(DEFINED ENV{EC_INCLUDE_PATH})
      string(REPLACE " " ";" EC_INCLUDE_PATH "$ENV{EC_INCLUDE_PATH}")
   endif()
   if(DEFINED ENV{EC_LD_LIBRARY_PATH})
      string(REPLACE " " ";" EC_LD_LIBRARY_PATH "$ENV{EC_LD_LIBRARY_PATH}")
   endif()

   # Enable DEBUG macro on cmake debug build
   if(CMAKE_BUILD_TYPE STREQUAL "Debug")
      add_definitions(-DDEBUG_LEVEL)
   endif()

   # Prepare some internal EC variables
   set(EC_ARCH   $ENV{EC_ARCH})
   set(EC_PLAT   $ENV{ORDENV_PLAT})
   set(EC_USER   $ENV{USER})
   set(EC_CI_ENV $ENV{ECCI_ENV})
   set(EC_COMP "")
   if(DEFINED ENV{COMP_ARCH})
      set(EC_COMP "-$ENV{COMP_ARCH}")
   endif()

   # Include EC defined functions
   include(ec_git_version)
   include(ec_build_info)
   include(ec_build_config)
   include(ec_parse_manifest)
   include(ec_dump_cmake_variables)
   include(ec_install_prefix)
   include(ec_install_symlink)
   include(ec_package_ssm)
endif()

# Increment init check to control cascade options
MATH(EXPR EC_INIT_DONE "${EC_INIT_DONE}+1")
