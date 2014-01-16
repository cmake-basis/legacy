#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

##########################################################
# ------- Setup Config Header ---------------
##########################################################
#
# SetupConfigHeader takes all the steps necessary for basic project setup, calling other setup functions
#  
# Options:
#   INSTALL_CONFIG_HEADER         - Installs a project configuration header into MESH_INCLUDE_INSTALL_DIRECTORY
#
# Multi Arg Params:
#   HINTS                         - List of paths to look for config input file named ProjectConfig.h.in
#
##########################################################
function(SetupConfigHeader)
  
  set(options INSTALL_CONFIG_HEADER)
  set(oneValueArgs ) # currently none
  set(multiValueArgs HINTS)
  cmake_parse_arguments(SETUP_CONFIG_HEADER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  
  find_file(PROJECT_CONFIG_H_IN ProjectConfig.h.in 
    HINTS
      ${CMAKE_CURRENT_SOURCE_DIR}
      ${PROJECT_SOURCE_DIR}
      ${CMAKE_SOURCE_DIR}
      ${SETUP_CONFIG_HEADER_HINTS}
      ${CMAKE_MESH_PATH}
    PATH_SUFFIXES
      /modules/cmake/
      /cmake/
      /cmakeMesh/
      /modules/cmakeMesh/
      /external/cmakeMesh/
      /
  )

  #Get Mercurial release
  find_package(Mercurial)
  if(MERCURIAL_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.hg")
    
    mercurial_hg_info(${PROJECT_SOURCE_DIR} ${PROJECT_NAME})
    message(STATUS "Current ${PROJECT_NAME} mercurial repository revision:")
    message(STATUS "    Revision:  ${${PROJECT_NAME}_HG_ID}")
    message(STATUS "    Changeset: ${${PROJECT_NAME}_HG_CHANGESET}")
    message(STATUS "    Author:    ${${PROJECT_NAME}_HG_AUTHOR}")
    message(STATUS "    Date:      ${${PROJECT_NAME}_HG_DATE}")
    message(STATUS "    Tags:      ${${PROJECT_NAME}_HG_TAGS}")
    message(STATUS "    Branch:    ${${PROJECT_NAME}_HG_BRANCH}")
    message(STATUS "    Summary:   ${${PROJECT_NAME}_HG_SUMMARY}")
  endif(MERCURIAL_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.hg")

  # set the output config file
  if(NOT EXISTS MESH_PROJECT_CONFIG_HEADER)
	  set(MESH_PROJECT_CONFIG_HEADER "${CMAKE_INCLUDE_OUTPUT_DIRECTORY}/${PROJECT_NAME}Config.h")
  endif(NOT EXISTS MESH_PROJECT_CONFIG_HEADER)
	
	# --------- Setup the Configuration header file -------------
	# configure a header file to pass some of the CMake settings
	# to the source code
	configure_file (
	  ${PROJECT_CONFIG_H_IN}
	  ${MESH_PROJECT_CONFIG_HEADER}
	)
	
	# add the binary tree to the search path for include files
	# so that we will find ${PROJECT_NAME}Config.h
	include_directories("${CMAKE_INCLUDE_OUTPUT_DIRECTORY}")
	
  if(SETUP_CONFIG_HEADER_INSTALL_CONFIG_HEADER)
    install(FILES ${MESH_PROJECT_CONFIG_HEADER} DESTINATION  ${MESH_INCLUDE_INSTALL_DIRECTORY})
  endif(SETUP_CONFIG_HEADER_INSTALL_CONFIG_HEADER)
	
endfunction(SetupConfigHeader)
