##############################################################################
# @file  ConfigSettings.cmake
# @brief Sets variables used in CMake package configuration.
#
# It is suggested to use @c _CONFIG as suffix for variable names that are to
# be substituted in the Config.cmake.in template file in order to distinguish
# these variables from the build configuration.
#
# @note The default BasisConfigSettings.cmake file which is part of the BASIS
#       installation is included prior to this file. Hence, the variables are
#       valid even if a custom project-specific configuration is used and
#       default values can further be overwritten in this file.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.<br />
# See http://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup BasisSettings
##############################################################################

# ============================================================================
# common settings
# ============================================================================

basis_get_fully_qualified_target_uid (UTILITIES_LIBRARY_CONFIG ${CXX_LIBRARY_TARGET})
basis_get_fully_qualified_target_uid (TEST_LIBRARY_CONFIG      ${TEST_LIBRARY_TARGET})
basis_get_fully_qualified_target_uid (TESTMAIN_LIBRARY_CONFIG  ${TESTMAIN_LIBRARY_TARGET})

# the following set() statements are simply used to document the variables
# note that this documentation is included in the Doxygen generated documentation

## @brief Name of BASIS utilities library for C++.
set (UTILITIES_LIBRARY_CONFIG "${UTILITIES_LIBRARY_CONFIG}")
## @brief Name of C++ unit testing library.
set (TEST_LIBRARY_CONFIG "${TEST_LIBRARY_CONFIG}")
## @brief Name of C++ unit testing library with definition of main() function.
set (TEST_MAIN_LIBRARY_CONFIG "${TEST_MAIN_LIBRARY_CONFIG}")

# ============================================================================
# build tree configuration settings
# ============================================================================

if (BUILD_CONFIG_SETTINGS)
    set (TEMPLATES_DIR_CONFIG "${PROJECT_CODE_DIR}/src")
    return ()
endif ()

# ============================================================================
# installation configuration settings
# ============================================================================

## @brief Directory of installed BASIS utilities template files.
set (TEMPLATES_DIR_CONFIG "\${\${NS}INSTALL_PREFIX}/${INSTALL_TEMPLATES_DIR}")
