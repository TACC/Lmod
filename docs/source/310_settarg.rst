.. _settarg-label:

================================================
Combining modules and build systems with settarg
================================================

````````````
Introduction
````````````

The settarg module works with Lmod to help developers manage their
compiled software projects. It does so by making it easy to switch
between optimized or debug builds; change compiler or other modules;
and let the build system know about the changes.  The secret of
settarg is that it consolidates the state of a build into one
environment variable called $TARG.

One of the big advantages of developing software with a module system
is the ability to easily switch between compilers and mpi stacks and
other modules.  Sometimes one gets a strange compiler error or runtime
error with one set of tools and it is convenient try a different
compiler to see if it tells you something different.

Another useful trick to switch between the level of optimization with
one set of builds that have minimal optimization and the "-g" flag to
include the symbol table for ease of debugging and other builds with
full optimization.

Finally there are some sites which have "shared-home" filesystems.
That is where two or more clusters share the same "home" directory
tree.  Unless they are exactly the same hardware and running the same
version of the operating system, software built on one system might
not work on another.

For all these reasons, it is convenient to have the built software
reside in different directories.  Settarg makes it easy to place all
the objects, libraries and executes in a separate directory for each
kind of build so that they never mix and this avoids hard to resolve
bugs.

Settarg manages these environment variables but it is up to the
software developer to integrate these variables in to their build
system. More on how to modify a Makefile to know about all the TARG
variables later.

The keys to settarg
~~~~~~~~~~~~~~~~~~~

The keys to settarg are:

#. It manages a set of environment variables including $TARG
#. It is integrated with Lmod so that changes in modules automatically
   changes $TARG
#. Your PATH is dynamically adjusted with $TARG
#. The title bar is dynamically managed.
#. It is easy to configure with site, user and project control.

All you need to is load the settarg module and it will control these
variables including PATH that you can use to control your build
process. The most important one of these is TARG short for target.  It
contains a string for the machine architecture, the build scenario,
(opt, dbg), the compiler and the mpi module.  For example, TARG might
be::

    TARG = OBJ/_x86_64_06_2d_dbg_gcc-7.1_openmpi-2.2

Settarg also generates other environment variables to be used to
control your Makefile or other build tool.  So for the above $TARG,
the following variables are also set::

    TARG_MACH            = x86_64_06_2d
    TARG_BUILD_SCENARIO  = dbg
    TARG_COMPILER        = gcc/7.1
    TARG_COMPILER_FAMILY = gcc
    TARG_MPI             = openmpi/2.2
    TARG_MPI_FAMILY      = openmpi

Knowing that TARG_COMPILER_FAMILY is gcc or intel can mean it is easy
to set the compiler flags appropriate for each compiler.

But the most important feature of settarg is that if you change
your compiler from gcc to intel/18.0.1 then TARG and the other
environment variable change automatically::

    TARG                 = OBJ/_x86_64_06_2d_dbg_intel-18.0.1_openmpi-2.2
    TARG_COMPILER        = intel/18.0.1
    TARG_COMPILER_FAMILY = intel

and all the other variables remain the same.  If you change the build
scenario from ``dbg`` to ``opt`` then the following would be the
result::

    TARG                 = OBJ/_x86_64_06_2d_opt_intel-18.0.1_openmpi-2.2
    TARG_BUILD_SCENARIO  = opt

Integration with your build system
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once we have these environment variables, we can use them to control
where our software is built.  It is possible to place all the objects,
libraries and executable stored in the $TARG directory.  If all the
generated files are in the $TARG directory, then changing the compiler
will result in a different TARG directory.  So each $TARG directory is
independent and we won't require a ``make clean`` between changing
compilers or build scenarios. 

Integration with PATH
~~~~~~~~~~~~~~~~~~~~~

It is useful to have your PATH point to the new $TARG directory, so
settarg changes your path to include $TARG by removing the old value
of $TARG and replacing it with the new value of $TARG.  This way you
can set $TARG, build, then run the new executable.

Settarg integration with prompt commands
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The bash shell support an environment variable called "PROMPT_COMMAND".
If this variable is set to the name of a shell function, then for each
new shell prompt, this command is run.  Similarly, zsh will run the
"precmd" on every new prompt.  By default the settarg module defines a
shell function called precmd and if the user is using the bash shell,
the PROMPT_COMMAND variable is set to "precmd".

If users have their own prompt command then, they can prevent settarg
from overriding their prompt command by LMOD_SETTARG_IN_PROMPT to "no".

