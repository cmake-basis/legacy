#!/bin/bash
set -e

[ -n "$TRAVIS_BUILD_DIR" ] || { echo "Script must be run within Travis CI environment" 1>&2; exit 1; }

# Test installation prefix
[ -n "$prefix" ] || prefix="/tmp/local"

# BASIS configuration
[ -n "$utilities" ] || utilities=yes
[ -n "$tools"     ] || tools=yes
[ -n "$example"   ] || example=yes
[ -n "$doc"       ] || doc=no
[ -n "$tests"     ] || tests=no

# Update package managers
[[ $TRAVIS_OS_NAME != linux ]] || sudo apt-get update -qq
[[ $TRAVIS_OS_NAME != osx   ]] || brew update
[ -z "$(which pip)" ] || pip install --upgrade pip

# Use dependencies built and installed from sources
export PATH="$prefix/bin:$PATH"
[[ $TRAVIS_OS_NAME != linux ]] || export   LD_LIBRARY_PATH="$prefix/lib:$LD_LIBRARY_PATH"
[[ $TRAVIS_OS_NAME != osx   ]] || export DYLD_LIBRARY_PATH="$prefix/lib:$DYLD_LIBRARY_PATH"

# Install required dependencies
[ -z "$cmake"  ] || [[ $cmake  == any  ]] || $TRAVIS_BUILD_DIR/test/build/cmake.sh  "$cmake"  "$prefix"
[ -z "$itk"    ] || [[ $itk    == none ]] || $TRAVIS_BUILD_DIR/test/build/itk.sh    "$itk"    "$prefix"
[ -z "$jython" ] || [[ $jython == none ]] || {
  $TRAVIS_BUILD_DIR/test/build/jython.sh "$jython" "$prefix/jython-$jython"
  export PATH="$prefix/jython-$jython/bin:$PATH"
}

if [[ $doc == yes ]]; then
  [[ $TRAVIS_OS_NAME != linux ]] || sudo apt-get install -y graphviz
  [[ $TRAVIS_OS_NAME != osx   ]] || brew install graphviz
  $TRAVIS_BUILD_DIR/test/build/doxygen.sh "$doxygen" $prefix
  $TRAVIS_BUILD_DIR/test/build/sphinx.sh  "$sphinx"  $prefix
fi
