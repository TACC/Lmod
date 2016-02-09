.. _installing-lmod-label:

Installing Lua and Lmod
=======================

Environment modules simplify customizing the users's shell environment
and it can be done dynamically. Users load modules as they see fit. It
is completely under their control. Environment Modules, or simply
modules, provide a simple contract or interface between the system
administrators and users. System adminstrators provide modules and
users get to choose which to load.

There have been environment module systems for quite a while. See
http://modules.sourceforge.net/ for a TCL based module system and see
http://www.lysator.liu.se/cmod for another module system. Here we describe
Lmod, which is a completely new module system written in Lua. For
those who have used modules before, Lmod automatically reads TCL
modulefiles. Lmod has some important features over the TCL module system,
namely a built-in solution to *hierarchical* modulefiles and provides
additional safety features for users as described in the User Guide.

Hierarchical modulefiles are used to solve the issue of system
pre-built library compatibility. User applications using these libraries must be
built with the same compiler as the libraries. If a site provides more
than one compiler, then for each compiler version there will be
separate versions of the libraries. Lmod provides built-in control
making sure that compilers and pre-built libraries stay matched. The
rest of the pages here describe how to install Lmod, how to provide
the module command to users during the login process, and some
discussion on how to install optional software and the associated
modules.

The result of installing Lmod is that users will have the
module command defined, and there will be a preset list of modules
loaded. This will be done without modifying the users' startup files (``~/.bashrc``,
``~/.profile``, ``~/.cshrc``, or ``~/.zshenv``). The module command should be
available for login shells, interactive shells, and non-interactive
shells. The command ``ssh YOUR_HOST module list`` should work. This will
require some understanding of the system startup procedure for various
shells which will be covered in a later section.  First, we discuss
installing Lua, which is a prerequisite for Lmod.

Installing Lua
--------------

In this document, it is assumed that all optional software is going to
be installed in /opt/apps. The installation of Lmod requires
installing lua as well.  On some system is possible to install Lmod
directly with your package manager. It is available with recent
fedora, debian and ubuntu distributions.


Install lua-X.Y.Z.tar.gz
~~~~~~~~~~~~~~~~~~~~~~~~

One choice is to install the lua-X.Y.Z.tar.gz file.  This tar ball
contains lua and the required libraries. This can be
downloaded from https://sourceforge.net/projects/lmod/files/::

    $ wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.5.tar.gz

The current version is 5.1.4.5 but it may change in the future. This
can be installed using the following commands:: 

    $ tar xf lua-X.Y.Z.tar.gz
    $ cd lua-X.Y.Z
    $ ./configure --prefix=/opt/apps/lua/X.Y.Z
    $ make; make install
    $ cd /opt/apps/lua; ln -s X.Y.Z lua
    $ mkdir /usr/local/bin; ln -s /opt/apps/lua/lua/bin/lua /usr/local/bin

The last command is optional, but you will have to somehow put the
``lua`` command in your path.  Also obviously, please replace X.Y.Z
with the actual version (say 5.1.4.5)


Using Your Package Manager
~~~~~~~~~~~~~~~~~~~~~~~~~~

You can use your package manager for your OS to install Lua. You will
also need the matching packages: lua Filesystem (lfs) and luaposix.
On Ubuntu Linux, the following packages will work::

   liblua5.1-0
   liblua5.1-0-dev
   liblua5.1-filesystem-dev
   liblua5.1-filesystem0
   liblua5.1-posix-dev
   liblua5.1-posix0
   lua5.1

Note; Centos may require looking the EPEL repo.  At TACC we install the
following rpms::

   $ rpm -qa | grep lua

   lua-posix-5.1.7-1.el6.x86_64
   lua-5.1.4-4.1.el6.x86_64
   lua-filesystem-1.4.2-1.el6.x86_64
   lua-devel-5.1.4-4.1.el6.x86_64

You will also need the libtcl and tcl packages as well.


Using Luarocks
~~~~~~~~~~~~~~

If you have installed lua but still need luafilesystem and luaposix,
you can install the ``luarocks`` program from your package manager or
directly from https://luarocks.org/.  The ``luarocks`` programs can
install many lua packages including the ones required for Lmod. ::

  $ luarocks install luaposix; luarocks install luafilesystem

Now you have to make the lua packages installed by luarocks to be known
by lua.  On our Centos system, Lua knowns about the following for \*.lua
files::

   $ lua -e 'print(package.path)'
   ./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib64/lua/5.1/?.lua;/usr/lib64/lua/5.1/?/init.lua;

