##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of Perl utilities.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# Note: The modules in the lib/ directory are build by the perllib target
#       which is automatically added by BASIS.

basis_install (FILES Basis.pm.in DESTINATION "${INSTALL_PERL_TEMPLATES_DIR}")
