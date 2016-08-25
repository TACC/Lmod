#!/usr/bin/env tclsh

#------------------------------------------------------------------------
# Lmod License
#------------------------------------------------------------------------
#
#  Lmod is licensed under the terms of the MIT license reproduced below.
#  This means that Lmod is free software and can be used for both academic
#  and commercial purposes at absolutely no cost.
#
#  ----------------------------------------------------------------------
#
#  Copyright (C) 2008-2014 Robert McLay
#
#  Permission is hereby granted, free of charge, to any person obtaining
#  a copy of this software and associated documentation files (the
#  "Software"), to deal in the Software without restriction, including
#  without limitation the rights to use, copy, modify, merge, publish,
#  distribute, sublicense, and/or sell copies of the Software, and to
#  permit persons to whom the Software is furnished to do so, subject
#  to the following conditions:
#
#  The above copyright notice and this permission notice shall be
#  included in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
#  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
#  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.
#
#------------------------------------------------------------------------

global g_loadT g_varsT g_fullName g_usrName g_shellName g_mode
namespace eval ::cmdline {
    namespace export getArgv0 getopt getKnownOpt getfiles getoptions \
	    getKnownOptions usage
}

proc ::cmdline::getopt {argvVar optstring optVar valVar} {
    upvar 1 $argvVar argsList
    upvar 1 $optVar option
    upvar 1 $valVar value

    set result [getKnownOpt argsList $optstring option value]

    if {$result < 0} {
         set result -1
    }
    return $result
}

proc ::cmdline::getKnownOpt {argvVar optstring optVar valVar} {
    upvar 1 $argvVar argsList
    upvar 1 $optVar  option
    upvar 1 $valVar  value

    # default settings for a normal return
    set value ""
    set option ""
    set result 0

    # check if we're past the end of the args list
    if {[llength $argsList] != 0} {

	# if we got -- or an option that doesn't begin with -, return (skipping
	# the --).  otherwise process the option arg.
	switch -glob -- [set arg [lindex $argsList 0]] {
	    "--" {
		set argsList [lrange $argsList 1 end]
	    }

	    "-*" {
		set option [string range $arg 1 end]

		if {[lsearch -exact $optstring $option] != -1} {
		    # Booleans are set to 1 when present
		    set value 1
		    set result 1
		    set argsList [lrange $argsList 1 end]
		} elseif {[lsearch -exact $optstring "$option.arg"] != -1} {
		    set result 1
		    set argsList [lrange $argsList 1 end]
		    if {[llength $argsList] != 0} {
			set value [lindex $argsList 0]
			set argsList [lrange $argsList 1 end]
		    } else {
			set value "Option \"$option\" requires an argument"
			set result -2
		    }
		} else {
		    # Unknown option.
		    set value "Illegal option \"$option\""
		    set result -1
		}
	    }
	    default {
		# Skip ahead
	    }
	}
    }

    return $result
}

proc ::cmdline::getoptions {arglistVar optlist {usage options:}} {
    upvar 1 $arglistVar argv

    set opts [GetOptionDefaults $optlist result]

    set argc [llength $argv]
    while {[set err [getopt argv $opts opt arg]]} {
	if {$err < 0} {
            set result(?) ""
            break
	}
	set result($opt) $arg
    }
    if {[info exist result(?)] || [info exists result(help)]} {
	error [usage $optlist $usage]
    }
    return [array get result]
}

proc ::cmdline::getKnownOptions {arglistVar optlist {usage options:}} {
    upvar 1 $arglistVar argv

    set opts [GetOptionDefaults $optlist result]

    # As we encounter them, keep the unknown options and their
    # arguments in this list.  Before we return from this procedure,
    # we'll prepend these args to the argList so that the application
    # doesn't lose them.

    set unknownOptions [list]

    set argc [llength $argv]
    while {[set err [getKnownOpt argv $opts opt arg]]} {
	if {$err == -1} {
            # Unknown option.

            # Skip over any non-option items that follow it.
            # For now, add them to the list of unknownOptions.
            lappend unknownOptions [lindex $argv 0]
            set argv [lrange $argv 1 end]
            while {([llength $argv] != 0) \
                    && ![string match "-*" [lindex $argv 0]]} {
                lappend unknownOptions [lindex $argv 0]
                set argv [lrange $argv 1 end]
            }
	} elseif {$err == -2} {
            set result(?) ""
            break
        } else {
            set result($opt) $arg
        }
    }

    # Before returning, prepend the any unknown args back onto the
    # argList so that the application doesn't lose them.
    set argv [concat $unknownOptions $argv]

    if {[info exist result(?)] || [info exists result(help)]} {
	error [usage $optlist $usage]
    }
    return [array get result]
}



