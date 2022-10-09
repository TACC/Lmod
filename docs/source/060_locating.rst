.. _modulepath-label:

How Lmod Picks which Modulefiles to Load
========================================

Lmod uses the directories listed in ``MODULEPATH`` to find the
modulefiles to load.  Suppose that you have a single directory
``/opt/apps/modulefiles`` that has the following files and directories::

    /opt/apps/modulefiles

    StdEnv.lua  ucc/  xyz/

    ./ucc:
    8.1.lua  8.2.lua

    ./xyz:
    10.1.lua

Lmod will report the following directory tree like this::


   ---------- /opt/apps/modulefiles -----------
   StdEnv    ucc/8.1    ucc/8.2 (D)    xyz/10.1

We note that the ``.lua`` extension has not been reported above.  The
``.lua`` extension tells Lmod that the contents of the file are
written in the Lua language.  All other files are assumed to be
written in TCL.


Here the name of the file or directory under ``/opt/apps/modulefiles``
is the name of the module.  The normal way to specify a module is to
create a directory to be the name of the module and the file(s) under
that directory are the version(s).  So we have created ``ucc`` and
``xyz`` directories to be the names of the module.  There are two
version files under ``ucc`` and one version file under ``xyz``.

The ``StdEnv.lua`` file is another way to specify a module. This
file is a module with no version associated with it.  These are
typically used as a meta-module: a module that loads other modules.


.. _nv_rules-label:

N/V: Picking modules when there are multiple directories in MODULEPATH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The follow rules apply when the module layout is either Name/Version (N/V)
or Category/Name/Version (C/N/V).  The rules are a little different for
Name/Version/Version (N/V/V) as described in the section below.  When
there are multiple directories specified in MODULEPATH, the rules get
more complicated on what modulefile to load. Lmod uses the following
rules to locate a modulefile:

#. The user may specify *C/N*/default or *N*/default which is exactly
   the same as *C/N* or *N*.  Namely Lmod removes the string
   "/default" and then continues as if it was never there.
#. It looks for an exact match in all ``MODULEPATH``
   directories. It picks the first match it finds.  This is true
   of hidden modules.  Specifying the fullName of a module will
   load it.
#. If a site has "extended defaults" enabled and a user types in part
   of the version then that part is used select the "best" of that
   version if any exist. Note that if user enters "abc/1" then it will
   match "abc/1.\*" or "abc/1-\*" but not "abc/17.\*"
#. If the name doesn't contain a version then Lmod looks for a
   marked default in the first directory that has one. A marked
   default which is also hidden will be loaded.
#. Finally it looks for the "Highest" Version in all ``MODULEPATH``
   directories. If there are two or more modulefiles with the
   "Highest" version then the first one in ``MODULEPATH`` order will
   be picked.  Note that hidden modulefiles are ignored when choosing
   the "Highest".
#. As a side node, if there are two version files, one with a ``.lua``
   extension and one without, the lua file will be used over the other
   one. It will be like the other file is not there.

As an example, suppose you have the following module tree::

   ---------- /home/user/modulefiles -----------
   xyz/11.1  xyz/11.2   
 

   ---------- /opt/apps/modulefiles ------------
   StdEnv    ucc/8.1    ucc/8.2         xyz/10.1

   ---------- /opt/apps/mfiles -----------------
   ucc/8.3 (D)  xyz/12.0   xyz/12.1 (D) xyz/12.2


If a user does the following command::

   $ module load ucc/8.2 xyz

then ucc/8.2 will be loaded because the user specified a particular
version and xyz/12.1 will be loaded because it is the highest version
across all directories in ``MODULEPATH``.

If a user does the following command::

   $ module load xyz/11

then xyz/11.2 will be loaded because it is the highest of the xyz/11.*
modulefiles.  Note that::

   $ module load xyz/12

will load xyz/12.1 not xyz/12.2 because 12.1 is the marked default and
is therefore the highest "xyz/12.*".



.. _setting-default-label:

Marking a Version as Default
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose you have several versions of the mythical UCC compiler suite::

      $ module avail ucc
      ---------- /opt/apps/modulefiles/Core -----------
      ucc/8.1   ucc/9.2   ucc/11.1   ucc/12.2 (D)

