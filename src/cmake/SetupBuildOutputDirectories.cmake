#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

include(CMakeParseArguments)

##########################################################
#
# mesh_setup_build_output_directories - configures the destination output directories of binaries, libraries, include files, and installations
#
# Single Arg Params:
#   INSTALL_PREFIX                - Installation toplevel project directory to be created in which all installation files will be placed upon running installation.
#                                   To keep the current CMAKE_INSTALL_PREFIX, call mesh_setup_build_output_directories(INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
#                                      Default: "nrec/", default is used for installing to a binary build software tree for distribution.
#
##########################################################
macro(mesh_setup_build_output_directories)
  
  set(options ) # currently none
  set(oneValueArgs INSTALL_PREFIX)
  set(multiValueArgs ) # currently none
  cmake_parse_arguments(SETUP_BUILD_OUTPUT_DIRECTORIES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  
  
  ## set default install prefix if param is blank
  ## TODO: This functionality that modifies INSTALL_PREFIX by default may not be appropriate and may be difficult for users to find and modify, consider removing it or making it easier to use.
  #if(NOT SETUP_BUILD_OUTPUT_DIRECTORIES_INSTALL_PREFIX)
  #  set(SETUP_BUILD_OUTPUT_DIRECTORIES_INSTALL_PREFIX nrec/ )
  #endif(NOT SETUP_BUILD_OUTPUT_DIRECTORIES_INSTALL_PREFIX)
  
  # set install prefix
  set(CMAKE_INSTALL_PREFIX ${SETUP_BUILD_OUTPUT_DIRECTORIES_INSTALL_PREFIX} ) # CACHE PATH "Toplevel project directory to be created in which all installation files will be placed upon running installation."

### CMake defined Output Directory Variables ###

  # ---------- Setup Library Output Directory -------------------------
  set (CMAKE_LIBRARY_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/lib
    CACHE PATH
    "Single Build Directory for all Libraries"
    )

  # --------- Setup Static Library Output Directory -------------
  set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/lib
    CACHE PATH
    "Single Build Directory for all static libraries."
    )
  
  # --------- Setup the Executable output Directory -------------
  set (CMAKE_RUNTIME_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/bin
    CACHE PATH
    "Single Build Directory for all Executables."
    )
  
  # --------- Setup the Include output Directory -------------
  set (CMAKE_INCLUDE_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/include
    CACHE PATH
    "Single Build Directory for all include files."
    )

  # --------- Setup Static Library Output Directory -------------
  set (CMAKE_DOC_OUTPUT_DIRECTORY
    ${PROJECT_BINARY_DIR}/doc
    CACHE PATH
    "Single Build Directory for documentation"
    )
	
### NREC defined Install directory variables ###

  # ---------- Setup Library Install Directory -------------------------
  set (MESH_LIBRARY_INSTALL_DIRECTORY
    lib
    CACHE PATH
    "Install Directory for Libraries"
    )

  # --------- Setup Static Library Install Directory -------------
  set (MESH_ARCHIVE_INSTALL_DIRECTORY
    lib
    CACHE PATH
    "Install Directory for  static libraries."
    )
  
  # --------- Setup the Executable Install Directory -------------
  set (MESH_RUNTIME_INSTALL_DIRECTORY
    bin
    CACHE PATH
    "Install Directory for Executables."
    )
  
  # --------- Setup the Include Install Directory -------------
  set (MESH_INCLUDE_INSTALL_DIRECTORY
    include
    CACHE PATH
    "Install Directory for include files."
    )

  set (MESH_DEFAULT_INSTALL_PARAMETERS
    RUNTIME DESTINATION ${MESH_RUNTIME_INSTALL_DIRECTORY}
    LIBRARY DESTINATION ${MESH_LIBRARY_INSTALL_DIRECTORY} 
    ARCHIVE DESTINATION ${MESH_LIBRARY_INSTALL_DIRECTORY}
    BUNDLE DESTINATION .
  )
endmacro(mesh_setup_build_output_directories)
