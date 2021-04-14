# Default configuration for the Intel compiler suite
# Input:
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

add_definitions(-DLittle_Endian)

set(CMAKE_C_FLAGS_DEBUG "-g -ftrapuv")
set(CMAKE_C_FLAGS_RELEASE "-O2")
set(CMAKE_C_FLAGS "-fp-model precise -traceback -Wtrigraphs" CACHE STRING "C compiler flags" FORCE)

set(CMAKE_Fortran_FLAGS_DEBUG "-g -ftrapuv")
set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
set(CMAKE_Fortran_FLAGS "-align array32byte -assume byterecl -convert big_endian -fp-model source -fpe0 -traceback -stand f08" CACHE STRING "Fortran compiler flags" FORCE)

set(CMAKE_EXE_LINKER_FLAGS_INIT "--allow-shlib-undefined -static-intel")

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
    set(TARGET_PROC "CORE-AVX512")
endif()
message(STATUS "Target architecture: ${TARGET_PROC}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -x${TARGET_PROC}")
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -x${TARGET_PROC}")


if (EXTRA_CHECKS)
   set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -warn all -check all")
   set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -warn all -check all")
   set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -warn all -check all")
endif()
