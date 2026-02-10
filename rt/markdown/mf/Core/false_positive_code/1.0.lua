-- Module with code-like patterns that should NOT be detected as markdown
help([[This module demonstrates code-like patterns that should remain plain text.

The module uses C preprocessor directives like #include <stdio.h> and #define MAX_SIZE 1024.
It also includes shell script shebangs like #!/bin/bash and version numbers like 1.2.3.

File paths are common: /usr/local/bin/program and ./scripts/install.sh.
Command line options use dashes: --help, -v, -D for debugging.

Version ranges appear as 1.0-2.0 and multiplication uses asterisks like 2 * 3 = 6.
Wildcards use asterisks: *.lua files and file_*.txt patterns.

This content has structure but should NOT be processed as markdown.]])

whatis("Name: False Positive Code Test")
whatis("Version: 1.0")
whatis("Description: Tests code-like patterns that should not trigger markdown detection")

setenv("FALSE_POSITIVE_CODE_VERSION", "1.0")

