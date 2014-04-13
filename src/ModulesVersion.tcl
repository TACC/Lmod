#!/usr/bin/env tclsh
proc main {argv} {
    source $argv
    set version       -1
    set date         "***"
    set newVersion    -1
    if {[info exists ModulesVersion]} {
      set version $ModulesVersion
    } elseif {[info exists ModuleVersion]} {
      set version $ModuleVersion
    }
    if {[info exists NewModulesVersionDate]} {
      set date $NewModulesVersionDate
    }
    if {[info exists NewModulesVersion]} {
      set newVersion $NewModulesVersion
    }
    puts stdout "modV=\{ version=\"$version\", date=\"$date\", newVersion=\"$newVersion\"\}"
}

eval main $argv
