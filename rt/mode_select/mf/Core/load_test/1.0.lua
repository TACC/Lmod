-- Test module for mode-specific load operations

-- Test load with mode
load{"dep_load", modeA={"load"}}         -- Should only load during load
load{"dep_unload", modeA={"unload"}}     -- Should only load during unload
load{"dep_both", modeA={"load", "unload"}} -- Should load during both operations

-- Set environment variables to track what happened
setenv("LOAD_TEST_LOADED", "yes") 
