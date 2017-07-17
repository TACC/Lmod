.. _dependent_modules-label:

Dependent Modules
=================

Let's assume that module "X" depends on module "A". There are several 
ways to handle module dependency.  Inside the "X" modulefile you could
have one of the following choices:

#. Use ``prereq("A")``
#. Use ``load("A")``
#. Use ``always_load("A")``
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
module "A" will be unloaded as well. 


``always_load("A")``
~~~~~~~~~~~~~~~~~~~~

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


``depends_on("A")``
~~~~~~~~~~~~~~~~~~~

This choice loads module "A" on the users behalf if it not already
loaded. When module "X" is unloaded, module "A" will be unloaded if it
is a dependent load.  Imagine the following scenario with
depends_on("A")::

   $ module purge; module load X; module unload X => unload A
   $ module purge; module load A; module load X; module unload X => keep A

Note that Lmod *does not* know that if both module "X" and "Y" depend
on "A".  So if a user loads both "X" and "Y" and then unloads "X",
module "A" will be unloaded unless the user has explicitly load "A" on
the command line.
