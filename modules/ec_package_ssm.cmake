# Build ssm specific files.
# How to use:
#    - Copy the .ssm.d directory in your project's root directory
#    - Edit the .ssm.d/post-install.in file according to your needs
#    - Call the ec_prepare_ssm macro.
#    - Pass wich directory needs dummy files if needed (ie: bin lib include) 
#set(EC_SSM 11)
if (EC_SSM LESS_EQUAL "11")
   set (EC_SSM_ARCH ${EC_ARCH})
endif()

function(ec_package_name)

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
      set(package "${name}_${version}${EC_COMP}_$ENV{ORDENV_PLAT}")
#      set(package "${name}${EC_COMP}_${version}_$ENV{ORDENV_PLAT}")
   else()
      set(package "${name}_${version}")
   endif()

   if (DEFINED ARGV2)
      # If a variable is passed, return the prefix in it
      set(${ARGV2} ${package} PARENT_SCOPE)
   else()
      if (EC_INIT_DONE LESS 2)
         # In cascade calls, we don't want to override the package name
         set(PACKAGE_NAME "${package}" PARENT_SCOPE)
      endif()
   endif()

endfunction()

macro(ec_prepare_ssm)

   string(TIMESTAMP BUILD_TIMESTAMP UTC)
   cmake_host_system_information(RESULT OS_HOSTNAME QUERY HOSTNAME)
   cmake_host_system_information(RESULT OS_FQDN QUERY FQDN)
   cmake_host_system_information(RESULT OS_NAME QUERY OS_NAME)
   cmake_host_system_information(RESULT OS_RELEASE QUERY OS_RELEASE)
   cmake_host_system_information(RESULT OS_VERSION QUERY OS_VERSION)
   cmake_host_system_information(RESULT OS_PLATFORM QUERY OS_PLATFORM)

   # Replace ssm info variables in control file
   configure_file(.ssm.d/control.json.in ${CMAKE_BINARY_DIR}/.ssm.d/control.json @ONLY)
   install(FILES ${CMAKE_BINARY_DIR}/.ssm.d/control.json DESTINATION .ssm.d)

   # Replace ssm variables in post-install file
   configure_file(.ssm.d/post-install.in ${CMAKE_BINARY_DIR}/.ssm.d/post-install @ONLY)
   install(PROGRAMS ${CMAKE_BINARY_DIR}/.ssm.d/post-install DESTINATION .ssm.d)
   
   # Install dummy compiler pointer
   if((EC_SSM LESS_EQUAL "11") AND (DEFINED ENV{COMP_ARCH}))
      foreach(dummy ${ARGN})
         execute_process(COMMAND mkdir -p ${CMAKE_BINARY_DIR}/${dummy}) 
         execute_process(COMMAND touch "${CMAKE_BINARY_DIR}/${dummy}/dummy_$ENV{COMP_ARCH}")
         install(FILES ${CMAKE_BINARY_DIR}/${dummy}/dummy_$ENV{COMP_ARCH} DESTINATION ${dummy})
      endforeach()
   endif()
 endmacro()

