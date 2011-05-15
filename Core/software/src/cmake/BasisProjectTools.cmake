##############################################################################
# \file  BasisProjectTools.cmake
# \brief Functions and macros used by any BASIS project.
#
# This is the main module that is included by BASIS projects. Most of the other
# BASIS CMake modules are included by this main module and hence do not need
# to be included separately.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE file in project root or 'doc' directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT BASIS_PROJECTTOOLS_INCLUDED)
set (BASIS_PROJECTTOOLS_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# required modules
# ============================================================================

include ("${CMAKE_CURRENT_LIST_DIR}/BasisGlobals.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/BasisCommon.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/BasisTargetTools.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/BasisSubversionTools.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/BasisDocTools.cmake")
include ("${CMAKE_CURRENT_LIST_DIR}/BasisUpdate.cmake")

# ============================================================================
# initialization / termination of major project components
# ============================================================================

# ****************************************************************************
# \brief Equivalent to CMake's project () command.
#
# Any BASIS project has to call this macro in the beginning of its root
# CMakeLists.txt file. Further, the macro basis_project_finalize () macro has
# to be called at the end of the root CMakeLists.txt file.
#
# As the BasisTest module has to be included after the project () command was
# used, this module is not included by the CMake Use file of the of the BASIS
# Core. Instead, this macro includes it before returning.
#
# The CMake module BasisUpdate.cmake, which is part of the BASIS CMake modules,
# realizes a feature referred to as "(automatic) file update". This feature
# is initialized by this macro and finalized by the corresponding
# basis_project_finalize () macro. As the CTest configuration file is usually
# maintained by the maintainer of BASIS and not the project developer, this
# file, if present in the project's root source directory, is updated if the
# template was modified. If you experience problems with the automatic file
# update, contact the maintainer of the template project and consider to
# disable the automatic file update for single files  by adding their path
# relative to the project's source directory to BASIS_UPDATE_EXCLUDE
# in the module Settings.cmake of your project. For example, to prevent the
# automatic udpate of the CTest configuration file, add "CTestConfig.cmake"
# to the list BASIS_UPDATE_EXCLUDE.
#
# The project specific attributes such as project version, among others, need
# to be defined in the Settings.cmake file which can be found in the
# SOFTWARE_CONFIG_DIR. The SOFTWARE_CONFIG_DIR is by default set by
# BasisSettings.cmake to the 'config' subfolder of the source tree of the
# project's software component. The project's Settings.cmake file is included
# by this macro.
#
# Dependencies to external packages should be resolved via find_package ()
# or find_sbia_package () commands in the file Depends.cmake which as well
# has to be located in SOFTWARE_CONFIG_DIR (note that this variable may be
# modified within Settings.cmake). The Depends.cmake file is included by
# this macro.
#
# Each BASIS project further has to have a README file in the root directory
# of the software component which is the root documentation file. This file
# may only consist of a reference to the project's actual documentation files
# that are located in the SOFTWARE_DOC_DIR.
#
# A LICENSE file with the copyright and license notices must be present in
# the root directory of the source tree.
#
# \see basis_project_finalize ()
#
# \param [in] NAME Project name.

macro (basis_project NAME)
  # set absolute path of root directory of project software component
  set (PROJECT_SOFTWARE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

  # set common CMake variables which would not be valid before project ()
  set (PROJECT_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
  set (PROJECT_BINARY_DIR "${CMAKE_CURRENT_BINARY_DIR}")

  # instantiate project directory structure
  foreach(P CONFIG SOURCE DATA DOC TESTS)
    set(VAR SOFTWARE_${P}_DIR)
    if (NOT IS_ABSOLUTE "${${VAR}}")
      set (${VAR} "${PROJECT_SOURCE_DIR}/${${VAR}}")
    endif ()
  endforeach()

  # include project settings
  include ("${SOFTWARE_CONFIG_DIR}/Settings.cmake")

  # check required project information
  if (NOT PROJECT_VERSION)
    message (FATAL_ERROR "PROJECT_VERSION not defined.")
  endif ()

  if (PROJECT_PACKAGE_VENDOR)
    basis_list_to_string (PROJECT_PACKAGE_VENDOR ${PROJECT_PACKAGE_VENDOR})
  endif ()

  if (PROJECT_DESCRIPTION)
    basis_list_to_string (PROJECT_DESCRIPTION ${PROJECT_DESCRIPTION})
  endif ()

  # default project information
  if (NOT PROJECT_README_FILE)
    set (PROJECT_README_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README")
  endif ()
  if (NOT EXISTS "${PROJECT_README_FILE}")
    message (FATAL_ERROR "Project README file not found.")
  endif ()

  if (NOT PROJECT_LICENSE_FILE)
    set (PROJECT_LICENSE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
  endif ()
  if (NOT EXISTS "${PROJECT_LICENSE_FILE}")
    message (FATAL_ERROR "Project LICENSE file not found.")
  endif ()

  # start CMake project
  project ("${NAME}")

  set (CMAKE_PROJECT_NAME "${PROJECT_NAME}") # variable used by CPack

  # convert project name to upper and lower case only, respectively
  string (TOUPPER "${PROJECT_NAME}" PROJECT_NAME_UPPER)
  string (TOLOWER "${PROJECT_NAME}" PROJECT_NAME_LOWER)

  # extract version numbers from version string
  basis_version_numbers (
    "${PROJECT_VERSION}"
      PROJECT_VERSION_MAJOR
      PROJECT_VERSION_MINOR
      PROJECT_VERSION_PATCH
  )

  # combine version numbers to version strings (also ensures consistency)
  set (PROJECT_VERSION   "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
  set (PROJECT_SOVERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")

  # get project revision
  basis_svn_get_revision ("${PROJECT_SOURCE_DIR}" PROJECT_REVISION)

  # print project information
  if (CMAKE_VERBOSE)
    message (STATUS "Project:")
    message (STATUS "  Name      = ${PROJECT_NAME}")
    message (STATUS "  Version   = ${PROJECT_VERSION}")
    message (STATUS "  SoVersion = ${PROJECT_SOVERSION}")
    if (PROJECT_REVISION)
    message (STATUS "  Revision  = ${PROJECT_REVISION}")
    else ()
    message (STATUS "  Revision  = n/a")
    endif ()
  endif ()

  # initialize automatic file update
  basis_update_initialize ()

  # update CTest configuration and enable testing
  #
  # \todo Is it possible to put the CTestConfig.cmake file in the directory
  #       SOFTWARE_TESTS_DIR? Will the "make test" then still work?
  #       Where should the BasisTest.cmake module be included?
  if (EXISTS "${PROJECT_SOURCE_DIR}/CTestConfig.cmake")
    basis_update (CTestConfig.cmake)
  endif ()

  include ("BasisTest")

  # resolve dependencies
  if (EXISTS "${SOFTWARE_CONFIG_DIR}/Depends.cmake")
    include ("${SOFTWARE_CONFIG_DIR}/Depends.cmake")
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
        DESTINATION "${INSTALL_DOC_DIR}"
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
        DESTINATION "${INSTALL_DOC_DIR}"
      )
    endif ()
    set (INSTALL_LICENSE)
  else ()
    install (
      FILES       "${PROJECT_LICENSE_FILE}"
      DESTINATION "${INSTALL_DOC_DIR}"
    )
  endif ()

  # configure default auxiliary source files
  basis_configure_auxiliary_sources (DEFAULT_SOURCES)

  set (DEFAULT_SOURCES_DIRS)
  foreach (DEFAULT_SOURCE ${DEFAULT_SOURCES})
    get_filename_component (TMP "${DEFAULT_SOURCE}" PATH)
    list (APPEND DEFAULT_SOURCES_DIRS "${TMP}")
    set (TMP)
  endforeach ()
  if (DEFAULT_SOURCES_DIRS)
    list (REMOVE_DUPLICATES DEFAULT_SOURCES_DIRS)
  endif ()

  include_directories (BEFORE ${DEFAULT_SOURCES_DIRS})

  source_group ("Default" ${DEFAULT_SOURCES})
endmacro ()

# ****************************************************************************
# \brief Finalize BASIS project configuration.
#
# This macro has to be called at the end of the root CMakeLists.txt file of
# each BASIS project initialized by basis_project ().
#
# The project configuration files are generated by including the CMake script
# SOFTWARE_CONFIG_DIR/GenerateConfig.cmake when this file exists.
#
# \see basis_project ()

macro (basis_project_finalize)
  # if project uses MATLAB
  if (MATLAB_FOUND)
    basis_create_addpaths_mfile ()
  endif ()

  # finalize (super-)project
  if (NOT IS_SUBPROJECT)
    # finalize addition of custom targets
    basis_add_custom_finalize ()
    # create and add execname executable
    basis_add_execname ()
    # add uninstall target
    basis_add_uninstall ()
  endif ()

  # generate configuration files
  include ("${SOFTWARE_CONFIG_DIR}/GenerateConfig.cmake" OPTIONAL)

  # create package
  include (BasisPack)

  # finalize update of files
  basis_update_finalize ()
endmacro ()

# ****************************************************************************
# \brief Initialize example component, calls CMake project () command.
#
# \param [in] PROJECT_NAME Name of the project this example belongs to.

function (basis_example PROJECT_NAME)
  # find software component
  find_package (${PROJECT_NAME} REQUIRED)

  if (NOT ${PROJECT_NAME}_FOUND)
    return ()
  endif ()

  # start example project
  project ("${PROJECT_NAME}Example")
endfunction ()

# ****************************************************************************
# \brief Initialize testing component, calls CMake project () command.
#
# \param [in] PROJECT_NAME Name of the project whose software is tested.

function (basis_testing PROJECT_NAME)
  # find software component
  find_package (${PROJECT_NAME} REQUIRED)

  if (NOT ${PROJECT_NAME}_FOUND)
    return ()
  endif ()

  include ("${${PROJECT_NAME}_USE_FILE}")
  set (PROJECT_SOFTWARE_DIR "${${PROJECT_NAME}_DIR}")

  # find example component (optional)
  find_package (${PROJECT_NAME}Example)

  if (${PROJECT_NAME}Example_FOUND)
    set (PROJECT_EXAMPLE_DIR "${${PROJECT_NAME}Example_DIR}")
  endif ()

  # start testing project
  project ("${PROJECT_NAME}Testing")

  # include testing module
  include (BasisTest)
endfunction ()

# ============================================================================
# auxiliary source files
# ============================================================================

# ****************************************************************************
# \brief Configure default auxiliary source files.
#
# This function configures the following default auxiliary source files
# which can be used by the projects which are making use of BASIS.
#
#   - config.h    This file is intended to be included by all source files.
#                 Hence, other projects will indirectly include this file when
#                 they use a library of this project.
#
#   - mainaux.h   This file is intended to be included by .(c|cc|cpp|cxx) files
#                 only which contain the definition of the main () function.
#                 It shall not be included by any other source file!
#
# \note If there exists a *.in file of the corresponding source file in the
#       SOFTWARE_SOURCE_DIR of the project, it will be used as template.
#       Otherwise, the template file coming with the BASIS CMake modules
#       is used.
#
# \param [out] SOURCES Configured default auxiliary C++ source files.

function (basis_configure_auxiliary_sources SOURCES)
  # get binary directory corresponding to SOFTWARE_SOURCE_DIR
  file (RELATIVE_PATH DIR "${PROJECT_SOURCE_DIR}" "${SOFTWARE_SOURCE_DIR}")
  set (DIR "${PROJECT_BINARY_DIR}/${DIR}")

  # configure auxiliary source files
  set (CPP_SOURCES "")
  foreach (SOURCE mainaux.h)
    set (TEMPLATE "${SOFTWARE_CONFIG_DIR}/${SOURCE}.in")
    if (NOT EXISTS "${TEMPLATE}")
      set (TEMPLATE "${CMAKE_CURRENT_LIST_DIR}/${SOURCE}.in")
    endif ()
    set (CPP_SOURCE "${DIR}/${SOURCE}")
    configure_file (${TEMPLATE} ${CPP_SOURCE} @ONLY)
    list (APPEND CPP_SOURCES "${CPP_SOURCE}")
  endforeach ()

  # return
  set (SOURCES "${CPP_SOURCES}" PARENT_SCOPE)
endfunction ()

# ============================================================================
# set/get any property
# ============================================================================

# ****************************************************************************
# \brief Replaces CMake's set_property () command.

function (basis_set_property SCOPE)
  if (SCOPE MATCHES "^TARGET$|^TEST$")
    set (IDX 0)
    foreach (ARG ${ARGN})
      if (ARG MATCHES "^APPEND$|^PROPERTY$")
        break ()
      endif ()
      if (SCOPE STREQUAL "TEST")
        basis_test_uid (UID "${ARG}")
      else ()
        basis_target_uid (UID "${ARG}")
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

function (basis_get_property VAR SCOPE ELEMENT)
  if (SCOPE STREQUAL "TARGET")
    basis_target_uid (ELEMENT "${ELEMENT}")
  elseif (SCOPE STREQUAL "TEST")
    basis_test_uid (ELEMENT "${ELEMENT}")
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
# \see basis_create_execname
#
# \param [in] TARGET_NAME Name of target. Defaults to "execname".

function (basis_add_execname)
  if (ARGC GREATER 1)
    message (FATAL_ERROR "Too many arguments given for function basis_add_execname ().")
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
  basis_create_execname (SOURCES)

  # add executable target
  add_executable (${TARGET_UID} ${SOURCES})
  target_link_libraries (${TARGET_UID} "${Boost_PROGRAM_OPTIONS_LIBRARY}")
endfunction ()

# ****************************************************************************
# \brief Create source code of execname target.
#
# The source file of the executable which is build by this target is
# configured using BASIS_TARGETS and the properties BASIS_TYPE, PREFIX,
# OUTPUT_NAME, and SUFFIX of these targets. The purpose of the built executable
# is to map CMake target names to their executable output names.
#
# Within source code of a certain project, other SBIA executables are called
# only indirectly using the target name which must be fixed and unique within
# the lab. The output name of these targets may however vary and depend on
# whether the project is build as part of a superproject or not. Each BASIS
# CMake function may adjust the output name in order to resolve name
# conflicts with other targets or SBIA executables.
#
# The idea is that a target name is supposed to be stable and known to the
# developer as soon as the target is added to a CMakeLists.txt file, while
# the name of the actual executable file is not known a priori as it is set
# by the BASIS CMake functions during the configure step. Thus, the developer
# should not rely on a particular name of the executable, but on the name of
# the corresponding CMake target.
#
# The execname target implements the calling conventions specified in the
# design Conventions document in the 'doc' directory.
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

function (basis_create_execname SOURCES)
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

  foreach (TARGET_UID ${BASIS_TARGETS})
    get_target_property (BASIS_TYPE "${TARGET_UID}" "BASIS_TYPE")
  
    if (BASIS_TYPE MATCHES "EXECUTABLE|SCRIPT")
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


endif (NOT BASIS_PROJECTTOOLS_INCLUDED)

