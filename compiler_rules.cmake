
#----- Fortran Compiler Rules

if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
    set(CMAKE_Fortran_FLAGS         "${CMAKE_Fortran_FLAGS} -cpp")
    set(CMAKE_Fortran_FLAGS_DEBUG   "-g -traceback")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O3 -ip")
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
    set(CMAKE_Fortran_FLAGS         "${CMAKE_Fortran_FLAGS} -Wall -Wno-unused-dummy-argument -cpp")
    set(CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g3")
    set(CMAKE_Fortran_FLAGS_RELEASE "-Ofast -march=native")
endif()

#----- C Compiler Rules

if(CMAKE_C_COMPILER_ID MATCHES GNU)
    set(CMAKE_C_FLAGS         "${CMAKE_C_FLAGS}")
    set(CMAKE_C_FLAGS_DEBUG   "-O0 -g3 -Wall")
    set(CMAKE_C_FLAGS_RELEASE "-std=c99 -O2 -finline-functions -funroll-loops -fomit-frame-pointer")
endif()

if(CMAKE_C_COMPILER_ID MATCHES Intel)
    set(CMAKE_C_FLAGS         "${CMAKE_C_FLAGS}")
    set(CMAKE_C_FLAGS_DEBUG   "-O0 -g3 -Wall")
    set(CMAKE_C_FLAGS_RELEASE "-std=c99 -O2 -finline-functions -funroll-loops -fomit-frame-pointer")
endif()
