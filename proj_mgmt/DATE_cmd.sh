#!/bin/bash
# -*- shell-script -*-

arg="$1"
osType=$(uname -s)
my_cmd=date

if [ $osType = "Darwin" ]; then
  if type -p gdate; then
    my_cmd=gdate
  else
    my_cmd=date
    arg="${arg%% %:z}"
  fi
fi

$my_cmd "$arg"

