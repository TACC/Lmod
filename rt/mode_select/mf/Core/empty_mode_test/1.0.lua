-- Test module for empty mode table error case
-- This should error because the mode table is empty
setenv{"TEST_EMPTY_MODE", "value", modeA={}}  -- Should error: empty mode table 
