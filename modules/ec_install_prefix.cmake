# This module defines an install prefix with the EC convention:
#   NAME_VERSION-COMPARCH-PLATFORM
# By default, it will define the CMAKE_INSTALL_PREFIX and use the PROJECT_NAME and PROJECT_VERSION variable
# Optional arguments 1 and 2 allow to specify the name and version to be used
# Optional argument 3 can be used to specify a return variable for the prefix instead of changing the CMAKE_INSTALL_PREFIX

function(ec_install_prefix)

   if (DEFINED ARGV0)
      set(name ${ARGV0})
   else()
     set(name ${PROJECT_NAME})
   endif()

   if (DEFINED ARGV1)
      set(version ${ARGV1})
   else()
      set(version ${PROJECT_VERSION})
   endif()

   if(DEFINED ENV{ORDENV_PLAT})
      set(prefix "${name}_${version}${EC_COMP}_$ENV{ORDENV_PLAT}")
   else()
      set(prefix "${name}_${version}")
   endif()

   if (DEFINED ARGV2)
      # If a variable is passed, return the prefix in it
      set(${ARGV2} ${prefix} PARENT_SCOPE)
   else()
      # Otherwise, define the CMAKE_INSTALL_PREFIX to it
      # In cascade calls, we don't want to override the prefix
      if (EC_INIT_DONE LESS 2)
         if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
            set(CMAKE_INSTALL_PREFIX "${prefix}" PARENT_SCOPE)
         else()
            set(prefix "${CMAKE_INSTALL_PREFIX}/${prefix}")
            set(CMAKE_INSTALL_PREFIX "${prefix}" PARENT_SCOPE)
         endif()
         message(STATUS "(EC) Defining install prefix for local install: ${prefix}") 
      endif()
   endif()

endfunction()