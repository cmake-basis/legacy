##############################################################################
# \file  CMakeLists.txt
# \brief CMake file to configure build system of example.
#
# By default, all content of the example folder is simply installed in the
# example subdirectory of the installation tree.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

install (
  DIRECTORY   ${CMAKE_CURRENT_SOURCE_DIR}/
  DESTINATION "${INSTALL_EXAMPLE_DIR}"
  PATTERN     CMakeLists.txt EXCLUDE
  PATTERN     *~             EXCLUDE
  PATTERN     .svn           EXCLUDE
  PATTERN     .git           EXCLUDE
)

