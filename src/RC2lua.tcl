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

proc initGA {} {
    global g_outputA
    unset -nocomplain g_outputA
}

proc myPuts { s } {
    global g_outputA
    lappend g_outputA $s
}

proc doubleQuoteEscaped {text} {
    regsub -all "\"" $text "\\\"" text
    return $text
}

proc module-alias {name mfile} {
    myPuts "\{kind=\"module_alias\",name=\"$name\",mfile=\"$mfile\"\},"
}

proc hide-version {mfile} {
    myPuts "\{kind=\"hide_version\", mfile=\"$mfile\"\},"
}

proc hide-modulefile {mfile} {
    myPuts "\{kind=\"hide_modulefile\", mfile=\"$mfile\"\},"
}


proc module-version {args} {
    set module_name    [lindex $args 0]
    foreach version [lrange $args 1 end] {
        set val [doubleQuoteEscaped $version]
        lappend argL "\"$val\""
    }
    set versionA [join $argL ","]
    myPuts "\{kind=\"module_version\",module_name=\"$module_name\", module_versionA=\{$versionA\}\},"
}

proc showResults {} {
    global g_outputA
    global g_fast
    if [info exists g_outputA] {
	set my_output [join  $g_outputA "\n"]
    } else {
	set my_output " "
    }
    
    if { $g_fast > 0 } {
	setResults $my_output
    } else {
	puts stdout "$my_output"
    }
}

proc main {mRcFile} {
    global env                 # Need this for .modulerc file that access global env vars.
    global g_fast
    initGA
    myPuts "ModA=\{"
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

    if { $found > 0 } {
	myPuts "\{kind=\"set_default_version\", version=\"$version\"\},"
    }
    myPuts "\}" 
    showResults
}


set g_fast 0

foreach arg $argv {
    switch -regexp -- $arg {
	^-F$ {
	    set g_fast 1
	}
	^[^-].*$ {
	    set fn $arg
	}
    }
}


main $fn
