-- Test module for mode-specific environment operations

-- Test setenv with mode
setenv{"TEST_VAR_LOAD", "load_only", modeA={"load"}}
setenv{"TEST_VAR_UNLOAD", "unload_only", modeA={"unload"}}
setenv{"TEST_VAR_BOTH", "both_modes", modeA={"load", "unload"}}
setenv("TEST_VAR_NORMAL", "no_mode")  -- Normal setenv for comparison

-- Test pushenv with mode
pushenv{"STACK_VAR_LOAD", "load_value", modeA={"load"}}
pushenv{"STACK_VAR_UNLOAD", "unload_value", modeA={"unload"}}
pushenv{"STACK_VAR_BOTH", "both_value", modeA={"load", "unload"}}
pushenv("STACK_VAR_NORMAL", "normal_value")  -- Normal pushenv for comparison

-- Test unsetenv with mode
unsetenv{"UNSET_VAR_LOAD", modeA={"load"}}
unsetenv{"UNSET_VAR_UNLOAD", modeA={"unload"}}
unsetenv{"UNSET_VAR_BOTH", modeA={"load", "unload"}}
unsetenv("UNSET_VAR_NORMAL")  -- Normal unsetenv for comparison 
