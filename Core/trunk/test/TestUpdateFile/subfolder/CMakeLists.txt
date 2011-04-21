# \file  CMakeLists.txt
# \brief Some CMake file in subfolder.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>

# ============================================================================
# update
# ============================================================================

# The following command exports the current version of this file from the
# corresponding tagged version of the SBIA project template and replaces this
# file in the source tree while preserving the CUSTOMIZE sections.
#
# See documentation of sbia_update () in CMake/SbiaMacros.cmake for details.

sbia_update (CMakeLists.txt)
sbia_update (Module.cmake)

# ============================================================================
# do something...
# ============================================================================

# Before the test, comment the next line. After the first configure, this
# message should not be printed, but the CMakeLists.txt file was replaced.
# When configuring again, this message is printed again...
message (STATUS "Common greetings in German and Spanish are:")

# Leave this line unchanged.
message (STATUS ${COMMON_GREETING_GERMAN})

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

# Remove the '#' from the following line before "configuring" the test an
# see if the greating will be displayed correctly.
#message (STATUS ${COMMON_GREETING_SPANISH})

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
