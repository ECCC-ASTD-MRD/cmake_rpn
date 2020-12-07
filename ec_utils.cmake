#----- Compiler selection
if(NOT DEFINED COMPILER_SUITE)
   if(DEFINED ENV{CRAYPE_VERSION})
 #     set(MPI_C_COMPILER "cc")
 #     set(MPI_Fortran_COMPILER "ftn")
 #     set(MPI_C_COMPILER_FLAGS "-I$ENV{CRAY_MPICH_DIR}/include")
      set(CMAKE_SYSTEM_NAME CrayLinuxEnvironment)
   elseif(DEFINED ENV{INTEL_LICENSE_FILE})
      set(COMPILER_SUITE intel)
   else()
      set(COMPILER_SUITE gnu)
   endif()
endif()

if(COMPILER_SUITE MATCHES gnu)
   set(CMAKE_C_COMPILER gcc)
   set(CMAKE_CXX_COMPILER c++)
   set(CMAKE_Fortran_COMPILER gfortran)
elseif(COMPILER_SUITE MATCHES intel)
   set(CMAKE_C_COMPILER icc)
   set(CMAKE_CXX_COMPILER icpc)
   set(CMAKE_Fortran_COMPILER ifort)
elseif(COMPILER_SUITE MATCHES pgi)
   set(CMAKE_C_COMPILER pgcc)
   set(CMAKE_CXX_COMPILER pgc)
   set(CMAKE_Fortran_COMPILER pgfortran)
endif()

enable_language(C)
enable_language(Fortran)

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

include(ec_build_info)
include(ec_parse_manifest)
include(dump_cmake_variables)

macro(ec_getvar)
   #----- Get name and version of operating system
   execute_process(COMMAND sh "-c" "${CMAKE_CURRENT_SOURCE_DIR}/os.sh" OUTPUT_VARIABLE EC_OS)
   message(STATUS "Operating system is: ${EC_OS}")

   #----- Get name and version of compiler
   execute_process(COMMAND sh "-c" "${CMAKE_CURRENT_SOURCE_DIR}/compiler.sh ${COMPILER_SUITE}" OUTPUT_VARIABLE EC_COMPILER_SUITE_VERSION)
   message(STATUS "Compiler version is: ${COMPILER_SUITE} ${COMPILER_SUITE_VERSION}") 
endmacro()

macro(ec_target_link_library_if _target _condvar)
   set(_libs ${ARGN})
   list(LENGTH _libs _nlibs)
   if(_nlibs GREATER 0 AND ${_condvar})
      target_link_libraries(${_target} ${_libs})
   endif()
endmacro()
