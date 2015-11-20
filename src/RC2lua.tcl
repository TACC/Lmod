#!/usr/bin/env tclsh
global g_currentModuleName
proc doubleQuoteEscaped {text} {
    regsub -all "\"" $text "\\\"" text
    return $text
}

proc module-alias {name mfile} {
    puts stdout "\{kind=\"module-alias\",name=\"$name\",mfile=\"$mfile\"\},"
}

proc hide-version {mfile} {
    puts stdout "\{kind=\"hide-version\", mfile=\"$mfile\"\},"
}


proc module-version {args} {
    set module_name    [lindex $args 0]
    foreach version [lrange $args 1 end] {
        set val [doubleQuoteEscaped $version]
        lappend argL "\"$val\""
    }
    set versionA [join $argL ","]
    puts stdout "\{kind=\"module-version\",module_name=\"$module_name\", module_versionA=\{$versionA\}\},"
}

proc main {mRcFile} {
    puts stdout "modA=\{"
    set version  -1
    set found 0

    source $mRcFile

    if {[info exists ModulesVersion]} {
      set version $ModulesVersion
      set found 1
    } elseif {[info exists ModuleVersion]} {
      set version $ModuleVersion
      set found 1
    }
    #if {[info exists NewModulesVersionDate]} {
    #  set date $NewModulesVersionDate
    #}
    #if {[info exists NewModulesVersion]} {
    #  set newVersion $NewModulesVersion
    #}

    if { $found > 0 } {
        puts stdout "\{kind=\"set-default-version\", version=\"$version\"\}"
    }
    puts stdout "\}"
}

eval main $argv
