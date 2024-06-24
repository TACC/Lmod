.. _env_vars-label:

Configuring Lmod for your site
==============================

Sites can control the behavior of Lmod at configuration time.  After
Lmod is configured and installed, user can also modify the behavior
through environment variables. To see all the configuration options
you can execute:: 

  $ ./configure --help

in the Lmod source directory.  There are a few behavior options that
do not have a configuration option.

There two kinds of variables: (1) An explicit values; (2) a yes/no
variable.  An example of first kind is `LMOD_SITE_NAME`.  This
variable controls the site name (e.g. TACC). This value of variable is
used directly.  There is no change of case or any other changes in
that string.

The second kind of variable is an yes/no variable.  One example of
this is LMOD_IGNORE_CACHE.  When this variable is "yes", Lmod ignores
any cache files and walks MODULEPATH instead.

The following settings are considered "no".  Note that the string value
is lowercased first, so NO, No, and nO are the same as no. ALL OTHER
VALUES are treated as "yes" such as "1", or "on".

#. export LMOD_IGNORE_CACHE=""
#. export LMOD_IGNORE_CACHE=0
#. export LMOD_IGNORE_CACHE=no
#. export LMOD_IGNORE_CACHE=off

Environment variables only
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following variables set actions that can only be controlled by
environment variables.  The actions can not be controlled through the
configuration step.

**LMOD_ADMIN_FILE**:
  [path] If set this will be a file to specify the nag message. If
  this variable has no value, then Lmod looks for
  ``<install_dir>/../etc/admin.list`` 

**LMOD_AVAIL_STYLE**:
  Used by the avail hook to control how avail output
  is handled.   This is a colon separated list of
  names.  Note that the default choice is marked by
  angle brackets:  A:B:<C> ==> C is the default.
  If no angle brackets are specified then the first
  entry is the default (i.e. A:B:C => A is default).
  See :ref:`avail_style` for more details.

**LMOD_IGNORE_CACHE**:
  [yes/no] If set to yes then Lmod will bypass all cachefile and walk
  the directories in MODULEPATH instead.

**LMOD_PAGER**:
  [string] Lmod uses a pager when not using redirect.  It defaults to
  less.  Site/Users can turn off the pager if it is set to "None".

**LMOD_RTM_TESTING**:
  [any value] If this variable has any value it means that Lmod does
  nothing.  This is useful when testing a personal copy of Lmod and
  your site has the SHELL_STARTUP_DEBUG package installed so that the
  invoking of the module command in the system startup will a no-op.

**LMOD_SYSTEM_NAME**:
  [string] This variable is used to where a site is using shared home
  files systems. See :ref:`shared_home_file_system` for more details.

**LMOD_SYSTEM_DEFAULT_MODULES**:
  [string] This variable to define a list of colon separated standard
  modules when the **module reset** command is issued by or for the
  user.  If a site has no default modules then they should set this
  module to **__NO_SYSTEM_DEFAULT_MODULES__**.

**LMOD_TRACING**:
   [yes/no] If set to yes then Lmod will trace the loads/unloads while
   the module command is running.

**LMOD_MODULERC**:
   Also **LMOD_MODULERCFILE** and **MODULERCFILE** can be used.  They
   all are used the same way but **LMOD_MODULERC** is used before the
   other two vars.  The contents of one of these environment variables
   is to be a single file or a colon separated list of files or
   directories to be used to specify the system MODULERC file(s).

   If a directory is specified then all the files in that directory
   are assumed to be MODULERC files.
   See :ref:`modulerc-label` for more details.


**LMOD_QUARANTINE_VARS**:
   A colon separated list of environment variables that Lmod will not
   change. Note that only non-path like variable can be added to this
   list. Having variables like PATH and LD_LIBRARY_PATH  in this list
   are ignored.  In other words, they can be changed by Lmod. New in
   Version 8.6+.


Configuration time settings that can be overridden by env. vars.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following settings are defined by configure but can be overridden
by environment variables.  The brackets show the following values
[kind, default: value, configuration option] where kind is either
yes/no, string, path, etc, value is what the default will be.  Finally
the configuration option which will set the action.


