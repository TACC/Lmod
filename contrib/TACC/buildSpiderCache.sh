#!/bin/bash
# -*- shell-script -*-

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
   local BASEMP=$2
   local file=$3
   local option=$file

   if [ ! -d $DIR ]; then
     mkdir -p  $DIR
   fi

   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

   rm -f $NEW
   $LMOD_DIR/spider -o $option $BASEMP > $NEW
   if [ "$?" = 0 -a -f "$NEW" ]; then
      chmod 644 $NEW
      if [ -f $RESULT ]; then
        cp -p $RESULT $OLD
      fi
      mv $NEW $RESULT
   fi
}

########################################################################
#  Make directores and file be world readable
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
    buildNewDB $CacheDir  /opt/apps/modulefiles:/opt/modulefiles  moduleT
    buildNewDB $RmapDir   /opt/apps/modulefiles:/opt/modulefiles  reverseMapT
  fi
fi

# if we are on master then build the shared file system cache files.
# These cache files are always rebuilt everytime this script is called.

if [ "$nodeType" == "master" ]; then
  XSEDE_dir="/home1/moduleData/XSEDE"
  if [ ! -d $XSEDE_dir ]; then
    mkdir -p $XSEDE_dir
  fi
  writeTS $nodeType /home1/moduleData/XSEDE/last_update
  for i in /opt/apps/xsede/modulefiles /share1/apps/teragrid/modulefiles; do
    if [ -d $i ]; then
      buildNewDB /home1/moduleData/XSEDE/cacheDir     $i  moduleT
      buildNewDB /home1/moduleData/XSEDE/reverseMapD  $i  reverseMapT
    fi
  done
fi
