#!/usr/bin/env tclsh
global g_currentModuleName
proc doubleQuoteEscaped {text} {
    regsub -all "\"" $text "\\\"" text
    return $text
}

proc module-alias {name mfile} {
    puts stdout "\{kind=\"module-alias\",name=\"$name\",mfile=\"$mfile\"\},"
}

proc hidden-module {mfile} {
    puts stdout "\{kind=\"hidden-module\", mfile=\"$mfile\"\},"
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
    source $mRcFile
    puts stdout "\}"
}

eval main $argv
