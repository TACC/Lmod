#!/usr/bin/env tclsh
global g_currentModuleName
proc module-alias {args} {
}
proc module-version {args} {
    set module_name    [lindex $args 0]
    set module_version [lindex $args 1]
    puts stdout "\{module_name=\"$module_name\", module_version=\"$module_version\"\},"
}

proc main {mRcFile} {
    puts stdout "modV=\{"
    source $mRcFile
    puts stdout "\}"
}



eval main $argv
