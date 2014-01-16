#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

##########################################################
# ------- VariableCheck ---------------
##########################################################
#
# VariableCheck checks for a list of variables 
# required later in the script and produces a clear error 
# message explaining the problem and how to fix it if they 
# are not present.
#  
# Multi Arg Params:
#
#     REQUIRED                  - List of variables that MUST be set to run this script correctly. 
#                                 Will produce a FATAL_ERROR message explaining which variables 
#                                 are misisng and exit the cmake script.
#
#     OPTIONAL                  - List of variables that be OPTIONALLY set to run this script with additional features. 
#                                 Will produce an AUTHOR_WARNING message explaining which variables 
#                                 are misisng and continue running the cmake script.
#
# Example:
#
#     mesh_variable_check(
#        REQUIRED
#           LIBRARY1_INCLUDE_DIRS
#           LIBRARY2_INCLUDE_DIRS
#           LIBRARY2_LIBRARIES
#        OPTIONAL
#           LIBRARY3_INCLUDE_DIRS
#           LIBRARY3_LIBRARIES
#     )
#
##########################################################
function(mesh_variable_check)

  set(options ) # currently none
  set(oneValueArgs ) # currently none
  set(multiValueArgs REQUIRED OPTIONAL )
  cmake_parse_arguments(VARIABLE_CONFIGURATION "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  
  set(MISSING_REQUIRED_VARIABLES)

  foreach(VARIABLE_NAME IN LISTS VARIABLE_CONFIGURATION_REQUIRED)
     if(NOT ${VARIABLE_NAME})
        list(APPEND MISSING_REQUIRED_VARIABLES ${VARIABLE_NAME})
     endif()
  endforeach()
  
  
  if(MISSING_REQUIRED_VARIABLES)
    set(MISSING_VARIABLES_ERROR "The following variables are marked as REQUIRED but they are not set to a valid value. Please define the variables correctly in your cmake script or on the command line using -D.")
    foreach(VARIABLE_NAME IN LISTS MISSING_REQUIRED_VARIABLES)
       if(DEFINED ${VARIABLE_NAME})
          set(MISSING_VARIABLES_ERROR "${MISSING_VARIABLES_ERROR}\n  variable name: ${VARIABLE_NAME}  value: ${${VARIABLE_NAME}}")
       else()
          set(MISSING_VARIABLES_ERROR "${MISSING_VARIABLES_ERROR}\n  variable name: ${VARIABLE_NAME}  value is not defined")
       endif()
    endforeach()

    message(FATAL_ERROR "${MISSING_VARIABLES_ERROR}")
  endif(MISSING_REQUIRED_VARIABLES)
  
  
  set(MISSING_OPTIONAL_VARIABLES)

  foreach(VARIABLE_NAME IN LISTS VARIABLE_CONFIGURATION_OPTIONAL)
     if(NOT ${VARIABLE_NAME})
        list(APPEND MISSING_OPTIONAL_VARIABLES ${VARIABLE_NAME})
     endif()
  endforeach()
  
  
  if(MISSING_OPTIONAL_VARIABLES)
    set(MISSING_VARIABLES_WARNING "The following variables are marked as OPTIONAL but they are not set to a valid value. Please define the variables correctly in your cmake script or on the command line using -D.")
    foreach(VARIABLE_NAME IN LISTS MISSING_OPTIONAL_VARIABLES)
       if(DEFINED ${VARIABLE_NAME})
          set(MISSING_VARIABLES_WARNING "${MISSING_VARIABLES_WARNING}\n  variable name: ${VARIABLE_NAME}  value: ${${VARIABLE_NAME}}")
       else()
          set(MISSING_VARIABLES_WARNING "${MISSING_VARIABLES_WARNING}\n  variable name: ${VARIABLE_NAME}  value is not defined")
       endif()
    endforeach()

    message(AUTHOR_WARNING "${MISSING_VARIABLES_WARNING}")
  endif(MISSING_OPTIONAL_VARIABLES)
  

endfunction(mesh_variable_check)