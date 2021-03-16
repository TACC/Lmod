#!/bin/bash
# -*- shell-script -*-

unset LMOD_ROOT
unset LMOD_PKG
unset LMOD_SETTARG_FULL_SUPPORT
unset LMOD_FULL_SETTARG_SUPPORT
unset NVM_DIR
unset XDG_CONFIG_HOME

OLD_IFS=$IFS
IFS=:
NEW_PATH=
for dir in $PATH; do
  if   [[ $dir =~ /.dotnet/ ]]; then
    :
  elif [[ $dir =~ /.config/ ]]; then
    :
  elif [[ $dir =~ /.local/ ]]; then
    :
  else
    NEW_PATH=$NEW_PATH:$dir
  fi
done
IFS=$OLD_IFS

NEW_PATH=${NEW_PATH#:}




PATH=$testDir/bin:$NEW_PATH:$testDir/sbin
