#
# Copyright (c) 2012-2013
#
# National Robotics Engineering Center, Carnegie Mellon University
# 10 40th Street, Pittsburgh, PA 15201
# www.nrec.ri.cmu.edu
#
# @author Andrew Hundt <ahundt@cmu.edu>

include(VcMacros)
  
##########################################################
# ------- mesh_setup_compiler_flags ---------------
##########################################################
#
# mesh_setup_compiler_flags performs optimization of compiler flags for maximum performance
#  
# Options:
#
#   NO_CXX_FLAGS                  - Compiler flag optimizations will not be enabled
#
#   C++11                         - Enable C++11 if it is supported
#
#   WARNING_FLAGS                 - Enable additional warning flags for greater code safety
#
#   BUILDTYPE_FLAGS               - Enable options for a set of build configurations that 
#                                   can be set with ccmake or cmake gui, including:
#                                     DEBUG         
#                                     MINSIZEREL    
#                                     RELEASE       
#                                     RELWITHDEBUG  
#                                     RELWITHDEBINFO
#
#   TARGET_ARCHITECTURE           - CPU architecture to optimize for.
#                                   WARNING: Using an incorrect setting here can result in crashes 
#                                   of the resulting binary because of invalid instructions used.
#                                   Setting the value to \"auto\" will try to optimize for the architecture 
#                                   where cmake is called.
#
#                                   Supported Values:
#                                     "auto" - default recommended setting, automatically detect and set optimization
#                                     "none" - don't apply optimization flags
#                                     "generic" - set general compiler optimization flags, but not architecture specific ones 
#                                     "core"
#                                     "merom" (65nm Core2) 
#                                     "penryn" (45nm Core2) 
#                                     "nehalem"
#                                     "westmere"
#                                     "sandy-bridge"
#                                     "ivy-bridge"
#                                     "atom"
#                                     "k8"
#                                     "k8-sse3"
#                                     "barcelona"
#                                     "istanbul"
#                                     "magny-cours"
#                                     "bulldozer"
#                                     "interlagos"
#
##########################################################
macro(mesh_setup_compiler_flags)
  

  set(options NO_CXX_FLAGS ENABLE_MUDFLAP WARNING_FLAGS BUILDTYPE_FLAGS C++11)
  set(oneValueArgs TARGET_ARCHITECTURE )
  set(multiValueArgs ) # currently none
  cmake_parse_arguments(SETUP_COMPILER_FLAGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

  if(SETUP_COMPILER_FLAGS_TARGET_ARCHITECTURE)
    set(TARGET_ARCHITECTURE ${SETUP_COMPILER_FLAGS_TARGET_ARCHITECTURE})
  endif(SETUP_COMPILER_FLAGS_TARGET_ARCHITECTURE)

  # pass BUILDTYPE_FLAGS through
  if(SETUP_COMPILER_FLAGS_BUILDTYPE_FLAGS)
    set(SETUP_COMPILER_FLAGS_BUILDTYPE_FLAGS BUILDTYPE_FLAGS)
  endif(SETUP_COMPILER_FLAGS_BUILDTYPE_FLAGS)

  # pass 
  if(SETUP_COMPILER_FLAGS_WARNING_FLAGS)
    set(SETUP_COMPILER_FLAGS_WARNING_FLAGS WARNING_FLAGS)
  endif(SETUP_COMPILER_FLAGS_WARNING_FLAGS)

  vc_determine_compiler()
  
  # detect C++11 features
  if(SETUP_COMPILER_FLAGS_C++11)
    find_package(CXXFeatures)
     if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" AND CXX11_COMPILER_FLAGS)
        #TODO: when problems are resolved, remove -Wc++11-narrowing 2013-06-13
       set(CXX11_COMPILER_FLAGS "${CXX11_COMPILER_FLAGS}  -stdlib=libc++ -Wno-c++11-narrowing" )
     endif()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CXX11_COMPILER_FLAGS}" )
  endif(SETUP_COMPILER_FLAGS_C++11)
  
  if(NOT CMAKE_BUILD_TYPE)
     set(CMAKE_BUILD_TYPE Release CACHE STRING
        "Choose the type of build, options are: None Debug Release RelWithDebug RelWithDebInfo MinSizeRel."
        FORCE)
  endif(NOT CMAKE_BUILD_TYPE)

  
  if(NOT SETUP_COMPILER_FLAGS_NO_CXX_FLAGS)
    # pass BUILDTYPE_FLAGS and WARNING_FLAGS through
    vc_set_preferred_compiler_flags(${SETUP_COMPILER_FLAGS_WARNING_FLAGS} ${SETUP_COMPILER_FLAGS_BUILDTYPE_FLAGS})
    add_definitions(${Vc_PREPROCESSOR_DEFINITIONS})
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${Vc_DEFINITIONS}" )
  endif(NOT SETUP_COMPILER_FLAGS_NO_CXX_FLAGS)
  
  # Default CMake Build Type compiler modes
  # NOTE: These are here and commented for reference only
  # because these flags are set by vc_set_preferred_compiler_flags above
  #set(CMAKE_BUILD_TYPE RelWithDebInfo)
  #set(CMAKE_BUILD_TYPE Debug)
  #set(CMAKE_BUILD_TYPE Release)

  # Set flag to insert mudflap instrumentation for debugging
  # -- Do not use this otherwise, as it will slow down code and produce tons of output.
  option(ENABLE_MUDFLAP "mudflap pointer debugging instrumentation")
  # Flags for single-threaded apps:
  set(MUDFLAP_COMPILER_FLAGS "-fmudflap -funwind-tables -rdynamic")
  # Flags for multi-threaded apps:
  set(MUDFLAP_COMPILER_FLAGS_MULTITHREAD "-fmudflap -fmudflapth -funwind-tables -lmudflapth -rdynamic")
  # For now, we're just running single-threaded
  if(ENABLE_MUDFLAP)
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${MUDFLAP_COMPILER_FLAGS}")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${MUDFLAP_COMPILER_FLAGS}")
  endif(ENABLE_MUDFLAP)

  ## Use this to set specific compile flags
  #if (UNIX AND CMAKE_COMPILER_IS_GNUCXX)
  #  # ORCHARD
  #  #set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -DNDEBUG -Wall -Wextra -msse -mmmx -msse2 -msse3 -mtune=i686 -march=i686 -fopenmp -fno-strict-aliasing")
  #  # WINGMAN
  #  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2 -DNDEBUG -Wall -Wextra -fno-strict-aliasing")
  #
  #  # Additional flags (from AFC) to use with WINGMAN flags above to boost performance
  #  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=nocona -msse3 -mfpmath=sse -DUNIX -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -mno-avx -mtune=generic")
  #
  #
  #endif (UNIX AND CMAKE_COMPILER_IS_GNUCXX)
  
  # UNLIMITED_TEMPLATE_BACKTRACE works with clang and gcc4.8 as of 2012-11-29
  option(UNLIMITED_TEMPLATE_BACKTRACE "Template substitutions displayed in a single compiler error message have no length limit. Useful for complex template errors.")
  if(UNLIMITED_TEMPLATE_BACKTRACE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -ftemplate-backtrace-limit=0")
  endif(UNLIMITED_TEMPLATE_BACKTRACE)
  
endmacro(mesh_setup_compiler_flags)
