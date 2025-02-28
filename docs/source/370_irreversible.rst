.. _mode_select-label:

Mode Select: Irreversible Module Actions
======================================

Purpose
^^^^^^^

The mode select feature allows modulefiles to specify actions that should only be executed in specific modes (load or unload). This is particularly useful for operations that are irreversible or need special handling during module load/unload cycles.

Usage
^^^^^

Mode select is implemented through a table with a ``modeA`` field that specifies when the action should be executed::

    -- Executed only during load and unload operations
    setenv{"MY_VAR", "some_value", modeA={"load", "unload"}}

    -- Executed only during unload
    setenv{"CLEANUP_VAR", "cleanup_value", modeA={"unload"}}

Important Notes
^^^^^^^^^^^^^
1. Spider caching disregards mode-specific actions:
   * Module dependencies and conflicts are evaluated without considering mode-specific behavior
   * Users should not rely on mode-specific actions for dependency resolution

2. When using mode select, the specified action becomes irreversible in the opposite mode. For example:
   * If an action is specified with ``mode = {"load"}``, it will not be automatically reversed during unload

3. To completely remove the effects of a mode-specific module, you may need to:
   * Purge all modules (``module purge``)
   * Start a new shell session
   * Or manually reverse the changes

4. MODULEPATH modifications cannot be mode-specific:
   * Operations like ``prepend_path{"MODULEPATH", ...}`` with a ``modeA`` field will raise an error
   * This restriction helps maintain consistent module visibility across load/unload cycles
   * MODULEPATH changes should be handled through normal (non-mode-specific) operations

5. Mode-specific functions only accept these valid keys:
   * ``n`` - Number of arguments
   * ``delim`` - Delimiter for path-like operations
   * ``modeA`` - Array specifying execution modes
   * ``priority`` - Priority level for the operation
   * ``kind`` - Type of operation
   * Using any other keys will raise an error

Example Scenario
^^^^^^^^^^^^^^^

Consider a module that needs to perform special cleanup during unload::

    -- cleanup.lua
    help([[
    This module demonstrates mode-specific actions
    that require special handling during unload.
    ]])

    -- Normal reversible action
    prepend_path("PATH", "/path/to/bin")

    -- Special cleanup only during unload
    setenv{"CLEANUP_REQUIRED", "true", modeA = {"unload"}}

In this example:

* The PATH modification is reversible and handled normally during load/unload cycles.
* The CLEANUP_REQUIRED variable is only set during unload
* Loading the module again will not automatically clear CLEANUP_REQUIRED

Best Practices
^^^^^^^^^^^^^

1. Use mode select sparingly and only when necessary
2. Document any irreversible changes in the module's help text
3. Test both load and unload scenarios thoroughly
4. Consider the impact on module collections and module restore operations 
