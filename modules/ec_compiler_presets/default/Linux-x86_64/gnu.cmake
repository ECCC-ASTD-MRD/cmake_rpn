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
add_link_options(-Wl,--as-needed)

if("C" IN_LIST languages)
    # set(CMAKE_C_FLAGS "-ffunction-sections -fdata-sections -ftree-vectorize -march=${TARGET_PROC}")
    set(CMAKE_C_FLAGS "-ftree-vectorize -march=${TARGET_PROC}")
    set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g3 -DNDEBUG")
    set(CMAKE_C_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_C_FLAGS " -pg")
    endif()

    if(STRICT)
        string(APPEND CMAKE_C_FLAGS " -Werror=uninitialized")
    endif()

    message(DEBUG "CMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-fconvert=big-endian -fcray-pointer -frecord-marker=4 -fno-second-underscore -ffree-line-length-none -finit-real=nan -ftree-vectorize -march=${TARGET_PROC} -fstack-arrays")
    set(CMAKE_Fortran_FLAGS_DEBUG "-fbacktrace -ffpe-trap=invalid,zero,overflow -O0 -g3")
    set(CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-O2 -g3")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_Fortran_FLAGS " -pg")
    endif()

    if(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 7.4)
        message(WARNING "(EC) This code might not work with such an old compiler!  Please consider upgrading.")
    elseif(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
        message(STATUS "(EC) Our code has not yet been updated to work with GNU compilers 10.x; adding extra options to be more permissive: -fallow-argument-mismatch.")
        string(APPEND CMAKE_Fortran_FLAGS " -fallow-argument-mismatch")
    endif()
    message(DEBUG "CMAKE_Fortran_FLAGS=${CMAKE_Fortran_FLAGS}")
endif()

# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

if(WITH_WARNINGS)
    if("C" IN_LIST languages)
        string(APPEND CMAKE_C_FLAGS " -Wall -Wextra -Wpedantic")
    endif()

    if("Fortran" IN_LIST languages)
        string(APPEND CMAKE_Fortran_FLAGS " -Wall -Wextra")
    endif()
endif()

if (EXTRA_CHECKS)
    if("C" IN_LIST languages)
        string(APPEND CMAKE_C_FLAGS " -fsanitize=bounds -fsanitize=alignment -fstack-protector-all -fstack-check")
        if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 8)
            string(APPEND CMAKE_C_FLAGS " -fstack-clash-protection")
        endif()
        if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
            string(APPEND CMAKE_C_FLAGS " -fanalyzer")
        endif()
    endif()

    if("Fortran" IN_LIST languages)
        string(APPEND CMAKE_Fortran_FLAGS " -fcheck=all -fsanitize=bounds -fsanitize=alignment")
    endif()

    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -fsanitize=bounds -fsanitize=alignment")
endif()
