##############################################################################
# \file  CMakeLists.txt
# \brief Root CMakeLists.txt file of SBIA Cornerstone package.
#
# Any SBIA project that is instantiated from the project template whose
# development started in January 2011 depends at least on the components of
# this basis package. Hence, this package is the cornerstone of any (future)
# SBIA project.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

# ============================================================================
# CMake version
# ============================================================================

# minimum required CMake version
set (MINIMUM_REQUIRED_CMAKE_VERSION "2.8")

cmake_minimum_required (VERSION ${MINIMUM_REQUIRED_CMAKE_VERSION})

# ============================================================================
# template version
# ============================================================================

# use invalid template version to indicate that this project is not
# instantiated from any template as it in fact provides the template
set (TEMPLATE_VERSION "0.0")

# ============================================================================
# own CMake modules
# ============================================================================

# set CMake module path
set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/cmake")

# include main module
include (SbiaProjectTools)

# include default settings
include (SbiaSettings)

# ============================================================================
# project directories
# ============================================================================

# The following two variables are actually set by CMake. This, however, after
# the project () command. As in particular the Settings.cmake module is
# included before this command is given, these CMake variables are set here
# manually such that they can be used in Settings.cmake.
set (PROJECT_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set (PROJECT_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")

set (PROJECT_CONFIG_DIR  "config")  # configuration files
set (PROJECT_EXAMPLE_DIR "example") # example projects
set (PROJECT_SRC_DIR     "src")     # source code files

# make relative paths absolute
get_filename_component (PROJECT_CONFIG_DIR  "${PROJECT_CONFIG_DIR}"  ABSOLUTE)
get_filename_component (PROJECT_EXAMPLE_DIR "${PROJECT_EXAMPLE_DIR}" ABSOLUTE)
get_filename_component (PROJECT_SRC_DIR     "${PROJECT_SRC_DIR}"     ABSOLUTE)

# ============================================================================
# project attributes and settings
# ============================================================================

# \see sbia_project ()
sbia_project ()

# ============================================================================
# subdirectories
# ============================================================================

add_subdirectory ("${PROJECT_SRC_DIR}")

if (EXISTS "${PROJECT_EXAMPLE_DIR}")
  add_subdirectory ("${PROJECT_EXAMPLE_DIR}")
endif ()

# ============================================================================
# finalize
# ============================================================================

# finalize configuration of project
sbia_project_finalize ()

