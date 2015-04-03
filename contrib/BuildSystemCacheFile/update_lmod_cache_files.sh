#!/bin/bash
##
#
#  Script to update Lmod cache files.
#
#  author: Kenneth Hoste (kenneth.hoste@ugent.be)
#
#  This script is licensed under the terms of the MIT license reproduced below.
#  This means that Lmod is free software and can be used for both academic
#  and commercial purposes at absolutely no cost.
#
##
#
#  Copyright (C) 2015-2015 Ghent University
#
#  Permission is hereby granted, free of charge, to any person obtaining
#  a copy of this software and associated documentation files (the
#  "Software"), to deal in the Software without restriction, including
#  without limitation the rights to use, copy, modify, merge, publish,
#  distribute, sublicense, and/or sell copies of the Software, and to
#  permit persons to whom the Software is furnished to do so, subject
#  to the following conditions:
#
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
#  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
#  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#
##

#
# loosely based on https://github.com/TACC/Lmod/tree/master/contrib/BuildSystemCacheFile/createSystemCacheFile.sh

#
# Script parameters (these can be tweaked via the provided command line options)
#

# exit on any error
set -e

# print debug info (default: False)
DEBUG=0

# location of cache directory
LMOD_CACHE_DIR=

# location of cache timestamp file
LMOD_CACHE_TIMESTAMP_FILE=

# contents for cache timestamp file
LMOD_CACHE_TIMESTAMP_FILE_TXT=

# update reverseMapT cache file
UPDATE_REVERSEMAPT_CACHE=0

#
# Utility functions
#

# print debug info
debug() {
    if [ $DEBUG -ne 0 ]; then
        echo "[DEBUG] $1"
    fi
}

# print error to stderr and exit
error() {
    echo "ERROR: $1" >&2
    exit 1
}

# print warning to stderr
warning() {
    echo "WARNING: $1" >&2
}


# print help w.r.t. script usage and command line options
print_help() {
    echo
    echo "Script to update Lmod cache files"
    echo
    echo "Available command line options:"
    echo "  -d"
    echo "      location of Lmod cache directory (default: determine via 'ml --config')"
    echo "  -D"
    echo "      enable debug printing"
    echo "  -h/-H"
    echo "      print (this) help and exit"
    echo "  -m"
    echo "      use specified path rather than current \$MODULEPATH"
    echo "  -t"
    echo "      location of Lmod cache timestamp file (default: determine via 'ml --config')"
    echo "  -T"
    echo "      contents for Lmod cache timestamp file (defailt: none, empty timestamp file)"
    echo "  -r"
    echo "      enable updating reverseMapT cache file (default: only moduleT and dbT cache files)"
    echo
}

# parse command line options using getopts
# see http://www.tldp.org/LDP/abs/html/internal.html#EX33
parse_cmdline(){
    debug "Parsing command line options..."
    local OPTIND
    while getopts :d:DhHm:t:T:r opt; do
        case $opt in
            d)
                LMOD_CACHE_DIR=$OPTARG
                ;;
            D)
                DEBUG=1
                ;;
            h|H)
                print_help
                exit 0
                ;;
            m)
                MODULEPATH=$OPTARG
                ;;
            t)
                LMOD_CACHE_TIMESTAMP_FILE=$OPTARG;
                ;;
            T)
                LMOD_CACHE_TIMESTAMP_FILE_TXT=$OPTARG;
                ;;
            r)
                UPDATE_REVERSEMAPT_CACHE=1
                ;;
            \?)
                print_help
                error "Unknown option specified: -$OPTARG"
                ;;
            :)
                print_help
                error "Option -$OPTARG requires an argument"
                ;;
        esac
    done

    # shift command line options so other arguments are accessible via $@ or $1, etc.
    shift $((OPTIND - 1))
}


# set default values for undefined parameters
set_defaults() {
    # FIXME: run ml --config once, check exit code, make sure only one cache dir/timestamp file is listed
    if [ -z $LMOD_CACHE_DIR ]; then
        LMOD_CACHE_DIR=`ml --config 2>&1 | grep -A 2 "Cache Directory" | tail -1 | tr -s ' ' | cut -f1 -d' '`
    fi

    if [ -z $LMOD_CACHE_TIMESTAMP_FILE ]; then
        LMOD_CACHE_TIMESTAMP_FILE=`ml --config 2>&1 | grep -A 2 "Cache Directory" | tail -1 | tr -s ' ' | cut -f2 -d' '`
    fi
}

# check script parameters (only in debug mode)
check_parameters() {
    # required parameters
    for param in LMOD_CACHE_DIR LMOD_CACHE_TIMESTAMP_FILE
    do
        debug "\$${param}: ${!param}"
        if [ -z ${!param} ]; then
            error "\$$param is undefined"
        fi
    done
    # optional parameters
    for param in LMOD_CACHE_TIMESTAMP_FILE_TXT
    do
        debug "\$${param}: ${!param}"
    done
}

