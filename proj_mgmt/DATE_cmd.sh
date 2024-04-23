#!/bin/bash
# -*- shell-script -*-

arg="$1"
osType=$(uname -s)
my_cmd=date

if [ $osType = "Darwin" ]; then
  if type -p gdate > /dev/null 2>&1; then
    my_cmd=gdate
  else
    arg="${arg%% %:z}"
  fi
fi

SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-$($my_cmd +%s)}"
$my_cmd -d "@$SOURCE_DATE_EPOCH" "$arg" 2>/dev/null ||
  $my_cmd -r "$SOURCE_DATE_EPOCH" "$arg" 2>/dev/null ||
  $my_cmd "$arg"

