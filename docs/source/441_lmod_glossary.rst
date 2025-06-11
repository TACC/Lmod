Lmod Glossary
~~~~~~~~~~~~~

This glossary defines key terms, components, and concepts used within the Lmod codebase and documentation.

.. glossary::
   :sorted:

   Cosmic
       A singleton module in Lmod responsible for managing global configuration values and Lmod's internal state or settings. It provides a centralized interface (e.g., ``cosmic:value()``, ``cosmic:assign()``) to get, set, and initialize these parameters, many of which are derived from environment variables (e.g., ``LMOD_SITE_NAME``, ``LMOD_TRACING``) or Lmod's configuration files. It acts as a central access point for global settings throughout the Lmod codebase.

   DirTree
       A class/module in Lmod that scans module file directory structures (as defined by ``MODULEPATH`` and other mechanisms). It builds a representation of the available modules by traversing these directories, identifying modulefiles, and noting associated version or ``.modulerc`` files. This hierarchical tree of directories and modulefiles is then utilized by other Lmod components, such as ``MName`` and ``ModuleA``, to discover, locate, and understand the available software modules.

   FrameStk
       (Frame Stack)
       A singleton class managing a stack of "frames," where each frame typically represents the evaluation context of a currently processing modulefile. This stack is crucial for Lmod to:

       1. Track the nesting depth of modulefile evaluations (e.g., module A loading module B).
       2. Provide access to context-specific data, such as the relevant ``MT`` (Module Table) or ``VarT`` (Variable Table) for the active module.
       3. Implement control flow operations within modulefiles, such as the ``break`` command, by allowing Lmod to unwind or alter the evaluation sequence based on the current stack state.
       4. Offer traceback capabilities for debugging or error reporting.

       Common operations include ``push()`` when entering a module context and ``pop()`` when exiting.

       For a detailed explanation of its role in state management, see :doc:`454_framestack_deepdive`.

   Hub
       A central singleton object, with its logic primarily defined in ``src/Hub.lua``. It acts as the main engine for Lmod's operations concerning modules. Its responsibilities include:

       #.   Orchestrating the loading (``hub:load()``) and unloading (``hub:unload()``) of modules.
       #.   Enforcing Lmod's rules during these operations, such as handling already loaded modules, checking for conflicts, and managing dependencies (``hub:dependencyCk()``).
       #.   Providing information about modules, such as listing available modules (``hub:avail()``) or their overview (``hub:overview()``).
       #.   Managing the overall module state, including reloading all modules (``hub:reloadAll()``) or refreshing the module view (``hub:refresh()``).

       It is called by `MainControl` methods (e.g., ``M.load()`` calls ``hub:load()``) and is a critical component in the sequence of actions Lmod takes to manage the user's environment.

   l_usrLoad()
       A local Lua function defined within ``src/cmdfuncs.lua``, specifically as a helper function called by ``Load_Usr()``. Its primary responsibilities are:

       1.  To process the array of module name arguments (``argA``) passed from the command line.
       2.  To distinguish between modules to be loaded and modules to be unloaded (typically those prefixed with a minus sign), sorting them into separate internal lists.
       3.  To convert these module name strings (e.g., "foo/1.0") into ``MName`` objects, which are Lmod's internal representation for modules.
       4.  It accepts a ``check_must_load`` boolean parameter, which dictates whether Lmod should verify at the end of the process if all requested modules were successfully loaded.

   LMOD_CMD
       An environment variable that stores the absolute path to the main Lmod executable script (typically named ``lmod``). This variable is essential for the correct functioning of the ``module`` command. Shell initialization scripts (e.g., for bash, tcsh, zsh) use ``$LMOD_CMD`` to define the ``module`` shell function or alias, which then calls the Lmod executable, passing user commands and arguments to it. For example, in bash, the module function is often defined like: ``module () { eval "$($LMOD_CMD shell "$@")"; }``. It must be correctly set in the user's environment for Lmod to be invoked.

   lmodCmdA
       A Lua table defined in the ``lmod.in.lua`` script. It serves as a primary dispatch table for Lmod, mapping user-provided command strings (e.g., "load", "avail", "list", "purge") to internal Lmod data structures or function entry points. When a user issues a ``module <command> ...`` instruction, Lmod consults ``lmodCmdA`` to find the entry corresponding to ``<command>``. This entry then directs Lmod to the appropriate internal table (like ``loadTbl``) or function (like ``Load_Usr()`` found in ``src/cmdfuncs.lua``) responsible for handling that specific action.

   Load_Usr()
       A function defined in ``src/cmdfuncs.lua`` that serves as the primary entry point for handling user-initiated ``module load`` commands (and similar commands like ``module try-load``). Its main sequence of operations includes:

       1.  Receiving the module names and any options specified by the user on the command line.
       2.  Calling the local helper function ``l_usrLoad()`` to parse these arguments. ``l_usrLoad()`` separates them into lists of modules to load and unload, and converts the names into ``MName`` objects. It is typically called with ``check_must_load`` set to true for standard loads.
       3.  Invoking ``mcp:load_usr(lA)`` (where ``mcp`` is the Main Control Program object and ``lA`` is the list of ``MName`` objects to load), which then delegates to ``M.load_usr()`` in ``src/MainControl.lua`` to continue the loading process.

   loadModuleFile()
       A function defined in ``src/loadModuleFile.lua`` that is responsible for the direct processing and evaluation of an individual modulefile. Its key tasks include:

       1.  Reading the entire content of the specified modulefile.
       2.  Detecting if the modulefile is a TCL-based module. If so, it invokes the ``runTCLprog()`` routine to convert the TCL commands into an equivalent Lua script.
       3.  Taking the modulefile content (which is now guaranteed to be Lua code, either originally or after conversion) and evaluating it within a controlled environment using the ``sandbox()`` mechanism. The ``sandbox()`` restricts the Lmod and Lua functions available to the modulefile.

       It is primarily called from ``src/Hub.lua`` during module loading but also used by other tools that need to interpret modulefile content.

   loadTbl
       A Lua table defined in ``src/lmod.in.lua`` that acts as a configuration and dispatch target for module loading commands. Entries in the main command dispatch table, ``lmodCmdA`` (for user commands like "load", "add", etc.), point to ``loadTbl`` via their ``action`` field. The ``loadTbl`` itself contains properties relevant to the load operation, most importantly a ``cmd`` field that holds a direct reference to the primary function responsible for handling the load request, which is ``Load_Usr()`` (located in ``src/cmdfuncs.lua``). It may also contain other metadata like ``name`` (for debugging/identification) and ``checkMPATH`` (a boolean indicating if ``MODULEPATH`` needs to be checked).

   LocationT
       A class (defined in ``src/LocationT.lua``) that creates a structured representation of module locations. It is typically initialized with data derived from ``ModuleA`` (which itself is built from ``DirTree``'s scan of ``MODULEPATH``). ``LocationT``'s primary purpose is to provide an efficient way to search for modules (via its ``LocationT:search(name)`` method) and to help ``MName`` objects resolve a given module name string (which might follow various conventions like Name/Version, Category/Name/Version) to its canonical file path and associated properties. It achieves this by abstracting the complexities of different directory layouts found across various module trees, effectively creating a readily searchable map or index.

   mcp
       (Main Control Program)
       The ``mcp`` (Main Control Program) is the primary stateful object that orchestrates Lmod's behavior for a given user command. It is an instance of the ``MainControl`` class (defined in ``src/MainControl.lua``). The ``mcp`` object is typically created using ``MainControl.build("mode")``, where ``"mode"`` (e.g., "load", "unload", "spider", "avail", "help") determines its operational context.
       Key characteristics and roles:

       1.  **State Management**: The mode with which ``mcp`` is initialized dictates how subsequent operations are handled. For example, if a modulefile command like ``prepend_path()`` is encountered, the ``mcp`` object's internal logic (based on its mode) will dispatch this to the appropriate underlying ``MainControl`` method, such as ``M.prepend_path`` if in "load" mode, or ``M.remove_path`` if in "unload" mode.
       2.  **Method Dispatch**: It provides the core methods (like ``mcp:load_usr()``, ``mcp:setenv()``, ``mcp:prepend_path()``) that are called by higher-level functions (in ``src/modfuncs.lua`` or ``src/cmdfuncs.lua``). These ``mcp`` methods then delegate to the actual implementation methods (e.g., ``M.load_usr()``, ``M.setenv()``) within the ``MainControl`` class, tailored to the current mode.
       3.  **Central Orchestration**: It ties together various components by holding references or providing access to other key Lmod objects and data structures necessary for the current operation.

       The global variables ``mcp``, ``MCP``, and ``MCPQ`` are typically instances of ``MainControl`` initialized for different primary purposes or verbosity levels within a single Lmod invocation.

   MName
       An ``MName`` (Module Name) object is Lmod's primary internal representation of a module. These objects are created from user-provided module name strings (e.g., "gcc/9.3.0", "tacc") or from other internal representations. ``MName`` objects are defined in ``src/MName.lua``.
       Key characteristics and roles:

       1.  **Encapsulation**: An ``MName`` object encapsulates various properties of a module, including its user-specified name, its canonical short name (``:sn()``), full name (``:fullName()``), version (``:version()``), and the resolved path to its modulefile (``:fn()`` or ``:path()``).
       2.  **Resolution**: It contains the logic to resolve a potentially ambiguous module name string into a specific modulefile on the filesystem. This process involves interacting with other Lmod components like ``DirTree`` (for directory structure), ``ModuleA`` (for collections of modules), and ``LocationT`` (for location indexing and handling different naming schemes like N/V, C/N/V).
       3.  **State & Validation**: ``MName`` objects can report on the module's status, such as whether it's currently loaded (``:isloaded()``) or if it's a valid, findable module (``:valid()``).
       4.  **Operations**: They are used extensively throughout Lmod. For example, lists of ``MName`` objects are passed to functions like ``hub:load()`` and ``mcp:load_usr()`` to specify which modules to act upon. Modulefile commands like ``prereq`` or ``conflict`` also operate on ``MName`` objects.

       Instantiation typically occurs via methods like ``MName:new(type, name, ...)`` or ``MName:buildA(type, argTable)``.

   ModuleA
       ``ModuleA`` (Module Array/Aggregator) is a class, defined in ``src/ModuleA.lua``, that represents the entire collection of available modules discovered by Lmod from the ``MODULEPATH``. It is typically used as a singleton within Lmod's operations.
       Key characteristics and roles:

       1.  **Data Source**: It acts as a primary, structured source of information about all known modules. It's initialized by processing the ``MODULEPATH`` directories, using ``DirTree`` to scan the filesystem and identify modulefiles and their organization.
       2.  **Module Discovery**: Provides methods like ``:search(name)`` to find modules, and ``:defaultT()`` to get information about default module versions.
       3.  **Information Provider**: Supplies data for commands like ``module avail`` (via ``:build_availA()``) and for internal checks, such as determining if a module path follows a Name/Version/Version (``:isNVV()``) convention.
       4.  **Interaction**: ``ModuleA``'s data is used by ``LocationT`` to build its searchable index, and ``MName`` objects query ``ModuleA`` (often via ``LocationT``) to resolve names to specific modulefile paths and properties.
       5.  **Caching**: It can incorporate spider cache information (``spider_cache=true``) to speed up discovery if available.

       It's instantiated using ``ModuleA:__new({mpathA}, maxdepthT)`` or more commonly accessed via ``ModuleA:singleton{spider_cache=...}``.

   MT
       (Module Table)
       ``MT`` (Module Table) is a central Lmod data structure, defined in ``src/MT.lua``, that represents the current state of the user's environment in terms of loaded modules. It acts as a live record of which modules are loaded, their properties, and how they were loaded.
       Key characteristics and roles:

       1.  **State Tracking**: It stores detailed information for each loaded module, including its short name (``sn``), full name, user-specified name, version, filename (``:fn()``), status (e.g., "active", "inactive", "pending" via ``:setStatus()``, ``:status()``, ``:have()``), load order, and any associated properties.
       2.  **Environment Representation**: It maintains the current ``MODULEPATH`` array (``:modulePathA()``) and other environment-related settings derived from module operations.
       3.  **Query Interface**: Provides numerous methods to query the state of loaded modules, such as listing modules (``:list()``), checking if a module is loaded (``:have()``), retrieving a module's filename or version.
       4.  **Modification Interface**: Offers methods to modify the state, such as adding a module (``:add()``), changing its status, or marking it as directly loaded by the user (``:userLoad()``).
       5.  **Serialization**: Can serialize its contents (e.g., via ``:serializeTbl()``), which is crucial for Lmod to pass its state back to the shell for environment updates (e.g., by setting ``LOADEDMODULES``).
       6.  **Collections**: Handles module collections by loading their state from files (``:getMTfromFile()``).

       The ``MT`` is typically accessed as a singleton object (e.g., ``MT:singleton()``) or retrieved from the current evaluation context via ``frameStk:mt()``. It is dynamically updated as modules are loaded and unloaded.

       For a detailed explanation of its role in state management, see :doc:`455_mt_deepdive`.

   myGlobal
       Refers to the Lua script ``src/myGlobals.lua``. Its
       primary purpose is to initialize and make available a wide
       range of global variables, internal constants, and fundamental
       settings that govern Lmod's runtime behavior. 
       Key aspects:

       1.  **Centralized Configuration**: It uses the ``Cosmic`` singleton (``cosmic:init{...}``) extensively to define and initialize numerous ``LMOD_*`` configuration parameters. These parameters can be sourced from compile-time settings (via ``sedV`` substitution), environment variables (``envV``), or assigned default values. Examples include ``LMOD_TRACING``, ``LMOD_SITE_NAME``, ``LMOD_CONFIG_DIR``, ``LMOD_RC``.
       2.  **Internal Constants**: Defines essential internal constants like ``ModulePath`` (the string "MODULEPATH") and ``LMOD_CACHE_VERSION``.
       3.  **Global State**: Establishes some baseline global state, such as ensuring ``LC_ALL`` is set to "C" for consistent behavior and initializing ``ExitHookA`` (an array for functions to be called on exit).
       4.  **Early Initialization**: Due to its widespread inclusion, it plays a crucial role in the early setup of Lmod's operating environment before specific commands are processed.

       It serves as a foundational script that provides a consistent and globally accessible set of parameters and constants for the rest of the Lmod codebase.

   runTCLprog()
       A globally available Lmod function (``_G.runTCLprog``) responsible for executing a specified TCL script and returning its output. It is primarily used by:
       1.  ``loadModuleFile()``: To convert TCL-based modulefiles into Lua code. In this context, ``runTCLprog`` is called with ``tcl2lua.tcl`` (a TCL script that translates modulecmd TCL syntax to Lua) as the program to run, and the path to the target TCL modulefile plus other necessary arguments.
       2.  ``mrc_load.lua``: To convert ``.modulerc`` files (which can be TCL based) into Lua. Here, ``runTCLprog`` is called with ``RC2lua.tcl``.
       The ``runTCLprog`` function itself has multiple potential backends: it can be a Lua implementation that invokes an external ``tclsh`` interpreter, or if Lmod is compiled with an embedded TCL interpreter (from ``pkgs/tcl2lua/tcl2lua.c`` or ``embed/tcl2lua.c``), it can be a C function that directly executes the TCL script. Its purpose is to bridge the gap between TCL-based files and Lmod's Lua core by translating TCL into executable Lua statements.

   sandbox_run()
       The "sandbox" refers to the controlled execution environment Lmod creates to evaluate the Lua code within modulefiles. This mechanism is primarily implemented in ``src/sandbox.lua``.
       Key aspects:

       1.  **Controlled Environment (``sandbox_env``)**: A specific Lua environment table (``sandbox_env``) is constructed. This table explicitly includes a curated list of safe standard Lua library functions (e.g., ``pairs``, ``string.format``) and all Lmod-provided modulefile API functions (e.g., ``prepend_path``, ``load``, ``whatis`` from ``src/modfuncs.lua``). Functions that could be harmful are generally excluded or replaced by safer Lmod versions.
       2.  **Execution (``sandbox_run``)**: The Lua code from a modulefile (after being read and potentially converted from TCL by ``runTCLprog``) is executed using a function, typically ``sandbox_run``. This function compiles and runs the module code, setting the ``sandbox_env`` as the global environment for that code.
       3.  **Purpose**: To ensure security (preventing malicious operations), isolation (enforcing a defined API), and robust error handling for modulefile execution.

       The ``loadModuleFile()`` function is the primary user of ``sandbox_run``. A similar mechanism, ``mrc_sandbox_run`` (from ``src/mrc_sandbox.lua``), is used for evaluating ``.modulerc`` files.

   varT
       (Variable Table)
       ``varT`` is Lmod's internal representation of the environment that is being built or modified as modulefiles are processed. It is not the OS environment itself, but rather a Lua table that Lmod uses to track changes.
       Key characteristics:

       1.  **Structure**: ``varT`` is a Lua table where keys are environment variable names (strings, e.g., "PATH", "FOO_VERSION"). The values associated with these keys are instances of the ``Var`` class (defined in ``src/Var.lua``). Each ``Var`` object encapsulates the state and behavior for a single environment variable (e.g., its current value, delimiter for path-like variables, rules for handling duplicates).
       2.  **Access**: ``varT`` is typically accessed from the current evaluation context (frame) via ``frameStk:varT()``, where ``frameStk`` is the singleton instance of ``FrameStk``.
       3.  **Manipulation**: All modifications to the environment dictated by modulefile commands (like ``setenv``, ``prepend_path``, ``set_alias``) are performed by first obtaining the relevant ``Var`` object from ``varT`` (creating it if it doesn't exist via ``Var:new(name)``) and then calling methods on that ``Var`` object (e.g., ``:set()``, ``:prepend()``, ``:setAlias()``). These methods update the internal state of the ``Var`` object within ``varT``.
       4.  **Output Generation**: After all module commands are processed, Lmod reads the final state of all ``Var`` objects in ``varT`` to generate the shell commands (e.g., ``export FOO=bar;``, ``setenv PATH /new/path:$PATH``) that will actually modify the user's shell environment.

       For a detailed explanation of its role in state management, see :doc:`456_vart_deepdive`.
