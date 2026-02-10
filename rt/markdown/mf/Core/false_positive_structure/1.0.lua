-- Module with structured text that should NOT be detected as markdown
help([[This module has well-structured content with paragraphs and formatting.

The first paragraph provides an overview of the module functionality.
It explains what the module does and why it might be useful.

The second paragraph goes into more detail about specific features.
It describes how to use the module and what to expect.

The third paragraph covers advanced usage and configuration options.
It provides examples and best practices for optimal results.

This content has multiple paragraphs, empty lines, and long sentences
but lacks markdown syntax, so it should remain plain text.]])

whatis("Name: False Positive Structure Test")
whatis("Version: 1.0")
whatis("Description: Tests structured text that should not trigger markdown detection")

setenv("FALSE_POSITIVE_STRUCTURE_VERSION", "1.0")

