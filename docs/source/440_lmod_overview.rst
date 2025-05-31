Lmod Internal Overview
~~~~~~~~~~~~~~~~~~~~~~

This overview is for developers who wish to understand how the Lmod
program works.  We will outline the actions that Lmod takes when it is
given a command. In particular we will show how Lmod loads the
following simple modulefiles called foo/1.0.lua:: 

    setenv("Foo", "Bar")
    prepend_path("PATH", "/home/user/bin")

In Lmod simplist terms, it takes commands from the user to change the state of the user's environment.  
It does this by loading and unloading modulefiles. When Lmod takes a command, it modifies an internal
table of key value pairs.   Finally, once the command has successfully
completed, Lmod will output the table of key value pairs to stdout.

The output is typically written as shell commands.  The choice of
shell is picked by the user.   The module command in its simplest form
is a shell function in bash and a shell alias in tcsh/csh.  For bash
and zsh the shell function can be written as::

   module () {
     eval "$($LMOD_CMD shell "$@")"
   }

where *$LMOD_CMD* is the path to the Lmod source.  The second argument
*shell* tells Lmod to ask the environment what shell is running.  For
tcsh/csh the shell alias is::

   alias module 'eval `$LMOD_CMD tcsh \!*'`

In all cases the second argument controls how the key value pairs are
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


#. The user command **module load foo/1.0**
#. Lmod decides what command to run by using the second argument
   (namely **load**) and converts the word into a command.  It does
   this by searching the **lmodCmdA** table in **lmod.in.lua** for the
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
   **foo/1.0** to an **MName** object.  This is necessary to map the
   name to an actual path in the filesystem.  This conversion from a
   module name to an MName object is found here: ???
#. The module is ready to start the loading process. It uses a derived
   object called **mcp** (short for main control program, a nod to the
   movie Tron)  How this works is discussed here: ???.  In our case,
   the **mcp:load_usr(lA)** calls **M.load_usr()** in
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
   lua program and calls **sandbox()** to evaluate the modulefile.
#. The **sandbox()** routine is an interesting feature of Lua.  It
   allows Lmod to call the Lua interpreter and control what functions
   are available.  In particular, modulefiles can only call certain
   Lmod functions like **setenv()** and **prepend_path()** but not
   other internal Lmod functions. It also allows Lmod to capture any
   syntax or other errors that a modulefile might have.
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
   This is controlled by **mcp**.  See MCP discussion??? for more
   details.
#. The function **M.setenv()** store the name of the environment
   variable as the key and the next command line argument as the
   value.  In this case the key is "Foo" and the value is "Bar".  This
   key value pair is stored in the **varT** table.

The evaluation of **prepend_path("PATH","/home/user/bin")** works
similarly.

#. Lua finds the function **prepend_path()** from the modulefile and calls
   this function in **src/modfuncs.lua**.
#. The **prepend_path()** function has to figure out what action it is
   supposed to take. For example this modulefile could be loading, in
   that case it calls **M.prepend_path()** in **src/MainControl.lua**. But
   if Lmod is unloading the module then **M.remove_path()** is called.
   This is controlled by **mcp**.  See MCP discussion??? for more
   details.
#. The function **M.prepend_path()** store the name of the environment
   variable as the key and the next command line argument as the
   value.  In this case the key is "PATH" and "/home/user/bin" is
   prepended to "PATH".  These changes to the  key value pair is
   stored in the **varT** table.

Things to explain:

#. MName: How Lmod converts module names to paths.  The difference
   between a modulefile to load versus unload.
#. DirTree and ModuleA and LocationT:  How MName uses both of these Classes to
   figure out what a module is.  That is the whole N/V, C/N/V versus N/V/V
#. MCP: How the mcp object works.  The many ways that Lmod evaluates
   modulefiles.
#. FrameStk:  How Lmod handles the break function
#. VarT: How the var table works.  Especially, how prepend, append
   works for path like variables.
#. MT: How the module table works to store the state in a the user
   env.
#. Cosmic and myGlobal

