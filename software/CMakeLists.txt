##############################################################################
# \file  CMakeLists.txt
# \brief Root CMake configuration file of the BASIS Core package.
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
# initialize
# ============================================================================

# set CMake module path
set (BASIS_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/src/cmake")
set (CMAKE_MODULE_PATH "${BASIS_MODULE_PATH}")

# use invalid template version to indicate that this project is not
# instantiated from a template as it is even the basis of any template
set (TEMPLATE_VERSION "0.0")

# include BASIS settings
include (BasisSettings NO_POLICY_SCOPE)
include (BasisDirectories)

# include BASIS functions
include (BasisProjectTools)

# \see basis_project_initialize ()
basis_project_initialize ("BASIS")

# ============================================================================
# subdirectories
# ============================================================================

add_subdirectory ("${SOFTWARE_SOURCE_DIR}")

if (EXISTS "${PROJECT_EXAMPLE_DIR}")
  add_subdirectory ("${PROJECT_EXAMPLE_DIR}")
endif ()

if (EXISTS "${PROJECT_TESTING_DIR}")
  add_subdirectory ("${PROJECT_TESTING_DIR}")
endif ()

# ============================================================================
# finalize
# ============================================================================

basis_project_finalize ()

