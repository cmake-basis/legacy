##############################################################################
# \file  CMakeLists.txt
# \brief CMake file used to update CMake modules.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# update
# ============================================================================

# See documentation of module SbiaUpdate for details.

sbia_update (CMakeLists.txt)

sbia_update (SbiaCommands.cmake)
sbia_update (SbiaGlobal.cmake)
sbia_update (SbiaMacros.cmake)
sbia_update (SbiaPackage.cmake)
sbia_update (SbiaSettings.cmake)
sbia_update (SbiaTesting.cmake)
sbia_update (SbiaUpdate.cmake)
sbia_update (SbiaUpdateFile.py)

# Any find module used by the project and which is part of the template, which
# means that the CMake find module file is located in the current source
# directory, can be updated by adding a line such as
#
# sbia_update (FindPackage.cmake)
#
# to the following customizable section. When the project is first instantiated
# each module which is part of the template at this time should be listed
# here. When new find modules are added to an existing template, projects
# which were instantiated before are not affected as the update invocation
# for the new module will not take effect for existing projects. Both, the
# find module and the update call need to be copied and configured manually if
# required.

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# <sbia-custom>

sbia_update (FindNiftiCLib.cmake)

# </sbia-custom>
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