and the following for shared libraries::

   $ lua -e 'print(package.cpath)'
   ./?.so;/usr/lib64/lua/5.1/?.so;/usr/lib64/lua/5.1/loadall.so;

Assuming that luarocks has installed things in its default location (/usr/local/...)
then you'll need to do::

   LUAROCKS_PREFIX=/usr/local
   export LUA_PATH="$LUAROCKS_PREFIX/share/lua/5.1/?.lua;$LUAROCKS_PREFIX/share/lua/5.1/?/init.lua;;"
   export LUA_CPATH="$LUAROCKS_PREFIX/lib/lua/5.1/?.so;;"

Please change LUAROCKS_PREFIX to match your site.  The exporting of
LUA_PATH and LUA_CPATH must be done before any module commands. It is
very important that the trailing semicolon are there.  They are
replaced by the built-in system path.


Why does Lmod install differently?
----------------------------------

Lmod automatically creates a version directory for itself.  So, for
example, if the installation prefix is set to ``/apps``, and the
current version is ``X.Y.Z``, installation will create ``/apps/lmod``
and ``/apps/lmod/X.Y.Z``.  This way of configuring is different from
most packages.  There are two reasons for this:


#. Lmod is designed to have just one version of it running at one
   time. Users will not be switching version during the course of
   their interaction in a shell.

#. By making the symbolic link the startup scripts in /etc/profile.d
   do not have to change.  They just refer to ``/apps/lmod/lmod/...``
   and not ``/apps/lmod/X.Y.Z/...``




Installing Lmod
---------------

Lmod has a large number of configuration options.  They are discussed
in the Configuring Lmod Guide.  This section is here will describe how
to get Lmod installed quickly by using the defaults.


.. note ::
  If you have a large number of modulefiles or a slow parallel
  filesystem please read the Configure Lmod Guide on how to set-up
  the spider caching system.  This will greatly speed up ``module
  avail`` and ``module spider``

If you want Lmod version X.Y.Z installed in ``/apps/lmod/X.Y.Z``, use
the following form of ``configure``::

    $ ./configure --prefix=/apps
    $ make install


The installation will also create a link to ``/apps/lmod/lmod``.  The
symbolic link is created to ease upgrades to Lmod itself, as numbered
versions can be installed side-by-side, testing can be done on the new
version, and when all is ready, only the symbolic link needs changing.

To create such a testing installation, you can use::

    $ make pre-install

which does everything but create the symbolic link.


In the ``init`` directory of the source code, there are ``profile.in`` and ``cshrc.in``
templates. During the installation phase, the path to lua is added and
``profile`` and ``cshrc`` are written to the ``/apps/lmod/lmod/init``
directory. These files are created assuming that your modulefiles are going to be
located in ``/apps/modulefiles/$LMOD_sys`` and
``/apps/modulefiles/Core``, where ``$LMOD_sys`` is what the
command "``uname``" reports, (e.g., Linux, Darwin). The layout of
modulefiles is discussed later.

.. note ::
   You should modify the ``profile.in`` and ``cshrc.in`` files to suit
   your system if you choose to have a different location for your modulefiles.
   The ``MODULEPATH`` variable must also match your system's modulefiles location.

The ``profile`` file is the Lmod initialization script for the bash, and zsh
shells and ``cshrc`` file is for tcsh and csh shells.  Many sites find using
the ``/etc/profiles.d`` directory, in which setup files to be sourced by users'
shells at login are placed, to be a convenient way of insuring that Lmod is
properly set up for all users.  When ``profiles.d`` is activated, the system
login scripts will source, in glob order, the files that pertain to the current
shell. See the next section for more details.

It is important that the Lmod setup scripts are sourced late in the
initialization process to insure that any existing modules setup has
occurred.  However, you probably want to leave some room at the end of the
list of files in ``/etc/profile.d``, so we pick a name that is likely to be
at the end but still leave room for any initialization scripts that should come
later. ::

    $ ln -s /apps/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh
    $ ln -s /apps/lmod/lmod/init/cshrc   /etc/profile.d/z00_lmod.csh

To test the setup, you just need to login as a user. The module
command should be set and ``$MODULEPATH`` should be defined. Bash or Zsh
users should see the ``module`` command defined as something like::

     $ type module
     module ()
     {
       eval $($LMOD_CMD bash $*)
     }

     $ echo $LMOD_CMD
     /apps/lmod/lmod/libexec/lmod

     $ echo $MODULEPATH
     /apps/modulefiles/Linux:/apps/modulefiles/Core

