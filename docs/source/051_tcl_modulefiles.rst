.. _tcl_modulefile_functions-label:

TCL Modulefile Functions
========================

Lmod reads modulefiles written in either Lua or TCL.  Lmod has to
interpret the TCL modulefiles into Lua and then evaluate the Lua
file.  So it is always faster to interpret Lua file rather than TCL
files.

Here are a list of TCL commands that are provided in addition to the
standard TCL language.

**add-property NAME value** :
   See :ref:`lmodrc-label` for how to use this command.

**always-load A B C** :
   Load one or more modules.  When this command is used in a
   modulefile that is being unloaded, this command has does nothing.
   See the **load** command for the 

**append-path NAME path** :
   Append **path** to environment variable **NAME**.  

**conflict A B** :
   The current modulefile will only load if all listed modules are NOT loaded.

**depends-on  A B** :
   Loads all modules.  When unloading only dependent modules are
   unloaded.  See :ref:`dependent_modules-label` for details.
   
**exit** *number* :
   Exits the module.  No changes in the environment occur if this
   command is found.

**extensions** "numpy/2.1 scipy/3.2" :
   This module provides the following extensions. Place the list of
   extensions as a single string.

**family NAME** :
   A user can only have one family "name" loaded at a time. For
   example family("compiler") would mean that a user could only have
   one compiler loaded at a time. 

**is-loaded NAME** :
   Return true when module "NAME" is loaded.

**module** *command* *args* :
   This command performs different actions depending on *command*:

   **add**  *A B* :
      load one or more modules

   **load**  *A B* :
      load one or more modules

   **try-load**  *A B* :
      load one or more modules but does not report an error
      if not found.

   **load-any** *A B* :
      load any one of the following modulefiles

   **swap** *A B* :
      unload *A* and load *B*

   **switch** *A B* :
      unload *A* and load *B*

   **unload** *A B* :
      unload one or more modules.

   **del** *A B* :
      unload one or more modules.

   **rm** *A B* :
      unload one or more modules.

   **use** *path* :
      Add *path* to MODULEPATH

   **unuse** *path* :
      remove *path* to MODULEPATH
   
**module-info** *string* :
   This command returns different things depending what *string* is:

   **mode** : is the current mode: "load", "remove" or "display"

   **shell** : The current shell specified by the user

   **shelltype** : It has the value of "sh", "csh", "perl", "python", "lisp", "fish", "cmake", or "r".

   **flags** : always returns 0

   **name**  : The fullname of the module.

   **user** : always returns 0.

   **symbols** : always returns 0.

   **specified** : User specified name on command line.

**module-whatis** *string* :
    The whatis command can be called repeatedly with different strings. 
    See the Administrator Guide for more details.

**prepend-path NAME path** :
   prepend to a path-like variable the value.

**prereq  A B**:
     The current modulefile will only load if **any** of the listed modules are already loaded.

**pushenv NAME** *value* :
   sets **NAME** to *value* just like **setenv**.  In addition it
   saves the previous value in a hidden environment variable.  This
   way the previous state can be returned when a module is unloaded.
   **pushenv** ("FOO",false) will clear "FOO" and the pop will return
   the previous value.

**remove-path NAME** *value* :
   remove value from a path-like variable for both load and unload modes.

**remove-property NAME** *value* :
   See :ref:`lmodrc-label` for how to use this command.

**reportError** *string* :
  Report an error and abort processing of the modulefile.

**require-fullname** :
  Reports an error if the user specified name is not the fullname of
  the module (e.g. **module load gcc/10.1** vs **module load gcc**.
  Typically used in TCL modulefile as follows::

      if { [ module-info mode load ] } {
          require-fullname
      }

**set-alias NAME** *value* :
  Define an alias to **NAME** with *value*.

**setenv NAME** *value* :
   Assigns to the environment variable "NAME" the value.  Do not use this
   function to assign the initial to a path-like variable.  Use
   **append_path** or **prepend_path** instead.

**unset-alias NAME** *value* :
   Removes the **NAME** alias.

**unsetenv NAME** *value* :
   unsets the **NAME** env. var.

**versioncmp** *version-string1* *version-string2* :
   Returns -1, 0, 1 if the version string are less-than, equal or
   greater than.  Note that this command knows that 1.10 is newer than
   1.8.

**is-avail** *name* :
  Return 1 if the name is available for loading, 0 if not. (As of Lmod 8.6+)


TCL Modulefile Functions NOT SUPPORTED
--------------------------------------

**atleast** :
   It is not possible to use the atleast function inside a TCL modulefile

**between** :
   It is not possible to use the between function inside a TCL modulefile

**latest** :
   It is not possible to use the latest function inside a TCL modulefile



TCL Global Variables
--------------------

The following TCL global variables are set inside modulefiles and
.modulerc and .version files.

**ModuleTool** : This is the string "Lmod". This works for Lmod
    8.4.8+.  This variable also exists in Tmod version 4.7 or greater
    and reports "Modules".

**ModuleToolVersion** : This is the current version of Lmod. This
    works for Lmod 8.4.8+ This variable also exists in Tmod version 4.7 or greater.

