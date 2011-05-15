##############################################################################
# \file  CMakeLists.txt
# \brief CMakeLists file to configure build system of all targets.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# common sources
# ============================================================================

set (
  TRON_SOURCES
    tron.h
    tron.cpp
)

set (
  LINEAR_SOURCES
    linear.h
    linear.cpp
    linear_model_matlab.h
    linear_model_matlab.c
)

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

# ----------------------------------------------------------------------------
# target: train
# ----------------------------------------------------------------------------

sbia_add_library (
  train MEX
    train.c
    ${TRON_SOURCES}
    ${LINEAR_SOURCES}
    ${SBIA_TEMPLATE_SOURCES}
    ${SBIA_DEFAULT_SOURCES}
)

target_link_libraries (train BLAS)

# ----------------------------------------------------------------------------
# target: predict
# ----------------------------------------------------------------------------

sbia_add_library (
  predict MEX
    predict.c
    ${TRON_SOURCES}
    ${LINEAR_SOURCES}
    ${SBIA_TEMPLATE_SOURCES}
    ${SBIA_DEFAULT_SOURCES}
)

target_link_libraries (predict BLAS)

# ----------------------------------------------------------------------------
# target: libsvmread
# ----------------------------------------------------------------------------

sbia_add_library (
  libsvmread MEX
    libsvmread.c
    ${SBIA_TEMPLATE_SOURCES}
    ${SBIA_DEFAULT_SOURCES}
)

# ----------------------------------------------------------------------------
# target: libsvmwrite
# ----------------------------------------------------------------------------

sbia_add_library (
  libsvmwrite MEX
    libsvmwrite.c
    ${SBIA_TEMPLATE_SOURCES}
    ${SBIA_DEFAULT_SOURCES}
)

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

# ----------------------------------------------------------------------------
# target: Example1
# ----------------------------------------------------------------------------

sbia_add_executable (Example1 Example1.m func.m)

# ----------------------------------------------------------------------------
# target: Example2
# ----------------------------------------------------------------------------

sbia_add_executable (
  Example2
    Example2.m
    func.m
    # link libraries (e.g., MEX-file or MEX-file target)
    libsvmread
    train
    predict
)

# specifying the link libraries such as MEX-files for a MATLAB executable
# target via target_link_libraries () does not yet entirely work;
# the build executables will not be rebuild when the link libraries changed
#target_link_libraries (Example4 train predict)

# copy/install additional data file
add_custom_command (
  TARGET  Example2 POST_BUILD
  COMMAND "${CMAKE_COMMAND}"
  ARGS    -E copy "${CMAKE_CURRENT_SOURCE_DIR}/heart_scale" "${RUNTIME_OUTPUT_DIRECTORY}/heart_scale"
  COMMENT "Copying heart_scale file to build tree..."
)

install (
  FILES       heart_scale
  DESTINATION "${INSTALL_BIN_DIR}"
  COMPONENT   "${SBIA_DEFAULT_COMPONENT}"
)

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
