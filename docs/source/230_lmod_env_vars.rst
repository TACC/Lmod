Controlling Lmod behavior through Environment Variables
=======================================================

Sites can control the behavior of Lmod via how lmod is configured.
To see all the configuration options you can execute::

  $ ./configure --help

in the Lmod source directory.  All of the configuration options can
also be overridden by environment variables as well as a few behavior
options that do not have a configuration option.

There two kinds of variables: (1) An explicit values; (2) a yes/no
variable.  An example of first kind is `LMOD_SITE_NAME`.  This
variable controls the site name (e.g. TACC). This value of variable is
used directly.  There is no change of case or any other changes.

The second kind of variable is an yes/no variable.  One example of
this is LMOD_IGNORE_CACHE.  When this variable is "yes", Lmod ignores
any cache files and walks MODULEPATH instead.

The following settings are considered "no".  Note that the string value
is lowercased first, so NO, No, and nO are the same as no. ALL OTHER
VALUES are treated as "yes".

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
  [path] If set this will be a file to specify the nag message.

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

**LMOD_TRACING**:
   [yes/no] If set to yes then Lmod will trace the loads/unloads while
   the module command is running.


Configuration time setting that can be overridden by env. vars.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following settings are defined by configure but can be overridden
by environment variables.  The brackets show the following values
[kind, default: value, configuration option] where kind is either
yes/no, string, path, etc, value is what the default will be.  Finally
the configuration option which will set the action.


**LMOD_ALLOW_TCL_MFILES**:
  [yes/no, default: yes, --with-tcl].  Allow tcl modulefiles.  Note
  that .version and .modulerc files still use the tcl interpreter. So
  setting this to no.

**LMOD_ANCIENT**:
  [number, default:86400, --with-ancient].  The number of seconds that
  the user's personal cache is considered valid.

**LMOD_AUTO_SWAP**:
  [yes/no, default: yes, --with-autoSwap] Allows Lmod to swap
  any modules that use the family function such as compilers and mpi
  stacks. 

**LMOD_CACHED_LOADS**:
  [yes/no, default:no, --with-cachedLoads] If true then Lmod will use
  the spider cache instead of walking MODULEPATH as long as
  LMOD_IGNORE_CACHE is not set.

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
  stderr. Turning redirect to "yes" will cause these message to be  
  written to stdout.  Note this only works for bash and zsh.  This
  will not work with csh or tcsh as there is a problem with these
  shells and not Lmod.

**LMOD_SHORTTIME**:
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
  to help with module tracking.  See contrib/tracking_modules_usage/*
  for details.

**LMOD_TMOD_PATH_RULE**:
  [yes/no, default: no, --with-tmodPathRule].  Normally Lmod
  prepend/appends  a directory in the beginning/end of the path like
  variable. If this is true then if path entry is already there then
  do not prepend/append.

**LMOD_USE_DOT_FILES**:
  [yes/no, default: yes, --with-useDotFiles] If yes then use
  ~/.lmod.d/.cache, if no then use ~/.lmod.d/__cache__
