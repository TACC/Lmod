.. _lua_modulefile_functions-label:


Lua Modulefile Functions
========================

Lua is an efficient language built on simple syntax. Readers wanting
to know more about lua can see http://www.lua.org/. This simple description
given here should be sufficient to write all but the most complex
modulefiles.

It is important to understand that modulefiles are written in the
positive. That is, one writes the actions necessary to activate the
package. A modulefile contains commands to add to the PATH or set
environment variables. When loading a modulefile the commands are
followed. When unloading a modulefile the actions are reversed. That
is the element that was added to the PATH during loading, is removed
during unloading. The environment variables set during loading are
unset during unloading.

**prepend_path** ("*PATH*", "*/path/to/pkg/bin*"):
   prepend to a path-like variable the value.

**prepend_path** ("*PATH*", "*/path/to/pkg/bin*", "*delim*"):
   prepend to a path-like variable the value. It is possible to add a
   third argument to be the delimiter.  By default is is "*:*", the
   delimiter can be any single character for example " " or  ";"

**prepend_path** {"*PATH*", "*/path/to/pkg/bin*", delim="*delim*", priority=*num*}:
   prepend to a path-like variable the value. One can use this form
   **with braces {} instead of parens ()** to specify both a priority
   a non-default delimiter.

**append_path** ("*PATH*", "*/path/to/pkg/bin*"):
   append to a path-like variable the value.

**append_path** ("*PATH*", "*/path/to/pkg/bin*", "*delim*"):
   append to a path-like variable the value. It is possible to add a
   third argument to be the delimiter.  By default is is "*:*", the
   delimiter can be any single character for example " " or  ";"

**append_path** {"*PATH*", "*/path/to/pkg/bin*", delim="*delim*", priority=*num*}:
   append to a path-like variable the value. One can use this form
   **with braces {} instead of parens ()** to specify both a priority
   a non-default delimiter.

**remove_path** ("*PATH*", "*/path/to/pkg/bin*"):
   remove value from a path-like variable for both load and unload modes.

**remove_path** ("*PATH*", "*/path/to/pkg/bin*" , "*delim*"):
   remove value from a path-like variable for both load and unload modes.
   It is possible to add a third argument to be the delimiter.  By
   default is is "*:*", the delimiter can be any single character for
   example " " or  ";" 

**setenv** ("NAME", "*value*"):
   assigns to the environment variable "NAME" the value.  Do not use this
   function to assign the initial to a path-like variable.  Use
   **append_path** or **prepend_path** instead.

**pushenv** ("NAME", "*value*"):
   sets **NAME** to *value* just like **setenv**.  In addition it
   saves the previous value in a hidden environment variable.  This
   way the previous state can be returned when a module is unloaded.
   **pushenv** ("FOO",false) will clear "FOO" and the pop will return
   the previous value.

**add_property** ("NAME", "*value*"):
   See :ref:`lmodrc-label` for how to use this function.

**remove_property** ("NAME", "*value*"):
   See :ref:`lmodrc-label` for how to use this function.

**unsetenv** ("NAME"):
   unset the value associated with "NAME".  This command is a no-op
   when the mode is unload.

**whatis** ("STRING"):
    The whatis command can be called repeatedly with different strings. 
    See the Administrator Guide for more details.

**help** ( [[ *help string* ]]):
     What is printed out when the help command is called. Note that
     the *help string* can be multi-lined.

**pathJoin** ("/a", "b/c/", "d/"):
     builds a path: "/a/b/c/d", It combines any number of strings with
     one slash and removes excess slashes. Note that trailing slash is
     removed. If you need a trailing slash then do
     **pathJoin("/a", "b/c") .. "/"** to get "/a/b/c/".

**depends_on** ("pkgA", "pkgB", "pkgC"):
     Loads all modules.  When unloading only dependent modules are
     unloaded.  See :ref:`dependent_modules-label` for details.


**load** ("pkgA", "pkgB", "pkgC"):
     load all modules. Report error if unable to load.

**load_any** ("pkgA", "pkgB", "pkgC"):
     loads the first module found. Report error if unable to load any
     of the modules.  When unloading all modules are marked to be
     unloaded.