# make preparations
prepare() {
    # make sure directories are there
    debug "Creating directories $LMOD_CACHE_DIR and `dirname $LMOD_CACHE_TIMESTAMP_FILE`"
    mkdir -p $LMOD_CACHE_DIR
    mkdir -p `dirname $LMOD_CACHE_TIMESTAMP_FILE`
}

# create new cache timestamp file
new_timestamp() {
    debug "Cleaning up existing file ${LMOD_CACHE_TIMESTAMP_FILE}.new (if any)"
    debug "ls -l \${LMOD_CACHE_TIMESTAMP_FILE}.new: `ls -l ${LMOD_CACHE_TIMESTAMP_FILE}.new 2> /dev/null`"
    rm -f ${LMOD_CACHE_TIMESTAMP_FILE}.new

    debug "Creating Lmod cache timestamp file @ ${LMOD_CACHE_TIMESTAMP_FILE}.new"
    if [ -z $LMOD_CACHE_TIMESTAMP_FILE_TXT ]
    then
        debug "Creating empty timestamp file at ${LMOD_CACHE_TIMESTAMP_FILE}.new"
        touch ${LMOD_CACHE_TIMESTAMP_FILE}.new
    else
        debug "Creating timestamp file at ${LMOD_CACHE_TIMESTAMP_FILE}.new with following contents:"
        debug "$LMOD_CACHE_TIMESTAMP_FILE_TXT"
        echo $LMOD_CACHE_TIMESTAMP_FILE_TXT > ${LMOD_CACHE_TIMESTAMP_FILE}.new
    fi
}

# install new cache file (.lua or .luac_*)
install_new_cache() {
    cache_ext=$1
    cache_file_path=$2
    chmod 644 ${cache_file_path}.new.${cache_ext}

    # back up existing cache file
    if [ -f ${cache_file_path}.${cache_ext} ]
    then
        debug "Backup up old Lmod cache file ${cache_file_path}.${cache_ext}"
        cp -p ${cache_file_path}.${cache_ext} ${cache_file_path}.old.${cache_ext}
        debug "`ls -l ${cache_file_path}.old.${cache_ext}`"
    fi

    # put new cache file in place
    debug "Putting new cache file ${cache_file_path}.new.${cache_ext} in place at ${cache_file_path}.${cache_ext}"
    mv ${cache_file_path}.new.${cache_ext} ${cache_file_path}.${cache_ext}
}

# run spider command to generate specified cache type to specified file path
run_spider() {
    cache_type=$1
    cache_file_path=$2

    debug "Generating new $cache_type Lmod cache file at $cache_file_path"
    debug "Running \"spider -o $cache_type $MODULEPATH > $cache_file_path\""
    spider -o $cache_type $MODULEPATH > $cache_file_path

    SPIDER_EXIT_CODE=$?
    debug "Exit code of spider command: $SPIDER_EXIT_CODE"

    if [ $SPIDER_EXIT_CODE -ne 0 ]; then
        error "Failed to update Lmod spider cache (exit code: $SPIDER_EXIT_CODE)"
    fi
}

# update Lmod cache files (both .lua and .luac_*)
update_cache() {
    cache_type=$1
    cache_file_name=$LMOD_CACHE_DIR/${cache_type}

    debug "Updating $cache_type Lmod cache at $cache_file_name"

    # cleanup
    debug "Cleaning up ${cache_file_name}*.old.*, ${cache_file_name}*.new.*"
    debug "ls -l ${cache_file_name}.*: `ls -l ${cache_file_name}.* 2> /dev/null`"
    rm -f ${cache_file_name}*.old.* ${cache_file_name}*.new.*

    # generate new plain-text Lmod cache file (.lua)
    run_spider $cache_type ${cache_file_name}.new.lua
    install_new_cache lua ${cache_file_name}

    # also install compiled Lmod cache version
    # include Lua version in filename of compiled cache, to avoid compatibility issues when Lua is upgraded
    # FIXME: only when lua and luac are available?
    lua_ver=$(lua -e 'print((_VERSION:gsub("Lua ","")))')
    luac -o ${cache_file_name}.new.luac_$lua_ver ${cache_file_name}.lua
    install_new_cache luac_$lua_ver ${cache_file_name}
}

#
# MAIN
#
parse_cmdline $@

# put defaults in place for parameters that were not set
set_defaults

# check parameters (make sure they are defined)
check_parameters

# make the necessary preparations
prepare

# create new timestamp file
# timestamp file marks time of last change to the system, and *must* be older than the Lmod cache files themselves
# a timestamp file that is more recent than the Lmod cache file(s) indicates cache invalidity
new_timestamp

# update cache files
update_cache moduleT
update_cache dbT
if [ $UPDATE_REVERSEMAPT_CACHE -ne 0 ]; then
    update_cache reverseMapT
fi

# put new timestamp file in place
mv ${LMOD_CACHE_TIMESTAMP_FILE}.new $LMOD_CACHE_TIMESTAMP_FILE
