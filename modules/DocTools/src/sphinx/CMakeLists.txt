##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of Sphinx extensions and themes.
#
# Copyright (c) 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

basis_install_directory (themes "${INSTALL_SPHINX_THEMES_DIR}")

add_subdirectory (extensions)
