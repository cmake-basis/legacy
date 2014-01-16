###################################
* cmakeMesh Module                *
###################################

  PURPOSE: The cmakeMesh module is intended to provide a set of CMake scripts and utility functions that will be useful to a new or existing project that uses CMake and can be shared with other projects.



###################################
* Learn to use CMake              *
###################################

CMake is a prerequisite to using CMakeMesh, so learn the basics of CMake before you jump into cmakeMesh.
cmakeMesh is a set of utilities and convenience scripts to make working with CMake easier, particularly with commonly shared libraries.

Beginner CMake Resources
  - Modern CMake:                 https://archive.fosdem.org/2013/schedule/event/moderncmake/
  - Overview:                     http://www.kde.org/kdeslides/CampKDE2010/CampKDE2010-MarcusHanwell.pdf
  - Documentation:                http://www.cmake.org/cmake/help/documentation.html
      - Be sure to understand what each major category is about and used for in the CMake Master Index
                                  http://www.cmake.org/cmake/help/v2.8.11/cmake.html
  - Tutorial:                     http://www.cmake.org/cmake/help/cmake_tutorial.html
  - Wiki:                         http://www.cmake.org/Wiki/CMake
  - Examples:                     http://www.vtk.org/Wiki/CMake/Examples
  - FAQ:                          http://www.cmake.org/Wiki/CMake_FAQ
  - Finding Libraries:            http://www.vtk.org/Wiki/CMake:How_To_Find_Libraries
  - Useful Variables:             http://www.cmake.org/Wiki/CMake_Useful_Variables
  - List of CMake Commands:       http://www.cmake.org/cmake/help/v2.8.11/cmake.html#section_Commands
  
Advanced CMake Resources
  - Module Maintainers Resources: http://www.itk.org/Wiki/CMake:Module_Maintainers
  - CMake Modules readme.txt:     http://cmake.org/gitweb?p=cmake.git;a=blob;f=Modules/readme.txt
  - Building External Projects:   http://www.kitware.com/media/html/BuildingExternalProjectsWithCMake2.8.html
  - ProjectConfig.cmake files:    http://www.cmake.org/Wiki/CMake:How_to_create_a_ProjectConfig.cmake_file
  - Writing Platform Checks:      http://www.cmake.org/Wiki/CMake:How_To_Write_Platform_Checks
  - Cross Compiling:              http://www.vtk.org/Wiki/CMake_Cross_Compiling
  
Important Functions
  - find_package
      - For finding and configuring libraries, headers, and paths that your project needs to build.
      - http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:find_package
  - ExternalProject_Add
      - Build components outside of CMake
      - http://www.cmake.org/cmake/help/v2.8.11/cmake.html#module:ExternalProject
  - BundleUtilities
      - Packaging standalone bundle applications
      - BundleUtilities.cmake:       http://www.cmake.org/cmake/help/v2.8.11/cmake.html#module:BundleUtilities
      - BundleUtilities Example:     http://www.cmake.org/Wiki/BundleUtilitiesExample
      - Post Install: http://www.cmake.org/pipermail/cmake/2012-February/049248.html
  - CMakeParseArguments
      - Handling arguments in your CMake function implementations
      - http://www.cmake.org/cmake/help/v2.8.11/cmake.html#module:CMakeParseArguments
  - Properties on Targets
      - http://www.cmake.org/cmake/help/v2.8.11/cmake.html#section_PropertiesonTargets
  - get_target_property
      - retrieve settings for a specific target such as a library or executable
      - http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:set_target_properties
  - set_target_property
      - modify settings for a specific target
      - http://www.cmake.org/cmake/help/v2.8.11/cmake.html#command:get_target_property
  

###################################
* Basic setup                     *
###################################

Where to put the cmakeMesh module
-----------------------------------
  myproject/modules/cmakeMesh  - The cmakeMesh module will be most useful in this location relative to your project's top level directory. 
  myporject/cmakeMesh          - This directory is also supported.
  [some other directory]       - Much of the functionality should work if it is in other locations, although some changes and adjustments may be required.




