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
BASE_MODULE_PATH=/opt/apps/xsede/modulefiles:/opt/apps/modulefiles:/opt/modulefiles

ADMIN_ls4="/home1/moduleData"
ADMIN_stampede="/home1/moduleData"

nlocal=$(hostname -f)
nlocal=${nlocal%.tacc.utexas.edu}
first=${nlocal%%.*}
SYSHOST=${nlocal#*.}

eval "ADMIN_DIR=\$ADMIN_$SYSHOST"

CacheDir=$ADMIN_DIR/cacheDir
RmapDir=$ADMIN_DIR/reverseMapD


########################################################################
#  End Site Specific Setting
########################################################################


buildNewDB()
{
   local DIR=$1
   local file=$2
   local option=$file

   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

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

ans=$(./may_i_build_cache -f $updateSystemFn -i ./clusterDescriptT.lua -c $CacheDir )

if [ "$ans" = yes ]; then
  buildNewDB $CacheDir  moduleT
fi



########################################################################
#  Build reverse map (This is optional)
########################################################################
#buildNewDB $RmapDir   reverseMapT



