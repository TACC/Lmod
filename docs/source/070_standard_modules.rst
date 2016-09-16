Providing A Standard Set Of Modules for all Users
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Users can be provided with an initial set of modulefiles as part of
the login proceedure.  Once a list of modulefiles have been installed,
please create a file called StdEnv.lua and place it in the MODULEPATH
list of directories, typically
``/opt/apps/modulefiles/Core/StdEnv.lua``. The name is your choice,
the purpose is provide a standard list of modules that get loaded during
login. In ``StdEnv.lua`` is something like: ::

    load("name1","name2","name3")

Using the /etc/profile.d directory system described earlier to create a
file called ``z00_StdEnv.sh`` ::

    if [ -z "$__Init_Default_Modules" -o -z "$LD_LIBRARY_PATH" ]; then
       export __Init_Default_Modules=1;

       ## ability to predefine elsewhere the default list
       LMOD_SYSTEM_DEFAULT_MODULES=${LMOD_SYSTEM_DEFAULT_MODULES:-"StdEnv"} 
       export LMOD_SYSTEM_DEFAULT_MODULES
       module --initial_load restore
    else
       module refresh
    fi

Similar for z00_StdEnv.csh::

    if ( ! $?__Init_Default_Modules || ! $?LD_LIBRARY_PATH )  then
      setenv __Init_Default_Modules 1
      if ( ! $?LMOD_SYSTEM_DEFAULT_MODULES ) then
        setenv LMOD_SYSTEM_DEFAULT_MODULES "StdEnv"
      endif
      module --initial_load restore
    else
      module refresh
    endif

The z00_Stdenv.* names are chosen because the files in /etc/profile.d
are sourced in alphabetical order. These names guarantee they will run
after the module command is defined.

The first time these files are source by a shell they will set
``LMOD_SYSTEM_DEFAULT_MODULES`` to ``StdEnv`` and then execute
``module restore``.  Any subshells will instead call ``module
refresh``.  Both of these statements are important to get the
correct behavior out of Lmod.

The ``module restore`` tries to restore the user's default
collection.  If that doesn't exist, it then uses contents of the variable
``LMOD_SYSTEM_DEFAULT_MODULES`` to find a colon separated list of
Modules to load.


The ``module refresh`` solves an interesting problem.  Sub shells
inherit the environment variables of the parent but do not normally
inherit the shell aliases and functions.  This statement fixes this.
Under a "``refresh``", all the currently loaded modules are reloaded
but in a special way. Only the functions which define alias and shell
functions are active, all others functions are ignored.

The above is an example of how a site might provide a default set of
modules that a user can override with a default collection.  The
minimum required setup (for bash with z00_StdEnv.sh ) would be::

    if [ -z "$__Init_Default_Modules" -o -z "$LD_LIBRARY_PATH" ]; then
       export __Init_Default_Modules=1;

       module --initial_load restore   
    else
       module refresh
    fi

The module restore command still depends on the environment variable
LMOD_SYSTEM_DEFAULT_MODULES but that can be set somewhere else.
