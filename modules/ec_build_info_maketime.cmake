# Copyright 2021, Her Majesty the Queen in right of Canada

# This file is used by the build_info target and will be parsed whenever make is invoked

include(${CMAKE_CURRENT_LIST_DIR}/ec_git_version.cmake)

ec_git_version()

set(EC_ARCH   $ENV{EC_ARCH})
set(EC_USER   $ENV{USER})
string(TIMESTAMP BUILD_TIMESTAMP UTC)
configure_file(${CMAKE_CURRENT_LIST_DIR}/build_info.h.in ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}_build_info.h @ONLY)
