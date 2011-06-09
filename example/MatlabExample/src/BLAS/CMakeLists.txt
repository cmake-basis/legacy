##############################################################################
# \file  CMakeLists.txt
# \brief Build BLAS library.
#
# This CMake file can be configured to build and/or install required
# thirdpary libraries which are bundled with this software package.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See COPYING file in project root or 'doc' directory for details.
#
# Contact: SBIA Group <sbia-software@uphs.upenn.edu>
##############################################################################

set (
  BLAS_SOURCES
    blas.h
    blasp.h
    daxpy.c
    ddot.c
    dnrm2.c
    dscal.c
)

basis_add_library (BLAS STATIC EXTERNAL ${BLAS_SOURCES})

# position independent code required for build of MEX-files
basis_set_target_properties (
  BLAS
  PROPERTIES
    COMPILE_FLAGS "-fPIC"
)
