lappend g_outputA ""
lappend g_outputA "local foo=\"abc\""
lappend g_outputA "local bar=\"def\""
lappend g_outputA "setenv(\"FOO\", foo)"
lappend g_outputA "setenv(\"BAR\", bar)"

foreach arg $argv {
    puts stdout $arg
}


set my_output [join $g_outputA "\n" ]
puts stdout $my_output

prtstr $my_output
