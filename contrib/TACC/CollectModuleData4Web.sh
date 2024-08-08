#!/bin/bash
# -*- shell-script -*-

######################################################################
# find ADMIN_DIR

SCRIPT_NAME="${BASH_SOURCE[0]:-${(%):-%x}}"
SCRIPT_DIR=${SCRIPT_NAME%/*}


if [ $SCRIPT_DIR = "." ]; then
  SCRIPT_DIR=$PWD
fi  

########################################################################
# find spider cmd

LMOD_DIR=/opt/apps/lmod/lmod/libexec
if [ ! -x $LMOD_DIR/spider ]; then
    echo "$LMOD_DIR/spider command not found!" '-> Quiting!'
    exit 1
fi
   

########################################################################
# Make sure that $ADMIN_DIR/softwarePage exists

ADMIN_DIR=$SCRIPT_DIR
mkdir -p $ADMIN_DIR/softwarePage

########################################################################
# find BASE_MODULE_PATH

BASE_MODULE_PATH=""

for i in /opt/modulefiles /opt/apps/modulefiles /opt/apps/xsede/modulefiles; do
  if [ -d $i ]; then
    BASE_MODULE_PATH=$i:$BASE_MODULE_PATH
  fi
done
BASE_MODULE_PATH=${BASE_MODULE_PATH%:}

########################################################################
# find name for python3

PYTHON=
for cmd in python3 python python2; do
  command -v $cmd > /dev/null
  if [ "$?" = 0 ]; then
    PYTHON=$cmd
    break
  fi
done

# Build json software page and make it pretty if possible.

$LMOD_DIR/spider -o softwarePage    $BASE_MODULE_PATH > $ADMIN_DIR/softwarePage/softwarePage.old.json

$PYTHON -mjson.tool $ADMIN_DIR/softwarePage/softwarePage.old.json > $ADMIN_DIR/softwarePage/softwarePage.json 2> /dev/null
if [ -s $ADMIN_DIR/softwarePage/softwarePage.json ]; then
  rm -f $ADMIN_DIR/softwarePage/softwarePage.old.json
else
  mv $ADMIN_DIR/softwarePage/softwarePage.old.json $ADMIN_DIR/softwarePage/softwarePage.json
fi

chmod 644 $ADMIN_DIR/softwarePage/softwarePage.*
