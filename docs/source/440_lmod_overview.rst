Lmod Internal Overview
~~~~~~~~~~~~~~~~~~~~~~

This document provides a concrete, step-by-step walkthrough of Lmod's most common
operation: loading a module. It follows a single ``module load`` command from
user input to the final environment modification, explaining the key functions
and components involved in that specific sequence.

To illustrate this process, we will trace how Lmod handles the command
``module load foo/1.0``, assuming the ``foo/1.0.lua`` modulefile contains the
following code:

.. code-block:: lua

    setenv("Foo", "Bar")
    prepend_path("PATH", "/home/user/bin")

For a higher-level, component-based view of the architecture (the "what" and "where"), 
please first read the :doc:`443_structure` document. We recommend understanding the 
high-level components before diving into this detailed procedural walkthrough.

In Lmod's simplest terms, it takes commands from the user to change the state of the user's environment.  
It does this by loading and unloading modulefiles. When Lmod takes a command, it modifies an internal
table of key value pairs.   Finally, once the command has successfully
completed, Lmod will output the table of key value pairs to stdout.

The two core internal data structures Lmod uses to manage this state are:

-  **The Module Table (MT)**: An in-memory database of all known modules and their current state (active, inactive, etc.).
-  **The Variable Table (varT)**: An in-memory representation of the shell environment being modified.

These tables are snapshotted and managed by the :doc:`FrameStk <454_framestack_deepdive>` to allow for reversible operations.
You can learn more about these core components in the :doc:`Lmod Glossary <441_lmod_glossary>`.

The output is typically written as shell commands. The choice of shell is picked
by the user. The `module` command itself is a shell function (in bash/zsh) or
alias (in tcsh/csh) that uses `eval` to apply Lmod's output to the current
shell.

For bash and zsh, the shell function is typically defined as:

.. code-block:: shell

   module () {
     eval "$($LMOD_CMD shell "$@")"
   }

The `eval` command is the key to Lmod's ability to modify the shell's
environment. The process works in three stages:

1.  **`$LMOD_CMD shell "$@"`**: First, the Lmod program runs. Its job is *not*
    to change the environment itself, but to **print plain text** to its
    standard output. This text consists of the shell commands required to make
    the desired changes (e.g., ``export FOO=Bar;`` or ``unset PATH;``).
2.  **`$(...)`**: The shell's command substitution syntax captures this plain
    text output from the Lmod process.
3.  **`eval "..."`**: Finally, `eval` takes the captured string of commands
    and executes it in the context of the *current* shell. This is what allows
    Lmod, an external program, to define variables, aliases, and functions in
    your interactive session.

For tcsh/csh the shell alias is::

   alias module 'eval `$LMOD_CMD tcsh \!*`'

In all cases the second argument to `lmod` controls how the key value pairs are
expressed.  For bash/zsh **Foo => Bar** gets expanded to::

   Foo=Bar
   export Foo

And for tcsh/csh it gets expanded to::

   setenv Foo Bar

For the rest of this discussion, we will concentrate on what the Lmod
program does assuming that the output will be for bash/zsh users and
ignoring the evaluation step.

Internal Steps
--------------

The following steps trace the execution of the command **`module load foo/1.0`**.

#. The user command **module load foo/1.0**
#. Lmod decides what command to run by using the second argument
   (namely **load**) and converts the word into a command.  It does
   this by searching the **lmodCmdA** table in **src/lmod.in.lua** for the
   user command (**load**).  The **lmodCmdA** table matches action
   value as **loadTbl** and the **loadTbl** has the comand
   **Load_Usr()** which is a function in **src/cmdfuncs.lua**
#. The function **Load_Usr()** calls the local function
   **l_usrLoad()** with the **check_must_load** set to true.  This
   means that Lmod will check to see if all the requested modulefiles
   were successfully loaded at the end.
#. The function **l_usrLoad()** takes the remaining arguments and
   breaks them down into two lists.  Any modules that lead with a
   minus are added to the unload list.  All other modules are added to
   the load list.
#. The **l_usrLoad** function converts the command line argument
   **foo/1.0** to an **MName** object. An :doc:`MName <441_lmod_glossary>` is Lmod's internal representation
   of a module, encapsulating its name, version, and the logic to find its file path.
   The complex details of this name-to-path resolution process are found in the
   :doc:`MName Resolution Deep Dive <450_mname_resolution_deepdive>`.
#. The module is ready to start the loading process. It uses a derived
   object called **mcp** (short for main control program, a nod to the
   movie Tron). The :doc:`mcp <441_lmod_glossary>` is Lmod's central conductor; it knows the current
   context (e.g., 'loading' vs. 'unloading') and dictates how modulefile commands
   should be interpreted. How this works is discussed in the :doc:`MCP Deep Dive <451_mcp_deepdive>`.
   In our case, the **mcp:load_usr(lA)** calls **M.load_usr()** in
   **src/MainControl.lua**.  After telling Lmod to register the list
   of loaded module, Lmod then calls **M.load()** still in
   **src/MainControl.lua** 
