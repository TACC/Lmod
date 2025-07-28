.. _lmod_detailed_architecture:

Lmod Detailed Architecture and Directory Structure
==================================================

This document provides a high-level overview of Lmod's internal architecture,
detailing its main components and how they interact. It also describes the
key directories within the Lmod source code. This information is intended for
developers looking to understand Lmod's design and contribute to its codebase.

High-Level Architecture
-----------------------

Lmod processes user commands (e.g., ``module load <modulefile>``) through a series
of well-defined components. The general flow involves parsing the command,
executing core logic to determine necessary environment changes, loading and
evaluating modulefiles in a controlled sandbox, managing environment variables,
and finally formatting the output as shell commands.

.. mermaid::
   :align: center
   :alt: Lmod High-Level Architecture Diagram

   graph TD
       subgraph "User's Shell"
           A["User Command<br/>(e.g., 'module load gcc')"]
       end
       
       A --> B["1. Command Line Parser<br/>'lmod.in.lua'<br/>Interprets the command and its arguments"];
       
       B --> C["2. Core Logic (MCP)<br/>'MainControl.lua'<br/>Orchestrates the loading process"];
       
       C -- "Request to find module" --> D["3. Module File Loader<br/>'Hub.lua'<br/>Resolves module name to a file path"];
       
       D -- "Located at" --> E["Modulefile<br/>(e.g., '/path/to/gcc.lua')"];
       
       E -- "Passes Lua code to" --> F;
       
       subgraph "4. Sandbox Environment ('sandbox.lua')"
         direction LR
         F["Modulefile Code<br/>(e.g., 'prepend_path(...)')"] --> G["Lmod API<br/>'modfuncs.lua'"];
       end
   
       G -- "Instructs MCP to record changes" --> H;
   
       subgraph "5. Environment Variable Manager"
         H["'varT' (Variable Table)<br/>A list of all proposed environment<br/>changes is built and managed by the MCP"];
       end
       
       H -- "Final list of changes (varT) passed to" --> I["6. Output Formatter<br/>'shells/*.lua'<br/>Translates 'varT' into shell-specific code"];
       
       I -- "Generates" --> J;
   
       subgraph "User's Shell"
           J["Shell Commands<br/>(e.g., 'export PATH=...')<br/>Printed to standard output"];
       end

Key Architectural Components:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1.  **Command Line Parser:**

    *   **Responsibilities:** Interprets the user's command line input (e.g., ``lmod load gcc``, ``module avail``), identifies the primary command (load, avail, list, etc.), and parses any associated options and arguments.

    *   **Key Files:**

        *   ``src/lmod.in.lua``: The main entry point for the ``lmod`` command. It performs initial setup, determines the target shell for output, identifies the core command requested by the user, and orchestrates the overall workflow, including invoking the output formatter at the end.

        *   ``src/ml_cmd.in.lua``: The main entry point for the ``ml`` command, a shorthand utility for ``lmod``. It parses ``ml`` syntax and translates it into ``lmod`` commands.

        *   ``src/Options.lua``: Handles the parsing of command-line flags and options provided with the ``lmod`` or ``ml`` commands.

        *   ``src/cmdfuncs.lua``: Contains the implementations for the various sub-commands Lmod supports (e.g., ``load``, ``unload``, ``list``, ``avail``, ``spider``). ``lmod.in.lua`` dispatches to functions within this file based on the parsed command.

