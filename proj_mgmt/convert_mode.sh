#!/bin/bash
# -*- shell-script -*-

KIND=$1
MODE=$2

if [ $MODE = "user_default" ]; then
   uid=$(id -u)
   umask=$(umask)
   system=$(uname -s)
   if [ $system = Darwin ]; then
     UID_MIN=500
   else
     UID_MIN=1000
   fi
     
   if [ -f /etc/login.defs ]; then
     xx=$(grep '^UID_MIN' /etc/login.defs | sed -e 's/^UID_MIN[ \t]*//')
     if [ -n "${xx}" ]; then
       UID_MIN=$xx
     fi
   fi
   if [ $uid -lt $UID_MIN ]; then
     umask=022
   fi
   MODE_X=$(( ( ~ $umask ) & 0777 ))
   MODE_X=$(echo "ibase=10; obase=8; $MODE_X" | bc )
   MODE_X=0$MODE_X
else
   MODE_X=0$MODE
fi   
MODE_R=$(( 0666 & $MODE_X ))
MODE_R=$(echo "ibase=10; obase=8; $MODE_R" | bc )
MODE_R=0$MODE_R

if [ $KIND = "-x" ]; then
  echo $MODE_X
fi
if [ $KIND = "-r" ]; then
  echo $MODE_R
fi
