.. _terse_output-label:

Terse output for computer programs
==================================

Normal output from Lmod for *module list*, *module avail* and *module
spider* are designed to be readable by users.  Having computer
programs parse this output is complicated.  So Lmod has a terse option
(--*terse* or -*t*) to provide output for computer programs to read.
The tab-completion that Lmod provide uses this terse output
extensively. There are two other options that Lmod provides discussed
below (--*dumpname* and --*dumpversion*).

Terse decorations
~~~~~~~~~~~~~~~~~
Aliases are marked with a parentheses an **@** and the true module
file::

   a13(@a/13.2)

where *a13* is an alias for *a/13.2*.
   

As of Lmod 8.7.50, Lmod produces some decorations to terse output.
Hidden modules are marked by **<H>**, soft hidden modules are marked
by **<s>**, module that are hidden when using *module list* are
displayed as **<HL>**, nearly forbidden module are
marked by **<NF>** and **<F>** for forbidden modules.

Sites can set the environment variable LMOD_TERSE_DECORATIONS=no to
turn these angle bracket decorations off.


module --terse list
~~~~~~~~~~~~~~~~~~~

The terse output for "module --terse list" is a list of the currently loaded
modules::

  % module --terse list

  H/1.0 <H>
  C/2.0

module --terse avail
~~~~~~~~~~~~~~~~~~~~

The terse output for "module --terse avail" is a list of the currently
available modules::

   % module --terse avail

   a13(@a/13.2.345)
   /opt/apps/modulefiles:
   ab2/
   ab2/7(@ab2/7.4.3)
   ab2/7.4(@ab2/7.4.3)
   ab2/7.4.3
   /opt/apps/other:
   C/ 
   C/1.0
   C/2.0
   C/3.0 <F>
   /opt/apps/lmod/modulefiles:
   lmod

Note that global aliases are reported first (if any). This is followed
by a directory that ends in a colon (**:**).  Then the shortname (sn)
follows with a trailing slash.  The local aliases are reported along
with the regular modules.  If there is no trailing "**/**" then that
is a module not a short name.

module --terse spider
~~~~~~~~~~~~~~~~~~~~~

The terse output for "module --terse spider" is very similar to the
terse output for "module --terse avail".  The only differences are
that no directories or aliases are reported.


module --terse spider *package*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This output will report the versions of this module::

    % ml -t spider petsc
    petsc/3.2
    petsc/3.4.3
    petsc/3.12

module --terse spider *package*/*version*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This output reports the dependent modules if a software hierarchy is
used::

    % ml -t spider petsc/3.12

    gcc/7.3.0  mpich/3.2.1
    gcc/7.3.0  mpich/3.2.1-dbg

  
