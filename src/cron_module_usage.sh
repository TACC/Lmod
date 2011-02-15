#!/bin/bash
DATE=$(date +"%F")
Fn="moduleUsage-$DATE.csv"

PATH=/opt/apps/lmod/lmod/libexec:$PATH

echo processMT -d -f $Fn
processMT -d -f $Fn



