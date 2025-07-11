# Copyright 2021, Her Majesty the Queen in right of Canada

# Default configuration for the Intel compiler suite
# Input:
#  EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

# Compiler shared library location
list(APPEND CMAKE_INSTALL_RPATH $ENV{CMPLR_ROOT}/linux/compiler/lib/intel64)

# Set the target architecture
if(NOT TARGET_PROC)
    set(TARGET_PROC "graniterapids")
endif()
message(STATUS "(EC) Target architecture: ${TARGET_PROC}")

add_definitions(-DLittle_Endian)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-fp-model precise -traceback -Wtrigraphs -x${TARGET_PROC}" CACHE STRING "C compiler flags" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "-O0 -g -ftrapuv")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g -DNDEBUG")
    set(CMAKE_C_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_C_FLAGS " -pg")
    endif()

    # Disable some warnings
    # 10441: icc deprecation in favor of icx
    string(APPEND CMAKE_C_FLAGS " -diag-disable=10441")
endif()

if("Fortran" IN_LIST languages)
    set(CMAKE_Fortran_FLAGS "-convert big_endian -align array32byte -assume byterecl -fp-model source -fpe0 -traceback -stand f08 -x${TARGET_PROC}" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g -ftrapuv")
    set(CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-O2 -g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")

    if(WITH_PROFILING)
        string(APPEND CMAKE_Fortran_FLAGS " -pg")
    endif()

    # Disable some warnings
    # 5268: Line length above 132 columns
    # 7025: Non-standard F2008 directive
    # 7373:  Fixed-form is an obsolescent feature in F2008
    string(APPEND CMAKE_Fortran_FLAGS " -diag-disable=5268,7025,7373")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "--allow-shlib-undefined")

# There might be extra OpenMP and OpenACC flags which are specific to each compiler,
# that are not added the find_package(OpenACC)
# It doesn't matter if we defined them even if OpenACC isn't used because the
# OpenACC_extra_FLAGS variable just won't be used
set(OpenACC_extra_FLAGS "-fopt-info-optimized-omp")

if (EXTRA_CHECKS)
    if("C" IN_LIST languages)
        string(APPEND CMAKE_C_FLAGS " -Wall")
    endif()

    if("Fortran" IN_LIST languages)
        string(APPEND CMAKE_Fortran_FLAGS " -warn all -check all")
    endif()

    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -warn all -check all")
endif()