2.  **Core Logic / MCP (Main Control Program):**

    *   **Responsibilities:** This is the brain of Lmod. The MCP orchestrates the execution of commands. It determines the current context (e.g., loading, unloading, displaying help, listing modules), manages Lmod's internal state, and decides how modulefile directives (like ``setenv`` or ``prepend_path``) should behave in that context. It accumulates all intended environment changes. For a detailed explanation of the MCP's modes and state management, see the :ref:`deepdive_mcp_overview`.

    *   **Key Files:**

        *   ``src/MainControl.lua``: Defines the base class and core logic for the MCP object (often referred to as ``mcp``). It manages a collection of environment variable changes (known as ``varT``) and the state of loaded modules (``MT`` - Module Table).

        *   ``src/MC_*.lua`` (e.g., ``MC_Load.lua``, ``MC_Unload.lua``, ``MC_Show.lua``, ``MC_Avail.lua``): These files implement specialized behaviors for the MCP depending on the command being executed. For instance, ``MC_Load.lua`` defines how ``setenv`` behaves during a module load, while ``MC_Unload.lua`` defines its behavior during an unload.

        *   ``src/FrameStk.lua``: Manages a frame stack that holds contextual information for Lmod operations, including the current ``varT`` and ``MT``. This is important for handling nested operations and features like ``LmodBreak()``.

3.  **Module File Loader:**

    *   **Responsibilities:** Locates, reads, and prepares modulefiles for execution. The first step in this process is resolving the user-provided module name into a full path to a modulefile, which is handled by Lmod's `MName` resolution system. For more details on this, see the :ref:`deepdive_mname_resolution`. Once located, the loader handles both Lua-based and TCL-based modulefiles, converting TCL to Lua as needed.

    *   **Key Files:**

        *   ``src/Hub.lua``: Acts as a central "hub" for module operations. It applies Lmod's rules for loading and unloading, such as checking for conflicts, managing module dependencies, and handling module version switches (e.g., unloading an older version when a newer one is loaded). It then instructs the ``loadModuleFile.lua`` script to process the actual modulefile.

        *   ``src/loadModuleFile.lua``: This script is responsible for the physical reading of a modulefile from the disk. If the file is a TCL modulefile (identified by not having a ``.lua`` extension), it invokes ``tcl2lua.tcl`` to translate its contents into Lua. The resulting Lua code (either directly read or translated) is then passed to the Sandbox for execution.

        *   ``src/tcl2lua.tcl``: A TCL script that parses a TCL modulefile and translates its commands (e.g., ``setenv``, ``prepend-path``) into equivalent Lua function calls that Lmod's sandbox can understand.

4.  **Sandbox:**

    *   **Responsibilities:** Provides a secure and controlled environment for executing the Lua code derived from a modulefile. This prevents modulefiles from interfering with Lmod's internal operations or the user's system in unintended ways. For a detailed breakdown of the sandbox implementation, see the :ref:`deepdive_sandbox`.

    *   **Key Files:**

        *   ``src/sandbox.lua``: Defines the sandboxed environment. It maintains an "allowlist" (``sandbox_env``) of Lua functions and Lmod-specific API calls (defined in ``modfuncs.lua``) that are permissible within a modulefile. The ``sandbox_run()`` function executes the modulefile's Lua code within this restricted environment, ensuring it only has access to the approved functions.

5.  **Environment Variable Manager:**

    *   **Responsibilities:** Manages the state of environment variables that Lmod intends to modify. It handles the complexities of different variable types (scalars vs. paths) and records all changes requested by modulefiles.

    *   **Key Files:**

        *   ``src/Var.lua``: Defines a class-like structure for representing individual environment variables. It handles operations like prepending/appending to path-like variables, setting scalar variables, and managing Lmod-specific metadata like priorities and reference counts for path components.

        *   ``src/modfuncs.lua``: Contains the Lua implementations of the functions made available to modulefiles in the sandbox (e.g., ``setenv()``, ``prepend_path()``, ``load()``, ``whatis()``). When a modulefile calls one of these functions, the corresponding function in ``modfuncs.lua`` is executed. These functions typically validate their arguments and then invoke methods on the MCP object (``MainControl.lua``) to register the intended change. The MCP, in turn, uses ``Var.lua`` objects to manage the state of each affected variable, storing these ``Var`` objects in the ``varT`` (variable table).

        *   The ``varT`` (Variable Table): This is not a single file but a conceptual table, managed by the MCP (``MainControl.lua``) and stored on the ``FrameStk.lua``, that holds a collection of ``Var.lua`` objects representing all the environment modifications Lmod will make upon successful completion.

