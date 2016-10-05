.. _modulepath-label:

How Lmod Picks which Modulefiles to Load
========================================

Lmod use the directories listed in ``MODULEPATH`` to find the
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

The ``StdEnv.lua`` file is the another way to specify a module. This
file is a module with no version associated with it.  These are
typically used as a meta-module.  That is a module that loads other
modules.


Picking modules when there are multiple directories in MODULEPATH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When there are multiple directories specified in MODULEPATH, the rules
get more complicated on what modulefile to load. Lmod uses the
following rules to locate a modulefile:

#. It looks for an exact match in all ``MODULEPATH``
   directories. Picking the first match it finds.
#. If the user requested name is a full name and version, and
   there is no exact match then it stops.
#. If the name doesn't contain a version then Lmod looks for a
   marked default in the first directory that has one.
#. Finally it looks for the "Highest" Version in all ``MODULEPATH``
   directories. If there are two or more modulefiles with the
   "Highest" version then the first one in ``MODULEPATH`` order will
   be picked.
#. As a side node, if there are two version files, one with a ``.lua``
   extension and one without, the lua file will be used over the other
   one. It will like the other file is not there.

As an example, suppose you have the following module tree::

   ---------- /home/user/modulefiles -----------
   xyz/11.1

   ---------- /opt/apps/modulefiles -----------
   StdEnv    ucc/8.1    ucc/8.2        xyz/10.1

   ---------- /opt/apps/mfiles ----------------
   ucc/8.3 (D)    xyz/12.1 (D)


If a user does the following command::

   $ module load ucc/8.2 xyz

then ucc/8.2 will be loaded because the user specified a particular
version and xyz/12.1 will be loaded be cause it is the highest version
across all directories in ``MODULEPATH``.

.. _setting-default-label:

Marked a Version as Default
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose you have several versions of the mythical UCC compiler suite::

      $ module avail ucc
      ---------- /opt/apps/modulefiles/Core -----------
      ucc/8.1   ucc/9.2   ucc/11.1   ucc/12.2 (D)

and you like to make the 11.1 version the default.  Lmod searches 
three different ways to mark a version as a default in the following
order.  The first way is to make a symbolic link between a file named
"``default``" and the desired default version.::

    $ cd /opt/apps/modulefiles/Core/ucc; ln -s 11.1.lua default


A second way to mark a default is with a .modulerc file in the same
directory as the modulefiles.::
    
    #%Module
    module-version ucc/11.1 default


There is a third method to pick the default module.  If you create a
.version file in the ucc directory that contains::

    #%Module
    set   ModulesVersion   "11.1"

Please note that either a .modulerc or .version file must be in the
same directory as the 11.1.lua file in order for Lmod to read it.

Using any of the above three ways will change the default to version
11.1. ::

    $ module avail ucc
    ---------- /opt/apps/modulefiles/Core -----------
    ucc/8.1   ucc/9.2   ucc/11.1 (D)   ucc/12.2

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


Autoswaping Rules
~~~~~~~~~~~~~~~~~

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


