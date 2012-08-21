##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of Python utilities.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

basis_install (FILES __init__.py.in basis.py.in DESTINATION "${INSTALL_PYTHON_TEMPLATES_DIR}")
