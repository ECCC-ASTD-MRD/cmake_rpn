# Copyright 2021, Her Majesty the Queen in right of Canada

# Add a target to generate API documentation with Doxygen

# Define doc target only once (in case of projects cascades)
if(EC_INIT_DONE LESS 2)
    option(WITH_DOC "Create and install the HTML based API documentation (requires Doxygen and Graphviz)" OFF)
    if(WITH_DOC)
        find_package(Doxygen COMPONENTS dot)

        if(Doxygen_FOUND)
            if(NOT PROJECT_SOURCE_DIR)
                message(FATAL_ERROR "(EC) PROJECT_SOURCE_DIR not defined!  This module must be called AFTER the project command!")
            endif()

            option(DOC_CALL_GRAPH "Generate a call dependency graph for every global function or class method" OFF)
            option(DOC_CALLER_GRAPH "Generate a caller dependency graph for every global function or class method" OFF)
            option(DOC_EXTRACT_ALL "Generate documentation for undocumented entities" OFF)
            option(DOC_INCLUDE_GRAPH "Generate a graph for each documented file showing the direct and indirect include dependencies of the file with other documented files" OFF)
            option(DOC_INCLUDED_BY_GRAPH "Generate a graph for each documented file showing the direct and indirect include dependencies of the file with other documented files" OFF)
            option(DOC_EXTRACT_STATIC "Include static members in documentation" ON)

            # Doxygen expects boolean to be "YES" or "NO" whereas CMake's boolean values are "ON" and "OFF"
            # We therefore need to convert them here

            if(DOC_CALL_GRAPH)
                set(DOC_CALL_GRAPH "YES")
            else()
                set(DOC_CALL_GRAPH "NO")
            endif()
            if(DOC_CALLER_GRAPH)
                set(DOC_CALLER_GRAPH "YES")
            else()
                set(DOC_CALLER_GRAPH "NO")
            endif()
            if(DOC_EXTRACT_ALL)
                set(DOC_EXTRACT_ALL "YES")
            else()
                set(DOC_EXTRACT_ALL "NO")
            endif()
            if(DOC_INCLUDE_GRAPH)
                set(DOC_INCLUDE_GRAPH "YES")
            else()
                set(DOC_INCLUDE_GRAPH "NO")
            endif()
            if(DOC_INCLUDED_BY_GRAPH)
                set(DOC_INCLUDED_BY_GRAPH "YES")
            else()
                set(DOC_INCLUDED_BY_GRAPH "NO")
            endif()
            if(DOC_EXTRACT_STATIC)
                set(DOC_EXTRACT_STATIC "YES")
            else()
                set(DOC_EXTRACT_STATIC "NO")
            endif()

            set(doxyfile_in ${CMAKE_CURRENT_LIST_DIR}/Doxyfile.in)
            set(doxyfile ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
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
endif()