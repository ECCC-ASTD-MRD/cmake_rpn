add_definitions(-DLittle_Endian)

#set(CMAKE_C_COMPILER "icc")
#set(CMAKE_Fortran_COMPILER "ifort")

#set(MPI_C_COMPILER "mpicc")
#set(MPI_Fortran_COMPILER "mpif90")

set(OPTIMIZ_FLAG -O2)
if (SHARED) 
   set (LIBTYPE -shared)
else()
   set (LIBTYPE -static-intel)
endif()

#set(FAST_FLAG -O3 -fast-transcendentals -no-prec-div -ip -no-prec-sqrt)

set(CMAKE_C_FLAGS "-Wl,--allow-shlib-undefined -Wtrigraphs -fpic -I. -traceback -msse3 -fp-model precise" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS "-g -assume byterecl -convert big_endian -msse3 -fpe0 -fpic -traceback -I. ${LIBTYPE} -diag-disable 7713 -diag-disable 10212 -diag-disable 5140 -mkl -fp-model source" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-fpic ${LIBTYPE} -mkl")

