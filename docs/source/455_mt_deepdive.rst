MT: The Module Table
~~~~~~~~~~~~~~~~~~~~

The Module Table, implemented in `src/MT.lua`, is the canonical source of truth for the state of all modules within an Lmod session. It functions as a comprehensive, in-memory database that tracks every module known to Lmod, including its status, properties, load order, and dependencies. Its single most important feature is its ability to serialize its entire state into environment variables, which is the core mechanism Lmod uses to maintain a persistent environment across multiple shell commands.

The `MT` is implemented as a singleton, ensuring that there is only one instance of the module table managing the session state at any given time.

Key Responsibilities and Concepts
---------------------------------

1. State Tracking
^^^^^^^^^^^^^^^^^

The primary role of the `MT` is to track the state of every module. A module can be in one of several states:

-   **Active:** The module is currently loaded and its environment changes are applied.
-   **Inactive:** The module was loaded but has since been unloaded or superseded by another module (e.g., due to a conflict or family swap). Its environment changes are no longer in effect, but Lmod still remembers it.
-   **Pending:** A temporary state used internally during the resolution process before a module is fully loaded.

The `MT` provides functions like `MT:add()`, `MT:remove()`, and `MT:setStatus()` to manage these states as modules are loaded and unloaded. `MT:list()` provides a way to retrieve a list of modules filtered by their status.

2. Persistence through Serialization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lmod's ability to "remember" the user's environment between commands (e.g., you can run `module load gcc` and then `module list` in a separate command) is powered by the `MT`.

After every command, the `MT` serializes its entire contents—the list of all modules, their states, properties, and the current `MODULEPATH`—into a set of environment variables (e.g., `_ModuleTable_Sz_`, `_ModuleTable001_`, etc.). When a new Lmod command is executed, it first deserializes this data from the environment, reconstructing the exact state of the `MT` from the previous command. This allows for a seamless, persistent user experience.

3. Tracking Module Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `MT` is responsible for storing metadata and properties associated with each module, including:

-   **`fullName` and `userName`**: The fully resolved module name (e.g., `gcc/11.2.0`) and the name the user typed (e.g., `gcc`).
-   **`fn`**: The path to the modulefile on the filesystem.
-   **`propT`**: A table of properties assigned to the module via the `add_property()` command.
-   **Families**: Tracks modules that belong to a family (e.g., `compiler`), allowing Lmod to enforce that only one member of a family is loaded at a time.
-   **Conflicts**: Stores information about declared module conflicts.

4. `MODULEPATH` Management
^^^^^^^^^^^^^^^^^^^^^^^^^^

The `MT` tracks the current `MODULEPATH`. When a module dynamically modifies the `MODULEPATH` (e.g., via `prepend_path("MODULEPATH", ...)`), the :doc:`varT <456_vart_deepdive>` (via its underlying `Var.lua` implementation) notifies the `MT`. The `MT` then flags that its internal view of the module tree is out-of-date (`MT:set_MPATH_change_flag()`), signaling that caches may need to be rebuilt.

5. Interaction with FrameStk
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The `MT` works in concert with the :doc:`FrameStk <454_framestack_deepdive>`. When a `module load` command begins, the `FrameStk` saves a deep copy of the initial `MT` state (`origMT`). After the command completes, the final state of the `MT` is compared against this original copy by `MT:reportChanges()` to generate the user-facing messages about which modules were loaded, unloaded, or changed.

Key Takeaways
-------------

-   **Central Database:** The `MT` is Lmod's central database for all module information.
-   **State Persistence:** It uses environment variable serialization to maintain state between commands.
-   **Rich Metadata:** It stores not just the load status, but also properties, families, conflicts, and file paths.
-   **Coherent State Management:** It works with the :doc:`FrameStk <454_framestack_deepdive>` and :doc:`varT <456_vart_deepdive>` to provide a robust and consistent view of the user's environment at all times.

A deep understanding of the `MT` is essential for debugging module resolution issues or contributing to Lmod's core state management logic. 