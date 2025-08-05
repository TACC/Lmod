#!/bin/bash
# -*- shell-script -*-

export gitV=8.7.63-23-gd1f9e84b
export PATH_to_SHA1=/usr/bin
export SHA1SUM=sha1sum
export PATH_TO_SED=/usr/bin
export PATH_to_LUA=/opt/apps/lua/lua/bin
export PATH_to_TM=/home/mclay/w/hermes/bin
export outputDir=/home/mclay/w/lmod/IS704/proj_mgmt/clean_gold_files
export projectDir=/home/mclay/w/lmod/IS704

export old="Lmod Warning: Syntax error in file: ProjectDIR"
export new="Lmod Warning: Syntax error in file:\nProjectDIR"
./cleanup.lua --nushell err.in err.out
more err.out
