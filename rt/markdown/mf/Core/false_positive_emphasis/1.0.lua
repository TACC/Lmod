-- Module with emphasis-like patterns that should NOT be detected as markdown
help([[This module shows text with asterisks and underscores that aren't markdown.

Asterisks appear in version strings: version 1.0 * beta release.
Multiplication uses asterisks: 2 * 3 = 6 and 10 * 5 = 50.
Wildcards use asterisks: *.lua files and file_*.txt patterns.

Underscores appear in variable names: MODULE_NAME, FILE_PATH, USER_HOME.
File names use underscores: my_file.txt, test_data.csv, config_file.lua.
Function names: load_module(), get_version(), set_path().

This content has asterisks and underscores but they're not markdown emphasis
because they don't follow proper markdown emphasis syntax patterns.]])

whatis("Name: False Positive Emphasis Test")
whatis("Version: 1.0")
whatis("Description: Tests emphasis-like patterns that should not trigger markdown detection")

setenv("FALSE_POSITIVE_EMPHASIS_VERSION", "1.0")

