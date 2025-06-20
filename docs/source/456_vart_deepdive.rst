varT: The Variable Table
~~~~~~~~~~~~~~~~~~~~~~~~

The Variable Table, commonly referred to as `varT`, is the component within Lmod responsible for managing all environment variable modifications. While the Module Table (`MT`) tracks the state of modules, the `varT` tracks the state of the environment itself. It is a table where each key is the name of an environment variable (e.g., `PATH`), and each value is a `Var` object, defined in `src/Var.lua`, that intelligently manages the variable's state.

Like the `MT`, the `varT` is a core part of the state that is snapshotted by the :doc:`FrameStk <454_framestack_deepdive>` during module evaluation, providing the same crucial benefits of isolation, statefulness, and reversibility for environment variables.

The `Var` Object: An Intelligent Wrapper
----------------------------------------

Instead of manipulating environment variable strings directly, Lmod uses the `Var` object as a sophisticated wrapper. This object provides the logic to correctly handle the different kinds of environment variables.

Path-Like Variables
^^^^^^^^^^^^^^^^^^^

For variables like `PATH`, `LD_LIBRARY_PATH`, or `MANPATH`, the `Var` object treats the value as a delimited list of paths. It provides methods to manipulate this list correctly:

-   **`Var:prepend(value, nodups, priority)`**: Adds a new path to the beginning of the list. It can handle de-duplication policies (`nodups`) and assign a `priority` to the path, which influences its position relative to other priority-aware paths.
-   **`Var:append(value, nodups, priority)`**: Adds a new path to the end of the list.
-   **`Var:remove(value, where, priority)`**: Removes a path from the list. The `where` parameter can specify removing the `"first"`, `"last"`, or `"all"` occurrences.
-   **`Var:expand()`**: Reconstructs the final, correctly delimited string from its internal representation of the path list, ready to be exported to the shell environment.

This abstraction is powerful because it frees the modulefile author from worrying about path separators or complex de-duplication logic.

Scalar Variables
^^^^^^^^^^^^^^^^

For simple key-value variables, the `Var` object provides straightforward methods:

-   **`Var:set(value)`**: Sets the variable to a specific string value.
-   **`Var:unset()`**: Unsets the variable.

Other Variable Types
^^^^^^^^^^^^^^^^^^^^

The `Var` object also handles other special types of shell modifications, such as aliases (`setAlias`/`unsetAlias`) and shell functions (`setShellFunction`/`unsetShellFunction`), treating them as distinct types of variables to be managed.

How `varT` is Used in the Lmod Lifecycle
----------------------------------------

The `varT` is managed almost exclusively through the :doc:`FrameStk <454_framestack_deepdive>`. The standard lifecycle within `src/MainControl.lua` for any command that modifies the environment (like `setenv`, `prepend_path`, etc.) is as follows:

1.  **Get the Current State:** The first step is always to retrieve the current `varT` from the top frame of the `FrameStk`:
    `local varT = frameStk:varT()`

2.  **Find or Create the `Var` Object:** Lmod then looks up the `Var` object for the specified variable name. If one doesn't exist (i.e., this is the first time the variable is being modified in the session), it creates a new one:
    `if (varT[name] == nil) then varT[name] = Var:new(name) end`

3.  **Apply the Modification:** Lmod then calls the appropriate method on the `Var` object, passing in the arguments from the modulefile command:
    `varT[name]:prepend(value, nodups, priority)`

4.  **Automatic State Capture:** Because this modification was made to the `varT` instance held by the current frame on the `FrameStk`, the change is automatically captured. It will be committed to the parent frame upon a successful `pop` or discarded upon a `LmodBreak`, just like the `MT` state.

When Lmod needs to generate the final shell script to be `eval`'d, it iterates through the final `varT`, calls the `expand()` method on each `Var` object, and generates the necessary `export` or `unset` commands.

Key Takeaways
-------------

-   **Abstraction for Variables:** `varT` is a table of `Var` objects, which provide an intelligent layer of abstraction over raw environment variables.
-   **Handles Complexity:** The `Var` object contains all the necessary logic for handling path manipulation, de-duplication, and priorities.
-   **Integrated with `FrameStk`:** `varT` is a core piece of the state managed by `FrameStk`, ensuring that all environment changes are atomic and reversible.
-   **The "How" of Environment Changes:** If the :doc:`MT <455_mt_deepdive>` tracks *what* modules are loaded, the `varT` tracks *how* those modules have changed the shell environment. 