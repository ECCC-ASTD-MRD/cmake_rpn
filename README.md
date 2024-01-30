# Description

This package contains common functions used throughout the build of various tools with cmake. 
It also defines a set of compilers presets optimized for ECCC's many platforms and compilers

# Usage

## Accessing the modules

CMake finds third party modules through the [`CMAKE_MODULE_PATH`](https://cmake.org/cmake/help/latest/variable/CMAKE_MODULE_PATH.html) CMake variable.

When loading the [code-tools](https://gitlab.science.gc.ca/RPN-SI/code-tools/) SSM package, the CMake modules in this package can be accessed using the `EC_CMAKE_MODULE_PATH` environment variable by adding it to `CMAKE_MODULE_PATH`:
```cmake
list(APPEND CMAKE_MODULE_PATH $ENV{EC_CMAKE_MODULE_PATH})
```

And if using CMake RPN as a submodule, the subdirectory `modules` of `cmake_rpn`
must be added to `CMAKE_MODULE_PATH`.  For example if `cmake_rpn` is a
submodule stored at the root of your repository:
```cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_rpn/modules
```


## functions

* include(ec_init)
  * Initializes some variables and the compiler suite. If the compiler suite is not defined (`cmake -DCOMPILER_SUITE=[gnu|intel|xlf|pgi|llvm]`, it will be determined by the compiler which is loaded on the platform. Default is gnu

* include(ec_compiler_presets)
  * Loads predefined compiler settings optimized per compiler and platform.  Must be included after languages are enabled

* include(ec_doxygen) 
  * Creates a __doc__ target to build the documentation with Doxygen.  Please note that the __doc__ target is not included in __all__.  This means that it won't be built when running ```make```.  To build the documentation, ```make doc``` must be executed explicitly.

* include(ec_org_manpages) 
  * Creates a __man__ target to build the man pages from org documents.

* ec_parse_manifest()
  * Parses a MANIFEST file defining package information and dependencies, and defines the variables NAME, VERSION, BUILD, DESCRIPTION, MAINTAINER, URL and for each dependencies [dependency]_REQ_VERSION, [dependency]_REQ_VERSION_MAJOR, [dependency]_REQ_VERSION_MINOR, [dependency]_REQ_VERSION_PATCH. ex:


```
NAME       : libgeoref
VERSION    : 0.1.0
BUILD      : Debug
DESCRIPTION: ECCC-CCMEP Geo reference manipulation library
SUMMARY    : This library allows for reprojection, coordinate transform and interpolation in between various type of geo reference (RPN,WTK,meshes,...)
MAINTAINER : Someone - Someone@canada.ca 
URL        : https://gitlab.science.gc.ca/RPN-SI/libgeoref

# Dependencies 
#    =,<,<=,>,>= : Version rules
#    ~           : Optional

RMN  ~>= 19.7.0
VGRID ~= 6.5.0
GDAL ~>= 2.0
```

* ec_git_version()
  * Extracts the version from git information into variable GIT_VERSION.

* ec_package_name()
  * Defines the variable PACKAGE_NAME using the EC convention (NAME_VERSION-COMPARCH-PLATFORM). 

* ec_install_symlink(filepath sympath)
  * Defines a symlink (sympath->filepath) to be invoked at the install step.

* ec_prepare_ssm()
  * Builds the ssm control file and pre/post install scripts if needed. To use, copy the .ssm.d/ directory to your projects ROOT and edit the pre/post install scripts as required. Information for the control file is taken from the MANIFEST file.

* ec_build_info()
  * Produces an header file (${PROJECT_NAME}_build_info.h) with build information and an associated target (build_info) that will update the timestamp and version when ```make``` is invoked.  The following definitions will be present in the generated header file:
    * PROJECT_NAME
    * PROJECT_NAME_STRING
    * PROJECT_VERSION_STRING
    * PROJECT_DESCRIPTION_STRING
    * VERSION
    * EC_ARCH
    * BUILD_USER
    * BUILD_TIMESTAMP
    * C_COMPILER_ID
    * C_COMPILER_VERSION
    * CXX_COMPILER_ID
    * CXX_COMPILER_VERSION
    * FORTRAN_COMPILER_ID
    * FORTRAN_COMPILER_VERSION

* ec_build_config()
  * Parses the file config.in to build a configuration information script "[NAME]-config" giving information on how the package was built (compiler, rmn_version, ...) which will end-up in the bin directory. Copy the cmake_rpn provided config.in file into your project and adjust the information needed.

* ec_dump_cmake_variables()
  * Dumps all of the cmake variables sorted.

* find_package functions
  * find_package(rmn [rmn_REQ_VERSION] COMPONENTS [shared|static] [OPTIONAL|REQUIRED])
  * find_package(vgrid [vgrid_REQ_VERSION] COMPONENTS [shared|static] [OPTIONAL|REQUIRED])
  * find_package(tdpack [tdpack_REQ_VERSION] COMPONENTS [shared|static] [OPTIONAL|REQUIRED])
  * find_package(rpncomm [rpncomm_REQ_VERSION] [OPTIONAL|REQUIRED])
  * find_package(ECCODES [ECCODES_REQ_VERSION] [OPTIONAL|REQUIRED])
  * find_package(ECBUFR [ECBUFR_REQ_VERSION] [OPTIONAL|REQUIRED])
  * find_package(FLT [FLT_REQ_VERSION] [OPTIONAL|REQUIRED])
  * find_package(URP [URP_REQ_VERSION] [OPTIONAL|REQUIRED])
  * find_package(GDB [OPTIONAL|REQUIRED])
  * find_package(R [OPTIONAL|REQUIRED])

## Example usage

```cmake
cmake_minimum_required(VERSION 3.16)

#----- Append EC specific module path
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake_rpn/modules $ENV{EC_CMAKE_MODULE_PATH})

include(ec_init)           # Include EC specific cmake utils
ec_git_version()           # Get the version from the git repository
ec_parse_manifest()        # Parse MANIFEST file (optional)

include(ec_doxygen)        # Doxygen target (optional)
include(ec_org_manpages)   # Generates manpages (optional)

project(${NAME} DESCRIPTION "${DESCRIPTION}" LANGUAGES C Fortran)
set(PROJECT_VERSION ${VERSION})

ec_build_info()            # Generate build include file
include(ec_compiler_presets)
ec_install_prefix()        # Define install prefix  

include(CTest)
add_custom_target(check COMMAND CTEST_OUTPUT_ON_FAILURE=true ${CMAKE_CTEST_COMMAND})

enable_testing()

include(ec_doxygen)          # Doxygen target (-DWITH_DOC=TRUE)
include(ec_openmp)           # Enable OpenMP (-DWITH_OPENMP=TRUE)

if (NOT rmn_FOUND)
   find_package(rmn ${RMN_REQ_VERSION} COMPONENTS shared REQUIRED)
endif()

add_subdirectory(src src)

#----- Generate the config file for the project to be usable via cmake's find_package command
set(INCLUDE_INSTALL_DIR include)
set(LIB_INSTALL_DIR     lib)
set(CONFIG_INSTALL_DIR  "${LIB_INSTALL_DIR}/cmake/${PROJECT_NAME}-${PROJECT_VERSION}")

include(CMakePackageConfigHelpers)
configure_package_config_file(
    "Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
    INSTALL_DESTINATION "${CONFIG_INSTALL_DIR}"
    PATH_VARS           INCLUDE_INSTALL_DIR LIB_INSTALL_DIR
)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion
)
install(FILES   "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
                "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION "${CONFIG_INSTALL_DIR}"
)

#----- Packaging
ec_package_name()       # Define package prefix  
ec_build_config()       # Create build configuration script
ec_prepare_ssm()        # Prepare ssm packaging files

set(CPACK_GENERATOR "TGZ")
set(CPACK_PACKAGE_VENDOR "ECCC")
set(CPACK_PACKAGE_CONTACT "${MAINTAINER}")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE.txt")
set(CPACK_RESOURCE_FILE_README "${CMAKE_CURRENT_SOURCE_DIR}/README.md")
set(CPACK_OUTPUT_FILE_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/package")
set(CPACK_PACKAGE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
set(CPACK_PACKAGE_FILE_NAME "${PACKAGE_NAME}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${NAME}_${PROJECT_VERSION}")
include(CPack)
```


# License
Please see the content of the __LICENSE__ file for liscensing information.
