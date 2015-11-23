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
   local tsfn=$2
   local file=$3
   local option=$file

   if [ ! -d $DIR ]; then
     mkdir -p $DIR
   fi

   local OLD=$DIR/$file.old.lua
   local NEW=$DIR/$file.new.lua
   local RESULT=$DIR/$file.lua

   local OLD_C=$DIR/$file.old.luac_$LuaV
   local NEW_C=$DIR/$file.new.luac_$LuaV
   local RESULT_C=$DIR/$file.luac_$LuaV

   rm -f $OLD $NEW
   $LMOD_DIR/spider --timestampFn $tsfn -o $option $BASE_MODULE_PATH > $NEW
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
#  Touch system file so that Lmod knows that the cache is good
########################################################################

cat > $LastUpdateFn <<EOF
hostType
EOF

buildNewDB $CacheDir $ADMIN_DIR/system.txt moduleT
buildNewDB $CacheDir $ADMIN_DIR/system.txt dbT

########################################################################
#  Build reverse map (This is optional)
#  This allows one to map between paths and modules.
#
#  For example: ldd on an executable produces paths to libraries. The
#  reverse map allows one to map back to modules the executable might be
#  using.   See tools like XALT:  xalt.sf.net
########################################################################
#buildNewDB $RmapDir  $ADMIN_DIR/system.txt reverseMapT




