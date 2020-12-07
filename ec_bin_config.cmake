# This module builds the config file infortmation script bin/xxx-config
#    Needs the MANIFEST file to have been parsed earlier (ec_parse_manifest)

string(TOUPPER ${BUILD} UBUILD)

#----- Build config information script
install(CODE "execute_process(COMMAND sed 
   -e \"s/CMAKE_NAME/${NAME}/\" 
   -e \"s/CMAKE_VERSION/${VERSION}${STATE}/\" 
   -e \"s/CMAKE_BUILD/${BUILD}/\" 
   -e \"s/CMAKE_CC/\\\"${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}\\\"/\" 
   -e \"s/CMAKE_CFLAGS/\\\"${CMAKE_C_FLAGS_${UBUILD}}\\\"/\"  
   -e \"s/CMAKE_FTN/\\\"${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}\\\"/\" 
   -e \"s/CMAKE_RMN/${RMN_VERSION}${RMN_STATE}/\" 
   -e \"s/CMAKE_VGRID/${VGRID_VERSION}${VGRID_STATE}/\"
   -e \"s/CMAKE_EER/${EER_VERSION}${EER_STATE}/\" 
   -e \"s/CMAKE_GDAL/${GDAL_VERSION}/\" 
   -e \"s/CMAKE_NETCDF/${NETCDF_VERSION}/\" 
   -e \"s/CMAKE_HDF4/${HDF4_VERSION}/\" 
   -e \"s/CMAKE_HDF5/${HDF5_VERSION}/\"
   ../config OUTPUT_FILE ${NAME}-config)")
install(PROGRAMS ${CMAKE_BINARY_DIR}/${NAME}-config DESTINATION bin)
