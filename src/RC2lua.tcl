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
#--  Copyright (C) 2008-2018 Robert McLay
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

proc doubleQuoteEscaped {text} {
    regsub -all "\"" $text "\\\"" text
    return $text
}

proc module-alias {name mfile} {
    global g_outputA
    #puts stdout "\{kind=\"module_alias\",name=\"$name\",mfile=\"$mfile\"\},"
    lappend g_outputA "\{kind=\"module_alias\",name=\"$name\",mfile=\"$mfile\"\},"
}

proc hide-version {mfile} {
    global g_outputA
    #puts stdout "\{kind=\"hide_version\", mfile=\"$mfile\"\},"
    lappend g_outputA "\{kind=\"hide_version\", mfile=\"$mfile\"\},"
}

proc hide-modulefile {mfile} {
    global g_outputA
    #puts stdout "\{kind=\"hide_modulefile\", mfile=\"$mfile\"\},"
    lappend g_outputA "\{kind=\"hide_modulefile\", mfile=\"$mfile\"\},"
}


proc module-version {args} {
    global g_outputA
    set module_name    [lindex $args 0]
    foreach version [lrange $args 1 end] {
        set val [doubleQuoteEscaped $version]
        lappend argL "\"$val\""
    }
    set versionA [join $argL ","]
    #puts stdout "\{kind=\"module_version\",module_name=\"$module_name\", module_versionA=\{$versionA\}\},"
    lappend g_outputA "\{kind=\"module_version\",module_name=\"$module_name\", module_versionA=\{$versionA\}\},"
}

proc main {mRcFile} {
    global env                 # Need this for .modulerc file that access global env vars.
    global g_outputA
    #puts stdout "ModA=\{"
    lappend g_outputA "ModA=\{"
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
        #puts stdout "\{kind=\"set_default_version\", version=\"$version\"\},"
	lappend g_outputA "\{kind=\"set_default_version\", version=\"$version\"\},"
    }
    #puts stdout "\}"
    lappend g_outputA "\}" 
    set my_output [join $g_outputA "\n"]
    puts stdout "$my_output"
}

eval main $argv
