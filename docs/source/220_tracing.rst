.. _tracing:

Tracing Lmod
============

Lmod supports a tracing option to report the major steps that Lmod
performs.  It can be set by either setting the ``LMOD_TRACING`` to
``yes`` or using the -T or --trace option on the command line.  This
can be useful to understand what happens a shell startup.  By setting
``LMOD_TRACING`` to yes for a particular user you can see something
like the following for a user which as a default collection::

    running: module --initial_load restore
      Using collection:      /home/user/.lmod.d/default
      Setting MODULEPATH to :/opt/apps/modulefiles/Linux:/opt/apps/modulefiles/Core
      Loading: unix
      Loading: gcc
      Loading: noweb
      Loading: StdEnv

Using Shell Startup Debug with Tracing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sites may wish to install the shell startup debug package from
sourceforce::

     https://sourceforge.net/projects/shellstartupdebug


It tracks the startup actions during shell startup. It
can tell you what files in /etc/profile.d/* are started.  For
example::

     % cat > ~/.init.sh
     export SHELL_STARTUP_DEBUG=1
     ^D
     % zsh -l
     /etc/zshenv{
       /etc/profile.d/lmod.sh{
       } Time = 0.1875
       /etc/profile.d/z00_lmod.sh{
       } Time = 0.2294
       /etc/profile.d/z99_StdEnv.sh{
       } Time = 0.2889
     } Time = 0.2929

One of the tricks of this package is that it guarantees that a
~/.init.sh is read before any files in /etc/profile.d/\*.sh are
sourced for bash and zsh.  The file ~/.init.csh is used for csh/tcsh.
This means that you can also easily track Lmod startup actions::

     % cat > ~/.init.sh
     export LMOD_TRACING=yes
     ^D
  
     % ssh localhost
     Last login: Sun Apr  2 08:03:13 2017
     running: module --initial_load restore
       Using collection:      /home/user/.lmod.d/default
       Setting MODULEPATH to: /opt/apps/modulefiles/Darwin:/opt/apps/modulefiles/Core
       Loading: unix (fn: /opt/apps/modulefiles/Core/unix/unix.lua)
       Loading: gcc (fn: /opt/apps/modulefiles/Darwin/gcc/5.2.lua)
       Loading: noweb (fn: /opt/apps/modulefiles/Core/noweb/2.11b.lua)
       Loading: StdEnv (fn: /opt/apps/modulefiles/Core/StdEnv.lua)

This way you can trace Lmod startup without having to edit any files
in /etc/profile.d/* or the shell startup files.