Xterm title bar support
~~~~~~~~~~~~~~~~~~~~~~~

If the environment variable LMOD_SETTARG_TITLE_BAR=yes and $TERM has
"xterm" in the string, then loading the module settarg will turn on
title bar support. A typical string in the title bar might be::

   (D G/5.2 M/3.2)user@host: ~/bin

where user is your user name and host is your hostname followed by
your current directory.  The string in the parentheses are what
settarg are providing.  The "D" is dbg build scenario, the "G/5.2" is
an abbreviation for the gcc/5.2 compiler module and "M/3.2" is an
abbreviation for the mpich/3.2 mpi module.  The abbreviations are
controlled by configuration files.  This string is
TARG_TITLE_BAR_PAREN. 

Settarg uses the following rules to define what the host is.
If the environment variable $SHOST is defined then that value is use
for the hostname.  Otherwise the first name is used from the
hostname.  In other words, your host name is
"login1.stampede2.tacc.utexas.edu" then "login1" will be used as the
host. Obviously, if you'd rather have "login1.stampede2" be in the
title bar then define SHOST to do so.



Settarg configuration
~~~~~~~~~~~~~~~~~~~~~

Lmod provides a default configuration for settarg in the file
settarg_rc.lua.  Sites may have to tailor this file to match the names
of their compilers and mpi modules and other module names.  Then users
may wish to set their own preferences.  Finally a project may wish to
have specialized settings.  All files are merged together in an
intelligent fashion into a single configuration. They do not overwrite
the previous setting.  More on this in :ref:`settarg_configuration-label`

Commands
~~~~~~~~

The environment TARG's value is typically used as a name of the build
directory.  So the settarg module provides some helpful aliases to
take advantage of this.

#. gettargdir:  it is simply an alias for "echo $TARG"
#. cdt:         Another alias: "cd $TARG"
#. settarg:     How to set the build scenario and to access other features.

By default settarg has an "empty" build scenario.  This can be changed
by::

    $ settarg dbg
    $ settarg opt

Which will change TARG_BUILD_SCENARIO to "dbg" or "opt".  Also::

    $ settarg --report

report the state of the .settarg table after combining all the
possible .settarg.lua files.

For those of you who like short commands, please configure Lmod with
--with_settarg=full or set the environment variable 
LMOD_SETTARG_FUNCTIONS=yes before loading the settarg module.
One useful command is::

    $ targ

which is a short for "gettargdir".  Also if you switch between build
scenarios frequently may wish to define the following shortcuts for
setting the build scenario::

    dbg()  { settarg "$@" dbg;   }
    opt()  { settarg "$@" opt;   }
    mdbg() { settarg "$@" mdbg;  }
    empty(){ settarg "$@" empty; }
  

What environment variables are defined by settarg
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are a typical list of variables::

    TARG_SUMMARY=x86_64_06_2d_dbg_gcc-7.1_openmpi-2.2
    TARG=OBJ/_x86_64_06_2d_dbg_gcc-7.1_openmpi-2.2

    TARG_TITLE_BAR=D G/7.1 O/2.2
    TARG_TITLE_BAR_PAREN=(D G/7.1 O/2.2)

    TARG_BUILD_SCENARIO=dbg

    TARG_MACH=x86_64_06_2d

    TARG_COMPILER=gcc/7.1
    TARG_COMPILER_FAMILY=gcc

    TARG_MPI=openmpi/2.2
    TARG_MPI_FAMILY=openmpi

    TARG_OS=Linux-2.6.32-279
    TARG_OS_Family=Linux
    TARG_HOST=stampede

Here is a glossary of what each of these variables mean:

TARG_SUMMARY:
    The dynamic combination of items like the machine architecture,
    build scenario, etc.   See below for how this gets built.

TARG:
    This variable contains all the "interesting" items.  How is
    put together is described later.

TARG_TITLE_BAR:
    This contains everything in TARG_SUMMARY but it is abbreviated to
    fit the space available.   This string is provided in case the
    user wishes to use this variable as part of their own title bar
    string.

TARG_TITLE_BAR_PAREN:
    This is $TARG_TITLE_BAR with parentheses around the string.  This
    variable is typically used in the xterm title bar.

TARG_BUILD_SCENARIO:
    This can be used to control compiler flags so that "dbg" might
    mean to create a debuggable executable.  Where as "opt" might
    mean to build a fully optimized build.  To clear this field use
    the command ``settarg empty``.

