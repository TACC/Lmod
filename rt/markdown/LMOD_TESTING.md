# Lmod Testing System Reference Guide

## Overview

The Lmod testing system is a comprehensive regression testing framework that validates Lmod functionality through automated test execution, output comparison, and result validation. This guide provides essential information for developers and LLMs working with the Lmod test suite.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Test Directory Structure](#test-directory-structure)
3. [Test Definition Files](#test-definition-files)
4. [Test Execution](#test-execution)
5. [Output Processing](#output-processing)
6. [Golden File Management](#golden-file-management)
7. [Common Commands](#common-commands)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

## System Architecture

### Core Components

- **Testing Infrastructure**: Located in `~/Lmod/testing.sh` and `~/Lmod/Testing_aux_tools/`
- **Test Definitions**: Lua-based `.tdesc` files in `rt/` subdirectories
- **Test Execution**: Generated shell scripts (`t1.script`) with numbered steps
- **Output Processing**: Automated sanitization and comparison against golden files
- **Result Validation**: CSV-based result tracking and pass/fail determination

### Environment Setup

To use the testing system, source the testing environment:

```bash
source ~/Lmod/testing.sh
```

This provides essential commands:
- `t .` - Run test in current directory
- `rs` - Run script (alias for `run_script`)
- `td` - Test description command
- `up N` - Navigate up N directories

## Test Directory Structure

Each test is organized in a feature-specific subdirectory under `rt/`:

```
rt/
├── test_name/
│   ├── test_name.tdesc          # Test definition file
│   ├── mf/                      # Module files for testing
│   │   ├── Core/
│   │   │   ├── module1/
│   │   │   │   └── 1.0.lua
│   │   │   └── module2/
│   │   │       └── 2.0.lua
│   │   └── ...
│   ├── out.txt                  # Golden stdout reference
│   ├── err.txt                  # Golden stderr reference
│   └── t1/                      # Test output directory
│       └── YYYY_MM_DD_HH_MM_SS-OS-arch-test_name/
│           ├── t1.script        # Generated execution script
│           ├── _stdout.001      # Individual step stdout
│           ├── _stderr.001      # Individual step stderr
│           ├── out.txt          # Processed stdout output
│           ├── err.txt          # Processed stderr output
│           ├── results.csv      # Test results summary
│           └── t1.result        # Final test result
```

### Key Directories

- **`mf/`**: Contains module files (`.lua`) required for the test
- **`t1/`**: Test output directory with timestamped subdirectories
- **Root level**: Contains golden reference files (`out.txt`, `err.txt`)

## Test Definition Files

Test definitions are written in Lua using the `.tdesc` format:

```lua
-- -*- lua -*-
local testName = "example_test"

testdescript = {
   owner   = "rtm",
   product = "modules",
   description = [[
     Test description here
   ]],
   keywords = {testName},

   active = 1,
   testName = testName,
   job_submit_method = "INTERACTIVE",

   runScript = [[
     . $(projectDir)/rt/common_funcs.sh

     unsetMT
     initStdEnvVars
     MODULEPATH_ROOT=$(testDir)/mf; export MODULEPATH_ROOT
     MODULEPATH=$MODULEPATH_ROOT/Core; export MODULEPATH

     runLmod --version              # 1
     runLmod load module1           # 2
     runLmod list                   # 3

     HOME=$ORIG_HOME
     cat _stdout.[0-9][0-9][0-9] > _stdout.orig
     joinBase64Results -bash _stdout.orig _stdout.new
     cleanUp _stdout.new out.txt

     cat _stderr.[0-9][0-9][0-9] > _stderr.orig
     cleanUp _stderr.orig err.txt

     rm -f results.csv
     wrapperDiff --csv results.csv $(testDir)/out.txt out.txt
     wrapperDiff --csv results.csv $(testDir)/err.txt err.txt
     testFinish -r $(resultFn) -t $(runtimeFn) results.csv
   ]],

   blessScript = [[
     # perform what is needed
   ]],

   tests = {
      { id='t1'},
   },
}
```

### Essential Elements

- **`runScript`**: Main test execution logic
- **`blessScript`**: Optional script for test maintenance
- **`tests`**: Test configuration (typically `{ id='t1' }`)

### Common Functions

- **`runLmod`**: Execute Lmod commands with output capture
- **`unsetMT`**: Clear module table state
- **`initStdEnvVars`**: Initialize standard environment variables
- **`cleanUp`**: Sanitize output for comparison
- **`wrapperDiff`**: Compare outputs and generate results
- **`testFinish`**: Finalize test execution

## Test Execution

### Running Tests

1. **Navigate to test directory**:
   ```bash
   cd rt/test_name/
   ```

2. **Run test**:
   ```bash
   t .
   ```

3. **View results**:
   ```bash
   cat t1/*/results.csv
   ```

### Generated Script

The `t .` command generates `t1.script` containing:
- Environment variable setup
- Test execution steps
- Output processing
- Result validation

### Debug Mode

Add `-D` flag to Lmod commands for debug output:
```bash
runLmod -D load module_name
```

## Output Processing

### Output Files

Each test step generates four files:
- **`_stdout.NNN`**: Command stdout (environment modifications)
- **`_stderr.NNN`**: Command stderr (user interface output)

### Processing Pipeline

1. **Capture**: Commands executed with output redirection
2. **Concatenate**: Individual files combined into `_stdout.orig` and `_stderr.orig`
3. **Sanitize**: Paths, timestamps, and system-specific data normalized
4. **Compare**: Processed output compared against golden files
5. **Validate**: Results recorded in `results.csv`

### Sanitization

The `cleanUp` function normalizes:
- File paths (`ProjectDIR`, `OutputDIR`)
- Timestamps (`YYYY-MM-DDTHH:mm`)
- System-specific paths
- Git commit hashes
- User-specific data

## Golden File Management

### Golden Files

- **`out.txt`**: Expected stdout output (environment modifications)
- **`err.txt`**: Expected stderr output (user interface messages)

### Updating Golden Files

**CRITICAL**: Never edit golden files directly. Instead:

1. **Run test and verify correctness**:
   ```bash
   t .
   ```

2. **Copy from test output**:
   ```bash
   cp t1/*/out.txt out.txt
   cp t1/*/err.txt err.txt
   ```

3. **Commit changes**:
   ```bash
   git add out.txt err.txt
   git commit -m "Update golden files for test_name"
   ```

### Validation Process

Tests pass when:
- `out.txt` matches processed stdout output
- `err.txt` matches processed stderr output
- No unexpected differences found

## Common Commands

### Test Execution
```bash
# Run test in current directory
t .

# Run script directly
rs

# Navigate to test directory
cd rt/test_name/
```

### Output Analysis
```bash
# View test results
cat t1/*/results.csv

# Compare outputs manually
diff out.txt t1/*/out.txt

# View individual step output
cat t1/*/_stdout.001
cat t1/*/_stderr.001
```

### Debugging
```bash
# Run with debug output
runLmod -D load module_name

# View generated script
cat t1/*/t1.script

# Check test log
cat t1/*/t1.log
```

## Best Practices

### Writing Tests

1. **Use descriptive step comments**:
   ```bash
   runLmod load module_name    # 1 - Load initial module
   runLmod list                # 2 - Verify module loaded
   ```

2. **Test edge cases**:
   - Error conditions
   - Boundary values
   - Invalid inputs

3. **Keep tests focused**:
   - One feature per test
   - Clear test objectives
   - Minimal dependencies

### Module File Organization

1. **Logical structure**:
   ```
   mf/
   ├── Core/           # Core modules
   ├── Beta/           # Beta modules
   └── Special/        # Special test cases
   ```

2. **Consistent naming**:
   - Use descriptive module names
   - Follow version numbering conventions
   - Include test-specific modules

### Output Management

1. **Verify before updating**:
   - Run tests multiple times
   - Check for flaky behavior
   - Validate expected changes

2. **Document changes**:
   - Explain why golden files changed
   - Reference related issues/PRs
   - Include test case descriptions

## Troubleshooting

### Common Issues

1. **Test failures**:
   - Check `results.csv` for specific differences
   - Verify module files exist and are valid
   - Ensure environment setup is correct

2. **Golden file mismatches**:
   - Review sanitization process
   - Check for system-specific paths
   - Verify timestamp handling

3. **Script generation errors**:
   - Validate `.tdesc` syntax
   - Check function availability
   - Verify environment variables

### Debug Techniques

1. **Manual execution**:
   ```bash
   # Run individual steps
   bash t1/*/t1.script
   ```

2. **Output inspection**:
   ```bash
   # View raw output
   cat t1/*/_stdout.orig
   cat t1/*/_stderr.orig
   ```

3. **Environment debugging**:
   ```bash
   # Check environment setup
   env | grep MODULE
   ```

### Getting Help

1. **Check existing tests** for similar patterns
2. **Review `common_funcs.sh`** for available functions
3. **Examine test output** for error messages
4. **Consult Lmod documentation** for command syntax

## Supplemental Quick Reference

### Setup and Installation

```bash
# Install required packages
sudo apt install lua5.3 liblua5.3-dev
sudo luarocks install luaposix
sudo luarocks install luafilesystem
sudo luarocks install lua-term
sudo luarocks install busted

# Clone and setup testing environment
git clone https://github.com/rtmclay/Hermes.git
export PATH=/home1/06280/mcawood/lmod/Hermes/bin:$PATH
git clone https://github.com/rtmclay/Testing_aux_tools.git
source ./Testing_aux_tools/testing_tools_shell_funcs.sh
```

### Quick Test Commands

```bash
# Run all tests
cd Lmod/rt
t .

# Run single test
cd Lmod/rt/[test]
t .

# Edit test definition
vim [test].tdesc

# Check test output
cat t1/[test]/err.txt
cat t1/[test]/out.txt

# Update test reference files
cp t1/[test]/*.txt .

# Retest to verify pass
t .
```

### Advanced Commands

```bash
# Run script directly (rs command)
# If in rt/[test] directory:
rm -rf t1/*; t .

# If in rt/[test]/t1/[timestamp] directory:
bash t1.script

# Rerun only failed tests (from rt directory)
t -r wrong
```

### Workflow Summary

1. **Setup**: Install dependencies and clone testing tools
2. **Run**: Execute tests with `t .`
3. **Edit**: Modify `.tdesc` files as needed
4. **Check**: Review output files for correctness
5. **Update**: Copy new reference files if changes are correct
6. **Verify**: Re-run tests to ensure they pass

## Conclusion

The Lmod testing system provides a robust framework for validating module functionality. By following these guidelines and best practices, developers can effectively create, maintain, and debug tests while ensuring the reliability of the Lmod codebase.

Remember: Always verify test correctness before updating golden files, and use the debugging tools available to troubleshoot issues systematically.
