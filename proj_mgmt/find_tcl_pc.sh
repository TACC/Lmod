#!/bin/bash
# -*- shell-script -*-
if ! command -v realpath > /dev/null; then
   realpath() {
     CWD=$PWD
     cd -- "$(dirname "$1")"
     LINK=$(readlink "$(basename "$1")")
     while [ "$LINK" ]; do
       cd "$(dirname "$LINK")"
       LINK=$(readlink "$(basename "$1")")
     done
     REALPATH="$PWD/$(basename "$1")"
     cd "$CWD"
     echo "$REALPATH"
   }
fi

OS=$(uname -s)

if [ $OS = Darwin ]; then
  if ! command -v brew > /dev/null ; then
    echo ""
    return
  fi
  CELLAR_DIR=$(brew --cellar)
  TCL_PC_LOC=$(find $CELLAR_DIR -name tcl.pc 2> /dev/null)
else
  TCL_PATH=$(realpath $1)
  TCL_DIR=$(dirname $TCL_PATH)
  TCL_PARENT=$(dirname $TCL_DIR)
  TCL_PC_LOC=$(cd -- ${TCL_PARENT}; find . -name tcl.pc 2> /dev/null)
  TCL_PC_LOC=${TCL_PARENT}/$TCL_PC_LOC
fi

TCL_PKG_CONFIG_DIR=$(dirname $TCL_PC_LOC); 
echo $TCL_PKG_CONFIG_DIR


  
