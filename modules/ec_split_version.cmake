# Split VERSION string into VERSION and STATE parts
# VERSION will be of the form : <major>[.<minor>[.<patch>[.<tweak>]]]]
# STATE is anything that comes after
#
# WARNING : This macro uses CMake's regex engine and will therefore change CMAKE_MATCH_* variables!

include_guard(GLOBAL)

macro(ec_split_version)
    string(REGEX MATCH "^([0-9]+)?(\\.[0-9]+)?(\\.[0-9]+)?(\\.[0-9]+)?(.*)" JUNK ${VERSION})
    unset(JUNK)
    set(VERSION "${CMAKE_MATCH_1}${CMAKE_MATCH_2}${CMAKE_MATCH_3}${CMAKE_MATCH_4}")
    set(STATE "${CMAKE_MATCH_5}")
    if(VERSION STREQUAL "")
        set(VERSION "0.0.0")
    endif()
endmacro()