# Default configuration for the GNU compiler suite
# Input:
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

add_definitions(-DLittle_Endian)

set(LAPACK_LIBRARIES "lapack")
message(STATUS "LAPACK_LIBRARIES=${LAPACK_LIBRARIES}")

set(BLAS_LIBRARIES "blas")
message(STATUS "BLAS_LIBRARIES=${BLAS_LIBRARIES}")
# Since we are now using CMake mechanisms to build shared libraries
# (BUILD_SHARED_LIBS), removed -fpic from CMAKE_C_FLAGS to see if it works
set(CMAKE_C_FLAGS "-w -Wall -Wextra")
set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_C_FLAGS_RELEASE "-O2")

set(CMAKE_Fortran_FLAGS "-Wall -Wextra -Wno-compare-reals -Wno-conversion -Wno-unused-dummy-argument -Wno-unused-parameter -fbacktrace -fconvert=big-endian -fcray-pointer -fdump-core -ffpe-trap=invalid,zero,overflow -ffree-line-length-none -finit-real=nan -fno-second-underscore -frecord-marker=4")
set(CMAKE_Fortran_FLAGS_DEBUG "-g")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")


#CMAKE_Fortran_COMPILER_VERSION
#CMAKE_C_COMPILER_VERSION
if(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 7.4)
    message(WARNING "This code might not work with such an old compiler!  Please consider upgrading.")
elseif(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 9)
    message(WARNING "Old compiler, but should work")
elseif(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 9 AND CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 10)
    message(STATUS "Compiler is modern and everything should be tip-top")
elseif(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
    message(WARNING "Our code has not yet been updated to work with GNU compilers 10.x; adding extra options to be more permissive.")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fallow-argument-mismatch")
endif()


# Set the target architecture
if(NOT TARGET_PROC)
    set(TARGET_PROC "native")
endif()
message(STATUS "Target architecture: ${TARGET_PROC}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=${TARGET_PROC}")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -march=${TARGET_PROC}")

# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")


if (EXTRA_CHECKS)
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fanalyzer -fsanitize=bounds -fsanitize=alignment -fstack-protector-all -fstack-check -fstack-clash-protection")
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fcheck=all -fsanitize=bounds -fsanitize=alignment")
   set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -fsanitize=bounds -fsanitize=alignment")
endif()
