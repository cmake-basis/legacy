##############################################################################
# \file  CMakeLists.txt
# \brief Root CMakeLists.txt file of testing source tree.
#
# Copyright (c) University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

# ============================================================================
# update
# ============================================================================

# See documentation of SbiaUpdate.cmake for details.

sbia_update (CTestCustom.cmake.in)

# ============================================================================
# custom settings
# ============================================================================

# configure custom CTest settings and/or copy them to binary tree
configure_file (
  "${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake.in"
  "${PROJECT_BINARY_DIR}/CTestCustom.cmake"
  @ONLY
)

# directories of test input data and exepected output data
set (TEST_DATA_DIR     "${CMAKE_CURRENT_SOURCE_DIR}/data")
set (TEST_EXPECTED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/expected")

# directories for built test executables and test output data
if (IS_SUBPROJECT)
  set (TEST_BIN_DIR    "${TEST_BIN_DIR}/${PROJECT_NAME}")
  set (TEST_OUTPUT_DIR "${TEST_OUTPUT_DIR}/${PROJECT_NAME}")
endif ()

# ============================================================================
# subdirectories
# ============================================================================

# configure build system of test executables and/or add tests
add_subdirectory (src)

