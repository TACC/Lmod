-- Test module for operations that work in both modes
-- Tests combination of dual-mode and normal operations

-- Operations that work in both load and unload modes
setenv{"MIXED_ENV_BOTH", "env_both", modeA={"load", "unload"}}
prepend_path{"MIXED_PATH", "/mixed/bin/both", modeA={"load", "unload"}}

-- Stack operations with mode selection
pushenv{"MIXED_STACK", "stack_both", modeA={"load", "unload"}}

-- Normal operations (should execute in both modes)
setenv("MIXED_NORMAL_ENV", "normal_env")
append_path("MIXED_LIB", "/mixed/lib/normal") 
