#
# Copyright (c) 2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

# Standard CMake Functions
include(CMakeParseArguments)

# cmakeMesh functions
include(${CMAKE_MESH_PATH}/FindIfEnabled.cmake)

##############################################
#  The mesh_setup_packages Macro is at the bottom  # 
#  of this file, it calls the other macros   # 
##############################################


# modified include directories that checks if including directories is enabled for the mesh_setup_packages call. For internal use only
macro(include_directories_if_enabled)
  if(NOT SETUP_PACKAGES_NO_INCLUDE_DIRECTORIES)
    include_directories(${ARGN})
  endif(NOT SETUP_PACKAGES_NO_INCLUDE_DIRECTORIES)
endmacro(include_directories_if_enabled)

#############################
#  Setup External Packages  #
#############################
macro(mesh_setup_external_packages)
    
  # ---------- Boost Dependencies -------------------------
  if(SETUP_PROJECT_Boost OR SETUP_PROJECT_ALL_PACKAGES)
    set(USE_INCLUDED_Boost_DEFAULT ON)
    if("${CMAKE_SYSTEM}" MATCHES "Darwin")
     set(USE_INCLUDED_Boost_DEFAULT OFF)
    endif()
    
    if(DEFINED USE_INCLUDED_Boost)
      set(USE_INCLUDED_Boost_VAL ${USE_INCLUDED_Boost})
    else(DEFINED USE_INCLUDED_Boost)
      set(USE_INCLUDED_Boost_VAL ${USE_INCLUDED_Boost_DEFAULT})
    endif(DEFINED USE_INCLUDED_Boost)
    option(USE_INCLUDED_Boost "Use the Boost package included in the repository" ${USE_INCLUDED_Boost_VAL})
    
    if(USE_INCLUDED_Boost)
     if (WIN32)
       set (Boost_USE_STATIC_RUNTIME OFF)
       set (Boost_USE_STATIC_LIBS ON)
     endif(WIN32)
     set (Boost_ADDITIONAL_VERSIONS "1.46" "1.46.0" "1.48" "1.48.0" "1.49" "1.49.0" "1.52" "1.52.0" "1.54" "1.54.0")
     set(Boost_DIR "${CMAKE_SOURCE_DIR}/external/install/boost")
     # Boost_DIR is the most correct variable to set, following the cmake standardized variable names.
     # However, some odd behavior has been spotted, so BOOST_ROOT and BOOSTROOT are set here to be extra confident it will look in the right place.
     set(BOOST_ROOT "${Boost_DIR}")
     set(BOOSTROOT "${BOOST_ROOT}")
    endif(USE_INCLUDED_Boost)
    
    set(BOOST_COMPONENTS thread unit_test_framework program_options system date_time filesystem serialization signals)
    set(BOOST_OPTIONAL_COMPONENTS chrono timer)
    find_package(Boost 1.46 COMPONENTS ${BOOST_COMPONENTS} OPTIONAL_COMPONENTS ${BOOST_OPTIONAL_COMPONENTS} REQUIRED)
    link_directories ( ${Boost_LIBRARY_DIRS} )
    include_directories_if_enabled (SYSTEM ${Boost_INCLUDE_DIRS} )
    
    # Make variable match CMake "standard" convention for FOUND variables with all-caps name
    set(BOOST_FOUND ${Boost_FOUND})
    
    # Setup and build boost::shared_ptr debug hooks (off by default)
    option(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS "Enable Boost::shared_ptr debug hooks for finding circular references")
    if(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS)
    # If the debug hooks are enabled, find the necessary file and build the library
    add_definitions(-DBOOST_SP_ENABLE_DEBUG_HOOKS)
    find_path(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH sp_collector.cpp HINTS ${CMAKE_SOURCE_DIR}/external/boost/libs/smart_ptr/src ${Boost_DIR})
    if(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH)
      add_library(BoostSPDebugHooks ${BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH}/sp_collector.cpp ${BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH}/sp_debug_hooks.cpp )
      list(APPEND Boost_LIBRARIES BoostSPDebugHooks)
    else(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH)
      message(STATUS "Could not find boost::shared_ptr debug hooks, BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH: ${BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH}")
    endif(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS_PATH)
    endif(BOOST_SHARED_PTR_ENABLE_DEBUG_HOOKS)
    
    set(BOOST_LIBRARIES ${Boost_LIBRARIES})
    add_definitions(-DHAVE_BOOST)
    
  endif(SETUP_PROJECT_Boost OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- PkgConfig -------------------------  
  find_package(PkgConfig)
  
  # ---------- IPP Dependencies -------------------------  
  if(SETUP_PROJECT_IPP OR SETUP_PROJECT_ALL_PACKAGES)
  option(USE_IPP_5_1 "Build with IPP 5.1, if the system is able to." ON)
  if(USE_IPP_5_1)
  if("${CMAKE_SYSTEM}" MATCHES "Linux")  
    if (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
	    set(IPP_ROOT "${CMAKE_SOURCE_DIR}/external/libipp" )
    else (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
	    set(IPP_ROOT "${CMAKE_SOURCE_DIR}/external/intel/ipp/5.1/ia32" )
    endif (CMAKE_CXX_SIZEOF_DATA_PTR EQUAL 8)
  endif()
  endif()
  find_package(IPP)
  if(IPP_FOUND)
    include_directories_if_enabled(${IPP_INCLUDE_DIRS})
    add_definitions(-DHAVE_IPP)
    set(IPP_LIBRARIES_OPTIONAL ${IPP_LIBRARIES})
  endif(IPP_FOUND)  
  endif(SETUP_PROJECT_IPP OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- Eigen -------------------------
  if(SETUP_PROJECT_Eigen3 OR SETUP_PROJECT_ALL_PACKAGES)
    option(USE_INCLUDED_Eigen3 "Use the Eigen3 package included in the repository" ON)
    if(USE_INCLUDED_Eigen3)
      set(EIGEN3_ROOT "${CMAKE_SOURCE_DIR}/external/eigen")
    endif(USE_INCLUDED_Eigen3)
    find_package(Eigen3)
    if(EIGEN3_FOUND)
      set(Eigen3_FOUND ${EIGEN3_FOUND} )
      set(Eigen3_INCLUDE_DIRS ${EIGEN3_INCLUDE_DIR} )
      include_directories_if_enabled( ${Eigen3_INCLUDE_DIRS} )
      add_definitions(-DHAVE_EIGEN3)
    endif(EIGEN3_FOUND)
  endif(SETUP_PROJECT_Eigen3 OR SETUP_PROJECT_ALL_PACKAGES)


  # ---------- Find Common System Dependencies -----------
  mesh_find_if_enabled(
    INCLUDE_PACKAGE_DIR
    FIND_PACKAGE
      ZLIB
      PNG
      JPEG
  )

  mesh_find_if_enabled(
    FIND_PACKAGE
      Curses
      OpenGL
      GLUT
      GD
      SVS
      GSL  # WARNING: GPL License
      GDAL
      X11
      Fontconfig
      PostgreSQL
      PQXX
      TIFF
      Protobuf
  )

  # Fix OpenGL variables
  if(EXISTS OPENGL_FOUND)
      set(OpenGL_FOUND ${OPENGL_FOUND})
  endif(EXISTS OPENGL_FOUND)
  if(EXISTS OPENGL_LIBRARIES)
      set(OpenGL_LIBRARIES ${OPENGL_LIBRARIES})
  endif(EXISTS OPENGL_LIBRARIES)
  

  # ---------- OpenCV Dependencies -------------------------  
  if(EXTERNAL_PROJECT_ADD_OpenCV)
     # TODO: consider moving this out, make sure it is at least configurable from outside
     set(OpenCV_COMP core imgproc calib3d video highgui ml)
     include(External_OpenCV)
     include_directories_if_enabled(${OpenCV_INCLUDE_DIRS})
  elseif(SETUP_PROJECT_OpenCV OR SETUP_PROJECT_ALL_PACKAGES)
    if(NOT OpenCV_DIR)
      set(USE_INCLUDED_OpenCV_DEFAULT ON)
      if("${CMAKE_SYSTEM}" MATCHES "Darwin")
        set(USE_INCLUDED_OpenCV_DEFAULT OFF)
        list(APPEND CMAKE_MODULE_PATH "/opt/local/lib/cmake/" "/opt/local/lib/"  "/opt/local/lib/cmake" "/opt/local/share/OpenCV")
        set(OpenCV_DIR "/opt/local/lib/cmake/")
        message(STATUS "OpenCV_DIR:${OpenCV_DIR} manually set for Darwin OpenCV dependency")
      endif()
      
      if(DEFINED USE_INCLUDED_OpenCV)
        set(USE_INCLUDED_OpenCV_VAL ${USE_INCLUDED_OpenCV})
      else(DEFINED USE_INCLUDED_OpenCV)
        set(USE_INCLUDED_OpenCV_VAL ${USE_INCLUDED_OpenCV_DEFAULT})
      endif(DEFINED USE_INCLUDED_OpenCV)
      option(USE_INCLUDED_OpenCV "Use the OpenCV package included in the repository" ${USE_INCLUDED_OpenCV_VAL})
      if(USE_INCLUDED_OpenCV)
        if(WIN32)
          set (OpenCV_DIR ${CMAKE_SOURCE_DIR}/external/install/opencv)
          set (OpenCV_CONFIG_PATH ${CMAKE_SOURCE_DIR}/external/install/opencv)
        else()
          set(OpenCV_DIR "${CMAKE_SOURCE_DIR}/external/install/opencv/share/OpenCV")
          set(OpenCV_CONFIG_PATH "${CMAKE_SOURCE_DIR}/external/install/opencv/share/OpenCV")
        endif()
        set(OpenCV_ROOT_DIR "${OpenCV_DIR}")
      endif(USE_INCLUDED_OpenCV)
    endif(NOT OpenCV_DIR)

    find_package(OpenCV)
    if(NOT EXISTS OPENCV_FOUND)
      set(OPENCV_FOUND ${OpenCV_FOUND})
    endif(NOT EXISTS OPENCV_FOUND)
    if(NOT EXISTS OpenCV_FOUND)
      set(OpenCV_FOUND ${OPENCV_FOUND})
    endif(NOT EXISTS OpenCV_FOUND)
    
    if(OPENCV_FOUND)
      set(OpenCV_LIBRARIES ${OpenCV_LIBS})
      set(OPENCV_LIBRARIES ${OpenCV_LIBS})
      set(OpenCV_INCLUDE_DIR ${OpenCV_INCLUDE_DIRS})
      include_directories_if_enabled(${OpenCV_INCLUDE_DIRS})
      add_definitions(-DHAVE_OPENCV)
    endif(OPENCV_FOUND)  
    
  endif(EXTERNAL_PROJECT_ADD_OpenCV)
  
  # ---------- KvaserCanLib -------------------------
  if(SETUP_PROJECT_KvaserCanLib OR SETUP_PROJECT_ALL_PACKAGES)
      find_package(KvaserCanLib)
      set(KVASERCANLIB_FOUND ${KvaserCanLib_FOUND})
      if(KvaserCanLib_FOUND)
          include_directories_if_enabled(${KvaserCanLib_INCLUDE_DIRS})
      endif(KvaserCanLib_FOUND)
  endif(SETUP_PROJECT_KvaserCanLib OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- CanUsbFtdi -------------------------
  if(SETUP_PROJECT_CanUsbFtdi OR SETUP_PROJECT_ALL_PACKAGES)
      find_package(CanUsbFtdi)
      set(CANUSBFTDI_FOUND ${CanUsbFtdi_FOUND})
      if(CanUsbFtdi_FOUND)
          include_directories_if_enabled(${CanUsbFtdi_INCLUDE_DIRS})
          add_definitions(-DHAVE_CAN_USB_FTDI)
      endif(CanUsbFtdi_FOUND)
  endif(SETUP_PROJECT_CanUsbFtdi OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- OpenSpliceDDS -------------------------
  if(SETUP_PROJECT_OpenSpliceDDS OR SETUP_PROJECT_ALL_PACKAGES)
      find_package(OpenSpliceDDS)
      set(OpenSpliceDDS_FOUND ${OpenSpliceDDS_FOUND})
      if(OpenSpliceDDS_FOUND)
          include_directories_if_enabled(${OpenSpliceDDS_INCLUDE_DIRS})
          add_definitions(-D__OPENSPLICE_DDS__)
      endif(OpenSpliceDDS_FOUND)
  endif(SETUP_PROJECT_OpenSpliceDDS OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- threading Dependencies ---------------------
  SET(CMAKE_THREAD_PREFER_PTHREAD TRUE)
  find_package(Threads)
  
  
  # ---------- Linux Only Packages ---------------------
  if("${CMAKE_SYSTEM}" MATCHES "Linux")
  
    # ---------- Peak CAN ---------------------
    if(SETUP_PROJECT_PeakCan OR SETUP_PROJECT_ALL_PACKAGES)
      option(USE_PEAK_CAN "Build with the Peak CAN drivers, if the system is able to." ON)
      if(USE_PEAK_CAN)
        if(NOT DEFINED PeakCanROOT)
        set(PeakCanROOT "${CMAKE_SOURCE_DIR}/external/peak-linux-driver-6.9b" )
        endif()
      endif()
      find_package(PeakCan)
      if(PEAKCAN_FOUND)
        include_directories_if_enabled(${PeakCan_INCLUDE_DIR})
      endif(PEAKCAN_FOUND)
    endif(SETUP_PROJECT_PeakCan OR SETUP_PROJECT_ALL_PACKAGES)
    
    # ---------- SVS Dependencies -------------------------
    if(SETUP_PROJECT_SVS OR SETUP_PROJECT_ALL_PACKAGES)
      option(USE_SVS "Build with SVS, if the system is able to." ON)
      if(USE_SVS)
        set(ENV{SVSROOT} "${CMAKE_SOURCE_DIR}/external/svs" )
      endif()
      find_package(SVS)
      if(SVS_FOUND)
        include_directories_if_enabled(${SVS_INCLUDE_DIRS})
        add_definitions(-DHAVE_SVS)
      endif(SVS_FOUND)
    endif(SETUP_PROJECT_SVS OR SETUP_PROJECT_ALL_PACKAGES)
    
    # ---------- Triclops Dependencies -------------------------
    if(SETUP_PROJECT_Triclops OR SETUP_PROJECT_ALL_PACKAGES)
      option(USE_Triclops "Build with Triclops, if the system is able to." ON)
      if(USE_Triclops)
        set(ENV{TriclopsROOT} "${CMAKE_SOURCE_DIR}/external/pointgrey/Triclops3.2.0.8-FC1" )
      endif()
      find_package(Triclops)
      if(TRICLOPS_FOUND)
        add_definitions(-DHAVE_TRICLOPS)
        include_directories_if_enabled(${Triclops_INCLUDE_DIR})
      endif(TRICLOPS_FOUND)
    endif(SETUP_PROJECT_Triclops OR SETUP_PROJECT_ALL_PACKAGES)
  
  endif("${CMAKE_SYSTEM}" MATCHES "Linux")
  
  # ---------- Qt4 -------------------------
  
  if(SETUP_PROJECT_Qt4 OR SETUP_PROJECT_ALL_PACKAGES)
    set(USE_INCLUDED_Qt4_DEFAULT ON)
    if("${CMAKE_SYSTEM}" MATCHES "Darwin")
    set(USE_INCLUDED_Qt4_DEFAULT OFF)
    endif()
    
    if(DEFINED USE_INCLUDED_Qt4)
      set(USE_INCLUDED_Qt4_VAL ${USE_INCLUDED_Qt4})
    else(DEFINED USE_INCLUDED_Qt4)
      set(USE_INCLUDED_Qt4_VAL ${USE_INCLUDED_Qt4_DEFAULT})
    endif(DEFINED USE_INCLUDED_Qt4)
    option(USE_INCLUDED_Qt4 "Use the Qt4 package included in the repository" ${USE_INCLUDED_Qt4_VAL})
    if(USE_INCLUDED_Qt4)
      
    if (WIN32)
      set (QT_QMAKE_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/qmake.exe)
      set (QT_MOC_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/moc.exe)
      set (QT_RCC_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/rcc.exe)
      set (QT_UIC_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/uic.exe)
    else()
      set (QT_QMAKE_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/qmake)
      set (QT_MOC_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/moc)
      set (QT_RCC_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/rcc)
      set (QT_UIC_EXECUTABLE ${CMAKE_SOURCE_DIR}/external/install/qt/bin/uic)
    endif()
    if(NOT Qt4_DIR)
      set(Qt4_DIR "${CMAKE_SOURCE_DIR}/external/install/qt")
    endif()
    if(NOT ENV{QTDIR})
      set(ENV{QTDIR} ${Qt4_DIR})
    endif()
    # QTDIR is the most correct variable to set, following the find script variable name.
    endif(USE_INCLUDED_Qt4)
    
    find_package(Qt4 COMPONENTS QtCore QtGui QtOpenGL QtNetwork QtSql QtDesigner)
    if(QT4_FOUND)
      include(${QT_USE_FILE})
      include_directories_if_enabled(${QT_INCLUDES})
    endif(QT4_FOUND)
  endif(SETUP_PROJECT_Qt4 OR SETUP_PROJECT_ALL_PACKAGES)

  #---------- QCV -------------------------
  if(SETUP_PROJECT_QCV OR SETUP_PROJECT_ALL_PACKAGES)
  find_package(QCV)
  if(QCV_FOUND)
    include_directories_if_enabled(${QCV_INCLUDE_DIRS})
    add_definitions(-DHAVE_QCV)
  endif(QCV_FOUND)
  endif(SETUP_PROJECT_QCV OR SETUP_PROJECT_ALL_PACKAGES)
  
  #---------- qcvExt -------------------------
  if(SETUP_PROJECT_QCVEXT OR SETUP_PROJECT_ALL_PACKAGES)
  find_package(qcvExt)
  if(QCVEXT_FOUND)
    include_directories_if_enabled(${QCVEXT_INCLUDE_DIRS})
    add_definitions(-DHAVE_QCVEXT)
  endif(QCVEXT_FOUND)
  endif(SETUP_PROJECT_QCVEXT OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- Qwt -------------------------  
  if(SETUP_PROJECT_Qwt OR SETUP_PROJECT_ALL_PACKAGES)
    if(NOT QWT_ROOT)
      option(USE_INCLUDED_Qwt "Use the Qwt package included in the repository" ON)
      if(USE_INCLUDED_Qwt)
        set(QWT_ROOT ${CMAKE_SOURCE_DIR}/external/install/qwt/)
      endif(USE_INCLUDED_Qwt)
    endif()
    
    find_package(Qwt)
    if(QWT_FOUND)
      include_directories_if_enabled(${QWT_INCLUDE_DIR})
      add_definitions(-DHAVE_QWT)
    endif(QWT_FOUND)
  endif(SETUP_PROJECT_Qwt OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- DC1394 -------------------------  
  if(SETUP_PROJECT_DC1394 OR SETUP_PROJECT_ALL_PACKAGES)
  find_package(DC1394)
  if(DC1394_FOUND)
     add_definitions(-D__DC1394__)
     add_definitions(-DHAVE_DC1394)
     set(DC1394_LIBRARIES_OPTIONAL ${DC1394_LIBRARIES})
  endif(DC1394_FOUND)
  endif(SETUP_PROJECT_DC1394 OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- GTK + GTK2 -------------------------  
  if(SETUP_PROJECT_GTK2 OR SETUP_PROJECT_ALL_PACKAGES)
  if(PKGCONFIG_FOUND)
    pkg_check_modules(GTK2 glib-2.0 gtk+-2.0)
  endif(PKGCONFIG_FOUND)
  
  if(NOT GTK2_FOUND)
    find_package(GTK2 COMPONENTS gtk)
  endif(NOT GTK2_FOUND)
    
  if(GTK2_FOUND)
    include_directories_if_enabled(${GTK2_INCLUDE_DIRS})
  endif(GTK2_FOUND)
  endif(SETUP_PROJECT_GTK2 OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- OpenSplice -------------------------
  if(SETUP_PROJECT_OpenSplice OR SETUP_PROJECT_ALL_PACKAGES)
  find_package(OpenSplice)
  set(OPENSPLICE_FOUND ${OpenSplice_FOUND})
  if(OpenSplice_FOUND)
    include_directories_if_enabled(${OpenSplice_INCLUDE_DIRS}
     add_definitions(-D__OPENSPLICE_DDS__))
      add_definitions(-DHAVE_OPENSPLICE)
      add_definitions(-DHAVE_DDS)
      add_definitions(-DHAVE_OPENSPLICE_DDS)
  endif(OpenSplice_FOUND)
  endif(SETUP_PROJECT_OpenSplice OR SETUP_PROJECT_ALL_PACKAGES)
  
  # ---------- FLTK -------------------------
  if(SETUP_PROJECT_FLTK OR SETUP_PROJECT_ALL_PACKAGES)
  if(NOT FLTK_FOUND)
    find_package(FLTK)
  endif(NOT FLTK_FOUND)
  if(FLTK_FOUND)
    include_directories_if_enabled(${FLTK_INCLUDE_DIR})
    add_definitions(-DHAVE_FLTK)
  endif(FLTK_FOUND)
  endif(SETUP_PROJECT_FLTK OR SETUP_PROJECT_ALL_PACKAGES)
  
  
  #---------- readline (WARNING: GPL LICENSE) -------------------
  if(SETUP_PROJECT_readline OR SETUP_PROJECT_ALL_PACKAGES)
    if(PKGCONFIG_FOUND)
      pkg_check_modules(READLINE readline)
    endif(PKGCONFIG_FOUND)
    
    if(NOT READLINE_FOUND)
      find_package(Readline) # WARNING: GPL License
    endif(NOT READLINE_FOUND)
  endif(SETUP_PROJECT_readline OR SETUP_PROJECT_ALL_PACKAGES)
  
  
  check_include_files(sys/shm.h HAVE_SHARED_MEMORY)
  check_include_files(malloc.h HAVE_MALLOC_H)
  
  if(IPP_FOUND)
    #---------- IPP-dependent External Libraries Built from Source -------------
    mesh_find_if_enabled(
      FIND_PACKAGE_AS_SUBDIRECTORY
      LibSVM
    )
  endif(IPP_FOUND)

  
   #----------------------------Google Test (GTest)-------------------------------
   # There are some functions (GTEST_ADD_TEST) that will not work 
   # unless the default FindGTest.cmake script runs.
  # Only run this if GTest is set to be build and GMock is NOT, GTest will be
  # built twice and cause collisions. It is not included in
  # SETUP_PROJECT_ALL_PACKAGES to avoid these collisions, because GMock is
  # included.
	if(SETUP_PROJECT_GTest AND NOT SETUP_PROJECT_GMock)	
		FIND_PACKAGE(GTest)
   endif(SETUP_PROJECT_GTest AND NOT SETUP_PROJECT_GMock)

   #----------------------------Google Mock (GMock)-------------------------------
   # There are some functions e.g. (GTEST_ADD_TEST) that will not work 
   # unless the default FindGTest.cmake script runs.
	if(SETUP_PROJECT_GMock OR SETUP_PROJECT_ALL_PACKAGES)	
		FIND_PACKAGE(GMock)
   endif(SETUP_PROJECT_GMock OR SETUP_PROJECT_ALL_PACKAGES)
endmacro(mesh_setup_external_packages)


  ##################################
  #  Setup Internal NREC Packages  #
  ##################################
macro(mesh_setup_internal_packages)

    mesh_find_if_enabled(
      INCLUDE_PACKAGE_DIR # include the directory of each of these packages
      FIND_PACKAGE
        Librt
        NRECUpiColor
        Profiling
      FIND_PACKAGE_AS_SUBDIRECTORY
        NRECUpiMap
        Newmat
        ezXML
        Meschach
        cvBlobs
        NRECSerialization
        NRECDataStructuresUtil
        NRECMathUtil
        NRECGeometry
        NRECSpatial
        NRECgil
        NRECParser
        NRECTransformNetwork
        NRECParametersIO
        NRECStereo
        NRECUdpComm
        NRECImageIO
        NRECblaser
        NRECserial
        NRECCoreTech # for a parent repository that contains several libraries as subrepos
        NRECTrackballWindow
    )
    
    if(HAVE_PROFILER OR ENABLE_PROFILER)
      message(STATUS "Enabling profiler")
      add_definitions(-DHAVE_PROFILER)
    endif()
endmacro(mesh_setup_internal_packages)



##########################################################
# ------- mesh_setup_packages ---------------
##########################################################
#
# mesh_setup_packages calls find_package and configures CMake variables in a uniform manner so that packages are compatible and variable names are predictable
#  
# Options:
#      ALL_PACKAGES                  - Find all supported packages
#      NO_PACKAGES                   - Suppress warning message if no packages are searched for 
#
#      NO_INCLUDE_DIRECTORIES  - disables calls to include_directories() in mesh_setup_project. All included directories must be specified manually using the package directory variables.
#
# Multi Arg Params:
#      FIND_PACKAGES                  - call find_package(PACKAGE_NAME) and set found variables, include directories, etc. in a uniform, compatible manner
#
##########################################################
macro(mesh_setup_packages)
  
  if(NOT ${ARGC})
    message(STATUS "Warning: mesh_setup_packages() called without parameters, so no packages will be searched for.")
    message(STATUS "                         If this is intentional pass NO_PACKAGES instead.")
    message(STATUS "                         other options include ALL_PACKAGES and FIND_PACKAGES <pkg1> <pkg2> ... <pkgN>")
  endif()  

  set(options 
    ALL_PACKAGES
    NO_PACKAGES 
    NO_INCLUDE_DIRECTORIES
  )
  set(oneValueArgs ) # currently none
  set(multiValueArgs FIND_PACKAGES EXTERNAL_PROJECT_ADD)
  cmake_parse_arguments(SETUP_PACKAGES "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )
  
  # set the variable for each package that is enabled
  foreach(PACKAGE_NAME IN LISTS SETUP_PROJECT_FIND_PACKAGES)
    set(SETUP_PACKAGES_${PACKAGE_NAME} TRUE)
  endforeach()
  
  # set the variable for each package that is enabled
  foreach(PACKAGE_NAME IN LISTS SETUP_PROJECT_EXTERNAL_PROJECT_ADD)
    set(EXTERNAL_PROJECT_ADD_${PACKAGE_NAME} TRUE)
  endforeach()
  
	# ---------- Add directories containing necessary CMake Scripts ----------
	
  # This modifies the user configuration directly, so should not be done. If this has been working for a while remove this comment 2013-08-21
	  ## find the location of cmakeMesh to add to CMAKE_MODULE_PATH
	  #find_path(CMAKE_MESH_PATH 
	  #  NAMES 
	  #    mesh_setup_project.cmake
	  #    AppendToEach.cmake
	  #  HINTS 
  	#    ${CMAKE_SOURCE_DIR} 
  	#    ${PROJECT_SOURCE_DIR}
    #	PATH_SUFFIXES
    #    modules/cmake
    #    modules/cmakeMesh
    #    cmake
    #    cmakeMesh
    #)
    #
    ## add cmakeMesh path to the list of paths for cmake files
    #list(APPEND CMAKE_MODULE_PATH ${CMAKE_MESH_PATH})
    #list(REMOVE_DUPLICATES CMAKE_MODULE_PATH)
  	  
    mesh_setup_external_packages()
    mesh_setup_internal_packages()
    
  
    # set the variable for each package that is enabled
    foreach(EXTERNAL_PACKAGE_NAME IN LISTS SETUP_PROJECT_EXTERNAL_PROJECT_ADD)
      string(TOUPPER ${EXTERNAL_PACKAGE_NAME} EXTERNAL_PACKAGE_NAME_UPPER)
      if(NOT ${EXTERNAL_PACKAGE_NAME_UPPER}_FOUND)
         include(External_${EXTERNAL_PACKAGE_NAME})
         include_directories_if_enabled(${${EXTERNAL_PACKAGE_NAME}_INCLUDE_DIRS})
      endif()
    endforeach()
      
endmacro(mesh_setup_packages)
