#!/usr/bin/tclsh

proc getModCmdOpts { &answerA &extraArgs args  } {
   
   upvar 1 ${&answerA}   resultA
   upvar 1 ${&extraArgs} otherArgs

   set resultA(mode)    normal
   set resultA(respect) {}
   set otherArgs {}

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
   set wordList [regexp -inline -all -- {\S+} $resultA(mode)]
   set modeStr "modeA=\{"

   foreach word $wordList {
      append modeStr "\"$word\","
   }
   set modeStr [string trimright $modeStr ","]
   append modeStr "\}"
   set  resultA(mode) $modeStr
   puts "modeStr:      $modeStr"
}


getModCmdOpts resultA otherArgs A B C

puts "mode: $resultA(mode)"
puts "respect: $resultA(respect)\n"

# ------------------------------------------------------------

getModCmdOpts resultA otherArgs -r --mode {load unload}  D E 

puts "mode: $resultA(mode)"
puts "respect: $resultA(respect)\n"


# ------------------------------------------------------------


getModCmdOpts resultA otherArgs -r --respect --mode load  F G H

puts "mode: $resultA(mode)"
puts "respect: $resultA(respect)\n"


