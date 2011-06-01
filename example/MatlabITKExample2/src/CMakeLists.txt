#############################################################################
# \file  CMakeLists.txt
# \brief CMakeLists file to configure build system of all targets.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

# ============================================================================
# subdirectoreis
# ============================================================================

add_subdirectory (BLAS)

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

set (
  PIPELINE_SOURCES
    MainPipeline.h
    MainPipeline.cpp
    SliceCountPipeline.h
    SliceCountPipeline.cpp
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

basis_add_library (
  train MEX
    train.c
    ${TRON_SOURCES}
    ${LINEAR_SOURCES}
    ${DEFAULT_SOURCES}
)

basis_target_link_libraries (train BLAS)

# ----------------------------------------------------------------------------
# target: predict
# ----------------------------------------------------------------------------

basis_add_library (
  predict MEX
    predict.c
    ${TRON_SOURCES}
    ${LINEAR_SOURCES}
    ${DEFAULT_SOURCES}
)

basis_target_link_libraries (predict BLAS)

# ----------------------------------------------------------------------------
# target: libsvmread
# ----------------------------------------------------------------------------

basis_add_library (
  libsvmread MEX
    libsvmread.c
    ${DEFAULT_SOURCES}
)

# ----------------------------------------------------------------------------
# target: libsvmwrite
# ----------------------------------------------------------------------------

basis_add_library (
  libsvmwrite MEX
    libsvmwrite.c
    ${DEFAULT_SOURCES}
)

#--------------------------------------------------------------
# target: main_gateway
#--------------------------------------------------------------
basis_add_library (
  main_gateway MEX
  main_gateway.cpp
  ${PIPELINE_SOURCES}
  ${DEFAULT_SOURCES}
)

basis_target_link_libraries(main_gateway ITKCommon ITKIO)
#--------------------------------------------------------------
# target: slicecount_gateway
#--------------------------------------------------------------
basis_add_library (
  slicecount_gateway MEX
  slicecount_gateway.cpp
  ${PIPELINE_SOURCES}
  ${DEFAULT_SOURCES}
)

basis_target_link_libraries(slicecount_gateway ITKCommon ITKIO)

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

basis_add_executable (Example1 Example1.m func.m)

# ----------------------------------------------------------------------------
# target: Example2
# ----------------------------------------------------------------------------

basis_add_executable (
  Example2
    Example2.m
    func.m
)

basis_target_link_libraries (Example2 libsvmread train predict)

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


basis_add_scripts ()


