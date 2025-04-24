setenv{"A", "A", modeA={"load"}}
setenv{"A", "B", modeA={"unload"}}
setenv{"AA", "X", modeA={"load", "unload"}}
prepend_path{"FOO", "BAR", modeA={"unload", "load"}}
append_path{"X", "Y", modeA={"unload"}}
load{"D", modeA={"unload"}}
try_load{"J", modeA={"unload"}}