6.  **Output Formatter:**

    *   **Responsibilities:** Generates the shell-specific commands that will actually alter the user's environment. It takes the accumulated changes (from ``varT``) and translates them into the correct syntax for the user's current shell (e.g., Bash, Csh, Zsh).

    *   **Key Files:**

        *   ``src/lmod.in.lua``: After all command processing is complete, this script orchestrates the output generation by calling the ``expand()`` method of the current ``Shell`` object, passing it the ``varT``.
        *   ``shells/BaseShell.lua``: Provides an abstract base class for shell-specific output generation.
        *   ``shells/*.lua`` (e.g., ``shells/bash.lua``, ``shells/csh.lua``): These are concrete implementations for specific shells. They inherit from ``BaseShell.lua`` and implement the ``expand(varT)`` method, which iterates through the ``varT`` and prints the appropriate shell commands (e.g., ``export VAR=val`` for Bash, ``setenv VAR val`` for Csh) to standard output. Lmod can generate output formated for programming languages such as python, R, Ruby and tools like cmake.
        *   ``src/Exec.lua``: Manages any direct shell command execution requested by modulefiles via the ``execute{}`` directive. Its ``expand()`` method is also called by ``lmod.in.lua`` to output these commands.

Project Directory Structure
---------------------------

Understanding the layout of the Lmod codebase can help in navigating and comprehending its components.

*   **``src/``**: This is the heart of Lmod, containing all the core Lua source files that implement Lmod's functionality. Key files discussed in the architecture section (``lmod.in.lua``, ``MainControl.lua``, ``sandbox.lua``, ``Var.lua``, ``modfuncs.lua``, ``Hub.lua``, ``loadModuleFile.lua``, ``Options.lua``, ``cmdfuncs.lua``,  etc.) are located here.

    *   **``src/MC_*.lua`` files**: Implementations for different modes of the MainControl program (MCP).

*   **``shells/``**: Contains Lua modules for specific shell output formatting (e.g., ``BaseShell.lua``, ``Bash.lua``, ``Csh.lua``, ``Zsh.lua``). These are used by the Output Formatter.

*   **``libexec/``**: Contains helper scripts and the main executable entry points like ``lmod`` and ``ml`` (which are typically wrappers that call ``lmod.in.lua`` and ``ml_cmd.in.lua`` respectively with the Lua interpreter). The ``tcl2lua.tcl`` script is also often found here or in a path accessible to ``loadModuleFile.lua``.

*   **``init/``**: Contains initialization scripts for various shells (Bash, Csh, Zsh, Fish, etc.). These scripts define the ``module`` shell function or alias that users interact with, which in turn calls the Lmod executable (``libexec/lmod``).

*   **``lmodadmin/``**: Contains administrative scripts for Lmod, such as ``update_lmod_system_cache_files``.

*   **``etc/``**: Typically contains Lmod's global configuration files, such as ``lmod_config.lua`` (site-wide Lmod settings) and ``lmodrc.lua`` (system-wide module RC file).

*   **``docs/``**: Contains the source files for Lmod's documentation, written in reStructuredText.

    *   **``docs/source/``**: The primary location for ``.rst`` files.

*   **``rt/``**: Contains the regression testing suite for Lmod (short for "regression tests"). This framework is crucial for verifying Lmod's functionality, preventing regressions, and ensuring stability across different shells and scenarios. For details on how to run these tests, see :ref:`lmod_testing_guide`.

*   **``tools/``**: May contain auxiliary Lua modules or scripts used by the core Lmod components or for development/debugging purposes.

This architectural overview and directory explanation should serve as a good starting point for developers aiming to contribute to Lmod. For deeper dives into specific functionalities, consulting the respective source files is recommended.
