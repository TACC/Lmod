#!/usr/bin/tclsh

proc getModCmdOpts { &answerA &extraArgs args  } {
   
   upvar 1 ${&answerA}   resultA
   upvar 1 ${&extraArgs} otherArgs
   foreach arg $args {
      if {[info exists nextArgIsKey]} {
         set resultA($nextArgIsKey) $arg
         unset nextArgIsKey
      } elseif {[info exists ignoreNextArg]} {
         unset ignoreNextArg
      } else {
         switch -- $arg {
            -r - -respect - --respect {
               set resultA(respect) true
            }
            -mode - --mode {
               set nextArgIsKey mode
            }
            default {
               lappend otherArgs $arg
            }
         }
      }
   }
}

#lassign [getModCmdOpts -r -respect --respect --mode normal  A B C] resultA otherArgs
getModCmdOpts resultA otherArgs -r --mode {load unload}  A B C

puts "mode: $resultA(mode)"
puts "respect: $resultA(respect)"
puts "args: $otherArgs"

