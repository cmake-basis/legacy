##############################################################################
# @file  BasisProject.cmake
# @brief Meta-data of this BASIS project.
#
# Copyright (c) 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup BasisSettings
##############################################################################

# Note: The #<*dependency> patterns are required by the basisproject tool
#       and should be kept on a separate line as last commented argument of
#       the corresponding options of the basis_project() command.

basis_project (
  # --------------------------------------------------------------------------
  # meta-data
  NAME        BashUtilities
  DESCRIPTION "BASIS Utilities for Bash."
  # --------------------------------------------------------------------------
  # dependencies
  DEPENDS
    BASH
    #<dependency>
  OPTIONAL_DEPENDS
    #<optional-dependency>
  TEST_DEPENDS
    PythonInterp
    #<test-dependency>
  OPTIONAL_TEST_DEPENDS
    #<optional-test-dependency>
)
