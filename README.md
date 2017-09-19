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

### Lmod 6.6:

Features:

  1. Now uses the value of LD_PRELOAD and LD_LIBRARY_PATH found at configure time to run all TCL progams.

  2. Now uses a custom _module_dir function for tab completion in bash for module use path<TAB>. Thanks to Pieter Neerincx!

  3. Support for LMOD_FAMILY_<name>_VERSION added.

  4. If ~/.lmod.d/.cache/invalidated exists then the user cache file(s) are ignored. When generating a user cache file ~/.lmod.d/.cache/invalidated is deleted.

Bug Fixes:

  1. Correctly merges spider cache location where there are multiple lmodrc.lua files.

  2. Remove leading and trailing blanks for names in setenv, pushenv, prepend_path, etc.

  3. ml now generates error for unknown argument that start with a double minus. (e.g. ml --vers)

  4. pushenv("name","") fixed when unloading module.

  5. Make sure to regularize MODULEPATH when ingesting it for the first time.

### Lmod 6.5:

Features:

  1. All the Lmod programs now resolve any symlinks to the actual program before adding to the Lua's package.path and package.cpath.

  2. Contrib patch: Extend msgHook to LmodError and LmodWarning.

  3. Now using travis for CI and testing.

  4. Configure time option to have Lmod check for magic TCL string in modulefiles (#%Module)

Bug Fixes:

  1. The command "savelist" now only reports collections that match $LMOD_SYSTEM_NAME (install of all collections).

  2. A collection name now CANNOT have `.' in its name.

  3. Contrib patch: Get correct status in a capture in Lua 5.1.

  4. Contrib patch: Failback to /proc/sys/kernel/random/uuid if uuidgen isn't available.

  5. Contrib patch: Failback to shasum if sha1sum isn't available.

  6. Now uses the tclsh (and the LD_LIBRARY_PATH) found at configure time.

  7. Now searches for ps, basename, expr in /bin and /usr/bin when not using the locations found by configure

### Lmod 6.4:

Features:

   1. Lmod now uses a regular expression to match user commands to internal commands. For example "av", "ava" or "available" will match "avail".

Bug Fixes:

   1. Lmod now obeys LMOD_REDIRECT (or module --redirect) when using the --terse option.  This means that if LMOD_REDIRECT is set then module -t av will go to stdout instead of stderr.

   2. Lmod now does not resolve any symlinks when doing "module use <path>"

   3. LMOD_REDIRECT is now reported with --config option.

   4. Lmod would sometimes miss a symlink to a directory with module use.  This is now fixed.

   5. Lmod now correctly ignores a valid .version/.modulerc file that points to a non-existant modulefile.

   6. Allow the use of md5 -r as an alternative to sha1sum and md5sum

   7. Added uninstall target to Lmod.


### Lmod 6.3:

Bug Fixes:

   1. Lmod now uses the values of LUA_PATH and LUA_CPATH at configuration time.  This way Lmod is safe from user changes to these important Lua values.

### Lmod 6.2:

Bug Fixes:

   1. Updated documentation at lmod.readthedocs.org

   2. Support for generating xalt_rmapT.json used by XALT.

   3. Fixed bug with upcase characters in version file.

### Lmod 6.1:

Features:

   1. It is now possible to configure Lmod to use the spider cache when loading (`--with-cachedLoads=yes` or `export LMOD_CACHED_LOADS=1` to activate). This is off by default. Sites that use this will have to keep their spider caches up-to-date or user will not be able to load modules not in the cache.

   2. It is now possible to configure Lmod to use Legacy Version ordering (`--with-legacyOrdering=yes` or `export LMOD_LEGACY_VERSION_ORDERING=1`). With legacy ordering 9.0 is "newer" than 10.0. This is the ordering that Tmod uses.

   3. Lmod will print admin message (a.k.a nag messages) when doing module whatis <foo> or module help <foo>.  In other words if a nag message would appear with module load <foo> then it will also appear when using whatis or help.

   4. Many improvement in the generation of the lmod database for module tracking.

Bug Fixes:

   1. The command module spider would fail to find a module if a site had the spider cache file dbT.lua files and a user had personal modulefiles. This is now fixed.

   2. Two or more .version files could confused Lmod.  This is now fixed.

   3. Lmod can now find UPPER CASE string when doing "module key ..."

   4. Lmod now ignore the value of PAGER, instead it uses LMOD_PAGER (default "less") and LMOD_PAGER_OPTS (default "-XqRMEF").  This allows for consistent behavior under systems like the Cray and Mac OS X.

   5. Lmod now reports the module stack when loads fail.

   6. Set $LMOD_REVERSEMAPT_DIR after $LMOD_CACHE_DIR in update_lmod_system_cache_files.

   7. Support for exit 1 in tcl modulefiles.

   8. Fixed bug in tcl and unsetenv.

### Lmod 6.0.1:

Bug Fixes:

   1. This version now contains the contrib/tracking_module_usage directory.

   2. This version fixes a bug when trying to run module avail or module spider with an old cache file.


### Lmod Version 6.0

Features:

   1. Full support for global RC files as well as .modulerc files. This means that $MODULERCFILE will be read along with ~/.modulerc. Also .modulerc files are read when they appear in the same directory and the version files (i.e. the same directory as 1.2 or 2.1.lua). One caveat, Setting the default module version in $MODULERCFILE or ~/.modulerc is not supported due Spider cache issues.

   2. Instructions on how to save module usage data to a MySQL database along with scripts to analyze the usage are in contrib/tracking_module_usage/README.

   3. Adding an exit hook.  This makes for more accurate tracking of module usage. See README above as to why this is a good idea.

   4. Some minor speed-ups and minimizing of directory tree

For information to version changes for Lmod before 6.0 see [README.old](README.old)
