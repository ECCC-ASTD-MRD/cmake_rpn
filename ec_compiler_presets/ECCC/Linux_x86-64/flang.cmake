# Copyright 2021, Her Majesty the Queen in right of Canada

message(FATAL "(EC) This combinaison of compiler and architecture not yet ready for use")

add_definitions(-Di386 -DLittle_Endian)

# original flags in previous version of Linux-x86_64-gfortran
set(CMAKE_C_FLAGS "-O2 -g -w" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS "-O2 -fbacktrace -g -w -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic -fopenmp" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s -fopenmp -fpic")
set(MPI_Fortran_COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS} ${CMAKE_Fortran_FLAGS}" CACHE STRING "Fortran compiler flags")