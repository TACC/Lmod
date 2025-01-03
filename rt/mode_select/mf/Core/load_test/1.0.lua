-- Test module for mode-specific load operations

-- Test load with mode
load{"dep_load", mode={"load"}}         -- Should only load during load
load{"dep_unload", mode={"unload"}}     -- Should only load during unload
load{"dep_both", mode={"load", "unload"}} -- Should load during both operations

-- Set environment variables to track what happened
setenv("LOAD_TEST_LOADED", "yes") 