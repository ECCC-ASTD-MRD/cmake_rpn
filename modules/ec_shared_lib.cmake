# Copyright 2021, Her Majesty the Queen in right of Canada

macro(ec_target_link_library_if _target _condvar)
   set(_libs ${ARGN})
   list(LENGTH _libs _nlibs)
   if(_nlibs GREATER 0 AND ${_condvar})
      target_link_libraries(${_target} ${_libs})
   endif()
endmacro()

function(ec_path_starts_with _path _prefix _res)
   get_filename_component(prefix "${_prefix}" REALPATH)
   get_filename_component(path "${_path}" REALPATH)

   string(LENGTH "${prefix}" lenprefix)
   string(LENGTH "${path}" lenpath)

   if(lenprefix LESS_EQUAL lenpath)
      string(SUBSTRING "${path}" 0 ${lenprefix} path)
      if(prefix STREQUAL path)
         set(${_res} TRUE PARENT_SCOPE)
         return()
      endif()
   endif()
   set(${_res} FALSE PARENT_SCOPE)
endfunction()

#----- Custom property to help managing local rpath stuff
define_property(TARGET PROPERTY EC_LIB_INSTALL_PATH BRIEF_DOCS "..." FULL_DOCS "...")

function(ec_get_target_shared_lib_dirs _target _res)
   set(dirs "")
   get_target_property(ttype ${_target} TYPE)

   #----- We have a shared lib, try to get the lib dir path
   if(ttype STREQUAL SHARED_LIBRARY OR ttype STREQUAL UNKNOWN_LIBRARY)
      foreach(prop IN ITEMS EC_LIB_INSTALL_PATH IMPORTED_LOCATION)
         get_property(p TARGET ${_target} PROPERTY ${prop})
         if(p)
            if(IS_ABSOLUTE "${p}" AND NOT IS_DIRECTORY "${p}")
               get_filename_component(p "${p}" DIRECTORY)
            endif()
            list(APPEND dirs "${p}")
            break()
         endif()
      endforeach()
   endif()

   #----- Process linked libraries
   get_target_property(targets ${_target} INTERFACE_LINK_LIBRARIES)
   if(targets)
      foreach(dir IN LISTS targets)
         if(TARGET ${dir})
            ec_get_target_shared_lib_dirs(${dir} xtra)
            list(APPEND dirs ${xtra})
         elseif(EXISTS dir)
            list(APPEND dirs ${dir})
         endif()
      endforeach()
   endif()

   list(REMOVE_DUPLICATES dirs)
   set(${_res} "${dirs}" PARENT_SCOPE)
endfunction()

function(ec_target_rpath_from_libs _target)
   #----- Get the canonicalized version of the prefix
   get_filename_component(iprefix "${CMAKE_INSTALL_PREFIX}" REALPATH)

   #----- Get the local path if there is one
   get_property(tpath TARGET ${_target} PROPERTY EC_LIB_INSTALL_PATH)
   if(tpath)
      if(IS_ABSOLUTE "${tpath}")
         get_filename_component(tpath "${tpath}" REALPATH)
         ec_path_starts_with("${tpath}" "${iprefix}" tlocal)
      else()
         set(tpath "${iprefix}/${tpath}")
         set(tlocal TRUE)
      endif()
   else()
      message(WARNING "(EC) Using rpn_target_rpath_from_libs without setting the EC_LIB_INSTALL_PATH property on the target can lead to surprises")
      set(tlocal FALSE)
   endif()

   #----- Get the shared lib directories to which the target links
   ec_get_target_shared_lib_dirs(${_target} dirs)

   set(rpath "")
   foreach(dir IN LISTS dirs)
      if(NOT IS_ABSOLUTE "${dir}")
         set(dir "${iprefix}/${dir}")
      endif()

      if("${dir}" STREQUAL "${tpath}")
         continue()
      endif()

      if(tlocal)
         #----- Check if we can use a ${ORIGIN} reference
         ec_path_starts_with("${dir}" "${iprefix}" llocal)
         if(llocal)
            get_filename_component(dir "${dir}" REALPATH)
            file(RELATIVE_PATH dir "${tpath}" "${dir}")
            list(APPEND rpath "\${ORIGIN}/${dir}")
            continue()
         endif()
      endif()

      #----- Check if we are in a system directory (no need for rpath to point there)
      set(issys FALSE)
      foreach(sp IN LISTS CMAKE_SYSTEM_PREFIX_PATH)
         ec_path_starts_with("${dir}" "${sp}/lib/" issys)
         if(issys)
            break()
         endif()
      endforeach()
      if(issys)
         continue()
      endif()

      #----- We can't make an ORIGIN reference nor are we in a system path, add the dir to rpath
      list(APPEND rpath "${dir}")
   endforeach()

   list(REMOVE_DUPLICATES rpath)
   message(STATUS "(EC) Adding rpath [${rpath}] to target ${_target}")
   set_property(TARGET ${_target} APPEND PROPERTY INSTALL_RPATH ${rpath})
endfunction()
