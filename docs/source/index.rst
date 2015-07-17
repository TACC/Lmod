
Lmod: A New Environment Module System
=====================================

Guides
^^^^^^

This a daunting list of documentation.  However all of this doesn't have to
be read to use Lmod.  Users should just read the User Guide and
possibly the FAQ.  Advanced users wishing to have personal modules,
should read the Advanced user guide and possibly the Lua Modulefile
Function guide.  System adminstrators should read the Install Lua and
Lmod as well as the Transitioning to Lmod first.  Other sections can
be read as needed.


.. toctree::
   :maxdepth: 1

   010_user
   020_advanced
   030_installing
   040_FAQ
   045_transition
   050_lua_modulefiles
   060_locating
   070_standard_modules
   080_hierarchy
   090_configuring_lmod
   095_tcl2lua
   100_generic_modules

The following are possible topics:

#. Optional Software layout, two digit rule
#. Module naming conventions
#. Spider Cache Theory and Practice
#. Advanced Topics: priority path, .modulerc tricks, deprecating modules
#. settarg
#. SitePackage.lua and hooks
#. tracking module usage
#. converting shell scripts into modulefiles
#. module command and a parallel a file system.
#. inherit
#. internal structure of lmod.


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


   

