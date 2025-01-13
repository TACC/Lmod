-- Test module for mixed unload operations
-- Tests combination of unload-specific and normal operations

-- Unload-specific operations
setenv{"MIXED_ENV_UNLOAD", "env_unload", mode={"unload"}}
append_path{"MIXED_PATH", "/mixed/bin/unload", mode={"unload"}}

-- Normal operations (should execute in unload mode)
setenv("MIXED_NORMAL_ENV", "normal_env")
append_path("MIXED_LIB", "/mixed/lib/normal") 