**try_load** ("pkgA", "pkgB", "pkgC"):
     load all modules. No errors reported if unable to load. Any other
     errors will be reported.


**complete** ("shellName","name","args"):
     Bash and tcsh support the complete function.  Note that the
     shellName must match the name of the shell given on the Lmod
     command.  There is no error if the shell names do not match. The
     command is ignored.  See rt/complete/mf/spack/1.0.lua for an example.

**source_sh** ("shellName","shell_script arg1 ...")
     source a shell script as part of a module. Supported shellNames
     are *sh*, *dash*, *bash*, *zsh*, *csh*, *tcsh*, *ksh*.  When
     loading, Lmod automatically converts the shell script into module
     commands and saves the module commands in the environment.  It
     does this by sourcing the shell script string in a subshell and
     comparing the environment before and after sourcing the shell
     script string. When unloading, the saved module commands from the
     environment are used.

     Note that shell script string must not change between loading and
     unloading as the full string is used to reference the saved
     module commands.

     Other shells could be supported with help from the community that
     uses that shell.  (New in version 8.6) 

     This feature was introduced in Tmod 4.6 and was shamelessly
     studied and re-implemented in Lmod 8.6+.

**LmodBreak** (msg):
     LmodBreak() modulefile function causes the evaluation of the
     current modulefile to stop and all changed in the user's
     environment to be ignored from the current modulefile.  However,
     all other modulefiles are evaluated.  In TCL modulefiles it is
     **break**.  

     In other words, this function does not stop, where as
     **LmodError()** stops all evaluations. New in Lmod 8.6+

     **Note** As of Lmod 8.6.16: LmodBreak() does nothing when unloading.


**userInGroups** ("group1", "group2", ...):
     Returns true if user is root or a member of one of the groups listed.

**mgrload** (required, active_object):
     load a single module file. If required is true then error out if
     not found.  If false then no message is generated.  Returns true
     if successful.  See :ref:`site_package_mgrload` for details.


**always_load** ("pkgA", "pkgB", "pkgC"):
     load all modules. However, when this command is reversed, it does nothing.

**set_alias** ("name", "value"):
     define an alias to name with value.

**unload** ("pkgA", "pkgB"):
     In both load and unload mode, the modulefiles are unloaded. It is
     not an error to unload modules that where not loaded.

**family** ("name"):
     A user can only have one family "name" loaded at a time. For example family("compiler") would mean that a user could only have one compiler loaded at a time.
**prereq** ("name1", "name2"):
     The current modulefile will only load if **all** the listed modules are already loaded.

**prereq_any** ("name1", "name2"):
     The current modulefile will only load if **any** of the listed modules are already loaded.

**conflict** ("name1", "name2"):
     The current modulefile will only load if all listed modules are NOT loaded.

**extensions** ("numpy/2.1, scipy/3.2, foo/1.3"):
     This module provides the following extensions. Place the list of
     extensions as a single string.

**requireFullName** ():
     This function throws an error if module name specified by the
     user is not the fullName. Typically used as::

        if (mode() == "load") then requireFullName() end

**haveDynamicMPATH** ():
     This function tells that Lmod that this module has a dynamic
     $MODULEPATH when building the spider cache.  See
     :ref:`spider_tool-label` for details.

Extra functions
~~~~~~~~~~~~~~~

The entries below describe several useful commands that come with Lmod that can be used in modulefiles.

**os.getenv** ("NAME"):
    Get the value for the environment variable called "NAME". Note that if 
    "NAME" is not set in the environment, then it is probably best
    to do::

       local foo=os.getenv("FOO") or ""

    otherwise ``foo`` will have the value of ``nil``.

**os.exit(number)**:
    Exits a modulefile.  Note that no environment variables are
    changed when this command is evaluated.

**capture** ("string"):
    Run the "string" as a command and capture the output.  This
    function uses the value of LD_PRELOAD and LD_LIBRARY_PATH found
    when Lmod is configured. Use **subprocess** if you wish to use the
    current values. There may be a trailing newline in the result which is your
    responsibility to remove or otherwise handle.::

       local nprocs = capture("nprocs"):gsub("\n$","")

