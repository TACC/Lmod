#!/bin/bash
# -*- shell-script -*-

######################################################################
# find ADMIN_DIR

cmd=$0
dir=$(dirname $cmd); 
if [ $dir = "." ]; then
  dir=$PWD
fi
ADMIN_DIR=$dir

######################################################################
# find arch.py command if it exists
export PATH=$ADMIN_DIR/bin:$PATH
if command -v arch.py > /dev/null ; then
  ARCH=$(arch.py)
else
  ARCH=$(arch)
fi

######################################################################
# Use ~swtools dir if it exists otherwise use ~mclay

######################################################################
# Find LMOD_DIR in either ~swtools or ~mclay
  

MCLAY=~mclay
SWTOOLS=~swtools
DIRLIST=( $SWTOOLS/l/pkg/$ARCH/lmod/lmod/libexec/ 
          $SWTOOLS/l/pkg/lmod/lmod/libexec/
          $MCLAY/l/pkg/$ARCH/lmod/lmod/libexec/ 
          $MCLAY/l/pkg/lmod/lmod/libexec/
        )
          
for i in "${DIRLIST[@]}"; do
    if [ -x $i/spider ]; then
        LMOD_DIR=$i
        break;
    fi
done 

######################################################################
# Find LUATOOLS in either ~swtools or ~mclay
  
DIRLIST=( $SWTOOLS/l/pkg/$ARCH/luatools/luatools
          $SWTOOLS/l/pkg/luatools/luatools
          $MCLAY/l/pkg/$ARCH/luatools/luatools
          $MCLAY/l/pkg/luatools/luatools
          )

lua_version=$(lua -e 'print((_VERSION:gsub("Lua ","")))')

for i in "${DIRLIST[@]}"; do
    if [ -f $i/share/$lua_version/strict.lua ]; then
        LUATOOLS=$i
        break;
    fi
done 

export LUA_PATH="$LUATOOLS/share/$lua_version"'/?.lua;;'
export LUA_CPATH="$LUATOOLS/lib/$lua_version"'/?.so;;'

BASE_MODULE_PATH=""

for i in /opt/modulefiles /opt/apps/modulefiles /opt/apps/xsede/modulefiles; do
  if [ -d $i ]; then
    BASE_MODULE_PATH=$i:$BASE_MODULE_PATH
  fi
done
BASE_MODULE_PATH=${BASE_MODULE_PATH%:}

$LMOD_DIR/spider -o softwarePage    $BASE_MODULE_PATH > $ADMIN_DIR/softwarePage/softwarePage.old.json

if [ "$lua_version" = 5.1 ]; then
  $LMOD_DIR/spider -o xmlSoftwarePage $BASE_MODULE_PATH > $ADMIN_DIR/softwarePage/softwarePage.xml
fi

python -mjson.tool $ADMIN_DIR/softwarePage/softwarePage.old.json > $ADMIN_DIR/softwarePage/softwarePage.json
rm -f $ADMIN_DIR/softwarePage/softwarePage.old.json

chmod 644 $ADMIN_DIR/softwarePage/softwarePage.*
