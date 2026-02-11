-- Module designed to test diagnostic output when markdown detection fails
-- This module has exactly 2 list items but NO other markdown indicators
-- Score should be 2 (lists > 1 gives +2) which is below threshold of 3
-- IMPORTANT: This tests that diagnostic output appears when detection fails
-- Note: Content is kept short to avoid structure indicator (needs >5 lines, >1 empty, >2 long lines)
help([[
Short content.

Features:
- Feature one
- Feature two
]])

whatis("Name: Diagnostic Test Module")
whatis("Version: 1.0")
whatis("Description: Tests diagnostic output when markdown detection fails")

setenv("DIAGNOSTIC_TEST_VERSION", "1.0")
