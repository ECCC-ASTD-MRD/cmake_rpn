# Copyright 2021, Her Majesty the Queen in right of Canada

# Default configuration for the GNU compiler suite
# Input:
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

# Set the target architecture
if(NOT TARGET_PROC)
    set(TARGET_PROC "native")
endif()
message(STATUS "(EC) Target architecture: ${TARGET_PROC}")

add_definitions(-DLittle_Endian)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-ftree-vectorize -march=${TARGET_PROC}")
    set(CMAKE_C_FLAGS_DEBUG "-Wall -Wextra -pedantic -O0 -g")
    set(CMAKE_C_FLAGS_RELEASE "-O2")
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-fconvert=big-endian -fcray-pointer -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -finit-real=nan -ftree-vectorize -march=${TARGET_PROC}")
    set(CMAKE_Fortran_FLAGS_DEBUG "-Wall -Wextra -fbacktrace -ffpe-trap=invalid,zero,overflow -O0 -g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    if(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 7.4)
        message(WARNING "(EC) This code might not work with such an old compiler!  Please consider upgrading.")
    elseif(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
        message(STATUS "(EC) Our code has not yet been updated to work with GNU compilers 10.x; adding extra options to be more permissive: -fallow-argument-mismatch.")
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fallow-argument-mismatch")
    endif()
endif()

# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

if (EXTRA_CHECKS)
    if("C" IN_LIST languages)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fsanitize=bounds -fsanitize=alignment -fstack-protector-all -fstack-check ")
        if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 8)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fstack-clash-protection")
        endif()
        if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
            set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fanalyzer")
        endif()
    endif()

    if("Fortran" IN_LIST languages)
        set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fcheck=all -fsanitize=bounds -fsanitize=alignment")
    endif()

    set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -fsanitize=bounds -fsanitize=alignment")
endif()
