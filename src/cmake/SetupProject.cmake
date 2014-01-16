#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

# Standard CMake includes
include(ExternalProject)

# CMakeMesh includes
include(CMakeParseArguments)
include(${CMAKE_MESH_PATH}/FindIfEnabled.cmake)
include(${CMAKE_MESH_PATH}/SetupDoxygen.cmake)
include(${CMAKE_MESH_PATH}/SetupConfigHeader.cmake)
include(${CMAKE_MESH_PATH}/SetupBuildOutputDirectories.cmake)
include(${CMAKE_MESH_PATH}/SetupCMakeOptions.cmake)
include(${CMAKE_MESH_PATH}/SetupCompilerFlags.cmake)
include(${CMAKE_MESH_PATH}/SetupPackages.cmake)


##########################################################
# ------- Setup Testing ---------------
##########################################################
#
# mesh_setup_unit_testing sets up unit tests
#
macro(mesh_setup_unit_testing)
# ------- Enable the CTest testing. Use make test to run all tests ---------------
    INCLUDE(CTest)
    option(BUILD_TESTING "Build Testing" ON)
    option(BENCHMARK_TESTING "Benchmark Testing" OFF)
endmacro(mesh_setup_unit_testing)


##########################################################
# ------- mesh_setup_project ---------------
##########################################################
#
# mesh_setup_project takes all the steps necessary for basic 
# project setup, calling other setup functions.
# This simplifies low level cmake variable and package 
# configuration down to a single configurable function. 
#  
# Options:
#
#   -- Packaging --
#
#      ALL_PACKAGES                  - Find all supported packages
#      NO_PACKAGES                   - Suppress warning message if no packages are searched for 
#      AUTO_FIND_PACKAGES            - Attempt to automatically find any packages listed under FIND_PACKAGES that not supported, 
#                                      this may cause cmake setup to fail if the package does not set the right include and found variables.
#
#
#   -- Compilation Flags --
#
#      C++11                         - Enable C++11 if it is supported
#
#      INSTALL_CONFIG_HEADER         - Installs a project configuration header into MESH_INCLUDE_INSTALL_DIRECTORY
#
#      NO_CXX_FLAGS                  - Disable compiler flag performance optimizations.
#                                      mesh_setup_project automatically optimizes compiler flags for your build platform, this option disables that functionality.
#                                      See mesh_setup_compiler_flags.cmake
#      NO_CONFIG_HEADER              - disables config-ix.cmake which set system configuration variables and generates config.h header
#      NO_WARNING_FLAGS              - Disables addedn compiler warning flags, reduces code safety,  See mesh_setup_compiler_flags.cmake
#      NO_BUILDTYPE_FLAGS            - Disables default build configuration such as DEBUG and RELEASE that 
#                                      can be set with ccmake or cmake gui. 
#                                      See mesh_setup_compiler_flags.cmake for a complete list of settings available by default.
#
#      NO_INCLUDE_DIRECTORIES  - disables calls to include_directories() in mesh_setup_project. All included directories must be specified manually using the package directory variables.
#
# Single Arg Params:
#      
#      TARGET_ARCHITECTURE           - CPU architecture to optimize for. See mesh_setup_compiler_flags.cmake for a list of available settings.
#                                      The default value \"auto\" will try to optimize for the 
#                                      architecture on which cmake was called.
#                                      WARNING: Using an incorrect setting here can result in crashes 
#                                      of the resulting binary because of invalid instructions used.
#
# Multi Arg Params:
#
#   Packages:
#     FIND_PACKAGES                  - call find_package(PACKAGE_NAME) and set found variables, include directories, etc. in a uniform, compatible manner
#
#     EXTERNAL_PROJECT_ADD           - call ExternalProject_Add script to build the package and set configuration plus found variables. See External_OpanCV.cmake for an example.
#
# Example demo:
#
#   SETUP_EXAMPLES                - Enables Example Mode for a small example project >>NOT FOR PRODUCTION USE<<
#
##########################################################
macro(mesh_setup_project)

  if(NOT ${ARGC})
    message(STATUS "Warning: mesh_setup_project() called without parameters, so no packages will be searched for.")
    message(STATUS "                             If this is intentional pass NO_PACKAGES instead.")
    message(STATUS "                             other options include ALL_PACKAGES and FIND_PACKAGES <pkg1> <pkg2> ... <pkgN>")
  endif()  

  set(options 
      ALL_PACKAGES 
      NO_PACKAGES  
      AUTO_FIND_PACKAGES  
      INSTALL_CONFIG_HEADER  
      SETUP_EXAMPLES  
      NO_CXX_FLAGS  
      NO_BUILDTYPE_FLAGS  
      NO_WARNING_FLAGS
      C++11
      NO_CONFIG_HEADER
      NO_INCLUDE_DIRECTORIES
  )
  set(oneValueArgs TARGET_ARCHITECTURE) # currently none
  set(multiValueArgs FIND_PACKAGES EXTERNAL_PROJECT_ADD)
  cmake_parse_arguments(SETUP_PROJECT "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  
  if(NOT SETUP_PROJECT_NO_CONFIG_HEADER)
    include(config-ix) # set system configuration variables and config.h header
  endif()
  
  # set the variable for each package that is enabled
  foreach(PACKAGE_NAME IN LISTS SETUP_PROJECT_FIND_PACKAGES)
    set(SETUP_PROJECT_${PACKAGE_NAME} TRUE)
  endforeach()
  
  # set the name of the install config header option for passing to another function
  if(SETUP_PROJECT_INSTALL_CONFIG_HEADER)
    set(INSTALL_CONFIG_HEADER_OPTION INSTALL_CONFIG_HEADER)
  endif(SETUP_PROJECT_INSTALL_CONFIG_HEADER)
  
  
  # set the name of the install config header options for passing to another function
  if(SETUP_PROJECT_NO_CXX_FLAGS)
    set(NO_CXX_FLAGS_OPTION NO_CXX_FLAGS)
  endif(SETUP_PROJECT_NO_CXX_FLAGS)

  if(SETUP_PROJECT_C++11)
    set(C++11_OPTION C++11)
  endif(SETUP_PROJECT_C++11)
  
  if(SETUP_PROJECT_NO_INCLUDE_DIRECTORIES)
    set(NO_INCLUDE_DIRECTORIES_OPTION NO_INCLUDE_DIRECTORIES)
  endif(SETUP_PROJECT_NO_INCLUDE_DIRECTORIES)

  # Note: WARNING_FLAGS in mesh_setup_compiler_flags enables warnings,
  #       while mesh_setup_project enables it by default and 
  #       NO_WARNINGS_FLAGS disables the warnings
  if(NOT SETUP_PROJECT_NO_WARNING_FLAGS)
    set(WARNING_FLAGS_OPTION WARNING_FLAGS)
  endif(NOT SETUP_PROJECT_NO_WARNING_FLAGS)

  # Note: BUILDTYPE_FLAGS in mesh_setup_compiler_flags enables warnings,
  #       while mesh_setup_project enables it by default and 
  #       NO_BUILDTYPE_FLAGS disables the warnings
  if(NOT SETUP_PROJECT_NO_BUILDTYPE_FLAGS)
    set(BUILDTYPE_FLAGS_OPTION BUILDTYPE_FLAGS)
  endif(NOT SETUP_PROJECT_NO_BUILDTYPE_FLAGS)

  if(SETUP_PROJECT_TARGET_ARCHITECTURE)
    set(TARGET_ARCHITECTURE_OPTION "TARGET_ARCHITECTURE ${SETUP_PROJECT_TARGET_ARCHITECTURE}")
  endif(SETUP_PROJECT_TARGET_ARCHITECTURE)
  
    mesh_setup_cmake_options()
    mesh_setup_compiler_flags(${NO_CXX_FLAGS_OPTION} ${TARGET_ARCHITECTURE_OPTION} ${WARNING_FLAGS_OPTION} ${BUILDTYPE_FLAGS_OPTION} ${C++11_OPTION})
    mesh_setup_build_output_directories()
    SetupConfigHeader(${INSTALL_CONFIG_HEADER_OPTION})
    
    mesh_setup_packages(${NO_INCLUDE_DIRECTORIES_OPTION} FIND_PACKAGES ${SETUP_PROJECT_FIND_PACKAGES} EXTERNAL_PROJECT_ADD ${SETUP_PROJECT_EXTERNAL_PROJECT_ADD})
    mesh_setup_unit_testing()
    
    #########################################
    # begin  >>NOT FOR PRODUCTION USE<<     #
    # This block is code used in examples   #
    # that isn't called by default,         #
    # and isn't useful in production        #
    #########################################
    # setup example tree                    #
    if(SETUP_PROJECT_SETUP_EXAMPLES)        #
      include(SetupExamples)                #
      SetupExamples()                       #
    endif(SETUP_PROJECT_SETUP_EXAMPLES)     #
    # end  >>NOT FOR PRODUCTION USE<<       #
    #########################################
    
    # Attempt to automatically find all remaining packages that have not yet been found
    if(SETUP_PROJECT_AUTO_FIND_PACKAGES)
      # if packages do not have any manual setup or configuration scripts, try to find it automatically
      foreach(PACKAGE_NAME IN LISTS SETUP_PROJECT_FIND_PACKAGES)
        # only find if it is not already found
        string(TOUPPER ${PACKAGE_NAME} PACKAGE_NAME_UPPER)
        if(NOT ${PACKAGE_NAME_UPPER}_FOUND AND NOT ${PACKAGE_NAME}_FOUND)
            # try to find modules that are not found, and add them as a subdirectory if they have that capability
            mesh_find_if_enabled(
              INCLUDE_PACKAGE_DIR
              FIND_PACKAGE_AS_SUBDIRECTORY
                ${PACKAGE_NAME}
            )
        endif(NOT ${PACKAGE_NAME_UPPER}_FOUND AND NOT ${PACKAGE_NAME}_FOUND)
      endforeach()
    endif(SETUP_PROJECT_AUTO_FIND_PACKAGES)
    
    mesh_setup_doxygen()
endmacro(mesh_setup_project)
