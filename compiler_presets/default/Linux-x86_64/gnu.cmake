# Default configuration for the GNU compiler suite
# Input:
#  LANGUAGES List of languages to enable for the project
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

# The full path of the compiler for <LANG> must be set in CMAKE_<LANG>_COMPILER
# before calling enable_language(<LANG>)
find_program(CMAKE_C_COMPILER "gcc")
find_program(CMAKE_Fortran_COMPILER "gfortran")

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
set(CMAKE_C_FLAGS "-march=native -w -Wall -Wextra")
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O2")

set(CMAKE_Fortran_FLAGS "-march=native -Wall -Wextra -Wno-compare-reals -Wno-conversion -Wno-unused-dummy-argument -Wno-unused-parameter -fbacktrace -fconvert=big-endian -fcray-pointer -fdump-core -ffpe-trap=invalid,zero,overflow -ffree-line-length-none -finit-real=nan -fno-second-underscore -frecord-marker=4")
set(CMAKE_Fortran_FLAGS_DEBUG "-g")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

if (EXTRA_CHECKS)
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fsanitize=bounds -fsanitize=alignment -fstack-protector-all -fstack-check -fstack-clash-protection")
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fcheck=all -fsanitize=bounds -fsanitize=alignment")
   set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -fsanitize=bounds -fsanitize=alignment")
endif()
