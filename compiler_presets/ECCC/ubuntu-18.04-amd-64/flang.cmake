add_definitions(-DAMD64 -Di386 -DLINUX_X86_64 -DLittle_Endian)

set(CMAKE_C_COMPILER "clang")
set(CMAKE_Fortran_COMPILER "flang")

set(MPI_C_COMPILER "mpicc")
set(MPI_Fortran_COMPILER "mpif90")
set(CMAKE_BUILD_TYPE "Debug")

# find_package(MPI) in CMakeLists.txt should be enough to find them
#set(MPI_Fortran_LIBRARIES    "-L/usr/lib64/openmpi/lib -lmpi_mpifh")
#set(MPI_Fortran_LIBRARIES    "-L/usr/lib/openmpi/lib -lmpi_f90 -lmpi_f77 -lmpi")
#set(MPI_Fortran_INCLUDE_PATH "/usr/include/openmpi")

# with warning and debugging flags
# -Wall: all the warnings about constructions that are questionable, and easy to avoid :
# https://gcc.gnu.org/onlinedocs/gcc-5.1.0/gcc/Warning-Options.html
# -Wno-tabs: Silence the warning: `Non-conforming tab character`
# -std=f2003 -pedantic : trop d'erreurs
# https://gcc.gnu.org/onlinedocs/gcc-5.1.0/gfortran/Fortran-Dialect-Options.html
#set(CMAKE_C_FLAGS "-Wall -D_REENTRANT" CACHE STRING "C compiler flags" FORCE)
#set(CMAKE_Fortran_FLAGS "-Wall -Wno-tabs -Wno-unused-but-set-variable -Wno-unused-dummy-argument -Wno-unused-value -Wno-unused-variable -Wno-conversion -fdump-core -fbacktrace -g -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic -fopenmp" CACHE STRING "Fortran compiler flags" FORCE)

# with optimisation flags only
# -O3: maximum optimisation: https://gcc.gnu.org/onlinedocs/gcc-5.1.0/gcc/Optimize-Options.html
# -w: Inhibit all warning messages: https://gcc.gnu.org/onlinedocs/gcc-5.1.0/gcc/Warning-Options.html
# Other Fortran options: https://gcc.gnu.org/onlinedocs/gcc-5.1.0/gfortran/Option-Summary.html
#set(CMAKE_C_FLAGS "-O3 -w -D_REENTRANT" CACHE STRING "C compiler flags" FORCE)
#set(CMAKE_Fortran_FLAGS "-O3 -w -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic -fopenmp" CACHE STRING "Fortran compiler flags" FORCE)

# original flags in previous version of Linux-x86_64-gfortran
set(CMAKE_C_FLAGS "-O2 -g -w -D_REENTRANT" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_Fortran_FLAGS "-O2 -fdump-core -fbacktrace -g -w -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -fpic -fopenmp" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s -fopenmp -fpic")
set(MPI_Fortran_COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS} ${CMAKE_Fortran_FLAGS}" CACHE STRING "Fortran compiler flags")

set(LAPACK_LIBRARIES "-llapack")
set(BLAS_LIBRARIES "-lblas")

#get_cmake_property(_variableNames VARIABLES)
#list (SORT _variableNames)
#foreach (_variableName ${_variableNames})
#    message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()
