# Copyright 2021, Her Majesty the Queen in right of Canada

# Link installer
macro(ec_install_symlink filepath sympath)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${sympath})")
    install(CODE "message(\"(EC) Creating symlink: ${sympath} -> ${filepath}\")")
endmacro(ec_install_symlink)
