# Copyright 2021, Her Majesty the Queen in right of Canada

# This module builds the pkgIndec.tcl file information and installs it
#    Needs the MANIFEST file to have been parsed earlier (rpn_parse_manifest)

macro(ec_build_tcl_pkgindex)
   #----- Build config information script
   install(CODE "execute_process(COMMAND sed 
      -e \"s/@PACKAGE_NAME@/${NAME}/g\" 
      -e \"s/@PACKAGE_VERSION@/${VERSION}/g\" 
      -e \"s/@PKG_LIB_FILE@/lib${NAME}.so.${VERSION}/g\" 
      ${CMAKE_CURRENT_SOURCE_DIR}/pkgIndex.tcl.in OUTPUT_FILE ${CMAKE_BINARY_DIR}/pkgIndex.tcl)")
   install(FILES ${CMAKE_BINARY_DIR}/pkgIndex.tcl DESTINATION TCL/lib/${NAME}${VERSION})
endmacro()
