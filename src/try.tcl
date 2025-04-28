#!/usr/bin/tclsh

proc getModCmdOpts { args } {
   
   #set resultA {}
   #set otherArgs {}

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
            --mode {
               set nextArgIsKey mode
            }
            default {
               lappend otherArgs $arg
            }
         }
      }
   }
   puts $resultA(respect)
   puts $resultA(mode)
   puts $otherArgs
   return [list $resultA $otherArgs ]
}

#lassign [getModCmdOpts -r -respect --respect --mode normal  A B C] resultA otherArgs
lassign [getModCmdOpts -r --mode {load unload}  A B C] resultA otherArgs

puts resultA(respect)
puts otherArgs(1)

