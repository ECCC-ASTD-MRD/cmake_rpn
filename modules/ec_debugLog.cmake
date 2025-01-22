# A collection of functions to assist with logging for debug purposes

include_guard(GLOBAL)


# Print a debug message
# Params:
#   1 : Function/File name
#   2 : Message
macro(debugLog)
    message(DEBUG "(EC) ${ARGV0} - ${ARGV1}")
endmacro()


# Print the value of a variable
# Params:
#   1 : Function/File name
#   2 : Variable name
macro(debugLogVar)
    debugLog(${ARGV0} "${ARGV1}=${${ARGV1}}")
endmacro()