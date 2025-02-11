set v [info patchlevel]
set sA [split $v "."]
set my_version 0
foreach n $sA {
   set my_version [expr {$my_version * 1000 + $n}]
}
puts $my_version
