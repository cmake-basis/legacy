##############################################################################
# \file  SbiaUpdate.cmake
# \brief Implements automatic file udpate feature.
#
# This file provides functions which implement the automatic file update
# of project files from the corresponding template files which they were
# instantiated from. Instead of the need to manually copy files and/or parts
# of files from the updated project template to each project that was
# instantiated from this particular template, the projects themselves check
# for the availibility of updated template files during the configure step
# of CMake and apply the updates if possible and desired by the user.
# The automatic file update mechanism can be configured to have the user decide
# for each or all files whether an available update may be applied or not.
# Further, updates will only be applied if it is guaranteed that these changes
# can be easily reverted.
#
# The automatic file update feature is only enabled when
#
# 1. The option SBIA_UPDATE, which is added by this module, is enabled.
#
# 2. PROJECT_TEMPLATE_ROOT is a valid URL to the root directory
#    or repository directory in which the project template is stored,
#    respectively, all released versions of the project templates are
#    stored. Note that local directories must be specified including the
#    "file://" prefix.
#
# 3. TEMPLATE_VERSION specifies an existent project template version,
#    i.e., the template root directory
#
#      PROJECT_TEMPLATE_ROOT/PROJECT_TEMPLATE
#
#    exists, where the variable PROJECT_TEMPLATE is set by this module when
#    included to the name/directory of the tagged project template corresponding
#    to the specified version. Therefore, the value of PROJECT_TEMPLATE contains
#    parts of TEMPLATE_VERSION, e.g.,
#
#      "SbiaProject-${TEMPLATE_VERSION_MAJOR}/Template".
#
# 4. The Python interpreter "python" was found by SbiaCommands and thus
#    the variable SBIA_CMD_PYTHON is set.
#
# 5. The script used to merge the content of the template with the existing
#    project files has to be in SBIA_CMakeModules_MODULE_PATH and the name of
#    the script must be "SbiaUpdateFile.py".
#
# 6. The project itself has to be under revision control, in particular,
#    a valid Subversion working copy. This is required to ensure that changes
#    applied during the automatic file udpate can be reverted.
#
# Hence, when the project is not configured and build inside the SBIA
# environment, the automatic file update is disabled. This is in fact desired
# as the project is not supposed to be modified at this point any more.
#
# When this module is included, it adds the advanced option SBIA_UPDATE_AUTO
# which is ON by default. If SBIA_UPDATE_AUTO is ON, files are updated
# automatically without interacting with the user to get confirmation for file
# update. If a project file contains local modifications or is not under
# revision control, the udpate will not be performed automatically in any case.
# Moreover, files which are listed with their path relative to the project
# source directory in SBIA_UPDATE_EXCLUDE are excluded from the automatic file
# update.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

if (NOT SBIA_UPDATE_INCLUDED)
set (SBIA_UPDATE_INCLUDED 1)


# get directory of this file
#
# \note This variable was just recently introduced in CMake, it is derived
#       here from the already earlier added variable CMAKE_CURRENT_LIST_FILE
#       to maintain compatibility with older CMake versions.
get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)


# ============================================================================
# options
# ============================================================================

option (SBIA_UPDATE      "Whether the automatic file update is enabled"                    "ON")
option (SBIA_UPDATE_AUTO "Whether files may be updated automatically without confirmation" "ON")

mark_as_advanced (SBIA_UPDATE)
mark_as_advanced (SBIA_UPDATE_AUTO)

# ============================================================================
# template branch
# ============================================================================

sbia_version_numbers (
  ${TEMPLATE_VERSION}
    TEMPLATE_VERSION_MAJOR
    TEMPLATE_VERSION_MINOR
    TEMPLATE_VERSION_PATCH
)

set (PROJECT_TEMPLATE "SbiaProject-${TEMPLATE_VERSION_MAJOR}/Template")

set (
  PROJECT_TEMPLATE_ROOT "@PROJECT_TEMPLATE_ROOT@"
  CACHE STRING "Root directory of project template(s) (e.g., \"SVN_ROOT_URL/tags\")."
)