TARG_MACH:
    This is the machine architecture along with the cpu family and
    model number in two hex numbers when on Linux system that has
    the pseudo file /proc/cpuinfo. The architecture is what is
    reported by "uname -m"

TARG_COMPILER:
   The name of the compiler and version written as <compiler>/<version>

TARG_COMPILER_FAMILY:
   The name of the compiler without the version.

TARG_MPI:
   The name of the mpi module and version written as <mpi>/<version>

TARG_MPI_FAMILY:
   The name of the mpi module without the version.

TARG_OS, TARG_OS_FAMILY:
    These are the OS name and family.  These variables are always
    defined even if there are not part of TARG_SUMMARY.

TARG_HOST:
    See below on how this is extracted from `hostname -f`

.. _settarg_configuration-label:

```````````````````````````
Settarg configuration files
```````````````````````````

Below is a typical configuration file.  This is file contains several
tables in written in Lua.  If you don't know Lua, it still should be
easy to modify this table. just remember the comma's.

The BuildScenarioTbl table maps host name to initial Build Scenario
state.  So the default is "empty" which means that the
TARG_BUILD_SCENARIO is undefined.  If you are on
"login1.stampede.tacc.utexas.edu" your default TARG_BUILD_SCENARIO
will be "opt".  Similarly, any host with "foo.bar.edu" will have a
default scenario of "dbg".::

    BuildScenarioTbl = {
       default             = "empty",
       ["tacc.utexas.edu"] = "opt",
       ["foo.bar.edu"]     = "dbg",
    }

    ModuleTbl = {
       build_scenario     = { "dbg", "opt", "empty"},
       compiler           = { "intel", "pgi", "gcc", "sun",},
       mpi                = { "mpich", "mpich2", "openmpi", "mvapich2", "impi"},
       solver             = { "petsc","trilinos"},
       profiling          = { "mpiP", "tau"},
       file_io            = { "hdf5", "netcdf", },
    }

    TargetList = { "mach", "build_scenario", "compiler", "mpi"}

    SettargDirTemplate = { "$SETTARG_TAG1", "/", "$SETTARG_TAG2", "$TARG_SUMMARY" }

    NoFamilyList = {"mach", "build_scenario"}

    TitleTbl = {
       dbg                    = 'D',
       opt                    = 'O',
       impi                   = "IM",
       mvapich2               = 'M',
       openmpi                = "O",
       mpich                  = "M",
       mpich2                 = "M2",
       intel                  = "I",
       gcc                    = "G",
       phdf5                  = "H5"
       hdf5                   = "H5"
    }

    TargPathLoc = "first"

    HostnameTbl = { 2}


ModuleTbl connects module names with a category.  It is also used to
define "build_scenario" which is just words to declare a build state.
In other words, in the above table "dbg" and "opt" could be anything.
The only hard-wired name is "empty".  The category "build_scenario" is
also hard-wired.  The names of all other categories are not fixed and
you are free to add other categories.

This table is also how settarg knows what the names of the compiler
and mpi stacks are.  If your site uses the name "ompi" for openmpi
then the above table will have to be modified to match.

TargetList defines how TARG_SUMMARY is assembled.  It is an array of
categories.   The category "mach" is special it is always defined to
be `uname -m` plus on Linux systems it contains the cpu family and
model from /proc/cpuinfo. Each piece is concatenated together with
"_".  If an item is undefined then the extra "_" is removed.

Settarg ships with the order given above, but sites and users can
change the order to be anything they like.  Also notice that there are
many more categories then are listed in TargetList.  More on this
aspect in the "Custom Configuration" section.

SettargDirTemplate specifies how TARG is assembled.  In the case shown
above then env. var SETTARG_TAG1 is combined with "/" and
SETTARG_TAG2 followed by TARG_SUMMARY.  Both "TAG" variables have to
be set in the environment.  Here we have assumed that SETTARG_TAG1 is
"OBJ" and SETTARG_TAG2 is "_".  This leads to TARG being:

    TARG=OBJ/_x86_64_06_2d_dbg_gcc-7.1_openmpi-2.2


The NoFamilyList is an array of categories that do not get the FAMILY
version.  All categories do.  For example, if TARG_COMPILER is
"gcc/7.1" then TARG_COMPILER_FAMILY is "gcc".

The TARG_TITLE_BAR and TARG_TITLE_BAR_PAREN are strings that could be
used in a terminal title bar. Every item in the TARG_SUMMARY is in the
TITLE bar variables (except for TARG_MACH).  Because the title bar
space is limited, TitleTbl is a way to map each item into an
abbreviation.   The order in which categories appear on the
title bar is the same as TargetList.  So a title bar with "O G/7.1
O/2.2" would mean that you are in "opt" mode with gcc/7.1 and
openmpi/2.2 loaded.

