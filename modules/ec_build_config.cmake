# Build [target]-config script which describes the build parameters.
# How to use:
#    - Copy the config.in file from cmake_rpn.
#    - Edit and remove the components not involved in your project
#    - Call the ec_build_config macro. 
#    - The script will be installed in the installation's bin directory.
#
# The following info is provided:
#   --cc           C compiler [${cc}]
#   --fc           FORTRAN compiler [${ftn}]
#   --cflags       C compiler flags [${cflags}]
#   --fflags       Fortran compiler flags [${fflags}]
#   --defs         Preprocessor definitions [${defs}]
#   --version      library version [${version}]
#   --arch         architecture [${arch}]
#   --env          environment version [${env}]
#   --has-rmn      which version of librmn is it compiled with [${has_rmn}]
#   --has-vgrid    which version of vgrid is it compiled with [${has_vgrid}]
#   ...


include(${CMAKE_CURRENT_LIST_DIR}/ec_debugLog.cmake)


option(GENERATE_BUILD_CONFIG "Generate a shell script returning information about the build")


macro(ec_build_config)
    set(GENERATE_BUILD_CONFIG ON CACHE BOOL "Generate a shell script returning information about the build" FORCE)
    debugLogVar("ec_build_config.cmake" GENERATE_BUILD_CONFIG)

    # Get preprocessor defines
    get_directory_property(EC_CMAKE_DEFINITIONS DIRECTORY ${CMAKE_SOURCE_DIR} COMPILE_DEFINITIONS)
    list(TRANSFORM EC_CMAKE_DEFINITIONS PREPEND "-D")
    list(JOIN EC_CMAKE_DEFINITIONS " " EC_CMAKE_DEFINITIONS)

    # Build flags list
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(EC_C_FLAGS "${EC_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}")
        set(EC_Fortran_FLAGS "${EC_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_DEBUG}")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(EC_C_FLAGS "${EC_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}")
        set(EC_Fortran_FLAGS "${EC_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_RELEASE}")
    else()
        set(EC_C_FLAGS "${CMAKE_C_FLAGS}")
        set(EC_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    endif()

    debugLogVar("ec_build_config" "PROJECT_NAME")
    debugLogVar("ec_build_config" GENERATE_BUILD_CONFIG)
    debugLogVar("ec_build_config" EC_C_FLAGS)
    debugLogVar("ec_build_config" EC_Fortran_FLAGS)
    debugLogVar("ec_build_config" EC_CMAKE_DEFINITIONS)

    install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config DESTINATION bin/${EC_SSM_ARCH})
endmacro()
