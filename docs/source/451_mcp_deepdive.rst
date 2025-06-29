.. _deepdive_mcp_overview:

The Conductor: How the `mcp` (Main Control Program) Object Works
--------------------------------------------------------------------

The ``mcp`` (Main Control Program) is a central, stateful object that orchestrates Lmod's behavior in response to user commands and modulefile directives. It's an instance of the ``MainControl`` class, which is defined in ``src/MainControl.lua``.

**Creation and Operational Modes**

-   An ``mcp`` object is typically created using the factory method `MainControl.build("mode")`. The `"mode"` string passed during creation is critical as it sets the operational context for that ``mcp`` instance.
-   Lmod defines several key modes, each tailoring how ``mcp`` (and thus Lmod) behaves. These include:

    -   **`load`**: For handling ``module load``, ``module add``, etc. Modulefile commands like `setenv()` lead to environment changes being applied.
    -   **`unload`**: For handling ``module unload``, ``module rm``, etc. Modulefile commands are interpreted in reverse (e.g., `setenv()` leads to unsetting the variable).
    -   **`show` / `access`**: For ``module show/display``, ``module help``, ``module whatis``. Modulefile commands usually result in printing what they *would* do rather than executing changes.
    -   **`spider`**: Used when generating cache data for ``module spider``. Modulefile evaluation is limited to extracting metadata, not applying changes.
    -   **`checkSyntax`**: For validating a modulefile without applying changes.
    -   **`computeHash`**: Used in collection management to determine if a modulefile's effective content has changed.
    -   **`mgrLoad`**: A special mode for restoring collections, where `load(), depends_on(), etc` commands within modulefiles are ignored.
    -   **`refresh`**: For `module refresh`, re-evaluating loaded modules to redefine aliases and shell functions for sub-shells
    -   **`quiet`**: A mode where most operations are suppressed, used internally.

**Dispatching Modulefile Commands**

-   Functions made available to Lua modulefiles (defined in `src/modfuncs.lua`, e.g., the `setenv()`, `prepend_path()`, `load()` Lua functions) are the primary interface for a modulefile to interact with Lmod.
-   When a modulefile calls one of these functions (e.g., `setenv("MY_VAR", "value")`):

    1.  The function in `src/modfuncs.lua` typically performs initial argument validation.
    2.  It then invokes the corresponding method on the currently active `mcp` object (e.g., `mcp:setenv({ "MY_VAR", "value" })`).
-   The `mcp` object, knowing its current operational `mode`, dispatches this call to an appropriate underlying implementation. This dispatch is often managed by how methods are assigned in mode-specific files like ``src/MC_Load.lua``, ``src/MC_Unload.lua``, etc. These files inherit from `MainControl` and effectively define a behavior table for each mode.

    -   **Example**: If `mcp` is in `load` mode (via `MC_Load.lua`), a call to `mcp:setenv()` will internally map to `MainControl.setenv()`, which aims to set the environment variable in Lmod's internal variable table (`VarT`).
    -   If `mcp` is in `unload` mode (via `MC_Unload.lua`), a call to `mcp:setenv()` (which modulefiles still use) will internally map to `MainControl.unsetenv()`, which aims to remove the variable from `VarT`.
    -   In `show` mode, `mcp:setenv()` might map to a function that simply records or prints the `setenv` command string.

**Global `mcp` Instances**

Lmod typically initializes a few global instances of `MainControl` objects at startup (e.g., in `lmod.in.lua` or `spider.in.lua`):

-   **`mcp` (lowercase)**: This is the primary, *dynamic* ``MainControl`` instance. Its mode is set based on the user's command (e.g., `load` for `module load`, `avail` for `module avail`). Most modulefile function evaluations will go through this `mcp`.
-   **`MCP` (uppercase)**: Often initialized in a fixed "positive" mode, typically `load` (or `spider` during spidering). It provides a consistent context for operations that should always behave as if loading, regardless of the main `mcp`'s current mode.
-   **`MCPQ` (uppercase with Q)**: Typically initialized in `quiet` mode. Used for operations that need to interact with the ``MainControl`` machinery but should not produce output or have side effects.

**Orchestration and State**

Beyond dispatching, the `mcp` object plays a role in overall orchestration:

-   It provides access to contextual information (e.g., `mcp:myFileName()` allows a modulefile to know its own path).
-   It interacts with other core Lmod components. For example, when setting environment variables, `mcp` methods will retrieve the current variable table (`VarT`) from the `FrameStk` (Frame Stack) and operate on `Var` objects within it.
-   For more complex operations like the actual loading of modules (beyond just interpreting individual commands), `mcp` methods often delegate to the ``hub`` object (``src/Hub.lua``), which manages loading rules, dependencies, and conflicts.

