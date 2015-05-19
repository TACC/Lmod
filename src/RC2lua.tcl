#!/usr/bin/env tclsh
global g_currentModuleName
proc doubleQuoteEscaped {text} {
    regsub -all "\"" $text "\\\"" text
    return $text
}

proc module-alias {args} {
}


proc module-version {args} {
    set module_name    [lindex $args 0]
    foreach version [lrange $args 1 end] {
        set val [doubleQuoteEscaped $version]
        lappend argL "\"$val\""
    }
    set versionA [join $argL ","]
    puts stdout "\{module_name=\"$module_name\", module_versionA=\{$versionA\}\},"
}

proc main {mRcFile} {
    puts stdout "modV=\{"
    source $mRcFile
    puts stdout "\}"
}

eval main $argv
