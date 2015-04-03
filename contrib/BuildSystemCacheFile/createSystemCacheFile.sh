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

LMOD_DIR=${LMOD_DIR:-/opt/apps/lmod/lmod/libexec}

# Chose the path that forms the "Core" module list:

# BASE_MODULE_PATH=/opt/apps/modulefiles:/opt/modulefiles
# BASE_MODULE_PATH=/opt/apps/modulefilesCore

if [ -z "$BASE_MODULE_PATH" ]; then
  echo "No BASE_MODULE_PATH defined: exiting"
  exit 1
fi

# eval "ADMIN_DIR=\$ADMIN_$SYSHOST"

if [ -z "$ADMIN_DIR" ]; then
  echo "No ADMIN_DIR defined: exiting"
  exit 2
fi

LuaC=${LuaC:-luac}

CacheDir=${CacheDir:-$ADMIN_DIR/cacheDir}
RmapDir=${RmapDir:-$ADMIN_DIR/reverseMapD}

LastUpdateFn=${LastUpdateFn:-$ADMIN_DIR/system.txt}

DbT=${DbT:-$ADMIN_DIR/system.txt}
ModuleT=${ModuleT:-$ADMIN_DIR/system.txt}

# Set to 1 if you want the reversemap build
ReverseMap=${ReverseMap:-0}
ReverseMapT=${ReverseMapT:-$ADMIN_DIR/system.txt}


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
   if [ $? -eq 0 ]; then
      chmod 644 $NEW
      if [ -f $RESULT ]; then
        cp -p $RESULT $OLD
      fi
      mv $NEW $RESULT

      $LuaC -o $NEW_C $RESULT
      if [ $? -eq 0 ]; then
          chmod 644 $NEW_C
          if [ -f $RESULT_C ]; then
              cp -p $RESULT_C $OLD_C
          fi
          mv $NEW_C $RESULT_C
      else
          echo "Failed to generate compiled lua cache $RESULT from $NEW"
      fi
   fi
}

########################################################################
#  Touch system file so that Lmod knows that the cache is good
########################################################################

cat > $LastUpdateFn <<EOF
hostType
EOF

buildNewDB $CacheDir $ModuleT moduleT 
buildNewDB $CacheDir $DbT dbT

########################################################################
#  Build reverse map (This is optional)
#  This allows one to map between paths and modules.  
#
#  For example: ldd on an executable produces paths to libraries. The
#  reverse map allows one to map back to modules the executable might be
#  using.   See tools like XALT:  xalt.sf.net
########################################################################
if [ "$ReverseMap" -eq 1 ]; then
    buildNewDB $RmapDir $ReverseMapT reverseMapT
fi
