##############################################################################
# \file  SbiaGlobals.cmake
# \brief Definition of global CMake constants and variables.
#
# This CMake module defines global CMake constants (variables whose value must
# not be modified), and global CMake variables used across SBIA CMake
# functions and macros.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT SBIA_GLOBALS_INCLUDED)
set (SBIA_GLOBALS_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# options
# ============================================================================

option (CMAKE_VERBOSE "Verbose mode" "OFF")

mark_as_advanced (CMAKE_VERBOSE)

# ============================================================================
# constants
# ============================================================================

# List of names used for special purpose targets.
set (SBIA_RESERVED_TARGET_NAMES "uninstall" "doc" "changelog" "execname")

# Default component used when no component is specified.
set (SBIA_DEFAULT_COMPONENT "Runtime")

# Character used to separated namespace and target name to build target UID.
set (SBIA_NAMESPACE_SEPARATOR "@")

# Character used to separated version and project name (e.g., in target UID).
set (SBIA_VERSION_SEPARATOR "#")

# Prefix used for SBIA package CMake Config files.
set (SBIA_CONFIG_PREFIX "SBIA_")

# Script used to execute a process in CMake script mode.
set (SBIA_SCRIPT_EXECUTE_PROCESS "${CMAKE_CURRENT_LIST_DIR}/SbiaExecuteProcess.cmake")

# ============================================================================
# cached variables
# ============================================================================

# The following variables are used across SBIA macros and functions. They
# in particular remember information added by one function or macro and is
# required by another function or macro.
#
# \note These variables are reset whenever this module is included the first
#       time. The guard directive at the beginning of this file protects
#       these variables to be overwritten each time this module is included.

# Caches all directories given as argument to sbia_include_directories ().
set (SBIA_CACHED_INCLUDE_DIRECTORIES_DOC "All include directories.")
set (SBIA_CACHED_INCLUDE_DIRECTORIES "" CACHE INTERNAL "${SBIA_CACHED_INCLUDE_DIRECTORIES_DOC}" FORCE)

# Caches the global names (UIDs) of all SBIA project targets.
set (SBIA_TARGETS_DOC "Names of all targets.")
set (SBIA_TARGETS "" CACHE INTERNAL "${SBIA_TARGETS_DOC}" FORCE)


endif (NOT SBIA_GLOBALS_INCLUDED)

