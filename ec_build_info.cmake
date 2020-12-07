# Build ISO 8601 build timestamp target
# How to use:
#   - add as a target to a build
#   - add_dependencies(eerUtils$ENV{OMPI} build)
#   - and include the file build.h to have the BUILD_TIMESTAMP variable #defined
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

function(ec_build_info)
   file(WRITE "${CMAKE_BINARY_DIR}/build_info.cmake" "
if(EXISTS \"${CMAKE_CURRENT_SOURCE_DIR}/.git\")
   execute_process(COMMAND git describe --always
      OUTPUT_VARIABLE BUILD_INFO)
   string(STRIP \"\${BUILD_INFO}\" BUILD_INFO)
else()
   set(BUILD_INFO \"\")
endif()

string(TIMESTAMP BUILD_TIMESTAMP UTC)

file(WRITE \"build_info.h\" \"\\
#ifndef _BUILD_INFO_H
#define _BUILD_INFO_H

#define BUILD_TIMESTAMP \\\"\${BUILD_TIMESTAMP}\\\"
#define BUILD_INFO      \\\"\${BUILD_INFO}\\\"
#define BUILD_ARCH      \\\"$ENV{EC_ARCH}\\\"
#define BUILD_USER      \\\"$ENV{USER}\\\"

#define VERSION         \\\"${VERSION}\\\"
#define DESCRIPTION     \\\"${DESCRIPTION}\\\"

#endif // _BUILD_INFO_H
\")
")

   add_custom_target(build_info
      COMMAND           "${CMAKE_COMMAND}" -P "${CMAKE_BINARY_DIR}/build_info.cmake"
      BYPRODUCTS        "build_info.h"
      COMMENT           "Generating build_info"
   )

   include_directories(${CMAKE_BINARY_DIR})
endfunction()
