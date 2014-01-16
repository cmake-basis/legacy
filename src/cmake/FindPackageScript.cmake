#
# Copyright (C) Carnegie Mellon University 2012-2013
#
#  Authors: Andrew Hundt ahundt@cmu.edu, Zach Pezzementi pez@nrec.ri.cmu.edu
#  


# -------------------------------------------------------------
function(basis_find_package_script_debug_output MODULE_NAME SEARCH_OUTPUT_VARIABLE PATH_HINTS SEARCH_FILE)
    set(meshfpdstr "")
    set(meshfpdstr "${meshfpdstr}------------------------------------------------------------\n")
    set(meshfpdstr "${meshfpdstr}basis_find_package_script(${MODULE_NAME}) DEBUG\n")
    set(meshfpdstr "${meshfpdstr}  Searching For:  ${SEARCH_OUTPUT_VARIABLE}\n") 
    set(meshfpdstr "${meshfpdstr}  Path Hints:     ${${PATH_HINTS}}\n")
    set(meshfpdstr "${meshfpdstr}  Search File(s): ${${SEARCH_FILE}}\n")
    set(meshfpdstr "${meshfpdstr}\n")
    set(meshfpdstr "${meshfpdstr}  Results:        ${${SEARCH_OUTPUT_VARIABLE}}\n") 
    set(meshfpdstr "${meshfpdstr}------------------------------------------------------------\n")
    
    message(STATUS ${meshfpdstr})
endfunction()

