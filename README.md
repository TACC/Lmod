![Lmod Logo](https://github.com/TACC/Lmod/raw/master/logos/2x/Lmod-4color%402x.png)

[![Test Status](https://github.com/TACC/Lmod/actions/workflows/test.yml/badge.svg)](https://github.com/TACC/Lmod/actions)
[![Documentation Status](https://readthedocs.org/projects/lmod/badge/?version=latest)](https://lmod.readthedocs.io/en/latest/?badge=latest)

# Lmod

Lmod is program to manage the user environment under Unix: (Linux, Mac OS X, ...).
It is a new implementation of environment modules.

## Lmod Web Sites

* Documentation:   https://lmod.readthedocs.org
* GitHub:          https://github.com/TACC/Lmod
* SourceForge:     https://lmod.sf.net
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


### Lmod 8.7:

Features:

   1. Module unload can never fail: module eval errors are warning durning unload.

   2. break (in TCL) and LmodBreak (in Lua) are ignored during unload.

   3. In TCL puts stdout are now delayed until the end of the module evaluation. (Matches Tmod 4.1)

   4. In TCL puts prestdout are now printed out at the beginning of module output. (Matched Tmod 5.1)

Bug Fixes

   1. Convert "module swap n/v" to "module swap n n/v"

   2. *break* in TCL modules now breaks out of looks.  It only stops the evaluation of the current module when outside a loop.

   3. Many fixes to sh\_to\_module script and source_sh() function to better handle

   4. Support for depends_on(between()) repaired.

   5. The command "module avail" only shows extensions that are currently available rather than all modules.
   

### Lmod 8.6:

Features:

   1. New command "module overview" which lists names and the number of versions for each.

   2. Added spiderPathFilter hook so that sites can control which directories are ignored.
      
   3. updated sh\_to\_modulefile script to capture shell functions and shell aliases.

   4. New module function source_sh() to source a shell script inside a modulefile.

   5. Added new env. var. LMOD\_QUARANTINE\_VARS.  All names in this colon separated list cannot be changed by Lmod.
      
   6. New file /etc/lmod/lmod_config.lua is used to configure Lmod.

Bug Fixes:

   1. Changed docs to use the word "delim" instead of "sep".
   
### Lmod 8.5:

Features:

   1. New function added userInGroups(group1, group2, ...) to check to see if a user is in one of those groups.

   2. The variable ModuleTool and ModuleToolVersion are set in both TCL and Lua modules.  These variables are also defined in Tmod 4.7+

   3. Added option --no_extensions to module avail to not print extensions from avail.

   4. added module function requireFullName() (TCL require-fullname) to generate an error if not specifying  the full name of a module.
      
   5. Configure options --with-lua= and --with-luac added to specify full path to both commands.
      
   6. Adding isAvail() function for Lua modulefiles. Report error if is-avail command used in a TCL modulefile.

Bug Fixes:

   1. Fix the try_load() function to ignore failure to be found but report broken modules.
   
   2. Spider list of modules from spider skip .version* and .modulerc* files.
      
   3. Allow all paths (but MODULEPATH) to have trailing double slashes.

   4. The command module use converts relative paths to absolute paths.

   5. Make TCL system call run in place rather than with an execute via Lmod.

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



For information to version changes for Lmod before 8.0 see [README.old](README.old)
