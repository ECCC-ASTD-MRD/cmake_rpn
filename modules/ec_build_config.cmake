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

set(EC_BUILD_CONFIG_MACRO_DEF_DIR "${CMAKE_CURRENT_LIST_DIR}")

macro(ec_build_config)
    # Get preprocessor defines
    get_directory_property(EC_CMAKE_DEFINITIONS DIRECTORY ${CMAKE_SOURCE_DIR} COMPILE_DEFINITIONS)
    list(TRANSFORM EC_CMAKE_DEFINITIONS PREPEND "-D")
    list(JOIN EC_CMAKE_DEFINITIONS " " EC_CMAKE_DEFINITIONS)

    # Build flags list
    set(EC_C_FLAGS "${CMAKE_C_FLAGS}")
    set(EC_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(EC_C_FLAGS "${EC_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}")
        set(EC_Fortran_FLAGS "${EC_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_DEBUG}")
    endif()
    if(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(EC_C_FLAGS "${EC_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}")
        set(EC_Fortran_FLAGS "${EC_Fortran_FLAGS} ${CMAKE_Fortran_FLAGS_RELEASE}")
    endif()

    #   get_target_property(coptions tdpack COMPILE_OPTIONS)
    #   if(DEFINED COMPILE_OPTIONS)
    #      set(EC_COPTIONS "${EC_COPTIONS} ${EC_CMAKE_COPTIONS})

    string(TIMESTAMP BUILD_TIMESTAMP "%Y-%m-%d %H:%M" UTC)

    # Replace build info variables in script
    if(NOT IS_READABLE ${CMAKE_CURRENT_SOURCE_DIR}/config.in)
        message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_DIR}/config.in not found!\n\
Please copy\n${EC_BUILD_CONFIG_MACRO_DEF_DIR}/config.in\n\
to your project and edit it to remove the unnecessary components.")
    endif()
    configure_file(config.in ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config @ONLY)
    if(NOT CMAKE_SKIP_INSTALL_RULES)
        install(PROGRAMS ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-config DESTINATION bin/${EC_SSM_ARCH})
    endif()
endmacro()
