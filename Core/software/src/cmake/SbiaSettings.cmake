##############################################################################
# \file  SbiaSettings.cmake
# \brief Default CMake settings used at SBIA.
#
# This file specifies the common CMake settings such as the common build
# configuration used by projects developed at SBIA. Note that this file is
# included in the root CMake file by the macro sbia_project () prior to the
# invocation of the CMake command project (). Thus, project related
# variables are not available at this point.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT SBIA_SETTINGS_INCLUDED)
set (SBIA_SETTINGS_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# build tree
# ============================================================================

set (
  CMAKE_ARCHIVE_OUTPUT_DIRECTORY
    "lib"
  CACHE PATH
    "Output directory for static and import libraries (relative to build tree)."
)


set (
  CMAKE_LIBRARY_OUTPUT_DIRECTORY
    "bin"
  CACHE PATH
    "Output directory for modules and shared libraries (relative to build tree)."
)

set (
  CMAKE_RUNTIME_OUTPUT_DIRECTORY
    "bin"
  CACHE PATH
    "Output directory for runtime libraries (relative to build tree)."
)

# make relative paths absolute and make options advanced
foreach(P ARCHIVE LIBRARY RUNTIME)
  set(VAR CMAKE_${P}_OUTPUT_DIRECTORY)
  if (NOT IS_ABSOLUTE "${${VAR}}")
    set (${VAR} "${CMAKE_BINARY_DIR}/${${VAR}}")
  endif ()
  mark_as_advanced (${VAR})
endforeach()

# set obsolete variables
#set (EXECUTABLE_OUTPUT_PATH "${RUNTIME_OUTPUT_DIRECTORY}")
#set (LIBRARY_OUTPUT_PATH    "${ARCHIVE_OUTPUT_DIRECTORY}")

# ============================================================================
# install tree
# ============================================================================

set (
  INSTALL_DIR
    "."
  CACHE PATH
    "Installation directory for README, LICENSE,... (relative to CMAKE_INSTALL_PREFIX)."
)

set (
  INSTALL_BIN_DIR
    "bin"
  CACHE PATH
    "Installation directory for executables (relative to CMAKE_INSTALL_PREFIX)."
)

set (
  INSTALL_DATA_DIR
    "data"
  CACHE PATH
    "Installation directory for auxiliary data (relative to CMAKE_INSTALL_PREFIX)."
)

set (
  INSTALL_DOC_DIR
    "doc"
  CACHE PATH
    "Installation directory for documentation (relative to CMAKE_INSTALL_PREFIX)."
)

set (
  INSTALL_EXAMPLE_DIR
    "example"
  CACHE PATH
    "Installation directory for example (relative to CMAKE_INSTALL_PREFIX)."
)

set (
  INSTALL_INCLUDE_DIR
    "include/sbia"
  CACHE PATH
    "Installation directory for header files (relative to CMAKE_INSTALL_PREFIX)."
)

set (
  INSTALL_LIB_DIR
    "lib"
  CACHE PATH
    "Installation directory for libraries (relative to CMAKE_INSTALL_PREFIX)."
)

# make absolute paths relative and make options advanced
if (IS_ABSOLUTE "${INSTALL_DIR}")
  file (RELATIVE_PATH INSTALL_DIR "${CMAKE_INSTALL_PREFIX}" "${INSTALL_DIR}")
endif ()
mark_as_advanced (INSTALL_DIR)

foreach(P BIN DATA DOC EXAMPLE INCLUDE LIB)
  set(VAR INSTALL_${P}_DIR)
  if (IS_ABSOLUTE "${${VAR}}")
    file (RELATIVE_PATH "${VAR}" "${CMAKE_INSTALL_PREFIX}" "${${VAR}}")
  endif ()
  mark_as_advanced ("${VAR}")
endforeach()

# ============================================================================
# build configuration(s)
# ============================================================================

# list of all available build configurations
set (
  CMAKE_CONFIGURATION_TYPES
    "Debug"
    "Coverage"
    "Release"
  CACHE STRING "Build configurations." FORCE
)

# list of debug configurations, used by target_link_libraries (), for example,
# to determine whether to link to the optimized or debug libraries
set (DEBUG_CONFIGURATIONS "Debug")

mark_as_advanced (CMAKE_CONFIGURATION_TYPES)
mark_as_advanced (DEBUG_CONFIGURATIONS)

if (NOT CMAKE_BUILD_TYPE MATCHES "^Debug$|^Coverage$|^Release$")
  set (CMAKE_BUILD_TYPE "Release")
endif ()

set (
  CMAKE_BUILD_TYPE
    "${CMAKE_BUILD_TYPE}"
  CACHE STRING
    "Current build configuration. Specify either \"Debug\", \"Coverage\", or \"Release\"."
  FORCE
)

# default script configuration file \see sbia_add_script ()
set (SBIA_SCRIPT_CONFIG_FILE "${CMAKE_CURRENT_LIST_DIR}/SbiaScriptConfig.cmake.in")

# ----------------------------------------------------------------------------
# common
# ----------------------------------------------------------------------------

# common compiler flags
set (CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

# common linker flags
set (CMAKE_EXE_LINKER_FLAGS    "${CMAKE_EXE_LINKER_FLAGS}    -lm")
set (CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -lm")
set (CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -lm")

# ----------------------------------------------------------------------------
# MinSizeRel - disabled
# ----------------------------------------------------------------------------

# compiler flags of MinSizeRel configuration
set (CMAKE_C_FLAGS_MINSIZEREL   "" CACHE INTERNAL "" FORCE)
set (CMAKE_CXX_FLAGS_MINSIZEREL "" CACHE INTERNAL "" FORCE)

# linker flags of MinSizeRel configuration
set (CMAKE_EXE_LINKER_FLAGS_MINSIZEREL    "" CACHE INTERNAL "" FORCE)
set (CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL "" CACHE INTERNAL "" FORCE)
set (CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "" CACHE INTERNAL "" FORCE)

# ----------------------------------------------------------------------------
# RelWithDebInfo - disabled
# ----------------------------------------------------------------------------

# compiler flags of RelWithDebInfo configuration
set (CMAKE_C_FLAGS_RELWITHDEBINFO   "" CACHE INTERNAL "" FORCE)
set (CMAKE_CXX_FLAGS_RELWITHDEBINFO "" CACHE INTERNAL "" FORCE)

# linker flags of RelWithDebInfo configuration
set (CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO    "" CACHE INTERNAL "" FORCE)
set (CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO "" CACHE INTERNAL "" FORCE)
set (CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "" CACHE INTERNAL "" FORCE)

# ----------------------------------------------------------------------------
# Coverage
# ----------------------------------------------------------------------------

# compiler flags for Coverage configuration
set (CMAKE_C_FLAGS_COVERAGE   "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
set (CMAKE_CXX_FLAGS_COVERAGE "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage")

# linker flags for Coverage configuration
set (CMAKE_EXE_LINKER_FLAGS_COVERAGE    "-fprofile-arcs -ftest-coverage")
set (CMAKE_MODULE_LINKER_FLAGS_COVERAGE "-fprofile-arcs -ftest-coverage")
set (CMAKE_SHARED_LINKER_FLAGS_COVERAGE "-fprofile-arcs -ftest-coverage")


endif (NOT SBIA_SETTINGS_INCLUDED)