# ::cmdline::GetOptionDefaults --
#
#	This internal procdure processes the option list (that was passed to
#	the getopt or getKnownOpt procedure).  The defaultArray gets an index
#	for each option in the option list, the value of which is the option's
#	default value.
#
# Arguments:
#	optlist		A list-of-lists where each element specifies an option
#			in the form:
#				flag default comment
#			If flag ends in ".arg" then the value is taken from the
#			command line. Otherwise it is a boolean and appears in
#			the result if present on the command line. If flag ends
#			in ".secret", it will not be displayed in the usage.
#	defaultArrayVar	The name of the array in which to put argument defaults.
#
# Results
#	Name value pairs suitable for using with array set.

proc ::cmdline::GetOptionDefaults {optlist defaultArrayVar} {
    upvar 1 $defaultArrayVar result

    set opts {? help}
    foreach opt $optlist {
	set name [lindex $opt 0]
	if {[regsub -- .secret$ $name {} name] == 1} {
	    # Need to hide this from the usage display and getopt
	}
	lappend opts $name
	if {[regsub -- .arg$ $name {} name] == 1} {

	    # Set defaults for those that take values.

	    set default [lindex $opt 1]
	    set result($name) $default
	} else {
	    # The default for booleans is false
	    set result($name) 0
	}
    }
    return $opts
}

# ::cmdline::usage --
#
#	Generate an error message that lists the allowed flags.
#
# Arguments:
#	optlist		As for cmdline::getoptions
#	usage		Text to include in the usage display. Defaults to
#			"options:"
#
# Results
#	A formatted usage message

proc ::cmdline::usage {optlist {usage {options:}}} {
    set str "[getArgv0] $usage\n"
    foreach opt [concat $optlist \
	    {{help "Print this message"} {? "Print this message"}}] {
	set name [lindex $opt 0]
	if {[regsub -- .secret$ $name {} name] == 1} {
	    # Hidden option
	    continue
	}
	if {[regsub -- .arg$ $name {} name] == 1} {
	    set default [lindex $opt 1]
	    set comment [lindex $opt 2]
	    append str [format " %-20s %s <%s>\n" "-$name value" \
		    $comment $default]
	} else {
	    set comment [lindex $opt 1]
	    append str [format " %-20s %s\n" "-$name" $comment]
	}
    }
    return $str
}

# ::cmdline::getfiles --
#
#	Given a list of file arguments from the command line, compute
#	the set of valid files.  On windows, file globbing is performed
#	on each argument.  On Unix, only file existence is tested.  If
#	a file argument produces no valid files, a warning is optionally
#	generated.
#
#	This code also uses the full path for each file.  If not
#	given it prepends [pwd] to the filename.  This ensures that
#	these files will never comflict with files in our zip file.
#
# Arguments:
#	patterns	The file patterns specified by the user.
#	quiet		If this flag is set, no warnings will be generated.
#
# Results:
#	Returns the list of files that match the input patterns.

proc ::cmdline::getfiles {patterns quiet} {
    set result {}
    if {$::tcl_platform(platform) == "windows"} {
	foreach pattern $patterns {
	    set pat [string map {{\\} {\\\\}} $pattern]
	    set files [glob -nocomplain -- $pat]
	    if {$files == {}} {
		if {! $quiet} {
		    puts stdout "warning: no files match \"$pattern\""
		}
	    } else {
		foreach file $files {
		    lappend result $file
		}
	    }
	}
    } else {
	set result $patterns
    }
    set files {}
    foreach file $result {
	# Make file an absolute path so that we will never conflict
	# with files that might be contained in our zip file.
	set fullPath [file join [pwd] $file]
	
	if {[file isfile $fullPath]} {
	    lappend files $fullPath
	} elseif {! $quiet} {
	    puts stdout "warning: no files match \"$file\""
	}
    }
    return $files
}

# ::cmdline::getArgv0 --
#
#	This command returns the "sanitized" version of argv0.  It will strip
#	off the leading path and remove the ".bin" extensions that our apps
#	use because they must be wrapped by a shell script.
#
# Arguments:
#	None.
#
# Results:
#	The application name that can be used in error messages.

