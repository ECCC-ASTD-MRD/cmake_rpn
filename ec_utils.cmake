#----- Compiler selection
if(NOT DEFINED EC_COMPILER)
   set(EC_COMPILER gnu)
   if(DEFINED ENV{INTEL_LICENSE_FILE})
      set(EC_COMPILER intel)
   endif()
#   if(DEFINED ENV{CRAYPE_VERSION})
#      set(CMAKE_SYSTEM_NAME CrayLinuxEnvironment)
#   endif()
endif()

if(EC_COMPILER MATCHES gnu)
   set(CMAKE_C_COMPILER gcc)
   set(CMAKE_CXX_COMPILER c++)
   set(CMAKE_Fortran_COMPILER gfortran)
elseif(EC_COMPILER MATCHES intel)
   set(CMAKE_C_COMPILER icc)
   set(CMAKE_CXX_COMPILER icpc)
   set(CMAKE_Fortran_COMPILER ifort)
elseif(EC_COMPILER MATCHES pgi)
   set(CMAKE_C_COMPILER pgcc)
   set(CMAKE_CXX_COMPILER pgc)
   set(CMAKE_Fortran_COMPILER pgfortran)
endif()

#----- Prepare some variables
if(DEFINED ENV{EC_INCLUDE_PATH})
   string(REPLACE " " ";" EC_INCLUDE_PATH    $ENV{EC_INCLUDE_PATH})
endif()
if(DEFINED ENV{EC_LD_LIBRARY_PATH})
   string(REPLACE " " ";" EC_LD_LIBRARY_PATH $ENV{EC_LD_LIBRARY_PATH})
endif()

#----- Build ISO 8601 build timestamp target
# How to use:
#   - add as a target to a build
#   - add_dependencies(eerUtils$ENV{OMPI} build)
#   - and include the file build.h to have the BUILD_TIMESTAMP variable #defined
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

function(ec_build_info)
   if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/.git)
      execute_process(COMMAND git describe --always
         OUTPUT_VARIABLE BUILD_INFO)
      string(STRIP ${BUILD_INFO} BUILD_INFO)
   endif()

   FILE (WRITE ${CMAKE_BINARY_DIR}/build_info.cmake "string(TIMESTAMP BUILD_TIMESTAMP UTC)\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(WRITE build_info.h \"#ifndef _BUILD_INFO_H\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define _BUILD_INFO_H\\n\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define BUILD_TIMESTAMP \\\"\${BUILD_TIMESTAMP}\\\"\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define BUILD_INFO      \\\"${BUILD_INFO}\\\"\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define BUILD_ARCH      \\\"${EC_OS}/${EC_COMPILER}-${EC_COMPILER_VERSION}\\\"\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define BUILD_USER      \\\"$ENV{USER}\\\"\\n\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define VERSION         \\\"${VERSION}\\\"\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#define DESCRIPTION     \\\"${DESCRIPTION}\\\"\\n\\n\")\n")
   FILE (APPEND ${CMAKE_BINARY_DIR}/build_info.cmake "file(APPEND build_info.h \"#endif // _BUILD_INFO_H\\n\")\n")
   ADD_CUSTOM_TARGET (
      build_info
      COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/build_info.cmake
      ADD_DEPENDENCIES ${CMAKE_BINARY_DIR}/build_info.cmake)
   include_directories(${CMAKE_BINARY_DIR})
endfunction()

#----- Parse a MANIFEST file
macro(ec_parse_version)
   file(STRINGS MANIFEST dependencies)
   foreach(line ${dependencies})
      string(REGEX MATCH "([A-Z,a-z]+)[ ]*([<,>,=,~,:]+)[ ]*(.*)" null ${line})
#      message("${CMAKE_MATCH_1}..${CMAKE_MATCH_2}..${CMAKE_MATCH_3}")
      set(LBL1 ${CMAKE_MATCH_1})
      set(LBL2 ${CMAKE_MATCH_2})
      set(LBL3 ${CMAKE_MATCH_3})
      string(TOUPPER ${LBL1} LBL1)

      if (${CMAKE_MATCH_2} MATCHES ":")
         set(${LBL1} ${LBL3}) 
      else()
         set(${LBL1}_REQ_VERSION_CHECK ${LBL2})

         string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" null ${LBL3})
         set(${LBL1}_REQ_VERSION_MAJOR ${CMAKE_MATCH_1})
         set(${LBL1}_REQ_VERSION_MINOR ${CMAKE_MATCH_2})
         set(${LBL1}_REQ_VERSION_PATCH ${CMAKE_MATCH_3})
         set(${LBL1}_REQ_VERSION ${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3})
