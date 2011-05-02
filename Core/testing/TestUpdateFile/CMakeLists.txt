# \file  CMakeLists.txt
# \brief Project CMake file.
#
# This build test tests the automatic file update.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>


# ============================================================================
# CMake version
# ============================================================================

# minimum required CMake version
cmake_minimum_required (VERSION 2.6)

# ============================================================================
# load common modules
# ============================================================================

if (IS_DIRECTORY "$ENV{SBIA_CMAKE_MODULE_PATH}")
  set (CMAKE_MODULE_PATH "$ENV{SBIA_CMAKE_MODULE_PATH}")
endif ()

include (SbiaGlobal)    # modifies CMAKE_MODULE_PATH
include (SbiaMacros)    # definition of command CMake macros
include (SbiaCommands)  # finds commonly used programs such as svn

project (ProjectTemplateTestUpdateFile)

include (${PROJECT_SOURCE_DIR}/Subfolder/Module.cmake)

# ============================================================================
# settings
# ============================================================================

set (PROJECT_TEMPLATE "SbiaProject-1/Testing/TestUpdateFile")

# ============================================================================
# update
# ============================================================================

# The following command exports the current version of this file from the
# corresponding tagged version of the SBIA project template and replaces this
# file in the source tree while preserving the CUSTOMIZE sections.
#
# See documentation of sbia_update () in CMake/SbiaMacros.cmake for details.

sbia_update (CMakeLists.txt)

# ============================================================================
# global settings
# ============================================================================

# Remove the '#' in the following line before running the test such that
# when the test is successful, the German greeting printed during the first
# configure is "Guten Tag!". The second time the build system is configured,
# the German greating will have changed back to "Hallo Welt!" again. 
# printed will be "Hallo Welt!". As
#set (COMMON_GREETING_GERMAN "Guten Tag!")

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom-section>

# Delete this comment before the test. It shall still be removed after the
# automatic update.
#
# This is my custom section. In order to test the automatic file update,
# edit this section, then run CMake with the directory in which this
# CMakeLists.txt resists as source directory and configure. After the
# configure step, the file should be updated while preserving your changes.

# </sbia-custom-section>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# ============================================================================
# subfolders
# ============================================================================

add_subdirectory (subfolder)
