.. _settarg-label:

Combining build systems and modules with settarg
================================================

Settarg works with Lmod to help developers manage their compiled
software projects. It does so by making it easy to switch between
optimize or debug build or changing compiler or other modules and
letting the build system about the changes.  The secret of settarg is
that concentrates the state of a build into one environment variable
called $TARG.

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
That is where two or more clusters share the same "home".  Unless they
are exactly the same hardware and running the same version of the
operating system, software built on one system might not work on
another.

For all these reasons, it is convenient to have the built software reside in
different directories.  One places the objects, libraries and executes
in separate directories so that they never mix and avoids hard to
resolve bugs. 

Settarg manages these environment variables but it up to the software
developer to integrate these variables in to their build tool. More on
how to modify a Makefile to know about all the TARG variables later.

The keys to settarg
~~~~~~~~~~~~~~~~~~~

The keys to settarg are:

#. It manages a set of environment variables especially $TARG
#. It is integrated so that changes in modules automatically changes
   $TARG
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

Settarg also generates other environment variable to be used to
control your Makefile.  So for the above $TARG, the following
variables are also set::

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
where our software is built.  It is possible to all the objects,
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



