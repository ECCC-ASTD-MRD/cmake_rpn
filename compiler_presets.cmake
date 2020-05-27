# This modules loads compiler presets for the current platform and handles
# ECCC's computing environment differently

# Input
#  COMPILER_SUITE : Lower case name of the compiler suite (gnu, intel, ...)
#  LANGUAGES : List of language to enable for the project.  Usually C and Fotran

# Check to see if we are at ECCC
if(DEFINED ENV{EC_ARCH})
   message(STATUS "ECCC environment variable detected; ECCC presets")
   set(COMPILER_PRESET_PATH "ECCC/${BASE_ARCH}/${COMPILER_SUITE}.cmake")
else()
   message(STATUS "Using default presets")
   set(COMPILER_PRESET_PATH "default/${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}/${COMPILER_SUITE}.cmake")
endif()

message(STATUS "Loading preset ${COMPILER_PRESET_PATH}")
include("${CMAKE_CURRENT_LIST_DIR}/compiler_presets/${COMPILER_PRESET_PATH}")