#         message("${LBL1} ${CMAKE_MATCH_1}..${CMAKE_MATCH_2}..${CMAKE_MATCH_3}")
      endif()
  endforeach()

   #----- Extract version and state
   string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)(.*)" null ${VERSION})
   set(VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
   set(STATE "${CMAKE_MATCH_4}")

  set(CMAKE_BUILD_TYPE ${BUILD})
  message(STATUS "Generating ${NAME} package")
endmacro()

function(ec_check_version DEPENDENCY)
   message("${${DEPENDENCY}_REQ_VERSION} ${${DEPENDENCY}_REQ_VERSION_CHECK} ${${DEPENDENCY}_VERSION}")

   set(STATUS YES)

   if (${$DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "=")
      if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_EQUAL ${$DEPENDENCY}_VERSION})
         set(STATUS NO)
         message(SEND_ERROR "Found version is different")
      endif()
   elseif (${$DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "<=")
      if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_LESS_EQUAL ${$DEPENDENCY}_VERSION})
         set(STATUS NO)
         message(SEND_ERROR "Found version greather than ${$DEPENDENCY}_VERSION}")
      endif()
   elseif (${${DEPENDENCY}_REQ_VERSION_CHECK} MATCHES ">=")
      set(STATUS NO)
      if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_GREATER_EQUAL ${$DEPENDENCY}_VERSION})
         message(SEND_ERROR "Found version is less than ${$DEPENDENCY}_VERSION}")
      endif()
   endif()

   if (NOT ${STATUS})
      if (NOT ${${DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "~")
         message(FATAL_ERROR "package is required")
      endif()
   endif()
endfunction()

# Add the target distclean to delete everything that cmake created
add_custom_target (distclean @echo cleaning for source distribution)
add_custom_command(
    DEPENDS clean
    COMMENT "distribution clean"
    COMMAND find
    ARGS    ${CMAKE_CURRENT_BINARY_DIR} "\\(" -name CMakeCache.txt
            -o -name cmake_install.cmake
            -o -name Makefile
            -o -name CMakeFiles
            -o -name ${BUILD}
            -o -name bin-${ARCH}
            -o -name install_manifest.txt
            "\\)" -print | xargs rm -fr
    TARGET  distclean
)

macro(ec_getvar)
   #----- Get name and version of operating system
   execute_process(COMMAND sh "-c" "${CMAKE_CURRENT_SOURCE_DIR}/os.sh" OUTPUT_VARIABLE EC_OS)
   message(STATUS "Operating system is: ${EC_OS}")

   #----- Get name and version of compiler
   execute_process(COMMAND sh "-c" "${CMAKE_CURRENT_SOURCE_DIR}/compiler.sh ${EC_COMPILER}" OUTPUT_VARIABLE EC_COMPILER_VERSION)
   message(STATUS "Compiler version is: ${EC_COMPILER} ${EC_COMPILER_VERSION}") 
endmacro()

#macro(ec-config CONFIG_FILE)
#   message("Generating config command: ${CMAKE_INSTALL_PREFIX}/bin/${CONFIG_FILE}")
#   execute_process(COMMAND sed -e '/sCMAKE_CC/${CMAKE_C_COMPILER}/g'-e '/sCMAKE_FTN/${CMAKE_Fortran_COMPILER}/g' 
#   -e '/sCMAKE_VERSION/${VERSION}/g' -e '/sCMAKE_RMN/${RMN_VERSION}/g' -e '/sCMAKE_GDAL/${GDAL_VERSION}/g' -e '/sCMAKE_VGRID/${VGRID_VERSION}/g'
#   ${CONFIG_FILE} > ${CMAKE_INSTALL_PREFIX}/bin/${CONFIG_FILE})

#cflags=CMAKE_CFLAGS
#libs=CMAKE_LIBS
#libdir=CMAKE_LIBDIR
#includedir=CMAKE_INCLUDEDIR
#endmacro()