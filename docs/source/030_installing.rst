.. _installing-lmod-label:

Installing Lua and Lmod
=======================

Environment modules simplify customizing the users' shell environment
and it can be done dynamically. Users load modules as they see fit. It
is completely under their control. Environment Modules or simply
modules provide a simple contract or interface between the system
administrators and users. System administrators provide modules and
users get to choose which to load.

There have been environment module systems for quite a while. See
http://modules.sourceforge.net/ for a TCL based module system and see
http://www.lysator.liu.se/cmod for another module system. Here we describe
Lmod, which is a completely new module system written in Lua. For
those who have used modules before, Lmod automatically reads TCL
modulefiles. Lmod has some important features over other module system,
namely a built-in solution to hierarchical modulefiles and provides
additional safety features to users as described in the User Guide.

The hierarchical modulefiles are used to solve the issue of system
pre-built libraries. User applications using these libraries must be
built with the same compiler as the libraries. If a site provides more
than one compiler, then for each compiler version there will be
separate versions of the libraries. Lmod provides built-in control
making sure that compilers and pre-built libraries stay matched. The
rest of the pages here describe how to install Lmod, how to provide
the module command to users during the login process and some
discussion on how to install optional software and the associated
modules.

The goal of installing Lmod is when completed, any user will have the
module command defined and a preset list of modules will be
loaded. The module command should work without modifying the users
startup files (``~/.bashrc``, ``~/.profile``, ``~/.cshrc``, or
``~/.zshenv``). The module command should be available for login
shells, interactive shells, and non-interactive shells. The command
``ssh YOUR_HOST module list`` should work. This will require some
understanding of the system startup procedure for various shells which
is covered here.

Installing Lua
--------------

In this document, it is assumed that all optional software is going to
be installed in /opt/apps. The installation of Lmod requires
installing lua as well.  On some system, it is possible to install Lmod
directly with your package manager. It is available with recent
fedora, debian and ubuntu distributions.


Install lua-X.Y.Z.tar.gz
~~~~~~~~~~~~~~~~~~~~~~~~

One choice is to install the lua-X.Y.Z.tar.gz file.  This tar ball
contains lua and the required libraries. This can be
downloaded from https://sourceforge.net/projects/lmod/files/::

    $ wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.gz

The current version is 5.1.4.9 but it may change in the future. This
can be installed using the following commands::

    $ tar xf lua-X.Y.Z.tar.gz
    $ cd lua-X.Y.Z
    $ ./configure --prefix=/opt/apps/lua/X.Y.Z
    $ make; make install
    $ cd /opt/apps/lua; ln -s X.Y.Z lua
    $ mkdir /usr/local/bin; ln -s /opt/apps/lua/lua/bin/lua /usr/local/bin

The last command is optional, but you will have to somehow put the
``lua`` command in your path.  Also obviously, please replace X.Y.Z
with the actual version (say 5.1.4.9)

If you use this option you do **not** need to use your package manager
or install luarocks.  Instead please read the section on how to
install Lmod.

Using Your Package Manager
~~~~~~~~~~~~~~~~~~~~~~~~~~

If you didn't install the lua tar ball described above then  
you can use your package manager for your OS to install Lua. You will
also need the matching packages: lua Filesystem (lfs) and luaposix.

On Ubuntu Linux, the following packages will work::

   liblua5.1-0
   liblua5.1-0-dev
   liblua5.1-filesystem-dev
   liblua5.1-filesystem0
   liblua5.1-posix-dev
   liblua5.1-posix0
   lua5.1
   tcl
   tcl-dev
   libtcl

Note; Centos may require looking the EPEL repo.  At TACC we install the
following rpms for our Centos based systems::

   lua-5.1.4-15.el7.x86_64
   lua-bitop-1.0.2-3.el7.x86_64
   lua-devel-5.1.4-15.el7.x86_64
   lua-filesystem-1.6.2-2.el7.x86_64
   lua-json-1.3.2-2.el7.noarch
   lua-lpeg-0.12-1.el7.x86_64
   lua-posix-32-2.el7.x86_64
   lua-term-0.03-3.el7.x86_64

You will also need the tcl and tcl-devel packages as well.::

   tcl-8.5.13-8.el7.x86_64
   tcl-devel-8.5.13-8.el7.x86_64 


Please note that the devel packages such as tcl-devel and lua-devel
are only required to build Lmod.  They are not required to run the
lmod package.  Note as well that the tcl-devel for Centos or tcl-dev
for ubuntu is only required if you configure Lmod
using --with-fastTCLInterp=yes. 

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
very important that the double trailing semicolon are there.  They are
replaced by the built-in system path for Lua.


Using Ansible
~~~~~~~~~~~~~

There is a `ready-to-use Ansible role
<https://galaxy.ansible.com/idiv-biodiversity/lmod/>` that allows you to
install Lmod conveniently from Ansible. The role was written with installation
on HPC clusters in mind, i.e. it is possible to install Lmod into a global,
networked file system share on only a single host, while all other hosts
install just the Lmod dependencies and the shell configuration files.
Nevertheless, it is of course possible to install Lmod with this role on a
single server. Also, the role supports the transition to Lmod as described in
:ref:`transition-to-lmod`.

You can find the complete role documentation `here
<https://github.com/idiv-biodiversity/ansible-role-lmod#ansible-role-lmod>`.


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
in the Configuring Lmod Guide.  This section here will describe how
to get Lmod installed quickly by using the defaults:


