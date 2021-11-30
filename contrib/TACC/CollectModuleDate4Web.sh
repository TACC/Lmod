#!/bin/bash
# -*- shell-script -*-

MCLAY=~mclay
for i in $MCLAY/l/pkg/x86_64/lmod/lmod/libexec/ $MCLAY/l/pkg/lmod/lmod/libexec/; do
    if [ -x $i/spider ]; then
        LMOD_DIR=$i
        break;
    fi
done 
for i in $MCLAY/l/pkg/x86_64/luatools/luatools $MCLAY/l/pkg/luatools/luatools ; do
    if [ -f $i/share/5.1/strict.lua ]; then
        LUATOOLS=$i
        break;
    fi
done 





export LUA_PATH="$LUATOOLS"'/share/5.1/?.lua;;'
export LUA_CPATH="$LUATOOLS"'/lib/5.1/?.so;;'

BASE_MODULE_PATH=/opt/apps/modulefiles:/opt/modulefiles

ADMIN_stampede2="/home1/moduleData"
ADMIN_frontera="/home1/moduleData"

nlocal=$(hostname -f)
nlocal=${nlocal%.tacc.utexas.edu}
first=${nlocal%%.*}
SYSHOST=${nlocal#*.}

eval "ADMIN_DIR=\$ADMIN_$SYSHOST"

if [ "$SYSHOST" = "stampede2" ]; then
   BASE_MODULE_PATH=/opt/apps/xsede/modulesfiles:$BASE_MODULE_PATH
fi


$LMOD_DIR/spider -o softwarePage    $BASE_MODULE_PATH > $ADMIN_DIR/softwarePage/softwarePage.old.json
$LMOD_DIR/spider -o xmlSoftwarePage $BASE_MODULE_PATH > $ADMIN_DIR/softwarePage/softwarePage.xml

python -mjson.tool $ADMIN_DIR/softwarePage/softwarePage.old.json > $ADMIN_DIR/softwarePage/softwarePage.json
rm $ADMIN_DIR/softwarePage/softwarePage.old.json

chmod 644 $ADMIN_DIR/softwarePage/softwarePage.*
