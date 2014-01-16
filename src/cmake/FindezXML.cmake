#####################################################################
#
# Find ezXML Library
#
## 1: Input Variables
#
#  ezXML_ROOT_DIR
#    Optional variable for location to search for the library
# 
## 2: Output Variables
# The following are set after configuration is done:
#
#  ezXML_FOUND
#  ezXML_LIBRARIES
#  ezXML_INCLUDE_DIRS
#
# 2011/12/13 Zach Pezzementi
#####################################################################

include(${CMAKE_MESH_PATH}/MeshFindPackage.cmake)

set(MODULE_PATH_HINTS ${CMAKE_SOURCE_DIR}/external/ezxml)

if(ezXML_ROOT)
  set(ROOT_RELATIVE_INCLUDE_PATH_HINTS ${ezXML_ROOT})
  set(ROOT_RELATIVE_LIBRARY_PATH_HINTS ${ezXML_ROOT}/lib)
endif(ezXML_ROOT)

mesh_find_package(
  ezXML 
  SUBPROJECT_SEARCH_FILE ezxml.h
  SUBPROJECT_PATH_HINTS ${MODULE_PATH_HINTS}
  MODULE_PRETTY_NAME "ezXML library"
  INCLUDE_SEARCH_FILE ezxml.h
  INCLUDE_PATH_HINTS ${MODULE_PATH_HINTS} ${ROOT_RELATIVE_INCLUDE_PATH_HINTS}
  MODULE_LIBRARIES ezxml
  LIBRARY_PATH_HINTS ${ROOT_RELATIVE_LIBRARY_PATH_HINTS}
)