**LMOD_ALLOW_TCL_MFILES**:
  [yes/no, default: yes, --with-tcl].  Allow tcl modulefiles.  Note
  that .version and .modulerc files still use the tcl interpreter. So
  setting this to no means that your site will have to use either the
  "default" symlink or ".modulerc.lua" to specify defaults.

**LMOD_ANCIENT_TIME**:
  [number, default:86400, --with-ancient].  The number of seconds that
  the user's personal cache is considered valid.

**LMOD_AUTO_SWAP**:
  [yes/no, default: yes, --with-autoSwap] Allows Lmod to swap
  any modules that use the family function such as compilers and mpi
  stacks. 

**LMOD_AVAIL_EXTENSIONS**:
  [yes/no, default: yes, --with-availExtensions] Display package
  extensions when doing "module avail".

**LMOD_BASH_INITIALIZE**:
  [yes/no, default:yes, --with-bashInitialize] If "yes" then Lmod will
  disable file globbing when eval'ing the output from Lmod.

**LMOD_CASE_INDEPENDENT_SORTING**:
  [yes/no, default: no, --with-caseIndependentSorting] Make avail and
  spider use case independent sorting.

**LMOD_COLORIZE**:
  [yes/no, default: yes, --with-colorize] Let lmod write colorize
  message to the terminal.

**LMOD_DISABLE_NAME_AUTOSWAP**:
  [yes/no, default: no, --with-disableNameAutoSwap] Setting this to
  "yes" disables the one name rule autoswapping.  In other words,
  "module load gcc/4.7 gcc/5.2 will fail when this is set.

**LMOD_DUPLICATE_PATHS**:
  [yes/no, default: no, --with-duplicatePaths] Allow duplicates
  directories in path-like variables, PATH, LD_LIBRARY_PATH, ...
  Note that if LMOD_TMOD_PATH_RULE is "yes" then LMOD_DUPLICATE_PATH
  is set to "no".

**LMOD_DYNAMIC_SPIDER_CACHE**:
  [yes/no, default: yes, --with-dynamicSpiderCache] Allow Lmod to
  re-evaluate modules that change $MODULEPATH that are already in the
  system spider cache. This will allow for user modulefiles that are
  in a matching software hierarchy.  There is a small speed cost to
  support this feature. Sites that do not use this feature may wish to
  disable this.

**LMOD_EXTENDED_DEFAULT**:
  [yes/no, default: yes, --with-extendedDefault] Allow users to
  specify a partial match of a version. So abc/17 will try to match
  the "best" abc/17.*.*

**LMOD_EXACT_MATCH**:
  [yes/no, default: no, --with-exactMatch] Requires Lmod to use
  fullNames for modules.  This disables defaults.

**LMOD_HIDDEN_ITALIC**:
  [yes/no, default: no, --with-hiddenItalic] Use italics for hidden
  modules instead of faint.

**LMOD_MPATH_AVAIL**:
  [yes/no, default: no, --with-mpathSearch] If this is set then module
  avail <string> will search modulepath names.

**LMOD_OVERRIDE_LANG**:
  [string, default: en, --with-lang] Override $LANG for Lmod
  error/messages/warnings.

**LMOD_PIN_VERSIONS**:
  [yes/no, default: no, --with-pinVersions] If yes then when restoring
  load the same version that was chosen with the save, instead of the
  current default version.

**LMOD_PREPEND_BLOCK**:
  [normal/reverse, default: normal, --with-prependBlock] Treat
  multiple directories passed to prepend in normal order and not
  reversed. 

**LMOD_REDIRECT**:
  [yes/no, default: no, --with-redirect].  Normal messages generated
  by  "module avail", "module list",etc write the output to
  stderr. Turning redirect to "yes" will cause these messages to be  
  written to stdout.  Note this only works for bash and zsh.  This
  will not work with csh or tcsh as there is a problem with these
  shells and not Lmod.

**LMOD_SHORT_TIME**:
  [number, default: 2, --with-shortTime].  If the time to build the
  spider cache takes longer than this number then write the spider
  cache out into the user's account.  If you want to prevent the
  spider cache file being written to the user's account then set this
  number to be large, like 86400.

