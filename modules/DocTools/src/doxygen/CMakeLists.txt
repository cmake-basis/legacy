##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of Doxygen filters.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

basis_add_library (doxyfilterlib "DoxyFilter.pm" "DoxyFilter/**.pm")
basis_library_prefix (PREFIX PERL)
basis_set_target_properties (
  doxyfilterlib
  PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY  "${BINARY_PERL_LIBRARY_DIR}"
    LIBRARY_INSTALL_DIRECTORY "${INSTALL_PERL_LIBRARY_DIR}"
    PREFIX                    "${PREFIX}"
)

basis_add_executable (doxyfilter.pl LIBEXEC)
basis_target_link_libraries (doxyfilter doxyfilterlib)