and you would like to make the 11.1 version the default.  Lmod searches
three different ways to mark a version as a default in the following
order.  The first way is to make a symbolic link between a file named
"``default``" and the desired default version.::

    $ cd /opt/apps/modulefiles/Core/ucc; ln -s 11.1.lua default


A second way to mark a default is with a .modulerc.lua file in the same
directory as the modulefiles.::

    module_version("ucc/11.1", "default")


A third way to mark a default is with a .modulerc file in the same
directory as the modulefiles.::

    #%Module
    module-version ucc/11.1 default


There is a four method to pick the default module.  If you create a
.version file in the ucc directory that contains::

    #%Module
    set   ModulesVersion   "11.1"

Please note that a .modulerc.lua, .modulerc or .version file must be in the
same directory as the 11.1.lua file in order for Lmod to read it.

Using any of the above three ways will change the default to version
11.1. ::

    $ module avail ucc
    ---------- /opt/apps/modulefiles/Core -----------
    ucc/8.1   ucc/9.2   ucc/11.1 (D)   ucc/12.2



Lmod Order of Marking a Default
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As stated above, there are four files used to mark a default:

     #. default symlink
     #. .modulerc.lua
     #. .modulerc
     #. .version

Lmod searches in this order. If it finds a number earlier in the
list then the other are ignored.  In other words if your site as both
a default symlink and a .modulerc.lua file then the default file is
used and the .modulerc.lua file is ignored.  Sites can check duplicate
ways of marking a default (among other checks) with::

     $ $LMOD_DIR/check_module_tree_syntax $MODULEPATH

Highest Version
~~~~~~~~~~~~~~~

If there is no marked default then Lmod chooses the "Highest" version
across all directories::

      $ module avail ucc

      ---------- /opt/apps/modulefiles/Core -----------
      ucc/8.1   ucc/9.2   ucc/11.1   ucc/12.2

      ---------- /opt/apps/modulefiles/New -----------
      ucc/13.2 (D)

The "Highest" version is by version number sorting.  So Lmod "knows"
that the following versions are sorted from lowest to highest::

   2.4dev1
     2.4a1
  2.4beta2
    2.4rc1
       2.4
   2.4.0.0
     2.4-1
 2.4.0.0.1
     2.4.1

.. _NVV-label:

N/V/V: Picking modules when there are multiple directories in MODULEPATH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The rules are different when the module layout is Name/Version/Version
(N/V/V).  The rules for N/V can be called ``Find Best`` where as N/V/V is
``Find First``. Note that if any one of the directories in ``MODULEPATH``
are in N/V/V format, the whole tree is searched with N/V/V rules.  Below
are the rules that Lmod uses to locate a modulefile when in N/V/V mode:

#. The user may specify *N*/default as *N/V*/default which is exactly
   the same as *N* or *N/V*.  Namely Lmod removes the string
   "/default" and then continues as if it was never there.
#. If there is an exact match and the exact match is marked default
   then this marked default is chosen no matter which directory
   it is in.
#. It looks for an exact match in all ``MODULEPATH`` directories. It
   picks the first match it finds.
#. If there is no exact match then Lmod finds the first match for the
   names that it has.  It matches by directory name.  No partial matches
   are on directory names
#. In the directory that is found above the first marked default is
   found.
#. If there are no marked defaults, then the "highest" is chosen.
#. The two above rules are followed at each directory level.
#. If a site has "extended defaults" enabled and a user types in part
   of the version then Lmod picks the "best" of the modulefiles that
   match. Partial matching is only available for the last part of the
   version.  

For example with the following module tree where foo is the name of
the module and rest are version information::

    ----- /apps/modulefiles/A ----------------
    foo/2/1  foo/2/4    foo/3/1    foo/3/2 (D)

    ----- /apps/modulefiles/B ----------------
    foo/3/3    foo/3/4

    ----- /apps/modulefiles/C ----------------
    bar/32/3.0.1   bar/32/3.0.4   bar/32/3.1.5

Then the commands ``module load foo`` and ``module load foo/3`` would
both load ``foo/3/2``.  The command ``module load foo/2`` would load
``foo/2/4``.

