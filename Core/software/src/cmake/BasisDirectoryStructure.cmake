##############################################################################
# \file  BasisDirectoryStructure.cmake
# \brief Defines the directory structure of BASIS projects.
#
# This CMake module defines the variables as specified in the design document
# DirectoryStructure, which is part of the documentation of the BASIS Core.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT BASIS_DIRECTORYSTRUCTURE_INCLUDED)
set (BASIS_DIRECTORYSTRUCTURE_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# source tree
# ============================================================================

# \note The following directory names have to match the names used in the
#       project template in 'src/template'.

set (PROJECT_SOFTWARE_DIR "software")
set (PROJECT_EXAMPLE_DIR  "example")
set (PROJECT_TESTING_DIR  "testing")

set (SOFTWARE_CONFIG_DIR  "config")
set (SOFTWARE_SOURCE_DIR  "src")
set (SOFTWARE_DATA_DIR    "data")
set (SOFTWARE_DOC_DIR     "doc")
set (SOFTWARE_TESTS_DIR   "tests")

set (TESTING_DATA_DIR     "data")
set (TESTING_EXPECTED_DIR "expected")
set (TESTING_TESTS_DIR    "tests")

# ============================================================================
# build tree
# ============================================================================

set (
  CMAKE_RUNTIME_OUTPUT_DIRECTORY
    "bin"
  CACHE PATH
    "Output directory for runtime libraries (relative to build tree)."
)

set (
  CMAKE_LIBRARY_OUTPUT_DIRECTORY
    "bin"
  CACHE PATH
    "Output directory for modules and shared libraries (relative to build tree)."
)

set (
  CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    "lib"
  CACHE PATH
    "Output directory for static and import libraries (relative to build tree)."
)

# make relative paths absolute and make options advanced
foreach(P RUNTIME LIBRARY ARCHIVE)
  set(VAR CMAKE_${P}_OUTPUT_DIRECTORY)
  if (NOT IS_ABSOLUTE "${${VAR}}")
    set (${VAR} "${CMAKE_BINARY_DIR}/${${VAR}}")
  endif ()
  mark_as_advanced (${VAR})
endforeach()

# ============================================================================
# install tree
# ============================================================================

# \note In order for CPack to work correctly, the destination paths have to
#       be given relative (to CMAKE_INSTALL_PREFIX). Therefore, the
#       INSTALL_PREFIX prefix is excluded from the following paths.
#       Instead, CMAKE_INSTALL_PREFIX is set to INSTALL_PREFIX.
#       This has to be done after the project attributes are known, i.e.,
#       within the macro basis_project () which also configures the
#       following variables.

if (WIN32)
  set (
    INSTALL_PREFIX "C:\\Program Files\\SBIA\\\${PROJECT_NAME}"
    CACHE PATH "Installation directory prefix."
  )

  set (
    INSTALL_SINFIX ""
    CACHE PATH "Installation directories suffix or infix, respectively."
  )
else ()
  set (
    INSTALL_PREFIX "/usr/local"
    CACHE PATH "Installation directories prefix."
  )

  set (
    INSTALL_SINFIX "sbia/\${PROJECT_NAME_LOWER}"
    CACHE PATH "Installation directories suffix or infix, respectively."
  )
endif ()

set (INSTALL_BIN_DIR     "bin/${INSTALL_SINFIX}")
set (INSTALL_LIB_DIR     "lib/${INSTALL_SINFIX}")
set (INSTALL_INCLUDE_DIR "include/${INSTALL_SINFIX}/sbia/\${PROJECT_NAME_LOWER}")
set (INSTALL_DOC_DIR     "share/${INSTALL_SINFIX}/doc")
set (INSTALL_DATA_DIR    "share/${INSTALL_SINFIX}/data")
set (INSTALL_EXAMPLE_DIR "share/${INSTALL_SINFIX}/example")
set (INSTALL_MAN_DIR     "share/${INSTALL_SINFIX}/man")


endif (NOT BASIS_DIRECTORYSTRUCTURE_INCLUDED)

