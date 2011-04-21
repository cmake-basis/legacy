##############################################################################
# \file  SbiaProjectTools.cmake
# \brief Functions and macros used by any SBIA project.
#
# This is the main module that is included by SBIA projects. Most of the other
# SBIA CMake modules are included by this main module and hence do not need
# to be included separately.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT SBIA_PROJECTTOOLS_INCLUDED)
set (SBIA_PROJECTTOOLS_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# required modules
# ============================================================================

include ("${CMAKE_CURRENT_LIST_DIR}/SbiaGlobals.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/SbiaCommon.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/SbiaTargetTools.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/SbiaSubversionTools.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/SbiaDocTools.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/SbiaUpdate.cmake")

# ============================================================================
# project
# ============================================================================

# ****************************************************************************
# \brief SBIA equivalent to CMake's project () command.
#
# Any SBIA (sub-)project has to call this macro in the beginning of its root
# CMakeLists.txt file. Further, the macro sbia_project_finalize () macro has
# to be called at the end of the root CMakeLists.txt file.
#
# This macro at first searches the package SBIA CMake modules package and
# includes its CMake Use file which in turn includes all the other SBIA
# CMake modules required by any SBIA project. If the SBIA CMake modules was
# already found by a superproject, the CMake Use file of this package will
# do nothing as it should have been included by the superproject already
# which may adjust some SBIA settings which then are passed on to each
# (sub-)project. Note that the Use file also specifies the minimum required
# CMake version via cmake_minimum_required ().
#
# As the SBIA Testing CMake module has to be included after the project ()
# command was used, this module is not included by the CMake Use file of the
# SBIA CMake modules package. Instead, this macro includes it before returning.
#
# The CMake module SbiaUpdate.cmake, which is part of the SBIA CMake Modules
# package, realizes a feature referred to as "(automatic) file update".
# This feature is initialized by this macro and finalized by the corresponding
# sbia_project_finalize () macro. As the CTest configuration file is usually
# maintained by the maintainer of the project template and not the project
# developer, this file, if present in the project's root source directory,
# is updated if the template was modified. If you experience problems with the
# automatic file update, contact the maintainer of the template project and
# consider to disable the automatic file update for single files  by adding
# their path relative to the project's source directory to SBIA_UPDATE_EXCLUDE
# in the module Settings.cmake of your project. For example, to prevent the
# automatic udpate of the CTest configuration file, add "CTestConfig.cmake"
# to the list SBIA_UPDATE_EXCLUDE.
#
# The project specific attributes such as project name and project version,
# among others, need to be defined in the Settings.cmake file which can be
# found in the PROJECT_CONFIG_DIR. The PROJECT_CONFIG_DIR is by default set
# by SbiaSettings.cmake to the 'Config' subfolder of the project's source tree.
# The project's Settings.cmake file is included by this macro and the project
# name is passed unchanged to the project () command of CMake.
#
# Dependencies to external packages should be resolved via find_package ()
# commands in the file Depends.cmake which as well has to be located in
# PROJECT_CONFIG_DIR (note that this variable may be modified within
# Settings.cmake). The Depends.cmake file is included by this macro.
#
# Each SBIA project further has to have a ReadMe file in the top directory
# of the source tree which is the root documentation file. This file may only
# consist of a reference to the project's actual documentation files that
# are located in the 'doc' subfolder of the source tree.
#
# A Copyright file with the copyright and license notices must be present in
# the root directory of the source tree.
#
# \see sbia_project_finalize ()

macro (sbia_project)
  # include project settings
  include ("${PROJECT_CONFIG_DIR}/Settings.cmake")

  # check required project information
  if (NOT PROJECT_NAME)
    message (FATAL_ERROR "PROJECT_NAME not defined.")
  endif ()

  if (NOT PROJECT_VERSION)
    message (FATAL_ERROR "PROJECT_VERSION not defined.")
  endif ()

  if (PROJECT_PACKAGE_VENDOR)
    sbia_list_to_string (PROJECT_PACKAGE_VENDOR ${PROJECT_PACKAGE_VENDOR})
  endif ()

  if (PROJECT_DESCRIPTION)
    sbia_list_to_string (PROJECT_DESCRIPTION ${PROJECT_DESCRIPTION})
  endif ()

  # default project information
  if (NOT PROJECT_README_FILE)
    set (PROJECT_README_FILE "${CMAKE_CURRENT_SOURCE_DIR}/ReadMe")
  endif ()
  if (NOT EXISTS "${PROJECT_README_FILE}")
    message (FATAL_ERROR "Project README file not found.")
  endif ()

  if (NOT PROJECT_LICENSE_FILE)
    set (PROJECT_LICENSE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/Copyright")
  endif ()
  if (NOT EXISTS "${PROJECT_LICENSE_FILE}")
    message (FATAL_ERROR "Project LICENSE file not found.")
  endif ()

  # start CMake project
  project ("${PROJECT_NAME}")

  set (CMAKE_PROJECT_NAME "${PROJECT_NAME}") # variable used by CPack

  # determine whether project is configured as subproject
  if ("${CMAKE_SOURCE_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}")
    set (IS_SUBPROJECT 0)
  else ()
    set (IS_SUBPROJECT 1)
  endif ()

  # convert project name to upper and lower case only, respectively
  string (TOUPPER "${PROJECT_NAME}" PROJECT_NAME_UPPER)
  string (TOLOWER "${PROJECT_NAME}" PROJECT_NAME_LOWER)

  # extract version numbers from version string
  sbia_version_numbers (
    "${PROJECT_VERSION}"
      PROJECT_VERSION_MAJOR
      PROJECT_VERSION_MINOR
      PROJECT_VERSION_PATCH
  )

  # combine version numbers to version strings (also ensures consistency)
  set (PROJECT_VERSION   "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
  set (PROJECT_SOVERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")

  # get project revision
  sbia_svn_get_revision ("${PROJECT_SOURCE_DIR}" PROJECT_REVISION)

  # print project information
  if (CMAKE_VERBOSE)
    message (STATUS "SBIA Project:")
    message (STATUS "  Name      = ${PROJECT_NAME}")
    message (STATUS "  Version   = ${PROJECT_VERSION}")
    message (STATUS "  SoVersion = ${PROJECT_SOVERSION}")
    if (PROJECT_REVISION)
    message (STATUS "  Revision  = ${PROJECT_REVISION}")
    else ()
    message (STATUS "  Revision  = n/a")
    endif ()
  endif ()

  # adjust installation directories
  if (IS_SUBPROJECT)
    set (INSTALL_DATA_DIR    "${INSTALL_DATA_DIR}/${PROJECT_NAME}")
    set (INSTALL_DOC_DIR     "${INSTALL_DOC_DIR}/${PROJECT_NAME}")
    set (INSTALL_EXAMPLE_DIR "${INSTALL_EXAMPLE_DIR}/${PROJECT_NAME}")
    set (INSTALL_INCLUDE_DIR "${INSTALL_INCLUDE_DIR}/${PROJECT_NAME}")
  endif ()

  # initialize automatic file update
  if (NOT IS_SUBPROJECT)
    sbia_update_initialize ()
  endif ()

  # update CTest configuration and enable testing
  if (EXISTS "${PROJECT_SOURCE_DIR}/CTestConfig.cmake")
    sbia_update (CTestConfig.cmake)
  endif ()

  include ("SbiaTest")

  # resolve dependencies
  if (EXISTS "${PROJECT_CONFIG_DIR}/Depends.cmake")
    include ("${PROJECT_CONFIG_DIR}/Depends.cmake")
  endif ()

  # copy license to binary tree
  if (NOT "${PROJECT_BINARY_DIR}" STREQUAL "${PROJECT_SOURCE_DIR}")
    get_filename_component (TMP "${PROJECT_LICENSE_FILE}" NAME)
    configure_file ("${PROJECT_LICENSE_FILE}" "${PROJECT_BINARY_DIR}/${TMP}" COPYONLY)
    set (TMP)
  endif ()

  # install license
  if (IS_SUBPROJECT)
    get_filename_component (LICENSE_NAME "${PROJECT_LICENSE_FILE}" NAME)

    set (INSTALL_LICENSE 1)
    if (EXISTS "${CMAKE_SOURCE_DIR}/${LICENSE_NAME}")
      file (READ "${CMAKE_SOURCE_DIR}/${LICENSE_NAME}" SUPER_LICENSE)
      file (READ "${PROJECT_LICENSE_FILE}"             PROJECT_LICENSE)
      if (PROJECT_LICENSE STREQUAL SUPER_LICENSE)
        set (INSTALL_LICENSE 0)
      endif ()
    endif ()

    if (INSTALL_LICENSE)
      install (
        FILES       "${PROJECT_LICENSE_FILE}"
        DESTINATION "${INSTALL_DIR}"
        RENAME      "${LICENSE_NAME}-${PROJECT_NAME}"
      )
      file (
        APPEND "${CMAKE_BINARY_DIR}/${LICENSE_NAME}"
        "\n\n------------------------------------------------------------------------------\n"
        "See ${LICENSE_NAME}-${PROJECT_NAME} file for copyright and license notices specific\n"
        "to the project ${PROJECT_NAME}.\n"
        "------------------------------------------------------------------------------\n"
      )
      install (
        FILES       "${CMAKE_BINARY_DIR}/${LICENSE_NAME}"
        DESTINATION "${INSTALL_DIR}"
      )
    endif ()
    set (INSTALL_LICENSE)
  else ()
    install (
      FILES       "${PROJECT_LICENSE_FILE}"
      DESTINATION "${INSTALL_DIR}"
    )
  endif ()
endmacro ()

# ****************************************************************************
# \brief Finalize SBIA project configuration.
#
# This macro has to be called at the end of the root CMakeLists.txt file of
# each SBIA project initialized by sbia_project ().
#
# The project configuration files are generated by including the CMake script
# PROJECT_CONFIG_DIR/GenerateConfig.cmake when this file exists.
#
# \see sbia_project ()

macro (sbia_project_finalize)
  # if project uses MATLAB
  if (MATLAB_FOUND)
    sbia_create_addpaths_mfile ()
  endif ()

  # finalize superproject
  if (NOT IS_SUBPROJECT)
    # finalize addition of custom targets
    sbia_add_custom_finalize ()
    # create and add execname executable
    sbia_add_execname ()
    # add uninstall target
    sbia_add_uninstall ()
  endif ()

  # generate configuration files
  include ("${PROJECT_CONFIG_DIR}/GenerateConfig.cmake" OPTIONAL)

  # create package
  include (SbiaPack)

  # finalize update of files
  sbia_update_finalize ()
endmacro ()

# ============================================================================
# set/get any property
# ============================================================================

# ****************************************************************************
# \brief Replaces CMake's set_property () command.

function (sbia_set_property SCOPE)
  if (SCOPE MATCHES "^TARGET$|^TEST$")
    set (IDX 0)
    foreach (ARG ${ARGN})
      if (ARG MATCHES "^APPEND$|^PROPERTY$")
        break ()
      endif ()
      if (SCOPE STREQUAL "TEST")
        sbia_test_uid (UID "${ARG}")
      else ()
        sbia_target_uid (UID "${ARG}")
      endif ()
      list (REMOVE_AT ARGN ${IDX})
      list (INSERT ARGN ${IDX} "${UID}")
      math (EXPR IDX "${IDX} + 1")
    endforeach ()
  endif ()
  set_property (${ARGN})
endfunction ()

# ****************************************************************************
# \brief Replaces CMake's get_property () command.

function (sbia_get_property VAR SCOPE ELEMENT)
  if (SCOPE STREQUAL "TARGET")
    sbia_target_uid (ELEMENT "${ELEMENT}")
  elseif (SCOPE STREQUAL "TEST")
    sbia_test_uid (ELEMENT "${ELEMENT}")
  endif ()
  get_property (VALUE ${SCOPE} ${ELEMENT} ${ARGN})
  set ("${VAR}" "${VALUE}" PARENT_SCOPE)
endfunction ()

# ============================================================================
# execname
# ============================================================================

# ****************************************************************************
# \brief Create source code of execname command and add executable target.
#
# \see sbia_create_execname
#
# \param [in] TARGET_NAME Name of target. Defaults to "execname".

function (sbia_add_execname)
  if (ARGC GREATER 1)
    message (FATAL_ERROR "Too many arguments given for function sbia_add_execname ().")
  endif ()

  if (ARGC GREATER 0)
    set (TARGET_UID "${ARGV1}")
  else ()
    set (TARGET_UID "execname")
  endif ()

  # find required packages
  if (NOT Boost_PROGRAM_OPTIONS_FOUND)
    find_package (Boost 1.45.0 COMPONENTS program_options)
  endif ()

  if (Boost_PROGRAM_OPTIONS_FOUND)
    include_directories ("${Boost_INCLUDE_DIR}")
  else ()
    message (FATAL_ERROR "Boost component program_options not found."
                         " It is required by target ${TARGET_UID}.")
  endif ()

  # create source code
  sbia_create_execname (SOURCES)

  # add executable target
  add_executable (${TARGET_UID} ${SOURCES})
  target_link_libraries (${TARGET_UID} "${Boost_PROGRAM_OPTIONS_LIBRARY}")
endfunction ()

# ****************************************************************************
# \brief Create source code of execname target.
#
# The source file of the executable which is build by this target is
# configured using SBIA_TARGETS and the properties SBIA_TYPE, PREFIX,
# OUTPUT_NAME, and SUFFIX of these targets. The purpose of the built executable
# is to map CMake target names to their executable output names.
#
# Within source code of a certain project, other SBIA executables are called
# only indirectly using the target name which must be fixed. The output name
# of these targets may however vary and depend on whether the project is build
# as part of a superproject or not. Each SBIA CMake function may adjust the
# output name in order to resolve name conflicts with other targets or SBIA
# executables.
#
# The idea is that a target name is supposed to be stable and known to the
# developer as soon as the target is added to a CMakeLists.txt file, while
# the name of the actual executable file is not known a priori as it is set
# by the SBIA CMake functions during the configure step. Thus, the developer
# should not rely on a particular name of the executable, but on the name of
# the corresponding CMake target.
#
# Example template file snippet:
#
# \code
# //! Number of targets.
# const int numberOfTargets = @NUMBER_OF_TARGETS@;
#
# //! Map which maps target names to executable names.
# const char * const targetNameToOutputNameMap [numberOfTargets][2] =
# {
# @TARGET_NAME_TO_OUTPUT_NAME_MAP@
# };
# \endcode
#
# Example usage:
#
# \code
# execname TargetA@ProjectA
# execname TargetA@ProjectB
# execname --namespace ProjectA TargetA
# \endcode
#
# \param [out] SOURCES List of generated source files.
# \param [in]  ARGN    The remaining list of arguments is parsed for the
#                      following options:
#
#    BASENAME Basename of generated source file.
#             If not given, the basename of the template source file is used.
#    TEMPLATE Template source file. If not specified, the default template
#             which is part of the SBIA CMake Modules package is used.

function (sbia_create_execname SOURCES)
  # parse arguments
  CMAKE_PARSE_ARGUMENTS (ARGN "" "BASENAME;TEMPLATE" "" ${ARGN})

  if (NOT ARGN_TEMPLATE)
    set (ARGN_TEMPLATE "${CMAKE_CURRENT_LIST_DIR}/execname.cpp.in")
  endif ()

  if (NOT ARGN_BASENAME)
    get_filename_component (ARGN_BASENAME "${ARGN_TEMPLATE}" NAME_WE)
    string (REGEX REPLACE "\\.in$"          ""    ARGN_BASENAME "${ARGN_BASENAME}")
    string (REGEX REPLACE "\\.in\(\\..*\)$" "\\1" ARGN_BASENAME "${ARGN_BASENAME}")
  endif ()

  # output name
  set (SOURCE_FILE "${CMAKE_CURRENT_BINARY_DIR}/${ARGN_BASENAME}.cpp")

  # create initialization code of target name to executable name map
  set (NUMBER_OF_TARGETS "0")
  set (TARGET_NAME_TO_EXECUTABLE_NAME_MAP)

  foreach (TARGET_UID ${SBIA_TARGETS})
    get_target_property (TYPE "${TARGET_UID}" "SBIA_TYPE")
  
    if (TYPE MATCHES "EXECUTABLE|SCRIPT")
      get_target_property (PREFIX      "${TARGET_UID}" "PREFIX")
      get_target_property (SUFFIX      "${TARGET_UID}" "SUFFIX")
      get_target_property (OUTPUT_NAME "${TARGET_UID}" "OUTPUT_NAME")
  
      if (NOT OUTPUT_NAME)
        set (OUTPUT_NAME "${TARGET_UID}")
      endif ()
      if (NOT PREFIX)
        set (PREFIX "")
      endif ()
      if (NOT SUFFIX)
        set (SUFFIX "")
      endif ()
  
      set (EXECUTABLE_NAME "${PREFIX}${OUTPUT_NAME}${SUFFIX}")

      if (TARGET_NAME_TO_EXECUTABLE_NAME_MAP)
        set (TARGET_NAME_TO_EXECUTABLE_NAME_MAP "${TARGET_NAME_TO_EXECUTABLE_NAME_MAP},\n")
      endif ()
      set (TARGET_NAME_TO_EXECUTABLE_NAME_MAP "${TARGET_NAME_TO_EXECUTABLE_NAME_MAP}    {\"${TARGET_UID}\", \"${EXECUTABLE_NAME}\"}")

      math (EXPR NUMBER_OF_TARGETS "${NUMBER_OF_TARGETS} + 1")
    endif ()
  endforeach ()

  # configure source file
  configure_file ("${ARGN_TEMPLATE}" "${SOURCE_FILE}" @ONLY)

  # return
  set (SOURCES "${SOURCE_FILE}" PARENT_SCOPE)
endfunction ()


endif (NOT SBIA_PROJECTTOOLS_INCLUDED)

