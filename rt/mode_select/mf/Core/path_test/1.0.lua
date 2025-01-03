-- Test module for mode-specific path operations

-- Test prepend_path with mode
prepend_path{"PATH", "/test/bin/load", mode={"load"}}
prepend_path{"PATH", "/test/bin/unload", mode={"unload"}}
prepend_path{"PATH", "/test/bin/both", mode={"load", "unload"}}
prepend_path("PATH", "/test/bin/normal")  -- Normal prepend for comparison

-- Test append_path with mode
append_path{"LD_LIBRARY_PATH", "/test/lib/load", mode={"load"}}
append_path{"LD_LIBRARY_PATH", "/test/lib/unload", mode={"unload"}}
append_path{"LD_LIBRARY_PATH", "/test/lib/both", mode={"load", "unload"}}
append_path("LD_LIBRARY_PATH", "/test/lib/normal")  -- Normal append for comparison

-- Test remove_path with mode
remove_path{"REMOVE_PATH", "/old/bin/load", mode={"load"}}
remove_path{"REMOVE_PATH", "/old/bin/unload", mode={"unload"}}
remove_path{"REMOVE_PATH", "/old/bin/both", mode={"load", "unload"}}
remove_path("REMOVE_PATH", "/old/bin/normal")  -- Normal remove for comparison

-- Test with delimiters and priorities
prepend_path{"CUSTOM_PATH", "/custom/path", delim=";", priority=100, mode={"load"}}
append_path{"CUSTOM_LIB", "/custom/lib", delim=":", priority=50, mode={"unload"}} 