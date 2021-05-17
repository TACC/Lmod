It may be helpful to follow the actions and routines that manage a module load.
We'll work top down, starting from the outer level and work inward.

##Level 0:

A bash user begins by executing "module load foo".  Let's assume that the foo module
contains:

    setenv ("FOO_VERSION","1.0")

and the module command is defined as

    module () { eval $(/path/to/lmod bash "$@"); }

The executed *module command translates to

    eval $( /path/to/lmod bash "load" "foo" )

And the command

    /path/to/lmod/bash "load" "foo"

generates in its simplest form (hiding many details, explained later)

    export FOO_VERSION=1.0;

When evaluated, this sets **FOO\_VERSION** to be "1.0" in the environment.  This is the basic
idea behind Lmod and all other module systems. The main point is that the *lmod* command
generates text. This text is a simple shell program which the module shell function evaluates.
This is how *loading* the foo module changes the user's environment.

##Level 1:

This level starts with */path/to/lmod bash 'load' 'foo'*

The *lmod.lua* script is the entry point to the Lmod complex.  The main steps are:

    1.  Parse Command line arguments
    2.  Find the action the user requested (e.g. load the foo module).
    3.  Invoke the action.
    4.  Output the changes.

Invoking the action builds two data structures *varTbl* and *MT*.  The *varTbl* is an
array of environment variables that the actions like loading a module will change. Level 0
described such as action: setting the **FOO\_VERSION** variable to "1.0".

The other data structure is *MT*.  This is the module table.  It is a Lua table
that contains a list of the loaded modules, what the filename is for these modules and
other information.  This table is the only way that Lmod knows the state of the loaded
modules between invocations.

In step 4, Lmod reports the key value pairs in *varTbl* and the current value of *MT*
and generates a simple program to be evaluated.  The new key value pairs are written as
bash, csh, python or perl script depending on what the first argument to the lmod
command is.

The module table is a lua table and looks like:

    mt = {
      activeSize=1,
      mT= {
        foo = {
           FN="/path/to/foo/1.0.lua",
           ...
           }
       }
    }

With the mix of quotes and commas, it is difficult to store something like that
directly, especially in C-shell.  So Lmod serializes the table, but with spaces
and newlines removed. Then that text is base64 encoded and stored in variables
named _ModuleTable001_, _ModuleTable002_, etc in blocks of 256 characters.  When
Lmod starts, it grabs those environment variables and puts them together  and
then executes a base64 decodes them to recover the current state of the modules
loaded.

To see the current module table you can do:

    $ module --mt

## Level 2

Modulefiles are written with actions necessary to load the module.  For example,
a module file might say:

    setenv("ABC","DEF")
    prepend_path("PATH", "/path/to/add")

So loading this module would define **$ABC** and prepend to the **$PATH** variable.  This is the
positive direction. On the flip side, when a module is unloaded, the *setenv* and
*prepend\_path* actions are reversed or in the negative direction.  So when these module files
are interpreted the action of the functions depends on which mode.  There are several modes
among them are **load**, **unload**, **show** and **help**.

When implementing a module file interpreter, one could have a single *setenv* function which
checked the mode to decide which action to implement (e.g. load, unload, print or no-op).
Instead Lmod uses an object oriented approach by using an factory to build an object which
performs the action in the desired direction.  The program maintains a global variable
*mcp* which first built in lmod.lua:

    mcp = MasterControl.build("load")

This builds an object which places actions in the positive.  When a user requests an unload,
then the program builds:

    mcp = MasterControl.build("unload")

This places the actions in the negative direction; that is an *setenv* or *prepend\_path*
will unset a global variable or remove an entry from a path.

Another way that module files are interpreted is for show, with *mcp*:

    mcp = MasterControl.build("show")

This changes the module file actions to be converted into print statements.  There are several
other modes that treat the actions of module files differently.  The way that this is
implemented is that there is base class MasterControl (in src/MasterControl.lua) which
implements the functions in both positive and negative directions.  There is
a member function *load and another member function *unload.  When building the **load** version
of *mcp* the member setenv function points to the MasterControl.setenv function.  This can
be seen in src/MC\_Load.lua.

When building the **unload** version the setenv member function points to
MasterControl.unsetenv function as seen in src/MC\_Unload.lua.  It is the construction
of the **load**, **unload**, **show**, etc versions of *mcp*  that changes the
interpretation of the module file function.

## Level 3

To be explicit with what the Level 2 described in theory, let's start with a module file
that has:

    setenv("ABC","DEF")

The *loadModulefile()* function reads in the module file and evaluates the lua functions
in the file.  Please note that if a module file is written in TCL it is converted by
*loadModulefile()* to be lua functions.  The *setenv()* function in src/modfuncs.lua.
At the core all the *setenv()* function does is take the arguments it was called with
and it calls *mcp:setenv(...)*

     function setenv(...)
        mcp:setenv(...)
     end

The ... is the way that Lua describes a variable number of argument.  If the user has
requested a load then *mcp* has been constructed as an MC\_Load derived class.  This means
that *mcp:setenv()* is actually a call to *MasterControl:setenv(...)*.  Where as if the
user requested to unload the module, the *mcp* variable would have been built as an
MC_Unload object and the *mcp:setenv()* function is connected to
*MasterControl:unsetenv(...)*.


## Level 2

Users specify a single action on the command line **load**, **unload**, **list**, etc.
Lmod takes those actions and calls a routine in src/cmdfuncs.lua.  So if a user requests
a load.  This means that the *Load_Usr* function will be called.  This calls mcp:load()
function which is described in some detail in Level 3.  Eventually, this calls the
*loadModulefile()* function which reads the module file and evaluates as a lua program.
Note that TCL modules are converted inside of *loadModulefile()* to be lua functions.
The evaluation of


The command line actions are in src/cmdfuncs.lua.  Similarly, functions specified in module
files are in src/modfuncs.lua.  Explain why they are similar but not the same and maintained
separately.

## Level 5

Explain how the spider cache works.

## Level 6

Explain how the sandbox works and why it is important.

## Other possible topics

*Master.lua
*How Lmod supports both sending messages stderr but will support sending module list, avail,
  etc to stdout.
*hooks?
*