.. note ::
  If you have a large number of modulefiles or a slow parallel
  filesystem please read the Configure Lmod Guide on how to set-up
  the spider caching system.  This will greatly speed up ``module
  avail`` and ``module spider``

To install Lmod, you'll want to carefully read the following.  If you
want Lmod version X.Y installed in ``/opt/apps/lmod/X.Y``, just do::

    $ ./configure --prefix=/opt/apps
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
   Obviously you will want to modify the profile.in and cshrc.in files to suit
   your system.

Sites can also use ``/apps/lmod/lmod/init/.modulespath`` or configure
Lmod to use `--with-ModulePathInit=...`` to point to any file.  The
format of this file is::

    # comments are allowed as well as wildcards
    /apps/modulefiles/*
    /apps/other_modulefiles

If this file exists then MODULEPATH_ROOT method is not used.


The ``profile`` file is the Lmod initialization script for the bash and zsh
shells, the ``cshrc`` file is for tcsh and csh shells, and the ``profile.fish``
file is for the fish shell. Please copy or link the ``profile`` and ``cshrc``
files to ``/etc/profile.d``, and optionally the fish file to ``/etc/fish/conf.d``::

    $ ln -s /opt/apps/lmod/lmod/init/profile        /etc/profile.d/z00_lmod.sh
    $ ln -s /opt/apps/lmod/lmod/init/cshrc          /etc/profile.d/z00_lmod.csh
    $ ln -s /opt/apps/lmod/lmod/init/profile.fish   /etc/fish/conf.d/z00_lmod.fish

To test the setup, you just need to login as a user. The module
command should be set and ``MODULEPATH`` should be defined. Bash or Zsh
users should see something like::

     $ type module
     module ()
     {
       eval $($LMOD_CMD bash $*)
     }

     $ echo $LMOD_CMD
     /opt/apps/lmod/lmod/libexec/lmod

     $ echo $MODULEPATH
     /opt/apps/modulefiles/Linux:/opt/apps/modulefiles/Core

Similar for csh users::

    % which module
    module: alias to eval `/opt/apps/lmod/lmod/libexec/lmod tcsh !*`

    % echo $MODULEPATH
    /opt/apps/modulefiles/Linux:/opt/apps/modulefiles/Core

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

Similarly, the system BASHRC file should source all the \*.sh files in
``/etc/profile.d`` as well.  Here is where things can get complicated.
See the next section for details.

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

won't define the module command, even if sh is linked to bash.
Bash will run those scripts in shell emulation mode and won't
source the file that BASH_ENV points to.

Csh:
~~~~

Csh users have an easier time with the module command setup. The
system cshrc file is always sourced on every invocation of the
shell. The system cshrc file is typically called:
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
    
    
Fish:
~~~~~

Fish users have `several standard places
<https://fishshell.com/docs/current/index.html#initialization>`_
searched for scripts. The system location is usually
``/etc/fish/conf.d`` and the user location is usually 
``~/.config/fish/conf.d/``. Fish users are provided a special profile
file, ``init/profile.fish``, that should be linked into one of these
places with a suitable name. For example, a local user for fish might
want::

    $ ln -s /opt/apps/lmod/lmod/init/profile.fish ~/.config/fish/conf.d/z00_lmod.fish

A site might set::

    $ ln -s /opt/apps/lmod/lmod/init/profile.fish /etc/fish/conf.d/z00_lmod.fish

.. _issues-with-bash:

Issues with Bash
----------------

Interactive Non-login shells
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Bash startup procedure for interactive non-login shells is
complicated and varies between Operating Systems. In particular,
Redhat & Centos distributions of Linux as well as Mac OS X have no
system bashrc read during startup whereas Debian based distributions
do source a system bashrc. One easy way to tell how bash is set up
is to execute the following::

   $ strings `type -p bash` | grep bashrc

If the entire result of the command is::

   ~/.bashrc

then you know that your bash shell doesn't source a system bashrc
file.

If you want to have the same behavior between both interactive shells
(login or non-login) and your system doesn't source a system bashrc,
then you have two choices:

#. Patch bash so that it does source a system bashrc.  See
   ``contrib/bash_patch`` for details on how to do that.
#. Expect all of your bash users to have the following in their ``~/.bashrc`` ::

       if [ -f /etc/bashrc ]; then
          . /etc/bashrc
       fi

As a side note, we at TACC patched bash for a different reason which
may apply to your site.  When an MPI job starts, it logs into each
node with an interactive non-login shell.  When we had no system
bashrc file, many of our fortran 90 programs failed because they
required ``ulimit -s unlimited`` which makes the stack size
unlimited. *By patching bash, we could guarantee that it was set by
the system on each node.* Sites will have to chose which of the two
above methods they wish to deal with this deficiency in bash.

You may have to also change the /etc/bashrc (or /etc/bash.bashrc) file
so that it sources /etc/profile.d/\*.sh for non-login shells.

Bash Shell Scripts
~~~~~~~~~~~~~~~~~~

Bash shell scripts, unlike Csh or Zsh scripts, do not source any
system or user files.  Instead, if the environment variable,
``BASH_ENV`` is set and points to a file then this file is sourced
before the start of bash script.  So by default Lmod sets ``BASH_ENV``
to point to the bash script which defines the module command.

It may seem counter-intuitive but Csh and Zsh users running bash shell
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
bash script will still need to set ``BASH_ENV`` and run bash
scripts. They won't have the module command defined if they run a sh
script.
