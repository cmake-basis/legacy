##############################################################################
# @file  FindMatlabNiftiTools.cmake
# @brief Find MATLAB Central package "Tools for NIfTI and ANALYZE Image" (#8797).
#
# @par Input variables:
# <table border="0">
#   <tr>
#     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#         @b MatlabNiftiTools_DIR</td>
#     <td>The MATLAB Central package files are searched under the specified
#         root directory. If they are not found there, the default search
#         paths are considered. This variable can also be set as
#         environment variable.</td>
#   </tr>
#   <tr>
#     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#         @b MATLABNIFTITOOLS_DIR</td>
#     <td>Alternative environment variable for @p MatlabNiftiTools_DIR.</td>
#   </tr>
# </table>
#
# @par Output variables:
# <table border="0">
#   <tr>
#     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#         @b MatlabNiftiTools_FOUND</td>
#     <td>Whether the package was found and the following CMake variables are valid.</td>
#   </tr>
#   <tr>
#     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#         @b MatlabNiftiTools_INCLUDE_DIR</td>
#     <td>Cached include directory/ies only related to the searched package.</td>
#   </tr>
#   <tr>
#     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#         @b MatlabNiftiTools_INCLUDE_DIRS</td>
#     <td>Include directory/ies of searched and dependent packages (not cached).</td>
#   </tr>
#   <tr>
#     <td style="white-space:nowrap; vertical-align:top; padding-right:1em">
#         @b MatlabNiftiTools_INCLUDES</td>
#      <td>Alias for MatlabNiftiTools_INCLUDE_DIRS (not cached).</td>
#   </tr>
# </table>
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See https://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup CMakeFindModules
##############################################################################

# ----------------------------------------------------------------------------
# initialize search
if (NOT MatlabNiftiTools_DIR)
  if (NOT $ENV{MATLABNIFTITOOLS_DIR} STREQUAL "")
    set (MatlabNiftiTools_DIR "$ENV{MATLABNIFTITOOLS_DIR}"  CACHE PATH "Installation prefix for MATLAB NIfTI tools." FORCE)
  else ()
    set (MatlabNiftiTools_DIR "$ENV{MatlabNiftiTools_DIR}" CACHE PATH "Installation prefix for MATLAB NIfTI tools." FORCE)
  endif ()
endif ()

# ----------------------------------------------------------------------------
# find paths / files
if (MatlabNiftiTools_DIR)

  find_path (
    MatlabNiftiTools_INCLUDE_DIR
      NAMES load_nii.m
      HINTS ${MatlabNiftiTools_DIR}
      DOC   "Path of directory containing load_nii.m"
      NO_DEFAULT_PATH
  )

else ()

  find_path (
    MatlabNiftiTools_INCLUDE_DIR
    NAMES load_nii.m
    HINTS ENV MATLABPATH
    DOC   "Path of directory containing load_nii.m"
  )

endif ()

# ----------------------------------------------------------------------------
# append paths / libraries of packages this package depends on
if (MatlabNiftiTools_INCLUDE_DIR)
  set (MatlabNiftiTools_INCLUDE_DIRS "${MatlabNiftiTools_INCLUDE_DIR}")
  set (MatlabNiftiTools_INCLUDES     "${MatlabNiftiTools_INCLUDE_DIRS}")
endif ()

# ----------------------------------------------------------------------------
# handle the QUIETLY and REQUIRED arguments and set *_FOUND to TRUE
# if all listed variables are found or TRUE
include (FindPackageHandleStandardArgs)

find_package_handle_standard_args (
  MatlabNiftiTools
  REQUIRED_ARGS
    MatlabNiftiTools_INCLUDE_DIR
)

set (MatlabNiftiTools_FOUND "${MATLABNIFTITOOLS_FOUND}")

# ----------------------------------------------------------------------------
# set MatlabNiftiTools_DIR
if (NOT MatlabNiftiTools_DIR AND MatlabNiftiTools_FOUND)
  set (MatlabNiftiTools_DIR "${MatlabNiftiTools_INCLUDE_DIR}" CACHE PATH "Installation prefix for MATLAB NIfTI tools." FORCE)
endif ()
