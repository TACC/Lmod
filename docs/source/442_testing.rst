.. _lmod_testing_guide:

Lmod Regression Testing Guide
=============================

Lmod utilizes a comprehensive regression testing suite to ensure its stability,
correctness across various shells, and to prevent regressions when new features
or fixes are introduced. This guide provides an overview of the testing
framework and instructions on how to run and manage these tests.

The testing framework resides in the ``rt/`` directory (short for "regression
tests") within the Lmod source code.

Overview of the Testing Framework
---------------------------------

The ``rt/`` directory contains numerous subdirectories. Each subdirectory typically
represents a specific test case or a group of related tests focusing on a
particular Lmod feature or command (e.g., ``rt/load/``, ``rt/avail/``,
``rt/purge/``).

Inside each test directory, you'll commonly find the following types of files:

*   **``*.tdesc``**: This is the test description file. It's a crucial component
    that defines the test's purpose, the sequence of Lmod commands to execute,
    the shells to test against, and other test parameters.
*   **Modulefiles (often in subdirectories like ``mf/``, ``mf2/``, etc.):** Many tests
    require their own simple modulefiles to exercise specific Lmod behaviors.
    These are usually located within the test's directory or its subdirectories.
*   **Reference Output Files:**

    *   **``err.txt``**: Contains the expected standard error output for the test.
    *   **``out.txt``**: Contains the expected standard output for the test.

*   **Helper Scripts (e.g., ``*.sh``, ``*.lua``):** Some tests might     use additional    scripts to set up specific conditions or perform complex validation steps.

The primary tool for running these tests is a shell command typically named ``t``,
which is made available by sourcing a specific testing environment script (detailed below).
When a test is run, the ``t`` command executes the steps defined in the ``.tdesc``
file. It captures the actual standard output and standard error, placing them in a
temporary execution directory (usually a subdirectory named ``t1/<test_name>``
within the test case directory). The framework then compares these actual outputs
against the reference ``std.txt`` and ``err.txt`` files.

Prerequisites and Setup
-----------------------

Before you can run the Lmod regression tests, you need to set up your environment:

1.  **Install Required Packages:**
    Ensure you have Lua and several Luarocks packages installed. On a
    Debian-based system, you can typically do this with:

    .. code-block:: bash

        sudo apt update
        sudo apt install lua5.3 liblua5.3-dev
        sudo luarocks install luaposix
        sudo luarocks install luafilesystem
        sudo luarocks install lua-term # For lua-term, ensure it matches Lmod's version if issues arise
        sudo luarocks install busted   # Busted is a Lua unit testing framework

    *Note: Adjust package names and versions based on your Lua installation and distribution.*

2.  **Set up Robert McLay's Testing Environment:**
    Lmod's testing framework relies on a set of auxiliary tools and shell functions
    provided by Robert McLay (Lmod's author).

    *   Clone the ``Hermes`` repository and add it to your ``PATH``:

        .. code-block:: bash

            git clone https://github.com/rtmclay/Hermes.git
            export PATH=/path/to/your/Hermes/bin:$PATH

    *   Clone the ``Testing_aux_tools`` repository and source the shell functions:

        .. code-block:: bash

            git clone https://github.com/rtmclay/Testing_aux_tools.git
            source /path/to/your/Testing_aux_tools/testing_tools_shell_funcs.sh

Running Tests
-------------

Once your environment is set up, you can run the tests using the ``t`` command.

1.  **Running All Tests:**
    To run the entire regression test suite:

    .. code-block:: bash

        cd /path/to/Lmod/rt  # Navigate to Lmod's rt directory
        t .

    This command will iterate through all test subdirectories in ``rt/`` and
    execute them. This can take a significant amount of time.

2.  **Running a Single Test Case:**
    To run a specific test (e.g., a test named ``my_feature_test`` located in
    ``rt/my_feature_test/``):

    .. code-block:: bash

        cd /path/to/Lmod/rt/my_feature_test
        t .

    This will execute only the tests defined in the ``my_feature_test.tdesc`` file.

Understanding and Managing Test Output
--------------------------------------

A key aspect of Lmod's operation is its use of standard output (stdout) and
standard error (stderr):

*   **Lmod's ``stdout`` is its primary "payload"**: Lmod is designed to output
    shell commands to ``stdout``. These commands are then typically evaluated
    (e.g., via ``eval "$(lmod ...)"``) by the user's shell to modify their
    current environment (setting environment variables, defining aliases, etc.).
*   **Lmod's ``stderr`` is for communication**: All informational messages, warnings,
    and error messages generated by Lmod are directed to ``stderr``.

This separation is critical for how tests are structured and evaluated:

When you run a test using ``t .``:

*   The test commands from the ``.tdesc`` file are executed.
*   A temporary directory, typically ``t1/`` (e.g., ``rt/my_feature_test/t1/my_feature_test/``),
    is created within the specific test's directory.
*   The actual standard output of the test run is saved to ``std.txt`` within this ``t1/...`` directory.
    This file captures the shell commands Lmod generated, representing the intended
    changes to the environment.
*   The actual standard error is saved to ``err.txt`` within this ``t1/...`` directory.
    This file captures all messages, warnings, or errors Lmod produced during the test.
*   The framework then compares these generated ``std.txt`` and ``err.txt`` files with
    the reference ``std.txt`` and ``err.txt`` files located in the root of the
    test directory (e.g., ``rt/my_feature_test/std.txt``).
*   If the outputs match the reference files, the test passes. Otherwise, it fails,
    and differences will be reported.

To inspect the output of a failed test:

.. code-block:: bash

    cd /path/to/Lmod/rt/my_feature_test
    cat t1/my_feature_test/out.txt  # View actual standard output
    cat t1/my_feature_test/err.txt  # View actual standard error

Compare these with ``out.txt`` and ``err.txt`` in the current directory
(``/path/to/Lmod/rt/my_feature_test/``) to understand the discrepancies.

Editing a Test
--------------

To modify a test, you'll typically edit its ``*.tdesc`` file:

.. code-block:: bash

    cd /path/to/Lmod/rt/my_feature_test
    vim my_feature_test.tdesc  # Or your preferred editor

Updating Test Baselines (Reference Files)
-----------------------------------------

If a test fails because Lmod's behavior has legitimately changed (e.g., due to a
bug fix or a new feature that alters output), and you've verified that the new
output in ``t1/.../std.txt`` and ``t1/.../err.txt`` is correct, you need to
update the reference baseline files.

To do this, from within the specific test directory (e.g., ``rt/my_feature_test/``):

.. code-block:: bash

    cp t1/my_feature_test/*.txt .

This copies the newly generated (and now correct) ``std.txt`` and ``err.txt`` from
the temporary ``t1/my_feature_test/`` directory to become the new reference files in the
current test directory.

Debugging Lmod
--------------

When troubleshooting or developing new features, you may need to inspect Lmod's
internal state or trace its execution flow. Lmod includes a built-in debugging
tool that allows you to print messages from the source code, which can be made
visible during testing.

Lmod's debugging function is ``dbg.print{}``. You can add statements like this
to the Lua source code (files in ``src/``) to output variables or trace messages:

.. code-block:: lua

    -- In some file like src/cmdfuncs.lua
    dbg.print{"My debug message: some_variable = ", some_variable, "\n"}

By default, this debug output is suppressed. To see the output when running a
regression test, you need to enable debugging for the ``lmod`` command. This is
done by adding the ``-D`` flag to the command in your test's ``.tdesc`` file.

For example, if your ``.tdesc`` file has the following command:

.. code-block:: text

    runLmod avail

You would change it to:

.. code-block:: text

    runLmod -D avail

When you re-run the test with ``t .``, the output from any ``dbg.print{}``
statements will now appear in the standard error stream, which is captured in
``t1/.../err.txt``.

For quick, temporary debugging, you can also directly edit the generated test
script at ``rt/<test_case>/t1/<test_name>/t1.script`` to add the ``-D`` flag.
This avoids modifying the baseline ``.tdesc`` file.

Additionally, setting the ``LMOD_DEBUG`` environment variable to ``1`` will also
enable debug output.

Re-testing and Advanced Scenarios
---------------------------------

*   **Retest to Pass:** After updating reference files or fixing a test script,
    re-run the test to confirm it now passes:

    .. code-block:: bash

        cd /path/to/Lmod/rt/my_feature_test
        t .

*   **Cleaning Temporary Files:** The user note ``run rm tm/*, t .`` (if in ``rt/[test]``)
    suggests that there might be other temporary files (perhaps in a ``tm/`` directory)
    that sometimes need cleaning before a re-run. The ``t`` command usually handles
    its own cleanup within the ``t1/`` structure.

*   **Re-running the Generated Script:** If you are deep inside a test's temporary
    execution directory (e.g., ``rt/my_feature_test/t1/some_specific_shell_variant/``),
    the note ``run t1.script`` suggests you might be able to directly execute the
    shell script (``t1.script``) that the ``t`` command generated for that particular
    test variant. This can be useful for debugging a specific failing case.

*   **Re-running Failed Tests:** If you've run the full test suite and some tests
    failed, you can re-run only the tests that previously failed. From the main
    ``rt/`` directory:

    .. code-block:: bash

        cd /path/to/Lmod/rt
        t -r wrong

This is a significant time-saver compared to re-running the entire suite.

This guide should provide a solid foundation for working with Lmod's regression
testing suite. Always refer to the latest scripts and any specific READMEs within
the ``rt/`` or ``Testing_aux_tools`` directories for the most up-to-date information.
