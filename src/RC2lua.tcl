#!@tclsh@

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

array set g_state_defs [list\
                           usergroups {<undef> findUserGroups}\
                           username   {<undef> findUser}\
                       ]
proc findCmdPath {cmd} {
   return [lindex [auto_execok $cmd] 0]
}

proc capture {cmd args} {
   set path2cmd [findCmdPath $cmd]
   if {$path2cmd eq {}} {
      error "$cmd not found"
   } else {
      return [exec $path2cmd {*}$args]
   }
}


proc findUserGroups {} {
   return [capture id -G -n]
}
proc findUser {} {
   return [capture id -u -n]
}

proc getState {state} {
   if { ! [info exists ::g_states($state)]} {
      if {[info exists ::g_state_defs($state)]} {
         lassign $::g_state_defs($state) value initProc
      } else {
         set value <undef>
         set initProc {}
      }

      if {$initProc ne {}} {
         set value [$initProc]
      }
      set ::g_states($state) $value
      return $value
   } else {
      return ::g_states($state)
   }
}
      
         


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
    myPuts "\{action=\"module_alias\",name=\"$name\",mfile=\"$mfile\"\},"
}

proc hide-version {mfile} {
    myPuts "\{action=\"hide_version\", mfile=\"$mfile\"\},"
}

proc hide-modulefile {mfile} {
    myPuts "\{action=\"hide_modulefile\", mfile=\"$mfile\"\},"
}


proc parseMyArgs {args} {
   set extraArgA {}
   set argT      [dict create]

   foreach arg $args {
      if { [info exists timeDateArg] } {
         dict set argT $timeDateArg "\"$arg\""
         unset timeDateArg
      } elseif {[info exists nextMsgKey] } {
         dict set argT $nextMsgKey "\[===\[$arg\]===\]"
         unset nextMsgKey
      } elseif {[info exists nextKeyA]} {
         set v [string trimleft $arg " "]
         set v [string trimleft $v   " "]
         set v [regsub -all {\s+} $v ,]
         set valueA [split $v ","]
         set str "\{"
         foreach v $valueA {
            append str "\[\"$v\"\]=true,"
         }
         append str "\}"

         dict set argT $nextKeyA $str
         unset nextKeyA
      } else {
         switch -- $arg {
            --before - --after {
               set timeDateArg [string trimleft $arg -]
            }
            --hard - --soft {
               set v [string trimleft $arg -]
               dict set argT kind "\"$v\""
            }
            --hidden-loaded {
               dict set argT hidden_loaded true
            }
            --not-group - --not-user - --group - --user {
               set nextKeyA [string map {- {}} $arg]T
            }
            --message - --nearly-message {
               set nextMsgKey [string map {- {}} $arg]
            }
            default {
               lappend extraArgA $arg
            }
         }
      }
   }
   
   return [list $argT $extraArgA]
}

proc module-hide {args} {
   lassign [parseMyArgs {*}$args] argT extraArgA
   
   if { ! [dict exists $argT kind] } {
      dict set argT kind "\"hidden\""
   }
   foreach name $extraArgA {
      set str "\{action=\"hide\",name="
      append str "\"$name\","
   
      dict for {key value} $argT {
         append str "$key=$value,"
      }
      append str "\},"
      set str [regsub -all ",\}" $str "\}"]
      myPuts $str
   }
}

proc module-forbid {args} {
   lassign [parseMyArgs {*}$args] argT extraArgA
   foreach name $extraArgA {
      set str "\{action=\"forbid\",name="
      append str "\"$name\","

      dict for {key value} $argT {
         append str "$key=$value,"
      }
      append str "\},"
      set str [regsub -all ",\}" $str "\}"]
      myPuts $str
   }
}


proc module-version {args} {
    set module_name    [lindex $args 0]
    foreach version [lrange $args 1 end] {
        set val [doubleQuoteEscaped $version]
        lappend argL "\"$val\""
    }
    set versionA [join $argL ","]
    myPuts "\{action=\"module_version\",module_name=\"$module_name\", module_versionA=\{$versionA\}\},"
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

proc module-info {what {extraArg {}}} {
   switch -- $what {
      username {
         set myUser [getState username]
         if {$extraArg ne {}} {
            return [expr {$myUser eq $extraArg}]
         } else {
            return $myUser
         }
      }
      usergroups {
         if {$extraArg ne {}} {
            return [expr {$extraArg in [getState usergroups]}]
         } else {
            return [getState usergroups]
         }
      }
      default {
         error "module-info what not supported"
         return {}
      }
   }
}



proc main {mRcFile} {
    global env                 # Need this for .modulerc file that access global env vars.
    global g_fast
    global ModuleTool
    global ModuleToolVersion

    set ModuleTool        "Lmod"
    set ModuleToolVersion $env(LMOD_VERSION)

    initGA
    myPuts "ModA=\{"
    set version  -1
    set found     0

    source $mRcFile

    if {[info exists ModulesVersion]} {
      set version $ModulesVersion
      set found 1
    } elseif {[info exists ModuleVersion]} {
      set version $ModuleVersion
      set found 1
    }

    if { $found > 0 } {
	myPuts "\{action=\"set_default_version\", version=\"$version\"\},"
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
