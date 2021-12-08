Advanced User Guide for Personal Modulefiles
============================================

This advanced guide is for users wishing to create modulefiles for their own software. The reasons are simple:

#. Install a newer version of open source software than is currently available.
#. Easily change the version of applications or libraries under their own development.
#. Better documentation for what software is available.

One could create new version of some software and place it in your
personal PATH and forget about it. At least when it is in a module, it
will be listed in the loaded modules. It will also appear in the list of
available software via ``module avail``

User Created Modules
^^^^^^^^^^^^^^^^^^^^

Users can create their own modules. The first step is to add to the
module path::

   $ module use /path/to/personal/modulefiles

This will prepend ``/path/to/personal/modulefiles`` to the ``MODULEPATH``
environment variable. This means that any modulefiles defined here
will be used instead of the system modules. There is a possible exception
where defaults will override this selection. (See the next section
:ref:`finding_w_same_name-label` for more details). 

Suppose that the user creates a directory called ``$HOME/modulefiles``
and they want a personal copy of the "git" package. They do the
usual "tar, configure, make, make install" steps::

    $ wget https://www.kernel.org/pub/software/scm/git/git-2.6.2.tar.gz
    $ tar xf git-2.6.2.tar.gz
    $ cd git-2.6.2
    $ ./configure --prefix=$HOME/pkg/git/2.6.2
    $ make
    $ make install

This document has assumed that 2.6.2 is the current version of git, it
will need to be replaced with the current version. To create a
modulefile for git one does::

    $ cd ~/modulefiles
    $ mkdir git
    $ cd git
    $ cat > 2.6.2.lua
    local home    = os.getenv("HOME")
    local version = myModuleVersion()
    local pkgName = myModuleName()
    local pkg     = pathJoin(home,"pkg",pkgName,version,"bin")
    prepend_path("PATH", pkg)
    ^D

Starting first from the name: git/2.6.2.lua, modulefiles with the .lua
extension are assumed to be written in lua and files without this
extension are assumed to be written in TCL.
This modulefile for git adds ``~/pkg/git/2.6.2/bin`` to the user's
path so that the personal version of git can be found.  Note that the
use of the functions **myModuleName()** and  **myModuleVersion()**
allows the module to be generic and not hard-wired to a particular
module file. We have used the *cat* command to quickly create this lua
modulefile. Obviously, this file can easily created by your favorite
editor.

The first line reads the user's HOME directory from the
environment. The second line uses the "pathJoin" function provided
from Lmod. It joins strings together with the appropriate number of
"/". The last line calls the "prepend_path" function to add the path
to git to the user's path.

Finally the user can do: ::

   $ module use $HOME/modulefiles
   $ module load git
   $ type git
   ~/pkg/git/2.6.2/bin/git

For git to be available on future logins, users need to add the
following to their startup scripts or a saved collection::

   $ module use $HOME/modulefiles
   $ module load git

The modulefiles can be stored in different directories. There is an
environment variable ``MODULEPATH`` which controls that. Modulefiles that
are listed in an earlier directory are found before ones in later
directories. This is similar to command searching in the ``PATH``
variable. There can be several versions of a command. The first one
found in the ``PATH`` is used.

.. _finding_w_same_name-label:

Finding Modules With Same Name
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Suppose the user has created a "git" module to provide the latest
available. At a later date, the system administrators add a newer
version of "git" ::

   $ module avail git
   --------------- /home/user/modulefiles ----------------
   git/2.6.2

   --------------- /opt/apps/modulefiles ----------------
   git/1.7.4   git/2.0.1   git/3.5.4 (D)

   $ module load git


The load command will load ``git/3.5.4`` because it is the highest
version.

If a user wishes to make their own version of git the default module,
they will have to mark it as a default.  Marking a module as a default
is discussed in section :ref:`setting-default-label`.

