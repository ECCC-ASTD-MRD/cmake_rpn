# Copyright 2021, Her Majesty the Queen in right of Canada

option(WITH_OPENMP "Compile with OpenMP support" FALSE)
if (WITH_OPENMP)
    message(STATUS "(EC) Building WITH OpenMP")

    # Normalize thruth value
    set(WITH_OPENMP TRUE)

    find_package(OpenMP)
    if (NOT OPENMP_FOUND)
        message(FATAL_ERROR "(EC) OpenMP was requested, but was not found!")
    endif()
    if(OpenMP_C_FLAGS)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
    endif()
    if(OpenMP_Fortran_FLAGS)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
    else()
        # If we can't find Fortran flags, fallback on C flags
        message(WARNING "(EC) OpenMP couldn't find Fortran OpenMP Flags.  Falling back on C Flags.")
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_C_FLAGS}")
    endif()
else()
    message(STATUS "(EC) Building WITHOUT OpenMP")
endif()
