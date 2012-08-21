##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of tests for Bash utilities.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ----------------------------------------------------------------------------
# project independent utilities
basis_add_test (test_core.sh        UNITTEST)
basis_add_test (test_shutilities.sh UNITTEST)
basis_add_test (test_shtap.sh       UNITTEST)

# ----------------------------------------------------------------------------
# project-specific utilities
basis_add_test (test_basis_sh test_basis.py LINK_DEPENDS testaux)
basis_set_tests_properties (test_basis_sh PROPERTIES TIMEOUT 1500)
