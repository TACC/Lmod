Github Actions
~~~~~~~~~~~~~~

Lmod's GitHub repository uses **GitHub Actions** to automatically run tests and checks on the codebase. This process ensures that any new contributions or updates maintain the stability and quality of the project.

When code is pushed to the repository, GitHub automatically looks for workflow files in the `.github/workflows/` directory. Lmod uses two primary workflow files:

-   `docs.yml`: This workflow ensures that the project's documentation can be built without any errors.
-   `test.yml`: This workflow executes a comprehensive test suite on both Linux and macOS environments, across multiple versions of Lua.

The `test.yml` workflow downloads all necessary dependencies for Lua and the testing frameworks. Then, it runs the following test suites:

#. The **hermes** system tests, which are described in detail in :doc:`442_testing`.
#. The **busted** unit tests, which focus on verifying individual data structures and functions within Lmod.
#. The **Lmod Test Suite**, which runs tests on a full Lmod installation to validate end-to-end functionality.

The **busted** unit tests are designed to test various components in isolation. For example, tests for the `avail` command in `spec/Avail/Avail_spec.lua` cover different modes of operation:

- **Terse Mode**: Checks the output for available modules in a concise format.
- **Default Only**: Verifies the output for default modules only.
- **Search String**: Tests the output when a specific module name is searched.
- **Non-Matching Search**: Ensures correct behavior when no modules match the search string.
- **Regular Mode**: Confirms the output with detailed module information, including default indicators.