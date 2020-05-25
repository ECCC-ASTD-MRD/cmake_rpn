add_definitions(-DAMD64 -DLINUX_X86_64 -DLittle_Endian -DECCCGEM -DWITH_intel)

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
#set(FAST_FLAG -xCORE-AVX512 -O3 -fast-transcendentals -no-prec-div -ip -no-prec-sqrt)

set(CMAKE_C_FLAGS "-Wl,--allow-shlib-undefined -Wtrigraphs -fpic -I. -traceback -fp-model precise -D_REENTRANT -D_THREAD_SAFE" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS "-traceback -assume byterecl -convert big_endian -align array32byte -fpe0 -fpic -ip -I. ${LIBTYPE} -diag-disable=cpu-dispatch -fp-model source" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-fpic ${LIBTYPE} -mkl")

