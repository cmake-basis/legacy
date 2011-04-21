##############################################################################
# \file  FindMatlabNiftiTools.cmake
# \brief Find MATLAB Central package "Tools for NIfTI and ANALYZE Image" (#8797).
#
# Input variables:
#
#   MatlabNiftiTools_DIR     The MATLAB Central package files are searched
#                            under the specified root directory. If they are
#                            not found there, the default search paths are
#                            considered. This variable can also be set as
#                            environment variable.
#   MATLABNIFTITOOLS_DIR     Alternative environment variable for MatlabNiftiTools_DIR.
#
# Sets the following CMake variables:
#
#   MatlabNiftiTools_FOUND        Whether the package was found and the
#                                 following CMake variables are valid.
#   MatlabNiftiTools_INCLUDE_DIR  Cached include directory/ies only related to
#                                 the searched package.
#   MatlabNiftiTools_INCLUDE_DIRS Include directory/ies of searched and
#                                 dependent packages (not cached).
#   MatlabNiftiTools_INCLUDES     Alias for MatlabNiftiTools_INCLUDE_DIRS (not cached).
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# find paths / files
# ============================================================================

# ----------------------------------------------------------------------------
# 1. Look in user-specified package root
# ----------------------------------------------------------------------------

find_path (
  MatlabNiftiTools_INCLUDE_DIR
    NAMES         load_nii.m
    HINTS         ${MatlabNiftiTools_DIR}
                  ENV MatlabNiftiTools_DIR
                  ENV MATLABNIFTITOOLS_DIR
    DOC           "Path of directory containing load_nii.m"
    NO_DEFAULT_PATH
)

# ----------------------------------------------------------------------------
# 2. Search default paths
# ----------------------------------------------------------------------------

find_path (
  MatlabNiftiTools_INCLUDE_DIR
    NAMES load_nii.m
    HINTS ENV MATLABPATH
    DOC   "Path of directory containing load_nii.m"
)

# ============================================================================
# append paths / libraries of packages this package depends on
# ============================================================================

if (MatlabNiftiTools_INCLUDE_DIR)
  set (MatlabNiftiTools_INCLUDE_DIRS "${MatlabNiftiTools_INCLUDE_DIR}")
  set (MatlabNiftiTools_INCLUDES     "${MatlabNiftiTools_INCLUDE_DIRS}")
endif ()

# ============================================================================
# found ?
# ============================================================================

# handle the QUIETLY and REQUIRED arguments and set *_FOUND to TRUE
# if all listed variables are found or TRUE

include (FindPackageHandleStandardArgs)

find_package_handle_standard_args (
  MatlabNiftiTools
# MESSAGE
    DEFAULT_MSG
# VARIABLES
    MatlabNiftiTools_INCLUDE_DIR
)
