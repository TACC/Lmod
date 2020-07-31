![Lmod Logo](https://github.com/TACC/Lmod/raw/master/logos/2x/Lmod-4color%402x.png)

[![Build Status](https://travis-ci.org/TACC/Lmod.svg?branch=master)](https://travis-ci.org/TACC/Lmod)
[![Documentation Status](https://readthedocs.org/projects/lmod/badge/?version=latest)](https://lmod.readthedocs.io/en/latest/?badge=latest)

# Lmod

Lmod is program to manage the user environment under Unix: (Linux, Mac OS X, ...).
It is a new implementation of environment modules.

## Lmod Web Sites

* Documentation:   http://lmod.readthedocs.org
* Github:          https://github.com/TACC/Lmod
* Sourceforge:     https://lmod.sf.net
* TACC Homepage:   https://www.tacc.utexas.edu/research-development/tacc-projects/lmod
* Lmod Test Suite: https://github.com/rtmclay/Lmod_test_suite

## Lmod Mailing list

* mailto:lmod-users@lists.sourceforge.net.

Please go to https://lists.sourceforge.net/lists/listinfo/lmod-users to join.

## Lmod Source Management

The most up-to-date source will be at github. All known bugs have
been fixed if it is released on github.  When there has been
sufficient improvement or important bugfixes there is a new
release at sourceforge.

## ChangeLog


### Lmod 8.4:

Features:

   1. Support for Lua 5.4 added.

   2. Improved support for ksh and ksh scripts.
   
   3. Improved documentation for software hierarchy and community module collections.

Bug Fixes:

   1. Handle exit in TCL modulefile; Handle os.exit() when performing spider

   2. Now handles /bin/dash startup.

   3. Support improved for fish shell
   

### Lmod 8.3:

Features:

   1. The function extensions() now takes a string of comma separated names.  This is to get around the number of arguments limit in Lua.

   2. Add support for "atleast()" and "between()" functions support a "<" to signify a less than instead of less than or equal to between range.

Bug Fixes:

   1. Make "ml - foo" an error.

   2. It is now safe to have os.exit(1) in a modulefile. Spider can now handle it.

### Lmod 8.2:

Features:

   1. Better support for the fish shell including tab completion (Thanks Alberto!)

   2. New function extensions(): This allows for modules like python to report that the extensions  numpy and scipy are part of the modules. Users can use "module spider numpy" to find which modules provide numpy etc.
      
   3. Added a new command "clearLmod" which does a module purge and removes all LMOD aliases and environment variables.

Bug Fixes:

   1. Remove asking for the absolute path for generating spiderT and dbT. It now only use when building the reverseMapT.

   2. Lmod now requires "rx" other access when searching for modulefiles.

   3. settarg correctly handles a power9 processor running linux.

### Lmod 8.1:

Features:

   1. Extended Default feature added: module load intel/17 will find the "best" intel/17.* etc.

   2. All hidden files are NOT written to the softwarePage output.

Bug Fixes:

   1. Lmod now correctly reports failed to load module "A" in the special case where "ml A B" and A is a prereq of B and A doesn't exist.

   2. A meta module takes precedence over a regular module if the meta module occurs in an earlier directory in $MODULEPATH

   3. Lmod output only "fills" when the text is more than one line or it is wider than the current width.


### Lmod 8.0:

Features:

   1. Embed the TCL interpreter in Lmod when a site allows TCL files

   2. "module reset" resets $MODULEPATH to be the system $MODULEPATH

   3. Improved tracing of module loads/unloads when --trace is given.

   4. Allow MODULERCFILE to be a colon separated list.

### Lmod 7.8:

Features:

   1. Always use ref. counting for MODULEPATH.

   2. Make LMOD_RC support a colon separated list of possible lmodrc.lua files.

   3. General support for "MODULERC" files written in lua.
   

Bug Fixes:

   1. Just use lua_json provided with Lmod distribution

   2. Change ml so that ml av --terse is an error.

   3. Allow sites to completely control prefix location of lmod.

   4. Support "make -j install"

### Lmod 7.7:

Features:

   1. Lmod now uses reference counting for PATH-like variables

   2. Support for MODULEPATH_INIT. If found use <install_dir>/init/.modulespath
      to specify initial MODULEPATH.

   3. Tracing now reports changes to MODULEPATH

   4. Support for ml keyword <prop_name> added

Bug Fixes:

   1. Lmod now uses the spider cache when restoring when LMOD_CACHED_LOAD=yes

   2. Lmod now supports a module with a single leading underscore. It reports an
      error if there are two or more.

### Lmod 7.6:

Features:

   1. Support for disable <collection_name>

   2. A marked default is honored even if it is hidden

   3. Support for depends_on() as a better way to handle module dependencies.

### Lmod 7.5:

Features:

   1. Added -T, --trace option to report restore, load, unloads and spider.

   2. Report both global and version aliases with module --terse
      Add Global Aliases output to module avail if they exist.

   3. Support for isVisibleHook (Thanks @wpoely86!) to control whether
      a module is hidden or not.

   4. Support for "spider -o spider-json" to set the key "hidden"
      to true or false for each module.

   5. Setting LMOD_EXACT_MATCH=yes also turns off the display of (D) with avail.

   6. CMake "shell" added.

   7. Added feature that LMOD_TMOD_FIND_FIRST.  A site can decide to force
      FIND_FIRST instead FIND_BEST for NV module layouts.

Bug Fixes:

   1. Fix bug where Lmod would be unable to load a module where NV and
      NVV module layouts were mixed.

   2. Fix bug where LMOD_CASE_INDEPENDENT_SORTING=yes wasn't case
      independent when using avail hook.

### Lmod 7.4:

Features:

   1. Using built-in luafilesystem if system version doesn't exist or < 1.6.2

   2. Support for setting LMOD_SYSHOST with configure.

   3. Sites or users can use italic instead of dim for hidden modules

   4. Detailed spider output reports all dependencies hidden or not.

   5. Support for fish shell

   6. Move almost all configuration variables from profile.in to bash.in and similarly for tcsh.

Bug Fixes:

   1. Fixed bug that caused LMOD env vars to be lower cased.

   2. Fixed bug where tcsh/csh exit status was not returned.
    
   3. bash and zsh tab completions works when LMOD_REDIRECT is yes.

   4. Can now conflict with a version.

   5. Fixed bug with addto a:b:c 

   6. Fixed bugs in computeHashSum, generating softwarePage.

### Lmod 7.3:

Bug Fixes:

   1. The isloaded() function has been repaired.

   2. Updated French, German and Spanish translations.

   3. Two error message related to missing modules are now available for translations.

### Lmod 7.2.1:

Features:

   1. A test suite for testing the Lmod installation has been added. See https://github.com/rtmclay/Lmod_test_suite for details.

   2. Added support for localization of errors and warnings and messages.

   3. Language Translations complete: ES, Partial: FR, ZH, DE

   4. Introduced "errWarnMsgHook" to take advantage of the new message handling.

Bug Fixes:

   1. Several bug fixes related to Spider Cache and LMOD_CACHED_LOADS=1

   2. Repaired zsh tab completion.

   3. Minimize the output of Lmod's BASH_ENV when debugging Bash shell scripts.

   4. Allow colons as well as spaces for the path used in the addto command.

   5. Handles module directories that are empty or bad symlink or a .version file only.

   6. Fix bug in module describe.

### Lmod 7.1:

Features:

   1. The commands "module --show_hidden avail" and "module --show_hidden" list now show "hidden" modules with the (H) property.  Also they are displayed as dim.  This works better on black backgrounds.

   2. Added the command "module --config_json" to generate a json output of Lmod's configuration.

   3. Add support for env. var. LMOD_SITE_NAME to set a site's name.  This is also a configure option.

Bug Fixes:

   1. Hidden module now will not be marked as default.

   2. Now check permission of a directory before trying to open it.

   3. Lmod now does not pollute the configure time value of LD_LIBRARY_PATH and LD_PRELOAD into the users env.

   4. Lmod now handles illegal values of $TERM.

### Lmod 7.0:

   1. This version support N/V/V. (e.g. fftw/64/3.3.4).  Put a .version file in with the "64" directory to tell Lmod where the version starts.

   2. Marking a default in the MODULERC is now supported.

   3. User ~/.modulerc has priority over system MODULERC.

   4. System MODULERC  has priority over marking a default in the module tree.

   5. Installed Modules can be hidden by "hide-version foo/3.2.1" in any modulerc file.

   6. The system spider cache has changed.  Please update your scripts to build spiderT.lua instead of moduleT.lua


For information to version changes for Lmod before 7.0 see [README.old](README.old)
