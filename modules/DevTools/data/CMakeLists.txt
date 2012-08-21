##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of auxiliary data files.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ============================================================================
# settings
# ============================================================================

# Note: The following variables must be cached such that it they are available
#       in the code directory when the basisproject script is configured.

# This version number has to be changed whenever a new (modified) project
# template was added. A patch version number is not used here because subtle
# changes of the template files do not need to be tracked. This version number
# may only become of importance in case the project template is noticably
# extended or modified, which has to be done with care, however, in any case
# and should be avoided.
#
# Attention: Whenever a template file is modified or removed,
#            the previous project template has to be copied to a new
#            directory with an updated template version! Otherwise, the
#            three-way diff merge used by the basisproject tool to update
#            existing projects to this newer template will fail.
set (
  CURRENT_TEMPLATE_VERSION 1.5
  CACHE INTERNAL "Version of current project template." FORCE
)

# installation directory of project template files
set (
  INSTALL_TEMPLATE_DIR "${INSTALL_SHARE_DIR}/template"
  CACHE INTERNAL "Installation prefix for project templates." FORCE
)

# option to enable/disable installation of deprecated project template files
set (OPTDOC "Request installation of deprecated project templates."
            " Required by basisproject to upgrade a project which was"
            " instantiated from an older template.")
basis_list_to_string (OPTDOC ${OPTDOC})
option (INSTALL_DEPRECATED_TEMPLATES "${OPTDOC}" OFF)
mark_as_advanced (INSTALL_DEPRECATED_TEMPLATES)
unset (OPTDOC)

# ============================================================================
# installation
# ============================================================================

# ----------------------------------------------------------------------------
macro (basis_install_template VERSION)
  if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/template-${VERSION}")
    install (
      DIRECTORY   "${CMAKE_CURRENT_SOURCE_DIR}/template-${VERSION}/"
      DESTINATION "${INSTALL_TEMPLATE_DIR}-${VERSION}"
      PATTERN     *~             EXCLUDE
      PATTERN     .svn           EXCLUDE
      PATTERN     .git           EXCLUDE
      PATTERN     .DS_Store      EXCLUDE
    )
  endif ()
endmacro ()

# ----------------------------------------------------------------------------
if (INSTALL_DEPRECATED_TEMPLATES)
  basis_version_numbers (CURRENT_TEMPLATE_VERSION CURRENT_MAJOR CURRENT_MINOR DUMMY)
  if (CURRENT_MAJOR LESS 1)
    message (FATAL_ERROR "Invalid CURRENT_TEMPLATE_VERSION in DevTools/data/CMakeLists.txt!")
  endif ()
  set (MAJOR 1)
  while (NOT MAJOR GREATER CURRENT_MAJOR)
    set (MINOR 0)
    while (MINOR LESS CURRENT_MINOR)
      basis_install_template (${MAJOR}.${MINOR})
      math (EXPR MINOR "${MINOR} + 1")
    endwhile ()
    math (EXPR MAJOR "${MAJOR} + 1")
  endwhile ()
endif ()
basis_install_template (${CURRENT_TEMPLATE_VERSION})
