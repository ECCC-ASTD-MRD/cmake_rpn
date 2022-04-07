# Copyright 2021, Her Majesty the Queen in right of Canada

# Add a target to generate API documentation with Doxygen

option(WITH_DOC "Create and install the HTML based API documentation (requires Doxygen and Graphviz)" OFF)
if(WITH_DOC)
    find_package(Doxygen REQUIRED dot)

    if(NOT PROJECT_SOURCE_DIR)
        message(FATAL_ERROR "(EC) PROJECT_SOURCE_DIR not defined!  This module must be called AFTER the project command!")
    endif()

    set(doxyfile_in ${CMAKE_CURRENT_LIST_DIR}/Doxyfile.in)
    set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    configure_file(${doxyfile_in} ${doxyfile} @ONLY)

    add_custom_target(
        doc
        ALL
        COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM
    )

    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doc/html DESTINATION share/doc/${PROJECT_NAME})
endif()
