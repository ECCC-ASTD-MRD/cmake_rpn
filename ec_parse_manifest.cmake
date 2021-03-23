#----- Parse a MANIFEST file
macro(ec_parse_manifest)
   file(STRINGS MANIFEST dependencies)
   foreach(line ${dependencies})
      string(REGEX MATCH "[#]|([A-Z,a-z,_]+)[ ]*([<,>,=,~,:]+)[ ]*(.*)" res ${line})
#      message("..${CMAKE_MATCH_1}..${CMAKE_MATCH_2}..${CMAKE_MATCH_3}..")
      set(LBL1 ${CMAKE_MATCH_1})
      set(LBL2 ${CMAKE_MATCH_2})
      set(LBL3 ${CMAKE_MATCH_3})

      #----- Skip comment lines
      if("${res}" STREQUAL "" OR "${res}" MATCHES "#")
         continue()
      endif()

      string(TOUPPER ${LBL1} LBL1)
      if (${LBL2} MATCHES ":")
         set(${LBL1} ${LBL3}) 
      else()
         set(${LBL1}_REQ_VERSION_CHECK ${LBL2})

         #----- Parse dependencies
         string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)" null ${LBL3})
         set(${LBL1}_REQ_VERSION_MAJOR ${CMAKE_MATCH_1})
         set(${LBL1}_REQ_VERSION_MINOR ${CMAKE_MATCH_2})
         set(${LBL1}_REQ_VERSION_PATCH ${CMAKE_MATCH_3})
         set(${LBL1}_REQ_VERSION ${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3})
#         message("${LBL1} ${CMAKE_MATCH_1}..${CMAKE_MATCH_2}..${CMAKE_MATCH_3}")
      endif()
  endforeach()

   #----- Extract version and state
   string(REGEX MATCH "([0-9]+)\\.([0-9]+)\\.([0-9]+)(.*)" null ${VERSION})
   set(VERSION "${CMAKE_MATCH_1}.${CMAKE_MATCH_2}.${CMAKE_MATCH_3}")
   set(STATE "${CMAKE_MATCH_4}")

  set(CMAKE_BUILD_TYPE ${BUILD})
  message(STATUS "Generating ${NAME} package")
endmacro()

function(ec_check_version DEPENDENCY)
   message("${${DEPENDENCY}_REQ_VERSION} ${${DEPENDENCY}_REQ_VERSION_CHECK} ${${DEPENDENCY}_VERSION}")

   set(STATUS YES)

   if (${$DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "=")
      if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_EQUAL ${$DEPENDENCY}_VERSION})
         set(STATUS NO)
         message(SEND_ERROR "Found version is different")
      endif()
   elseif (${$DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "<=")
      if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_LESS_EQUAL ${$DEPENDENCY}_VERSION})
         set(STATUS NO)
         message(SEND_ERROR "Found version greather than ${$DEPENDENCY}_VERSION}")
      endif()
   elseif (${${DEPENDENCY}_REQ_VERSION_CHECK} MATCHES ">=")
      set(STATUS NO)
      if (NOT ${${DEPENDENCY}_REQ_VERSION} VERSION_GREATER_EQUAL ${$DEPENDENCY}_VERSION})
         message(SEND_ERROR "Found version is less than ${$DEPENDENCY}_VERSION}")
      endif()
   endif()

   if (NOT ${STATUS})
      if (NOT ${${DEPENDENCY}_REQ_VERSION_CHECK} MATCHES "~")
         message(FATAL_ERROR "package is required")
      endif()
   endif()
endfunction()
