# Find librmn and required build options
#
# This file will only work if ec_init() has been called first!
#
# Input variables:
#   RMN_ROOT Root of the librmn installation.  If this is provided, no other paths will be checked.
#   RMN_LINK_TYPE Specify how librmn should be linked (STATIC|SHARED).  Default: BUILD_SHARED_LIBS if explicitly defined, STATIC if not
#   RMN_MIN_VERSION Minimum required version
#
# Output variables:
#   RMN_LIBRARY Path of the library file
#   RMN_INCLUDE_DIR Path of the folder containing the library's include files
#   RMN_VERSION Version of the library found



# [[DOC]] for find_package (lists variables that are set automatically by CMake)
# https://cmake.org/cmake/help/v3.16/command/find_package.html

# [[DOC]] https://cmake.org/cmake/help/v3.16/manual/cmake-developer.7.html


if(DEFINED RMN_LINK_TYPE)
    string(TOUPPER ${RMN_LINK_TYPE} RMN_LINK_TYPE)
    if(NOT RMN_LINK_TYPE MATCHES "(SHARED|STATIC)")
        message(FATAL_ERROR "(EC) RMN_LINK_TYPE must be SHARED or STATIC!")
    endif()
else()
    if(DEFINED BUILD_SHARED_LIBS)
        message(STATUS "(EC) BUILD_SHARED_LIBS explicitly defined.  Using it to set RMN_LINK_TYPE accordingly.")
        if(BUILD_SHARED_LIBS)
            set(RMN_LINK_TYPE SHARED)
        else()
            set(RMN_LINK_TYPE STATIC)
        endif()
    else()
        message(STATUS "(EC) BUILD_SHARED_LIBS not explictly defined defaulting to STATIC linking for librmn.")
        set(RMN_LINK_TYPE STATIC)
    endif()
endif()
message(STATUS "(EC) RMN_LINK_TYPE=${RMN_LINK_TYPE}")

if(DEFINED RMN_ROOT)
    message(STATUS "(EC) RMN_ROOT=${RMN_ROOT}")
    find_path(RMN_INCLUDE_DIR NAMES "librmn_build_info.h" PATHS ${RMN_ROOT}/include NO_DEFAULT_PATH)
    if(NOT RMN_INCLUDE_DIR)
        message(FATAL_ERROR "include/librmn_build_info.h was not found in the provided RMN_ROOT (${RMN_ROOT})")
    endif()
else()
    find_path(RMN_INCLUDE_DIR NAMES "librmn_build_info.h" PATHS ENV EC_INCLUDE_PATH ENV CPATH)
endif()
message(STATUS "(EC) RMN_INCLUDE_DIR=${RMN_INCLUDE_DIR}")

if(RMN_LINK_TYPE MATCHES "STATIC")
    SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
endif()

if(DEFINED RMN_ROOT)
    find_library(RMN_LIBRARY rmn PATHS ${RMN_ROOT}/lib)
else()
    find_library(RMN_LIBRARY rmn PATHS ENV EC_LD_LIBRARY_PATH ENV LD_LIBRARY_PATH)
endif()
message(STATUS "(EC) RMN_LIBRARY=${RMN_LIBRARY}")

