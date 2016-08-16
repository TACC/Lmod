                      Lmod
                      ----

Lmod is program to manage the user environment under Unix: (Linux, Mac OS X, ...).
It is a new implementation of environment modules.

                  Lmod Web Sites
                  -------------

Documentation: http://lmod.readthedocs.org
Github:        https://github.com/TACC/Lmod
Sourceforge:   https://lmod.sf.net
TACC Homepage: https://www.tacc.utexas.edu/research-development/tacc-projects/lmod

                 Lmod Mailing list
                 -----------------

lmod-users@lists.sourceforge.net.
Please go to https://lists.sourceforge.net/lists/listinfo/lmod-users to join.

               Lmod Source Management
               ----------------------

The most up-to-date source will be at github. All known bugs have
been fixed if it is released on github.  When there has been
sufficient improvement or important bugfixes there is a new
release at sourceforge.

                   ChangeLog
                   ---------

Lmod 6.5:
Features:
  a) All the Lmod programs now resolve any symlinks to the
     actual program before adding to the Lua's package.path
     and package.cpath.
  b) Contrib patch: Extend msgHook to LmodError and LmodWarning
  c) Now using travis for CI and testing.
  d) Configure time option to have Lmod check for magic TCL string in
     modulefiles (#%Module)

Bug Fixes:
  a) The command "savelist" now only reports collections that
     match $LMOD_SYSTEM_NAME (install of all collections)
  b) A collection name now CANNOT have `.' in its name.
  c) Contrib patch: Get correct status in a capture in
     Lua 5.1.
  d) Contrib patch: Failback to /proc/sys/kernel/random/uuid 
     if uuidgen isn't available.
  e) Contrib patch: Failback to shasum if sha1sum isn't
     available.
  f) Now uses the tclsh (and the LD_LIBRARY_PATH) found at
     configure time.
  g) Now searches for ps, basename, expr in /bin and /usr/bin
     when not using the locations found by configure



Lmod 6.4:
Features:
   a) Lmod now uses a regular expression to match user commands
      to internal commands. For example "av", "ava" or "available"
      will match "avail"

Bug Fixes
   a) Lmod now obeys LMOD_REDIRECT (or module --redirect)
      when using the --terse option.  This means that if
      LMOD_REDIRECT is set then module -t av will go to
      stdout instead of stderr.

   b) Lmod now does not resolve any symlinks when doing
      "module use <path>"

   c) LMOD_REDIRECT is now reported with --config option.

   d) Lmod would sometimes miss a symlink to a directory
      with module use.  This is now fixed.

   e) Lmod now correctly ignores a valid .version/.modulerc
      file that points to a non-existant modulefile.

   f) Allow the use of md5 -r as an alternative to sha1sum and md5sum

   g) Added uninstall target to Lmod.


Lmod 6.3:
Bug Fixes:
   a) Lmod now uses the values of LUA_PATH and LUA_CPATH at
      configuration time.  This way Lmod is safe from user changes
      to these important Lua values.
Lmod 6.2:
Bug Fixes:
   a) Updated documentation at lmod.readthedocs.org
   b) Support for generating xalt_rmapT.json used by XALT.
   c) Fixed bug with upcase characters in version file.

Lmod 6.1:
Features:
   a) It is now possible to configure Lmod to use the spider cache
      when loading (--with-cachedLoads=yes or
      export LMOD_CACHED_LOADS=1 to activate). This is off by
      default. Sites that use this will have to keep their spider
      caches up-to-date or user will not be able to load modules
      not in the cache.
   b) It is now possible to configure Lmod to use Legacy Version
      ordering ( --with-legacyOrdering=yes or export
      LMOD_LEGACY_VERSION_ORDERING=1). With legacy ordering 9.0
      is "newer" than 10.0. This is the ordering that Tmod uses.
   c) Lmod will print admin message (a.k.a nag messages) when
      doing module whatis <foo> or module help <foo>.  In other
      words if a nag message would appear with module load <foo>
      then it will also appear when using whatis or help.
   d) Many improvement in the generation of the lmod database for
      module tracking.
Bug Fixes:
   a) The command module spider would fail to find a module if a
      site had the spider cache file dbT.lua files and a user
      had personal modulefiles. This is now fixed.
   b) Two or more .version files could confused Lmod.  This
      is now fixed.
   c) Lmod can now find UPPER CASE string when doing
      "module key ..."
   d) Lmod now ignore the value of PAGER, instead it uses
      LMOD_PAGER (default "less") and LMOD_PAGER_OPTS
      (default "-XqRMEF").  This allows for consistent behavior
      under systems like the Cray and Mac OS X.
   e) Lmod now reports the module stack when loads fail.
   f) Set $LMOD_REVERSEMAPT_DIR after $LMOD_CACHE_DIR in
      update_lmod_system_cache_files.
   g) Support for exit 1 in tcl modulefiles.
   h) Fixed bug in tcl and unsetenv.

Lmod 6.0.1:
Bug Fixes:
   a) This version now contains the contrib/tracking_module_usage
      directory.
   b) This version fixes a bug when trying to run module avail
      or module spider with an old cache file.


Lmod Version 6.0
Features:
   a) Full support for global RC files as well as .modulerc files.
      This means that $MODULERCFILE will be read along with
      ~/.modulerc. Also .modulerc files are read when they appear
      in the same directory and the version files (i.e. the same
      directory as 1.2 or 2.1.lua). One caveat, Setting the default
      module version in $MODULERCFILE or ~/.modulerc is not
      supported due Spider cache issues
   b) Instructions on how to save module usage data to a MySQL
      database along with scripts to analyze the usage are in
      contrib/tracking_module_usage/README.
   c) Adding an exit hook.  This makes for more accurate tracking of
      module usage. See README above as to why this is a good idea.
   d) Some minor speed-ups and minimizing of directory tree

For information to version changes for Lmod before 6.0 see README.old
