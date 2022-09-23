# Copyright 2021, Her Majesty the Queen in right of Canada

add_definitions(-DLittle_Endian)

if("C" IN_LIST languages)
    # original flags in previous version of Linux-x86_64-gfortran
    set(CMAKE_C_FLAGS "-W" CACHE STRING "C compiler flags" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "-g")
    set(CMAKE_C_FLAGS_RELEASE "-O2")
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-fconvert=big-endian -fcray-pointer -frecord-marker=4 -fno-second-underscore -fdump-core -fbacktrace -ffree-line-length-none" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_DEBUG "-g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s")
