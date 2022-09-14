# Copyright 2021, Her Majesty the Queen in right of Canada

option(WITH_OPENMP "Compile with OpenMP support" FALSE)
if (WITH_OPENMP)
    message(STATUS "(EC) Building WITH OpenMP")

    # Normalize thruth value
    set(WITH_OPENMP TRUE)

    find_package(OpenMP)
else()
    message(STATUS "(EC) Building WITHOUT OpenMP")
endif()
