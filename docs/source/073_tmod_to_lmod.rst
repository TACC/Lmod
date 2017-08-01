Converting from TCL/C Environment Modules to Lmod
=================================================

Sites converting from the TCL/C based Environment Modules (a.k.a Tmod)
should be aware of some of the differences between Tmod and Lmod. Lmod
is a complete re-implementation of the environment module concept with
no code reuse from the original program. There are some differences
between that can affect how easy your transition to Lmod.

One major difference between the two tools is that Lmod is written in
Lua and not TCL.  Lmod has to translate TCL into Lua.  This means that
pure TCL statements are evaluated by a program called
**tcl2lua.tcl**. This program outputs lua statements.  This can lead
to difference between Tmod and Lmod because different order that
statements are evaluated.  The details are discussed at
:ref:`tcl2lua-label`.

Another important difference between the tools is that Lmod has the
*One Name* rule.  That is you can only have one "name" loaded at a time.
Suppose a user tries to load gcc/5.4 and gcc/7.1 at the same time::

    $ module load gcc/5.4
    $ module load gcc/7.1

    The following have been reloaded with a version change:
      1) gcc/5.4 => gcc/7.1

Lmod is telling you that the gcc/5.4 has been replaced by gcc/7.1.
This happens automatically without anything special in the
modulefiles.


Module Naming rules
~~~~~~~~~~~~~~~~~~~

The fullname of a module is split into name/version.  Normally the
version is just the string after the last slash.  So gcc/5.4 has a
name of gcc and a version of 5.4.  A module named compiler/gcc/5.4
would have a name of compiler/gcc and a version of 5.4.

With Lmod 7+, sites can change the name - version split if they like.
For example a site might name their modules bowtie/64/3.4 and
bowtie/32/3.4 where the name of the module would be bowtie and the
version would be either 64/3.4 or 32/3.4. Please see :ref:`NVV-label`
for details.
