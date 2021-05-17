#!/bin/bash
# -*- shell-script -*-

# $Id: fstab 1396 2012-08-08 11:32:33Z karl $
#------------------------------------------------------------------------------
# Note: this file is managed via LosF
#
# You should, in general, not edit this file directly as you will
# *lose* the contents during the next sync process. Instead,
# edit the template file in your local config directory:
#
# /admin/build/admin/config/const_files/Stampede/login/buildSpiderCache.sh
#
# Questions? karl@tacc.utexas.edu
#
#------------------------------------------------------------------------------


force=
if [ "$1" = "--force" ]; then
  force="force"
fi

########################################################################
# Generate time stamp file:

writeTS()
{
  local nodeType=$1
  local fn=$2
  local hostName=$(hostname -f)
  local dateStr=$(date)
  local epoch=$(date +%s)

  echo "nodeType   = $nodeType" >  $fn
  echo "hostName   = $hostName" >> $fn
  echo "lastUpdate = $dateStr"  >> $fn
  echo "timeEpoch  = $epoch"    >> $fn
}


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
   local tsfn=$2
   local MPATH=$3
   local file=$4
   local option=$file

   if [ ! -d $DIR ]; then
     mkdir -p $DIR
   fi

   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

   local LuaV=$(lua -e 'print((_VERSION:gsub("Lua ","")))')
   local OLD_C=$DIR/$file.old.luac_$LuaV
   local NEW_C=$DIR/$file.new.luac_$LuaV
   local RESULT_C=$DIR/$file.luac_$LuaV

   rm -f $OLD $NEW
   $LMOD_DIR/spider --timestampFn $tsfn -o $option $MPATH > $NEW
   if [ "$?" = 0 ]; then
      chmod 644 $NEW
      if [ -f $RESULT ]; then
        cp -p $RESULT $OLD
      fi
      mv $NEW $RESULT

      luac -o $NEW_C $RESULT

      chmod 644 $NEW_C
      if [ -f $RESULT_C ]; then
        cp -p $RESULT_C $OLD_C
      fi
      mv $NEW_C $RESULT_C

   fi
}

########################################################################
#  Make directories and file be world readable
umask 022


########################################################################
#  Find an lmod that has a version 5 or better
for i in /opt/apps/lmod/lmod/libexec             \
         /opt/apps/lmod/5.0rc1/libexec           ; do
  if [ -x $i/lmod ]; then
    LmodVersion=$($i/lmod bash --version 2>&1 | grep "^Modules" | sed -e 's/.*Version \([0-9]\+\).*/\1/')
    if [ "$LmodVersion" -ge 5 ]; then
      export LMOD_DIR=$i
      break;
    fi
  fi
done

RmapDir="/tmp/moduleData/reverseMapD"
CacheDir="/tmp/moduleData/cacheDir"
cacheFile="$CacheDir/moduleT.lua"
timeStamp="/tmp/losf_last_update"

# Get timeStamp epoch and cacheFile epoch

a=$(getModifyTime $timeStamp)
b=$(getModifyTime $cacheFile)
nodeType=$(readTS $timeStamp)

# if the cache file is out-of-date then rebuild the cache files for the local
# directories
if [ -n "$force" -o $a -ge $b ]; then
  if [ "$nodeType" != "build" ]; then
    MPATH=/opt/apps/xsede/modulefiles:/opt/apps/modulefiles:/opt/modulefiles
    buildNewDB $CacheDir  $timeStamp $MPATH  moduleT
    buildNewDB $CacheDir  $timeStamp $MPATH  dbT
    buildNewDB $RmapDir   $timeStamp $MPATH  reverseMapT
  fi
fi

# if we are on master then build the shared file system cache files.
# These cache files are always rebuilt everytime this script is called.

if [ "$nodeType" == "master" ]; then
  XSEDE_dir="/home1/moduleData/XSEDE"
  if [ ! -d $XSEDE_dir ]; then
    mkdir -p $XSEDE_dir
  fi
  timeStamp=$XSEDE_dir/last_update
  writeTS $nodeType $timeStamp

  SHARED_DIRS="/home1/apps/intel13/modulefiles"

  if [ -d "$SHARED_DIRS" ]; then
    buildNewDB $XSEDE_dir/cacheDir     $timeStamp $SHARED_DIRS  moduleT
    buildNewDB $XSEDE_dir/cacheDir     $timeStamp $SHARED_DIRS  dbT
    buildNewDB $XSEDE_dir/reverseMapD  $timeStamp $SHARED_DIRS  reverseMapT
  fi

fi
