.. _module_spider_cmd:

Using the module spider command
===============================

The module spider command is reports all the modules that can be
loaded on a system.  In a flat module layout system, the *module
avail* and *module spider* return similar information.  In a
hierarchical system, *module spider* returns all the modules that are
possible where as *module avail* only reports modules that can be
loaded directly.

There are three modes to module spider

#. module spider: Report all modules, known as level 0.
#. module spider <name> : report all the versions for the modules that
   match <name>.  This is known as level 1
#. module spider <name/version>: Report detailed information on a
   particular module version. This is known as level 2

