setenv{"FOO", "BAR", mode={"load"}}
setenv{"A", "B", mode={"unload"}}
pushenv{"STACK_VAR", "load_value", mode={"load"}}
pushenv{"STACK_VAR", "unload_value", mode={"unload"}}

-- Path operation tests
prepend_path{"PATH_TEST", "/first", mode={"load"}}
prepend_path{"PATH_TEST", "/unload_first", mode={"unload"}}

append_path{"PATH_TEST", "/last", mode={"load"}}
append_path{"PATH_TEST", "/unload_last", mode={"unload"}}

-- Test remove during specific modes
remove_path{"PATH_TEST", "/to_remove", mode={"unload"}}


--setenv{"AA", "X", mode={"load", "unload"}}
--prepend_path{"FOO", "BAR", mode={"unload", "load"}}
--append_path{"X", "Y", mode={"unload"}}
--load{"D", mode={"unload"}}
--try_load{"J", mode={"unload"}}
