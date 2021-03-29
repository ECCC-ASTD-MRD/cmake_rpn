# This module exports the following variables:
#  GIT_VERSION : Latest tag obtained or short commit hash obtained from Git
#  VERSION : The GIT_VERSION if it is compatible with CMake 0.0.0 otherwise
#
# This module also add a definition nammed VERSION which contains GIT_VERSION

execute_process(
   COMMAND git describe --tags --always --dirty --broken
   WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
   RESULT_VARIABLE GIT_RESULT
   OUTPUT_VARIABLE GIT_VERSION
   ERROR_VARIABLE GIT_ERROR
   OUTPUT_STRIP_TRAILING_WHITESPACE
   ERROR_STRIP_TRAILING_WHITESPACE
)
if(${GIT_RESULT} EQUAL 0)
   message(STATUS "Git version: " ${GIT_VERSION})
else()
   message(FATAL_ERROR "Failed to get version info from Git!\n" "Git error message:\n" ${GIT_ERROR})
endif()

add_definitions(-DVERSION="${GIT_VERSION}")