When searching for ``foo``, Lmod finds it in the ``A`` directory.
Then seeing a choice between ``2`` and ``3`` it picks ``3`` as it is
higher.  Then in the ``foo/3`` directory it choses ``2`` as it is
higher than ``1``.  To load any other ``foo`` module, the full name
will have to specified.

The commands ``module load bar`` and ``module load bar/32/3.1`` would
load ``bar/32/3.1.5``.  And the command ``module load bar/32/3.0``
would load ``bar/32/3.0.4``.  Note that command ``module load bar/3``
would fail to load any modules.


Marking a directory as default in an N/V/V layout
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are three ways to mark a directory as a default: Using a ``default``
symlink, or the use of either the ``.modulerc`` or ``.version`` files.
Since it is possible (but not recommended) to have all three
possibilities, This is the same technique that was used before to mark
a particular version file when in an N/V layout. Lmod choses the
setting of the default directory in the following order:

      #. ``default`` symlink
      #. ``.modulerc.lua``
      #. ``.modulerc``
      #. ``.version``

Suppose that you have the following architecture split with
(32,64,128) bit libraries and you want the 64 directory to be the
default.  With the following structure::

      ----- /apps/modulefiles/A ----------------
      foo/32/1    foo/64/1      foo/128/1
      foo/32/4    foo/64/2 (D)  foo/128/2

You can have a symlink for ``/apps/modulefiles/A/foo/default`` which
points to ``/apps/modulefiles/A/foo/64``.  Or you can have the contents of
``/apps/modulefiles/A/foo/.modulerc`` contain::

    #%Module
    module-version 64 default

or you can have the contents of
``/apps/modulefiles/A/foo/.modulerc.lua`` contain::

    module_version("64","default")

or you can have the contents of ``/apps/modulefiles/A/foo/.version``
contain::

    #%Module
    set ModulesVersion "64"

Normally the 128 directory would be chosen as the default directory as
128 is higher than 64 or 32 but any one of these files forces Lmod to pick
64 over the other directories.

Why do N/V/V module layouts use ``Find First`` over ``Find Best``?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The main problem here is that of the default directories.  There is no
sane way to pick.  Suppose that you have the following structure::

      ----- /apps/modulefiles/A ----------------
      foo/32/1    foo/64/1      foo/128/1
      foo/32/4    foo/64/2 (D)  foo/128/2

      ----- /apps/modulefiles/B ----------------
      foo/32/5    foo/64/3      foo/128/3
      foo/32/6    foo/64/4      foo/128/4


And where the default directory in ``A`` in ``64`` and in ``B`` it is
``32``.  When trying to load ``foo/64`` the site has marked ``64`` the
default in ``A`` where as it is not in ``B``.  Does that mean that
``foo/64/2`` is "higher" that ``foo/64/4`` or not.  There is no clear
reason to pick one over the other so Lmod has chosen ``Find First``
for N/V/V module layouts.

For sites that are mixing N/V and N/V/V module layouts they may wish
to change Lmod to use the find first rule in all cases. See
:ref:`env_vars-label` to see how to configure Lmod for find first.

Autoswapping Rules
~~~~~~~~~~~~~~~~~~

When Lmod autoswaps hierarchical dependencies, it uses the following
rules:

1. If a user loads a default module, then Lmod will reload the default
   even if the module version has changed.
2. If a user loads a module with the version specified then Lmod will
   only load the exact same version when swapping dependencies.

For example a user loads the intel and boost library::

    $ module purge; module load intel boost; module list

    Currently Loaded Modules:
    1) intel/15.0.2  2) boost/1.57.0

Now swapping the Intel compiler suite for the Gnu compiler suite::


    The following have been reloaded with a version change:
    1) boost/1.57.0 => boost/1.56.0

Here boost has been reloaded with a different version because the
default is different in the gcc hierarchy.  However if the user does::


    $ module purge; module load intel boost/1.57.0; module list

     Currently Loaded Modules:
     1) intel/15.0.2  2) boost/1.57.0

And::

    $ module swap intel gcc;

    Inactive Modules:
    1) boost/1.57.0

Since the user initially specified loading boost/1.57.0 then Lmod
assumes that the user really wants that version.  Because version
1.57.0 of boost isn't available under the gcc hierarchy, Lmod marks
this boost module as inactive.  This is true even though version
1.57.0 is the default version of boost under the Intel hierarchy.


