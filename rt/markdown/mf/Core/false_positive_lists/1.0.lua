-- Module with list-like patterns that should NOT be detected as markdown
help([[This module demonstrates list-like patterns in plain text.

Version ranges use dashes: 1.0 - 2.0 and compatibility 3.0-4.0.
Command options are dash-separated: -v, -h, -D for verbose, help, debug.
Numbered steps appear in prose: Step 1. Do this first, then step 2. Continue.

Bullet-like text appears: The - symbol is used for subtraction.
Dashes in ranges: version 1.0-2.0 is supported.
Options listed: Available options include -a, -b, and -c.

This content has dashes and numbers but should NOT be detected as markdown lists
because they don't follow proper markdown list syntax at line start.]])

whatis("Name: False Positive Lists Test")
whatis("Version: 1.0")
whatis("Description: Tests list-like patterns that should not trigger markdown detection")

setenv("FALSE_POSITIVE_LISTS_VERSION", "1.0")

