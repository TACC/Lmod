-- Module with URLs and paths that should NOT be detected as markdown
help([[This module provides information about external resources.

Visit https://example.com/documentation for more details.
The project homepage is at http://www.example.org/project.
Email support at user@example.com for assistance.

File paths include /usr/local/share/data and ./config/settings.txt.
Relative paths like ../scripts/run.sh are also common.

This content has URLs and paths but no markdown link syntax, so it should remain plain text.
The URLs are just plain text, not formatted with markdown link syntax.]])

whatis("Name: False Positive URLs Test")
whatis("Version: 1.0")
whatis("Description: Tests URL patterns that should not trigger markdown detection")

setenv("FALSE_POSITIVE_URLS_VERSION", "1.0")

