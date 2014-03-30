#!/usr/bin/env tclsh
proc main {argv} {
    source $argv
    if {[info exists ModulesVersion]} {
      puts $ModulesVersion
    } elseif {[info exists ModuleVersion]} {
      puts $ModuleVersion
    }
}

eval main $argv
