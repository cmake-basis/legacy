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

if(NOT PNG_ROOT)
  set(PNG_ROOT ${CMAKE_SOURCE_DIR}/external/libpng)
endif()

if(NOT PNG_LIBRARY)
   set(PNG_LIBRARY ${PNG_DIR})
endif()

# need to pass the path to the external build
if(("${ZLIB_LIBRARIES}" STREQUAL "zlib") OR ("${ZLIB_LIBRARIES}" STREQUAL "libz"))
   get_target_property(ZLIB_LIBRARY_PATH zlib IMPORTED_LOCATION)
else()
   set(ZLIB_LIBRARY_PATH ${ZLIB_LIBRARIES})
endif()


ExternalProject_Add(PNG
                    DEPENDS ZLIB
                    SOURCE_DIR ${PNG_DIR}
                    CMAKE_ARGS 
                      -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> 
                      -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS} 
                      -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS} 
                      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} 
                      ${USE_PROJECT_CMAKE_MODULE_PATH}
                      -DZLIB_ROOT=${ZLIB_DIR}
                      -DZLIB_LIBRARY=${ZLIB_LIBRARY_PATH}
                      -DZLIB_INCLUDE_DIR=${ZLIB_INCLUDE_DIR}
                    INSTALL_DIR
                      ${PROJECT_BINARY_DIR}
                    )
ExternalProject_Get_Property(PNG install_dir)


add_library(png STATIC IMPORTED )
set_target_properties(png PROPERTIES IMPORTED_LOCATION ${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}png16${CMAKE_STATIC_LIBRARY_SUFFIX} )
add_dependencies(png PNG ZLIB ${ZLIB_LIBRARIES})
set(PNG_LIBRARIES png ) #png always requires zlib, so just keep them together
set(PNG_DIR ${install_dir})
set(PNG_INCLUDE_DIRS ${install_dir}/include)


find_package_handle_standard_args(PNG DEFAULT_MSG PNG_LIBRARIES PNG_INCLUDE_DIRS)

if(PNG_FOUND)
  set(PNG_LIBRARIES_OPTIONAL ${PNG_LIBRARIES})
  add_definitions(-DHAVE_PNG)
endif()

#message(STATUS "PNG_FOUND:${PNG_FOUND} PNG_LIBRARIES:${PNG_LIBRARIES} PNG_INCLUDE_DIRS:${PNG_INCLUDE_DIRS} PNGDIR:${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}png${CMAKE_STATIC_LIBRARY_SUFFIX} " )
