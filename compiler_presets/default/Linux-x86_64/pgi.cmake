set(CMAKE_C_COMPILER "pgcc")
set(CMAKE_Fortran_COMPILER "pgfortran")

set(MPI_C_COMPILER "mpicc")
set(MPI_Fortran_COMPILER "mpif90")

set(CMAKE_C_FLAGS "-O2 -Wl,--allow-shlib-undefined -fpic -I." CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS "-O2 -fpic -byteswapio -fast -Mvect=fuse,simd -Kieee -traceback" CACHE STRING "Fortran compiler flags" FORCE)

set(MPI_Fortran_COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS} ${CMAKE_Fortran_FLAGS}" CACHE STRING "Fortran compiler flags")

set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--allow-shlib-undefined" CACHE STRING "Linker flags" FORCE)

set(LAPACK_LIBRARIES "-llapack")
set(BLAS_LIBRARIES "-lblas")