**LMOD_SITE_MSG_FILE**:
  [full path, default: <nil> --with-siteMsgFile] The Site message file.
  This overrides the messageDir/en.lua file so that sites can replace
  some or all Lmod messages.

**LMOD_SITE_NAME**:
  [string, default: <nil>, --with-siteName].  This is the site name,
  for example TACC, and not the name of the cluster.  This is used
  with the family function.

**LMOD_SYSHOST**:
  [string, default: <nil>, --with-syshost].  This variable can be used
  to help with module tracking.  See :ref:`tracking_usage` for details.

**LMOD_TMOD_FIND_FIRST**:
  [yes/no, default: no, --with-tmodFindFirst].  Normally Lmod uses the
  FIND BEST rule to search for defaults when searching C/N/V or N/V
  module layouts.  A site can force FIND_FIRST for C/N/V or N/V module
  layouts to match the FIND_FIRST rule for N/V/V module layout.  See
  :ref:`NVV-label` for more details.

**LMOD_TMOD_PATH_RULE**:
  [yes/no, default: no, --with-tmodPathRule].  Normally Lmod
  prepend/appends  a directory in the beginning/end of the path like
  variable. If this is true then if path entry is already there then
  do not prepend/append.  Note that if LMOD_TMOD_PATH_RULE is "yes"
  then LMOD_DUPLICATE_PATH is set to "no".

**LMOD_USE_DOT_CONFIG_ONLY**:
  [yes/no, default: no, --with-useDotConfigDirOnly].  Lmod is
  transitioning from using ~/.lmod.d/ to ~/.config/lmod to store
  collections. By default, Lmod writes to both directories and read
  the most recent collection from either directory.  By changing this
  configuration option to yes, then Lmod will write only to
  ~/.config/lmod but will check both directories when reading picking
  the most recent one.

Configuration or cosmic:assign() at startup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**LMOD_DOWNSTREAM_CONFLICTS**:
  [yes/no, default: no, --with-downstreamConflicts] If yes then
  the conflict() function are also remembered to block future module
  loads. 


Configuration only settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~

--**with-silentShellDebugging**:
  [yes/no, default: no] If yes then the module command will silence its output under shell debug.

--**with-mode=MODE**:
  By default Lmod uses your umask to control the permission unless
  your user id (i.e. id -u) is less than 500.  If your id is less than
  500 then it uses a umask of 022.  This translates to use permission
  of 755 for executables and 644 for all other files.  Sites may wish
  to install with  different permission.  For example 750,
  or 700. Remember to set the execute bit.  It will be removed for
  non-executable files.
  
.. _lmod_config-label:


Configuring Lmod with **/etc/lmod/lmod_config.lua**:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lmod looks for a file named lmod_config.lua in the LMOD_CONFIG_DIR,
which is by default /etc/lmod/. So normally the file is found here:
/etc/lmod/lmod_config.lua.  It can be configured to any value with the
configure option (--with-lmodConfigDir=) or setting the environment
variable LMOD_CONFIG_DIR.  This file is used optionally.  It is not
required.

This file allows sites configure Lmod through Lua instead
of setting environment variables for each shell. By using the
cosmic:assign() functions this can be accomplished in one file.
Here is a full example::

    require("strict")
    local cosmic       = require("Cosmic"):singleton()

    cosmic:assign("LMOD_SITE_NAME",   "XYZZY")

    -- Note that this directory could be anything including /etc/lmod
    cosmic:assign("LMOD_PACKAGE_PATH", "/path/to/SitePackage_Dir/")

    local function echoString(s)
       io.stderr:write(s,"\n")
    end

    sandbox_registration {
       echoString = echoString
    }

In the above example a site is setting its name and providing the path
to the location directory where the SitePackage.lua file is.  Also the
simple **echoString** function has been added and is callable from
modulefiles because it has been registered in the sandbox.


Sites wishing to change the default values of other Lmod configuration
variables should study the src/myGlobals.lua file to see what the name
of the variable is and then use the cosmic:assign() function to set
the new value.  For example::

    cosmic:assign("LMOD_PIN_VERSIONS","yes")
    cosmic:assign("LMOD_CACHED_LOADS","yes")
    ...


To check that your installation is correct please run::

    $ module --config

to see that you got what you wanted.
