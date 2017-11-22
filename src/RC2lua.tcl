#!/usr/bin/env tclsh

#--------------------------------------------------------------------------
#-- Lmod License
#--------------------------------------------------------------------------
#--
#--  Lmod is licensed under the terms of the MIT license reproduced below.
#--  This means that Lmod is free software and can be used for both academic
#--  and commercial purposes at absolutely no cost.
#--
#--  ----------------------------------------------------------------------
#--
#--  Copyright (C) 2008-2017 Robert McLay
#--
#--  Permission is hereby granted, free of charge, to any person obtaining
#--  a copy of this software and associated documentation files (the
#--  "Software"), to deal in the Software without restriction, including
#--  without limitation the rights to use, copy, modify, merge, publish,
#--  distribute, sublicense, and/or sell copies of the Software, and to
#--  permit persons to whom the Software is furnished to do so, subject
#--  to the following conditions:
#--
#--  The above copyright notice and this permission notice shall be
#--  included in all copies or substantial portions of the Software.
#--
#--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
#--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
#--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#--  THE SOFTWARE.
#--
#--------------------------------------------------------------------------

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

proc hide-modulefile {mfile} {
    puts stdout "\{kind=\"hide-modulefile\", mfile=\"$mfile\"\},"
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
    global env
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
