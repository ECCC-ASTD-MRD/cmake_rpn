# Default configuration for the Intel compiler suite
# Input:
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

add_definitions(-DLittle_Endian)

# Intel compiler diag codes (Use icc or ifort -diag-dump to get the full list) :
#    5140: Unrecognized directive
#    6182: Fortran @@ does not allow this edit descriptor.
#    7416: Fortran @@ does not allow this intrinsic procedure.
#    7713: This statement function has not been used.
#   10212: xxxx%sprecise evaluates in source precision with Fortran.

# When we will want to have flags different from the compiler rules, we should add
#   -ip To enable additional interprocedural optimizations
#   -threads The linker searches for unresolved references in a library that supports enabling thread-safe operation.

set(CMAKE_C_FLAGS_DEBUG "-g -ftrapuv")
set(CMAKE_C_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS "-fp-model precise -mkl -traceback -Wtrigraphs" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS_DEBUG "-g -ftrapuv")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
set(CMAKE_Fortran_FLAGS "-align array32byte -assume byterecl -convert big_endian -fp-model source -fpe0 -mkl -traceback -stand f08 -diag-disable 5140 -diag-disable 7713 -diag-disable 10212" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "--allow-shlib-undefined -mkl -static-intel")

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_definitions(-DDEBUG)
endif()

# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

# Set the target architecture
if(NOT TARGET_PROC)
    set(TARGET_PROC "sse3")
endif()
message(STATUS "Target architecture: ${TARGET_PROC}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m${TARGET_PROC}")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -m${TARGET_PROC}")


if (EXTRA_CHECKS)
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -warn all -check all")
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -warn all -check all")
   set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -warn all -check all")
endif()
