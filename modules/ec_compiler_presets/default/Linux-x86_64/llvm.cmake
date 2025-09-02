# Copyright 2024, His Majesty the King in Right of Canada 
 
add_definitions(-DLittle_Endian)
add_link_options(-Wl,--as-needed)

if("C" IN_LIST languages)
  # original flags in previous version of Linux-x86_64-gfortran
  set(CMAKE_C_FLAGS "-W" CACHE STRING "C compiler flags" FORCE)
  set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
  set(CMAKE_C_FLAGS_RELEASE "-O2")
endif()

if("Fortran" IN_LIST languages)
  set(CMAKE_Fortran_FLAGS "-fconvert=big-endian -DFLANG_NEW " CACHE STRING "Fortran compiler flags" FORCE)
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "-s")
