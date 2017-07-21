.. _dependent_modules-label:

Dependent Modules
=================

Let's assume that module "X" depends on module "A". There are several 
ways to handle module dependency.  Inside the "X" modulefile you could
have one of the following choices:

#. Use ``prereq("A")``
#. Use ``load("A")``
#. Use ``always_load("A")``
#. Use RPATH  to make "X" know where the libraries in "A" can be found.
#. Use ``if (not isloaded("A")) then load("A") end``
#. Use ``if (not isloaded("A")) then always_load("A") end``
#. Use ``depends_on("A")``

Let's examine these choices in order.  The main issue for each of
these choices is what happens when module "X" is unloaded.

``prereq("A")``
~~~~~~~~~~~~~~~

This choice is the one you give for sophisticated users. If a user
tried to load module "X" without previously loading "A" then the user
will get a message telling the user that they must load "A" before
loading "X".  This way the dependency is explicitly handled by the
user.  When the user unloads "X", module "A" will remain loaded.


``load("A")``
~~~~~~~~~~~~~

This choice will always load module "A" on the users behalf. This is
true even if "A" is already loaded.  When module "X" is unloaded,
module "A" will be unloaded as well. This may surprise some users who
might want to continue using the "A" package.  At least with
``prereq()``, your users won't be surprised by this.  Another way to
handle this is the next choice. 



``always_load("A")``
~~~~~~~~~~~~~~~~~~~~

A site can chose to use ``always_load()`` instead.  This command is a
shorthand for::

   if (mode() == "load") then
      load("A")
   end

The TCL equivalent is::

   if { [ module-info mode load ] } {
      module load A
   }

This choice will always load module "A" on the users behalf.  This is
true even if "A" is already loaded.  When module "X" is unloaded, 
module "A" will remain loaded. 

``if (not isloaded("A")) then load("A") end``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This choice will load module "A" on the users behalf if it not already
loaded.  When module "X" is unloaded, module "A" will be unloaded as
well.

``if (not isloaded("A")) then always_load("A") end``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This choice will load module "A" on the users behalf if it not already
loaded.  When module "X" is unloaded, module "A" will remain loaded. 

Use RPATH
---------

We have switched to using RPATH for library dependencies at TACC. That
is when we build package X, we use the RPATH linking option to link
libraries in package A as part of the X rpm.  This has the disadvantage
that if the A package is removed then the X package is broken.
This has happened to us occasionally.  In general, however, we have found that
this has worked well for us.

``depends_on("A")``
~~~~~~~~~~~~~~~~~~~

This choice loads module "A" on the users behalf if it not already
loaded. When module "X" is unloaded, module "A" will be unloaded if it
is a dependent load.  Imagine the following scenario with
``depends_on("A")``::

   $ module purge; module load X; module unload X                => unload A
   $ module purge; module load A; module load X; module unload X => keep A

Lmod implements reference counting for modules loaded via
``depends_on()`` and only ``depends_on()``.  So if "X" and "Y" depend
on "A" then::

   $ module purge; module load X Y; module unload X   => keep A   
   $ module purge; module load X Y; module unload X Y => unload A
