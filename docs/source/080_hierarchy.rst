.. _Software-Hierarchy-label:

How to use a Software Module hierarchy
======================================

Libraries built with one compiler need to be linked with applications
with the same compiler version. For High Performance Computing there
are libraries called Message Passing Interface (MPI) that allow for
efficient communicating between tasks on a distributed memory computer
with many processors. Parallel libraries and applications must be
built with a matching MPI library and compiler.  To make this
discussion clearer, suppose we have the intel compiler version 15.0.1
and the gnu compiler collection version 4.9.2.  Also we have two MPI
libraries: mpich version 3.1.2 and openmpi version 1.8.2.  Finally we
have a parallel library HDF5 version 1.8.13 (phdf5).

Of the many possible ways of specifying a module layout, this flat
layout of modules is a reasonable way to do this::

    $ module avail

    --------------- /opt/apps/modulefiles ----------------------
    gcc/4.9.2                        phdf5/gcc-4.9-mpich-3.1-1.8.13      
    intel/15.0.2                     phdf5/gcc-4.9-openmpi-15.0-1.8.13   
    mpich/gcc-4.9-3.1.2              phdf5/intel-15.0-mpich-3.1-1.8.13   
    mpich/intel-15.0-3.1.2           phdf5/intel-15.0-openmpi-15.0-1.8.13
    openmpi/gcc-4.9-1.8.2
    openmpi/intel-15.0-1.8.2

In order for users to load the matching set of modules, they will have
to load the matching set of modules.  For example this would be
correct::

    $ module load gcc/4.9.2 openmpi/gcc-4.9-1.8.2  phdf5/gcc-4.9-openmpi-15.0-1.8.13

It is quite easy to load an incompatible set of modules.  Now it is
possible that the system administrators at your site might have setup
``conflict`` s to avoid loading mismatched modules.  However using
conflicts can be fragile.  What happens if a site adds a new compiler
such as clang or pgi or a new mpi stack.  All those module file
conflict statements will have to be updated.


A different strategy is to use a software hierarchy. In this approach
a user loads a compiler which extends the **MODULEPATH** to make
available the modules that are built with the currently loaded
compiler (similarly for the mpi stack).


Our modulefile hierarchy is stored under
``/opt/apps/modulefiles/{Core,Compiler,MPI}``. The Core directory is for
modules that are not dependent on Compiler or MPI implementations. The
Compiler directory is for packages which are only Compiler
dependent. Lastly, the MPI directory is packages which dependent on
MPI-Compiler pairing. The modulefiles for the compilers are placed in the
Core directory. For example the gcc version 4.9.2 file is in Core/gcc/4.9.2.lua
and contains::

    -- Setup Modulepath for packages built by this compiler
    local mroot = os.getenv("MODULEPATH_ROOT")
    local mdir  = pathJoin(mroot,"Compiler/gcc", "4.9")
    prepend_path("MODULEPATH", mdir)

This code asks the environment for **MODULEPATH_ROOT** which is
``/opt/apps/modulefiles`` and the last two lines prepend
``/opt/apps/modulefiles/Compiler/gcc/4.9`` to the **MODULEPATH** . 

The modulefiles for the MPI implementations are placed under the
Compiler directory because they only depend on a compiler. The
openmpi module file for the gcc-4.9.2 compiler is then stored at
``/opt/apps/modulefiles/Compilers/gcc/4.9/openmpi/1.8.2.lua`` and it
contains::

    -- Setup Modulepath for packages built by this MPI stack
    local mroot = os.getenv("MODULEPATH_ROOT")
    local mdir = pathJoin(mroot,"MPI/gcc", "4.9","openmpi","1.8")
    prepend_path("MODULEPATH", mdir)
    
The above code will prepend
``/opt/apps/modulefiles/MPI/gcc/4.9/openmpi/1.8`` to the
**MODULEPATH**.

We store packages as follows:

#. Core packages: **/opt/apps/pkgName/version**
#. Compiler dependent packages: **/opt/apps/compilerName-version/pkgName/version**
#. MPI-Compiler dependent packages: **/opt/apps/compilerName-version/mpiName-version/pkgName/version**

When **MODULEPATH** changes, Lmod unloads any modules which are not
currently in the **MODULEPATH** and then tries to reload all the
previously loaded modules. Any modules which are not available are
marked as inactive. Those inactive modules become active if found with
new **MODULEPATH** changes. 


.. Note::
   In all of the example above, We have used just the first two
   version numbers.  In other words, we have use 4.9 and not 4.9.2 and
   similarly 1.8 instead of 1.8.2.  It is our view that for at least
   compilers and MPI stacks that the third digit is typically a bug
   fix and doesn't require rebuilding all the dependent
   packages. Y.M.M.V.

