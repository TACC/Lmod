#!@tclsh@

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
#  Copyright (C) 2008-2018 Robert McLay
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

global g_loadT g_varsT g_fullName g_usrName g_shellName g_mode g_shellType g_outputA, g_fast
global g_moduleT g_setup_moduleT g_lua_cmd env g_my_cmd
global g_envT g_envClrT

set g_setup_moduleT 0
set g_lua_cmd       "@path_to_lua@"
set g_lmod_cmd      "@path_to_lmod@"
set g_my_cmd        $argv0
set g_envT          [dict create]
set g_envClrT       [dict create]

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
    global g_outputA
    set result {}
    if {$::tcl_platform(platform) == "windows"} {
	foreach pattern $patterns {
	    set pat [string map {{\\} {\\\\}} $pattern]
	    set files [glob -nocomplain -- $pat]
	    if {$files == {}} {
		if {! $quiet} {
		    lappend g_outputA "warning: no files match \"$pattern\"\n"
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
	    lappend g_outputA  "warning: no files match \"$file\"\n"
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

proc currentModeLmod {} {
    global g_modeStack
    set mode [lindex $g_modeStack end]
    set returnVal "load"
    if { $mode == "remove" } {
	set returnVal "unload"
    }
    return $returnVal
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


proc getModCmdOpts { &answerA &extraArgs args  } {
   
   upvar 1 ${&answerA}   resultA
   upvar 1 ${&extraArgs} otherArgs

   set resultA(mode)      normal
   set resultA(respect)   {}
   set resultA(separator) ":"
   set otherArgs {}

   foreach arg $args {
      if {[info exists nextArgIsKey]} {
         set resultA($nextArgIsKey) $arg
         unset nextArgIsKey
      } else {
         switch -glob -- $arg {
            -r - -respect - --respect {
               set resultA(respect) true
            }
            -mode - --mode {
               set nextArgIsKey mode
            }
            "--delim=*" {
               set resultA(separator) [string range $arg 8 end]
            }
            -d - -delim - --delim {
               set nextArgIsKey separator
            }
            default {
               lappend otherArgs $arg
            }
         }
      }
   }
   set wordList [regexp -inline -all -- {\S+} $resultA(mode)]   
   set modeStr "modeA=\{"

   foreach word $wordList {
      append modeStr "\"$word\","
   }
   set modeStr [string trimright $modeStr ","]
   append modeStr "\}"
   set  resultA(mode) $modeStr
}

proc module-info {what {more {}}} {
    global g_fullName g_usrName g_shellName g_shellType
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
        if {$more ne {}} {
            if {$g_shellName eq $more} {
               return 1
            } else {
               return 0
            }
        } else {
            return $g_shellName
        }
    }
    "shelltype" {
        return $g_shellType
    }
    "flags" {
        return 0
    }
    "name" {
        return $g_fullName
    }
    "user" {
         # C-version specific option, not relevant for Tcl-version but return
         # an empty value or false to avoid breaking modulefiles using it
         if {$more ne ""} {
            return 0
         } else {
            return {}
         }
    }
    "symbols" {
         # an empty value or false to avoid breaking modulefiles using it
         if {$more ne ""} {
            return 0
         } else {
            return {}
         }
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
    global g_outputA
    set msg ""
    foreach item $args {
       append msg $item
       append msg " "
    }

    regsub -all {[\n]} $msg  " " msg2
    set msg2 [string trimright $msg2]
    lappend g_outputA  "whatis(\[===\[$msg2\]===\])\n"
}

proc myBreak {  } {
    cmdargs "LmodBreak"  ""
}


proc setenv { args } {
   global env g_varsT
   set mode [currentMode]

   getModCmdOpts resultA otherArgs {*}$args
   set respect $resultA(respect)
   
   set var [lindex $otherArgs 0]
   set val [lindex $otherArgs 1]

   if {$mode == "load"} {
      # set env vars in the current environment during load only
      # Don't unset then during remove mode.
      set-env $var $val
      set g_varsT($var) $val
   }
   if {$mode == "display"} {
      set-env $var $val
   }
   if {$respect == "true"} {
      cmdargs_w_mode_select "setenv" $resultA(mode) $var $val $respect
   } else {
      cmdargs_w_mode_select "setenv" $resultA(mode) $var $val
   }
}

proc getenv { var args } {
    cmdargs "os.getenv" $var
}

proc unsetenv { args } {
   global env  g_varsT
   set mode [currentMode]

   getModCmdOpts resultA otherArgs {*}$args
   set respect $resultA(respect)
   
   set var [lindex $otherArgs 0]
   set val [lindex $otherArgs 1]

   if {$mode == "load"} {
      if {[info exists env($var)]} {
         unset-env $var
      }
    } elseif {$mode == "remove"} {
       if {$val != ""} {
          set-env $var $val
       }
    }
   cmdargs_w_mode_select "unsetenv" $resultA(mode) $var $val
}

proc require-fullname {} {
    cmdargs "requireFullName"
}

proc haveDynamicMPATH {} {
    cmdargs "haveDynamicMPATH"
}
    
# Dictionary-style string comparison
# Use dictionary sort of lsort proc to compare two strings in the "string
# compare" fashion (returning -1, 0 or 1). Tcl dictionary-style comparison
# enables to compare software versions (ex: "1.10" is greater than "1.8")
proc versioncmp {str1 str2} {
   if {$str1 eq $str2} {
      return 0
   # put both strings in a list, then lsort it and get first element
   } elseif {[lindex [lsort -dictionary [list $str1 $str2]] 0] eq $str1} {
      return -1
   } else {
      return 1
   }
}



proc pushenv { args } {
   global env  g_varsT

   getModCmdOpts resultA otherArgs {*}$args
   
   set var [lindex $otherArgs 0]
   set val [lindex $otherArgs 1]

   set-env $var $val
   set g_varsT($var) $val
   
   cmdargs_w_mode_select "pushenv" $resultA(mode) $var $val
}

proc prepend-path { args } {
   
   getModCmdOpts resultA otherArgs {*}$args
   
   set var       [lindex $otherArgs 0]
   set val       [lindex $otherArgs 1]
   set priority  [lindex $otherArgs 2]
   if {[ string match $priority ""]} {
      set priority 0
   }
   output-path-foo "prepend_path" $resultA(mode) $var $val $resultA(separator) $priority
}

proc append-path { args } {
   getModCmdOpts resultA otherArgs {*}$args
   
   set var       [lindex $otherArgs 0]
   set val       [lindex $otherArgs 1]
   set priority  [lindex $otherArgs 2]
   if {[ string match $priority ""]} {
      set priority 0
   }
   output-path-foo "append_path" $resultA(mode) $var $val $resultA(separator) $priority
}

proc remove-path { args } {
   getModCmdOpts resultA otherArgs {*}$args
   
   set var       [lindex $otherArgs 0]
   set val       [lindex $otherArgs 1]
   set priority  [lindex $otherArgs 2]
   if {[ string match $priority ""]} {
      set priority 0
   }
   output-path-foo "remove_path" $resultA(mode) $var $val $resultA(separator) $priority
}

proc output-path-foo { cmd mode var val separator priority } {
   global g_outputA
   lappend g_outputA  "$cmd\{\"$var\",\"$val\",delim=\"$separator\",priority=$priority,$mode\}\n"
}


proc set-alias { var val } {
    cmdargs "set_alias" $var $val
}
proc unset-alias { var } {
    cmdargs "unset_alias" $var
}

proc set-function { var val } {
    cmdargs "set_shell_function" $var $val ""
}
proc unset-function { var } {
    cmdargs "unset_shell_function" $var "" ""
}

proc add-property { var val } {
    cmdargs "add_property" $var $val
}

proc remove-property { var val } {
    cmdargs "remove_property" $var $val
}

proc doubleQuoteEscaped {str} {
    set charlist {\\\t"\n}
    # "
    return [regsub -all "\(\[$charlist\]\)" $str {\\\1}]
}

proc cmdargs { cmd args } {
    global g_outputA
    foreach arg $args {
	set val [string trimright $arg "\r\n "]
        set val [doubleQuoteEscaped $val]
	lappend cmdArgsL "\"$val\""
    }

    if {[info exists cmdArgsL]} {
        set cmdArgs [join $cmdArgsL ","]
	lappend g_outputA  "$cmd\($cmdArgs\)\n"
    } else {
	lappend g_outputA  "$cmd\(\)\n"
    }
}

proc cmdargs_w_mode_select { cmd mode args} {
    global g_outputA
    foreach arg $args {
	set val [string trimright $arg "\r\n "]
        set val [doubleQuoteEscaped $val]
	lappend cmdArgsL "\"$val\""
    }
    if {[info exists cmdArgsL]} {
        set cmdArgs [join $cmdArgsL ","]
       lappend g_outputA  "$cmd\{$mode, $cmdArgs\}\n"
    } else {
	lappend g_outputA  "$cmd\(\)\n"
    }
}

proc depends-on { args} {
    eval cmdargs "depends_on" $args
}

proc depends-on-any { args} {
    eval cmdargs "depends_on_any" $args
}

proc complete { shellName name args } {
    global g_outputA
    foreach arg $args {
	set val [string trimright $arg "\r\n "]
        set val [doubleQuoteEscaped $val]
	lappend cmdArgsL $val
    }
    if {[info exists cmdArgsL]} {
        set cmdArgs [join $cmdArgsL " "]
	lappend g_outputA  "complete\(\"$shellName\",\"$name\",\"$cmdArgs\"\)\n"
    } else {
	lappend g_outputA  "complete\(\"$shellName\",\"$name\"\)\n"
    }
}

proc my_exit { {code 1} } {
    eval cmdargs "os.exit" $code
}

proc always-load { args} {
    eval cmdargs "always_load" $args
}
proc family { var } {
    cmdargs "family" $var
}

proc extensions { args } {
    foreach arg $args {
        set val [doubleQuoteEscaped $arg]
        lappend cmdArgsL $val
    }
    if {[info exists cmdArgsL]} {
        set cmdArgs [join $cmdArgsL ","]
	eval cmdargs "extensions" $cmdArgs
    }
}

proc loadcmd { cmdName args } {
   getModCmdOpts resultA otherArgs {*}$args
   
   eval cmdargs_w_mode_select $cmdName $resultA(mode) {*}$otherArgs
}

proc swapcmd { old {new {}}} {
    if {$new == ""} {
	set new $old
    }
    eval cmdargs "unload" $old
    eval cmdargs "load"   $new
}

proc system {args} {
   set mode [currentMode]
   set status {}

   switch -- $mode {
      load - unload {
         if {[catch {exec /bin/sh -c [join $args]}]} {
             # non-zero exit status, get it:
             set status [lindex $::errorCode 2]
         } else {
             # exit status was 0
             set status 0
         }
      }
   }
   return $status
}


proc unload { args } {
   getModCmdOpts resultA otherArgs {*}$args
   set mode [currentMode]
   set cmdName "unload"
   if {$mode == "remove"} {
      set cmdName "load"
   }
   eval cmdargs_w_mode_select $cmdName $resultA(mode) {*}$otherArgs
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
	    eval cmdargs $path_cmd MODULEPATH $path
	}
    }
}
proc unuse { args } {
    foreach path $args {
	eval cmdargs "remove_path" MODULEPATH $path
    }
}

proc purge {} {
    eval cmdargs "purge"
}

proc setPutMode { value } {
    global putMode
    set putMode $value
}

proc initGA {} {
    global g_outputA
    unset -nocomplain g_outputA
}

proc showResults {} {
    global g_outputA
    global g_fast
    if [info exists g_outputA] {
	set my_output [join  $g_outputA ""]
    } else {
	set my_output " "
    }
    
    if { $g_fast > 0 } {
	setResults $my_output
    } else {
	puts stdout "$my_output"
    }
}

proc myPuts args {
    global putMode g_outputA

    foreach {a b c} $args break
    set nonewline 0
    set text "This string should never be seen!"
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
    if { $putMode != "inHelp" } {
        if { $nonewline == 0 && $channel  != "stdout" } {
            set text "$text\n"
        }
        set nonewline 0
        if { $channel == "stderr" } {
            set text "LmodMsgRaw(\[===\[$text\]===\])"
        } elseif { $channel == "stdout" } {
	    set lmodMode [currentModeLmod]
            set text "execute{cmd=\[===\[$text\]===\],modeA={\"$lmodMode\"}}"
        } elseif { $channel == "prestdout" } {
            set text "io.stdout:write(\[===\[$text\]===\])"
        }
    }
    

    lappend g_outputA $text
    if { $nonewline == 0 } {
        lappend g_outputA "\n"
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

proc findProg { arg } {
    global env
    foreach entry [split $env(PATH) ":" ] {
	set myfile "$entry/$arg"
	if { [file executable $myfile ] } {
	    return $myfile
	}
    }
    return "Unknown"
}

proc is-loaded { arg } {
    global g_loadT
    return [info exists g_loadT($arg)]
}

proc is-avail { arg } {
    global g_moduleT g_setup_moduleT g_lua_cmd g_my_cmd g_lmod_cmd

    if { ! $g_setup_moduleT } {
	if { [regexp "^@" $g_lua_cmd match ] } {
	    set g_lua_cmd [findProg lua]
	}

	if { [regexp "^@" $g_lmod_cmd match ] } {
	    set my_dir     [ file dirname $g_my_cmd ]
	    set g_lmod_cmd "$my_dir/lmod.in.lua"
	}
	
        if { ! [ file exists $g_lua_cmd ]} {
            reportError "unable to find $g_lua_cmd"
        }

        if { ! [ file exists $g_lmod_cmd ]} {
            reportError "unable to find $g_lmod_cmd"
        }


	set g_setup_moduleT 1
	set g_moduleT [dict create]
	set cmd "$g_lua_cmd $g_lmod_cmd bash --no_redirect -t avail"
	set ret [catch {
	    exec sh -c $cmd |& cat
	} msg]

	foreach line [split $msg "\n" ] {
	    if {[regexp "^MODULEPATH=" $line match]} {
		continue
	    }
	    if {[regexp "^export" $line match]} {
		continue
	    }
	    if {[regexp "=" $line match]} {
		continue
	    }
	    if {[regexp ":" $line match]} {
		continue
	    }
	    if {[regexp "/$" $line match]} {
		regsub "/$" $line "" line
	    }
	    set moduleName $line
	    dict set g_moduleT $moduleName 1
	}
    }
    return [dict exist $g_moduleT $arg]
}

proc module { command args } {
    switch -- $command {
        load {
            eval loadcmd "load" $args
        }
        load-any {
            eval loadcmd "load_any" $args
        }
	switch -
	swap {
	    eval swapcmd $args
	}
        add {
            eval loadcmd "load" $args
        }
        purge {
            eval purge $args
        }
        try-add {
            eval loadcmd "try_load" $args
        }
        try-load {
            eval loadcmd "try_load" $args
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
        default {
            reportError "Unknown module command: $command -> exitting"
        }
    }
}

proc reportError {message} {
    global g_outputA
    global ModulesCurrentModulefile g_fullName
    lappend g_outputA "LmodError(\[===\[$ModulesCurrentModulefile: ($g_fullName): $message\]===\])\n"
}

proc execute-modulefile {modfile } {
    global env g_help ModulesCurrentModulefile putMode g_shellType g_shellName ModuleTool ModuleToolVersion
    set ModulesCurrentModulefile $modfile
    set ModuleTool        "Lmod"
    set ModuleToolVersion $env(LMOD_VERSION)
    set putMode "normal"

    if {[info exists child] && [interp exists $child]} {
	interp delete $child
    }
	
    set child [interp create]
    interp alias $child add-property   	 {} add-property
    interp alias $child always-load    	 {} always-load
    interp alias $child append-path    	 {} append-path
    interp alias $child complete       	 {} complete
    interp alias $child conflict       	 {} conflict
    interp alias $child depends-on     	 {} depends-on
    interp alias $child depends-on-any 	 {} depends-on-any
    interp alias $child exit          	 {} my_exit
    interp alias $child extensions     	 {} extensions
    interp alias $child family         	 {} family
    interp alias $child getenv           {} getenv
    interp alias $child haveDynamicMPATH {} haveDynamicMPATH
    interp alias $child initGA         	 {} initGA
    interp alias $child is-loaded      	 {} is-loaded
    interp alias $child is-avail      	 {} is-avail
    interp alias $child module         	 {} module
    interp alias $child module-info    	 {} module-info
    interp alias $child module-whatis  	 {} module-whatis
    interp alias $child myPuts         	 {} myPuts
    interp alias $child myBreak      	 {} myBreak
    interp alias $child prepend-path   	 {} prepend-path
    interp alias $child prereq         	 {} prereq
    interp alias $child prereq-any     	 {} prereq-any
    interp alias $child pushenv        	 {} pushenv
    interp alias $child puts           	 {} myPuts
    interp alias $child remove-path    	 {} remove-path
    interp alias $child remove-property  {} remove-property
    interp alias $child reportError      {} reportError
    interp alias $child require-fullname {} require-fullname
    interp alias $child set-alias        {} set-alias
    interp alias $child set-function     {} set-function
    interp alias $child setPutMode       {} setPutMode
    interp alias $child setenv           {} setenv
    interp alias $child showResults      {} showResults
    interp alias $child system           {} system
    interp alias $child uname            {} uname
    interp alias $child unset-alias      {} unset-alias
    interp alias $child unset-function   {} unset-function
    interp alias $child unsetenv         {} unsetenv
    interp alias $child versioncmp       {} versioncmp

    interp eval $child {global ModulesCurrentModulefile g_help g_shellType g_shellName}
    interp eval $child [list "set" "ModulesCurrentModulefile" $modfile]
    interp eval $child [list "set" "ModuleTool"               "Lmod"]
    interp eval $child [list "set" "ModuleToolVersion"        $env(LMOD_VERSION)]
    interp eval $child [list "set" "g_help"                   $g_help]
    interp eval $child [list "set" "g_shellType"              $g_shellType]
    interp eval $child [list "set" "g_shellName"              $g_shellName]

    set errorVal [interp eval $child {
        set returnVal 0
        initGA
        if { $g_shellType == "broken" } {
            reportError "Unknown shell: $g_shellName exiting!"
            showResults
            return 1
        }
        
	set sourceFailed [catch {source $ModulesCurrentModulefile } errorMsg]
        if { $g_help && [info procs "ModulesHelp"] == "ModulesHelp" } {
            set start "help(\[===\["
            set end   "\]===\])"
            setPutMode "inHelp"
            myPuts stdout $start
	    catch { ModulesHelp } errMsg
            myPuts stdout $end
            setPutMode "normal"
        }
        if {$sourceFailed} {
	    if { $sourceFailed == 4 || $errorMsg == {invoked "continue" outside of a loop}} {
		set returnVal 0
		showResults
		return $returnVal
	    } elseif { $sourceFailed == 3 || $errorMsg == {invoked "break" outside of a loop}} {
		set returnVal 1
		myBreak
		showResults
		return $returnVal
	    }
            reportError $errorMsg
	    set returnVal 1
        }
        showResults
	return $returnVal
    }]
    interp delete $child
    return $errorVal
}





proc getenv {var} {

    global env
    set v ""
    if {[info exists env($var)]} {
        set v $env($var)           
    }
    return $v
}

proc unset-env {var} {
    global env

    if {[info exists env($var)]} {
	unset env($var)
    }
}

proc set-env {var value} {
    global g_envT g_envClrT env
    # If setting a var not seen then mark it for deletion when reset is called.
    if { ! [info exists env($var)] && ! [info exists g_envT($var)] } {
	dict set g_envClrT $var 1
    } else {
	dict set g_envT $var $env($var)
    }
    set env($var) $value
}

proc reset-env {} {
    global env g_envT g_envClrT
    dict for {key value} $g_envT {
	set env($key) $value
    }
    dict for {key value} $g_envClrT {
	unset env($key)
    }
}


proc main { modfile } {
    global g_mode

    pushMode           $g_mode
    execute-modulefile $modfile
    popMode
    reset-env
}

global g_loadT g_help 

set options {
            {l.arg   ""     "loaded list"}
            {h              "print ModulesHelp command"}
            {F              "fast processing of TCL files"}
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

set g_fast      $params(F)
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

switch -regexp -- $g_shellName {
    ^(sh|bash|ksh|zsh)$ {
	set g_shellType sh
    }
    ^(cmd)$ {
        set g_shellType cmd
    }
    ^(csh|tcsh)$ {
	set g_shellType csh
    }
    ^(perl)$ {
	set g_shellType perl
    }
    ^(python)$ {
	set g_shellType python
    }
    ^(json)$ {
	set g_shellType json
    }
    ^(lisp)$ {
	set g_shellType lisp
    }
    ^(fish)$ {
	set g_shellType fish
    }
    ^(cmake)$ {
	set g_shellType cmake
    }
    ^(r)$ {
	set g_shellType r
    }
    ^(rc)$ {
	set g_shellType rc
    }
    . {
	set g_shellType broken
    }
}

eval main $argv
