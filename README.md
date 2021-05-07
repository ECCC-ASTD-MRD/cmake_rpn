# Description

This package contains common functions used throughout the build of various tools with cmake. 
It also defines a set of compilers presets optimized for ECCC's many platforms and compilers

# Usage
This package can be included as a submodule or used through the CMAKE_MODULE_PATH environment variable

## functions

* include(ec_init)
  * Initializes some variables and the compiler suite. If the compiler suite is not defined (cmake -COMPILER_SUITE=[gnu|intel|xlf], it will be determined by the compiler which is loaded on the platform. Default is gnu

* include(ec_compiler_presets)
  * Loads predefined compiler settings optimized per compiler and platform. must be included after languages are enabled

* include(ec_doxygen) 
  * Creates a __doc__ target to build the documentation with Doxygen.  Plase note that the __doc__ target is not included in __all__.  This means that it won't be built when running ```make```.  To build the documentation, ```make doc``` must be executed explicitly.

* ec_parse_manifest
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

* ec_git_version
  * Extracts the version from git information into variable GIT_VERSION.

* ec_build_info
  * Produces an header file (${PROJECT_NAME}_build_info.h) with build information and an associated target (build_info) that will update the timestamp and version when ```make``` is invoked.  The following definitions will be present in the generated header file:
    * PROJECT_NAME
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

* config.in
  * This is a file used to build a configuration information script "[NAME]-config" giving information on how the package was built (compiler, rmn_version, ...) which will end-up in the bin directory. Copy to your project base directory and remove/add packages within it then add this within you CMakeLists.txt:
```cmake
       configure_file(config.in ${CMAKE_BINARY_DIR}/${NAME}-config @ONLY)
       install(PROGRAMS ${CMAKE_BINARY_DIR}/${NAME}-config DESTINATION bin)
```

* ec_dump_cmake_variables :
  * Dumps all of the cmake variables sorted.


* find_package(RMN [RMN_REQ_VERSION] COMPONENTS [SHARED|THREADED] [OPTIONAL|REQUIRED])
* find_package(VGRID [VGRID_REQ_VERSION] COMPONENTS [SHARED] [OPTIONAL|REQUIRED])
* find_package(ECCODES [ECCODES_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(ECBUFR [ECBUFR_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(FLT [FLT_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(URP [URP_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(GDB [OPTIONAL|REQUIRED])
* find_package(R [OPTIONAL|REQUIRED])

## Example usage

```cmake
cmake_minimum_required(VERSION 3.12)

#----- Append EC specific module path
foreach(PATH $ENV{EC_CMAKE_MODULE_PATH})
   list(APPEND CMAKE_MODULE_PATH ${PATH})
endforeach()

include(ec_init)           # Include EC specific cmake utils
ec_parse_manifest()        # Parse MANIFEST file (optional)
ec_build_info()            # Generate build include file (optional)
ec_git_version()           # Get the version from the git repository

include(doxygen)           # Doxygen target (optional)

project("SomeProject" DESCRIPTION "Does something")
set(PROJECT_VERSION ${VERSION})

#----- Enable language before sourcing the compiler presets
enable_language(C Fortran)
enable_testing()

include(ec_compiler_presets)  # Include compiler specific flags

find_package(RMN ${RMN_REQ_VERSION} COMPONENTS SHARED OPTIONAL)
find_package(VGRID ${VGRID_REQ_VERSION} COMPONENTS SHARED OPTIONAL)

add_subdirectory(src src)

#----- Process config script
configure_file(config.in ${CMAKE_BINARY_DIR}/${NAME}-config @ONLY)
install(PROGRAMS ${CMAKE_BINARY_DIR}/${NAME}-config DESTINATION bin)
```
