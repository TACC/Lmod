#!/bin/bash
# script to update Lmod system cache
# author: Kenneth Hoste (kenneth.hoste@ugent.be)
#
# loosely based on https://github.com/TACC/Lmod/tree/master/contrib/BuildSystemCacheFile

#DEBUG=${DEBUG-0} #  debug off
DEBUG=${DEBUG-1}  # debug on
debug() {
    if [ $DEBUG -ne 0 ]
    then
        echo
        echo "[DEBUG] $1"
        echo 
    fi
}

# run spider command to generate specified cache type to specified file path
run_spider() {
    cache_type=$1
    cache_file_path=$2

    debug "Generating new Lmod cache file @ $cache_file_path"
    debug "Running \"spider -o $cache_type $MODULEPATH > $cache_file_path\""
    spider -o $cache_type $MODULEPATH > $cache_file_path

    SPIDER_EXIT_CODE=$?
    debug "Exit code of spider command: $SPIDER_EXIT_CODE"

    if [ $SPIDER_EXIT_CODE -ne 0 ]
    then
        echo "Failed to update Lmod spider cache (exit code: $SPIDER_EXIT_CODE)"
        exit 1
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
    debug "Putting new cache file ${cache_file_path}.new.${cache_ext} in place @ ${cache_file_path}.${cache_ext}"
    mv ${cache_file_path}.new.${cache_ext} ${cache_file_path}.${cache_ext}
}

# update Lmod cache files (both .lua and .luac_*)
update_cache() {
    cache_type=$1
    cache_file_name=$LMOD_CACHE_DIR/${cache_type} #.lua

    debug "cache_file_name: $cache_file_name"

    # cleanup
    debug "Cleaning up ${cache_file_name}*.old.*, ${cache_file_name}*.new.*"
    debug "`ls -l ${cache_file_name}.* 2> /dev/null`"
    rm -f ${cache_file_name}*.old.* ${cache_file_name}*.new.*

    # generate new plain-text Lmod cache file (.lua)
    run_spider $cache_type ${cache_file_name}.new.lua
    install_new_cache lua ${cache_file_name}

    # also install compiled Lmod cache version
    # include Lua version in filename of compiled cache, to avoid compatibility issues when Lua is upgraded
    lua_ver=$(lua -e 'print((_VERSION:gsub("Lua ","")))')
    luac -o ${cache_file_name}.new.luac_$lua_ver ${cache_file_name}.lua
    install_new_cache luac_$lua_ver ${cache_file_name}
}


# figure out location of Lmod cache and cache timestamp file via 'ml --config'
LMOD_CACHE_DIR=`ml --config 2>&1 | grep -A 2 "Cache Directory" | tail -1 | tr -s ' ' | cut -f1 -d' '`
LMOD_CACHE_TIMESTAMP_FILE=`ml --config 2>&1 | grep -A 2 "Cache Directory" | tail -1 | tr -s ' ' | cut -f2 -d' '`

if [ $DEBUG -ne 0 ]
then
    debug "LMOD_CACHE_DIR: $LMOD_CACHE_DIR"
    debug "LMOD_CACHE_TIMESTAMP_FILE: $LMOD_CACHE_TIMESTAMP_FILE"
fi

# make sure directories are there
debug "Creating directories $LMOD_CACHE_DIR and `dirname $LMOD_CACHE_TIMESTAMP_FILE`"
mkdir -p $LMOD_CACHE_DIR
mkdir -p `dirname $LMOD_CACHE_TIMESTAMP_FILE`

# generate new cache timestamp file
# timestamp file marks time of last change to the system, and *must* be older than the Lmod cache itself
debug "Cleaning up ${LMOD_CACHE_TIMESTAMP_FILE}.*"
debug "`ls -l ${LMOD_CACHE_TIMESTAMP_FILE}.* 2> /dev/null`"
rm -rf ${LMOD_CACHE_TIMESTAMP_FILE}.new

debug "Updating Lmod cache timestamp file @ ${LMOD_CACHE_TIMESTAMP_FILE}.new"
touch ${LMOD_CACHE_TIMESTAMP_FILE}.new  # leave timestamp file empty on purpose, because Lmod uses contents to try to do magic

update_cache moduleT
update_cache dbT
#update_cache reverseMapT

# put new timestamp in place
mv ${LMOD_CACHE_TIMESTAMP_FILE}.new $LMOD_CACHE_TIMESTAMP_FILE
