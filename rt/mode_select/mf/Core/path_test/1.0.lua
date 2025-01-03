-- Test module for mode-specific path operations

-- Test prepend_path with mode
prepend_path{"PATH", "/test/bin/load", mode={"load"}}       -- Should only apply during load
prepend_path{"PATH", "/test/bin/unload", mode={"unload"}}   -- Should only apply during unload
prepend_path{"PATH", "/test/bin/both", mode={"load", "unload"}}  -- Should apply during both
prepend_path("PATH", "/test/bin/normal")  -- Should always apply

-- Test append_path with mode
append_path{"LD_LIBRARY_PATH", "/test/lib/load", mode={"load"}}     -- Should only apply during load
append_path{"LD_LIBRARY_PATH", "/test/lib/unload", mode={"unload"}} -- Should only apply during unload
append_path{"LD_LIBRARY_PATH", "/test/lib/both", mode={"load", "unload"}}  -- Should apply during both
append_path("LD_LIBRARY_PATH", "/test/lib/normal")  -- Should always apply

-- Test remove_path with mode
remove_path{"REMOVE_PATH", "/old/bin/load", mode={"load"}}     -- Should only remove during load
remove_path{"REMOVE_PATH", "/old/bin/unload", mode={"unload"}} -- Should only remove during unload
remove_path{"REMOVE_PATH", "/old/bin/both", mode={"load", "unload"}}  -- Should remove during both
remove_path("REMOVE_PATH", "/old/bin/normal")  -- Should always remove

-- Test with delimiters and priorities
prepend_path{"CUSTOM_PATH", "/custom/path", delim=";", priority=100, mode={"load"}}  -- Should only apply during load
append_path{"CUSTOM_LIB", "/custom/lib", delim=":", priority=50, mode={"unload"}}    -- Should only apply during unload 