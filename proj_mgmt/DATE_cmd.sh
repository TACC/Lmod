#!/bin/sh
# -*- shell-script -*-

arg="$1"
osType=$(uname -s)
my_cmd=date

if [ $osType = "Darwin" ]; then
  if type -p gdate > /dev/null 2>&1; then
    my_cmd=gdate
  else
    my_cmd=date
    arg="${arg%% %:z}"
  fi
fi

if [ -n "${SOURCE_DATE_EPOCH+x}" ]; then
  arg="${arg%% %:z} %Z"
  $my_cmd   -u -d "@$SOURCE_DATE_EPOCH" "$arg" 2>/dev/null ||
    $my_cmd -u -r "$SOURCE_DATE_EPOCH" "$arg"  2>/dev/null ||
    $my_cmd "$arg"
else
  $my_cmd "$arg"
fi
