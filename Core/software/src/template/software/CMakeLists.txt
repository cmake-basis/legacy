##############################################################################
# \file  CMakeLists.txt
# \brief Root CMakeLists.txt file of software component.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

# ============================================================================
# CMake version
# ============================================================================

cmake_minimum_required (VERSION 2.8.2)

# ============================================================================
# template version
# ============================================================================

# Specifies the tagged project template which this project was instantiated
# from. This information is required by the automatic update of template
# files from the project template repository or working copy, respectively.
# Further, the BASIS CMake modules can make use of this variable for the
# purpose of backwards compatibility with previous template versions.

set (TEMPLATE_VERSION "0.0")

# ============================================================================
# BASIS
# ============================================================================

find_package (BASIS REQUIRED)

if (BASIS_FOUND)
  include ("${BASIS_USE_FILE}")
else ()
  return ()
endif ()

# ============================================================================
# directory structure
# ============================================================================

# The following two variables are actually set by CMake. This, however, after
# the project () command. As in particular the Settings.cmake module is
# included before this command is given, these CMake variables are set here
# manually such that they can be used in Settings.cmake.
set (PROJECT_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
set (PROJECT_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")

set (PROJECT_CONFIG_DIR    "config")  # configuration files
set (PROJECT_DATA_DIR      "data")    # (required) auxiliary data files
set (PROJECT_DOC_DIR       "doc")     # documentation
set (PROJECT_EXAMPLE_DIR   "example") # example usage and input data
set (PROJECT_SRC_DIR       "src")     # project source code
set (PROJECT_TEST_DIR      "test")    # testing data and implementations

# directory of local CMake modules
set (PROJECT_MODULE_PATH "${PROJECT_CONFIG_DIR}/modules")

# make relative paths absolute
foreach(P CONFIG DATA DOC EXAMPLE SRC TEST)
  set(VAR PROJECT_${P}_DIR)
  get_filename_component (${VAR} "${${VAR}}" ABSOLUTE)
endforeach()

get_filename_component (PROJECT_MODULE_PATH "${PROJECT_MODULE_PATH}" ABSOLUTE)

# ============================================================================
# start
# ============================================================================

# The following macro call replaces the CMake command project (). Besides
# calling this command, it sets further common CMake variables such as
# PROJECT_NAME_UPPER, PROJECT_NAME_LOWER, PROJECT_VERSION_MAJOR,
# PROJECT_VERSION_MINOR, PROJECT_VERSION_PATCH,... please refer to
# the documentation of the macro for a list of available variables.
#
# The project attributes such as the version have to be specified as CMake
# variables in the CMake module PROJECT_CONFIG_DIR/Settings.cmake.
#
# The common CMake variables PROJECT_SOURCE_DIR and PROJECT_BINARY_DIR
# should be used in the subsequent CMake code to refer to the source or
# binary tree of the project. DO NOT use CMAKE_SOURCE_DIR and CMAKE_BINARY_DIR
# as these variables differ from the project specific variables when the
# project is part of a superproject.
#
# \see sbia_project ()

sbia_project ("ReplaceByProjectName")

# ============================================================================
# subdirectories
# ============================================================================

add_subdirectory ("${PROJECT_SRC_DIR}")

if (EXISTS "${PROJECT_DATA_DIR}")
  add_subdirectory ("${PROJECT_DATA_DIR}")
endif ()

if (EXISTS "${PROJECT_TESTS_DIR}" AND BUILD_TESTING)
  add_subdirectory ("${PROJECT_TESTS_DIR}")
endif ()

if (EXISTS "${PROJECT_EXAMPLE_DIR}")
  add_subdirectory ("${PROJECT_EXAMPLE_DIR}")
endif ()

if (EXISTS "${PROJECT_TESTING_DIR}" AND BUILD_TESTING)
  add_subdirectory ("${PROJECT_TESTING_DIR}")
endif ()

add_subdirectory ("${PROJECT_DOC_DIR}")

# ============================================================================
# finalize
# ============================================================================

# finalize configuration of project
sbia_project_finalize ()

