# (c) Copyright 2012 Carnegie Mellon University
# @author Andrew Hundt <ATHundt@gmail.com>
#
# FUNCTION: mesh_append_to_each(output_list input_list item_to_append <>)
#
# mesh_append_to_each takes an input list and appends a single element to each item in that list and adds it to the output list.
#                For example, this is useful for adding relative paths to the end of a list of paths.
#
function(mesh_append_to_each OUTPUT_LIST INPUT_LIST ITEM_TO_APPEND)
  set(${OUTPUT_LIST} "")
  foreach(PATH IN LISTS ${INPUT_LIST})
    list(APPEND ${OUTPUT_LIST} ${PATH}${ITEM_TO_APPEND} )
  endforeach()
  set(${OUTPUT_LIST} ${${OUTPUT_LIST}} PARENT_SCOPE)
endfunction()

