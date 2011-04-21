##############################################################################
# \file  CMakeLists.txt
# \brief Top CMake file of the testing system (based on CTest).
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# update
# ============================================================================

# See documentation of SbiaUpdate.cmake for details.

sbia_update (CMakeLists.txt)
sbia_update (CTestCustom.cmake.in)

# ============================================================================
# custom CTest settings
# ============================================================================

# configure custom CTest settings and/or copy them to binary tree
configure_file (
  "${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake.in"
  "${PROJECT_BINARY_DIR}/CTestCustom.cmake"
  @ONLY
)

# ============================================================================
# subdirectories
# ============================================================================

# configure build system of test executables and/or add tests
add_subdirectory (Tests)

# configure and/or install test data
add_subdirectory (Data)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>



# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
