##############################################################################
# \file  CMakeLists.txt
# \brief Configure and install CMake modules.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

set (
  MODULES
    SbiaCommands.cmake
    SbiaMacros.cmake
    SbiaSettings.cmake
    SbiaPackage.cmake
    SbiaTesting.cmake
    SbiaUpdate.cmake
)

set (
  FIND_MODULES
    FindNiftiCLib.cmake
    FindMatlabNiftiTools.cmake
)

set (
  AUXILIARY_FILES
    CMakeParseArguments.cmake
    SbiaExecuteProcess.cmake
    SbiaUpdateFile.py
    SbiaRunMcc.m
    execname.cpp.in
)

install (
  FILES
    ${MODULES}
    ${FIND_MODULES}
    ${AUXILIARY_FILES}
  DESTINATION
    "cmake"
)

