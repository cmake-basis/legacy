#! /usr/bin/env bash

##############################################################################
# \file  basistest.sh
# \brief Test execution command.
#
# This shell script runs the tests of a BASIS project. It is a wrapper for
# the CTest script. In particular, the testing master script or "daemon"
# basistestd uses this script by default in order to run a test.
#
# Copyright (c) 2011 University of Pennsylvania. All rights reserved.
# See COPYING file or https://www.rad.upenn.edu/sbia/software/license.html.
#
# Contact: SBIA Group <sbia-software at uphs.upenn.edu>
##############################################################################

# ============================================================================
# BASIS functions (automatically generated by BASIS)
# ============================================================================

@BASH_FUNCTION_getProgDir@
@BASH_FUNCTION_getProgName@

# ============================================================================
# settings
# ============================================================================

# executable information
progName=$(getProgName)
progDir=$(getProgDir)
version='@VERSION@'
revision='@REVISION@'

# ============================================================================
# help/version
# ============================================================================

# ****************************************************************************
# \brief Print version information.
printVersion ()
{
    if [ ! -z $revision -o $revision -gt 0 ]; then
        echo "basistest (BASIS) $version (Rev. $revision)"
    else
        echo "basistest (BASIS) $version"
    fi
    cat - << EOF-COPYRIGHT
Copyright (c) 2011 University of Pennsylvania. All rights reserved.
See COPYING file or https://www.rad.upenn.edu/sbia/software/license.html.
EOF-COPYRIGHT
}

# ****************************************************************************
# \brief Print usage section of help/usage.
printUsageSection ()
{
    echo "Usage:"
    echo "  $progName [options]"
}

# ****************************************************************************
# \brief Print documentation of options.
printOptionsSection ()
{
    cat - << EOF-OPTIONS
Required options:
  -p [ --project ]   The name of the BASIS project to be tested.

Options:
  -b [ --branch ]    The branch to be tested, e.g., "tags/1.0.0".
                     Defaults to "trunk".
  -m [ --model ]     The name of the dashboard model, i.e., either "Nightly",
                     "Continuous", or "Experimental". Defaults to "Nightly".
  -S [ --script ]    CTest script which performs the testing.
                     Defaults to the "basisctest" script of BASIS.
  -a [ --args ]      Additional arguments for the CTest script.
  -V [ --verbose ]   Increases verbosity of output messages. Can be given multiple times.
  -h [ --help ]      Print help and exit.
  -u [ --usage ]     Print usage information and exit.
  -v [ --version ]   Print version information and exit.
EOF-OPTIONS
}

# ****************************************************************************
# \brief Print contact information.
printContactSection ()
{
    echo "Contact:"
    echo "  SBIA Group <sbia-software at uphs.upenn.edu>"
}

# ****************************************************************************
# \brief Print help.
printHelp ()
{
    echo "$progName (BASIS)"
    echo
    printUsageSection
    echo
    cat - << EOF-DESCRIPTION
Description:
  This program performs the testing of specified BASIS project at SBIA.
EOF-DESCRIPTION
    echo
    printOptionsSection
    echo
    cat - << EOF-EXAMPLES
Examples:
  $progName -p BASIS -a coverage,memcheck

    Performs the testing of the project BASIS itself, including coverage
    analysis and memory checks.
EOF-EXAMPLES
    echo
    printContactSection
}

# ****************************************************************************
# \brief Print usage (i.e., only usage and options).
printUsage ()
{
    echo "$progName (BASIS)"
    echo
    printUsageSection
    echo
    printOptionsSection
    echo
    printContactSection
}

# ============================================================================
# options
# ============================================================================

# CTest script
ctestScript="$progDir/basisctest"

project=''      # name of the BASIS project
branch='trunk'  # the branch to test
model='Nightly' # the dashboard model
args=''         # additional CTest script arguments
verbosity=0     # verbosity of output messages

while [ $# -gt 0 ]; do
	case "$1" in
        -p|--project)
            shift
            if [ $# -gt 0 ]; then
                project=$1
            else
                echo "Option -c [ --conf ] requires an argument!" 1>&2
                exit 1
            fi
            ;;
        -b|--branch)
            shift
            if [ $# -gt 0 ]; then
                branch=$1
            else
                echo "Option -b [ --branch ] requires an argument!" 1>&2
                exit 1
            fi
            ;;
        -m|--model)
            shift
            if [ $# -gt 0 ]; then
                model=$1
            else
                echo "Option -m [ --model ] requires an argument!" 1>&2
                exit 1
            fi
            ;;
        -S|--script)
            shift
            if [ $# -gt 0 ]; then
                ctestScript=$1
            else
                echo "Option -S [ --script ] requires an argument!" 1>&2
                exit 1
            fi
            ;;
        -a|--args)
            shift
            if [ $# -gt 0 ]; then
                args=$1
            else
                echo "Option -a [ --args ] requires an argument!" 1>&2
                exit 1
            fi
            ;;

        # standard options
		-h|--help)    printHelp;    exit 0; ;;
		-u|--usage)   printUsage;   exit 0; ;;
        -v|--version) printVersion; exit 0; ;;
        -V|--verbose) ((verbosity++)); ;;

        # invalid option
        *)
            printUsage
            echo
            echo "Invalid option $1!" 1>&2
            ;;
    esac
    shift
done

# check options
if [ -z "$project" ]; then
    printUsage
    echo
    echo "No project specified!" 1>&2
    exit 1
fi

# ============================================================================
# main
# ============================================================================

# see if ctest can be found
which ctest &> /dev/null
if [ $? -ne 0 ]; then
    echo "Could not find the ctest command" 1>&2
    exit 1
fi

# check existence of CTest script
if [ ! -f "$ctestScript" ]; then
    echo "Missing CTest script $ctestScript" 1>&2
    exit 1
fi

# compose command
cmd='ctest'
if [ $verbosity -gt 2 ]; then
    cmd="$cmd -VV"
elif [ $verbosity -gt 1 ]; then
    cmd="$cmd -V"
fi
cmd="$cmd -S $ctestScript,project=$project,branch=$branch,model=$model"
if [ ! -z "$args" ]; then cmd="$cmd,$args"; fi
cmd="$cmd"

# run test
if [ $verbosity -gt 0 ]; then
    echo "$> $cmd"
fi
exec $cmd
