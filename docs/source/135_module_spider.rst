.. _module_spider_cmd-label:

Using the module spider command
===============================

The module spider command reports all the modules that can be
loaded on a system.  In a flat module layout system, the *module
avail* and *module spider* return similar information.  In a
hierarchical system, *module spider* returns all the modules that are
possible where as *module avail* only reports modules that can be
loaded directly.

There are three modes to module spider

#. module spider: Report all modules, known as level 0.
#. module spider <name> : Report all the versions for the modules that
   match <name>.  This is known as level 1
#. module spider <name/version>: Report detailed information on a
   particular module version. This is known as level 2


Level 0: module spider
~~~~~~~~~~~~~~~~~~~~~~

The *module spider* command by itself lists all the modules that can be found.
If your site is running a flat layout, then the information displayed
will be similar to what *module avail* reports.  A typical output
looks like::

    $ module spider
    --------------------------------------------------------------
    The following is a list of the modules currently available:
    --------------------------------------------------------------
      autotools: autotools/1.2
        Autoconf, automake, libtool

      boost: boost/1.54.0, boost/1.55.0, boost/1.56.0, boost/1.61.0, boost/1.62.0
        Boost provides free peer-reviewed portable C++ source libraries.

      fftw2: fftw2/2.1.5
        Numerical library, contains discrete Fourier transformation

      gcc: gcc/4.7.3, gcc/4.8.1, gcc/5.3.1, gcc/6.2.0
        The Gnu Compiler Collection

      hdf5: hdf5/1.8.12, hdf5/1.8.13, hdf5/1.8.14
        General purpose library and file format for storing scientific data (Serial Version)

      lmod: lmod/7.5.9
        Lmod: An Environment Module System

      mpich: mpich/3.0.4-dbg, mpich/3.0.4, mpich/3.1.1-dbg, mpich/3.1.1, mpich/3.1.2-dbg, ...
        High-Performance Portable MPI

      openmpi: openmpi/1.8.2, openmpi/1.10.3, openmpi/2.0.1
        Openmpi Version of the Message Passing Interface Library

      phdf5: phdf5/1.8.12, phdf5/1.8.13, phdf5/1.8.14
        General purpose library and file format for storing scientific data (parallel I/O version)



This output shows the name of the module followed by a list of the
fullnames of the modules.  If there are more modules then can fit on
one line, the the list is truncated.  Below is the description.  Lmod
looks for a particular whatis command in the modulefile.  For example,
the autotools module has a whatis function call that looks like the
following in a lua modulefile::

    whatis("Description: Autoconf, automake, libtool")

In a TCL modulefile it would look like::

    module-whatis "Description: Autoconf, automake, libtool"

If your output of *module spider* doesn't have a description, please
ask your site to consider adding an appropriate whatis line in
your modulefiles.

Level 1: module spider name1 name2 ...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can get more details about particular modules by adding one or more
names to the command to get a level 1 command.  For example::

   $ module spider hdf5

   ----------------------------------------------------------------------------
     hdf5:
   ----------------------------------------------------------------------------
       Description:
         General purpose library and file format for storing scientific data
         (Serial Version)

        Versions:
           hdf5/1.8.12
           hdf5/1.8.13
           hdf5/1.8.14
        Other possible modules matches:
           phdf5

Since the name "hdf5" matches a module name, Lmod only reports on the
hdf5 module and not the phdf5 module.  It does report that other
matches are possible (such as phdf5).  The reason for this is some
sites name the  R stat package as R.  This rule is to prevent getting
every module that has an 'r' in it.  Note that the searching for
modules is case insensitive.  So *module spider openmpi* would match a
module named *OpenMPI*.

If you search a name that only partially matches a module name then
Lmod reports all matches::

   $ module spider df5 

   ----------------------------------------------------------------------------
     hdf5:
   ----------------------------------------------------------------------------
       Description:
         General purpose library and file format for storing scientific data
         (Serial Version)

        Versions:
           hdf5/1.8.12
           hdf5/1.8.13
           hdf5/1.8.14

   ----------------------------------------------------------------------------
     phdf5:
   ----------------------------------------------------------------------------
       Description:
         General purpose library and file format for storing scientific data
         (parallel I/O version)

        Versions:
           phdf5/1.8.12
           phdf5/1.8.13
           phdf5/1.8.14


Finally, you can perform regular expression matches with::

  $ module -r spider '.*hdf5.*'



Level 2: module spider name/version
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The level 2 output provides a detailed report on a module::

   $ module  spider phdf5/1.8.14         

   ----------------------------------------------------------------------------
     phdf5: phdf5/1.8.14
   ----------------------------------------------------------------------------
       Description:
         General purpose library and file format for storing scientific
         data (parallel I/O version)

       You will need to load all module(s) on any one of the lines below
       before the "phdf5/1.8.14" module is available to load.

         gcc/4.8.1  mpich/3.1.1
         gcc/4.8.1  mpich/3.1.2
         gcc/4.8.1  openmpi/1.8.2


       Help:
          The HDF5 module defines the following environment variables:
          ...
      
