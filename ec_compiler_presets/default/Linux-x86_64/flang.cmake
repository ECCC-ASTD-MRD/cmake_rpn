# Copyright 2021, Her Majesty the Queen in right of Canada

add_definitions(-DLittle_Endian)

# original flags in previous version of Linux-x86_64-gfortran
set(CMAKE_C_FLAGS "-W" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O2")

set(CMAKE_Fortran_FLAGS "-O2 -fdump-core -fbacktrace -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic -fopenmp" CACHE STRING "Fortran compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS_DEBUG "-g")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s -fopenmp -fpic")
set(MPI_Fortran_COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS} ${CMAKE_Fortran_FLAGS}" CACHE STRING "Fortran compiler flags")

set(LAPACK_LIBRARIES "-llapack")
set(BLAS_LIBRARIES "-lblas")
