add_definitions(-DAMD64 -DLINUX_X86_64 -DLittle_Endian -DECCCGEM)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_Fortran_COMPILER "gfortran")

set(MPI_C_COMPILER "mpicc")
set(MPI_Fortran_COMPILER "mpif90")
#set(CMAKE_BUILD_TYPE "Debug")

# find_package(MPI) in CMakeLists.txt should be enough to find them
#set(MPI_Fortran_LIBRARIES    "-L/usr/lib64/openmpi/lib -lmpi_mpifh")
#set(MPI_Fortran_LIBRARIES    "-L/usr/lib/openmpi/lib -lmpi_f90 -lmpi_f77 -lmpi")
#set(MPI_Fortran_INCLUDE_PATH "/usr/include/openmpi")

set(OPTIMIZ_FLAG -O2)
if (SHARED)
   set (LIBTYPE -shared)
else()
   set (LIBTYPE -static)
endif()

set(CMAKE_C_FLAGS "-g -w -D_REENTRANT" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS "-fdump-core -fbacktrace -g -w -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic " CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s ${OPENMP_FLAG} ${LIBTYPE} -fpic")

set(LAPACK_LIBRARIES "-llapack")
set(BLAS_LIBRARIES "-lblas")