#. The function **M.load()** builds a hub singleton and calls
   **hub:load()** with the list of MName objects to load
#. The **M.load()** is found in **src/Hub.lua**.  Here Lmod has
   implemented many of its rules.  For example this routine checks to
   see if there is another "Foo" module loaded.  In that case the old
   Foo module is unloaded and the new one then loaded.  It check for 
   downstream conflicts.  Assuming that all is well, then the routine
   **loadModuleFile()** is called.
#. The function **loadModuleFile()** is found in **src/loadModuleFile.lua**
   This routine reads in the entire contents of the modulefile.  If
   the modulefile is a TCL module, then the conversion from TCL to
   Lua is done here with the **runTCLprog()** routine. Finally it
   takes the contents of the modulefile which in all cases is now a
   lua program and calls **sandbox_run()** to evaluate the modulefile.
#. The **sandbox_run()** routine is an interesting feature of Lua.  It
   allows Lmod to call the Lua interpreter and control what functions
   are available.  In particular, modulefiles can only call certain
   Lmod functions like **setenv()** and **prepend_path()** but not
   other internal Lmod functions. It also allows Lmod to capture any
   syntax or other errors that a modulefile might have. The sandbox mechanism
   is explained in detail in the :doc:`Sandbox Deep Dive <452_sandbox_deepdive>`.
#. Once the **sandbox_run()** function is called.  It is now Lua that
   controls the evaluation of the modulefile.  The only time that Lmod
   has control is when a function implemented in Lmod like
   **setenv()** or **prepend_path()** is called.  Any other Lua code
   inside a module is evaluated by Lua.
#. After all modulefile have been loaded, Lmod checks that all
   registered modules have been loaded. 
#. Finally, if there are no errors, Lmod then takes the internal key
   value pairs and output that text in the requested style, such as
   bash as text which is then evaluated by the shell function or shell
   alias. 

Visual Summary of Internal Steps
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following flowchart provides a high-level summary of the process described above.

.. code-block:: text

    User Shell: "module load foo"
           |
           v
    Lmod Process:
    1. Parse Command (`lmod.in.lua`)
    2. Create `MName` for "foo"
    3. Use `mcp` to orchestrate load
    4. `Hub` applies rules (conflicts, etc.)
    5. `loadModuleFile` reads file
    6. `sandbox` executes module code
    7. Update internal state (`VarT`, `MT`)
    8. Generate shell code string (e.g., "export FOO=Bar;")
           |
           v
    User Shell: `eval` executes the string

Steps to evaluate a modulefile
------------------------------

The above steps show how Lmod takes a module file, evaluates it and
generates the output text.  In this section the steps necessary to
evaluate the module are discussed here.  Here we discuss how the line
**setenv("Foo", "Bar")** is evaluated.

#. Lua finds the function **setenv()** from the modulefile and calls
   this function in **src/modfuncs.lua**.
#. The **setenv()** function has to figure out what action it is
   supposed to take. For example this modulefile could be loading, in
   that case it calls **M.setenv()** in **src/MainControl.lua**. But
   if Lmod is unloading the module then **M.unsetenv()** is called.
   This is controlled by **mcp**.  See the :doc:`MCP Deep Dive <451_mcp_deepdive>` for more
   details.
#. The function **M.setenv()** store the name of the environment
   variable as the key and the next command line argument as the
   value.  In this case the key is "Foo" and the value is "Bar".  This
   key value pair is stored in the **varT** table. See the :doc:`varT Deep Dive <456_vart_deepdive>` for details.

The evaluation of **prepend_path("PATH","/home/user/bin")** works
similarly.

#. Lua finds the function **prepend_path()** from the modulefile and calls
   this function in **src/modfuncs.lua**.
#. The **prepend_path()** function has to figure out what action it is
   supposed to take. For example this modulefile could be loading, in
   that case it calls **M.prepend_path()** in **src/MainControl.lua**. But
   if Lmod is unloading the module then **M.remove_path()** is called.
   This is controlled by **mcp**.  See the :doc:`MCP Deep Dive <451_mcp_deepdive>` for more
   details.
#. The function **M.prepend_path()** store the name of the environment
   variable as the key and the next command line argument as the
   value.  In this case the key is "PATH" and "/home/user/bin" is
   prepended to "PATH".  These changes to the  key value pair is
   stored in the **varT** table.

Summary
-------

As we have seen, a single `module load` command initiates a chain of events:
parsing the user's request, resolving a module name to a file (:doc:`MName <441_lmod_glossary>`),
orchestrating the operation based on context (:doc:`mcp <441_lmod_glossary>`), enforcing loading rules
like conflict detection (:doc:`Hub <441_lmod_glossary>`), and finally evaluating the modulefile in a
secure `sandbox`. The entire process culminates in Lmod generating a string of
shell commands, which the user's shell then executes via `eval` to modify its
own environment.

