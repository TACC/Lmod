help([[
Test module for showing mode-specific function definitions
]])

whatis("Name: Mode Test")
whatis("Version: 1.0")

-- Test showing a standard function
setenv("STANDARD_VAR", "value")

-- Test showing mode-specific functions
setenv{"MODE_VAR", "value", modeA={"load"}}
prepend_path{"MODE_PATH", "/path", priority=10, modeA={"unload"}}

-- Test showing a variable used in a mode-specific function
local t = {"VAR", "value", modeA={"load"}}
setenv(t) 
