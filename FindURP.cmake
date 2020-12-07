# TODO We should have code to check the version

# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.0/command/find_package.html
# [[DOC]] https://cmake.org/cmake/help/v3.14/manual/cmake-developer.7.html
set(URP_VERSION ${URP_FIND_VERSION})

find_path(URP_INCLUDE_DIR
   NAMES URP.h
   HINTS $ENV{URP_ROOT}/include ENV C_INCLUDE_PATH)

# [[DOC]] for find_library https://cmake.org/cmake/help/latest/command/find_library.html
find_library(URP_LIBRARY
   NAMES urp
   PATHS $ENV{URP_ROOT}/lib ENV LIBRARY_PATH)
find_library(MUT_LIBRARY
   NAMES mut
   PATHS $ENV{URP_ROOT}/lib ENV LIBRARY_PATH)
find_library(DRP_LIBRARY
   NAMES drp
   PATHS $ENV{URP_ROOT}/lib ENV LIBRARY_PATH)
find_library(DSP_LIBRARY
   NAMES dsp
   PATHS $ENV{URP_ROOT}/lib ENV LIBRARY_PATH)
find_library(BZ2_LIBRARY
   NAMES bz2
   PATHS $ENV{URP_ROOT}/lib ENV LIBRARY_PATH)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(URP DEFAULT_MSG URP_LIBRARY URP_INCLUDE_DIR MUT_LIBRARY DRP_LIBRARY DSP_LIBRARY)
mark_as_advanced(URP_INCLUDE_DIR URP_LIBRARY MUT_LIBRARY DRP_LIBRARY DSP_LIBRARY)

if(URP_FOUND)
   set(URP_INCLUDE_DIRS ${URP_INCLUDE_DIR})
   set(URP_LIBRARIES ${MUT_LIBRARY} ${DRP_LIBRARY} ${URP_LIBRARY} ${DSP_LIBRARY} ${BZ2_LIBRARY})

   add_library(URP::LibURP STATIC IMPORTED)
   set_target_properties(URP::LibURP PROPERTIES IMPORTED_LOCATION ${URP_LIBRARY})

   add_library(URP::LibMUT STATIC IMPORTED)
   set_target_properties(URP::LibMUT PROPERTIES IMPORTED_LOCATION ${MUT_LIBRARY})

   add_library(URP::LibDRP STATIC IMPORTED)
   set_target_properties(URP::LibDRP PROPERTIES IMPORTED_LOCATION ${DRP_LIBRARY})

   add_library(URP::LibDSP STATIC IMPORTED)
   set_target_properties(URP::LibDSP PROPERTIES IMPORTED_LOCATION ${DSP_LIBRARY})

   add_library(URP::LibBZ2 SHARED IMPORTED)
   set_target_properties(URP::LibBZ2 PROPERTIES IMPORTED_LOCATION ${BZ2_LIBRARY})

   #----- Add the target that includes all libraries
   add_library(URP::URP INTERFACE IMPORTED)
   target_link_libraries(URP::URP INTERFACE URP::LibMUT URP::LibDRP URP::LibURP URP::LibDSP URP::LibBZ2)
   set_target_properties(URP::URP PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ${URP_INCLUDE_DIR}
      INTERFACE_COMPILE_DEFINITIONS HAVE_URP
   )
endif()

# urp_lib_flags="-lmut -ldrp -lurp -ldsp -lm -lxml2 -lz -lbz2"
