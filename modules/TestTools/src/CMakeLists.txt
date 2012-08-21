##############################################################################
# @file  CMakeLists.txt
# @brief Build configuration of testing tools.
#
# Copyright (c) 2011, 2012 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ----------------------------------------------------------------------------
# testdriver
basis_add_executable (testdriver.cxx LIBEXEC)
if (WIN32)
  basis_target_link_libraries (testdriver Ws2_32)
endif ()

if (ITK_FOUND)
  basis_set_target_properties (
    testdriver
    PROPERTIES
      COMPILE_DEFINITIONS
        "ITK_VERSION=\"${ITK_VERSION_MAJOR}.${ITK_VERSION_MINOR}.${ITK_VERSION_PATCH}\""
        "ITK_VERSION_MAJOR=${ITK_VERSION_MAJOR}"
  )
  basis_target_link_libraries (testdriver ${ITK_LIBRARIES})
endif ()

# ----------------------------------------------------------------------------
# automated testing
basis_add_script (basistest.ctest)

if (BASH_FOUND AND BashUtilities_FOUND)
  basis_add_executable (basistest-svn.sh    LIBEXEC) # wraps svn command
  basis_add_executable (basistest-slave.sh  LIBEXEC) # executes test task
  basis_add_executable (basistest-master.sh LIBEXEC) # executes scheduled tests
  basis_add_executable (basistest-cron.sh   LIBEXEC) # test cron job
  basis_add_executable (basistest.sh)                # main wrapper

  basis_set_target_properties (
    basistest-slave
    PROPERTIES COMPILE_DEFINITIONS
      "basis_set_script_path (
         BASISTEST_CTEST_SCRIPT \"@BINARY_LIBEXEC_DIR@/basistest.ctest\"
                                \"@INSTALL_MODULES_DIR@/basistest.ctest\"
       )"
  )

  basis_set_target_properties (
    basistest-cron
    PROPERTIES COMPILE_DEFINITIONS
      "basis_set_script_path (
         BASISTEST_CTEST_SCRIPT \"@BINARY_LIBEXEC_DIR@/basistest.ctest\"
                                \"@INSTALL_MODULES_DIR@/basistest.ctest\"
       )"
  )
endif ()
