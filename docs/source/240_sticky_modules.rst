.. _sticky_modules-label:

Sticky Modules
==============

Sites may wish to mark a module as *sticky*.  This means that if the
module is loaded then it won't be removed with a normal unload or
purge.  One possible use of sticky modules is where a site wants to
define some environment variables that define what the architecture or
operating system that allows users to use their system.  The reason to
make these values sticky is that the system may be difficult to use
without these variables set.

Suppose you have a module named "site" that will be sticky.  A lua
module would look like::

    setenv("ARCH","abc")
    add_property("lmod","sticky")

A TCL module would look like::

    #%Module
    setenv ARCH abc
    add-property lmod sticky

It is the ``add_property()`` function in Lua or ``add-property`` in
TCL which makes the module sticky.

If the "site" module is loaded then it can be unloaded by either
command::

    $ module --force unload site

or::

    $ module --force purge


Since a user can unload a sticky module if they really want to.  You
may wish to the startup scripts (i.e. /etc/profile.d/*) instead of
modules to define environment variables that you don't want users to
easily change.


Lmod Implementation
~~~~~~~~~~~~~~~~~~~

Lmod unloads all requested modules, including the sticky modules.  As
each module is unloaded it remembers any modules which are
sticky. After all modules have been unloaded, Lmod tries to load any
sticky modules found from the previous step.
