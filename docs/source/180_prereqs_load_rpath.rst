Choices in handling module dependencies
=======================================

One module can depend on another: e.g. package XYZ depends on boost
version 1.51.0.  How might a site handle this?

There are at least four choices:

#. Have module XYZ have prereq("boost/1.51.0")
#. Use load("boost/1.51.0") in the XYZ module.
#. Use always_load("boost/1.51.0") in the XYZ module.
#. Use RPATH to make PACKAGE XYZ know where the right boost 1.51.0
   is.  The boost module doesn't need to be loaded.

Use ``prereq(...)``
-------------------

One of the obvious choices is to use ``prereq()``.  Using this has
some advantages.  It is clear that if package XYZ needs boost/1.51.0
and boost isn't loaded then Lmod generates an error and stops.  The
user then must load the correct version of boost and XYZ.  For
sophisticated users this is good choice.  There are no surprises,
especially compared with the next possibility.

However, many users want to use package XYZ and do not wish to have to
load the prerequisites especially when there are more than one.  So a
site might want to try other options. 

Load dependencies directly
--------------------------

A site could make the XYZ module load the boost dependency::

    load("boost/1.51.0")

This allows the user to load the XYZ module and the requirements are
meant.

The trouble with using ``load()`` is when unloading XYZ.  Imagine a
does the following::

     $ module load boost/1.51.0
     $ module load XYZ
     ...
     $ module unload XYZ

At the end of this sequence of commands the ``boost/1.51.0`` has been
unloaded because unloading XYZ forces ``boost/1.51.0`` to be unloaded
as well.  This may surprise some users who might want to continue
using the boost package.  At least with ``prereq()``, your users won't
be surprised by this.  Another way to handle this is the next choice.


Use ``always_load()`` instead of ``load()``
-------------------------------------------

A site can chose to use ``always_load()`` instead.  This command is a
shorthand for::

   if (mode() == "load") then
      load("boost/1.51.0")
   end

The TCL equivalent is::

   if { [ module-info mode load ] } {
      module load boost/1.51.0
   }

These approaches mean that package XYZ and be loaded and the boost
dependency is also loaded.  But when XYZ is unloaded the boost module
remains.  For library dependencies, the next technique has advantages
but for non-library packages dependencies, the ``always_load()`` is a
good way to go. 

Use RPATH
---------

We have switched to using RPATH for library dependencies at TACC. That
is when we build package XYZ, we use the RPATH linking option to link
``boost/1.51.0`` as part of the XYZ rpm.  This has the disadvantage
that if the boost package is removed then the XYZ package is broken.
This has happened to us occasionally.  In general, however, we have found that
this has worked well for us.
