#!/bin/bash
HOST=$(hostname -f)
TACC_ADMIN_DIR_ranger=/share/tacc_admin/moduleUsage
TACC_ADMIN_DIR_ls4=/home1/tacc_admin/moduleUsage
TACC_ADMIN_DIR_longhorn=/share/tacc_admin/moduleUsage
NAME=$(expr "$HOST" : '[^.][^.]*\.\(.*\)\.tacc.utexas.edu')

eval "TACC_ADMIN_DIR=\$TACC_ADMIN_DIR_$NAME"

DATE=$(date +"%F")
Fn="$TACC_ADMIN_DIR/moduleUsage-$DATE.csv"

PATH=/opt/apps/lmod/lmod/libexec:$PATH

processMT -d -f $Fn
