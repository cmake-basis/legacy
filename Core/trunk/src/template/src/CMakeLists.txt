##############################################################################
# \file  CMakeLists.txt
# \brief CMakeLists file to configure build system of all targets.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

# ============================================================================
# library target(s)
# ============================================================================

# Add library target for each static or shared library (including MEX-files)
# using the macro sbia_add_library (). Note that the maco sbia_add_library ()
# is used the same way as the CMake command add_library ().
#
# See documentation of sbia_add_executable in SbiaMacros.cmake for details.
#
# \see sbia_add_library ()
# \see http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:add_library



# ============================================================================
# executable target(s)
# ============================================================================

# Add executable target for each executable program using the macro
# sbia_add_executable () which is used just the same way as the CMake command
# add_executable () is used.
#
# The source_group () command can be used to group source files within IDEs
# such as the Microsoft Visual Studio IDE, in particular.
#
# See documentation of sbia_add_executable in SbiaMacros.cmake for details.
#
# \see sbia_add_executable ()
# \see http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:add_executable
# \see http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:source_group



# ============================================================================
# scripts
# ============================================================================

# Use the macro sbia_add_script () to add scripts to the project.
#
# For convenience, the functions sbia_add_scripts_by_extension () and
# sbia_add_scripts_by_extensions () add all scripts within the current
# source directory with the given extension(s). The filenames of the scripts
# may contain an optional ".in" suffix or ".in." as any part of the name.
#
# Moreover, sbia_add_scripts () adds all scripts of common scripting languages
# given that the usual filename extensions are used. Hence, in most cases,
# the calling sbia_add_scripts () is sufficient.
#
# See documentation of these macros in SbiaMacros.cmake for details.
#
# \see sbia_add_script
# \see sbia_add_scripts_by_extension
# \see sbia_add_scripts_by_extensions
# \see sbia_add_scripts

sbia_add_scripts ()
