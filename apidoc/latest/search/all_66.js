var searchData=
[
  ['find_20package_20modules',['Find Package Modules',['../group__CMakeFindModules.html',1,'']]],
  ['f',['f',['../namespacedoxyfilter-perl.html#a5f3722f40f37bf1a568612dd52aeed51',1,'doxyfilter-perl']]],
  ['fail',['fail',['../classJTap.html#ac8125a708bc1e380caef2d6609d7bbcb',1,'JTap']]],
  ['fetch',['FETCH',['../Readonly_8pm.html#a808ba7d5e3a39039c0f5d89da95ad983',1,'Readonly.pm']]],
  ['fetchsize',['FETCHSIZE',['../Readonly_8pm.html#ac5b3ba0bd1a3e51afbb155140ab73520',1,'Readonly.pm']]],
  ['fi',['fi',['../basistest-cron_8sh.html#ae61e3bc396177088cc8427ab6dfde48a',1,'fi():&#160;basistest-cron.sh'],['../basistest-master_8sh.html#a2430242dc52b9fec75095457ac808899',1,'fi():&#160;basistest-master.sh'],['../basistest-slave_8sh.html#ae9baf3289cfdf9c247d311089fca6757',1,'fi():&#160;basistest-slave.sh'],['../basistest-svn_8sh.html#a2430242dc52b9fec75095457ac808899',1,'fi():&#160;basistest-svn.sh'],['../basistest_8sh.html#a9118011ef11b8aaef09efa26fd914386',1,'fi():&#160;basistest.sh']]],
  ['file',['file',['../basistest-master_8sh.html#a118fb10bf7ab2e6a4b35d927ccf23872',1,'file():&#160;basistest-master.sh'],['../MatlabTools_8cmake.html#ad8bbbbba3413e584f6c72b5ff076e21e',1,'file(WRITE&quot;${OUTPUT_FILE}&quot;&quot;#! /bin/bash

readonly __DIR__=\&quot;${BASIS_BASH___DIR__}\&quot;

errlog=
finish()
{
    local status=0
    if [[ -n \&quot;$errlog\&quot; ]]; then
        grep &apos;??? Error&apos; \&quot;$errlog\&quot; &amp;&gt; /dev/null
        [[ $? -ne 0 ]] || status=1
        /bin/rm \&quot;$errlog\&quot;
    fi
    exit $status
}

if [[ -d \&quot;$TMPDIR\&quot; ]]; then
    tmpdir=$TMPDIR
else
    tmpdir=/tmp
fi

errlog=`mktemp \&quot;$tmpdir/${ARGN_COMMAND}-log.XXXXXX\&quot;`
[[ $? -eq 0 ]] || {
    echo \&quot;Failed to create temporary log file in &apos;$tmpdir&apos;!\&quot; 1&gt;&amp;2
    exit 1
}

args=
while [[ $# -gt 0 ]]; do
  [[ -z \&quot;$args\&quot; ]] || args=\&quot;$args, \&quot;
  args=\&quot;$args&apos;$1&apos;\&quot;
  shift
done

echo &apos;Launching MATLAB to execute ${ARGN_COMMAND} function...&apos;
trap finish EXIT # DO NOT install trap earlier !
&apos;${MATLAB_EXECUTABLE}&apos; -nodesktop -nosplash ${ARGN_OPTIONS} \\
    -r \&quot;try${MATLABPATH}${STARTUP_CODE}, ${ARGN_COMMAND}($args), catch err, fprintf(2, [&apos;??? Error executing ${ARGN_COMMAND}\\n&apos; err.message &apos;\\n&apos;]), end, quit force\&quot; \\
    2&gt; &gt;(tee \&quot;$errlog\&quot; &gt;&amp;2)&quot;) message(FATAL_ERROR&quot;MATLAB MEX script (mex) not found! It is required to build target $:&#160;MatlabTools.cmake'],['../DoxyFilter_8pm.html#a7884474698b5ec93c20c60ec6c72d17c',1,'FILE():&#160;DoxyFilter.pm'],['../Constants_8pm.html#afc938a9bfdcacbb3e4f2145753795510',1,'FILE():&#160;Constants.pm']]],
  ['file_5fpath',['file_path',['../namespacebasisproject.html#a91bd380262674e8016836cfd33262891',1,'basisproject']]],
  ['filename',['fileName',['../namespacedoxyfilter-perl.html#a9f6e44a08dcffe959a89db71af7d82a6',1,'doxyfilter-perl']]],
  ['files',['files',['../Which_8pm.html#a2c3225555b0baee0aa70cad80319cbf1',1,'Which.pm']]],
  ['filetype',['FileType',['../classbasis_1_1argparse_1_1FileType.html',1,'basis::argparse']]],
  ['finalized',['finalized',['../classget__python__lib_1_1easy__install__default.html#a33b05da568e380e7c6679f650a7d92e3',1,'get_python_lib::easy_install_default']]],
  ['find_5ffile',['find_file',['../FindLIBLINEAR_8cmake.html#a83b8181e4d4dbf45d8cc299e16971a58',1,'FindLIBLINEAR.cmake']]],
  ['find_5flibrary',['find_library',['../FindNiftiCLib_8cmake.html#a68ac62c1569f75f3b2d5da7dc26c01be',1,'find_library(NiftiCLib_znz_LIBRARY NAMES znz HINTS ENV LD_LIBRARY_PATH DOC&quot;Path of znz library&quot;) find_path(NiftiCLib_INCLUDE_DIR NAMES nifti/nifti1_io.h HINTS ENV C_INCLUDE_PATH ENV CXX_INCLUDE_PATH DOC&quot;path to directory containing nifti1_io.h file.&quot;) find_library(NiftiCLib_LIBRARY NAMES niftiio HINTS ENV LD_LIBRARY_PATH DOC&quot;Path of niftiio library&quot;) find_library(NiftiCLib_znz_LIBRARY NAMES znz HINTS ENV LD_LIBRARY_PATH DOC&quot;Path of znz library&quot;) set_target_properties(niftiznz PROPERTIES IMPORTED_LINK_INTERFACE_LANGUAGES&quot;CXX&quot;IMPORTED_LOCATION&quot;$:&#160;FindNiftiCLib.cmake'],['../FindOpenCV_8cmake.html#a611ca57b959ea49685af927f155572fa',1,'find_library(OpenCV_ ${__CVLIB}_LIBRARY_DEBUG NAMES&quot;opencv_${__CVLIB}${OpenCV_CVLIB_NAME_SUFFIX}d&quot;&quot;${__CVLIB}${OpenCV_CVLIB_NAME_SUFFIX}d&quot;PATHS&quot;${OpenCV_DIR}/lib&quot;NO_DEFAULT_PATH) find_file(OpenCV_ $:&#160;FindOpenCV.cmake']]],
  ['find_5fpath',['find_path',['../FindGMock_8cmake.html#a7ed2ffc44d2fe1681e58da6b77843a08',1,'find_path(GMock_INCLUDE_DIR NAMES gmock.h HINTS&quot;${GMock_DIR}&quot;PATH_SUFFIXES&quot;include/gmock&quot;DOC&quot;Include directory for Google Mock.&quot;NO_DEFAULT_PATH) find_library(GMock_LIBRARY NAMES gmock HINTS&quot;$:&#160;FindGMock.cmake'],['../FindGTest_8cmake.html#a83b2c106ebfdaabe83fbd88564018ec3',1,'find_path(GTest_INCLUDE_DIR NAMES gtest.h HINTS&quot;${GTest_DIR}&quot;PATH_SUFFIXES&quot;include/gtest&quot;DOC&quot;Include directory for Google Test.&quot;NO_DEFAULT_PATH) find_library(GTest_LIBRARY NAMES gtest HINTS&quot;$:&#160;FindGTest.cmake'],['../FindNiftiCLib_8cmake.html#a5ef50762005ef2626b0aa98b813e068e',1,'find_path(NiftiCLib_INCLUDE_DIR NAMES nifti/nifti1_io.h HINTS ${NiftiCLib_DIR}PATH_SUFFIXES&quot;include&quot;DOC&quot;path to directory containing nifti1_io.h file.&quot;NO_DEFAULT_PATH) find_library(NiftiCLib_LIBRARY NAMES niftiio HINTS $:&#160;FindNiftiCLib.cmake'],['../FindOpenCV_8cmake.html#aafeab0c20e1cec70fcd57e29784c36eb',1,'find_path(OpenCV_INCLUDE_DIR&quot;cv.h&quot;PATH_SUFFIXES&quot;include&quot;&quot;include/opencv&quot;DOC&quot;Directory of cv.h header file.&quot;) set(OpenCV_LIBS) set(OpenCV_COMPONENTS_REQUIRED) set(OpenCV_LIB_COMPONENTS) set(OpenCV_VERSION) find_path(OpenCV_INCLUDE_DIR&quot;cv.h&quot;HINTS $:&#160;FindOpenCV.cmake'],['../FindOpenCV_8cmake.html#acf61cdcc8fadd5300d828e416d65515a',1,'find_path(OpenCV_INCLUDE_DIR&quot;cv.h&quot;PATHS&quot;${OpenCV_DIR}&quot;PATH_SUFFIXES&quot;include&quot;&quot;include/opencv&quot;DOC&quot;Directory of cv.h header file.&quot;NO_DEFAULT_PATH) message(FATAL_ERROR&quot;Unknown OpenCV library component:&#160;FindOpenCV.cmake']]],
  ['find_5fprogram',['find_program',['../FindSVMTorch_8cmake.html#a86f4731d298db92b2068b19a953de374',1,'find_program(SVMTorch_train_EXECUTABLE NAMES SVMTorch HINTS ${SVMTorch_DIR}DOC&quot;The SVMTorch executable.&quot;NO_DEFAULT_PATH) find_program(SVMTorch_train_EXECUTABLE NAMES SVMTorch DOC&quot;The SVMTorch executable.&quot;) find_program(SVMTorch_test_EXECUTABLE NAMES SVMTest HINTS $:&#160;FindSVMTorch.cmake'],['../FindSVMTorch_8cmake.html#a948f9fce5f383fe883204f8df85fd980',1,'find_program(SVMTorch_test_EXECUTABLE NAMES SVMTest DOC&quot;The SVMTest executable.&quot;) find_path(SVMTorch_INCLUDE_DIR NAMES IOTorch.h HINTS&quot;$:&#160;FindSVMTorch.cmake']]],
  ['findafni_2ecmake',['FindAFNI.cmake',['../FindAFNI_8cmake.html',1,'']]],
  ['findbash_2ecmake',['FindBASH.cmake',['../FindBASH_8cmake.html',1,'']]],
  ['findblas_2ecmake',['FindBLAS.cmake',['../FindBLAS_8cmake.html',1,'']]],
  ['findboostnumericbindings_2ecmake',['FindBoostNumericBindings.cmake',['../FindBoostNumericBindings_8cmake.html',1,'']]],
  ['findgmock_2ecmake',['FindGMock.cmake',['../FindGMock_8cmake.html',1,'']]],
  ['findgtest_2ecmake',['FindGTest.cmake',['../FindGTest_8cmake.html',1,'']]],
  ['finditk_2ecmake',['FindITK.cmake',['../FindITK_8cmake.html',1,'']]],
  ['findjythoninterp_2ecmake',['FindJythonInterp.cmake',['../FindJythonInterp_8cmake.html',1,'']]],
  ['findliblinear_2ecmake',['FindLIBLINEAR.cmake',['../FindLIBLINEAR_8cmake.html',1,'']]],
  ['findmatlab_2ecmake',['FindMATLAB.cmake',['../FindMATLAB_8cmake.html',1,'']]],
  ['findmatlabniftitools_2ecmake',['FindMatlabNiftiTools.cmake',['../FindMatlabNiftiTools_8cmake.html',1,'']]],
  ['findmosek_2ecmake',['FindMOSEK.cmake',['../FindMOSEK_8cmake.html',1,'']]],
  ['findnifticlib_2ecmake',['FindNiftiCLib.cmake',['../FindNiftiCLib_8cmake.html',1,'']]],
  ['findopencv_2ecmake',['FindOpenCV.cmake',['../FindOpenCV_8cmake.html',1,'']]],
  ['findperl_2ecmake',['FindPerl.cmake',['../FindPerl_8cmake.html',1,'']]],
  ['findperllibs_2ecmake',['FindPerlLibs.cmake',['../FindPerlLibs_8cmake.html',1,'']]],
  ['findpythoninterp_2ecmake',['FindPythonInterp.cmake',['../FindPythonInterp_8cmake.html',1,'']]],
  ['findpythonmodules_2ecmake',['FindPythonModules.cmake',['../FindPythonModules_8cmake.html',1,'']]],
  ['findsparsebayes_2ecmake',['FindSparseBayes.cmake',['../FindSparseBayes_8cmake.html',1,'']]],
  ['findsphinx_2ecmake',['FindSphinx.cmake',['../FindSphinx_8cmake.html',1,'']]],
  ['findsvmtorch_2ecmake',['FindSVMTorch.cmake',['../FindSVMTorch_8cmake.html',1,'']]],
  ['findweka_2ecmake',['FindWeka.cmake',['../FindWeka_8cmake.html',1,'']]],
  ['fine',['fine',['../Readonly_8pm.html#a3b609eb1144d3ff598171258c0ecb09f',1,'Readonly.pm']]],
  ['firstkey',['FIRSTKEY',['../Readonly_8pm.html#a5dcebba01e44fb011885ec867638d487',1,'Readonly.pm']]],
  ['flags_5fparent',['FLAGS_PARENT',['../shflags_8sh.html#aae80f2ad48c1d946a1ca6be0501045d2',1,'shflags.sh']]],
  ['flags_5fversion',['FLAGS_VERSION',['../shflags_8sh.html#a0517a9737307b4b371aa77e4d2475e1d',1,'shflags.sh']]],
  ['floatarg',['FloatArg',['../group__CxxCmdLine.html#ga3b1b39b2140aebf482b95bea64ee416a',1,'basis']]],
  ['foo',['foo',['../Util_8pm.html#a56ac724da1ff5fb78091e00dad9360ae',1,'Util.pm']]],
  ['for',['for',['../OptList_8pm.html#a1f4fa28975f9b0f6dc0c6347ceabab99',1,'OptList.pm']]],
  ['for_2epm',['For.pm',['../For_8pm.html',1,'']]],
  ['force',['force',['../classget__python__lib_1_1easy__install__default.html#aad9e8937721f0f2b316535a6289d97bc',1,'get_python_lib.easy_install_default.force()'],['../MatlabTools_8cmake.html#abfe32c6b20d37f91b969a96eb05a3fd4',1,'force():&#160;MatlabTools.cmake'],['../namespaceupdatefile.html#a2c79b89bb1322b48b0da06ec8055d4e4',1,'updatefile.force()']]],
  ['foreach',['foreach',['../View_8pm.html#affddc504d4d83a079e37b031d7f30d3a',1,'foreach(reverse @$visit):&#160;View.pm'],['../CommonTools_8cmake.html#a8a330adf7e4e7f7a276c2780f6b17071',1,'foreach(_FP_VAR IN ITEMS FOUND DIR USE_FILE VERSION VERSION_STRING VERSION_MAJOR VERSION_MINOR VERSION_PATCH INCLUDE_DIR INCLUDE_DIRS INCLUDE_PATH LIBRARY_DIR LIBRARY_DIRS LIBRARY_PATH) if(DEP MATCHES&quot;^([^ ]+)[ \\n\\t]*:&#160;CommonTools.cmake']]],
  ['format_5fhelp',['format_help',['../classbasis_1_1argparse_1_1HelpFormatter_1_1__Section.html#ab24537e5263da6f6b863a41c6af851d9',1,'basis.argparse.HelpFormatter._Section.format_help()'],['../classbasis_1_1argparse_1_1HelpFormatter.html#a56f3a8da72d7b76dade2f2b511481c0b',1,'basis.argparse.HelpFormatter.format_help()'],['../classbasis_1_1argparse_1_1ArgumentParser.html#aa20e175f8ae8b99cc8c1990f68a767a3',1,'basis.argparse.ArgumentParser.format_help()']]],
  ['format_5fusage',['format_usage',['../classbasis_1_1argparse_1_1ArgumentParser.html#a37a4dbc7f17d03de6640260886f65720',1,'basis::argparse::ArgumentParser']]],
  ['format_5fversion',['format_version',['../classbasis_1_1argparse_1_1ArgumentParser.html#a6486261d9375324ae77a723046df1b7b',1,'basis::argparse::ArgumentParser']]],
  ['formatter',['formatter',['../classbasis_1_1argparse_1_1HelpFormatter_1_1__Section.html#a1a4faefe1e41960026a126b80ace2ed1',1,'basis::argparse::HelpFormatter::_Section']]],
  ['formatter_5fclass',['formatter_class',['../classbasis_1_1argparse_1_1ArgumentParser.html#acd44157a10e1b9bfeb7ae3cd4d756d79',1,'basis::argparse::ArgumentParser']]],
  ['fprintf',['fprintf',['../MatlabTools_8cmake.html#a1e1cfa23218f094a20f169b8675342a9',1,'fprintf(2, &apos;???Error:Failed to open file ${OUTPUT_FILE}for writing!&apos;):&#160;MatlabTools.cmake'],['../MatlabTools_8cmake.html#ac0699d37ad72a5b5827a4772b22a3f6b',1,'fprintf(fid, &apos;${MATLAB_EXECUTABLE}\\n%s\\n&apos;, version) fclose(fid) quit force&quot; ) execute_process ( COMMAND $:&#160;MatlabTools.cmake']]],
  ['from',['from',['../Install_8pm.html#ac66c11ce84f4ecc25614a4bc04b593d1',1,'from():&#160;Install.pm'],['../UtilitiesTools_8cmake.html#aa6090bf34a1288ff78c3d0aed68de755',1,'from():&#160;UtilitiesTools.cmake']]],
  ['fromfile_5fprefix_5fchars',['fromfile_prefix_chars',['../classbasis_1_1argparse_1_1ArgumentParser.html#a12327b78d7d6aaa3d95c126d2309d9e1',1,'basis::argparse::ArgumentParser']]],
  ['full_5foutput',['full_output',['../testdriver_8h.html#a80cc8aa7b708dcadb32c4822b2015d2d',1,'testdriver.h']]],
  ['function',['FUNCTION',['../Python_8pm.html#a8807407e8283a618c42d1f1abcbfbbb4',1,'Python.pm']]],
  ['functions',['functions',['../Util_8pm.html#abf0834a85ef9e8a0c2fb1f8407d74d36',1,'functions():&#160;Util.pm'],['../Readonly_8pm.html#a75cab06ee2e4bf0e99fdcbddb35fb5e6',1,'functions():&#160;Readonly.pm']]],
  ['fuzzy',['fuzzy',['../Util_8pm.html#a4f4e2b7b70f82ff94f08733bf304c742',1,'Util.pm']]]
];
