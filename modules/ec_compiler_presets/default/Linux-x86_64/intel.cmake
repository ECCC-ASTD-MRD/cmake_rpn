# Copyright 2021, Her Majesty the Queen in right of Canada

# Default configuration for the Intel compiler suite
# Input:
# EXTRA_CHECKS Enable extra checking.  This will make the execution slower.

include(${CMAKE_CURRENT_LIST_DIR}/../../../ec_debugLog.cmake)

debugLogVar("intel.cmake" "CMAKE_C_COMPILER")
debugLogVar("intel.cmake" "CMAKE_C_COMPILER_VERSION")
debugLogVar("intel.cmake" "CMAKE_C_COMPILER_ID")

# Set the target architecture
if(NOT TARGET_PROC)
    execute_process(COMMAND lscpu COMMAND grep Flags COMMAND cut -d: -f2- OUTPUT_VARIABLE CPU_FLAGS)
    if(CPU_FLAGS MATCHES avx512)
        set(TARGET_PROC x86-64-v4)
    elseif(CPU_FLAGS MATCHES avx2 AND CPU_FLAGS MATCHES fma)
        set(TARGET_PROC x86-64-v3)
    elseif(CPU_FLAGS MATCHES sse4_2)
        set(TARGET_PROC x86-64-v2)
    else()
        set(TARGET_PROC x86-64)
    endif()
    unset(CPU_FLAGS)
endif()
message(STATUS "(EC) Target architecture: ${TARGET_PROC}")

add_definitions(-DLittle_Endian)

if("C" IN_LIST languages)
    set(CMAKE_C_FLAGS "-fp-model precise -traceback -Wtrigraphs -march=${TARGET_ARCH}" CACHE STRING "C compiler flags" FORCE)
    set(CMAKE_C_FLAGS_DEBUG "-O0 -g")
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
    set(CMAKE_Fortran_FLAGS "-convert big_endian -align array32byte -assume byterecl -fp-model source -fpe0 -traceback -stand f08 -march=${TARGET_PROC}" CACHE STRING "Fortran compiler flags" FORCE)
    set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_Fortran_FLAGS_RELWITHDEBINFO "-O2 -g")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
    if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 2024.2)
        string(APPEND CMAKE_C_FLAGS_DEBUG " -ftrapv")
    else()
        string(APPEND CMAKE_C_FLAGS_DEBUG " -ftrapuv")
    endif()

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

if(WITH_WARNINGS)
    if("C" IN_LIST languages)
        string(APPEND CMAKE_C_FLAGS " -Wall")
    endif()

    if("Fortran" IN_LIST languages)
        string(APPEND CMAKE_Fortran_FLAGS " -warn all")
    endif()
endif()

if(EXTRA_CHECKS)
    message(STATUS "(EC) Enabling extra checks")

    if("Fortran" IN_LIST languages)
        string(APPEND CMAKE_Fortran_FLAGS " -check all")
    endif()

    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -check all")
endif()
