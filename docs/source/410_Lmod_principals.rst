Notes for Lmod Principals:

Module Naming
~~~~~~~~~~~~~

FullName -> shortname/version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

N/V vs. C/N/V
~~~~~~~~~~~~~
Lmod supports names like gcc/10.1 where gcc is the shortname and 10.1
is the version.  It also supports C/N/V which is
category/name/version.  So a module can be named compiler/gcc/10.1
where the shortname is compiler/gcc and the version is 10.1.  The
number of categories can be as many as a site wants to use.  It is
just more typing.  Internally, Lmod only separates the fullName into a
shortname (sn) and a version.

N/V vs. N/V/V
~~~~~~~~~~~~~

Starting with version 7+, Lmod support two or more levels of versions
(namely N/V/V). So sites might name a module gcc/x86_64/10.1, where the
shortname is gcc and the version is x86_64/10.1. The depth of version
is unlimited as is the number of names. So a site might name a module:
compiler/gcc/x86_64/10.1 where the shortname is compiler/gcc and the
version is x86_64/10.1

See the discussion about consequences of using N/V/V vs. N/V in ...







One Name Rule
~~~~~~~~~~~~~
It is really the one shortname (or sn) rule.  A user can only load one
module named "gcc"

ModuleTable
~~~~~~~~~~~

The current state of modules is stored in a Lua table (The key-value
pairs are stored in a table. In this case it is called the
ModuleTable.  This internal table is written out into the environment
and converted into base64 encoding and stored in blocks of 256
characters.

Load means load
~~~~~~~~~~~~~~~

When a user requests a module to be loaded, it is loaded even if it is
already loaded.  If a user requests "module load foo" and foo is
already loaded, then "foo" is unload and reloaded.


Modules loading other module should use depends_on()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Unloading a module can never fail
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Even if unloading a module has an error in it, it is unloaded.  The
error is treated as a warning.

Base64 encoding is used a great deal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Encoding text strings can be converted to base64 encoding.  This
means that all spaces and quotes are hidden from shell interpretation.

The ModuleTable is encoded as:
_ModuleTable_Sz_ and _ModuleTable001_ _ModuleTable002_ ...

Other environment variables used by Lmod internally all start with
__LMOD_

Lmod communicates with users via a group of env. vars
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thing like LMOD_CMD and LMOD_DIR etc.


Lmod coding conventions
~~~~~~~~~~~~~~~~~~~~~~~

Notes
~~~~~

A discussion on the design of Lmod:

* At the outermost level.  The lmod program produces text. This text
  is evaluated by the appropriate tool. In other words, Lmod can
  produce shell commands to be evaluated by a shell. It can also
  produce python, perl or cmake commands to be evaluate by the
  matching tool.

* Internally, Lmod has a table of key-value pairs that contain
  typically environment variables and their values.  If no errors are
  encountered, then Lmod loops over the keys in alphabetical order and
  generates the requested style for output (shell, python, ...).

* Give an example modulefile:

      $ cat acme/1.1.lua

      setenv(       "SITE_ACME_DIR",   "/opt/apps/acme/1.1")
      prepend_path( "PATH",            "/opt/apps/acme/1.1/bin")
      prepend_path( "LD_LIBRARY_PATH", "/opt/apps/acme/1.1/bin")

* $ module load acme

* Lmod gets the subcommand "load" and converts it to the "Load" (via src/lmod.in.lua)
  function in cmdfuncs.lua 

  Note all subcommands from the command line map to functions in src/cmdfuncs.lua

* Steps to load the module:
** Find the modulefile: acme/1.1.lua
** 1st Lmod walks the directories with the src/DirTree.lua to build
   DirT table.  This table contains the directory tree.
** 2nd: Lmod converts dirT into moduleA
** The conversion into moduleA applies all the rules that Lmod
   requires to know the shortname and version.
*** Whether a module is a meta module (i.e. no version)
*** Whether it is a N/V or N/V/V
*** Any marked defaults in the directory tree (as oppose to
    LMOD_MODULERC)
* if LMOD_CACHED_LOAD is set then Lmod skips all those step because it
  has already found moduleT ( the file is called spiderT but it is
  really moduleA)
* If all modules are in the form of N/V (instead of N/V/V) then
  moduleT with multiple directories in the module path are joined into
  one structure called LocationT

* Go to spec/*/*_spec.lua to see an example of what the structure looks
  like.  For exmaple spec/DirTree/DirTree_spec.lua for what dirT looks
  like and spec/ModuleA/ModuleA_spec.lua

* When a module is loaded.  All is known is the userName. That is the
  name that the module name on the command line. It could be the
  fullName (i.e. shortName/version) or just the shortName.

* That userName is used to initialize on MName object.  This object is
  used to convert the userName into the fileName.  This is a lazy
  evaluation. The conversion from a userName into a fullName and
  fileName is only done when it is needed.

* This is because **module load compiler mpi* the mpi modulefiles
  location might not be known until the compiler module has been
  loaded.

  

------------------------------------------------------------------------
Outline of steps to load a modulefile
* command line is parsed into a sub-command such as load
* the load string is converted to an action -> Load_Usr
** Note that all commands are found in src/cmdfuncs.lua
* The operation of Load_Usr and l_usrLoad() are discussed here
* Each positional argument is now a module to load (or unload)
* Each userName of a module is converted to an MName object (and is
  discussed here)
* Each Lmod function inside a modulefile gets evaluated differently
  depending on the mode.  When loading a module, the setenv() function
  sets an environment variable.  When unloading a module, the setenv()
  function unsets or clears the environment variable.

  The various ways that Lmod evaluates its functions is controlled by
  the MainControl base class and the derived (or inherited) classes
  such as src/MC_Load.lua for module loads and src/MC_Unload.lua

* So the command load calls Load_Usr() in src/cmdfuncs.lua.  That
  calls l_usrLoad().  This then calls MainControl:load_usr() which
  calls MainControl:load().  This then calls Hub:load() which is doing
  the real work of loading a module

* Hub:load() enforces the rules of Lmod

* Lmod uses the MName object to convert the userName into a filename.

* Then the function loadModuleFile() tells Lua to evaluate the
  modulefile.  It does so by reading the entire contents of the file
  into a string.  This string is given to Lua to evaluate inside a
  sandbox (see details here)
* A tcl modulefile is converted to a lua via tcl2lua.tcl
  
* When lua encounters a function like setenv() or prepend_path(),
  these functions are Lmod functions.

* A function like setenv() and prepend_path() are found in src/modfuncs.lua.  
  These functions check that the arguments are valid.  Then
  mcp:setenv() is called.

* Review what mcp:setenv() etc means

* functions like MainControl:setenv() and MainControl:prepend_path()
  sets a key-value pair in the varT table.

* Explain what frameStk does

* Once all modulefile(s) are evaluated, control returns to lmod.
  Assuming no errors were encountered, then lmod generates text from
  the key-value pairs stored in the varT table for the appropriate
  "shell".  This includes the Moduletable, LOADEDMODULES and _LMFILES_

* Hooks?