TargPathLoc controls where (or if) $TARG.  Note that the environment
variable LMOD_SETTARG_TARG_PATH_LOCATION is use to control
TargPathLoc. Normally the value of TARG is placed in the PATH at the
beginning of your PATH.  You can place it at the end of your PATH when
TargPathLoc = "last".  If TargPathLoc is "empty" then TARG is removed
from your path.  Actually the rules controlling where TARG goes in
your path are slightly more complicated.  TargPathLoc controls where
$TARG is placed in your path when TARG was not there before.  After
the first time TARG is added to your path, TARG maintains its relative
location.

Finally, HostnameTbl tells settarg how to extract an entry from the
full hostname to be used as TARG_HOST.  If your host has multiple
components then a "2" would say to use the second component as
TARG_HOST.  So if your hostname is "login1.stampede.tacc.utexas.edu"
then TARG_HOST would be "stampede".  If HostnameTbl was "{ 3,2}" then
TARG_HOST would be "tacc.stampede".  If your hostname has a single
component then that is used for TARG_HOST.

Custom configuration
~~~~~~~~~~~~~~~~~~~~

Settarg will read up to three separate copies of settarg configuration
files.  The first one is in the same directory as the settarg command
is and is called settarg_rc.lua.  The second place is in the user's
home directory (if ``~/.settarg.lua`` exists). Then from the current
directory up to "/" it looks for another .settarg.lua (if it exists).
It will not re-read the ``~/.settarg.lua``.  Typically a user should
copy the system settarg_rc.lua to their home directory (as
``~/.settarg.lua``) and specify the generally desired behavior.  Then
in top directory of a project place a simple .settarg.lua that
specifies how the target list should be put together for that project:

Suppose that TargetList ``~/.settarg.lua`` is::

   TargetList  = { "mach", "build_scenario", "compiler", "mpi",}

Then in ``~/project/a`` there is another ``.settarg.lua`` that just has::

   TargetList  = { "mach", "build_scenario", "compiler", "mpi", "file_io"}

Normally in any directory your TARG will be the default, but in any
directory below ``~/project/a`` TARG will have hdf5 or netcdf if either
are loaded.

To see the state of the configuration execute::

    $ settarg --report

````````````````````
Makefile integration
````````````````````


See the ``contrib/settarg/make_example`` directory and the README.txt
inside.  That directory contains a simple Makefile and a more
complicated one to a way to use $TARG in a Makefile so that all
generated files (``*.o`` and the executable) are in the $TARG directory.


There are four main points to converting a Makefile to know about
settarg.  The first is to set the compiler based on
``TARG_COMPILER_FAMILY``::

   CC := gcc
   ########################################################################
   #  Use TARG_COMPILER_FAMILY to set the C compiler name

   ifeq ($(TARG_COMPILER_FAMILY),gcc)
      CC := gcc
   endif

   ifeq ($(TARG_COMPILER_FAMILY),intel)
      CC := icc
   endif

The second is to set the optimization based on
``TARG_BUILD_SCENARIO``::

   CF := -O2
   ########################################################################
   #  Use TARG_BUILD_SCENARIO to set the compiler options for either
   #  debug or optimize.

   ifeq ($(TARG_BUILD_SCENARIO),dbg)
     CF := -g -O0
   endif

   ifeq ($(TARG_BUILD_SCENARIO),opt)
     CF := -O3
   endif
   override CFLAGS   := $(CFLAGS) $(CF)

The third point is to force the make file to use the $TARG directory
if defined and change the compilation rules::

    ########################################################################
    #  Use O_DIR as equal to $(TARG)/ so that if TARG is empty then O_DIR
    #  will be empty.  But if $(TARG) as a value then O_DIR will have a
    #  trailing slash.

    ifneq ($(TARG),)
      override O_DIR := $(TARG)/
    endif


    ######################## compilation rules ###############################

    $(O_DIR)%.o : %.c
            $(COMPILE.c) -o $@ -c $<

The four point is that the dependencies have to change to use
$(O_DIR)::

     ######################## Dependencies ####################################

     $(O_DIR)main.o : main.c hello.h

     $(O_DIR)hello.o: hello.c hello.h

For small projects, generating  the dependencies by hand is manageable.
But for larger projects it can get unwieldy.  The ``Makefile`` shows
how to generate the dependencies automatically.

