#!/bin/bash
# -*- shell-script -*-


########################################################################
# Generate time stamp file:

writeTS()
{
  local nodeType=$1
  local fn=$2
  local hostName=$(hostname -f)
  local dateStr=$(date)
  local epoch=$(date +%s)

  echo "nodeType   = $nodeType" >  fn
  echo "hostName   = $hostName" >> fn
  echo "lastUpdate = $dateStr"  >> fn
  echo "timeEpoch  = $epoch"    >> fn
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

buildNewDB()
{
   local DIR=$1
   local BASEMP=$2
   local file=$3
   local option=$file

   if [ ! -d $DIR ]; then
     mkdir -p  $DIR
     chmod 755 $DIR
   fi

   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

   rm -f $OLD $NEW
   $LMOD_DIR/spider -o $option $BASEMP > $NEW
   if [ "$?" = 0 ]; then
      chmod 644 $NEW
      if [ -f $RESULT ]; then
        cp -p $RESULT $OLD
      fi
      mv $NEW $RESULT
   fi
}

LMOD_DIR="/opt/apps/lmod/lmod/libexec"
RmapDir="/tmp/moduleData/reverseMapD"
CacheDir="/tmp/moduleData/cacheDir"
cacheFile="$CacheDir/moduleT.lua"
timeStamp="/tmp/losf_last_update"


# Get timeStamp epoch

a=$(getModifyTime $timeStamp)
b=$(getModifyTime $cacheFile)
nodeType=$(readTS $timeStamp)


# if timestamp file is older than the cache file we are done.
if [ $a -ge $b ]; then
  if [ "$nodeType" != "build" ]; then
    buildNewDB $CacheDir  /opt/apps/modulefiles:/opt/modulefiles  moduleT 
    buildNewDB $RmapDir   /opt/apps/modulefiles:/opt/modulefiles  reverseMapT
  fi
fi

if [ "$nodeType" == "master" ]; then
  writeTS $nodeType /home1/moduleData/last_update
  for i in /opt/apps/xsede/modulefiles /share1/apps/teragrid/modulefiles do
    buildNewDB /home1/moduleData/cacheDir     $i  moduleT 
    buildNewDB /home1/moduleData/reverseMapD  $i  reverseMapT
  done
fi

  
  

