.. _deepdive_sandbox:

Lmod Sandbox Deep Dive
========================

This document provides a detailed look into the Lmod sandbox mechanism. It assumes you have already read the :ref:`lmod_detailed_architecture` document, which introduces the sandbox's role in the broader Lmod ecosystem. Here, we will explore its design, how it creates a controlled execution environment, and the specifics of its implementation.

The primary goal of the sandbox is to ensure that modulefiles can be evaluated safely and consistently, without risk to the stability of Lmod or the security of the user's system. It achieves this by strictly controlling the functions and data a modulefile can access.

The Sandbox Environment (`sandbox_env`)
---------------------------------------

At the heart of the sandbox is a Lua "environment," a special table that dictates what global variables and functions are available to a piece of code. Lmod constructs a custom environment, known as ``sandbox_env``, which serves as a carefully curated "allowlist." This environment is built by combining a limited, safe subset of standard Lua functions with the Lmod-specific modulefile API.

The key files involved in this process are:

*   ``src/sandbox.lua``: Contains the core logic for creating and running the sandbox.
*   ``src/modfuncs.lua``: Defines the API functions available to modulefiles (e.g., ``setenv``, ``prepend_path``, ``load``).

Permitted Lua Functions
^^^^^^^^^^^^^^^^^^^^^^^

Only a small, "safe" subset of Lua's standard libraries are exposed to modulefiles. Functions that could perform insecure or system-altering operations are deliberately excluded.

**Included Functions and Libraries:**
*   **Basic Utilities:** ``assert``, ``ipairs``, ``pairs``, ``pcall``, ``print``, ``tostring``, ``type``, ``unpack``
*   **String Manipulation:** The entire ``string`` library (e.g., ``string.format``, ``string.match``, ``string.sub``). This is considered safe and is highly useful for modulefile authors.
*   **Table Manipulation:** The ``table`` library (e.g., ``table.concat``, ``table.insert``, ``table.sort``).
*   **Mathematical Functions:** The ``math`` library.

**Excluded Functions and Libraries:**
The following are explicitly **not** included in the sandbox, as they could be used to compromise security or system stability:
*   ``io`` library: To prevent arbitrary file reading/writing from within a modulefile.
*   ``os`` library: Functions like ``os.execute()``, ``os.rename()``, and ``os.remove()`` are forbidden to prevent modulefiles from executing arbitrary shell commands or modifying the filesystem. (Note: Lmod provides its own safe ``execute()`` function with controlled behavior).
*   ``dofile``, ``loadfile``: Blocked to prevent a modulefile from executing other, potentially untrusted scripts.
*   ``require``: Modulefiles cannot load arbitrary Lua modules.

The Lmod Modulefile API
^^^^^^^^^^^^^^^^^^^^^^^

The second part of the ``sandbox_env`` is the set of functions defined in ``src/modfuncs.lua``. These functions form the public API for modulefiles. When a modulefile calls ``prepend_path("PATH", "/some/dir")``, it is invoking the ``prepend_path`` function from ``modfuncs.lua``, which has been exposed in its environment. These functions are designed to safely interact with Lmod's internal state, primarily by queuing changes in the ``mcp`` (Main Control Program) object.

The Sandbox Executor (`sandbox_run`)
------------------------------------

Once the ``sandbox_env`` is constructed, Lmod needs to execute the modulefile's code within it. This is the job of the ``sandbox_run()`` function in ``src/sandbox.lua``.

The process generally follows these steps:

1.  **Code Compilation:** The modulefile content (as a string) is compiled into Lua bytecode using Lua's built-in ``load()`` function. This function also associates the code chunk with the specified environment (our ``sandbox_env``). This critical step ensures that when the compiled code runs, it resolves any global variable lookups against the ``sandbox_env`` table, not the actual global environment of the Lmod program.
2.  **Protected Execution:** The compiled code is executed inside a "protected call" using ``pcall()``. This is a vital safety feature. If any error occurs during the modulefile's execution—whether a syntax error or a runtime error—``pcall()`` catches it and prevents it from crashing Lmod.
3.  **Error Handling:** ``pcall()`` returns a status (success or failure) and a return value (or an error message). Lmod checks this status. If the execution failed, Lmod captures the error message and reports it to the user in a structured way, often including the name of the modulefile where the error occurred.

Handling Different File Types
-----------------------------

Lmod's sandbox is designed for Lua, but it can handle different types of files through pre-processing.

TCL Modulefiles
^^^^^^^^^^^^^^^

Lmod does **not** have a separate sandbox for TCL. Instead, when ``loadModuleFile()`` detects a TCL modulefile (by its lack of a ``.lua`` extension), it first passes the file to a translator script, ``tcl2lua.tcl``. This script reads the TCL ``modulecmd`` syntax (e.g., ``prepend-path``) and converts it into an equivalent Lua script string. This resulting Lua code is then executed in the standard Lua sandbox described above.

``.modulerc`` Files
^^^^^^^^^^^^^^^^^^^

Configuration files like ``.modulerc`` are also evaluated in a sandbox, but a more restrictive one. The process, handled by ``mrc_sandbox_run()``, uses a much smaller allowlist of functions. This is because ``.modulerc`` files are intended for simple configuration (like setting a default version) and should not perform complex operations like loading other modules or modifying arbitrary environment variables.

This deep dive should provide a solid foundation for understanding the design and implementation of the Lmod sandbox. For further details, developers are encouraged to review the source code in ``src/sandbox.lua`` and ``src/modfuncs.lua``.
