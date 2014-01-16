#
# Copyright (c) 2012
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

##########################################################
# ------- Set CMake Options  ---------------
##########################################################
# SEE: http://www.cmake.org/Wiki/CMake_Useful_Variables

macro(mesh_setup_cmake_options)
  # Always include the source and build directories in the include path
  # to save doing so manually in every subdirectory.
  set( CMAKE_INCLUDE_CURRENT_DIR ON )

  # Put the include directories which are in the source or build tree
  # before all other include directories so they are prefered over
  # any installed headers.
  set( CMAKE_INCLUDE_DIRECTORIES_PROJECT_BEFORE ON )

  
endmacro(mesh_setup_cmake_options)