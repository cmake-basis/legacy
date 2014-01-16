#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

include(CMakeParseArguments)

macro(mesh_setup_doxygen)

	# -------------- Doxygen -------------------
	#-- Add an Option to toggle the generation of the API documentation
	#TODO: Handle the multiple \mainpage doxygen comments properly
	#option(BUILD_DOCUMENTATION "Use Doxygen to create the HTML based API documentation" OFF)
	#if(BUILD_DOCUMENTATION)
	  
    # find the location of cmakeMesh UseDoxygen folder to add to CMAKE_MODULE_PATH
	  find_path(CMAKE_MESH_USE_DOXYGEN_PATH 
	    NAMES 
	      UseDoxygen.cmake
	    HINTS 
	      ${CMAKE_MESH_PATH}
  	    ${CMAKE_SOURCE_DIR} 
  	    ${PROJECT_SOURCE_DIR}
        PATH_SUFFIXES
          UseDoxygen
    )

	
    # This modifies the user configuration directly, so should not be done. If this has been working for a while remove this comment 2013-08-21
    ## add cmakeMesh path to the list of paths for cmake files
    #list(APPEND CMAKE_MODULE_PATH ${CMAKE_MESH_USE_DOXYGEN_PATH})
    #list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)
	  
	  
	  find_package(Doxygen)
	  if (NOT DOXYGEN_FOUND)
	    message(WARNING "Doxygen not found, skipping documentation. Please install and configure Doxygen correctly.")
	  else(NOT DOXYGEN_FOUND)
       
	    set(DOXYGEN_PREDEFINED ${PROJECT_NAME})
	    set(DOXYFILE_WARN_LOG_FILE ${CMAKE_DOC_OUTPUT_DIRECTORY}/doxywarn.txt)
	    set(DOXYFILE_EXCLUDE_PATTERNS "*.m */.hg/* */.svn/* */.git/* */.* */.*/* ")
	    set(DOXYFILE_HTML_HEADER ${CMAKE_MESH_USE_DOXYGEN_PATH}/header.html)
	    set(DOXYFILE_HTML_FOOTER ${CMAKE_MESH_USE_DOXYGEN_PATH}/footer.html)
	    set(DOXYFILE_SOURCE_DIR ${PROJECT_SOURCE_DIR})
       set(DOXYFILE_HTML_DIR ${CMAKE_DOC_OUTPUT_DIRECTORY}/html)
      

       # take list of directories to exclude and convert it into a format doxygen understands
       list(APPEND DOXYFILE_EXCLUDE "${CMAKE_CURRENT_LIST_FILE}")
       string(REPLACE ";" " " DOXYFILE_EXCLUDE ${DOXYFILE_EXCLUDE})
      
       # add the paths to each project directory to the doxygen image paths if it has not been set manually
       if(NOT DOXYFILE_IMAGE_DIR)
         foreach(CMAKE_MESH_SINGLE_IMAGE_PATH ${CMAKE_MESH_ALL_SUBDIRECTORY_PACKAGE_DIRS} ${CMAKE_SOURCE_DIR} ${PROJECT_SOURCE_DIR})
           set(DOXYFILE_IMAGE_DIR "${DOXYFILE_IMAGE_DIR} \"${CMAKE_MESH_SINGLE_IMAGE_PATH}\"")
         endforeach()
       endif(NOT DOXYFILE_IMAGE_DIR)
       
	    FIND_PACKAGE(HTMLHelp)
	    if(HTMLHELP_FOUND)
     	   set(DOXYFILE_HTML_HELP_COMPILER ${HTML_HELP_COMPILER})
	    endif()
       
 	    include(${CMAKE_MESH_USE_DOXYGEN_PATH}/UseDoxygen.cmake)
	  endif(NOT DOXYGEN_FOUND)


endmacro(mesh_setup_doxygen)
