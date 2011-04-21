##############################################################################
# \file  CMakeLists.txt
# \brief CMakeLists.txt file of Boost.Program_options library.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See LICENSE or Copyright file in project root directory for details.
#
# Contact: SBIA Group <sbia-software -at- uphs.upenn.edu>
##############################################################################

set (
  SOURCES
    cmdline
    config_file
    options_description
    parsers
    variables_map
    value_semantic
    positional_options
    utf8_codecvt_facet
    convert
    winmain
    split
)

set (PO_SOURCES "")
foreach (SOURCE ${SOURCES})
  list (APPEND PO_SOURCES "src/${SOURCE}.cpp") 
endforeach ()

sbia_add_library (boost_program_options STATIC ${PO_SOURCES})

