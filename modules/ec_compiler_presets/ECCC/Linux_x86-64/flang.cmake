# Copyright 2021, Her Majesty the Queen in right of Canada

message(FATAL "(EC) This combinaison of compiler and architecture not yet ready for use")

add_definitions(-DLittle_Endian)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-W" CACHE STRING "C compiler flags" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "-g")
    set(CMAKE_C_FLAGS_RELEASE "-O2")
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-fdump-core -fbacktrace -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_DEBUG "-g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    set(MPI_Fortran_COMPILE_FLAGS "${MPI_Fortran_COMPILE_FLAGS} ${CMAKE_Fortran_FLAGS}" CACHE STRING "Fortran compiler flags")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s")
