lappend g_outputA ""
lappend g_outputA "local foo=\"abc\""
lappend g_outputA "local bar=\"def\""
lappend g_outputA "setenv(\"FOO\", foo)"
lappend g_outputA "setenv(\"BAR\", bar)"




set my_output [join $g_outputA "\n" ]
prtstr $my_output
prtstr "argv0 $argv0"
prtstr "argc $argc"


foreach arg $argv {
    puts stdout $arg
}

