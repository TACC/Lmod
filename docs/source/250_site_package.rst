.. _site_package:

Modify Lmod behavior with SitePackage.lua
=========================================

Lmod provides a standard way for sites to modify its behavior. This
file is called SitePackage.lua.

Here are some notes on what should be discussed here:

#. Here is where you can have a function that all your modules can
   call.  Note that these are for lua modulefiles.  If you have TCL
   module files, you'll have to modify tcl2lua.tcl to a TCL function
   into lua.
#. Functions must be registered.  Modulefiles are evaluated in a
   "sandbox". Modules can only execute functions that are registered.

#. Here is where to add hook functions.
#. See contrib/tracking_module_usage/README to track your sites module
   usage.
