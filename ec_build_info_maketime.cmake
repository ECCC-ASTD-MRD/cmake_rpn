# This file is used by the build_info target and will be parsed whenever make is invoked

include(${SOURCE_DIR}/cmake_rpn/ec_git_version.cmake)
# When a CMake script is executed with "-P", CMAKE_SOURCE_DIR is the current dir
# Since we don't want that, we force it
set(CMAKE_SOURCE_DIR "${SOURCE_DIR}")
ec_git_version()

string(TIMESTAMP BUILD_TIMESTAMP UTC)

if(DEFINED ENV{EC_ARCH})
    set(EC_ARCH $ENV{EC_ARCH})
endif()
set(BUILD_USER $ENV{USER})
configure_file(${SOURCE_DIR}/cmake_rpn/build_info.h.in ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_build_info.h @ONLY)