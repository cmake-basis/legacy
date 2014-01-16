# (c) Copyright 2012-2013 Carnegie Mellon University
# @author Andrew Hundt <ATHundt@gmail.com>

set(AUTO_PRECOMPILED_HEADERS OFF CACHE BOOL "Use 'cotire' utility to automatically use precompiled headers to help accelerate compile time. https://github.com/sakra/cotire")
if(AUTO_PRECOMPILED_HEADERS)
 include(cotire)
endif(AUTO_PRECOMPILED_HEADERS)

# ------- Example creation function from list ---------------
# Function for making a list of Examples
function(mesh_make_executables FILE_NAME_LIST )
   # loop over each file name with the variable FILE_NAME
   foreach(FILE_NAME ${${FILE_NAME_LIST}}) 
     get_filename_component(MODULE_NAME ${FILE_NAME} NAME_WE )
     add_executable(${MODULE_NAME} ${FILE_NAME})
           
     if(AUTO_PRECOMPILED_HEADERS)
       cotire(${MODULE_NAME})
     endif(AUTO_PRECOMPILED_HEADERS)

     target_link_libraries( ${MODULE_NAME}
      ${ARGN} # ARGN expands to the remaining arguments for the macro
     )

   endforeach(FILE_NAME)

endfunction(mesh_make_executables)


# ------- Append to list of libraries for this project ---------------
macro(mesh_add_library_to_project LIBRARY_NAME)
  # TODO: There is a bug where on multiple sequential executions of cmake the library list begins to repeat itself. If a library is removed it will currently still remain.
  # TODO: improve efficiency of this implementation, make it cleaner. Currently it forces the variable's value so that it is always updated at global scope
  set(${PROJECT_NAME}_LIBRARIES ${${PROJECT_NAME}_LIBRARIES} ${LIBRARY_NAME} CACHE STRING "List of libraries from project ${PROJECT_NAME}" FORCE)
  add_library(${LIBRARY_NAME} ${ARGN})
  
  if(AUTO_PRECOMPILED_HEADERS)
    cotire(${LIBRARY_NAME})
  endif(AUTO_PRECOMPILED_HEADERS)
  
  #debug for this function:
  #message(STATUS "${PROJECT_NAME}_LIBRARIES: ${${PROJECT_NAME}_LIBRARIES}")
endmacro(mesh_add_library_to_project)


# ------- Create QT4 Binary ---------------
function(makeQT4Binary EXECUTABLE_NAME SOURCE_FILE_NAME_LIST MOC_HEADER_LIST )
  # TODO: Remove workaround for moc Boost conflict when a fix has been found. See: https://bugreports.qt.nokia.com/browse/QTBUG-22829    workaround: OPTIONS -DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED
  qt4_wrap_cpp(MOC_SRCS_LIST ${${MOC_HEADER_LIST}} OPTIONS -DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED)
  add_executable(${EXECUTABLE_NAME} ${${SOURCE_FILE_NAME_LIST}} ${MOC_SRCS_LIST})
  
  if(AUTO_PRECOMPILED_HEADERS)
    cotire(${MODULE_NAME})
  endif(AUTO_PRECOMPILED_HEADERS)
  target_link_libraries(${EXECUTABLE_NAME} ${ARGN})
endfunction(makeQT4Binary)


# ------- Create QT4 Library ---------------
function(makeQT4Library LIBRARY_NAME SOURCE_FILE_NAME_LIST MOC_HEADER_LIST )
  # TODO: Remove workaround for moc Boost conflict when a fix has been found. See: https://bugreports.qt.nokia.com/browse/QTBUG-22829    workaround: OPTIONS -DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED
  qt4_wrap_cpp(MOC_SRCS_LIST ${${MOC_HEADER_LIST}} OPTIONS -DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED)
  mesh_add_library_to_project(${LIBRARY_NAME} ${${SOURCE_FILE_NAME_LIST}} ${MOC_SRCS_LIST})
endfunction(makeQT4Library)

