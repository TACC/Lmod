.. _hooks

SitePackage.lua and hooks
=========================

Sites may wish to alter the behavior of Lmod to suit their needs.  A
good place to do this is the ``SitePackage.lua``. Anything in this
file will automatically be loaded every time the Lmod command  is run.
This file can be used to provide common functions that can be used in
a sites modulefiles.  It is also a place where a site can implement
their hook functions.

Hook functions are normal functions that if implemented and registered
with Lmod will be called when certain operations happen inside Lmod.
For example, there is a load hook.  A site can register a function
that is called every time a module is loaded.  There are several hook
functions that are discussed in :ref:`hook_functions`.


How to set up SitePackage.lua
-----------------------------
Here are two suggestions on how to use your SitePackage.lua file:

#. Install Lmod normally and then overwrite your SitePackage.lua file over
   this one in the install directory.

#. Create a file named "SitePackage.lua" in a different directory separate
   from the Lmod installed directory and it will override the one in the Lmod
   install directory.  Then you should modify your z00_lmod.sh and
   z00_lmod.csh (or however you initialize the "module" command)
   with::

       (for bash, zsh, etc)
       export LMOD_PACKAGE_PATH=/path/to/the/Site/Directory

       (for csh)
       setenv LMOD_PACKAGE_PATH /path/to/the/Site/Directory


Implementing functions in SitePackage.lua
-----------------------------------------

For example your site might wish to provide the following function to
set ``MODULEPATH`` inside your SitePackage::

   function prependModulePath(subdir)
      local mroot = os.getenv("MODULEPATH_ROOT")
      local mdir  = pathJoin(mroot, subdir)
      prepend_path("MODULEPATH", mdir)
   end

This function must be registered with the sandbox so that Lmod
modulefiles can call it::

   sandbox_registration{ prependModulePath    = prependModulePath }



.. _hook_functions:

Hook functions
--------------

**load**(...):
  This function is called after a modulefile is loaded.

**unload**(...):
  This function is called after a modulefile is unloaded.

**parse_updateFn**(...):
  This hook returns the time on the timestamp file.

**writeCache**(...):
  This hook return whether a cache should be written.

**SiteName**(...):
  This hook is used to specify Site Name. It is used to generate
  family prefix:  ``site_FAMILY_``

**msgHook**(...):
  Hook to print messages after avail, list, spider, LmodError and LmodWarning.

**groupName**(...):
  This hook adds the arch and os name to moduleT.lua to make it safe
  on shared filesystems.

**avail**(...):
  Map directory names to labels

**restore(...):
  This hook is run after restore operation

**startup(UsrCmd):
  This hook is run when Lmod is called

**packagebasename(s_patDir, s_patLib):
  This hook gives you a table with the current patterns that spider uses to
  construct the reverse map.







