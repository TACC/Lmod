
Lmod: The Modern Environment Module System
==========================================

Guides
^^^^^^

.. toctree::
   :maxdepth: 1

   01_user
   02_advanced
   03_installing
   04_FAQ
   05_lua_modulefiles
   06_locating
   07_standard_modules
   08_hierarchy
   09_configuring_lmod

User Guide:
   This is the guide for users getting started with Lmod.

Advanced User Guide:
   This is the guide for advanced users wishing to have their own modules.

Installing Lua and Lmod:
   This is the guide for sys admin who want to install Lmod.

Lua Modulefile Functions:
   The lua functions use in a modulefile.

Locating Modules:
   How Lmod a module file to load.

Providing a Standard Set of Modules
   Providing your users a way to read their default collection or
   a system standard.

Software Hierarchy
   How to use a Module hierarchy with Lmod.

Configuring Lmod
   How to configure Lmod to match site expectations.

PURPOSE
^^^^^^^

Lmod is a Lua based module system that easily handles the MODULEPATH
Hierarchical problem. Environment Modules provide a convenient way to
dynamically change the users' environment through modulefiles. This
includes easily adding or removing directories to the PATH environment
variable. Modulefiles for Library packages provide environment
variables that specify where the library and header files can be
found.

OVERVIEW
^^^^^^^^

This guide is written to explain what Environment Modules are and why
they are very useful for both users and system administrators. Lmod is
an implementation of Environment Modules, much of what is said here is
true for any environment modules system but there are many features
which are unique to Lmod. 

Environment Modules provide a convenient way to dynamically change the
users' environment through modulefiles. This includes easily adding or
removing directories to the PATH environment variable. 

A modulefile contains the necessary information to allow a user to run
a particular application or provide access to a particular
library. All of this can be done dynamically without logging out and
back in. Modulefiles for applications modify the user's path to make
access easy. Modulefiles for Library packages provide environment
variables that specify where the library and header files can be
found. 

Packages can be loaded and unloaded cleanly through the module
system. All the popular shells are supported: bash, ksh, csh, tcsh,
zsh.  Also available for perl and python. 

It is also very easy to switch between different versions of a package
or remove it. 

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


   

