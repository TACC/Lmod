#!/bin/ksh
# -*- shell-script -*-

fooFunc ()
{
  echo "arg1: $1"
}

alias fooAlias='echo foobin -q -l'

export PATH=$testDir/bin:$testDir/sbin:$PATH

