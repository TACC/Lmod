Github Actions
~~~~~~~~~~~~~~

The github website where Lmod has its repository supports actions.
This is a hook to run tests to verify the soundness of any updates.

When checking in github checks to see if there is a .github/workflows
directory with \*.yml files. If they exists then github runs them
during the check-in process.

Lmod has two \*.yml files: docs.yml and test.yml file.  The docs.yml
file checks to see if the documentation can be built without errors.
The test.yml runs three sets of tests for both Linux and MacOS with
several versions of Lua.

The .yml file downloads all the dependencies for lua and the Hermes testing
harness.  Then each of the following tests are run.

#. The **hermes** tm tests as describe ???
#. The lua based **busted** unit tests
#. The **Lmod_test_suite**.  These tests are run with Lmod installed. The tm tests are run directly from the source tree.


The **hermes** system tests have been previously described in ???

The **busted** unit tests exist to test various data structures in Lmod separately. For example, the Avail test in `spec/Avail/Avail_spec.lua` verifies the `Avail` command in different modes:

- **Terse Mode**: Checks the output for available modules in a concise format.
- **Default Only**: Verifies the output for default modules only.
- **Search String**: Tests the output when a specific module name is searched.
- **Non-Matching Search**: Ensures correct behavior when no modules match the search string.
- **Regular Mode**: Confirms the output with detailed module information, including default indicators.