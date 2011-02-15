#!/usr/bin/env tclsh
# $Id$
proc main {argv} {
    source $argv
    puts $ModulesVersion
}

eval main $argv
