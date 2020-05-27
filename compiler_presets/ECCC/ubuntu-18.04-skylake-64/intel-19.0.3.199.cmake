add_definitions(-DLittle_Endian)

set(CMAKE_C_COMPILER "icc")
set(CMAKE_Fortran_COMPILER "ifort")

set(MPI_C_COMPILER "mpicc")
set(MPI_Fortran_COMPILER "mpif90")

set(OPTIMIZ_FLAG -O2 -xCORE-AVX512)
if (SHARED)
   set (LIBTYPE -shared)
else()
   set (LIBTYPE -static-intel)
endif()

set(CMAKE_C_FLAGS "-Wl,--allow-shlib-undefined -Wtrigraphs -fpic -I. -traceback -fp-model precise" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS "-traceback -assume byterecl -convert big_endian -align array32byte -fpe0 -fpic -ip -I. ${LIBTYPE} -diag-disable=cpu-dispatch -fp-model source" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-fpic ${LIBTYPE} -mkl")

