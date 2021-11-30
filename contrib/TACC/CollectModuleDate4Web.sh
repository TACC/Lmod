#!/bin/bash
# -*- shell-script -*-

MCLAY=~mclay
for i in $MCLAY/l/pkg/x86_64/lmod/lmod/libexec/ $MCLAY/l/pkg/lmod/lmod/libexec/; do
    if [ -x $i/spider ]; then
        LMOD_DIR=$i
        break;
    fi
done 

lua_version=$(lua -e 'print((_VERSION:gsub("Lua ","")))')

for i in $MCLAY/l/pkg/x86_64/luatools/luatools $MCLAY/l/pkg/luatools/luatools ; do
    if [ -f $i/share/$lua_version/strict.lua ]; then
        LUATOOLS=$i
        break;
    fi
done 

export LUA_PATH="$LUATOOLS/share/$lua_version"'/?.lua;;'
export LUA_CPATH="$LUATOOLS/lib/$lua_version"'/?.so;;'

ADMIN_stampede2="/home1/moduleData"
ADMIN_frontera="/home1/moduleData"
ADMIN_ls6="/home1/moduleData"

nlocal=$(hostname -f)
nlocal=${nlocal%.tacc.utexas.edu}
first=${nlocal%%.*}
SYSHOST=${nlocal#*.}

eval "ADMIN_DIR=\$ADMIN_$SYSHOST"

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
rm $ADMIN_DIR/softwarePage/softwarePage.old.json

chmod 644 $ADMIN_DIR/softwarePage/softwarePage.*
