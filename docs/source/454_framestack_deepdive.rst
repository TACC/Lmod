FrameStk: The Engine of Reversible State
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The FrameStack, implemented in `src/FrameStk.lua`, is a critical component at the heart of Lmod's module evaluation process. It provides the foundational mechanism that allows module loading to be a sequential, stateful, and reversible process. Understanding the FrameStack is key to understanding how Lmod robustly manages environment changes across complex dependency chains.

The Core Problem: Stateful, Sequential Loading
---------------------------------------------

Consider a typical command: `module load A B C`. Lmod processes this by loading each module in sequence: first `A`, then `B`, and finally `C`. This sequential approach creates a challenge:

-   **Statefulness:** Module `B` may depend on environment variables set by module `A`. For example, `A` might define `A_ROOT`, and `B`'s modulefile might then use `prepend_path("PATH", "$A_ROOT/bin")`.
-   **Isolation and Reversibility:** If module `B` fails to load or contains a command that should halt the process (like `break()`), its partial changes to the environment should not affect the final state. The environment should effectively "roll back" to the state it was in after `A` was successfully loaded.

The FrameStack is Lmod's solution to this challenge. It is a stack data structure where each frame contains a snapshot of the environment's state, specifically the **Module Table (MT)** and the **Variable Table (varT)**.

These two tables are the core of Lmod's state management:
-  The :doc:`Module Table (MT) <455_mt_deepdive>` tracks the state of all loaded modules.
-  The :doc:`Variable Table (varT) <456_vart_deepdive>` tracks all modifications to environment variables.

How the FrameStack Works: The Push-Pop-Break Cycle
--------------------------------------------------

The lifecycle of the FrameStack is managed primarily by `src/Hub.lua` as it orchestrates module operations.

1. `FrameStk:push()` - Entering a Module
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before Lmod evaluates any modulefile, it performs a `push` operation on the FrameStack.

-   **Action:** `frameStk:push(mname)`
-   **What it does:** It creates a deep copy of the current `mt` and `varT` from the top of the stack and pushes a new frame, associated with the new module (`mname`), onto the stack.
-   **Effect:** This effectively creates a temporary, isolated sandbox for the incoming module. Any changes it makes to the environment will be contained within this new top-level frame.

2. `FrameStk:pop()` - Committing a Successful Load
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After a module is evaluated successfully, a `pop` operation occurs.

-   **Action:** `frameStk:pop()`
-   **What it does:** This is the "commit" step. The `pop` operation takes the `mt` and `varT` from the current top frame (the module that just finished) and copies them down to the frame below it. It then removes the top frame.
-   **Effect:** This merges the changes from the completed module into its parent's state. In the `module load A B C` example, when `B` successfully loads and is popped, its modifications to the environment become the new "current" state for when `C` is loaded.

3. `FrameStk:LmodBreak()` - Reverting a Failed or Broken Load
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a modulefile executes the `break()` command or encounters a critical error, the `LmodBreak` function is called.

-   **Action:** `frameStk:LmodBreak()`
-   **What it does:** This is the "rollback" step. Instead of committing changes, it does the opposite of a `pop`. It discards the `mt` and `varT` of the current (failed) top frame and instead replaces them with a deep copy of the `mt` and `varT` from the parent frame beneath it.
-   **Effect:** This completely reverts any environment modifications made by the current module, restoring the state to exactly what it was before the module began its evaluation. This ensures that a failed module load does not pollute the environment for subsequent operations.

Key Takeaways
-------------

-   **The Stack is State:** The FrameStack is the definitive record of the environment at each step of a complex `module` command.
-   **`push` Creates a Sandbox:** Every module evaluation happens in an isolated frame.
-   **`pop` Commits Changes:** It merges a module's successful changes into the parent environment.
-   **`LmodBreak` Reverts Changes:** It provides the critical rollback mechanism that makes Lmod's environment management safe and robust.

By using this push-pop-break mechanism, the FrameStack gives Lmod the ability to handle nested dependencies and complex user commands with predictable and reversible behavior, preventing the "environment pollution" that can occur in simpler systems. 