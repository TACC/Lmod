.. _inherit-label:

===================================================
A Personal Hierarchy Mirroring the System Hierarchy
===================================================

Suppose you as a user wants to have personal modules that work as part
of the software hierarchy.  You might want to do that if you are a
library or parallel application developer. You might want to test
libraries or parallel applications before making them publically
available. These are two possible of many that you might want to
mirror the software hierarchy. So how to go about it.

The simplest to understand (but not implement) is to just copy over
the entire compiler-mpi tree to your account and then tweek the
compiler and mpi modules to point inside your directory.  Once you
have done that, you can add the modules that you need.

But that it work.  Is there something easier to do? Yes there is.
There is much easier method (but do not implement this one
either). Just copy over the compiler and mpi modules you wish to have
in your tree.  Then add an additional directory for your packages to
prepend to **$MODULEPATH**.  However this is still problematical as
the site might change the system compiler modules tomorrow but your
copy this compiler module will be out of date.

So Lmod provides a way to get the contents of the system compiler
which then you can add on to. You can use the *inherit()* function to
"import" the same named module in the module tree.  

To make things concrete, let's assume that you are a boost developer and
the system has a boost library as well.  The system boost version is
1.8 and you are working on 1.9.  There is a system gcc 9.1 module.
You create the following directory: $HOME/my_modules and under there
you create Core, Compiler and MPI  directories::

   $ mkdir -p ~/my_modules/{Core,Compiler,MPI}

You also set the following environment variable::

   $ export MY_MODULEPATH_ROOT=$HOME/my_modules

When this is set up you will do::

   $ module use ~/my_modules/Core

Then in the file ~/my_modules/Core/gcc/9.1.lua you have::

   inherit()
   local compiler = "gcc"
   local MP_ROOT  = os.getenv("MY_MODULEPATH_ROOT")
   local version  = "9"

   prepend_path("MODULEPATH", pathJoin(MP_ROOT, "Compiler",compiler,version))

Suppose you also have the system intel/19.0.5  module.  Then you would
need at ~/my_modules/Core/intel/19.0.5.lua you have::

   inherit()
   local compiler = "intel"
   local MP_ROOT  = os.getenv("MY_MODULEPATH_ROOT")
   local version  = "19"

   prepend_path("MODULEPATH", pathJoin(MP_ROOT, "Compiler",compiler,version))

Inheriting from a marked default
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It would be best to mark your versions of the compilers (and mpi
modules if they exist) as defaults. Module that are marked defaults
are chosen over the highest version.  The easiest way to mark module
as the default is with a symbolic link::

    $ cd ~/my_modules/Core/intel; ln -s 19.0.5.lua default
    $ cd ~/my_modules/Core/gcc;   ln -s 9.1.lua    default

Then to support your personal boost 1.9 module for gcc goes at
**~/my_modules/Compiler/gcc/9/boost/1.9.lua**. And the boost 1.9 module
for the intel 19.0.5 goes at **~/my_modules/Compiler/intel/19/boost/1.9.lua**

Note that here I have used the major version number for the compiler
modules.  Here I have assumed that all gcc 9.* version work the
same. You can do this or use the full version whichever works for you.
For each compiler version you will have to have your own personal
version as well.

MPI versions
^^^^^^^^^^^^

If you wish to have a full personal compiler-MPI hierarchy mirroring
the system one, you need to add mpi stack modulefiles as well.
Assuming that you have an impi 19.0.5, you will place at
**~/my_modules/Compiler/intel/19/impi/19.0.5.lua**::

   inherit()
   local compiler   = "intel"
   local MP_ROOT    = os.getenv("MY_MODULEPATH_ROOT")
   local c_version  = "19"
   local mpiNm      = impi
   local m_version  = "19"

   prepend_path("MODULEPATH", pathJoin(MP_ROOT, "MPI",compiler,c_version,mpiNm,m_version))

Then your parallel application ACME version 1.3 will have a modulefile
found at **~/my_modules/MPI/intel/19/impi/19/acme/1.3.lua**

An example of setting up a user can be found in the source in the
rt/user_inherit directory.  In the **mf** directory is the "system"
directory and the **user_mf** directory is a user supplied tree.
