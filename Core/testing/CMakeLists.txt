# \file  CMakeLists.txt
# \brief CMake file to configure build system of template tests.
#
# This CMake files configures the build system of the tests which are used
# to test the project template itself.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>

# ============================================================================
# CMake version
# ============================================================================

# minimum required CMake version
cmake_minimum_required (VERSION 2.6)

# ============================================================================
# common settings
# ============================================================================

# disable automatic file update as only the test of the automatic file udpate
# should make use of it. All other tests are related to other aspects of the
# project template
set (SBIA_PROJECT_TEMPLATE_ROOT_DIR)

# ============================================================================
# subdirectories
# ============================================================================

add_subdirectory (TestUpdateFile)
