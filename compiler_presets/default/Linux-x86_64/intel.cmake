# Default configuration for the GNU compiler suite
# Input:
#  LANGUAGES List of languages to enable for the project
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

# The full path of the compiler for <LANG> must be set in CMAKE_<LANG>_COMPILER
# before calling enable_language(<LANG>)
find_program(CMAKE_C_COMPILER "icc")
find_program(CMAKE_Fortran_COMPILER "ifort")

# Do these need to be here if we don't use MPI?  Are there any adverse effect to
# having them?
find_program(MPI_C_COMPILER "mpicc")
find_program(MPI_Fortran_COMPILER "mpif90")

# I don't know why, but enable_language empties CMAKE_BUILD_TYPE!
# We therefore have to back it up and restore it after enable_language
message(STATUS "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
set(TMP_BUILD_TYPE ${CMAKE_BUILD_TYPE})

foreach(LANGUAGE ${LANGUAGES})
   enable_language(${LANGUAGE})
endforeach()

# Reset CMAKE_BUILD_TYPE
set(CMAKE_BUILD_TYPE ${TMP_BUILD_TYPE})
unset(TMP_BUILD_TYPE)
message(STATUS "CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")

# find_package() commands can only be called after the languages have been 
# eneabled or they will fail

add_definitions(-DLittle_Endian)

set(LAPACK_LIBRARIES "lapack")
message(STATUS "LAPACK_LIBRARIES=${LAPACK_LIBRARIES}")

set(BLAS_LIBRARIES "blas")
message(STATUS "BLAS_LIBRARIES=${BLAS_LIBRARIES}")

# Since we are now using CMake mechanisms to build shared libraries
# (BUILD_SHARED_LIBS), removed -fpic from CMAKE_C_FLAGS to see if it works
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS "-fp-model source -ip -mkl -traceback -Wtrigraphs" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS_DEBUG "-g")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
set(CMAKE_Fortran_FLAGS "-align array32byte -assume byterecl -convert big_endian -fpe0 -fp-model source -ip -mkl -traceback -stand f08 -diag-disable 7713 -diag-disable 10212 -diag-disable 5140" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "--allow-shlib-undefined -mkl -static-intel")


# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

# Set the target architecture
if(NOT ARCH)
    # -xHost is the Intel equivalent of GCC's -march=native
    set(ARCH "Host")
endif()
message(STATUS "Target architecture: ${ARCH}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -x${ARCH}")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -x${ARCH}")


if (EXTRA_CHECKS)
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -warn all -check all")
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -warn all -check all")
   set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -warn all -check all")
endif()
