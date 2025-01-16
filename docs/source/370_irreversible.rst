.. _mode_select-label:

Mode Select: Irreversible Module Actions
======================================

Purpose
^^^^^^^

The mode select feature allows modulefiles to specify actions that should only be executed in specific modes (load or unload). This is particularly useful for operations that are irreversible or need special handling during module load/unload cycles.

Usage
^^^^^

Mode select is implemented through a table with a ``mode`` field that specifies when the action should be executed::

    -- Execute only during load
    setenv{
        name = "MY_VAR",
        value = "some_value",
        mode = "load"
    }

    -- Execute only during unload
    setenv{
        name = "CLEANUP_VAR", 
        value = "cleanup_value",
        mode = "unload"
    }

Supported Modes
^^^^^^^^^^^^^^

The following modes are supported:

* ``load`` - Execute the action only when loading the module
* ``unload`` - Execute the action only when unloading the module

Important Notes
^^^^^^^^^^^^^

1. When using mode select, the specified action becomes irreversible in the opposite mode. For example:

   * If an action is specified with ``mode = "load"``, it will not be automatically reversed during unload
   * If an action is specified with ``mode = "unload"``, it will not be automatically reversed during load

2. To completely remove the effects of a mode-specific module, you may need to:
   
   * Purge all modules (``module purge``)
   * Start a new shell session
   * Or manually reverse the changes

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
    setenv{
        name = "CLEANUP_REQUIRED",
        value = "true",
        mode = "unload"
    }

In this example:

* The PATH modification is reversible and handled normally
* The CLEANUP_REQUIRED variable is only set during unload
* Loading the module again will not automatically clear CLEANUP_REQUIRED

Best Practices
^^^^^^^^^^^^^

1. Use mode select sparingly and only when necessary
2. Document any irreversible changes in the module's help text
3. Consider providing helper functions or instructions for users to manually reverse changes
4. Test both load and unload scenarios thoroughly
5. Consider the impact on module collections and module restore operations 