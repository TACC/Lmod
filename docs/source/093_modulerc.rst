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
#. One or more system modulerc files: $LMOD_MODULERC or $MODULERC or <INSTALL_DIR>/../etc/rc.lua
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
   See the isVisible hook in :ref:`hooks` to do more complicated hiding.

**hide_modulefile** ("full_path"):
   This command will hide just one module located at "full_path"
   modules. This way only modulefile can be hidden.  Note that the
   "full_path" doesn't have to include the .lua extension.
   See the isVisible hook in :ref:`hooks` to do more complicated hiding.

The above functions are the only functions support in .modulerc.lua
files. In particular, Lmod functions like setenv(), pushenv() are not supported.

===========================================
hide{}: a more powerful way to hide modules
===========================================

Lmod (8.8+) supports hide{} and forbid{} function calls control how
modules can be accessed.  The hide{} and forbid{} functions are
specified in the .modulerc.lua files in the location where the modules
are located or in LMOD_MODULERC location.
This function controls how hidden a module is from being displayed
with "module list",  "module avail" or "module spider".

This function takes a table.  That is why it uses curly braces {}
instead of parentheses ().  Here is the calling description::

   hide{name="<sn/fullName/fn>",
        kind="hidden|soft|hard",
        before="YYYY-MM-DDTHH:MM",
        after="YYYY-MM-DDTHH:MM",
        userA={"u1","u2",...},
        groupA={"g1","g2",...},
        notUserA={"u1","u2",...},
        notGroupA={"g1","g2",...},
        hidden_loaded=true,
        }

Where the **name** could be name could be the shortName (sn) like
"gcc" or the fullName such as "gcc/13.1" or the full path to the
modulefile (fn).  If the shortname is used then all versions will be
hidden. the **name** key is the only one required, all others have
default values.  Note that **name** can take a list of module names by
doing::

    hide{name={"moduleA","moduleB"},...}

where **name** values can be sn or fullName or fn.

The **kind** key has three possible values "hidden" or "soft" or
"hard".  The "hidden" value is default.  The "hard" value means that
the modulefile exists but it cannot be shown by "module avail" or
"module spider" nor can it be accessed in any way even when the
**--show_hidden** option is given. It doesn't exist.  A "hidden" or
"soft" module is not shown by avail or spider unless the
**--show_hidden** or **--all** option is given on the command line.  A
"hidden" or "soft" module can be loaded directly by its fullName. A
special feature of "soft" module can be shown in the following
scenario::

    foo
      ├── 1.0.lua 
      └── 2.0.lua <soft>

Then "module load foo" will load "foo/2.0".  Where as hidden are not
picked as the "highest".  So "module load bar" would load "bar/1.0"::

    bar
      ├── 1.0.lua 
      └── 2.0.lua <hidden>
      

not "bar/2.0".

The **before** and **after** keys use a time string of the form
"YYYY-MM_DDTHH:MM".  The "THH:MM" can be dropped and Lmod assumes
"T00:00".  Note that Lmod will have to be updated in the year 10000.
The **before** key says a modulefile will be hidden until some future
date.  The **after** flag can be used to mark a module as hidden at a
future time. If the current time is later than the **before** time and
before the **after** time then the module is *NOT* hidden.  Note that
the local time is used.

The **userA** and **groupA** are an array of user and groups that when
listed will have the module be hidden.  The module will not be hidden
for all other users or groups. The **notUserA** and **notGroupA** are
a list of users and groups that the module will *NOT* be hidden. Note
that the list **userA** and **groupA** will be obeyed over being the
the **notUserA** or **notGroupA**

Finally, the **hidden_loaded=true** says that if a module is loaded it
won't be displayed when the command "module list" is given.  Note that
"module --show_hidden list" will always display them.

=========================================================
forbid{}: a way to mark modules as visible but unloadable
=========================================================

This function also take a table as its arguments and works similarly
to **hide** {}.  But its function is to report to users that module
exists and is shown with "module avail" and "module spider" but can
not be loaded.  The function can be called as follows:: 

   forbid{name="<sn/fullName/fn>",
        before="YYYY-MM-DDTHH:MM",
        after="YYYY-MM-DDTHH:MM",
        userA={"u1","u2",...},
        groupA={"g1","g2",...},
        notUserA={"u1","u2",...},
        notGroupA={"g1","g2",...},
        message="...",
        nearly_message="...",
        }

Where the **name** could be name could be the shortName (sn) like
"gcc" or the fullName such as "gcc/13.1" or the full path to the
modulefile (fn).  If the shortname is used then all versions will be
forbidden. the **name** key is the only one required, all others have
default values.  Note that **name** can take a list of module names by
doing::

    forbid{name={"moduleA","moduleB"},...}

where **name** values can be sn or fullName or fn.

The **before** and **after** keys use a time string of the form
"YYYY-MM_DDTHH:MM".  The "THH:MM" can be dropped and Lmod assumes
"T00:00".  Note that Lmod will have to be updated in the year 10000.
The **before** key says a modulefile will be forbidden until some future
date.  The **after** flag can be used to mark a module as forbidden at a
future time. If the current time is later than the **before** time and
before the **after** time then the module is *NOT* forbidden.  Note that
the local time is used.

The **userA** and **groupA** are an array of user and groups that when
listed will have the module be forbidden.  The module will not be
forbidden for all other users or groups. The **notUserA** and
**notGroupA** are a list of users and groups that the module will
*NOT* be forbidden.. Note that the list **userA** and **groupA** will be
obeyed over being the the **notUserA** or **notGroupA**

The **message** string is reported when a user tries to load it.
The **nearly_message** string is reported when the user loads the
module and the current time is close to the **after** time.  By
default the **nearly_message** is given when the current time is
within 14 days.  This can be changed by setting environment variable
"LMOD_NEARLY_FORBIDDEN_DAYS" or by configuring Lmod in the usual
fashion.


============================================================
TCL .modulerc files
============================================================

Site can also use the .modulerc files in the location where the
modulefiles are located or in the LMOD_MODULERC files.

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


**module-hide** *options* name1 name2 ...
   Where the *options* are::

       --before YYYY-MM-DDTHH:MM
       --after  YYYY-MM-DDTHH:MM
       --hard
       --soft
       --hidden-loaded
       --user {u1 u2 ...}
       --group {g1 g2 ...}
       --not-user {u1 u2 ...}
       --not-group {g1 g2 ...}

   All of the above options work the same as the Lmod versions do.



**module-forbid** *options* name1 name2 ...
   Where the *options* are::

       --before YYYY-MM-DDTHH:MM
       --after  YYYY-MM-DDTHH:MM
       --user {u1 u2 ...}
       --group {g1 g2 ...}
       --not-user {u1 u2 ...}
       --not-group {g1 g2 ...}
       --message {...}
       --nearly-message {...}

   All of the above options work the same as the Lmod versions do.


The above TCL commands are the only commands support in .modulerc or .version
files. In particular, TCL commands like setenv(), pushenv() are not supported.

System MODULERC files
^^^^^^^^^^^^^^^^^^^^^

By default, Lmod looks in /path_to_lmod/lmod/../etc/rc.lua or
/path_to_lmod/lmod/../etc/rc to find a system MODULERC file.  The lua
file takes precedence over the TCL version. Or you
can set either **LMOD_MODULERC** or **MODULERCFILE** to be a
single file or a colon separated list.  If more than one file is
specified then the priority is left to right. 
