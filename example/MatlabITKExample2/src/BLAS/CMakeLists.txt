##############################################################################
# \file  CMakeLists.txt
# \brief Build BLAS library.
#
# This CMake file can be configured to build and/or install required
# thirdpary libraries which are bundled with this software package.
#
# For copyright information please see Copyright.txt in the root
# directory of the project.
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