**subprocess** ("string")
    Run the "string" as a command and capture the output.  There may
    be a trailing newline in the result which is your responsibility
    to remove or otherwise handle. 

**isFile** ("name"):
    Returns true if "name" is any file type except directory.

**isDir** ("name"):
    Returns true if "name" is a directory.

**splitFileName** ("name"):
    Returns both the directory and the file name. ``local d,f=splitFileName("/a/b/c.ext")``. Then ``d="/a/b"``, ``f="c.ext"``

**LmodMessage** ("string", ...):
    Prints a message to the user.

**LmodWarning** ("string", ...):
    Prints a warning message to the user.

**LmodError** ("string", "..."):
    Print Error string and exit without loading the modulefile.

    **Note** that LmodError() is treated as a warning when unloading
    as of Lmod 8.6.16

**mode** ():
    Returns the string "load" when a modulefile is being loaded,
    "unload" when unloading, and "spider" when a modulefile is
    processed builting the spider cache which is used by *module
    avail* and *module spider*.

**isloaded** ("NAME"):
    Return true when module "NAME" is loaded or is in the middle of a
    load. Use isPending() to distinguish between loaded or pending.
    

**isPending** ("NAME"):
    Return true when module "NAME" is in the middle of a load().
    This function is rarely needed.  It can be useful when checking
    if one depends_on() package is currently being loaded.


**isAvail** ("NAME"):
    Return true when "NAME" is possible to load.  Note that it
    probably better to use the **try_load** () instead::

       if ( not isloaded("foo") ) then try_load("foo") end
      
      

**LmodVersion** ():
    The version of lmod.

**convertToCanonical** ("string"):
    A modulefile can use this function to know if an Lmod feature is
    supported::

      if (convertToCanonical(LmodVersion()) < convertToCanonical("8.6") ) then
        LmodMessage("The function source_sh() is not supported")
      end


**execute** {cmd="*<any command>*", modeA={"load"}}
    Run any command with a certain mode.  For example
    **execute** {cmd="ulimit -s unlimited",modeA={"load"}} will run
    the command **ulimit -s unlimited** as the last thing that the
    loading the module will do.


Modifier functions to prereq and loads
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**atleast** ("name", "version"):
    This modifier function will only succeed if the module is
    "version" or newer. See the between function for adding a "<" to
    modify the search criteria.

**between** ("name", "v1", "v2"): This modifier function will only
    succeed if the module's version is equal to or between "v1" and
    "v2". Note that version "1.2" is the same as "1.2.0.0.0....".
    This means that between("foo","2.7","3.0") would include "foo/3.0"
    but not "foo/3.0.0.1".  You can add a "<" to either the lower or
    upper version boundary to specify less than instead of "<=".  So
    between("foo","2.7<","<3.0") would want any module greater than 2.7
    and less than 3.0.

**latest** ("name"):
    This modifier function will only succeed if the module has the
    highest version on the system.


Introspection Functions
~~~~~~~~~~~~~~~~~~~~~~~

The following functions allow for more generic modulefiles by finding
the name and version of a modulefile.

**myModuleName** ():
   Returns the name of the current modulefile without the version.

**myModuleVersion** ():
   Returns the version of the current modulefile.

**myModuleFullName** ():
   Returns the name and version of the current modulefile.

**myModuleUsrName** ():
   Returns the name the user specified to load a module.  So it could be the name or the name and version.

**myFileName** ():
   Returns the absolute file name of the current modulefile.

**myShellName** ():
   Returns the name of the shell the user specified on the
   command line.

**myShellType** ():
   Returns the shellType based on the name of the shell the user
   specified on the command line. It returns sh for sh, bash, zsh,
   csh for csh, tcsh. Otherwise it is the same as **myShellName** ().


**hierarchyA** ("fullName", level):
   Returns the hierarchy of the current module.  See the section on
   Generic Modules for more details.

Math Functions
~~~~~~~~~~~~~~

**math.floor** (): math floor function

**math.ceil** (): math ceil function

**math.max** (): math max function

**math.min** (): math min function


Special Functions
~~~~~~~~~~~~~~~~~

**inherit** (): imports the contents of exact same name module also
   found in the module tree. (See :ref:`inherit-label` for an
   explanation.)