proc ::cmdline::getArgv0 {} {
    global argv0

    set name [file tail $argv0]
    return [file rootname $name]
}

set g_modeStack {}

proc currentMode {} {
    global g_modeStack

    set mode [lindex $g_modeStack end]
    return $mode
}

proc pushMode {mode} {
    global g_modeStack

    lappend g_modeStack $mode
}

proc popMode {} {
    global g_modeStack

    set len [llength $g_modeStack]
    set len [expr {$len - 2}]
    set g_modeStack [lrange $g_modeStack 0 $len]
}


proc module-info {what {more {}}} {
    global g_fullName g_usrName g_shellName
    set mode [currentMode]
    switch -- $what {
    "mode" {
	if {$more != ""} {
	    if {$mode == $more} {
		return 1
	    } else {
		return 0
	    }
	} else {
	    return $mode
	}
    }
    "shell" {
        return $g_shellName
    }
    "shelltype" {
        return $g_shellName
    }
    "flags" {
        return 0
    }
    "name" {
        return $g_fullName
    }
    "specified" {
        return $g_usrName
    }
    "version" {
        regexp {([^/]*)/?(.*)} $more d dir rest
        if {$rest == ""} {
            set rest "default"
        }
        return "$dir/$rest"
    }

    default {
	    error "module-info $what not supported"
	    return {}
	}
    }
}

proc module-whatis { args } {
    set msg ""
    foreach item $args {
       append msg $item
       append msg " "
    }

    regsub -all {[\n]} $msg  " " msg2
    puts stdout "whatis(\[===\[$msg2\]===\])"
}

proc setenv { var val args } {
    global env g_varsT
    set mode [currentMode]

    if {[string match "-respect" $var] || [string match "-r" $var ] || [string match "--respect" $var]} {
	set respect "true"
	set var [lindex $args 0]
	set val [lindex $args 1]
	cmdargs "setenv" $var $val $respect
	return
    }
    if {$mode == "load"} {
	# set env vars in the current environment during load only
	# Don't unset then during remove mode.
	set env($var)     $val
	set g_varsT($var) $val
    }
    cmdargs "setenv" $var $val
}

proc unsetenv { var {val {}}} {
    global env  g_varsT
    set mode [currentMode]

    if {$mode == "load"} {
	if {[info exists env($var)]} {
	    unset-env $var
	}
    }\
    elseif {$mode == "remove"} {
	if {$val != ""} {
	    set env($var) $val
	}
    }
    cmdargs "unsetenv" $var $val
}

proc pushenv { var val } {
    global env  g_varsT
    set env($var) $val
    set g_varsT($var) $val
    cmdargs "pushenv" $var $val
}

proc prepend-path { var val args} {
    if {[string match "--delim=*" $var ]} {
        set separator [string range $var 8 end]
        set var       $val
        set val       [lindex $args 0]
        set priority  [lindex $args 1]
    } elseif {[string match "-delim" $var] || [string match "-d" $var ] || [string match "--delim" $var]} {
        set separator $val
        set var       [lindex $args 0]
        set val       [lindex $args 1]
        set priority  [lindex $args 2]
    } else {
        set priority [lindex $args 0]
        set separator ":"
    }
    if {[ string match $priority ""]} {
        set priority 0
    }
    output-path-foo "prepend_path" $var $val $separator $priority
}

proc append-path { var val args} {
    if {[string match "--delim=*" $var ]} {
        set separator [string range $var 8 end]
        set var       $val
        set val       [lindex $args 0]
        set priority  [lindex $args 1]
    } elseif {[string match "-delim" $var] || [string match "-d" $var] || [string match "--delim" $var]} {
        set separator $val
        set var      [lindex $args 0]
        set val      [lindex $args 1]
        set priority [lindex $args 2]
    } else {
        set priority [lindex $args 0]
        set separator ":"
    }
    if {[ string match "" $priority]} {
        set priority 0
    }
    output-path-foo "append_path" $var $val $separator $priority
}

proc remove-path { var val args} {
    if {[string match "--delim=*" $var ]} {
        set separator [string range $var 8 end]
        set var       $val
        set val       [lindex $args 0]
        set priority  [lindex $args 1]
    } elseif {[string match "-delim" $var] || [string match "-d" $var] || [string match "--delim" $var]} {
        set separator $val
        set var      [lindex $args 0]
        set val      [lindex $args 1]
        set priority [lindex $args 2]
    } else {
        set priority [lindex $args 0]
        set separator ":"
    }
    if {[ string match "" $priority]} {
        set priority 0
    }
    output-path-foo "remove_path" $var $val $separator $priority
}

