# Copyright 2021, Her Majesty the Queen in right of Canada

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS_RELEASE "-O2")
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-fast -Mvect=fuse,simd -Kieee -traceback" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "--allow-shlib-undefined" CACHE STRING "Linker flags" FORCE)