mark_as_advanced (PROJECT_TEMPLATE_ROOT)

# ============================================================================
# initialization
# ============================================================================

# ****************************************************************************
# \function sbia_update_initialize
# \brief    Initialize file update and update files already scheduled for update.
#
# This function has to be called before any sbia_update () call. It performs
# the update of files already scheduled for updated during a previous CMake
# configure step and for which the user choose to update them by invoking the
# function sbia_update_files (). Note that files are only udpated here if the
# interactive mode is enabled or if there are files which could not be updated
# automatically by the last execution of sbia_update_finalize (). Otherwise,
# no files are updated by this function. Afterwards the update system is
# initialized for another iteration of CMake's configure step.
#
# Example:
#
# \code
# sbia_update_initialize ()
# sbia_update (CMakeLists.txt)
# sbia_update_finalize ()
# \endcode
#
# \see sbia_update ()
# \see sbia_update_finalize ()
# \see sbia_update_files ()

function (sbia_update_initialize)

  # look for required file udpate script
  find_file (
    SBIA_UPDATE_SCRIPT
    NAMES SbiaUpdateFile.py
    PATHS "${CMAKE_CURRENT_LIST_DIR}"
    NO_DEFAULT_PATHS
  )

  mark_as_advanced (SBIA_UPDATE_SCRIPT)

  # check PROJECT_TEMPLATE_ROOT
  set (PROJECT_TEMPLATE_ROOT_VALID 0)

  if (PROJECT_TEMPLATE_ROOT MATCHES "file://.*")
    string (REGEX REPLACE "file://" "" TMP "${PROJECT_TEMPLATE_ROOT}")
    if (IS_DIRECTORY "${TMP}")
      set (PROJECT_TEMPLATE_ROOT_VALID 1)
    endif ()
  elseif (PROJECT_TEMPLATE_ROOT MATCHES "http.*://.*")
    sbia_svn_get_revision (${PROJECT_TEMPLATE_ROOT} REV)
    if (REV)
      set (PROJECT_TEMPLATE_ROOT_VALID 1)
    endif ()
  endif ()
  
  # check PROJECT_TEMPLATE
  set (PROJECT_TEMPLATE_VALID 1) # we cannot know if PROJECT_TEMPLATE_ROOT is not valid...

  if (PROJECT_TEMPLATE_ROOT_VALID)
    set (PROJECT_TEMPLATE_VALID 0)

    if (NOT PROJECT_TEMPLATE STREQUAL "")
      set (TMP "${PROJECT_TEMPLATE_ROOT}/${PROJECT_TEMPLATE}")

      if (TMP MATCHES "file://.*")
        string (REGEX REPLACE "file://" "" TMP "${TMP}")
        if (IS_DIRECTORY "${TMP}")
          set (PROJECT_TEMPLATE_VALID 1)
        endif ()
      elseif (TMP MATCHES "http.*://.*")
        sbia_svn_get_revision (${PROJECT_TEMPLATE_ROOT} REV)
        if (REV)
          set (PROJECT_TEMPLATE_VALID 1)
        endif ()
      endif ()
    endif ()
  endif ()

  # --------------------------------------------------------------------------
  # update enabled
  # --------------------------------------------------------------------------

  if (
        SBIA_UPDATE                          # 1. update is enabled
    AND PROJECT_TEMPLATE_ROOT_VALID # 2. valid template root dir
    AND PROJECT_TEMPLATE_VALID               # 3. valid project template
    AND SBIA_CMD_PYTHON                      # 4. python interpreter found
    AND SBIA_UPDATE_SCRIPT                   # 5. update script found
    AND PROJECT_REVISION                     # 6. project is under revision control
  )

    # update files which were not updated during last configure run. Instead,
    # CMake variables where added which enabled the user to specify the files
    # which should be udpated
    sbia_update_files ()

  # --------------------------------------------------------------------------
  # update disabled
  # --------------------------------------------------------------------------

  else ()

    if (SBIA_UPDATE)
      message ("File update not feasible.")

      if (CMAKE_VERBOSE)
        message ("Variables related to (automatic) file update:

  SBIA_UPDATE           : ${SBIA_UPDATE}
  SBIA_UPDATE_AUTO      : ${SBIA_UPDATE_AUTO}
  SBIA_CMD_PYTHON       : ${SBIA_CMD_PYTHON}
  SBIA_UPDATE_SCRIPT    : ${SBIA_UPDATE_SCRIPT}
  PROJECT_TEMPLATE_ROOT : ${PROJECT_TEMPLATE_ROOT}
  PROJECT_TEMPLATE      : ${PROJECT_TEMPLATE}
  PROJECT_REVISION      : ${PROJECT_REVISION}
")
      endif ()

      if (NOT SBIA_CMD_PYTHON)
        message ("=> Python interpreter not found.")
      endif ()
	  if (NOT SBIA_UPDATE_SCRIPT)
        message ("=> File update script not found.")
      endif ()
      if (NOT PROJECT_TEMPLATE_ROOT_VALID)
        message ("=> Invalid PROJECT_TEMPLATE_ROOT path.")
      endif()
      if (NOT PROJECT_TEMPLATE_VALID)
        message ("=> Template PROJECT_TEMPLATE does not exist. Check value of TEMPLATE_VERSION.")
      endif ()
      if (NOT PROJECT_REVISION)
        message ("=> Project is not under revision control.")
      endif ()

      message ("Setting SBIA_UPDATE to OFF.")
      set (SBIA_UPDATE "OFF" CACHE BOOL "Whether the automatic file update is enabled" FORCE)
    endif ()
 
  endif ()
endfunction ()

# ============================================================================
# update
# ============================================================================

# ****************************************************************************
# \function sbia_update
# \brief    Checks for availibility of update and adds files for which an
#           updated template exists to SBIA_UPDATE_FILES.
#
# This function retrieves a copy of the latest revision of the corresponding
# template file of the project template from which this project was
# instantiated and caches it in the binary tree. If a cached copy is already
# available, the cached copy is used. Then, it checks whether the template
# contains any updated compared to the current project file, ignoring the
# content of customizable sections. If an udpate is available, the file
# is added to SBIA_UPDATE_FILE. The updates will be applied by either
# sbia_update_initialize () if the interactive mode is enabled or by
# sbia_update_finalize ().
#
# Files which are listed with their path relative to the project source
# directory in SBIA_UPDATE_EXCLUDE are excluded from the automatic file
# update and will hence be skipped by this function.
#
# \see sbia_update_initialize ()
# \see sbia_update_finalize ()
#
# \param [in] FILENAME Name of project file in current source directory.

function (sbia_update FILENAME)
  if (NOT SBIA_UPDATE)
    return ()
  endif ()

  # absolute path of project file
  set (CUR "${CMAKE_CURRENT_SOURCE_DIR}/${FILENAME}")

  # get path of file relative to project source directory
  file (RELATIVE_PATH REL "${PROJECT_SOURCE_DIR}" "${CUR}")

  # must be AFTER REL was set
  if (CMAKE_VERBOSE)
    message (STATUS "Checking for update of file '${REL}'...")
  endif ()

  # skip file if excluded from file update
  if (SBIA_UPDATE_EXCLUDE)
    list (FIND SBIA_UPDATE_EXCLUDE "${REL}" IDX)

    if (IDX EQUAL -1)
      if (CMAKE_VERBOSE)
        message (STATUS "Checking for update of file '${REL}'... - excluded")
      endif ()

      return ()
    endif ()
  endif ()

  # skip file if it is not under revision control
  if (EXISTS "${CUR}")
    sbia_svn_get_last_changed_revision ("${CUR}" CURREV)

    if (CURREV EQUAL 0)
      if (CMAKE_VERBOSE)
        message (STATUS "Checking for update of file '${REL}'... - file unversioned")
      endif ()

      return ()
    endif ()
  endif ()

  # retrieve template file
  sbia_update_cached_template ("${REL}" TMP)             # file name of cached template file
  sbia_update_template        ("${REL}" "${TMP}" RETVAL) # update cached template file

  if (NOT RETVAL)
    message (STATUS "Checking for update of file '${REL}'... - template missing")
    return ()
  endif ()

  # get currently cached list of files in SBIA_UPDATE_FILES
  set (FILES ${SBIA_UPDATE_FILES})

  # --------------------------------------------------------------------------
  # check if update of existing project file is available
  # --------------------------------------------------------------------------

  if (EXISTS "${CUR}")
    execute_process (
      COMMAND
        "${SBIA_CMD_PYTHON}" "${SBIA_UPDATE_SCRIPT}" -i "${CUR}" -t "${TMP}"
      RESULT_VARIABLE
        RETVAL
      OUTPUT_QUIET
      ERROR_QUIET
    )

    if (RETVAL EQUAL 0)
      list (APPEND FILES "${REL}")
    elseif (RETVAL EQUAL 2)

      if (FILES)
        list (REMOVE_ITEM FILES "${REL}")
      endif ()

      sbia_update_option ("${REL}" OPT)

      if (DEFINED ${OPT})
        set (${OPT} "" CACHE INTERNAL "Unused option." FORCE)
      endif ()
    endif ()

    if (CMAKE_VERBOSE)
      if (RETVAL EQUAL 0)
        message (STATUS "Checking for update of file '${REL}'... - update available")
      elseif (RETVAL EQUAL 2)
        message (STATUS "Checking for update of file '${REL}'... - up-to-date")
      else ()
        message (STATUS "Checking for update of file '${REL}'... - failed")
      endif ()
    endif ()

  # --------------------------------------------------------------------------
  # new files added to template
  # --------------------------------------------------------------------------

  else ()

    list (APPEND FILES "${REL}")

    if (CMAKE_VERBOSE)
      message (STATUS "Checking for update of file '${REL}'... - file missing")
    endif ()

  endif ()

  # update cached variable SBIA_UPDATE_FILES
  set (SBIA_UPDATE_FILES ${FILES} CACHE INTERNAL "Files to be updated." FORCE)
endfunction ()

# ============================================================================
# finalization
# ============================================================================

# ****************************************************************************
# \function sbia_update_finalize
# \brief    Adds file update options for user interaction or performs
#           file update immediately if quiet update enabled.
#
# \see sbia_update ()
# \see sbia_update_initialize ()
# \see sbia_update_finalize ()

function (sbia_update_finalize)
  if (NOT SBIA_UPDATE)
    return ()
  endif ()

  set (FILES ${SBIA_UPDATE_FILES})

  if (FILES)
    list (REMOVE_DUPLICATES FILES)
  endif ()

  # iterate over files added by sbia_update ()
  foreach (REL ${FILES})

    # absolute path of project file
    set (CUR "${PROJECT_SOURCE_DIR}/${REL}")

    # name of cached template file
    sbia_update_cached_template ("${REL}" TMP)

    # ------------------------------------------------------------------------
    # project file exists
    # ------------------------------------------------------------------------

    if (EXISTS "${CUR}")

      # check if it is under revision control and whether it has local modifications
      if (EXISTS "${CUR}")
        sbia_svn_get_last_changed_revision (${CUR} CURREV)
        sbia_svn_status                    (${CUR} CURSTATUS)
      endif ()

      sbia_update_option ("${REL}" OPT) # name of file update option

      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # quietly update file w/o user interaction
      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      if (
            SBIA_UPDATE_AUTO           # 1. option SBIA_UPDATE_AUTO is ON
        AND CURREV GREATER 0           # 2. project file is under revision control
        AND "${CURSTATUS}" STREQUAL "" # 3. project file has no local modifications
      )
        if (CMAKE_VERBOSE)
          message (STATUS "Updating file '${REL}'...")
        endif ()

        execute_process (
          COMMAND
            "${SBIA_CMD_PYTHON}" "${SBIA_UPDATE_SCRIPT}" -f -i "${CUR}" -t "${TMP}" -o "${CUR}"
          RESULT_VARIABLE
            RETVAL
          OUTPUT_QUIET
          ERROR_QUIET
        )

        if (RETVAL EQUAL 0 OR RETVAL EQUAL 2)
          list (REMOVE_ITEM FILES "${REL}")
          set (${OPT} "" CACHE INTERNAL "Unused option." FORCE)
        endif ()

        if (RETVAL EQUAL 0)
          message ("Updated file '${REL}'")
        elseif (NOT RETVAL EQUAL 2)
          message ("Failed to update file '${REL}'")
        endif ()

        if (CMAKE_VERBOSE)
          if (RETVAL EQUAL 0)
            message (STATUS "Updating file '${REL}'... - done")
          elseif (RETVAL EQUAL 2)
            message (STATUS "Updating file '${REL}'... - up-to-date")
          else ()
            message (STATUS "Updating file '${REL}'... - failed")
          endif ()
        endif ()

      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # add file update option (if not present yet)
      # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      else ()

        if ("${${OPT}}" STREQUAL "")
          # add option which user can modify to force update of file
          set (${OPT} "OFF" CACHE BOOL "Whether file '${REL}' should be updated." FORCE)
          # add SBIA_UPDATE_ALL option if not present
          if ("${SBIA_UPDATE_ALL}" STREQUAL "")
            set (SBIA_UPDATE_ALL "OFF" CACHE BOOL "Whether all files should be updated." FORCE)
          endif ()
        endif ()

        # inform user that file update is available
        message ("Update of file '${REL}' available.\nSet SBIA_UPDATE_ALL or ${OPT} to ON if changes should be applied.")

      endif ()

    # ----------------------------------------------------------------------
    # project file non existent
    # ----------------------------------------------------------------------

    else ()

      if (CMAKE_VERBOSE)
        message (STATUS "Adding file '${REL}'...")
      endif ()

      configure_file ("${TMP}" "${CUR}" COPYONLY)

      list (REMOVE_ITEM FILES "${REL}")
      set (${OPT} "" CACHE INTERNAL "Unused option." FORCE)

      message ("Added file '${REL}'. Do not forget to add it to the repository!")

      if (CMAKE_VERBOSE)
        message (STATUS "Adding file '${REL}'... - done")
      endif ()

    endif ()

  endforeach ()

  if (NOT FILES)
    set (SBIA_UPDATE_ALL "" CACHE INTERNAL "Unused option." FORCE)
  endif ()

  set (SBIA_UPDATE_FILES ${FILES} CACHE INTERNAL "Files to be updated." FORCE)
endfunction ()

# ============================================================================
# helpers
# ============================================================================

# ----------------------------------------------------------------------------
# common helpers
# ----------------------------------------------------------------------------

# ****************************************************************************
# \function sbia_update_option
# \brief    Returns name of file update option.
#
# The CMake variable name returned by this function is used as file update
# option which enables the user to select which files should be udpated.
#
# \see sbia_update_finalize ()
# \see sbia_update_files ()
#
# \param [in]  REL         Path of project file relative to project source directory.
# \param [out] OPTION_NAME Name of file update option.
#
function (sbia_update_option REL OPTION_NAME)
  set (TMP "${REL}")
  string (REGEX REPLACE "\\.|\\\\|/|-" "_" TMP ${TMP})
  set (${OPTION_NAME} "SBIA_UPDATE_${TMP}" PARENT_SCOPE)
endfunction ()

# ****************************************************************************
# \function sbia_update_cached_template
# \brief    Get filename of cached template file.
#
# \param [in]  REL      Path of project file relative to project source directory.
# \param [out] TEMPLATE Absolute path of cached template file in binary tree
#                       of project.

function (sbia_update_cached_template REL TEMPLATE)
  # URL of template file
  set (SRC "${PROJECT_TEMPLATE_ROOT}/${PROJECT_TEMPLATE}/${REL}")

  # get revision of template file. If no revision number can be determined,
  # we either did not find the svn client or the file referenced by SRC
  # is not a repository. However, if it is a working copy, we will still
  # get a revision number. Thus, we then need to check if SRC is a URL
  # starting with 'https://sbia-svn/ or not (see below).
  sbia_svn_get_last_changed_revision ("${SRC}" REV)

  if (REV GREATER 0)
    sbia_svn_status ("${SRC}" STATUS)
    if (NOT "${STATUS}" STREQUAL "")
      set (REV "0") # under revision control, but locally modified
    endif ()
  else ()
    set (REV "-") # not under revision control (or non-existent)
  endif ()

  # file name of cached template file in binary tree of project
  set (${TEMPLATE} "${PROJECT_BINARY_DIR}/${REL}.rev${REV}" PARENT_SCOPE)
endfunction ()

# ----------------------------------------------------------------------------
# update helpers
# ----------------------------------------------------------------------------

# ****************************************************************************
# \function sbia_update_clear
# \brief    Removes cached template files from binary tree.
#
# This function is used by sbia_update_template () to remove cached template
# copies of a particular file in the binary tree when no longer needed.
#
# \see sbia_update_template ()
#
# \param [in] REL  Path of the project file whose template copies shall be
#                  removed relative to the project's source directory.
# \param [in] ARGN Absolute paths of cached template files to preserve.

function (sbia_update_clear REL)
  # collect all cached template files
  file (GLOB FILES "${PROJECT_BINARY_DIR}/${REL}.rev*")
  # remove files which are to be preserved
  if (FILES)
    foreach (ARG ${ARGN})
      list (REMOVE_ITEM FILES ${ARG})
    endforeach ()
  endif ()
  # remove files
  if (FILES)
    file (REMOVE ${FILES})
  endif ()
endfunction ()

# ****************************************************************************
# \function sbia_update_template
# \brief    Retrieves latest revision of template file.
#
# \param [in]  REL      Path of project/template file relative to project source tree.
# \param [in]  TEMPLATE Absolute path of cached template file in binary tree of project.
# \param [out] RETVAL   Boolean variable which indicates success or failure.

function (sbia_update_template REL TEMPLATE RETVAL)

  # URL of template file
  set (SRC "${PROJECT_TEMPLATE_ROOT}/${PROJECT_TEMPLATE}/${REL}")

  # if template file is not under revision control or has local modifications
  # we cannot use caching as there is no unique revision number assigned
  if (TEMPLATE MATCHES ".*\\.rev[0|-]")

    # remove previously exported/downloaded template files
    sbia_update_clear ("${REL}")

    # download template file from non-revision controlled template
    file (DOWNLOAD "${SRC}" "${TEMPLATE}" TIMEOUT 30 STATUS RET)
    list (GET RET 0 RET)

  # if cached file not available, retrieve it from repository or working copy
  elseif (NOT EXISTS "${TEMPLATE}")

    # remove previously exported/downloaded revisions
    sbia_update_clear ("${REL}")

    # if template URL is SVN repository, export file using SVN client
    if ("${SRC}" MATCHES "https://sbia-svn/.*")
      execute_process (
        COMMAND         "${SBIA_CMD_SVN}" export "${SRC}" "${TEMPLATE}"
        TIMEOUT         30
        RESULT_VARIABLE RET
        OUTPUT_QUIET
        ERROR_QUIET
      )
    # otherwise, download file
    else ()
      file (DOWNLOAD "${SRC}" "${TEMPLATE}" TIMEOUT 30 STATUS RET)
      list (GET RET 0 RET)
    endif ()
  else ()
    sbia_update_clear ("${REL}" "${TEMPLATE}")
	set (RET 0)
  endif ()

  # return value
  if (RET EQUAL 0)
    set (${RETVAL} 1 PARENT_SCOPE)
  else ()
    set (${RETVAL} 0 PARENT_SCOPE)
  endif ()
endfunction ()

# ****************************************************************************
# \function sbia_update_files
# \brief    Update files listed in SBIA_UPDATE_FILES for which file
#           update option exists and is ON or SBIA_UPDATE_ALL is ON.
#
# This function attempts to update all files in SBIA_UPDATE_FILES
# whose file update option is ON. If the option SBIA_UPDATE_ALL is ON,
# the file update options of individual files are ignored and all files
# are updated. It is called by sbia_update_initialize ().
#
# The list SBIA_UPDATE_FILES is populated by the function sbia_update ()
# and the file update options for the listed files are added by
# sbia_update_finalize () if SBIA_UPDATE_QUIET is OFF. Otherwise,
# the files are updated directly by sbia_update_finalize () if possible.
#
# \see sbia_update_initialize ()
# \see sbia_update_finalize ()

function (sbia_update_files)
  if (NOT SBIA_UPDATE)
    return ()
  endif ()

  set (FILES ${SBIA_UPDATE_FILES})

  if (FILES)
    list (REMOVE_DUPLICATES FILES)
  endif ()

  foreach (REL ${FILES})

    # absolute path of project file
    set (CUR "${PROJECT_SOURCE_DIR}/${REL}")

    # if project file exists, check if it is under revision control and
	# whether it has local modifications
    if (EXISTS "${CUR}")
      sbia_svn_status (${CUR} CURSTATUS)
    else ()
      set (CURSTATUS "")
    endif ()

    # get name of cached template file
    sbia_update_cached_template ("${REL}" TMP)

    # if cached template file exists...
    if (EXISTS "${TMP}")
 
      sbia_update_option ("${REL}" OPT) # name of file update option

      # ...and file update option is ON
      if ("${${OPT}}" STREQUAL "ON" OR "${SBIA_UPDATE_ALL}" STREQUAL "ON")

        if (CMAKE_VERBOSE)
          message (STATUS "Updating file '${REL}'...")
        endif ()

        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # project file has local modifications
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        if (NOT "${CURSTATUS}" STREQUAL "")

          message ("File '${REL}' has local modifications. Modifications must be committed or reverted before file can be updated.")

          if ("${${OPT}}" STREQUAL "ON")
            message ("Setting ${OPT} to OFF.")
            set (${OPT} "OFF" CACHE BOOL "Whether file '${REL}' should be updated." FORCE)
          endif ()

          if (CMAKE_VERBOSE)
            message (STATUS "Updating file '${REL}'... - failed")
          endif ()

        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # project file has NO local modifications
        # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        else ()

          execute_process (
            COMMAND
              "${SBIA_CMD_PYTHON}" "${SBIA_UPDATE_SCRIPT}" -f -i "${CUR}" -t "${TMP}" -o "${CUR}"
            RESULT_VARIABLE
              RETVAL
            OUTPUT_QUIET
            ERROR_QUIET
          )

          if (RETVAL EQUAL 0 OR RETVAL EQUAL 2)
            list (REMOVE_ITEM FILES "${REL}")
            set (${OPT} "" CACHE INTERNAL "Unused option." FORCE)
          endif ()

          if (RETVAL EQUAL 0)
            message ("Updated file '${REL}'")
          elseif (NOT RETVAL EQUAL 2)
            message ("Failed to update file '${REL}'")
          endif ()

          if (CMAKE_VERBOSE)
            if (RETVAL EQUAL 0)
              message (STATUS "Updating file '${REL}'... - done")
            elseif (RETVAL EQUAL 2)
              message (STATUS "Updating file '${REL}'... - up-to-date")
            else ()
              message (STATUS "Updating file '${REL}'... - failed")
            endif ()
          endif ()
  
        endif ()
      endif ()
    endif ()

  endforeach ()

  set (SBIA_UPDATE_FILES ${FILES} CACHE INTERNAL "Files to be updated." FORCE)

  # reset option SBIA_UPDATE_ALL
  if (FILES)
    if ("${SBIA_UPDATE_ALL}" STREQUAL "ON")
      message ("Setting SBIA_UPDATE_ALL to OFF.")
      set (SBIA_UPDATE_ALL "OFF" CACHE BOOL "Whether all files should be updated." FORCE)
    endif ()
  else ()
    set (SBIA_UPDATE_ALL "" CACHE INTERNAL "Unused option." FORCE)
  endif ()
endfunction ()


endif (NOT SBIA_UPDATE_INCLUDED)

