-- Module with borderline content that might be detected as markdown
help([[
Mixed Content Module
===================

This module has some structure that might trigger markdown detection.

Some text with * characters for * emphasis * but not proper markdown.
Also has some_underscores_in_text that aren't intended as formatting.

Features:
- Item one (this is a list)
- Item two with details
- Item three

But also has regular paragraphs without special formatting.
This tests the boundary between markdown and plain text detection.
]])

whatis("Name: Mixed Content Module")
whatis("Version: 1.5")
whatis([[Description: Module with content that tests markdown detection boundaries.
It has some structured elements but also plain text portions.]])

setenv("MIXED_VERSION", "1.5")

