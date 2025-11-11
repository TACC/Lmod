-- Module with markdown help that SHOULD be processed as markdown
help([[
# Markdown Module

## Description
This module demonstrates **markdown formatting** in help content.

## Features
- *Italicized* feature descriptions
- **Bold** important notes
- `inline code` examples
- Structured content with headers

## Usage
```bash
module load markdown_content/2.0
```

For more information, visit the [project website](https://example.com).

### Installation Notes
1. First step in installation
2. Second step with **important** details
3. Final configuration step
]])

whatis("Name: Markdown Module")
whatis("Version: 2.0") 
whatis("Description: Module demonstrating markdown help content")

setenv("MARKDOWN_VERSION", "2.0")

