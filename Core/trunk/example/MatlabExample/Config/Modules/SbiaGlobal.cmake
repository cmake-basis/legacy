##############################################################################
# \file  SbiaGlobal.cmake
# \brief Global CMake settings used at SBIA.
#
# This file is included at the top of the root CMake files of each project
# before all other SBIA CMake module files if the environment variable
# SBIA_CMAKE_MODULE_PATH is set to the path of the directory containing
# this file. Otherwise, a local copy of it which is included with each
# project is used.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# URL to project templates
# ============================================================================

# The following variable is used by the CMake module SbiaUpdate.cmake which
# implements the (automatic) file update of project files which were
# instantiated from the project template. Its value has to be a valid URL,
# i.e., begin with "http://", "https://", or "file://", for example.
# If this variable is not set or invalid, the file udpate is disabled.
#
# \see SbiaUpdate.cmake
#
# Examples:
#
# "file:///sbiasfw/lab/share/development/templates"
# "https://sbia-svn/projects/Development_Project_Templates/RevisedCMakeProjectTemplate"

set (SBIA_PROJECT_TEMPLATE_ROOT_DIR "")

# ============================================================================
# CMake module path
# ============================================================================

# default CMake module path
#
# This variable can be used by projects to reset the CMake module path
# after it was temporarily set to a different path such as
# PROJECT_CMAKE_MODULE_PATH, for example.
#
# \note This variable may differ from SBIA_CMAKE_MODULE_PATH!

set (DEFAULT_CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/Config/Modules")
set (CMAKE_MODULE_PATH         "${DEFAULT_CMAKE_MODULE_PATH}")
