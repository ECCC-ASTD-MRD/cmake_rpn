# This module defines the install prefix withe the EC convention:
#   CMAKE_INSTALL_PREFIX = NAME_VERSION-COMPARCH-PLATFORM
#
function(ec_install_prefix)
   # In cascade calls, we don't want to override theprefix
   if (EC_INIT_DONE LESS 2)
      # Don't override user specified prefix either
      if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
         if(DEFINED ENV{ORDENV_PLAT})
            if(DEFINED ENV{COMP_ARCH})
               set(EC_COMP "-$ENV{COMP_ARCH}")
            endif()
            set(CMAKE_INSTALL_PREFIX "${NAME}_${PROJECT_VERSION}${EC_COMP}_$ENV{ORDENV_PLAT}" CACHE PATH "..." FORCE)
            message(STATUS "(EC) Defining install prefix for local install: ${CMAKE_INSTALL_PREFIX}") 
          endif()
      endif()
   endif()
endfunction()