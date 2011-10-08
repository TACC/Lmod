#!/usr/bin/env tclsh
proc main {argv} {
    source $argv
    puts $ModulesVersion
}

eval main $argv
