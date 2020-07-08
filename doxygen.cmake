# Add a target to generate API documentation with Doxygen
# Taken from https://p5r.uk/blog/2014/cmake-doxygen.html and slightly modified

option(BUILD_DOCUMENTATION "Create and install the HTML based API documentation (requires Doxygen and Graphviz)" ON)
if(BUILD_DOCUMENTATION)
    find_package(Doxygen REQUIRED dot)

    if(NOT PROJECT_SOURCE_DIR)
        message(FATAL_ERROR "PROJECT_SOURCE_DIR not defined!  This module must be called AFTER the project command!")
    endif()

    set(doxyfile_in ${CMAKE_CURRENT_LIST_DIR}/Doxyfile.in)
    set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    configure_file(${doxyfile_in} ${doxyfile} @ONLY)

    add_custom_target(doc
        COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Generating API documentation with Doxygen"
        VERBATIM)

    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/html DESTINATION share/doc)
endif()
