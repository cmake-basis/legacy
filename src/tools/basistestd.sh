#! /usr/bin/env bash

##############################################################################
# \file  basistestd.sh
# \brief Test "daemon" which can be run as a cron job.
#
# This shell script is supposed to be scheduled as cron job. On execution,
# it parses the configuration file and executes the configured tests.
#
# Note: This script runs on Linux only. It may need to be modified for other
#       Unix systems. In particular, it does not run on Mac OS.
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

# absolute path of CTest script
ctestScript="$progDir/@MODULES_DIR@/nightly.ctest"

# absolute path of tests configuration file
#confFile='/etc/basistestd.conf'
confFile="$progDir/@DATA_DIR@/basistestd.conf"

# absolute path of file with timestamps for next test execution
#scheduleFile='/var/run/basistestd.schedule'
scheduleFile="$progDir/@DATA_DIR@/basistestd.schedule"

# command used to submit test jobs
submitCmd='qsub -l centos5'

# ============================================================================
# help/version
# ============================================================================

# ****************************************************************************
# \brief Print version information.
printVersion ()
{
    if [ ! -z $revision -o $revision -gt 0 ]; then
        echo "basistestd (BASIS) $version (Rev. $revision)"
    else
        echo "basistestd (BASIS) $version"
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
Options:
  -V [ --verbose ]   Increases verbosity of output messages. Can be given multiple times.
  -h [ --help ]      Print this help and exit.
  -u [ --usage ]     Print usage and exit.
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
  
Configuration:
  The format of the configuration file is detailed here. Comments within the
  configuration file start with a '#' character at the beginning of each line.

  For each test of a specific branch of a project, the configuration file
  contains a line following the format:

    <m>:<h>:<d>:<project>:<branch>:<model>:<options>

  where

    <m>         Interval in minutes between consecutive test runs.
                Defaults to "0" if "x" is given.
    <h>         Interval in hours between consecutive test runs.
                Defaults to "0" if "x" is given.
    <d>         Interval in days (i.e., multiples of 24 hours) between consecutive
                test runs. Defaults to "1" if "x" is given.
    <project>   Name of the BASIS project.
    <branch>    Branch within the project's SVN repository, e.g., "tags/1.0.0".
                Defaults to "trunk" if a "x" is given.
    <model>     Dashboard model, i.e., either one of "Nightly", "Continuous",
                and "Experimental". Defaults to "Nightly".
    <options>   Additional options to the CTest script.
                The "nightly.ctest" script of BASIS is used by default.
                Run "ctest -S <path>/nightly.ctest,help" to get a list of
                available options. By default, the default options of the
                CTest script are used.

  For example, nightly tests of the main development branch (trunk) of the
  project BASIS itself which are run once every day including coverage
  analysis and memory checks are scheduled by

    x:x:1:BASIS:trunk:Nightly:coverage,memcheck

  Attention: The entire line may not contain any whitespace character!
EOF-DESCRIPTION
    echo
    printOptionsSection
    echo
    cat - << EOF-EXAMPLES
Examples:
  $progName --version

    Prints version information and exits.
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
# helpers
# ============================================================================

# ****************************************************************************
# \brief Runs a test given the arguments in the configuration file.
runTest ()
{
    cmd="$submitCmd ctest"
    if [ $verbosity -gt 0 ]; then cmd="$cmd -V"; fi
    cmd="$cmd -S $ctestScript,project=$1,branch=$2,model=$3"
    if [ ! -z "$options" ]; then cmd="$cmd,$options"; fi
    echo "> $cmd"
    $cmd
    return $?
}

# ****************************************************************************
# \brief Convert date to timestamp.
#
# \param [in] $1 UTC date.
#
# \return Timestamp corresponding to given date.
date2stamp ()
{
    date --utc --date "$1" +%s
}

# ****************************************************************************
# \brief Convert timestamp to date.
#
# \param [in] $1 Timestamp.
#
# \return UTC date corresponding to given timestamp.
stamp2date ()
{
    date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
}

# ****************************************************************************
# \brief Adds a certain time interval to a given date.
#
# \param [in] $1 Unit of the time interval. Either one of -s, -m, -h, or -d.
#                Defaults to number of days.
# \param [in] $2 The date to which the time interval is added.
# \param [in] $3 The time interval given in the specified units.
#
# \return The date which is $3 time units after the given date.
dateAdd ()
{
    case $1 in
        -s) sec=1;      shift;;
        -m) sec=60;     shift;;
        -h) sec=3600;   shift;;
        -d) sec=86400;  shift;;
         *) sec=86400;;
    esac
    local dte1=$(date2stamp $1)
    local interval=$2
    local addSec=$((dte1 + interval * sec))
    echo $(stamp2date $addSec)
}

# ****************************************************************************
# \brief Computes the time interval between two given dates.
#
# \param [in] $1 Unit of the time interval. Either one of -s, -m, -h, or -d.
#                Defaults to number of days.
# \param [in] $2 The first date.
# \param [in] $3 The second date.
#
# \return Time interval, i.e., an absolute value, in the given units.
dateDiff ()
{
    case $1 in
        -s) sec=1;      shift;;
        -m) sec=60;     shift;;
        -h) sec=3600;   shift;;
        -d) sec=86400;  shift;;
         *) sec=86400;;
    esac
    local dte1=$(date2stamp $1)
    local dte2=$(date2stamp $2)
    local interval=$((dte2 - dte1))
    echo $((interval / sec))
}

