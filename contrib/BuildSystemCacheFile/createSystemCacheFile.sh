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


# Chose the path that forms the "Core" module list:

# BASE_MODULE_PATH=/opt/apps/modulefiles:/opt/modulefiles
# BASE_MODULE_PATH=/opt/apps/modulefilesCore

if [ -z "$BASE_MODULE_PATH" ]; then
  echo "No BASE_MODULE_PATH defined: exiting"
fi

ADMIN_ranger="/share/moduleData"
ADMIN_ls4="/home1/moduleData"
ADMIN_stampede="/home1/moduleData"

nlocal=$(hostname -f)
nlocal=${nlocal%.tacc.utexas.edu}
first=${nlocal%%.*}
SYSHOST=${nlocal#*.}

# eval "ADMIN_DIR=\$ADMIN_$SYSHOST"

if [ -z "$ADMIN_DIR" ]; then
  echo "No ADMIN_DIR defined: exiting"
fi


CacheDir=$ADMIN_DIR/cacheDir
RmapDir=$ADMIN_DIR/reverseMapD

LastUpdateFn=$ADMIN_DIR/system.txt

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
        cp -p $RESULT $OLD
      fi
      mv $NEW $RESULT
   fi
}

########################################################################
#  Touch system file so that Lmod knows that the cache is good
########################################################################

cat > $LastUpdateFn <<EOF
hostType
EOF

buildNewDB $CacheDir  moduleT


########################################################################
#  Build reverse map (This is optional)
########################################################################
#buildNewDB $RmapDir   reverseMapT



