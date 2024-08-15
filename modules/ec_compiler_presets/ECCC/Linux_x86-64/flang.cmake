# Copyright 2021, Her Majesty the Queen in right of Canada

message(FATAL "(EC) This combinaison of compiler and architecture not yet ready for use")

add_definitions(-DLittle_Endian)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-W" CACHE STRING "C compiler flags" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_C_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_C_FLAGS " -fprofile-generate")
    endif()
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-fdump-core -fbacktrace -fcray-pointer -fconvert=big-endian -frecord-marker=4 -fno-second-underscore -ffree-line-length-none" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_Fortran_FLAGS " -fprofile-generate")
    endif()

    string(APPEND MPI_Fortran_COMPILE_FLAGS " ${CMAKE_Fortran_FLAGS}")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s")