proc output-path-foo { cmd var val separator priority } {
    puts stdout "$cmd\{\"$var\",\"$val\",delim=\"$separator\",priority=\"$priority\"\}"
}


proc set-alias { var val } {
    cmdargs "set_alias" $var $val
}
proc unset-alias { var } {
    cmdargs "unset_alias" $var
}

proc add-property { var val } {
    cmdargs "add_property" $var $val
}

proc remove-property { var val } {
    cmdargs "remove_property" $var $val
}

proc doubleQuoteEscaped {text} {
    regsub -all "\"" $text "\\\"" text
    return $text
}

proc cmdargs { cmd args } {
    foreach arg $args {
	#if {$arg != ""} {
	    set val [doubleQuoteEscaped $arg]
	    lappend cmdArgsL "\"$val\""
	#}
    }
    set cmdArgs [join $cmdArgsL ","]
    puts stdout "$cmd\($cmdArgs\)"
}
proc family { var } {
    cmdargs "family" $var
}


proc loadcmd { args } {
    eval cmdargs "load" $args
}

proc swapcmd { old {new {}}} {
    if {$new == ""} {
	set new $old
    }
    eval cmdargs "unload" $old
    eval cmdargs "load"   $new
}

proc system { args } {
    foreach arg $args {
        lappend cmdArgsL "$arg"
    }
    set cmdArgs [join $cmdArgsL " "]
    puts stdout "execute\{cmd=\"$cmdArgs\",modeA = \{\"all\"\}\}"
}

proc tryloadcmd { args } {
    eval cmdargs "try_load" $args
}
proc unload { args } {
    set mode [currentMode]
    set cmdName "unload"
    if {$mode == "remove"} {
        set cmdName "load"
    }
    eval cmdargs $cmdName $args
}
proc prereq { args } {
    eval cmdargs "prereq_any" $args
}
proc prereq-any { args } {
    eval cmdargs "prereq_any" $args
}
proc conflict { args } {
    eval cmdargs "conflict" $args
}
proc use { args } {
    set path_cmd "prepend_path"
    foreach path $args {
	if {$path == ""} {
	    # skip holes
	} elseif {($path ==  "--append") ||($path == "-a") ||($path ==  "-append")} {
	    set path_cmd "append_path"
        } elseif {($path == "--prepend") ||($path == "-p") ||($path == "-prepend")} {
	    set path_cmd "prepend_path"
	} else {
            #puts stderr "path: $path"
            #if {[file isdirectory $path]} {
                eval cmdargs $path_cmd MODULEPATH $path
            #}
	}
    }
}
proc unuse { args } {
    foreach path $args {
	eval cmdargs "remove_path" MODULEPATH $path
    }
}

proc setPutMode { value } {
    global putMode
    set putMode $value
}

proc myPuts args {
    global putMode
    foreach {a b c} $args break
    set nonewline 0
    switch [llength $args] {
        1 {
            set channel stdout
            set text $a
        }
        2 {
            if {[string equal $a -nonewline]} {
                set nonewline 1
                set channel stdout
            } else {
                set channel $a
            }
            set text $b
        }
        3 {
            if {[string equal $a -nonewline]} {
                set nonewline 1
                set channel $b
            } elseif {[string equal $b -nonewline]} {
                set nonewline 1
                set channel $a
            } else {
                error {puts ?-nonewline? ?channel? text}
            }
            set text $c
        }
        default {
            error {puts ?-nonewline? ?channel? text}
        }
    }
    if {$putMode != "inHelp"} {
        if { ($channel == "stdout") || ($channel == "stderr") } {
            set channel "stdout"
            set text "LmodMessage(\[===\[$text\]===\])"
        }
    } else {
        set channel  "stdout"
    }
    if { $nonewline == 1 } {
        puts -nonewline $channel $text
    } else {
        puts $channel $text
    }

}

proc uname {what} {
    global unameCache tcl_platform
    set result {}

    if {! [info exists unameCache($what)]} {
	switch -- $what {
	sysname {
		set result $tcl_platform(os)
	    }
	machine {
		set result $tcl_platform(machine)
	    }
	nodename -
	node {
		set result [info hostname]
	    }
	release {
		set result $tcl_platform(osVersion)
	    }
	default {
		error "uname $what not supported"
	    }
	domain {
		set result [exec /bin/domainname]
	    }
	version {
		set result [exec /bin/uname -v]
	    }
	}
	set unameCache($what) $result
    }

    return $unameCache($what)
}
proc is-loaded { arg } {
    global g_loadT
    return [info exists g_loadT($arg)]
}

