message(FATAL "This combinaison of compiler and architecture not yet ready for use")

add_definitions(-DLittle_Endian)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_Fortran_COMPILER "gfortran")

set(MPI_C_COMPILER "mpicc")
set(MPI_Fortran_COMPILER "mpif90")

set(OPTIMIZ_FLAG -O2)
if (SHARED)
   set (LIBTYPE -shared)
else()
   set (LIBTYPE -static)
endif()

set(CMAKE_C_FLAGS "-g -w" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS "-fdump-core -fbacktrace -g -w -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic " CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s ${OPENMP_FLAG} ${LIBTYPE} -fpic")

set(LAPACK_LIBRARIES "-llapack")
set(BLAS_LIBRARIES "-lblas")
