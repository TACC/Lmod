#!/bin/bash
# -*- shell-script -*-

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

if [ "${NO_SHELL_FUNCTIONS:-}" != yes ]; then
   fooFunc ()
   {
     echo "arg1: $1"
   }  

   junk ()
   {
     if [ -n "${ZSH_VERSION:-}" ]; then
       \echo "junk"
     fi
   }

   banner ()
   {
     local str="$1"
     local RED=$'\033[1;31m'
     local NONE=$'\033[0m'
     echo "${RED}${str}${NONE}"
   }  

   save_args() {
     for arg do
       printf "%s\n" "$arg" | sed -e "s/'/'\\\\''/g" -e "1s/^/'/" -e "\$s/\$/' \\\\/" ;
     done
     echo " "
   }  

   my_help ()
   {
     echo "do not forget \"foo\""
   }
fi

alias fooAlias='foobin -q -l'

PATH=$testDir/bin:$NEW_PATH:$testDir/sbin

export TST_SCRIPT=1
export MY_NAME="tstScript.sh"

complete -F _xyz123 XyZ123
