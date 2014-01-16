# Macros for use with the Vc library. Vc can be found at http://code.compeng.uni-frankfurt.de/projects/vc
#
#=============================================================================
# Copyright 2009-2012   Matthias Kretz <kretz@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file CmakeCopyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

macro(UserWarning _msg)
   if("$ENV{DASHBOARD_TEST_FROM_CTEST}" STREQUAL "")
      # developer (non-dashboard) build
      message(WARNING "${_msg}")
   else()
      # dashboard build
      message(STATUS "${_msg}")
   endif()
endmacro()
