# Copyright 2021, Her Majesty the Queen in right of Canada

add_definitions(-DLittle_Endian)
add_link_options(-Wl,--as-needed)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-Wno-static-in-inline -march=native " CACHE STRING "C compiler flags" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_C_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_C_FLAGS " -fprofile-instr-generate")
    endif()

    if(STRICT)
        string(APPEND CMAKE_C_FLAGS " -Werror=uninitialized")
    endif()
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-Mbyteswapio -Wno-unused-command-line-argument" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_Fortran_FLAGS " -fprofile-instr-generate")
    endif()
endif()
