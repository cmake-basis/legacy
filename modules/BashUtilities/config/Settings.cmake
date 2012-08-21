##############################################################################
# @file  Settings.cmake
# @brief Non-default project settings.
#
# This file is included by basis_project_impl() after it looked for the
# required and optional dependencies and the CMake variables related to the
# project directory structure were defined (see BASISDirectories.cmake file
# in @c PROJECT_BINARY_DIR, where BASIS is here the name of the project).
# It is further included before the BasisSettings.cmake file.
#
# In particular, build options should be added in this file using CMake's
# <a href="http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:option">
# option()</a> command. Further, any common settings related to using a found
# dependency can be set here if the basis_use_package() command was enable
# to import the required configuration of a particular external package.
#
# Copyright (c) 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup BasisSettings
##############################################################################

# target name of utilities library in lib/ directory
set (BASH_LIBRARY_TARGET "shutils")

# installation directory of utilities template files
set (INSTALL_TEMPLATES_DIR "${INSTALL_SHARE_DIR}/utilities")

# configure all BASIS utilities such that they are included in API
# documentation even if BASIS does not use them itself
basis_set_project_property (PROPERTY PROJECT_USES_BASH_UTILITIES TRUE)

# the following variable would be set by the package configuration file
# but has to be set here such that the CMake UtilitiesTools.cmake
# functions can add a dependency on this target
if (BASIS_USE_FULLY_QUALIFIED_UIDS)
  set (BASIS_BashUtilities_LIBRARY "basis.${BASH_LIBRARY_TARGET}")
else ()
  set (BASIS_BashUtilities_LIBRARY "${BASH_LIBRARY_TARGET}")
endif ()
