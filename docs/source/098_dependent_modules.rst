.. _dependent_modules-label:

Dependent Modules
=================

Let's assume that module "X" depends on module "A". There are several 
ways to handle module dependency.  Inside the "X" modulefile you could
have one of the following choices:

#. Use ``depends_on("A","B")`` or ``depends_on_any("C","D", ...)``
#. Use ``prereq("A")``
#. Use ``load("A")``
#. Use ``always_load("A")``
#. Use RPATH  to make "X" know where the libraries in "A" can be found.

Let's examine these choices in order.  The main issue for each of
these choices is what happens when module "X" is unloaded.

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


``depends_on_any("C","D")``
~~~~~~~~~~~~~~~~~~~~~~~~~~~
The function ``depends_on_any("C","D")`` works similarly to
``depends_on()`` except that Lmod picks the first available module
listed.  It first checks to see if any of the modules are already
loaded. If none are already loaded then picks the first one that can
be loaded.  On unload, Lmod remembers which of the choices it loaded
to unload.  It is not an error if that module has already been
unloaded.

Complex uses of ``depends_on()``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sites can have complex dependencies that they might wish to express
using ``depends_on()``.  Let's assume that module X depends on the
openblas package but only when using gcc.  A site might try to do the
following in the X modulefile::

 
    -- DO NOT DO THIS!!
    if (isloaded("gcc")) then
       depends_on("openblas")
    end
    -- DO NOT DO THIS!!

Let's also assume that your site is using the hierarchy where X is a
compiler dependent module and you wish to use the same modulefile for
X for both the gcc and intel compiler modules.  The above code in the
X modulefile works correctly when loading but will fail when
unloading in this common scenario:  if a user tries to swap gcc for
intel then the openblas module will likely be left loaded or inactive.

To simplify the discussion, let's have the user start with the
following modules loaded::

   $ module list

   1) gcc/7.1  2) X/1.0  3) openblas/0.2.20

And lets assume that openblas is a Core module and X is a compiler
dependent module.  Then executing::

   $ module swap gcc intel

causes gcc to be unloaded.  When gcc is unloaded it removes the path
in MODULEPATH to the gcc dependent modules which means that X will be
unloaded and marked as inactive.  The way that a module is unloaded is
that the contents of the module is evaluated and most action requested
are reversed.  So load statements cause a module to unload and a
depends_on() function is told to forgo() the modules.  The isloaded()
is not reversed.  But as you can see since the gcc modulefile is not
loaded the if statement then clause is not evaluated.  This means that
openblas will still be loaded.

In the case where openblas is a compiler-dependent module then it will
be unloaded and marked as inactive. Either way this probably not what
the site wants to happen.  The trouble here is that environment that
happens on load is not the case on unload.

There is another way to determine which compiler and/or mpi stack a
module is in and that is its filename.  This assumes that you have a
rational naming convention for module locations.  Using a similar
technique to the one describe in :ref:`generic_modules-label`.  We can
determine which compiler is in use.  So if the module file is located
in `/apps/mfiles/Compiler/<compiler>/<compiler-version>/<app-name>/<app-version>` 
then we can do the following and use the hierarchyA() function in the
X modulefile::

     local hierA = hierarchyA(myModuleFullName(),1)
     if (hierA[1]:find("^gcc/")) then
        depends_on("openblas")
     end

This will work correctly for both loading and unloading.  This, of
course, assumes that the location of the X modulefile is something
like::

    /apps/mfiles/Compiler/gcc/7.1/X/1.0.lua

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

Use RPATH
---------

We have switched to using RPATH for library dependencies at TACC. That
is when we build package X, we use the RPATH linking option to link
libraries in package A as part of the X rpm.  This has the disadvantage
that if the A package is removed then the X package is broken.
This has happened to us occasionally.  In general, however, we have found that
this has worked well for us.








