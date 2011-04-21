##############################################################################
# \file  CMakeLists.txt
# \brief Root CMakeLists.txt file of SBIA (sub-)project.
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
# Further, the SBIA CMake Modules package can make use of this variable in
# order to guarantee backwards compatibility with previous template versions.

set (TEMPLATE_VERSION "1.0")

# ============================================================================
# cornerstone
# ============================================================================

find_package (SBIA_SRC REQUIRED)

if (NOT SBIA_SRC_FOUND)
  return ()
endif ()

# Includes required SBIA CMake modules and sets CMAKE_MODULE_PATH to
# SBIA_SRC_MODULE_PATH where the fundamental CMake modules and common
# CMake Find modules are located.
include ("${SBIA_SRC_USE_FILE}")

# ============================================================================
# project directories
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
# project attributes and settings
# ============================================================================

# The following macro call replaces the CMake command project (). Besides
# calling this command, it sets further common CMake variables such as
# PROJECT_NAME_UPPER, PROJECT_NAME_LOWER, PROJECT_VERSION_MAJOR,
# PROJECT_VERSION_MINOR, PROJECT_VERSION_PATCH,... please refer to
# the documentation of the macro sbia_project () for a list of all available
# variables.
#
# The project name and version have to be specified as CMake variables
# PROJECT_NAME and PROJECT_VERSION in the CMake module
# PROJECT_CONFIG_DIR/Settings.cmake.
#
# The common CMake variables PROJECT_SOURCE_DIR and PROJECT_BINARY_DIR
# should be used in the subsequent CMake code to refer to the source or
# binary tree of the project. DO NOT use CMAKE_SOURCE_DIR and CMAKE_BINARY_DIR
# as these variables differ from the project specific variables when the
# project is part of a superproject.
#
# \see sbia_project ()

sbia_project ()

# ============================================================================
# default auxiliary source files
# ============================================================================

# get binary directory corresponding to PROJECT_SRC_DIR
file (RELATIVE_PATH BINARY_SRC_DIR "${PROJECT_SOURCE_DIR}" "${PROJECT_SRC_DIR}")
set (BINARY_SRC_DIR "${PROJECT_BINARY_DIR}/${BINARY_SRC_DIR}")

# config.h - This file is intended to be included by all source files.
#            Hence, other projects will indirectly include this file when
#            they use a library of this project.

set (CONFIG_H_TEMPLATE "${PROJECT_SRC_DIR}/config.h.in")
set (CONFIG_H_FILE     "${BINARY_SRC_DIR}/config.h")

configure_file (${CONFIG_H_TEMPLATE} ${CONFIG_H_FILE} @ONLY)

# main.h - This file is intended to be included by .(c|cc|cpp|cxx) files
#          only which further contain the definition of the main () function.
#          It may not be included by any other source file!

set (MAIN_H_TEMPLATE "${PROJECT_SRC_DIR}/main.h.in")
set (MAIN_H_FILE     "${BINARY_SRC_DIR}/main.h")

configure_file (${MAIN_H_TEMPLATE} ${MAIN_H_FILE} @ONLY)

set (SBIA_TEMPLATE_HDRS
  ${CONFIG_H_TEMPLATE}
  ${MAIN_H_TEMPLATE}
)

set (SBIA_TEMPLATE_SRCS
  ""
)

set (SBIA_TEMPLATE_SOURCES
  ${SBIA_TEMPLATE_HDRS}
  ${SBIA_TEMPLATE_SRCS}
)

set (SBIA_DEFAULT_HDRS
  ${CONFIG_H_FILE}
  ${MAIN_H_FILE}
)

set (SBIA_DEFAULT_SRCS
  ""
)

set (SBIA_DEFAULT_SOURCES
  ${SBIA_DEFAULT_HDRS}
  ${SBIA_DEFAULT_SRCS}
)

source_group ("Templates" FILES ${SBIA_TEMPLATE_SOURCES})
source_group ("Default"   FILES ${SBIA_DEFAULT_SOURCES})

include_directories (BEFORE "${BINARY_SRC_DIR}")

# ============================================================================
# subdirectories
# ============================================================================

if (EXISTS "${PROJECT_UTILITIES_DIR}")
  add_subdirectory (${PROJECT_UTILITIES_DIR})
endif ()

add_subdirectory ("${PROJECT_SRC_DIR}")

if (EXISTS "${PROJECT_DATA_DIR}")
  add_subdirectory ("${PROJECT_DATA_DIR}")
endif ()

if (EXISTS "${PROJECT_EXAMPLE_DIR}")
  add_subdirectory ("${PROJECT_EXAMPLE_DIR}")
endif ()

if (BUILD_TESTING)
  add_subdirectory ("${PROJECT_TEST_DIR}")
endif ()

add_subdirectory ("${PROJECT_DOC_DIR}")

# ============================================================================
# finalize
# ============================================================================

# finalize configuration of project
sbia_project_finalize ()