# -------------------------------------------------------------
#  basis_find_libraries
#
#  Required Arg:
#
#    [first param]                    Variable to fill out with the list of libraries found
#
#  One Value Args:
#
#    LIBRARY_DIRS_OUTPUT_VARIABLE     optional variable to set with a list of directories in which libraries are contained
#
#  Multi Value Args:
#
#    NAMES                            list of library names to find
#
#    HINTS                            list of path hints to look for the libraries
#
#
macro(basis_find_libraries LIBRARY_LIST_OUTPUT_VARIABLE )
  include(CMakeParseArguments)
  set(options )
  set(oneValueArgs LIBRARY_DIRS_OUTPUT_VARIABLE )
  set(multiValueArgs NAMES HINTS)
  cmake_parse_arguments(BASIS_FIND_LIBRARIES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(${LIBRARY_LIST_OUTPUT_VARIABLE} )
  foreach(LIB ${BASIS_FIND_LIBRARIES_NAMES})
    if (MSVC)
      # search for both release and debug libraries
      set (LIBd ${LIB}d)
      find_library(FOUND_${LIB} NAMES ${LIB} PATHS ${BASIS_FIND_LIBRARIES_HINTS})
      find_library(FOUND_${LIBd} NAMES ${LIBd} PATHS ${BASIS_FIND_LIBRARIES_HINTS})
      set (FOUND_${LIB} optimized ${FOUND_${LIB}} debug ${FOUND_${LIBd}})
    else (MSVC)
      find_library(FOUND_${LIB} NAMES ${LIB} PATHS ${BASIS_FIND_LIBRARIES_HINTS})
    endif (MSVC)
    # MESSAGE("LIB: ${LIB}, ${FOUND_${LIB}}")
    if(FOUND_${LIB})
      # build up list of libs
      list(APPEND ${LIBRARY_LIST_OUTPUT_VARIABLE} ${FOUND_${LIB}})
      mark_as_advanced( FOUND_${LIB} )
      if(LIBRARY_DIRS_OUTPUT_VARIABLE)
        # build up list of library dirs
        get_filename_component(PATH LIBRARY_LIST_LIB_DIR ${FOUND_${LIB}})
        list(APPEND ${BASIS_FIND_LIBRARIES_LIBRARY_DIRS_OUTPUT_VARIABLE} ${LIBRARY_LIST_LIB_DIR})
      endif()
    endif(FOUND_${LIB})
  endforeach(LIB ${LIBS})
  #message(STATUS "LIBS1: ${IPP_LIBRARIES}")
  set(${LIBRARY_LIST_OUTPUT_VARIABLE} ${${LIBRARY_LIST_OUTPUT_VARIABLE}} PARENT_SCOPE)
  if(LIBRARY_DIRS_OUTPUT_VARIABLE)
    list(REMOVE_DUPLICATES BASIS_FIND_LIBRARIES_LIBRARY_DIRS_OUTPUT_VARIABLE)
    SET(${BASIS_FIND_LIBRARIES_LIBRARY_DIRS_OUTPUT_VARIABLE} ${${BASIS_FIND_LIBRARIES_LIBRARY_DIRS_OUTPUT_VARIABLE}} PARENT_SCOPE)
  endif()
endmacro()



# -------------------------------------------------------------
#
# basis_find_package_script - Implement a Find Script
#
#
# basis_find_package_script makes it easy to implement a find script, simply specify a few parameters, 
# filenames and paths to headers, source files, and library files to implement a find script 
# that supports building packages as subdirectories, or just a regular library find script
#
# Designed to be used in conjunction with find_package_as_subdirectory in FindPackageAsSubdirectory.cmake
#
# Usage:
#   basis_find_package_script(<module name> [HEADER_ONLY_INSTALLATION] [DEBUG] [DEBUG_SUBPROJECT] [DEBUG_INCLUDE] [DEBUG_LIBRARY]
#     [MODULE_PRETTY_NAME "<name string>"]]
#     [SUBPROJECT_SEARCH_FILE <relative file path>]
#     [SUBPROJECT_PATH_HINTS path1 [path2 ...]] 
#     [INCLUDE_SEARCH_FILE <relative file path>]
#     [INCLUDE_SEARCH_FILES path1 [path2 ...]]
#     [INCLUDE_PATH_HINTS path1 [path2 ...]]  
#     [MODULE_LIBRARIES lib1 [lib2 ...]] 
#     [LIBRARY_PATH_HINTS path1 [path2 ...]]
#     [REQUIRED_PACKAGES package1 [package2 ...]] 
#   )
#
# Options:
#
#    HEADER_ONLY_INSTALLATION     Installed library consists entirely of header files, 
#                                 so do not search for any binaries.
#
# Debug Options:
#
#    Debug options are helpful when the find script is not working as expected.  
#
#    DEBUG                        Prints debug output indicating the paths that are being searched
#                                 and where/if components of the package are being found. This is 
#                                 the same as specifying DEBUG_SUBPROJECT DEBUG_INCLUDE and 
#                                 DEBUG_LIBRARY at the same time.
#
#    DEBUG_SUBPROJECT             Prints debug output specifically when detecting the source (as opposed to installed)
#                                 version of the library that is to be added as a subproject in a subdirectory.
#
#    DEBUG_INCLUDE                Prints debug output specifically when detecting the include path of the library.
#
#    DEBUG_LIBRARY                Prints debug output specifically when detecting the binary library files.
#
#
# Single Arg Params:
#
#    MODULE_PRETTY_NAME           A pretty name for the library that will be used in printouts 
#                                 and long descriptions such as those in ccmake. This is also the
#                                 string most useful when googling or emailing about the library.
#
#    SUBPROJECT_SEARCH_FILE       The relative path to a file that when present indicates that the full 
#                                 source of a cmake library that supports compilation as a subproject is present.
#                                 The root of this path is where the top level CMakeLists.txt file will be so that
#                                 add_subdirectory() of the absolute path to the root will cause the library to be
#                                 be built as a subproject.
#
#                                 Typically this file will be a .cpp file that is not present 
#                                 when the library is installed on a system without the source.
#
#                                 This will be strung together with the SUBPROJECT_PATH_HINTS to determine the
#                                 path to the top of the source directory.
#
#                                 Example:   src/png.cpp
#
#    INCLUDE_SEARCH_FILE          The relative path to a file that when present indicates the include directory.
#                                 The root of this path is where the top level CMakeLists.txt file will be so that
#                                 include_directories() of the absolute path to the root will cause the library to be
#                                 be built as a subproject.
#
#                                 Typically this file will be a .hpp file that is present when the library is 
#                                 installed on a system without the source. When possible this should also 
#                                 correspond to the the file in the source as well.
#                                 
#                                   Example: png.h
#                                            opencv/opencv.h
#
#                                 The path specified here will be the path required to include the file in user source code.

#                                   User Source Examples: #include "png.h"
#                                                         #include "opencv/opencv.h"
#                                                         #include "opencv2/core/core.hpp"
#
# Multi Arg Params:
#   
#    SUBPROJECT_PATH_HINTS        Paths to look in for the source code of a package. This is the directory that
#                                 will be passed as a parameter to add_subdirectory(). Note that the final path
#                                 must be a subdirectory of the top level CMakeLists.txt file.
#
#    INCLUDE_PATH_HINTS           Paths to look for the headers of a package. The final path will be used to set
#                                 ${MODULE_NAME}_INCLUDE_DIRS, such as PNG_INCLUDE_DIRS.
#
#    MODULE_LIBRARIES             The name of the libraries in this module. Does not include library extensions. For example
#                                 while there may be libpng.a libpng.dylib png.lib and png.dll depending on platform, only
#                                 png will need to be specified.
#
#    LIBRARY_PATH_HINTS           Paths to look in for the source code of a package. This is the directory component that will
#                                 be used to set ${MODULE_NAME}_LIBRARIES such as PNG_LIBRARIES.
#
#    REQUIRED_PACKAGES            Dependencies to check for. A warning will be printed if PACKAGENAME_FOUND is not set
#                                 Example: ZLIB 
#
#    INCLUDE_SEARCH_FILES         Same as INCLUDE_SEARCH_FILE, but allows multiple files to be specified in the case that one is not sufficient.
#
#
# Example:
#
#   basis_find_package_script(
#     PNG
#     MODULE_PRETTY_NAME     "png"
#     SUBPROJECT_SEARCH_FILE src/png.cpp
#     SUBPROJECT_PATH_HINTS  /path/to/source/libpng ${PNG_DIR}
#     INCLUDE_SEARCH_FILE    png.h
#     INCLUDE_PATH_HINTS     /usr/local/include /opt/local ${PNG_DIR}
#     MODULE_LIBRARIES       png
#     LIBRARY_PATH_HINTS     /usr/local/lib /opt/local/lib ${PNG_DIR}/lib
#     REQUIRED_PACKAGES      ZLIB
#   )
#
# Example Variable Result Values with software installed:
#
#   PNG_INCLUDE_DIRS: /usr/local/include
#
#                     This is the result of appending /usr/local/include to png.h 
#                     causing /usr/local/include/png.h to be found successfully.
#                     PNG_INCLUDE_DIRS is then set to /usr/local/include
#
#
#   PNG_LIBRARIES:    /usr/local/lib/libpng.a
#
#                     This is the result of searching in /usr/local/lib for the png library 
#                     causing /usr/local/lib/libpng.a to be found successfully.
#                     PNG_LIBRARIES is then set to /usr/local/lib
#
# Example Results with build from source:
#
#  PNG_SUBPROJECT_PATH: /path/to/png/CMakeLists.txt, this function will then call add_subdirectory(/path/to/png)
#
#                       The library itself is then expected to set PNG_INCLUDE_DIRS and PNG_LIBRARIES appropriately in the subdirectories.
#


function(basis_find_package_script MODULE_NAME)
  include(CMakeParseArguments)
  set(options HEADER_ONLY_INSTALLATION DEBUG DEBUG_SUBPROJECT DEBUG_INCLUDE DEBUG_LIBRARY)
  set(oneValueArgs SUBPROJECT_SEARCH_FILE MODULE_PRETTY_NAME INCLUDE_SEARCH_FILE)
  set(multiValueArgs SUBPROJECT_PATH_HINTS INCLUDE_PATH_HINTS MODULE_LIBRARIES LIBRARY_PATH_HINTS REQUIRED_PACKAGES INCLUDE_SEARCH_FILES)
  cmake_parse_arguments(BASIS_FPS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  if(NOT BASIS_FPS_MODULE_PRETTY_NAME)
    set(BASIS_FPS_MODULE_PRETTY_NAME ${MODULE_NAME})
  endif(NOT BASIS_FPS_MODULE_PRETTY_NAME)

  # find subproject if a search file is specified and a path is not yet specified
  if( NOT ${MODULE_NAME}_SUBPROJECT_PATH AND BASIS_FPS_SUBPROJECT_SEARCH_FILE )
    find_path( ${MODULE_NAME}_SUBPROJECT_PATH ${BASIS_FPS_SUBPROJECT_SEARCH_FILE} HINTS ${BASIS_FPS_SUBPROJECT_PATH_HINTS} )
  endif()

  # handle debug output
  if (BASIS_FPS_DEBUG OR BASIS_FPS_DEBUG_SUBPROJECT)
    basis_find_package_script_debug_output(${MODULE_NAME} ${MODULE_NAME}_SUBPROJECT_PATH BASIS_FPS_SUBPROJECT_PATH_HINTS BASIS_FPS_SUBPROJECT_SEARCH_FILE)
  endif(BASIS_FPS_DEBUG OR BASIS_FPS_DEBUG_SUBPROJECT)

  include(FindPackageHandleStandardArgs)
  
  ##################################################################
  # Find header include folders, set *_INCLUDE_DIRS variables
  ##################################################################
  
  # backwards compatibility with INCLUDE_SEARCH_FILE VARIABLE
  if(BASIS_FPS_INCLUDE_SEARCH_FILE)
    list(APPEND BASIS_FPS_INCLUDE_SEARCH_FILES ${BASIS_FPS_INCLUDE_SEARCH_FILE})
  endif()
  
  # find the location of each header file (multiple path results supported)
  # note: INT_VAR is a workaround to make each variable unique because find_path caches variables so that variable is never set again
  set(INT_VAR "1")
  foreach(INCLUDE_DIR ${BASIS_FPS_INCLUDE_SEARCH_FILES})
    find_path(${MODULE_NAME}_INCLUDE_DIR${INT_VAR} ${INCLUDE_DIR} HINTS ${BASIS_FPS_INCLUDE_PATH_HINTS})
    if(BASIS_FPS_DEBUG OR NOT ${MODULE_NAME}_INCLUDE_DIR${INT_VAR})
      basis_find_package_script_debug_output(${MODULE_NAME} ${MODULE_NAME}_INCLUDE_DIR${INT_VAR} BASIS_FPS_INCLUDE_PATH_HINTS INCLUDE_DIR)
      if(NOT ${MODULE_NAME}_INCLUDE_DIR${INT_VAR} AND BASIS_FPS_DEBUG)
        message(FATAL_ERROR "Unable to find header ${INCLUDE_DIR} in find script Find${MODULE_NAME}.cmake. You may be able to disable this component using ccmake, otherwise see the debug message above for the path components that caused this warning. Be sure to check for misspellings or missing path hints.")
      endif()
    endif()
    list(APPEND ${MODULE_NAME}_INCLUDE_DIRS ${${MODULE_NAME}_INCLUDE_DIR${INT_VAR}})
    MATH(EXPR INT_VAR "${INT_VAR}+1")
  endforeach()  
  list(REMOVE_DUPLICATES ${MODULE_NAME}_INCLUDE_DIRS)
  set(${MODULE_NAME}_INCLUDE_DIRS ${${MODULE_NAME}_INCLUDE_DIRS} CACHE STRING "Directories to include for project ${MODULE_NAME}" FORCE)
  mark_as_advanced(${MODULE_NAME}_INCLUDE_DIRS)

  # handle debug output
  if (BASIS_FPS_DEBUG OR BASIS_FPS_DEBUG_INCLUDE)
    basis_find_package_script_debug_output(${MODULE_NAME} ${MODULE_NAME}_INCLUDE_DIRS BASIS_FPS_INCLUDE_PATH_HINTS BASIS_FPS_INCLUDE_SEARCH_FILES)
  endif(BASIS_FPS_DEBUG OR BASIS_FPS_DEBUG_INCLUDE)
  
  ####################################################################
  # Find locations to call add_subdirectory, set *_LIBRARIES variables
  ####################################################################
  
  if( ${MODULE_NAME}_SUBPROJECT_PATH )
    # Module is being built as a subdirectory
    set(${MODULE_NAME}_PROJECT_IS_SUBDIRECTORY ON CACHE BOOL "${BASIS_FPS_MODULE_PRETTY_NAME} is built as a subdirectory of this project")
    if(BASIS_FPS_MODULE_LIBRARIES AND (NOT BASIS_FPS_HEADER_ONLY_INSTALLATION) )
      set(${MODULE_NAME}_LIBRARIES ${BASIS_FPS_MODULE_LIBRARIES} CACHE STRING "List of libraries from project ${MODULE_NAME}" FORCE)
      # uncomment to debug libraries variable
      # message(STATUS "BASIS_FPS_MODULE_LIBRARIES : ${BASIS_FPS_MODULE_LIBRARIES} ${MODULE_NAME}_LIBRARIES : ${${MODULE_NAME}_LIBRARIES}")
      if(${MODULE_NAME}_LIBRARIES)
            set(${MODULE_NAME}_LIBRARIES_OPTIONAL ${${MODULE_NAME}_LIBRARIES} PARENT_SCOPE)
            # set ${PROJECT_NAME}_LIBRARY_DIRS to the location(s) of the libs
            include(GetFilePaths)
            GetFilePaths( ${MODULE_NAME}_LIBRARY_DIRS ${MODULE_NAME}_LIBRARIES )
            set(${MODULE_NAME}_LIBRARY_DIRS ${${MODULE_NAME}_LIBRARY_DIRS} PARENT_SCOPE)
            mark_as_advanced(${MODULE_NAME}_LIBRARY_DIRS ${MODULE_NAME}_LIBRARIES_OPTIONAL)
      endif()
    endif()
    
    # We do not know what library targets it has at this point, so only check 
    # the include directory
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(${MODULE_NAME} REQUIRED_VARS ${MODULE_NAME}_INCLUDE_DIRS)
    mark_as_advanced(${MODULE_NAME}_LIBRARIES)
  else( ${MODULE_NAME}_SUBPROJECT_PATH )
    # Looking for installed version of module
    if((BASIS_FPS_MODULE_LIBRARIES) AND (NOT BASIS_FPS_HEADER_ONLY_INSTALLATION))
      basis_find_libraries(${MODULE_NAME}_LIBRARIES 
                            NAMES ${BASIS_FPS_MODULE_LIBRARIES} 
                            HINTS ${BASIS_FPS_LIBRARY_PATH_HINTS})
      #find_library(${MODULE_NAME}_LIBRARIES NAMES ${BASIS_FPS_MODULE_LIBRARIES} HINTS ${BASIS_FPS_LIBRARY_PATH_HINTS})
      
      
      if(${MODULE_NAME}_LIBRARIES)
            # An installed version (not a subdirectory version) of the library was found
            # set optional variables and library paths
            set(${MODULE_NAME}_LIBRARIES_OPTIONAL ${${MODULE_NAME}_LIBRARIES} PARENT_SCOPE)
            # set ${PROJECT_NAME}_LIBRARY_DIRS to the location(s) of the libs
            include(GetFilePaths)
            GetFilePaths( ${MODULE_NAME}_LIBRARY_DIRS ${MODULE_NAME}_LIBRARIES )
            set(${MODULE_NAME}_LIBRARY_DIRS ${${MODULE_NAME}_LIBRARY_DIRS} PARENT_SCOPE)
            mark_as_advanced(${MODULE_NAME}_LIBRARY_DIRS ${MODULE_NAME}_LIBRARIES_OPTIONAL)
      endif(${MODULE_NAME}_LIBRARIES)

      # handle debug output
      if (BASIS_FPS_DEBUG OR BASIS_FPS_DEBUG_LIBRARY)
        basis_find_package_script_debug_output(${MODULE_NAME} ${MODULE_NAME}_LIBRARIES BASIS_FPS_LIBRARY_PATH_HINTS BASIS_FPS_MODULE_LIBRARIES)
      endif(BASIS_FPS_DEBUG OR BASIS_FPS_DEBUG_LIBRARY)

      FIND_PACKAGE_HANDLE_STANDARD_ARGS(${MODULE_NAME} ${MODULE_NAME}_LIBRARIES ${MODULE_NAME}_INCLUDE_DIRS)
    else()
      # Header-only library, so only check for include dir
      if(NOT BASIS_FPS_HEADER_ONLY_INSTALLATION)
        set(${MODULE_NAME}_LIBRARIES "${MODULE_NAME}_header_only_library_detected" STRING "List of paths to libraries from project")
      endif(NOT BASIS_FPS_HEADER_ONLY_INSTALLATION)
      FIND_PACKAGE_HANDLE_STANDARD_ARGS(${MODULE_NAME} REQUIRED_VARS ${MODULE_NAME}_INCLUDE_DIRS)
    endif()
    mark_as_advanced(${MODULE_NAME}_LIBRARIES)
  endif( ${MODULE_NAME}_SUBPROJECT_PATH )

  string(TOUPPER ${MODULE_NAME} UPPER_CASE_${MODULE_NAME})
  set(${UPPER_CASE_${MODULE_NAME}}_FOUND ${${UPPER_CASE_${MODULE_NAME}}_FOUND} PARENT_SCOPE)

  # Could set the non-all-caps version of the _FOUND variable also, but may 
  # lead to working with bad assumptions about CMake behavior with other 
  # libraries.
  # Also not sure whether this variable is supposed to be cached.
  #set(${MODULE_NAME}_FOUND ${${UPPER_CASE_${MODULE_NAME}}_FOUND} CACHE BOOL "Whether ${BASIS_FPS_MODULE_PRETTY_NAME} was found")
 

  # Verify that required packages required by the current package are available if in a subproject build
  foreach(FIND_PACKAGE IN LISTS BASIS_FPS_REQUIRED_PACKAGES)
    string(TOUPPER ${FIND_PACKAGE} FIND_PACKAGE_UPPER)
    if(NOT ${FIND_PACKAGE_UPPER}_FOUND)
      message(STATUS -------------------------------------------------------------)
      message(STATUS "basis_find_package_script(${MODULE_NAME}) WARNING: Required package ${FIND_PACKAGE} NOT DETECTED")
      message(STATUS -------------------------------------------------------------)
    endif(NOT ${FIND_PACKAGE_UPPER}_FOUND)
  endforeach(FIND_PACKAGE IN LISTS BASIS_FPS_REQUIRED_PACKAGES)

endfunction(basis_find_package_script )


