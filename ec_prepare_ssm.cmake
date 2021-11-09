# Build ssm specific files.
# How to use:
#    - Copy the .ssm.d directory in your project's root directory
#    - Edit the .ssm.d/post-install.in file according to your needs
#    - Call the ec_prepare_ssm macro.
#    - Pass wich directory needs dummy files if needed (ie: lib include) 

macro(ec_prepare_ssm)
   set(EC_PLAT $ENV{ORDENV_PLAT})
   set(EC_USER $ENV{USER})
   set(EC_COMP "")
   if(DEFINED ENV{COMP_ARCH})
      set(EC_COMP "-$ENV{COMP_ARCH}")
   endif()

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
   if(DEFINED ENV{COMP_ARCH})
     foreach(dummy ${ARGN})
       execute_process(COMMAND mkdir -p ${CMAKE_BINARY_DIR}/${dummy}) 
       execute_process(COMMAND touch "${CMAKE_BINARY_DIR}/${dummy}/dummy_$ENV{COMP_ARCH}")
       install(FILES ${CMAKE_BINARY_DIR}/${dummy}/dummy_$ENV{COMP_ARCH} DESTINATION ${dummy})
     endforeach()
   endif()
 endmacro()