The `mcp` object, through its mode-specific behavior and dispatch mechanism, is fundamental to Lmod's ability to correctly interpret modulefile commands in various operational contexts, from loading and unloading to displaying help and building caches.

.. _deepdive_mcp_dispatch:

**`mcp` in Action: `setenv` and `prepend_path` Dispatch**

Let's look specifically at how `mcp` handles two of the most common modulefile commands, as this illustrates its core dispatch mechanism.

.. table:: MCP Command Dispatch Matrix
   :widths: auto

   +--------------------+-------------------------------+-------------------------------------+---------------------------+
   | Modulefile Command | ``load`` Mode                 | ``unload`` Mode                     | ``show`` Mode             |
   +====================+===============================+=====================================+===========================+
   | ``setenv()``       | ``MainControl.setenv()``      | ``MainControl.unsetenv()``          | ``MC_Show.setenv()``      |
   +--------------------+-------------------------------+-------------------------------------+---------------------------+
   | ``prepend_path()`` | ``MainControl.prepend_path()``| ``MainControl.remove_path_first()`` | ``MC_Show.prepend_path()``|
   +--------------------+-------------------------------+-------------------------------------+---------------------------+
   | ``pushenv()``      | ``MainControl.pushenv()``     | ``MainControl.popenv()``            | ``MC_Show.pushenv()``     |
   +--------------------+-------------------------------+-------------------------------------+---------------------------+


When a modulefile executes `setenv("MY_VAR", "some_value")` or `prepend_path("PATH", "/new/path")`, these Lua functions (defined in `src/modfuncs.lua`) ultimately call methods on the active `mcp` object, typically `mcp:setenv{...}` or `mcp:prepend_path{...}`.

The critical factor is the current **mode** of the `mcp` instance:

1.  **During `load` mode** (e.g., `module load mymod`):
    -   `mcp:setenv{name, value, ...}`: This call is dispatched to the `MainControl.setenv()` function (as defined in `src/MainControl.lua` and mapped in `src/MC_Load.lua`).

        -   `MainControl.setenv()` retrieves the current variable table (`VarT`) from the `FrameStk` (Frame Stack).
        -   It ensures a `Var` object for `name` exists within `VarT`.
        -   It calls the `:set(value)` method on this `Var` object, which updates Lmod's internal record of what `MY_VAR` should become.

    -   `mcp:prepend_path{name, value, ...}`: This is dispatched to `MainControl.prepend_path()`.

        -   `MainControl.prepend_path()` retrieves `VarT`.
        -   It ensures a `Var` object for the path variable `name` (e.g., "PATH") exists, configured with the correct delimiter (usually ":").
        -   It calls the `:prepend(value)` method on this `Var` object to add "/new/path" to the beginning of the internal representation of "PATH".

2.  **During `unload` mode** (e.g., `module unload mymod`):

    -   Even if a modulefile contains `setenv("MY_VAR", "some_value")`, during an unload operation, the `mcp` (now in "unload" mode, likely an instance of `MC_Unload`) interprets this differently.
    -   `mcp:setenv{name, value, ...}`: This call is dispatched to `MainControl.unsetenv()` (as mapped in `src/MC_Unload.lua`).

        -   `MainControl.unsetenv()` retrieves `VarT`.
        -   It finds the `Var` object for `name`.
        -   It calls the `:unset()` method, marking the variable for removal or reversion to its previous state.

    -   `mcp:prepend_path{name, value, ...}`: This is dispatched to `MainControl.remove_path()`.

        -   `MainControl.remove_path()` retrieves `VarT`.
        -   It finds the `Var` object for the path `name`.
        -   It calls `:remove(value)` to remove "/new/path" from the internal representation of "PATH".

3.  **During other modes** (e.g., `show`, `spider`):

    -   `mcp:setenv{...}` or `mcp:prepend_path{...}` will be dispatched according to that mode's configuration (e.g., in `src/MC_Show.lua` or `src/MC_Spider.lua`).
    -   For `module show mymod`, these calls often map to functions like `MainControl.show_setenv`, which would print a string like `setenv("MY_VAR","some_value");` instead of changing `VarT`.
    -   For `module spider`, these often map to `MainControl.quiet`, meaning the command has no effect as it's not relevant to cache generation.

This mode-based dispatch, where the same modulefile command leads to different actions within `MainControl` based on `mcp`'s state, is how Lmod achieves consistent behavior across its various operations. The specific mappings for each mode are largely defined by how methods are assigned in the various `src/MC_<ModeName>.lua` files. 
