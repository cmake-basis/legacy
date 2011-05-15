##############################################################################
# \file  MakeLists.txt
# \brief Root CMake file.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# CMake version
# ============================================================================

# minimum required CMake version
cmake_minimum_required (VERSION 2.8 FATAL_ERROR)

# ============================================================================
# template version
# ============================================================================

# Specifies the tagged project template which this project was instantiated
# from. This information is required by the automatic update of template
# files from the project template repository or working copy, respectively.
# Further, the SbiaGlobal.cmake module which sets the CMAKE_MODULE_PATH
# to the path of the folder containing the Sbia* CMake modules may make use
# of this information to set the path different for different versions of the
# template in order to guarantee backwards compatibility.

set (PROJECT_TEMPLATE "SbiaProject-1/Template")

# ============================================================================
# load modules (before project () command)
# ============================================================================

# At first, the CMake module SbiaGlobal.cmake is included. This module specifies
# the locations of other CMake modules and the root directory of project
# templates, among others. Note that SbiaGlobal.cmake defines the variable
# DEFAULT_CMAKE_MODULE_PATH and sets CMAKE_MODULE_PATH to this path.
#
# \note DEFAULT_CMAKE_MODULE_PATH may differ from the environment variable
#       SBIA_CMAKE_MODULE_PATH and further is not necessarily equal to
#       CMAKE_CURRENT_SOURCE_DIR/CMake, the project's CMake module path!
#
# \see SbiaGlobal.cmake
# \see Settings.cmake

if (IS_DIRECTORY "$ENV{SBIA_CMAKE_MODULE_PATH}")
  set (CMAKE_MODULE_PATH "$ENV{SBIA_CMAKE_MODULE_PATH}")
else ()
  set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Config/Modules")
endif ()

include (SbiaGlobal)   # global settings, modifies CMAKE_MODULE_PATH
include (SbiaCommands) # finds installed programs such as svn, python,...
include (SbiaMacros)   # definition of CMake macros and functions
include (SbiaUpdate)   # implementation of automatic file update
include (SbiaSettings) # default CMake settings

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

# Include additional CMake modules within this customizable section.

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ============================================================================
# project attributes and settings
# ============================================================================

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

# Specifies the location of the Settings.cmake file required by the following
# macro sbia_project (). See the documentation of sbia_project () which is
# defined in the CMake module SbiaMacros.cmake for details.
#
# \see sbia_project ()

set (PROJECT_CONFIG_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Config")

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# The following macro call replaces the CMake command project (). Besides
# calling this command, it sets further common CMake variables such as
# PROJECT_NAME_UPPER, PROJECT_NAME_LOWER, PROJECT_VERSION_MAJOR,
# PROJECT_VERSION_MINOR, PROJECT_VERSION_PATCH,... please refer to
# the documentation of the macro sbia_project () for a list of all available
# variables.
#
# The project name and version have to be specified as CMake variables
# PROJECT_NAME and PROJECT_VERSION in the Settings.cmake which must be in the
# current source directory.
#
# The common CMake variables PROJECT_SOURCE_DIR and PROJECT_BINARY_DIR
# should be used in the subsequent CMake code to refer to the source or
# binary tree of the project.
#
# \see sbia_project ()

sbia_project ()

# ============================================================================
# load modules (after project () command)
# ============================================================================

include (SbiaTesting) # testing support, includes CTest

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

# Include additional CMake modules within this customizable section.

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ============================================================================
# update
# ============================================================================

# See documentation of the module SbiaUpdate.cmake for details.

# If you experience problems with the automatic file update, contact the
# maintainer of the template project or sbia-software@uphs.upenn.edu and
# consider to disable the automatic file update for single files by adding
# their path relative to the project's source directory to
# SBIA_UPDATE_EXCLUDE in the module Settings.cmake in the top directory of
# the project's source tree.

sbia_update_initialize ()

# \attention The sbia_update* () functions cannot be used before the CMake
#            modules SbiaCommands and SbiaUpdate were included and the macro
#            sbia_project () has been called.

sbia_update (CMakeLists.txt)
sbia_update (CTestConfig.cmake)

# ============================================================================
# default C++ include file
# ============================================================================

set (CONFIG_H_TEMPLATE "${PROJECT_CONFIG_DIR}/Config.h.in")
set (CONFIG_H_DIR      "${PROJECT_BINARY_DIR}")
set (CONFIG_H          Sbia${PROJECT_NAME}Config.h)
set (CONFIG_H_FILE     "${CONFIG_H_DIR}/${CONFIG_H}")

configure_file (${CONFIG_H_TEMPLATE} ${CONFIG_H_FILE} @ONLY)

set (SBIA_TEMPLATE_HDRS
  ${CONFIG_H_TEMPLATE}
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
)

set (SBIA_DEFAULT_SRCS
  ""
)

set (SBIA_DEFAULT_SOURCES
  ${SBIA_DEFAULT_HDRS}
  ${SBIA_DEFAULT_SRCS}
)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

source_group ("Templates" FILES ${SBIA_TEMPLATE_SOURCES})
source_group ("Default"   FILES ${SBIA_DEFAULT_SOURCES})

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

include_directories (BEFORE "${CONFIG_H_DIR}")

# ============================================================================
# subdirectories
# ============================================================================

add_subdirectory (Config)       # update project configuration files

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Utilities")
  add_subdirectory (Utilities)  # build and/or install utilities
endif ()

add_subdirectory (Code)         # build and install project sources

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Example")
  add_subdirectory (Example)    # build and/or install example(s)
endif ()

if (BUILD_TESTING)
  add_subdirectory (Testing)    # build and add tests
endif ()

add_subdirectory (Doc)          # generate and/or install documentation

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

# Add further subdirectories within this customizable section.

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ============================================================================
# miscellaneous
# ============================================================================

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>



# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ============================================================================
# configure config and version file
# ============================================================================

set (PROJECT_CONFIG_TEMPLATE         "${PROJECT_CONFIG_DIR}/Config.cmake.in")
set (PROJECT_CONFIG_FILE             "${PROJECT_BINARY_DIR}/Sbia${PROJECT_NAME}Config.cmake")
set (PROJECT_CONFIG_VERSION_TEMPLATE "${PROJECT_CONFIG_DIR}/ConfigVersion.cmake.in")
set (PROJECT_CONFIG_VERSION_FILE     "${PROJECT_BINARY_DIR}/Sbia${PROJECT_NAME}ConfigVersion.cmake")

configure_file ("${PROJECT_CONFIG_TEMPLATE}"         "${PROJECT_CONFIG_FILE}"         @ONLY)
configure_file ("${PROJECT_CONFIG_VERSION_TEMPLATE}" "${PROJECT_CONFIG_VERSION_FILE}" @ONLY)

# ============================================================================
# packaging
# ============================================================================

include (SbiaPackage)

# ============================================================================
# auxiliary files
# ============================================================================

# if project uses MATLAB
if (MATLAB_FOUND)
  sbia_create_addpaths_mfile ()
endif ()

# ============================================================================
# finalize update
# ============================================================================

sbia_update_finalize ()