proc module { command args } {
    switch -- $command {
        load {
            eval loadcmd $args
        }
	switch -
	swap {
	    eval swapcmd $args
	}
        add {
            eval loadcmd $args
        }
        try-add {
            eval tryloadcmd $args
        }
        unload {
            eval unload $args
        }
        del {
            eval unload $args
        }
        rm {
            eval unload $args
        }
        use {
            eval use $args
        }
        unuse {
            eval unuse $args
        }

    }
}

proc reportError {message} {
    global ModulesCurrentModulefile g_fullName
    puts stdout "LmodError(\[===\[$ModulesCurrentModulefile: ($g_fullName): $message\]===\])"
}

proc execute-modulefile {modfile } {
    global env g_help ModulesCurrentModulefile putMode
    set ModulesCurrentModulefile $modfile

    set slave "__modname"
    set putMode "normal"

    if {![interp exists $slave]} {
	interp create $slave
	interp alias $slave family {} family
	interp alias $slave setenv {} setenv
	interp alias $slave pushenv {} pushenv
	interp alias $slave unsetenv {} unsetenv
	interp alias $slave system {} system
	interp alias $slave append-path {} append-path
	interp alias $slave prepend-path {} prepend-path
	interp alias $slave remove-path {} remove-path
	interp alias $slave prereq {} prereq
	interp alias $slave prereq-any {} prereq-any
	interp alias $slave conflict {} conflict
	interp alias $slave is-loaded {} is-loaded
	interp alias $slave module {} module
        interp alias $slave setPutMode {} setPutMode
        interp alias $slave puts {} myPuts
	interp alias $slave module-info {} module-info
	interp alias $slave module-whatis {} module-whatis
	interp alias $slave set-alias {} set-alias
	interp alias $slave unset-alias {} unset-alias
	interp alias $slave add-property {} add-property
	interp alias $slave remove-property {} remove-property
	interp alias $slave uname {} uname
	interp alias $slave module-version {} module-version
	interp alias $slave module-alias {} module-alias
	interp alias $slave reportError {} reportError

	interp eval $slave {global ModulesCurrentModulefile g_help}
	interp eval $slave [list "set" "ModulesCurrentModulefile" $modfile]
	interp eval $slave [list "set" "g_help" $g_help]
    }

    set errorVal [interp eval $slave {
	set sourceFailed [catch {source $ModulesCurrentModulefile } errorMsg]
        if { $g_help && [info procs "ModulesHelp"] == "ModulesHelp" } {
            set start "help(\[===\["
            set end   "\]===\])"
            setPutMode "inHelp"
            puts stdout $start
	    catch { ModulesHelp } errMsg
            puts stdout $end
            setPutMode "normal"
        }
        if {$sourceFailed} {
            reportError $errorMsg
            return 1
        }
    }]
    interp delete $slave
    return $errorVal
}

proc unset-env {var} {
    global env

    if {[info exists env($var)]} {
	unset env($var)
    }
}

proc main { modfile } {
    global g_mode
    pushMode $g_mode
    execute-modulefile $modfile
    popMode
}

global g_loadT g_help

set options {
            {l.arg   ""     "loaded list"}
            {h              "print ModulesHelp command"}
            {f.arg   "???"  "module full name"}
            {m.arg   "load" "mode: load remove display"}
            {s.arg   "bash" "shell name"}
            {L.arg   "???"  "LD_LIBRARY_PATH"}
            {P.arg   "???"  "LD_PRELOAD"}
            {u.arg   "???"  "module specified name"}
}

set usage ": tcl2lua.tcl \[options] filename ...\noptions:"
array set params [::cmdline::getoptions argv $options $usage]

set g_help $params(h)
foreach m [split $params(l) ":"] {
    set g_loadT($m) 1
}

set g_fullName  $params(f)
set g_usrName   $params(u)
set g_shellName $params(s)
set g_mode      $params(m)
if {[lsearch $argv "-L"] >= 0} {
    set env("LD_LIBRARY_PATH")  $params(L)
}
if {[lsearch $argv "-P"] >= 0} {
    set env("LD_PRELOAD")  $params(P)
}
eval main $argv
