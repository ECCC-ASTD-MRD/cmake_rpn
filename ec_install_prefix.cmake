# This module defines the install prefix withe the EC convention:
#   CMAKE_INSTALL_PREFIX = NAME_VERSION-COMPARCH-PLATFORM
#
function(ec_install_prefix)
   # Default install path within EC
   if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
      if(DEFINED ENV{ORDENV_PLAT})
         if(DEFINED ENV{COMP_ARCH})
            set(EC_COMP "-$ENV{COMP_ARCH}")
         endif()
         message(STATUS "(EC) Defining install prefix for local install") 
         set(CMAKE_INSTALL_PREFIX "${NAME}_${PROJECT_VERSION}${EC_COMP}_$ENV{ORDENV_PLAT}" CACHE PATH "..." FORCE)
      endif()
   endif()
endfunction()