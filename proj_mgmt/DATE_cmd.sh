#!/bin/bash
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

#$my_cmd "$arg"


SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-$($my_cmd +%s)}"
$my_cmd -u -d "@$SOURCE_DATE_EPOCH" "$arg" 2>/dev/null ||
  $my_cmd -u -r "$SOURCE_DATE_EPOCH" "$arg" 2>/dev/null ||
  $my_cmd "$arg"
