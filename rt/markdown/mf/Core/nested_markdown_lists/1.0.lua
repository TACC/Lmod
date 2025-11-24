-- Module with nested markdown formatting in list items (SHOULD be processed correctly)
help([[
# Nested Markdown in Lists

## Overview
This module tests that nested markdown formatting (bold, italic, code) within list items is correctly processed and rendered.

## Unordered Lists with Nested Formatting

- Feature with **bold** text
- Feature with *italic* text  
- Feature with `code` examples
- Feature with **bold** and *italic* together
- Feature with `code` and **bold** text
- Feature with a [link](https://example.com) inside

## Ordered Lists with Nested Formatting

1. First item with **bold** emphasis
2. Second item with *italic* emphasis
3. Third item with `code` formatting
4. Fourth item combining **bold**, *italic*, and `code`
5. Fifth item with a [link](https://example.com) and **bold** text

## Mixed Nested Formatting

- Regular text without formatting
- Text with **bold** only
- Text with *italic* only
- Text with `code` only
- Text with **bold** and *italic* combined
- Text with all three: **bold**, *italic*, and `code`
- Text with [links](https://example.com) and **bold** formatting

## Expected Behavior

All nested formatting should be rendered correctly:
- **Bold** text should appear bold
- *Italic* text should appear italic
- `Code` should appear with code formatting
- [Links](https://example.com) should be formatted as links

If you see raw markdown syntax (like `**bold**` or `*italic*`) in the output, the nested formatting is not being processed correctly.
]])

whatis("Name: Nested Markdown Lists Test")
whatis("Version: 1.0")
whatis("Description: Tests nested markdown formatting within list items")

setenv("NESTED_MARKDOWN_LISTS_VERSION", "1.0")

