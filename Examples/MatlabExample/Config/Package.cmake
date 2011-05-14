##############################################################################
# \file  Package.cmake
# \brief Contains project specific CPack packaging information.
#
# This file is included by the module SbiaPackage.cmake before the CPack
# package is included. It can be used to overwrite the default CPack
# settings set in SbiaPackage.cmake.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# package information / general settings
# ============================================================================

# Overwrite default package information set in SbiaPackage.cmake here.
#
# \see http://www.vtk.org/Wiki/CMake:Packaging_With_CPack

# ============================================================================
# source package
# ============================================================================

# Pattern of files in the source tree that will not be packaged when building
# a source package. This is a list of patterns, e.g., "/CVS/", "/\\.svn/",
# ".swp$", ".#", "/#", "*~", and "cscope*", which are ignored by default.

set (
  CPACK_SOURCE_IGNORE_FILES
    "${CPACK_SOURCE_IGNORE_FILES}" # default ignore patterns
	# add further ignore patterns here
)
