-- Test module for invalid mode error case
-- This should error because "invalid" is not a valid mode
setenv{"TEST_INVALID_MODE", "value", mode={"invalid"}}  -- Should error: invalid mode 