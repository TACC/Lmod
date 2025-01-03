-- Test module for mixed mode and non-mode operations

-- Test environment and path operations mixed together
setenv{"MIXED_ENV_LOAD", "env_load", mode={"load"}}
prepend_path{"MIXED_PATH", "/mixed/bin/load", mode={"load"}}

setenv{"MIXED_ENV_UNLOAD", "env_unload", mode={"unload"}}
append_path{"MIXED_PATH", "/mixed/bin/unload", mode={"unload"}}

-- Test normal operations mixed with mode operations
setenv("MIXED_NORMAL_ENV", "normal_env")
prepend_path{"MIXED_PATH", "/mixed/bin/both", mode={"load", "unload"}}

-- Test pushenv with path operations
pushenv{"MIXED_STACK", "stack_load", mode={"load"}}
append_path("MIXED_LIB", "/mixed/lib/normal")

-- Test complex combinations
setenv{"MIXED_COMPLEX", "complex_load", mode={"load"}}
prepend_path{"MIXED_COMPLEX_PATH", "/complex/bin", delim=";", priority=100, mode={"load"}}
pushenv{"MIXED_COMPLEX_STACK", "complex_both", mode={"load", "unload"}}

-- Test error cases
setenv{"MIXED_ERROR", "error_value", mode={}}  -- Empty mode table
prepend_path{"MIXED_ERROR_PATH", "/error/bin", mode={"invalid_mode"}}  -- Invalid mode 