Lmod Glossary
~~~~~~~~~~~~~

This glossary defines key terms, components, and concepts used within the Lmod codebase and documentation.

.. glossary::
   :sorted:

   Cosmic
       Placeholder: A detailed explanation of the Cosmic variable/concept in Lmod.

   DirTree
       Placeholder: A detailed explanation of the DirTree class/object and its role in Lmod, particularly in module discovery.

   FrameStk
       Placeholder: A detailed explanation of FrameStk and its function, especially concerning the 'break' command in modulefiles.

   hub
       Placeholder: A detailed explanation of the 'hub' singleton object, its responsibilities, and how it orchestrates module operations (e.g., ``hub:load()``).

   l_usrLoad()
       Placeholder: A detailed explanation of the local function ``l_usrLoad()`` within ``Load_Usr()``, its parameters (e.g., ``check_must_load``), and its role in processing module load/unload lists.

   LMOD_CMD
       Placeholder: Explanation of the environment variable ``$LMOD_CMD`` and its significance in invoking the Lmod executable.

   lmodCmdA
       Placeholder: A detailed explanation of the ``lmodCmdA`` table (typically found in ``lmod.in.lua``) and its role in mapping user commands to internal Lmod functions.

   Load_Usr()
       Placeholder: A detailed explanation of the ``Load_Usr()`` function (typically in ``src/cmdfuncs.lua``), how it's invoked, and its primary responsibilities in handling user module load requests.

   loadModuleFile()
       Placeholder: A detailed explanation of the ``loadModuleFile()`` function (typically in ``src/loadModuleFile.lua``), its process for reading, (potentially converting TCL modules via ``runTCLprog()``), and preparing modulefiles for evaluation.

   loadTbl
       Placeholder: A detailed explanation of the ``loadTbl`` and its connection to ``lmodCmdA`` in resolving module commands.

   LocationT
       Placeholder: A detailed explanation of the LocationT class/object and its role with MName and DirTree in module identification.

   M.load()
       Placeholder: A detailed explanation of the ``M.load()`` function within ``src/MainControl.lua`` (called by ``mcp``), detailing its interaction with the ``hub`` singleton.

   M.load_usr()
       Placeholder: A detailed explanation of the ``M.load_usr()`` function within ``src/MainControl.lua`` (called by ``mcp``), and its role in user module loading operations.

   M.prepend_path()
       Placeholder: A detailed explanation of the ``M.prepend_path()`` function in ``src/MainControl.lua``, which handles the logic for prepending paths to environment variables during module load.

   M.remove_path()
       Placeholder: A detailed explanation of the ``M.remove_path()`` function in ``src/MainControl.lua``, which handles the logic for removing paths from environment variables during module unload.

   M.setenv()
       Placeholder: A detailed explanation of the ``M.setenv()`` function in ``src/MainControl.lua``, which handles the logic for setting environment variables during module load.

   M.unsetenv()
       Placeholder: A detailed explanation of the ``M.unsetenv()`` function in ``src/MainControl.lua``, which handles the logic for unsetting environment variables during module unload.

   mcp
       (main control program)
       Placeholder: A detailed explanation of the 'mcp' (main control program) object, its central role in Lmod's operation, how it determines context (loading, unloading, help, etc.), and directs command execution.

   MName
       Placeholder: A detailed explanation of an 'MName' (Module Name) object, how Lmod converts module names (e.g., "foo/1.0") into these objects, and their importance in mapping names to filesystem paths.

   ModuleA
       Placeholder: A detailed explanation of the ModuleA class/object and its interaction with MName and DirTree.

   MT
       (Module Table)
       Placeholder: A detailed explanation of the 'MT' (Module Table) and its role in storing the state of loaded modules and the user's environment.

   myGlobal
       Placeholder: A detailed explanation of the myGlobal variable/concept in Lmod.

   prepend_path()
       Placeholder: A detailed explanation of the ``prepend_path()`` Lua function available in modulefiles (defined in ``src/modfuncs.lua``), and how it interacts with ``mcp`` to call routines like ``M.prepend_path()`` or ``M.remove_path()``.

   runTCLprog()
       Placeholder: A detailed explanation of the ``runTCLprog()`` routine used by ``loadModuleFile()`` for converting TCL-based modulefiles to Lua.

   sandbox()
       Placeholder: A detailed explanation of the ``sandbox()`` Lua feature and how Lmod utilizes it to evaluate modulefiles in a controlled environment, including ``sandbox_run()``. It should cover what functions are exposed or restricted.

   setenv()
       Placeholder: A detailed explanation of the ``setenv()`` Lua function available in modulefiles (defined in ``src/modfuncs.lua``), and how it interacts with ``mcp`` to call routines like ``M.setenv()`` or ``M.unsetenv()``.

   varT
       (Variable Table)
       Placeholder: A detailed explanation of the 'varT' (variable table) where key-value pairs for environment variables are internally stored and managed by Lmod, especially how path manipulations are handled. 