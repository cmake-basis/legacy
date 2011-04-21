##############################################################################
# \file  CMakeLists.txt
# \brief CMakeLists file of Config folder.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# update
# ============================================================================

# See documentation of the module SbiaUpdate for details.

# If you experience problems with the automatic file update, contact the
# maintainer of the template project or sbia-software@uphs.upenn.edu and
# consider to disable the automatic file update for single files by adding
# their path relative to the project's source directory to
# SBIA_UPDATE_EXCLUDE in the module Settings.cmake in the top directory of
# the project's source tree.

sbia_update (CMakeLists.txt)

# Add "Config.cmake.in" and/or "Config.h.in" to SBIA_UPDATE_EXCLUDE in
# Settings.cmake if this/these file/s shall not be considered for update by
# the automatic file update mechanism.

sbia_update (Config.h.in)
sbia_update (Config.cmake.in)

# ============================================================================
# subdirectories
# ============================================================================

if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/Modules")
  add_subdirectory (Modules) # update CMake modules
endif ()
