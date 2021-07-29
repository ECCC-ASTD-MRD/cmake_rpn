# Build ssm specific files.
# How to use:
#    - Copy the .ssm.d directory in your project's root directory
#    - Edit the .ssm.d/post-install.in file according to your needs
#    - Call the ec_prepare_ssm macro. 

macro(ec_prepare_ssm)
   set(EC_PLAT $ENV{ORDENV_PLAT})
   set(EC_USER $ENV{USER})

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
   install(FILES ${CMAKE_BINARY_DIR}/.ssm.d/post-install DESTINATION .ssm.d)
endmacro()

