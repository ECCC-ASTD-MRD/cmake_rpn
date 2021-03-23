message(FATAL "This combinaison of compiler and architecture not yet ready for use")

add_definitions(-Di386 -DLittle_Endian)

set(CMAKE_C_COMPILER "clang")
set(CMAKE_Fortran_COMPILER "flang")

set(MPI_C_COMPILER "mpicc")
set(MPI_Fortran_COMPILER "mpif90")
set(CMAKE_BUILD_TYPE "Debug")

# original flags in previous version of Linux-x86_64-gfortran
set(CMAKE_C_FLAGS "-O2 -g -w" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS "-O2 -fdump-core -fbacktrace -g -w -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic -fopenmp" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s -fopenmp -fpic")
set(MPI_Fortran_COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS} ${CMAKE_Fortran_FLAGS}" CACHE STRING "Fortran compiler flags")

set(LAPACK_LIBRARIES "-llapack")
set(BLAS_LIBRARIES "-lblas")
