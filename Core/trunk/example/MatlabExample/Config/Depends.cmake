##############################################################################
# \file  Depends.cmake
# \brief Contains find_package () commands to resolve external dependencies.
#
# This file is included by the macro sbia_project () if found in the
# directory specified by PROJECT_CONFIG_DIR which is set in the root
# CMakeLists file. It is supposed to resolve dependencies to external
# packages using the find_package () command of CMake. Alternatively,
# packages which are shipped with this project are located in
# PROJECT_UTILITIES_DIR (defined in Settings.cmake).
# CMake variables that are usually set by the find_package () call, should
# be set here as well using the PROJECT_UTILITIES_DIR variable.
#
# If no CMake Find module (i.e., Find<Package>.cmake) for an external package
# is available yet and the package does not provide a <Package>Config.cmake or
# <package>-config.cmake file, write your own Find module and store it in the
# 'CMake' folder of the project or have someone else write one for you.
# Consider also to inform the maintainer of the project template at SBIA to
# integrate your Find module into the collection of lab-wide available CMake
# modules.
#
# Note that the CMAKE_MODULE_PATH is by default set to
# DEFAULT_CMAKE_MODULE_PATH. This path does not necessarily lead to the
# 'CMake' folder of the project. Instead, use PROJECT_CMAKE_MODULE_PATH.
# Alternatively, set the CMAKE_MODULE_PATH to PROJECT_CMAKE_MODULE_PATH
# before using the find_package () command when the find modules in
# the 'CMake' folder should be used. The macro sbia_project () will
# reset the CMAKE_MODULE_PATH to DEFAULT_CMAKE_MODULE_PATH after this
# file has been processed.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# external
# ============================================================================

find_package (Matlab REQUIRED)

include_directories (${MATLAB_INCLUDE_DIR})

# ============================================================================
# intra-project
# ============================================================================

include_directories ("${PROJECT_SOURCE_DIR}/Code")
include_directories ("${PROJECT_BINARY_DIR}/Code")
