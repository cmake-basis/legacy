##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of development tools.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ----------------------------------------------------------------------------
# project creation/modification
basis_add_executable (basisproject.py)
basis_target_link_libraries (basisproject pyutilities)

basis_set_target_properties (
  basisproject
  PROPERTIES COMPILE_DEFINITIONS
      "basis_set_script_path (
         TEMPLATE_DIR \"${PROJECT_DATA_DIR}/template\"
                      \"${INSTALL_TEMPLATE_DIR}\"
       )"
)
