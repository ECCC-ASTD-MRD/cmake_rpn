# Copyright 2021, Her Majesty the Queen in right of Canada

# Set the target architecture
if(NOT TARGET_PROC)
    set(TARGET_PROC "icelake-server")
endif()

include(${CMAKE_CURRENT_LIST_DIR}/../../default/Linux-x86_64/gnu.cmake)
