# Copyright 2021, Her Majesty the Queen in right of Canada

# Add a target to generate API documentation with Doxygen

# Define doc target only once (in case of projects cascades)
if (EC_INIT_DONE LESS 2)
    find_package(Doxygen COMPONENTS dot)

    if (Doxygen_FOUND)
        if(NOT PROJECT_SOURCE_DIR)
            message(FATAL_ERROR "(EC) PROJECT_SOURCE_DIR not defined!  This module must be called AFTER the project command!")
        endif()

        set(doxyfile_in ${CMAKE_CURRENT_LIST_DIR}/Doxyfile.in)
        set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

        if (NOT DOC_CALL_GRAPH)
            set(DOC_CALL_GRAPH "NO")
        endif()
        if (NOT DOC_CALLER_GRAPH)
            set(DOC_CALLER_GRAPH "NO")
        endif()
        if (NOT DOC_EXTRACT_ALL)
            set(DOC_EXTRACT_ALL "NO")
        endif()
        if (NOT DOC_INCLUDE_GRAPH)
            set(DOC_INCLUDE_GRAPH "NO")
        endif()
        if (NOT DOC_INCLUDED_BY_GRAPH)
            set(DOC_INCLUDED_BY_GRAPH "NO")
        endif()

        configure_file(${doxyfile_in} ${doxyfile} @ONLY)

        add_custom_target(
            doc
            COMMAND ${DOXYGEN_EXECUTABLE} ${doxyfile}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "(EC) Generating API documentation with Doxygen"
            VERBATIM
        )

        install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doc/html DESTINATION share/doc/${PROJECT_NAME} OPTIONAL)
    endif()
endif()