# Copyright 2021, Her Majesty the Queen in right of Canada

add_definitions(-DLittle_Endian)

# original flags in previous version of Linux-x86_64-gfortran
set(CMAKE_C_FLAGS "-W" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O2")

set(CMAKE_Fortran_FLAGS "-fdump-core -fbacktrace -ffree-line-length-none" CACHE STRING "Fortran compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS_DEBUG "-g")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s")