Recommended CMake Mesh Setup
-----------------------------------

Module Placement
-----------------------------------
ExampleShell                - This is a thin shell repository as recommended by mercurial with very little in the way of actual content.
                              See: http://mercurial.selenic.com/wiki/Subrepository#Use_a_thin_shell_repository_to_manage_your_subrepositories
ExampleShell/               - Specific sources for projects can go here in subrepositories. Anything that can be reused should go in ExampleShell/modules.
ExampleShell/externals      - External to NREC
ExampleShell/modules        - All reusable modules written by your team
ExampleShell/modules/nrec   - All modules created that are more NREC wide and/or cannot be distributed to the customer


Sample Find Script
-----------------------------------
  cmakeMesh/FindNRECSerialization.cmake


Custom CMake Functions
-----------------------------------
  Binaries
    makeBinariesFromSourceNames       - Builds a set of binaries with 1 binary per source file (BuildUtilities.cmake)
    makeQT4Binary                     - Specify Executable name, a source file list, and a moc header list to build a Qt4 binary (BuildUtilities.cmake)
    makeUnitTest                      - Builds a unit test and adds it to the test suite (BuildUtilities.cmake)
    
  Libraries - BuildUtilities.cmake  
    mesh_add_library_to_project       - Adds the library name to ${PROJECT_NAME}_LIBRARIES then calls add_library (BuildUtilities.cmake)
    makeQT4Library                    - Specify library name, a source file list, and a moc header list to build a Qt4 library (BuildUtilities.cmake)
  
  Finding Packages
    find_package_as_subdirectory      - Finds a package, adding it as a subdirectory by default, otherwise adding it as a precompiled external library (FindPackageAsSubdirectory.cmake)
    mesh_find_package                 - Automates writing a find script, including subproject functionality. You simply set the required variables and it handles the rest (FindPackageAsSubdirectory.cmake)
    mesh_setup_project                      - Calls all the Setup*.cmake scripts used in the project, and sets up default path layouts (mesh_setup_project.cmake)

  Doxygen
    UseDoxgen/                        - Folder containing Doxygen setup configuration and build scripts.
    SetupDoxygen                      - Reasonable default Doxygen configuration for a project. 

Important Variables
-----------------------------------
  ${PROJECT_NAME}_IS_SUBDIRECTORY     - Defined when a project is being built as a subdirectory of another project. Used to conditionally run parts of a cmake build depending on the configuration.
  MESH_INSTALL_DIRECTORY_EXCLUDE_PATTERNS


Build Policies
-----------------------------------
  We want to maximize our ability to compile the tree on different systems, considering that every package is not available on every system. No components should be set to "REQUIRED" in find_package, mesh_find_package, or mesh_setup_packages! Therefore, every component that requires a module should start with:
  
  # see VariableCheck.cmake
  
  mesh_variable_check(
    REQUIRED
      MyPackage_INCLUDE_DIRS
      MyPackage_LIBRARIES
  )

Optional Libraries
-----------------------------------
  If a library is desired to be optional so that features of it are only used when available, it is suggested that the find script allow HAVE_LibraryName to be defined when it is found and a variable to be set named LibraryName_LIBRARIES_OPTIONAL, that is not defined (cmake resolves undefined variables to the empty string) when the library is not available, and defined normally when it is available. This way, the optional library can be passed to add_executable and will build successfully both when the library is available and when it is not. If the find script cannot be changed, this can be done in the mesh_setup_packages.cmake script. Several examples can be found in mesh_setup_packages.cmake, such as IPP_LIBRARIES_OPTIONAL.


