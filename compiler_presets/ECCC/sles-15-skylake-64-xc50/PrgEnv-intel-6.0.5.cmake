add_definitions(-DLittle_Endian)
set(CMAKE_C_COMPILER "icc")
set(CMAKE_Fortran_COMPILER "ifort")

set(MPI_C_COMPILER "cc")
set(MPI_Fortran_COMPILER "ftn")

set(EXTRA_LIBRARIES "-liomp5 -L/opt/gcc/6.1.0/snos/lib64 -lcilkrts")

set(OPTIMIZ_FLAG -O2 -xCORE-AVX512)
if (SHARED)
   set (LIBTYPE -shared)
else()
   set (LIBTYPE -static-intel)
   set (LLIBTYPE -Bstatic -static-libgcc -static)
endif()
#set(FAST_FLAG -O3 -fast-transcendentals -no-prec-div -ip -no-prec-sqrt)

set(CMAKE_C_FLAGS "-traceback -fpic -fp-model precise" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS "-traceback -assume byterecl -convert big_endian -align array32byte -fpe0 -fpic -ip  -diag-disable=cpu-dispatch ${LIBTYPE} -diag-disable 7713 -diag-disable 10212 -diag-disable 5140 -fp-model source -I." CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,--allow-shlib-undefined -fpic")