Whereas csh and tcsh users should find something like::

    % which module
    module: alias to eval `/apps/lmod/lmod/libexec/lmod tcsh !*`

    % echo $MODULEPATH
    /apps/modulefiles/Linux:/apps/modulefiles/Core

If you do not see the module alias then please read the next section.


Integrating **module** Into Users' Shells
-----------------------------------------

Bash:
~~~~~

On login, the bash shell first reads ``/etc/profile``, and if ``profiles.d``
is activated, that in turn
should source all the \*.sh files in ``/etc/profile.d`` with something
like::

    if [ -d /etc/profile.d ]; then
      for i in /etc/profile.d/*.sh; do
        if [ -r $i ]; then
          . $i
        fi
      done
    fi

Similarly, the system ``bashrc`` file should source all the \*.sh files in
``/etc/profile.d``.  However, when bash is invoked as a non-login shell,
those files are not sourced, and things get complicated.  See the next
section for details.

Bash Shell Scripts:
~~~~~~~~~~~~~~~~~~~

Bash shell scripts do not source any system or user files before
starting execution. Instead it looks for the environment variable
BASH_ENV. It treats the contents as a filename and sources it before
starting a bash script.

Bash Script Note:

It is important to remember that all bash scripts should start with::

    #!/bin/bash

Starting with::

    #!/bin/sh

and sh is linked to bash won't define the module command. Bash will
run those scripts in shell emulation mode and it doesn't source the
file that BASH_ENV points to.

Csh:
~~~~

Csh users have an easier time with the module command setup. The
system cshrc file is always sourced on every invocation of the
shell. The system cshrc file it typically called:
``/etc/csh.cshrc``. This file should source all the \*.csh files in
``/etc/profile.d``::

    if ( -d /etc/profile.d ) then
      set nonomatch
      foreach i (/etc/profile.d/*.csh)
        source $i
      end
      unset nonomatch
    endif

Zsh:
~~~~

Zsh users have an easy time with the module command setup as well. The
system zshenv file is sourced on all shell invocations. This system
file can be in a number of places but is typically in ``/etc/zshenv`` or
``/etc/zsh/zshenv`` and should have::

    if [ -d /etc/profile.d ]; then
      setopt no_nomatch
      for i in /etc/profile.d/*.sh; do
        if [ -r $i ]; then
          . $i
        fi
      setopt nomatch
      done
    fi

Issues with Bash
----------------

Interactive Non-login shells
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Bash startup proceedure for interactive non-login shells is
complicated and varies between Operating Systems. In particular,
Redhat & Centos distributions of Linux as well as Mac OS X have no
system bashrc read during startup where as Debian based distributions
do source a system.  One easy way to tell how bash is set up is to
execute the following::

   $ strings `type -p bash` | grep bashrc

If the entire results of the command is::

   ~/.bashrc

then you know that your bash shell doesn't source a system BASHRC
file.

If you want to have the same behavior between both interactive shell
(login or non) and your system doesn't source a system bashrc, then
you have two choices:

#. Patch bash so that it does source a system bashrc.  See
   ``contrib/bash_patch`` for details on how to do that.
#. Expect all of your bash users to have the following in their ``~/.bashrc`` ::

       if [ -f /etc/bashrc ]; then
          . /etc/bashrc
       fi

As a side note, we at TACC patched bash for a different reason which
may apply to your site.  When an MPI job starts, the mpi process logs
into each node with an interactive non-login shell.  When we had no
system bashrc file, many of our fortron 90 programs failed because
they required ``ulimit -s unlimited`` which makes the stack size
unlimited.  By patching bash, we could guarantee that it was set by
the system on each node.


Bash Shell Scripts
~~~~~~~~~~~~~~~~~~

Bash shell scripts, unlike Csh or Zsh scripts, do not source any
system or user files.  Instead, if the environment variable,
``BASH_ENV`` is set and points to a file then this file is sourced
before the start of bash script.  So by default Lmod sets ``BASH_ENV``
to point to the bash script which defines the module command.

It may seem counterintuitive but Csh and Zsh users running bash shell
scripts will want BASH_ENV set so that the module command will work in
their bash scripts.

A bash script is one that starts as the very first line::

    #!/bin/bash

A script that has nothing special or starts with::

    #!/bin/sh

is a shell script.  And even if ``/bin/sh`` points to ``/bin/bash``
bash runs in a compatibility mode and doesn't honor ``BASH_ENV``.

To combat this Lmod exports the definition of the module command.
This means that even /bin/sh scripts will have the module command
defined when run by a Bash User.  However, a Csh or Zsh user running a
bash script will still need the ``BASH_ENV`` and run bash
scripts. They won't have the module command defined if they run an sh
script.