Standardized Module Directory Layout
-----------------------------------
  
  projectname
  |
  |- projectname
  |  |- project.h
  |  |- project.cpp
  |  |- class.h
  |  |- class.cpp
  |  |- CMakeLists.txt
  |
  |- doc
  |   |- class.html
  |
  |- lib
  |   |- class.a
  |   |- class.so
  |
  |- bin
  |   |- exectuable
  |
  |-unit_tests
  |   |- class_test.cpp
  |
  |-examples
  |   |- class_example.cpp
  |
  |- cmake ->
  |
  |- README
  |- CMakeLists.txt
  |- License.txt
  |- Doxyfile.in
  
  

Sample Module Using Standardized Layout
-----------------------------------
  ExampleShell/modules/ExampleProject






#######################################
* Adding a new Module to your project *
#######################################

Create a new directory in modules, following the above internal structure
Create a find script in modules/cmake
Modify modules/cmake/SetupPackages.cmake to look for your new find script
  If your module does depend on other modules
    todo - See Andrew Hundt <ahundt@cmu.edu>


###################################
* Adding a new Library            *
###################################






###################################
* Compiler Configuration          *
###################################

mesh_setup_compiler_flags.cmake
  - These flags can also be set directly in SetupProject.cmake
  - Set how you would like compilation to be configured
  - See mesh_setup_compiler_flags.cmake for documentation
  
  mesh_setup_compiler_flags.cmake features (Developer Notes in parenthesis)
    - Detect the current compiler (vc_determine_compiler in VcMacros.cmake) 
    - Detect and enable C++11 support (see FindCXXFeatures.cmake and the FindCXXFeatures folder )
    - Optimize compiler flags for a specific target architecture (OptimizeForArchitecture.cmake)
    - Enable additional warnings for greater code safety (vc_set_preferred_compiler_flags in VcMacros.cmake)
  


########################################
* Adding Custom Commands to CMakeMesh  *
########################################

Sometimes custom executable commands are required for the build, such as with IDL data formats. 
Before covering how to integrate this functionality into CMakeMesh it is recommended that you 
first consider providing these functions in a "cmake" folder within your own library. You may 
wish to consider simply supplying appropriate *.cmake files in the project that defines your 
IDL format, then calling include() on them as part of the CMakeMesh find script. Keep in mind 
that any code you commit in CMakeMesh will need to have zero encumbrances, because every project 
will need to be able to use it. 

Once you are sure you want to integrate a custom function, such as for your IDLs, we recommend you 
use the same approach as standard CMake scripts, such as in FindProtobuf.cmake and FindQt4.cmake. 
Each implements macros/functions directly in the find script for running the moc compiler and protoc, 
respectively. FindProtobuf.cmake may actually be the simpler example to follow.

The basic way of doing this followed by those scripts may require your idl tool be installed on the 
system, but alternately you could pair that with an External*.cmake script to allow you to build 
your IDL tool then use it.

Reference links:
FindProtobuf.cmake 
  - CMake Docs: http://www.cmake.org/cmake/help/v2.8.11/cmake.html#module:FindProtobuf  
  - Implementation: http://cmake.org/gitweb?p=cmake.git;a=blob;f=Modules/FindProtobuf.cmake
FindQt4.cmake 
  - CMake Docs: http://www.cmake.org/cmake/help/v2.8.11/cmake.html#module:FindQt4
  - Implementation: http://cmake.org/gitweb?p=cmake.git;a=blob;f=Modules/FindQt4.cmake


There are several ways to integrate a custom function based on the approach you are taking. 
For example imagine you wanted to integrate "MyPkg". 

If you have MyPkg_generate_cpp in a find script such as FindMyPkg.cmake, you can add that 
file directly to the CMakeMesh folder. 

Next put the calls to run that find script with the right configuration into SetupPackages.cmake, 
so if someone specified:

mesh_setup_project(
   FIND_PACKAGES
     MyPkg
)

then the functions would be available to call after mesh_setup_project runs.

Another alternative is to have a MyPkg.cmake script or some other name that defines the 
functions you want, then users simply include(MyPkg).
  



########################################
* Doxygen Integration                  *
########################################

TODO