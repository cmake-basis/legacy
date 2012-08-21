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
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup BasisSettings
##############################################################################

# The modules depend especially on auxiliary testing targets of the core, i.e.,
# the top-level project of BASIS itself. Therefore, configure/build this
# project before the modules.
set (BASIS_BUILD_MODULES_FIRST FALSE)

# the following variable would be set by the BASISConfig.cmake file if this
# project would not be BASIS itself
set (BASIS_MODULES_ENABLED "${PROJECT_MODULES_ENABLED}")

# ============================================================================
# directories
# ============================================================================

# installation directory of CMake modules
set (INSTALL_MODULES_DIR "${INSTALL_SHARE_DIR}/cmake-modules")

# installation directory of utilities template files
set (INSTALL_CXX_TEMPLATES_DIR    "${INSTALL_SHARE_DIR}/utilities")
set (INSTALL_JAVA_TEMPLATES_DIR   "${INSTALL_SHARE_DIR}/utilities")
set (INSTALL_PYTHON_TEMPLATES_DIR "${INSTALL_SHARE_DIR}/utilities")
set (INSTALL_PERL_TEMPLATES_DIR   "${INSTALL_SHARE_DIR}/utilities")
set (INSTALL_MATLAB_TEMPLATES_DIR "${INSTALL_SHARE_DIR}/utilities")
set (INSTALL_BASH_TEMPLATES_DIR   "${INSTALL_SHARE_DIR}/utilities")

# common prefix (path) of Sphinx extensions
set (SPHINX_EXTENSIONS_PREFIX "basis/sphinx/ext")
# installation directory of Sphinx themes
set (INSTALL_SPHINX_THEMES_DIR "${INSTALL_SHARE_DIR}/sphinx-themes")

# ============================================================================
# utilities
# ============================================================================

# list of enabled utilities
# in case of other projects defined by BASISConfig.cmake
set (BASIS_UTILITIES_ENABLED CXX)
if (PythonInterp_FOUND)
  list (APPEND BASIS_UTILITIES_ENABLED PYTHON)
endif ()
if (Perl_FOUND)
  list (APPEND BASIS_UTILITIES_ENABLED PERL)
endif ()
if (BASH_FOUND)
  list (APPEND BASIS_UTILITIES_ENABLED BASH)
endif ()

# configure all BASIS utilities such that they are included in API
# documentation even if BASIS does not use them itself
if (Java_FOUND)
  basis_set_project_property (PROPERTY PROJECT_USES_JAVA_UTILITIES TRUE)
endif ()
if (PythonInterp_FOUND)
  basis_set_project_property (PROPERTY PROJECT_USES_PYTHON_UTILITIES TRUE)
endif ()
if (Perl_FOUND)
  basis_set_project_property (PROPERTY PROJECT_USES_PERL_UTILITIES TRUE)
endif ()
if (BASH_FOUND)
  basis_set_project_property (PROPERTY PROJECT_USES_BASH_UTILITIES TRUE)
endif ()
if (MATLAB_FOUND)
  basis_set_project_property (PROPERTY PROJECT_USES_MATLAB_UTILITIES TRUE)
endif ()

# target UIDs of BASIS libraries; these would be set by the package configuration
# file if this BASIS project would not be BASIS itself
if (BASIS_USE_FULLY_QUALIFIED_UIDS)
  set (NS "sbia.basis.")
else ()
  set (NS)
endif ()
set (BASIS_CXX_UTILITIES_LIBRARY    "${NS}utilities_cxx")
set (BASIS_PYTHON_UTILITIES_LIBRARY "${NS}utilities_python")
set (BASIS_PERL_UTILITIES_LIBRARY   "${NS}utilities_perl")
set (BASIS_BASH_UTILITIES_LIBRARY   "${NS}utilities_bash")
set (BASIS_TEST_LIBRARY             "${NS}testlib")
set (BASIS_TEST_MAIN_LIBRARY        "${NS}testmain")

# ============================================================================
# testing
# ============================================================================

# BASIS used by tests to build test projects
set (TESTING_BASIS_DIR "${PROJECT_BINARY_DIR}")

# compile flags for test projects, e.g., utilities tests
set (TESTING_BUILD_TYPE          "${CMAKE_BUILD_TYPE}")
set (TESTING_C_FLAGS             "${CMAKE_C_FLAGS}")
set (TESTING_CXX_FLAGS           "${CMAKE_CXX_FLAGS}")
set (TESTING_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}")
set (TESTING_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS}")
set (TESTING_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS}")
