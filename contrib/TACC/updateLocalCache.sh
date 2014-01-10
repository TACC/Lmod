#!/bin/bash
# -*- shell-script -*-

########################################################################
#  Create a system cache file
#
#   This creates the system cache file for module spider.
########################################################################

########################################################################
#  Site Specific Setting
########################################################################

LMOD_DIR=/opt/apps/lmod/lmod/libexec
BASE_MODULE_PATH=/opt/apps/modulefiles:/opt/modulefiles

ADMIN_ls4="/home1/moduleData"
ADMIN_stampede="/tmp/moduleData"

nlocal=$(hostname -f)
nlocal=${nlocal%.tacc.utexas.edu}
first=${nlocal%%.*}
SYSHOST=${nlocal#*.}

eval "ADMIN_DIR=\$ADMIN_$SYSHOST"

CacheDir=$ADMIN_DIR/cacheDir
RmapDir=$ADMIN_DIR/reverseMapD
timeStamp="/tmp/losf_last_update"
cacheFile="$CacheDir/moduleT.lua"

########################################################################
#  End Site Specific Setting
########################################################################

########################################################################
# Read time stamp file for nodeType

readTS()
{
  local fn=$1
  nodeType=$(cat $fn | grep -e "nodeType" | sed -e 's/.*= *//')
  echo $nodeType
}

########################################################################
# Stat file to get modify time

getModifyTime()
{
  local fn=$1
  local result=0
  if [ -f $fn ]; then
    result=$(stat --format=%Y $fn)
  fi
  echo $result
}

########################################################################
#  Build the new database

buildNewDB()
{
   local DIR=$1
   local file=$2
   local option=$file

   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

   if [ ! -d $DIR ]; then
     mkdir -p $DIR
   fi


   rm -f $OLD $NEW
   $LMOD_DIR/spider -o $option $BASE_MODULE_PATH > $NEW
   if [ "$?" = 0 ]; then
      chmod 644 $NEW
      if [ -f $RESULT ]; then
        cp $RESULT $OLD
      fi
      mv $NEW $RESULT
   fi
}

# Get timeStamp epoch and cacheFile epoch

a=$(getModifyTime $timeStamp)
b=$(getModifyTime $cacheFile)

# if the cache file is out-of-date then rebuild the cache files for the local
# directories
if [ $a -ge $b ]; then
  buildNewDB $CacheDir  moduleT
  buildNewDB $RmapDir   reverseMapT
fi

