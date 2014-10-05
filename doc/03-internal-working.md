This is a core dump of the internal structure of Lmod.

It may be helpful to follow the actions and routines that handle a module load.
This will be explained from the outer most level and will work inward.

##Level 0:

To start with a bash user enters a "module load foo".  Let assume that the foo module
contains:

    setenv ("FOO_VERSION","1.0")

and the module command is defined as

    module () { eval $(/path/to/lmod bash "$@"); }

The user command translates to

    eval $( /path/to/lmod bash "load" "foo" )

And the command

    /path/to/lmod/bash "load" "foo"

generates in its simplest form (hiding many details, explained later)

    export FOO_VERSION=1.0;

Which when evaluated sets FOO_VERSION to be "1.0" in the environment.  This is the basic
way that modules have work and has nothing to do with the internals of Lmod.  The main
point here is that the *lmod* command generates text which is a simple shell program which
the module shell function evaluates.  This is how the user's environment has changed
by *loading* the foo module.  

##Level 1:

This level is to start with "/path/to/lmod bash 'load' 'foo'".

The lmod.lua script is the entry point to the Lmod complex.  The main steps are:

    1.  Parse Command line arguments
    2.  Find the action the user requested (e.g. load the foo module).
    3.  Invoke the action.
    4.  Output the changes.

Invoking the action builds two data structures *varTbl* and *MT*.  The *varTbl* is an
array of environment variable that the actions like loading a module will change such
as setting the *FOO_VERSION* variable to "1.0".

The other data structure built is *MT*.  This is the module table.  It is a lua table
and it contains a list of the module loaded, what is the filename for the module and
other information.  This table is the only way Lmod knows the state of the loaded modules
between invocations.

In step 4, Lmod reports the key value pairs in *varTbl* and the current value of *MT*
and generates simple program to be evaluated.  The new key value pairs are written as
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

With the mix of quotes and commas it is difficult something like that directly, especially
in C-shell.  So Lmod serializes the table similarily to what is shown above but without
spaces and newlines removed.  Then that text is base64 encoded and stored in variables named
_ModuleTable001_, _ModuleTable002_, etc in blocks of 256 characters.  When Lmod starts, it
grabs those env. vars and puts them together to base64 decodes them to recover the current
state of the modules loaded.

To see the current module table you can do:

   $ module --mt

## Level 2

The command line actions are in src/cmdfuncs.lua  Similarily, functions specified in module
files are in src/modfuncs.lua.  Explain why they are similar but not the same and maintained
separately.

## Level 3

Explain how MasterControl Class works.
Explain the positive action in module files.
Explain all the ways that modulefiles are "executed" or evaluated.
  (load, unload, show, help, whatis).
Explain the stack based nature that mcp uses to manages the evaluation of modulefiles.

## Level 4

Explain MName and the load and prereq modifiers work MN_*.

## Level 5

Explain how the spider cache works.

## Level 6

Explain how the sandbox works and why it is important.

## Other possible topics

*Master.lua
*How Lmod supports both sending messages stderr but will support sending module list, avail,
  etc to stdout.
*hooks?







