##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of C++ utilities.
#
# Copyright (c) 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ----------------------------------------------------------------------------
# template files
basis_install (FILES basis.h.in basis.cxx.in DESTINATION "${INSTALL_TEMPLATES_DIR}")

# ----------------------------------------------------------------------------
# utilities
basis_add_library (
  ${CXX_LIBRARY_TARGET} STATIC
    os.cxx           # operating system dependent functions
    path.cxx         # file/directory path related functions
    subprocess.cxx   # subprocess execution
    stdio.cxx        # standard I/O functions
    CmdLine.cxx      # command-line parsing
    utilities.cxx    # project-independent utility functions
  NO_BASIS_UTILITIES # this *is* the BASIS utilities library
)
basis_set_target_properties (${CXX_LIBRARY_TARGET} PROPERTIES OUTPUT_NAME utilities)

# ----------------------------------------------------------------------------
# unit testing
if (NOT HAVE_TR1_TUPLE)
  basis_add_definitions ("-DGTEST_USE_OWN_TR1_TUPLE=1")
endif ()

basis_add_library (${TEST_LIBRARY_TARGET} STATIC "test.cxx")
basis_set_target_properties (${TEST_LIBRARY_TARGET} PROPERTIES OUTPUT_NAME test)

basis_add_library (${TESTMAIN_LIBRARY_TARGET} STATIC "test_main.cxx")
basis_target_link_libraries (${TESTMAIN_LIBRARY_TARGET} ${TEST_LIBRARY_TARGET})
basis_set_target_properties (${TESTMAIN_LIBRARY_TARGET} PROPERTIES OUTPUT_NAME testmain)
