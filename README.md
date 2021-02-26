# Description

This package contains common functions used thoughout the building of various tools with cmake. 
It also defines a set of compilers rules optimized for ECCC's many platforms and compilers

# Usage
This package can be included as a submodule or used through the CMAKE_MODULE_PATH environment variable

## functions

* include(ec_init)
* include(ec_parse_manifest)
* include(ec_build_info)
* include(doxygen) 
* include(compiler_presets)
* include(ec_bin_config)
* include(git_version)

* dump_cmake_variables


* find_package(RMN [RMN_REQ_VERSION] COMPONENTS [SHARED|THREADED] [OPTIONAL|REQUIRED])
* find_package(VGRID [VGRID_REQ_VERSION] COMPONENTS [SHARED] [OPTIONAL|REQUIRED])
* find_package(ECCODES [ECCODES_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(ECBUFR [ECBUFR_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(FLT [FLT_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(URP [URP_REQ_VERSION] [OPTIONAL|REQUIRED])
* find_package(GDB [OPTIONAL|REQUIRED])
* find_package(R [OPTIONAL|REQUIRED])

## example usage

```cmake
...

#----- Append EC specific module path
foreach(PATH $ENV{EC_CMAKE_MODULE_PATH})
   list(APPEND CMAKE_MODULE_PATH ${PATH})
endforeach()

include(ec_init)           # Initialize compilers and ECCC specific functions
include(ec_parse_manifest) # Parse MANIFEST file
include(ec_build_info)     # Generate build include file

include(doxygen)           # Doxygen target

project("SomeProject" VERSION 0.0.0 DESCRIPTION "Does something")
option(BUILD_SHARED_LIBS "Build shared libraries instead of static ones." TRUE)

set(CMAKE_INSTALL_PREFIX "" CACHE PATH "..." FORCE)

#----- Enable language before sourcing the compiler presets
enable_language(C)
enable_language(Fortran)
enable_testing()

include(compiler_presets)

find_package(RMN ${RMN_REQ_VERSION} COMPONENTS SHARED OPTIONAL)
find_package(VGRID ${VGRID_REQ_VERSION} COMPONENTS SHARED OPTIONAL)
find_package(GDB)
find_package(ECCODES ${ECCODES_REQ_VERSION})
find_package(ECBUFR ${ECBUFR_REQ_VERSION})
find_package(FLT ${FLT_REQ_VERSION})
find_package(URP ${URP_REQ_VERSION})

...
```