# ------- Example creation function from list ---------------
# Function for making a list of Examples
function(makeExamples FILE_NAME_LIST)
   # loop over each file name with the variable FILE_NAME
   foreach(FILE_NAME ${${FILE_NAME_LIST}}) 
  	 get_filename_component(MODULE_NAME ${FILE_NAME} NAME_WE )
	   add_executable(${MODULE_NAME} ${FILE_NAME})
           
         if(AUTO_PRECOMPILED_HEADERS)
           cotire(${MODULE_NAME})
         endif(AUTO_PRECOMPILED_HEADERS)

	   target_link_libraries( ${MODULE_NAME}
     	  ${BOOST_LIBRARIES}
	      ${JPEG_LIBRARIES}
        )

   endforeach(FILE_NAME)

endfunction(makeExamples)

# ------- unit test creation function ---------------
# Function for making a unit test
function(makeUnitTest FILE_NAME)
   add_definitions(-DBOOST_TEST_DYN_LINK)
	mesh_make_unit_test(${FILE_NAME} ${Boost_LIBRARIES})
endfunction(makeUnitTest)


# ------- unit test creation function from list ---------------
# Function for making a list of unit tests
function(makeUnitTests FILE_NAME_LIST)
   add_definitions(-DBOOST_TEST_DYN_LINK)
	mesh_make_unit_tests("${FILE_NAME_LIST}" ${Boost_LIBRARIES} ${ARGN}) #need to also pass along the "hidden" values in ARGN
endfunction(makeUnitTests)

# ------- GTest unit test creation function ---------------
# Function for making a unit test
function(makeGTest FILE_NAME)
	mesh_make_unit_test(${FILE_NAME} ${GTEST_LIBRARIES}) 
endfunction(makeGTest)

# ------- GTest unit test creation function from list ---------------
# Function for making a list of unit tests
function(makeGTests FILE_NAME_LIST)
	mesh_make_unit_tests("${FILE_NAME_LIST}" ${GTEST_LIBRARIES} ${ARGN}) #need to also pass along the "hidden" values in ARGN
endfunction(makeGTests)

# ------- GMock unit test creation function ---------------
# Function for making a GMock unit test
function(makeGMock FILE_NAME)
	mesh_make_unit_test(${FILE_NAME} ${GMOCK_LIBRARIES}) 
endfunction(makeGMock)


# ------- GMock unit test creation function from list ---------------
# Function for making a list of GMock unit tests
function(makeGMocks FILE_NAME_LIST)
	mesh_make_unit_tests("${FILE_NAME_LIST}" ${GMOCK_LIBRARIES} ${ARGN}) #need to also pass along the "hidden" values in ARGN
endfunction(makeGMocks)

#-----------------------MAKE TEST HELPER FUNCTION---------------------
#Helper function for each of the singular add test functions
#Handles functionality common for each test setup
#---------------------------------------------------------------------
function(mesh_make_unit_test FILE_NAME)
   get_filename_component(MODULE_NAME ${FILE_NAME} NAME_WE )
   add_executable(${MODULE_NAME} ${FILE_NAME})

   target_link_libraries( ${MODULE_NAME}
     ${ARGN} # ARGN expands to the remaining arguments for the macro
   )

   ADD_TEST( ${MODULE_NAME} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${MODULE_NAME})
endfunction(mesh_make_unit_test)

#-----------------------MAKE TESTS HELPER FUNCTION---------------------
#Helper function for each of the add multiple tests functions
#Handles functionality common for each test setup
#---------------------------------------------------------------------
function(mesh_make_unit_tests FILE_NAME_LIST)
   foreach(FILE_NAME ${${FILE_NAME_LIST}}) 
  	 	get_filename_component(MODULE_NAME ${FILE_NAME} NAME_WE )
	   add_executable(${MODULE_NAME} ${FILE_NAME})
           
         if(AUTO_PRECOMPILED_HEADERS)
           cotire(${MODULE_NAME})
         endif(AUTO_PRECOMPILED_HEADERS)

	   target_link_libraries( ${MODULE_NAME}
	      ${ARGN} # ARGN expands to the remaining arguments for the macro
	   )

	   ADD_TEST( ${MODULE_NAME} ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${MODULE_NAME})
   endforeach(FILE_NAME)
endfunction(mesh_make_unit_tests)
