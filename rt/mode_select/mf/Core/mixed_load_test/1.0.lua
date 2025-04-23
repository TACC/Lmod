-- Test module for mixed load operations
-- Tests combination of load-specific and normal operations

-- Load-specific operations
setenv{"MIXED_ENV_LOAD", "env_load", modeA={"load"}}
prepend_path{"MIXED_PATH", "/mixed/bin/load", modeA={"load"}}

-- Normal operations (should execute in load mode)
setenv("MIXED_NORMAL_ENV", "normal_env")
append_path("MIXED_LIB", "/mixed/lib/normal") 
