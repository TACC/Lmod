# Markdown Test Coverage Analysis

## Current Coverage

### ✅ Covered
1. **Plain text** - Basic non-markdown content
2. **Markdown content** - Full markdown with headers, lists, emphasis, code, links
3. **Mixed content** - Borderline case with some markdown-like patterns
4. **Short content** - Content below 30 character threshold
5. **Color support** - With/without LMOD_COLORIZE

### ❌ Critical Gaps (False Positive Prevention)

Since markdown detection is **enabled by default**, we must prevent false positives at all costs. The following scenarios need testing:

## False Positive Scenarios to Test

### 1. Code/Technical Content (High Risk)
- **C includes**: `#include <stdio.h>` - hash at start but not header
- **C preprocessor**: `#define`, `#ifdef`, `#pragma` - hash patterns
- **Shell scripts**: `#!/bin/bash` - shebang lines
- **Comments**: `# This is a comment` - hash but not markdown header
- **Version numbers**: `1.2.3`, `v2.0.1` - numbers with dots
- **Ranges**: `1.0-2.0`, `version 1.0 * beta` - dashes/asterisks
- **File paths**: `/usr/bin/program`, `./script.sh` - paths with slashes
- **Command options**: `--help`, `-v`, `-D` - dashes that aren't lists

### 2. Variable/Environment Content (High Risk)
- **Environment variables**: `PATH=/usr/bin`, `MODULE_VERSION=1.0` - equals signs
- **Variable names**: `MODULE_VERSION`, `LUA_PATH` - underscores
- **Variable references**: `${VAR}`, `$VAR` - dollar signs
- **Assignment**: `export VAR=value` - equals signs

### 3. URL/Path Content (Medium Risk)
- **URLs without markdown**: `Visit https://example.com for more info`
- **Email addresses**: `Contact: user@example.com`
- **File paths**: `See /usr/local/bin/program`
- **Relative paths**: `./scripts/install.sh`

### 4. List-like Patterns (Medium Risk)
- **Version ranges**: `1.0 - 2.0` - dash but not list
- **Options**: `Options: -v, -h, -D` - dash-separated but not list
- **Numbered items without markdown**: `Step 1. Do this` (not at start)
- **Bullet points in prose**: `The - symbol is used...`

### 5. Emphasis-like Patterns (Low-Medium Risk)
- **Asterisks in text**: `version 1.0 * beta release` - single asterisk
- **Underscores in names**: `MODULE_NAME`, `file_name.txt`
- **Multiplication**: `2 * 3 = 6` - asterisk for math
- **Wildcards**: `*.lua`, `file_*.txt` - asterisks/underscores

### 6. Code-like Patterns (Low-Medium Risk)
- **Backticks in prose**: `Use the 'module' command` - single quotes
- **Code mentions**: `See the load() function` - parentheses
- **File extensions**: `.lua`, `.so`, `.a` - dots

### 7. Structure-like Patterns (Low Risk)
- **Multi-line content**: Long paragraphs that might trigger structure detection
- **Empty lines**: Content with blank lines but not markdown structure
- **Long lines**: Single very long line (>60 chars) but not structured

### 8. Edge Cases
- **Exactly 30 characters**: At threshold boundary
- **29 characters**: Just below threshold
- **31 characters**: Just above threshold
- **Empty content**: Empty help/whatis
- **Whitespace only**: Only spaces/tabs/newlines
- **Special characters**: Unicode, non-ASCII
- **Multi-line whatis**: Whatis entries with newlines

### 9. Real-world Module Examples
- **Compiler modules**: Often have version numbers, paths, options
- **Library modules**: Often have URLs, version info
- **Tool modules**: Often have command examples, options
- **Environment modules**: Often have variable assignments

## Test Modules Needed

1. **false_positive_code** - C includes, preprocessor, shebangs
2. **false_positive_vars** - Environment variables, assignments
3. **false_positive_urls** - URLs without markdown links
4. **false_positive_lists** - List-like patterns that aren't lists
5. **false_positive_emphasis** - Asterisks/underscores that aren't emphasis
6. **false_positive_structure** - Structured text that isn't markdown
7. **false_positive_edge** - Edge cases (30 chars, empty, whitespace)
8. **false_positive_realworld** - Real-world module examples

## Detection Threshold Analysis

Current threshold: **score >= 3**

**Strong indicators (+3 each):**
- ATX headers (`# Header`)
- Setext headers (`===`)
- Code blocks (` ``` `)

**Medium indicators (+2 each):**
- Links (`[text](url)`)
- Images (`![alt](url)`)
- Multiple lists (`- item`)

**Weak indicators (+1 each):**
- Emphasis (`**bold**`, `*italic*`)
- Structure (paragraphs, long lines)

**To trigger false positive, need:**
- 1 strong indicator (score = 3), OR
- 2 medium indicators (score = 4), OR
- 1 medium + 1 weak (score = 3), OR
- 3 weak indicators (score = 3)

**Critical test cases:**
- Content with 1-2 weak indicators should NOT trigger (score < 3)
- Content with patterns that look like markdown but aren't should NOT trigger

## Test Strategy

1. **Create comprehensive false positive tests** - Ensure common patterns don't trigger
2. **Test threshold boundaries** - Verify 30 char limit works
3. **Test score boundaries** - Verify score < 3 doesn't trigger
4. **Test real-world examples** - Use actual module content patterns
5. **Test all markdown features** - Ensure true positives work correctly
6. **Test image support** - New feature needs coverage

