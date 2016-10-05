How to Transition to Lmod (or how to test Lmod without installing it for all)
=============================================================================

In the :ref:`installing-lmod-label` document, we described how to
install Lua and Lmod for all.  Sites which are currently running
another environment module system will likely wish to test and then
transition from their old module system to Lmod. This can be smoothly
with changing all users on some Tuesday.

It is important to remember the following facts:

* Lmod reads modulefiles written in TCL.  There is typically no need
  to translate modulefiles written in TCL into Lua. Lmod does this for
  you automatically.  

* Some users can run Lmod while others use the old environment module
  system.

* However no user can run both at the same time in the same shell.


Obviously, since you are installing Lmod in your own account, this is
a good way to test Lmod without committing your site to switch.  Part
of this document will describe TACC's transition experience.

Steps for Testing Lmod in your account
--------------------------------------

#. Install Lua
#. Install Lmod in your account
#. Build the list modules required
#. Purge modules using old module command
#. Reload modules using Lmod


Install Lua
~~~~~~~~~~~

The previous document described how to install Lua.  If your system
doesn't provide package for Lua, then it is probably easy to
install the lua tarball found at sourceforge.net using the following
command::

    $ wget https://sourceforge.net/projects/lmod/files/lua-W.X.Y.Z.tar.gz

where you replace the *W.X.Y.Z* with the current version
(i.e. 5.1.4.8).

Many Linux distributions already have a lua package
and it may even be install automatically.  For example recent Centos
and other Redhat based distributions automatically install Lua as part
of the rpm tools.

Once you have lua installed and in your path.  You'll need
luafilesystem and luaposix libraries to complete the
requirements.  See the previous document on how to install these
libraries via your package manager or luarocks.


Install Lmod
~~~~~~~~~~~~

Please follow the previous document on how to install Lmod.  Let's
assume that you have installed Lmod in your own account like this::

   $ ./configure --prefix=$HOME/pkg
   $ make install

This will install Lmod in **$HOME/pkg/lmod/x.y.z** and make a
symbolic link to **$HOME/pkg/lmod/lmod**.


Build the list of modules required
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Many sites provide a default set of modules.  When testing, you'll
want to be able to load those list of modules using Lmod.   Using your
old module system, login and do::

    
    $ module list

    Currently Loaded Modules:

    1) a1      3) A     5) b2     7) B
    2) a2      4) b1    6) b3


It turns out that both the latest version of TCL/C modules and the
pure TCL script list a module that loads other modules later in the
list.  In this made up case we unload module B and notice that
unloading the B module also unloads modules b3, b2 and b1.  Then
unloading the A module also unloads modules a2 and a1.  In this case
then we would set::

   export LMOD_SYSTEM_DEFAULT_MODULES=A:B

Purge modules using old module command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Execute::

    $ module purge

to unload the currently loaded modules **using the old module command**.


Reload modules using Lmod
~~~~~~~~~~~~~~~~~~~~~~~~~

Once all modules have been purge and the environment variable
LMOD_SYSTEM_DEFAULT_MODULES has been set. All that are required are to redefine the 
module command to use Lmod and to restore the default
set of modules by::

    
    $ export BASH_ENV=$HOME/pkg/lmod/lmod/init/bash
    $ source $BASH_ENV

This will define the module command.  Finally the default set of
modules can be loaded.

    $ module --initial_load restore

This command first looks to see if there is a default collection in
**~/.lmod.d/default**. If that file isn't found then it uses the value
of variable LMOD_SYSTEM_DEFAULT_MODULES as a list of module to load.

If you have gotten this far then you have installed Lmod in your
account. Congratulations!

Please test your system.  Try to load your most complicated
modulefiles.  See if **module avail**, **module spider** works and so
on.

If you have trouble loading certain TCL modulefiles then read the
**How Lmod reads TCL modulefiles** to see why you might have problems.

An example of how this can be done in your bash startup scripts
---------------------------------------------------------------

All the comments above can be combined into a complete example::

    if [ -z "$_INIT_LMOD" ]; then
       export _INIT_LMOD=1           # guard variable is crucial, to avoid breaking existing modules settings
       type module > /dev/null 2>&1
       if [ "$?" -eq 0 ]; then
         module purge >2 /dev/null   # purge old modules using old module command.
         clearMT                     # clear the stored module table (wipe _ModuleTable001_ etc.)
       fi

       export MODULEPATH=...                         # define  MODULEPATH
       export BASH_ENV=$HOME/pkg/lmod/lmod/init/bash # Point to the new definition of Lmod

       source $BASH_ENV                              # Redefine the module command to point 
                                                     # to the new Lmod
       export LMOD_SYSTEM_DEFAULT_MODULES=...        # Colon separated list of modules
                                                     # to load at startup
       module --initial_load restore                 # load either modules listed above or the
                                                     # user's ~/.lmod.d/default module collection
    else
       source $BASH_ENV                              # redefine the module command for sub-shell
       module refresh                                # reload all modules but only activate the "set_alias" 
                                                     # functions.
    fi  

Obviously, you will have to define **MODULEPATH** and
**LMOD_SYSTEM_DEFAULT_MODULES** to match your site setup.
The reason for the guard variable **_INIT_LMOD** is that the module
command and the initialization of the modules is only done in the
initial login shell. On any sub-shells, the module command gets defined
(again).  Finally the **module refresh** command is called to define
any alias or shell functions in any of the currently loaded modules.


How to Transition to Lmod: Staff & Power User Testing
-----------------------------------------------------

Once you have tested Lmod personally and wish to transition your site
to use Lmod, I recommend the following strategy for staff and
friendly/power users for testing:

#. Install Lua and Lmod in system locations
#. Install */etc/profile.d/z00_lmod.sh* to redefine the module command
#. Load system default modules (if any) after previous steps
#. Only user who have a file named *~/.lmod* use Lmod
#. At TACC, we did this for 6 months.

Using this strategy, you can have extended testing  without
exposing Lmod to any user which hasn't opted-in.

How to Deploy Lmod
~~~~~~~~~~~~~~~~~~

Once Staff testing is complete and you are ready to deploy Lmod to
your users it is quite easy to switch to an opt-out strategy:

#. Change */etc/profile.d/z00_lmod.sh* so that everyone is using Lmod
#. If a user has a ~/.no.lmod then they continue to use your original
   module system
#. At TACC we did this for another 6 months
#. We broke Environment Module support with the family directive
#. We now only support Lmod
#. Both transitions generated very few tickets (2+2)