# Get version from the library's binary
file(
    WRITE
    ${CMAKE_CURRENT_BINARY_DIR}/print_librmn_version.c
    "#include <stdio.h>
extern char librmn_version[];
int main() {
    printf(\"%s\\n\", librmn_version);
    return 0;
}\n"
)
get_filename_component(RMN_LIBRARY_DIR ${RMN_LIBRARY} DIRECTORY)
execute_process(
    COMMAND ${CMAKE_C_COMPILER} -Wl,-rpath,${RMN_LIBRARY_DIR} ${CMAKE_CURRENT_BINARY_DIR}/print_librmn_version.c ${RMN_LIBRARY} -o ${CMAKE_CURRENT_BINARY_DIR}/print_librmn_version
)
execute_process(
    COMMAND ${CMAKE_CURRENT_BINARY_DIR}/print_librmn_version
    OUTPUT_VARIABLE RMN_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(STATUS "(EC) RMN_VERSION=${RMN_VERSION}")

# Extract version from the include file
file(READ ${RMN_INCLUDE_DIR}/librmn_build_info.h RMN_BUILD_INFO)
string(REGEX MATCH "\n#define +VERSION +\"([^\"]*)\"\n" null ${RMN_BUILD_INFO})
set(RMN_HEADER_VERSION ${CMAKE_MATCH_1})
message(STATUS "(EC) RMN_HEADER_VERSION=${RMN_HEADER_VERSION}")

if(NOT ${RMN_VERSION} MATCHES ${RMN_HEADER_VERSION})
    message(FATAL_ERROR "Header version does not match lib binary!")
endif()

string(REGEX MATCH "\n#define +WITH_OPENMP +\"([^\"]*)\"\n" null ${RMN_BUILD_INFO})
set(RMN_WITH_OPENMP ${CMAKE_MATCH_1})
message(STATUS "(EC) Librmn compiled WITH_OPENMP=${RMN_WITH_OPENMP}")

string(REGEX MATCH "\n#define +C_COMPILER_ID +\"([^\"]*)\"\n" null ${RMN_BUILD_INFO})
set(RMN_C_COMPILER_ID ${CMAKE_MATCH_1})
message(STATUS "(EC) Librmn compiled with ${RMN_C_COMPILER_ID}")

unset(RMN_HEADER_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    rmn
    FOUND_VAR RMN_FOUND
    REQUIRED_VARS
        RMN_LIBRARY
        RMN_INCLUDE_DIR
    VERSION_VAR RMN_VERSION
)

if(RMN_FOUND)
    mark_as_advanced(RMN_INCLUDE_DIR RMN_LIBRARY)

    add_library(rmn ${RMN_LINK_TYPE} IMPORTED)
    set_target_properties(
        rmn PROPERTIES
        IMPORTED_LOCATION ${RMN_LIBRARY}
        INTERFACE_INCLUDE_DIRECTORIES ${RMN_INCLUDE_DIR}
        INTERFACE_COMPILE_DEFINITIONS WITH_RMN
    )
    if(${RMN_WITH_OPENMP} MATCHES "TRUE")
        target_compile_options(rmn INTERFACE -fopenmp)
        target_link_options(rmn INTERFACE -fopenmp)
    endif()
    target_compile_options(rmn
        INTERFACE $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-fconvert=big-endian -fcray-pointer -fno-second-underscore -frecord-marker=4>
                  $<$<COMPILE_LANG_AND_ID:Fortran,Intel>:-align array32byte -assume byterecl -convert big_endian>
    )

    # TODO Add flags for MKL when librmn was compiled with it
    # target_compile_options(rmn
    #     INTERFACE $<$<COMPILE_LANG_AND_ID:C,Intel>:-mkl>
    #                 $<$<COMPILE_LANG_AND_ID:Fortran,GNU>:-fconvert=big-endian -fcray-pointer -fno-second-underscore -frecord-marker=4>
    #                 $<$<COMPILE_LANG_AND_ID:Fortran,Intel>:-align array32byte -assume byterecl -convert big_endian -mkl>
    # )

    # This does not work; it adds "-lmkl" which is not what we need
    # if(${RMN_C_COMPILER_ID} MATCHES "Intel")
    #     target_link_libraries(rmn INTERFACE mkl)
    # endif()
endif()


# if("rpnpy" IN_LIST RMN_FIND_COMPONENTS)
#    message("Component rpnpy requested")
#    # Let's say we don't find it
#    set(RMN_rpnpy_FOUND)
#    if(${RMN_FIND_REQUIRED_rpnpy})
#       message(FATAL_ERROR "Could not find required component rpnpy")
#    else()
#       message("Could not find component rpnpy")
#    endif()
# endif()
