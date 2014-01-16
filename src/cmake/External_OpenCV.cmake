#
# Copyright 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# NREC Confidential and Proprietary
# Do not distribute without prior written permission


set(USE_PROJECT_CMAKE_MODULE_PATH "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")
if(CMAKEMESH_USE_EXTERNALS)
  set(USE_PROJECT_CMAKE_MODULE_PATH -DCMAKE_MODULE_PATH=${CMAKE_BINARY_DIR}/cmake_subrepos)
endif()

if(CMAKE_COMPILER_IS_GNUXX)
  set(OPENCV_CONFIG_SETTINGS "-mtune=generic -march=nocona")
endif()

if(NOT OpenCV_DIR OR NOT OPENCV_ROOT)
  set(OPENCV_ROOT ${CMAKE_SOURCE_DIR}/external/opencv)
  set(OpenCV_DIR ${OPENCV_ROOT})
endif()


if(PNG_FOUND)
   if(TARGET PNG)
      get_target_property(PNG_LIBRARY_PATH png IMPORTED_LOCATION)
      list(APPEND OpenCV_DEPENDENCIES PNG)
   else()
      set(PNG_LIBRARY_PATH ${PNG_LIBRARIES})
   endif()
   
   set(PNG_CONFIG_VARS
      -DPNG_LIBRARY=${PNG_LIBRARIES}
      -DPNG_PNG_INCLUDE_DIR=${PNG_INCLUDE_DIRS}
   )
   
  set(WITH_PNG ON)
else()
  set(WITH_PNG OFF)
endif()

ExternalProject_Add(OpenCV
                    DEPENDS ${OpenCV_DEPENDENCIES}
                    SOURCE_DIR ${OpenCV_DIR}
                    CMAKE_ARGS
                      -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
                      -DWITH_GSTREAMER=OFF
                      -DBUILD_PERF_TESTS:BOOL=OFF
                      -DWITH_GIGEAPI:BOOL=OFF
                      -DWITH_OPENEXR:BOOL=OFF
                      -DBUILD_WITH_DEBUG_INFO:BOOL=OFF
                      -DBUILD_DOCS:BOOL=OFF
                      -DBUILD_EXAMPLES:BOOL=OFF
                      -DBUILD_NEW_PYTHON_SUPPORT:BOOL=OFF
                      -DBUILD_PACKAGE:BOOL=OFF
                      -DBUILD_SHARED_LIBS:BOOL=ON
                      -DBUILD_TESTS:BOOL=OFF
                      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                      -DWITH_1394=OFF
                      -DWITH_CUDA=OFF
                      -DWITH_FFMPEG:BOOL=OFF
                      -DWITH_V4L:BOOL=OFF
                      -DWITH_JASPER:BOOL=OFF
                      -DWITH_OPENGL:BOOL=ON
                      -DENABLE_SSE=ON
                      -DENABLE_SSE2=ON
                      -DENABLE_SSE3=ON
                      -DENABLE_SSSE3=ON
                      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} 
                      -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} 
                      ${USE_PROJECT_CMAKE_MODULE_PATH}
                      # TODO: verify PNG definitions next time OpneCV is updated, currently not verified to work in all situations:
                      -DWITH_PNG=OFF
                      ${PNG_CONFIG_VARS}
                      # the commented flags are from the modified SmartUnloading script, delete if the current functionality has been working for a while
                      #-DCMAKE_CXX_FLAGS:STRING="${OPENCV_CONFIG_SETTINGS} ${CXX11_COMPILER_FLAGS}"
                      #-DCMAKE_C_FLAGS:STRING=${OPENCV_CONFIG_SETTINGS}
                      #-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_CURRENT_BINARY_DIR}/external/opencv/install
)
ExternalProject_Get_Property(OpenCV install_dir)
set(OpenCV_ROOT_DIR ${install_dir})
set(OpenCV_DIR ${OpenCV_ROOT_DIR})
set(OpenCV_INCLUDE_DIRS ${OpenCV_ROOT_DIR}/include ${OpenCV_ROOT_DIR}/include/opencv)
set(OpenCV_LIBRARIES_DIR ${OpenCV_ROOT_DIR}/lib)
set(OpenCV_LIB_DIR ${OpenCV_LIB_DIR})
set(OpenCV_CONFIG_DIR ${OpenCV_ROOT_DIR}/share/OpenCV/)

set(OpenCV_LIBS)
foreach(COMP ${OpenCV_COMP})
  add_library(${CMAKE_SHARED_LIBRARY_PREFIX}opencv_${COMP} SHARED IMPORTED)
  set_property(TARGET libopencv_${COMP} PROPERTY IMPORTED_LOCATION ${OpenCV_ROOT_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}opencv_${COMP}${CMAKE_SHARED_LIBRARY_SUFFIX})
  list(APPEND OpenCV_LIBS libopencv_${COMP})
  add_dependencies(libopencv_${COMP} OpenCV)
endforeach()

set(OpenCV_LIBRARIES ${OpenCV_LIBS})

find_package_handle_standard_args(OpenCV DEFAULT_MSG OpenCV_LIBRARIES OpenCV_INCLUDE_DIRS)

mark_as_advanced(OpenCV_DIR)
mark_as_advanced(OpenCV_ROOT_DIR)
mark_as_advanced(OpenCV_INCLUDE_DIRS)
mark_as_advanced(OpenCV_LIBRARIES_DIR)
mark_as_advanced(OpenCV_LIBS)

# set OpenCV_Found for compatibility with the original find script
set(OpenCV_FOUND ${OPENCV_FOUND})

if(OPENCV_FOUND)
  set(OpenCV_LIBRARIES_OPTIONAL ${OpenCV_LIBRARIES})
  add_definitions(-DHAVE_OPENCV)
endif()
