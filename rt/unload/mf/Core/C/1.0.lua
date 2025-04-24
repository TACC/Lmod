setenv{"A", "A", mode={"load"}}
setenv{"A", "B", mode={"unload"}}
setenv{"AA", "X", mode={"load", "unload"}}
prepend_path{"FOO", "BAR", mode={"unload", "load"}}
append_path{"X", "Y", mode={"unload"}}
load{"D", mode={"unload"}}
try_load{"J", mode={"unload"}}
