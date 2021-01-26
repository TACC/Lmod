.. _modulerc-label:

=============================================================
Site and user control of defaults, aliases and hidden modules
=============================================================

Lmod uses a **.modulerc.lua** or **.modulerc** file to control the
default version and other things as describe in
:ref:`setting-default-label`.  Lmod also allows sites to control the
defaults, aliases and hidden modules from a system location.  Also
users can override these defaults and add new aliases and hidden
modules via a personal **~/.modulerc.lua** or **~/.modulerc** file.
Note that lua files always take priority over non-lua files.

A default can be specified in three ways:

#. **default**, **.version**,  **.modulerc.lua** or **.modulerc** file
   in the module tree as describe earlier.
#. One or more system MODULERC files: $LMOD_MODULERCFILE or $MODULERC or <INSTALL_DIR>/../etc/rc.lua
#. A **~/.modulerc.lua** or **~/.modulerc**

The highest priority for defaults are the user MODULERC files, followed by the
system MODULERC file(s) and the lowest priority are the files in the
module tree.  In other words a user or system MODULERC file can
override the default modules.

All lua modulerc files support the following commands:

**module_version** ("known_version","default"):
   This command marks a known version to be the default.  If there are
   duplicates, the last one applies.

**module_version** ("known_version","alias"):
   The known version can be also known as the alias. For example:
   module_version("ab/7.4", "7") means that the ab/7.4 and ab/7 names
   the same modulefile.

**module_alias** ("alias", "known_version"):
   An alias can be used as a global alias. For example:
   module_alias("z13", "z/13.0.1") says that "module load z13" will
   load the "z/13.0.1" modulefile.

**hide_version** ("fullName"):
   This command will hide all "fullName" modules. So if there are
   multiple phdf5/1.8.6 module, then all will be marked as hidden.

**hide_modulefile** ("full_path"):
   This command will hide just one module located at "full_path"
   modules. This way only modulefile can be hidden.

The TCL files support similar commands:

**module-version** known_version default
  see module_version() above.

**module-version** known_version alias
  see module_version() above.

**module-alias** alias known_version
  see module_alias() above.

**hide-version** fullName 
  see hide_version above.

**hide-modulefile** full_path
  see hide-modulefile above.


System MODULERC files
^^^^^^^^^^^^^^^^^^^^^

By default, Lmod looks in /path_to_lmod/lmod/../etc/rc.lua or
/path_to_lmod/lmod/../etc/rc to find a system MODULERC file.  The lua
file takes precedence over the TCL version. Or you
can set either **LMOD_MODULERCFILE** or **MODULERCFILE** to be a
single file or a colon separated list.  If more than one file is
specified then the priority is left to right. 
