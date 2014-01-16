#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu

set(USE_PROJECT_CMAKE_MODULE_PATH "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}")
if(CMAKEMESH_USE_EXTERNALS)
  set(USE_PROJECT_CMAKE_MODULE_PATH -DCMAKE_MODULE_PATH=${CMAKE_BINARY_DIR}/cmake_subrepos)
endif()


if(NOT ZLIB_ROOT)
  set(ZLIB_ROOT ${CMAKE_SOURCE_DIR}/external/zlib)
endif()

ExternalProject_Add(ZLIB
                    SOURCE_DIR ${ZLIB_ROOT}
                    CMAKE_ARGS 
                      -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
                      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} 
                      -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} 
                      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} 
                      ${USE_PROJECT_CMAKE_MODULE_PATH}
                    INSTALL_DIR
                      ${PROJECT_BINARY_DIR}
                    )
ExternalProject_Get_Property(ZLIB install_dir)

if(UNIX)
   set(ZLIB_NAME libz)
else(UNIX)
   set(ZLIB_NAME zlib)
endif(UNIX)

add_library(zlib STATIC IMPORTED )
set_target_properties(zlib PROPERTIES IMPORTED_LOCATION ${install_dir}/lib/${ZLIB_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX} )
add_dependencies(zlib ZLIB)
set(ZLIB_LIBRARIES zlib)
set(ZLIB_LIBRARY ${ZLIB_LIBRARIES})
set(ZLIB_DIR ${install_dir})
set(ZLIB_INCLUDE_DIR ${install_dir}/include)
set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})


find_package_handle_standard_args(ZLIB DEFAULT_MSG ZLIB_LIBRARY ZLIB_LIBRARIES ZLIB_INCLUDE_DIR ZLIB_INCLUDE_DIRS)

if(ZLIB_FOUND)
  set(ZLIB_LIBRARIES_OPTIONAL ${ZLIB_LIBRARIES})
  add_definitions(-DHAVE_ZLIB)
endif()

#message(STATUS "ZLIB_FOUND:${ZLIB_FOUND} ZLIB_LIBRARIES:${ZLIB_LIBRARIES} ZLIB_INCLUDE_DIRS:${ZLIB_INCLUDE_DIRS}" )
