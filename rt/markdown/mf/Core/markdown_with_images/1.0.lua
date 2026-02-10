-- Module with markdown including images (SHOULD be processed as markdown)
help([[
# Module with Images

## Overview
This module demonstrates markdown with image support.

## Screenshots
![Module Architecture](https://example.com/arch.png)
![Logo](logo.png)
![Screenshot](screenshots/main.png)

## Features
- Feature one with **bold** text
- Feature two with *italic* text
- Feature three with `code` examples

For more information, visit the [project website](https://example.com).
]])

whatis("Name: Markdown with Images Test")
whatis("Version: 1.0")
whatis("Description: Tests markdown content with images")

setenv("MARKDOWN_WITH_IMAGES_VERSION", "1.0")

