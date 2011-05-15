##############################################################################
# \file  Settings.cmake
# \brief Project settings.
#
# This file can be used to overwrite default settings which are set by
# SbiaSettings.cmake and to setup further global project settings. Therefore,
# it has to be included after SbiaSettings.cmake in the project's root CMake
# file. In particular, the command sbia_project () includes this file.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# project name
# ============================================================================

# Specify the name of the project here. This should be the only place where
# the actual project name is given. All other CMake code uses this variable.
# Note that the project name may not contain any whitespaces.

set (PROJECT_NAME "MatlabExample")

# ============================================================================
# project version
# ============================================================================

# Update package version whenever a new release of the project is published
# and/or the project is tagged.
#
# The version number consists of three components: the major version number,
# the minor version number, and the patch number. The format of the version
# string is "Major.Minor.Patch", where the patch number defaults to 0 if not
# given. Only digits are allowed except of the two separating dots.
#
# A change of the major version number indicates changes of the softwares API
# and/or its behavior and/or the change or addition of major features.
# A change of the minor version number indicates changes that are not only bug
# fixes and no major changes.
# A change of the patch number indicates changes only related to bug fixes
# which did not change the softwares API. It is the least important component
# of the version number.

set (PROJECT_VERSION "1.0.0")

# ============================================================================
# package vendor
# ============================================================================

# The name of the vendor of the project's package. This variable is mainly
# used for the packaging via CPack, i.e., as value of CPACK_PACKAGE_VENDOR.

set (PROJECT_PACKAGE_VENDOR "University of Pennsylvania Health Systems")

# ============================================================================
# project description
# ============================================================================

# Give a brief description of the project in the following. This description
# is in particular used as value of CPACK_PACKAGE_DESCRIPTION_SUMMARY for
# the package creation via CPack (see SbiaPackage module).

set (PROJECT_DESCRIPTION "This is an example project which uses MATLAB.")

# ============================================================================
# root documentation
# ============================================================================

# Specify the main documentation file of the project here. This variable is
# used for the package creation via CPack, for example.
#
# \see SbiaPackage
#
# \note As the CMake command project () was not invoked yet at this point,
#       use CMAKE_CURRENT_SOURCE_DIR or CMAKE_CURRENT_BINARY_DIR instead
#       of PROJECT_SOURCE_DIR or PROJECT_BINARY_DIR, respectively.

set (PROJECT_README_FILE "${CMAKE_CURRENT_BINARY_DIR}/Doc/ReadMe.html")

# ============================================================================
# license
# ============================================================================

# Specify the license file of the project. The content of this file will be
# displayed during the installation of the package created via CPack, for
# example.
#
# \see SbiaPackage
#
# \note As the CMake command project () was not invoked yet at this point,
#       use CMAKE_CURRENT_SOURCE_DIR or CMAKE_CURRENT_BINARY_DIR instead
#       of PROJECT_SOURCE_DIR or PROJECT_BINARY_DIR, respectively.

set (PROJECT_LICENSE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright")

# ============================================================================
# directories
# ============================================================================

# \note As the CMake command project () was not invoked yet at this point,
#       use CMAKE_CURRENT_SOURCE_DIR or CMAKE_CURRENT_BINARY_DIR instead
#       of PROJECT_SOURCE_DIR or PROJECT_BINARY_DIR, respectively.

# directory of local CMake modules
#
# The variable CMAKE_MODULE_DIR is set by the module SbiaGlobal. Even if this
# variable yet refers to the project's own 'CMake' folder, it may refer to
# another lab-wide CMake modules path specified by DEFAULT_CMAKE_MODULE_PATH
# in the future. Hence, use this variable whenever you want to include a
# project own CMake module and specify the absolute path of the module.
# Alternatively, temporarily adjust the CMAKE_MODULE_PATH and then reset it
# by setting its value to DEFAULT_CMAKE_MODULE_PATH.
#
# Example:
#
# \code
# include ("${PROJECT_CMAKE_MODULE_DIR}/Module.cmake")
# \endcode
#
# or
#
# \code
# set (CMAKE_MODULE_PATH "${PROJECT_CMAKE_MODULE_PATH}")
# include (Module)
# set (CMAKE_MODULE_PATH "${DEFAULT_CMAKE_MODULE_PATH}")
# \endcode
set (PROJECT_CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/Config/Modules")

# directory of local external libraries
set (PROJECT_UTILITIES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Utilities")

# ============================================================================
# options
# ============================================================================

# Add build options here using the CMake command option ().
#
# \see http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:option

# ============================================================================
# build configuration(s)
# ============================================================================

# Set common compiler and linker flags for the different supported build
# configurations here. The available build configurations are listed in
# CMAKE_CONFIGURATION_TYPES. For each build configuration, there exist the
# CMake variables CMAKE_C_FLAGS_<CONFIG> and CMAKE_CXX_FLAGS_<CONFIG>
# which specify the compiler flags, where <CONFIG> is the name of the build
# configuration in uppercase letters only. Accordingly, the variables
# CMAKE_EXE_LINKER_FLAGS_<CONFIG>, CMAKE_MODULE_LINKER_FLAGS_<CONFIG>,
# and CMAKE_SHARED_LINKER_FLAGS_<CONFIG> specify the linker flags for
# the corresponding target types.
#
# In order to only add compiler and/or linker flags, only append the values of
# the corresponding variables.
#
# \see SbiaSettings.cmake

# ============================================================================
# update
# ============================================================================

# exclude certain project files from (automatic) file update
#
# \note File paths have to be specified relative to the project source
#       directory such as "Doc/Doxyfile.in" or "Config/Config.cmake.in".
set (
  SBIA_UPDATE_EXCLUDE
)
