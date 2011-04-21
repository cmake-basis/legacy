##############################################################################
# \file  SbiaTesting.cmake
# \brief CTest configuration.
#
# This file should be included in the root CMake file of any SBIA project
# after the invocation of the macro sbia_project ().
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# configuration
# ============================================================================

# include CTest module which enables testing
include (CTest)

mark_as_advanced (DART_TESTING_TIMEOUT)

# configure custom CTest settings and/or copy them to binary tree
if ("${PROJECT_BINARY_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  set (CTEST_CUSTOM_FILE "CTestCustom.cmake")
else ()
  set (CTEST_CUSTOM_FILE "CTestCustom-${PROJECT_NAME}.cmake")
endif ()

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake.in")
  configure_file (
    "${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake.in"
    "${CMAKE_BINARY_DIR}/${CTEST_CUSTOM_FILE}"
    @ONLY
  )
elseif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake")
  configure_file (
    "${CMAKE_CURRENT_SOURCE_DIR}/CTestCustom.cmake"
    "${CMAKE_BINARY_DIR}/${CTEST_CUSTOM_FILE}"
    COPYONLY
  )
endif ()

if (
      NOT "${CTEST_CUSTOM_FILE}" STREQUAL "CTestCustom.cmake"
  AND EXISTS "${CMAKE_BINARY_DIR}/${CTEST_CUSTOM_FILE}"
)
  file (APPEND "${CMAKE_BINARY_DIR}/CTestCustom.cmake" "include (\"./${CTEST_CUSTOM_FILE}\")")
endif ()

# ============================================================================
# convenience macros and functions
# ============================================================================

# ****************************************************************************
# \function sbia_add_tests_of_default_options
# \brief    Adds tests of default options for given executable (or script).
#
# \param [in] EXEC Name of executable target or script name.

function (sbia_add_tests_of_default_options EXEC)
  if (CMAKE_VERBOSE)
    message (STATUS "Adding tests of default options for '${EXEC}'...")
  endif ()

  # get absolute path to executable
  set (EXEC_NAME)

  if (TARGET "${EXEC}")
    get_target_property (EXEC_NAME "${EXEC}" OUTPUT_NAME)
  endif ()

  if (NOT EXEC_NAME)
    set (EXEC_NAME "${EXEC}")
  endif ()

  set (EXEC_CMD "${RUNTIME_OUTPUT_DIRECTORY}/${EXEC_NAME}")

  # --------------------------------------------------------------------------
  # test option: -V
  # --------------------------------------------------------------------------

  sbia_add_test (${EXEC}VersionS "${EXEC_CMD}" "-V")

  set_tests_properties (
    ${EXEC}VersionS
    PROPERTIES
      PASS_REGULAR_EXPRESSION "${EXEC} ${PROJECT_VERSION}"
  )

  # --------------------------------------------------------------------------
  # test option: --version
  # --------------------------------------------------------------------------

  sbia_add_test (${EXEC}VersionL "${EXEC_CMD}" "--version")

  set_tests_properties (
    ${EXEC}VersionL
    PROPERTIES
      PASS_REGULAR_EXPRESSION "${EXEC} ${PROJECT_VERSION}"
  )

  # --------------------------------------------------------------------------
  # test option: -h
  # --------------------------------------------------------------------------

  sbia_add_test (${EXEC}HelpS "${EXEC_CMD}" "-h")

  # --------------------------------------------------------------------------
  # test option: --help
  # --------------------------------------------------------------------------

  sbia_add_test (${EXEC}HelpL "${EXEC_CMD}" "--help")

  # --------------------------------------------------------------------------
  # test option: -u
  # --------------------------------------------------------------------------

  sbia_add_test (${EXEC}UsageS "${EXEC_CMD}" "-u")

  set_tests_properties (
    ${EXEC}UsageS
    PROPERTIES
      PASS_REGULAR_EXPRESSION "[Uu]sage:(\n)( )*${EXEC_NAME}"
  )

  # --------------------------------------------------------------------------
  # test option: --usage
  # --------------------------------------------------------------------------

  sbia_add_test (${EXEC}UsageL "${EXEC_CMD}" "--usage")

  set_tests_properties (
    ${EXEC}UsageL
    PROPERTIES
      PASS_REGULAR_EXPRESSION "[Uu]sage:(\n)( )*${EXEC_NAME}"
  )

  if (CMAKE_VERBOSE)
    message (STATUS "Adding tests of default options for '${EXEC}'... - done")
  endif ()
endfunction ()

