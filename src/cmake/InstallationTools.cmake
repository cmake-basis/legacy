##############################################################################
# @file  InstallationTools.cmake
# @brief CMake functions used for installation.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See https://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
#
# @ingroup CMakeTools
##############################################################################

## @addtogroup CMakeUtilities
# @{


# ============================================================================
# Installation
# ============================================================================

# ----------------------------------------------------------------------------
## @brief Replaces CMake's install() command.
#
# @sa http://www.cmake.org/cmake/help/cmake-2-8-docs.html#command:install
function (basis_install)
  install (${ARGN})
endfunction ()

# ----------------------------------------------------------------------------
## @brief Install content of current source directory excluding typical files.
#
# @param [in] DESTINATION Destination directory.
# @param [in] ARGN        Further arguments for CMake's install(DIRECTORY) command.
function (basis_install_directory DESTINATION)
  install (
    DIRECTORY   "${CMAKE_CURRENT_SOURCE_DIR}/"
    DESTINATION "${DESTINATION}"
    ${ARGN}
    PATTERN     CMakeLists.txt EXCLUDE
    PATTERN     *~             EXCLUDE
    PATTERN     .svn           EXCLUDE
    PATTERN     .git           EXCLUDE
    PATTERN     .DS_Store      EXCLUDE
  )
endfunction ()

# ----------------------------------------------------------------------------
## @brief Add installation command for creation of a symbolic link.
#
# @param [in] OLD  The value of the symbolic link.
# @param [in] NEW  The name of the symbolic link.
#
# @returns Adds installation command for creating the symbolic link @p NEW.
function (basis_install_link OLD NEW)
  # Attention: CMAKE_INSTALL_PREFIX must be used instead of INSTALL_PREFIX.
  set (CMD_IN
    "
    set (OLD \"@OLD@\")
    set (NEW \"@NEW@\")

    if (NOT IS_ABSOLUTE \"\${OLD}\")
      set (OLD \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/\${OLD}\")
    endif ()
    if (NOT IS_ABSOLUTE \"\${NEW}\")
      set (NEW \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/\${NEW}\")
    endif ()

    if (IS_SYMLINK \"\${NEW}\")
      file (REMOVE \"\${NEW}\")
    endif ()

    if (EXISTS \"\${NEW}\")
      message (STATUS \"Skipping: \${NEW} -> \${OLD}\")
    else ()
      message (STATUS \"Installing: \${NEW} -> \${OLD}\")

      get_filename_component (SYMDIR \"\${NEW}\" PATH)

      file (RELATIVE_PATH OLD \"\${SYMDIR}\" \"\${OLD}\")

      if (NOT EXISTS \${SYMDIR})
        file (MAKE_DIRECTORY \"\${SYMDIR}\")
      endif ()

      execute_process (
        COMMAND \"${CMAKE_COMMAND}\" -E create_symlink \"\${OLD}\" \"\${NEW}\"
        RESULT_VARIABLE RETVAL
      )

      if (NOT RETVAL EQUAL 0)
        message (ERROR \"Failed to create (symbolic) link \${NEW} -> \${OLD}\")
      else ()
        list (APPEND CMAKE_INSTALL_MANIFEST_FILES \"\${NEW}\")
      endif ()
    endif ()
    "
  )

  string (CONFIGURE "${CMD_IN}" CMD @ONLY)
  install (CODE "${CMD}")
endfunction ()

# ----------------------------------------------------------------------------
## @brief Adds installation command for creation of symbolic links.
#
# This function creates for each main executable a symbolic link directly
# in the directory @c INSTALL_PREFIX/bin if @c INSTALL_SINFIX is TRUE and the
# software is installed on a Unix-based system, i.e., one which
# supports the creation of symbolic links.
#
# @returns Adds installation command for creation of symbolic links in the
#          installation tree.
function (basis_install_links)
  if (NOT UNIX)
    return ()
  endif ()

  # main executables
  basis_get_project_property (TARGETS)
  foreach (TARGET_UID ${TARGETS})
    get_target_property (IMPORTED ${TARGET_UID} "IMPORTED")

    if (NOT IMPORTED)
      get_target_property (BASIS_TYPE ${TARGET_UID} "BASIS_TYPE")
      get_target_property (LIBEXEC    ${TARGET_UID} "LIBEXEC")
      get_target_property (TEST       ${TARGET_UID} "TEST")

      if (BASIS_TYPE MATCHES "EXECUTABLE" AND NOT LIBEXEC AND NOT TEST)
        get_target_property (SYMLINK_NAME ${TARGET_UID} "SYMLINK_NAME")
        if (NOT "${SYMLINK_NAME}" MATCHES "^none$|^None$|^NONE$")
          get_target_property (SYMLINK_PREFIX ${TARGET_UID} "SYMLINK_PREFIX")
          get_target_property (SYMLINK_SUFFIX ${TARGET_UID} "SYMLINK_SUFFIX")
          get_target_property (INSTALL_DIR    ${TARGET_UID} "RUNTIME_INSTALL_DIRECTORY")

          basis_get_target_location (OUTPUT_NAME ${TARGET_UID} NAME)

          if (NOT SYMLINK_NAME)
            set (SYMLINK_NAME "${OUTPUT_NAME}")
          endif ()
          if (SYMLINK_PREFIX)
            set (SYMLINK_NAME "${SYMLINK_PREFIX}${SYMLINK_NAME}")
          endif ()
          if (SYMLINK_SUFFIX)
            set (SYMLINK_NAME "${SYMLINK_NAME}${SYMLINK_SUFFIX}")
          endif ()

          # avoid creation of symbolic link if there would be a conflict with
          # the subdirectory in bin/ where the actual executables are installed
          if (INSTALL_SINFIX AND "${SYMLINK_NAME}" STREQUAL "${BASIS_INSALL_SINFIX}")
            message (STATUS \"Skipping: ${INSTALL_DIR}/${OUTPUT_NAME} -> ${INSTALL_PREFIX}/bin/${SYMLINK_NAME}\")
          else ()
            basis_install_link (
              "${INSTALL_DIR}/${OUTPUT_NAME}"
              "bin/${SYMLINK_NAME}"
            )
          endif ()
        endif ()
      endif ()
    endif ()
  endforeach ()

  # documentation
  # Note: Not all CPack generators preserve symbolic links to directories
  # Note: This is not part of the filesystem hierarchy standard of Linux,
  #       but of the standard of certain distributions including Ubuntu.
  if (INSTALL_SINFIX AND BASIS_INSTALL_SINFIX)
    basis_install_link (
      "${INSTALL_DOC_DIR}"
      "share/doc/${BASIS_INSTALL_SINFIX}"
    )
  endif ()
endfunction ()

# ============================================================================
# Deinstallation
# ============================================================================

# ----------------------------------------------------------------------------
## @brief Add uninstall target.
#
# @returns Adds the custom target @c uninstall and code to cmake_install.cmake
#          to install an uninstaller.
function (basis_add_uninstall)
  # add uninstall target
  configure_file (
    ${BASIS_MODULE_PATH}/cmake_uninstall.cmake.in
    ${PROJECT_BINARY_DIR}/cmake_uninstall.cmake
    @ONLY
  )
  add_custom_target (
    uninstall
    COMMAND ${CMAKE_COMMAND} -P "${PROJECT_BINARY_DIR}/cmake_uninstall.cmake"
    COMMENT "Uninstalling..."
  )
endfunction ()


## @}
# end of Doxygen group
