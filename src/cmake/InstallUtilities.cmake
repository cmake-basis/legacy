#
# Copyright (c) 2012
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

# ------- patterns to exclude from the install directory ---------------
set (MESH_INSTALL_DIRECTORY_EXCLUDE_PATTERNS
	PATTERN "CVS" EXCLUDE
	PATTERN ".svn" EXCLUDE
	PATTERN ".hg" EXCLUDE
	PATTERN "benchmark_tests" EXCLUDE
	PATTERN "SConscript" EXCLUDE
	PATTERN "doxyfile" EXCLUDE
	PATTERN "info.dox" EXCLUDE
	PATTERN "obj" EXCLUDE
	PATTERN "doc" EXCLUDE
)

set(MESH_INSTALL_DIRECTORY_EXCLUDE_UNIT_TESTS
	PATTERN "unit_tests" EXCLUDE
)
set (MESH_INSTALL_DIRECTORY_EXCLUDE_SOURCE
  PATTERN "*.c*" EXCLUDE
)
