# This module builds the config file infortmation script bin/xxx-config
#    Needs the MANIFEST file to have been parsed earlier (ec_parse_manifest)

string(TOUPPER ${BUILD} UBUILD)

#----- Build config information script
install(CODE "execute_process(COMMAND sed 
   -e \"s/CMAKE_NAME/${NAME}/\" 
   -e \"s/CMAKE_VERSION/${VERSION}${STATE}/\" 
   -e \"s/CMAKE_BUILD/${BUILD}/\" 
   -e \"s/CMAKE_CC/\\\"${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}\\\"/\" 
   -e \"s/CMAKE_CFLAGS/\\\"${CMAKE_C_FLAGS}\\\"/\"  
   -e \"s/CMAKE_FTN/\\\"${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}\\\"/\" 
   -e \"s/CMAKE_FFLAGS/\\\"${CMAKE_Fortran_FLAGS}\\\"/\" 
   -e \"s/CMAKE_RMN/${RMN_VERSION}${RMN_STATE}/\" 
   -e \"s/CMAKE_VGRID/${VGRID_VERSION}${VGRID_STATE}/\"
   -e \"s/CMAKE_EER/${eerUtils_VERSION}${EER_STATE}/\" 
   -e \"s/CMAKE_GDAL/${GDAL_VERSION}/\" 
   -e \"s/CMAKE_NETCDF/${NETCDF_VERSION}/\" 
   -e \"s/CMAKE_HDF4/${HDF4_VERSION}/\" 
   -e \"s/CMAKE_HDF5/${HDF5_VERSION}/\"
   ../config.in OUTPUT_FILE ${NAME}-config)")
install(PROGRAMS ${CMAKE_BINARY_DIR}/${NAME}-config DESTINATION bin)


       # this list of properties can be extended as needed
#       set(CMAKE_PROPERTY_LIST SOURCE_DIR BINARY_DIR COMPILE_DEFINITIONS COMPILE_OPTIONS INCLUDE_DIRECTORIES LINK_LIBRARIES INTERFACE_LINK_LIBRARIES)
#       set(tgt georef)
   
#       foreach (prop ${CMAKE_PROPERTY_LIST})
#           get_property(propval TARGET ${tgt} PROPERTY ${prop} SET)
#           if (propval)
#               get_target_property(propval ${tgt} ${prop})
#               message (STATUS "${prop} = ${propval}")
#           endif()
#       endforeach(prop)