# ****************************************************************************
# \brief Get next scheduled date of a given test.
scheduleDate ()
{
    local retval='now'
    for line in ${schedule[@]}; do
        parts=(`echo $line | tr ':' ' '`)
        num=${#parts[@]}
        if [ $num -lt 6 -o $num -gt 7 ]; then continue; fi
        if [    "${parts[3]}" == "$2" \
             -a "${parts[4]}" == "$3" \
             -a "${parts[5]}" == "$4" \
             -a "${parts[6]}" == "$5" ]
        then
            retval="${parts[0]} ${parts[1]}:${parts[2]}"
        fi
    done
    echo "$retval"
}

# ***************************************************************************
# \brief Add entry to test schedule.
scheduleTest ()
{
    idx=${#newSchedule[@]}
    ((idx++))
    local dt=$(date --utc --date "$1" "+%Y-%m-%d:%H:%M")
    newSchedule[$idx]="$dt:$2:$3:$4:$5"
}

# ============================================================================
# options
# ============================================================================

verbosity=0

while [ $# -gt 0 ]; do
	case "$1" in
		-h|--help)
			printHelp
			exit 0
			;;

		-u|--usage)
			printUsage
			exit 0
			;;
        -v|--version)
            printVersion
            exit 0
            ;;
        -V|--verbose)
            ((verbosity++))
            ;;
    esac
done

# ============================================================================
# main
# ============================================================================

# check existence of configuration file
if [ ! -f "$confFile" ]; then
    echo "Missing configuration file $confFile" 1>&2
    exit 1
fi

# check existence of ctest command
which ctest > /dev/null
if [ $? -ne 0 ]; then
    echo "Could not find ctest command in the PATH" 1>&2
    exit 1
fi

# check existence of CTest script
if [ ! -f "$ctestScript" ]; then
    echo "Missing CTest script $ctestScript" 1>&2
    exit 1
fi

# parse existing test schedule
schedule=()
if [ -f "$scheduleFile" ]; then
    idx=0
    while read line; do
        schedule[$idx]=$line
        ((idx++))
    done < $scheduleFile
fi

# variables set by readConfLine () which store the configuration for a
# particular test run
minutes=0
hours=0
days=0
project=''
branch=''
model=''
options=''

# read configuration file line by line
linenumber=0
errors=0
while read line; do
    ((linenumber++))
    # skip empty lines
    if [ -z "$line" ]; then continue; fi
    # skip comments
    if [[ "$line" =~ "^#" ]]; then continue; fi
    # parse line
    parts=(`echo $line | tr ':' ' '`)
    num=${#parts[@]}
    if [ $num -lt 4 ]; then
        echo "$confFile:$linenumber: Invalid configuration, skipping test" 1>&2
        ((errors++))
        continue
    fi
    minutes=${parts[0]}
    hours=${parts[1]}
    days=${parts[2]}
    project=${parts[3]}
    branch=${parts[4]}
    model=${parts[5]}
    options=${parts[6]}
    # check arguments
    if [ -z "$minutes" -o -z "$hours" -o -z "$days" ]; then
        echo "$confFile:$linenumber: Invalid configuration, skipping test" 1>&2
        ((errors++))
        continue
    fi
    if [ "$minutes" == "x" ]; then minutes=0; fi
    if [ "$hours"   == "x" ]; then hours=0;   fi
    if [ "$days"    == "x" ]; then days=0;   fi
    if [ $minutes -eq 0 -a $hours -eq 0 -a $days -eq 0 ]; then
        echo "$confFile:$linenumber: Invalid test interval, skipping test" 1>&2
        ((errors++))
        continue
    fi
    if [ -z "$project" ]; then
        echo "$confFile:$linenumber: No project name given, skipping test" 1>&2
        ((errors++))
        continue
    fi
    if [ -z "$branch" ]; then
        branch='trunk'
    fi
    if [ -z "$model" ]; then
        model='Nightly'
    fi
    # determine whether test is already due for execution
    nextDate=$(scheduleDate $schedule $project $branch $model $options)
    if [ $(dateDiff -m 'now' $nextDate) -gt 0 ]; then
        echo "Next $model test of $project ($branch) with options \"$options\" is scheduled for $nextDate UTC"
        # skip test as it is not yet scheduled for execution
        scheduleTest "$nextDate" "$project" "$branch" "$model" "$options"
        continue
    fi
    # run test
    runTest $project $branch $model $options
    if [ $? -ne 0 ]; then
        echo "$confFile:$linenumber: Failed to run test" 1>&2
        ((errors++))
        # try again after a fixed time
        minutes=0
        hours=1
        days=0
    fi
    # update time of next execution
    nextDate=$(date --utc --date "$nextDate" "+%Y-%m-%d %T")
    minutes=$((minutes + hours * 60 + days * 1440))
    nextDate=$(dateAdd -m 'now' $minutes)
    scheduleTest "$nextDate" "$project" "$branch" "$model" "$options"
    if [ $? -ne 0 ]; then
        echo "$confFile:$linenumber: Failed to reschedule test" 1>&2
        ((errors++))
    fi
done < "$confFile"

# write new schedule
rm -f $scheduleFile
for line in ${newSchedule[@]}; do
    echo "$line" >> $scheduleFile
done
sort "$scheduleFile" -o "$scheduleFile"

# done
if [ $errors -ne 0 ]; then
    exit 1
fi
exit 0
