#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

# given a list of paths to files, 
# get the set of dirs contain those files
# Note: GetFilePaths removes duplicate paths
#
# This function is particularly useful for setting a 
# libraryName_LIBRARY_DIRS variable in a Find Script.
function(GetFilePaths OUTPUT_PATHS INPUT_FILES)
      set(${OUTPUT_PATHS} "")

      foreach(SINGLE_FILE IN LISTS ${INPUT_FILES})
        get_filename_component(FILE_PATH ${SINGLE_FILE} PATH)
        list(APPEND ${OUTPUT_PATHS} ${FILE_PATH})
        
        # uncomment to debug
        #message(AUTHOR_WARNING "SINGLE_FILE:${SINGLE_FILE} SINGLE_PATH:${FILE_PATH} OUTPUT_PATHS:${${OUTPUT_PATHS}}")

      endforeach()
      list(REMOVE_DUPLICATES ${OUTPUT_PATHS})
      set(${OUTPUT_PATHS} ${${OUTPUT_PATHS}} PARENT_SCOPE)

      # uncomment to debug
      #message(AUTHOR_WARNING "${OUTPUT_PATHS}:${${OUTPUT_PATHS}}")

endfunction(GetFilePaths OUTPUT_PATHS INPUT_FILES)
