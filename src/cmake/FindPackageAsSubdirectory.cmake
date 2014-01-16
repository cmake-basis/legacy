#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

macro(list_found_libraries PROJECT_NAME)
  string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
  # Print out the libraries that are part of this package
  if(${PROJECT_NAME_UPPER}_FOUND)
    message(STATUS "${PROJECT_NAME} Libraries: ${${PROJECT_NAME}_LIBRARIES}")
  endif(${PROJECT_NAME_UPPER}_FOUND)
endmacro(list_found_libraries PROJECT_NAME)


# Called in the same way as the standard find scripts. 
# However, it also supports directories that are in the 
# correct location to be used directly as subdirectories.
#
# @bug   Make sure it correctly catches and reports an error when the name of the header is correct
#        the cpp file to find is wrong and there is also no lib present. For example a full source 
#        directory for a library where the specified cpp was deleted due to chages/updates
#
#  @todo properly deal with setting libraries variable so it is not cleared out and can be configured below, make sure there can't be duplicate libraries. This invlolves mesh_find_package and mesh_find_if_enabled as well.
#
#  OPTIONS:
#
#  DEBUG                             print debug output to help diagnose when packages aren't found
#
#  NO_INCLUDE_DIRECTORIES            Do not call include_directories, it will be called manually when necessary
#
#  OUTPUT VARIABLES:
#
#  CMAKE_MESH_ALL_SUBDIRECTORY_PACKAGE_DIRS - find_package_as_subdirectory appends path to all packages found as subdirectories to this variable
#
# Designed to be used in conjunction with mesh_find_package in MeshFindPackage.cmake
#
macro(find_package_as_subdirectory PROJECT_NAME )

  set(options INCLUDE_PACKAGE_DIR ONLY_ADD_INCLUDE_DIRS PRINT_CONFIGURATION)
  set(oneValueArgs DEBUG NO_INCLUDE_DIRECTORIES) # currently none
  set(multiValueArgs ) # currently none
  cmake_parse_arguments(FIND_PACKAGE_AS_SUBDIRECTORY "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  # only find if it is not already found
  string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)
  
  if(NOT ${PROJECT_NAME_UPPER}_FOUND AND EXTERNAL_PROJECT_ADD_${PACKAGE_NAME})
       # build the project using external_project_add
       include(External_${EXTERNAL_PACKAGE_NAME})
       # TODO: Consider moving include_directories and add_subdirectory to each module's CMakeLists.txt
       include_directories(${${EXTERNAL_PACKAGE_NAME}_INCLUDE_DIRS})
  elseif(NOT ${PROJECT_NAME_UPPER}_FOUND)
    
    # call find_package normally, adding in the remaining unparsed arguments for find script configuration
    find_package(${PROJECT_NAME} ${FIND_PACKAGE_AS_SUBDIRECTORY_UNPARSED_ARGUMENTS})
    
    if(${PROJECT_NAME}_PROJECT_IS_SUBDIRECTORY)  
      
      if(FIND_PACKAGE_AS_SUBDIRECTORY_PRINT_CONFIGURATION)
        message(STATUS "Adding subdirectory: ${${PROJECT_NAME}_SUBPROJECT_PATH}")
      endif(FIND_PACKAGE_AS_SUBDIRECTORY_PRINT_CONFIGURATION)
      
      if(${PROJECT_NAME}_LIBRARIES)
        # clear libraries variable because we will build it up on the fly
        set(FIND_PACKAGE_AS_SUBDIRECTORY_CURRENT_PROJECT_LIBRARIES ${${PROJECT_NAME}_LIBRARIES})
        list(REMOVE_DUPLICATES FIND_PACKAGE_AS_SUBDIRECTORY_CURRENT_PROJECT_LIBRARIES)
      endif()
      set(${PROJECT_NAME}_LIBRARIES ${FIND_PACKAGE_AS_SUBDIRECTORY_CURRENT_PROJECT_LIBRARIES} CACHE STRING "List of libraries from project ${PROJECT_NAME}" FORCE)
      
      # Include directories necessary to build the project as a subdirectory
      # TODO: Consider moving include_directories and add_subdirectory to each module's CMakeLists.txt
      if(NOT FIND_PACKAGE_AS_SUBDIRECTORY_NO_INCLUDE_DIRECTORIES)
        include_directories(${${PROJECT_NAME}_INCLUDE_DIRS})
      endif(NOT FIND_PACKAGE_AS_SUBDIRECTORY_NO_INCLUDE_DIRECTORIES)
      
      if(FIND_PACKAGE_AS_SUBDIRECTORY_ONLY_ADD_INCLUDE_DIRS)
        # the include only search failed, so print an error
        if(${PROJECT_NAME_UPPER}_FOUND)
           set(${PROJECT_NAME_UPPER}_FOUND_INCLUDE_DIRS TRUE)
        else()
          message(STATUS "${PROJECT_NAME} NOT Found")
        endif()
        # Set FOUND variable off to incidate we only actually found includes, so this code will run again if the package is searched for later
        # TODO: better way to do this?
        set(${PROJECT_NAME_UPPER}_FOUND FALSE)
        
        if(FIND_PACKAGE_AS_SUBDIRECTORY_DEBUG)
          message(STATUS "ONLY_ADD_INCLUDE_DIR ${PROJECT_NAME_UPPER}_FOUND:${${PROJECT_NAME_UPPER}_FOUND} ${PROJECT_NAME_UPPER}_FOUND_INCLUDE_DIRS:${${PROJECT_NAME_UPPER}_FOUND_INCLUDE_DIRS}")
        endif()
      else(FIND_PACKAGE_AS_SUBDIRECTORY_ONLY_ADD_INCLUDE_DIRS)
        list(APPEND CMAKE_MESH_ALL_SUBDIRECTORY_PACKAGE_DIRS ${${PROJECT_NAME}_SUBPROJECT_PATH})
        set(${PROJECT_NAME}_DIR ${${PROJECT_NAME}_SUBPROJECT_PATH})
        add_subdirectory(${${PROJECT_NAME}_SUBPROJECT_PATH})
      endif(FIND_PACKAGE_AS_SUBDIRECTORY_ONLY_ADD_INCLUDE_DIRS)

    endif(${PROJECT_NAME}_PROJECT_IS_SUBDIRECTORY)
    
    if(${PROJECT_NAME}_LIBRARIES AND FIND_PACKAGE_AS_SUBDIRECTORY_PRINT_CONFIGURATION)
      list_found_libraries(${PROJECT_NAME})
    endif(${PROJECT_NAME}_LIBRARIES AND FIND_PACKAGE_AS_SUBDIRECTORY_PRINT_CONFIGURATION)
  endif()
  
  if(NOT ${PROJECT_NAME_UPPER}_FOUND AND NOT FIND_PACKAGE_AS_SUBDIRECTORY_ONLY_ADD_INCLUDE_DIRS)
    message(STATUS "${PROJECT_NAME} NOT Found")
  endif()
  
endmacro(find_package_as_subdirectory)

