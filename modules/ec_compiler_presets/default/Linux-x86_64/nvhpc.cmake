# Copyright 2021, Her Majesty the Queen in right of Canada

add_definitions(-DLittle_Endian)
add_link_options(-Wl,--as-needed)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-tp native -Mvect=noassoc -Mlre=noassoc -Mnoflushz -Mnodaz")
    set(CMAKE_C_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_C_FLAGS " -pg")
    endif()

    if(WITH_WARNINGS)
        string(APPEND CMAKE_C_FLAGS " -Wall -Wextra -Wpedantic")
    endif()
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-tp native -byteswapio -fast -Mvect=fuse,simd -Mvect=noassoc -Mlre=noassoc -Mnoflushz -Mnodaz -Kieee -traceback" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_Fortran_FLAGS " -pg")
    endif()
endif()
