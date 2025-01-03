-- Test module for mode-specific environment operations

-- Test setenv with mode
setenv{"TEST_VAR_LOAD", "load_only", mode={"load"}}
setenv{"TEST_VAR_UNLOAD", "unload_only", mode={"unload"}}
setenv{"TEST_VAR_BOTH", "both_modes", mode={"load", "unload"}}
setenv("TEST_VAR_NORMAL", "no_mode")  -- Normal setenv for comparison

-- Test pushenv with mode
pushenv{"STACK_VAR_LOAD", "load_value", mode={"load"}}
pushenv{"STACK_VAR_UNLOAD", "unload_value", mode={"unload"}}
pushenv{"STACK_VAR_BOTH", "both_value", mode={"load", "unload"}}
pushenv("STACK_VAR_NORMAL", "normal_value")  -- Normal pushenv for comparison

-- Test unsetenv with mode
unsetenv{"UNSET_VAR_LOAD", mode={"load"}}
unsetenv{"UNSET_VAR_UNLOAD", mode={"unload"}}
unsetenv{"UNSET_VAR_BOTH", mode={"load", "unload"}}
unsetenv("UNSET_VAR_NORMAL")  -- Normal unsetenv for comparison 