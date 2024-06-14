.. _site_package:

Modify Lmod behavior with SitePackage.lua
=========================================

Lmod provides a standard way for sites to modify its behavior. This
file is called SitePackage.lua.  Anything in this file will
automatically be loaded every time the Lmod command is run.  Here are
two suggestions on how to use your SitePackage.lua file  

#. Install Lmod normally and then overwrite your SitePackage.lua file over
   this one in the install directory.
#. Create a file named "SitePackage.lua" in a different directory separate
   from the Lmod installed directory.  Then you should modify
   your z01_lmod.sh and z01_lmod.csh (or however you initialize the
   "module" command) with:

      (for bash, zsh, etc)
      export LMOD_PACKAGE_PATH=/path/to/the/Site/Directory

      (for csh)
      setenv LMOD_PACKAGE_PATH /path/to/the/Site/Directory

A "SitePackage.lua" in that directory will override the one in the Lmod
install directory.  In other words, you only get one
"SitePackage.lua" file.  Suppose that your site has a system
SitePackage.lua which you want to extend and not override.  Suppose
that your site's SitePackage.lua is in /etc/lmod and you set::

    export LMOD_PACKAGE_PATH=/home/user/Lmod

Then in /home/user/Lmod do::

    % ln -s /etc/lmod/SitePackage.lua /home/user/Lmod/Site.lua

Then inside your /home/user/Lmod/SitePackage.lua do::

    require("Site")

Each require statement can only ``require`` one name.  So make sure
that you symlink to a new name in your personal SitePackage.lua directory.
    
Checking if you have setup SitePackage.lua correctly
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You should check to see that Lmod finds your SitePackage.lua.  If you do::
 
    $ module --config
 
and it reports::
 
    Modules based on Lua: Version X.Y.Z  3027-02-05 16:31
        by Robert McLay mclay@tacc.utexas.edu
 
    Description                      Value
    -----------                      -----
    ...
    Site Pkg location                standard

Then you haven't set things up correctly.

Possible functions for your SitePackage.lua file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two common reason a site might set up this file. The main
reason is to specify hook functions.  If your site wishes to track
module usage, you can use the load hook to have a message sent to
syslog.  The details are in contrib/track_module_usage/README.

The second reason is to provide common functions that all your
modulefiles can use.  These functions must be registered.  To prevent
modulefiles from calling arbitrary functions all modulefiles are
evaluated in a "sandbox" which limits the functions that are called.

The following SitePackage.lua file is a simple example of how to
implement a function.  In this case, we are going to provide a simple
prepend to the MODULEPATH that can be called by any modulefile.
Suppose your site is wants to use MODULEPATH_ROOT as the top level
directory and all modulepath entry are subdirectories of it.  You
could create a ``prependModulePath()`` function to simplify your
modulefiles. 

Here is the SitePackage.lua file::

   require("sandbox")

   function prependModulePath(subdir)
      local mroot = os.getenv("MODULEPATH_ROOT")
      local mdir  = pathJoin(mroot, subdir)
      prepend_path("MODULEPATH", mdir)
   end

   sandbox_registration{ prependModulePath    = prependModulePath, }

Then in your lua modulefiles you can use it to extend MODULEPATH::

   -- gcc modulefile:
   local version = "7.1"
   prependModulePath(pathJoin("Compiler/gcc/",version))

Note that if you wish to use any function defined in SitePackage.lua
in a TCL modulefile, you will need to modify tcl2lua.tcl to know about
these functions. You'll also have to merge your changes to tcl2lua.tcl
into any new version of Lmod.

There is no need to modify tcl2lua.tcl if you only add hook functions.

.. _site_package_mgrload:

Using **mgrload** function
~~~~~~~~~~~~~~~~~~~~~~~~~~

Suppose your site has an archecture state which controls the how the
modules work.  So you would like to unload all the current modules and
then set an environment variable and reload.  Here you want to use the
**mgrload** function and not the **load** function.  If you use the
load function you loose the **depends_on** () state and whether a
module was loaded by a user or was loaded by another module.  The way
this works is that you ask for the currently loaded modules with the
**loaded_modules** function to get an array of "active" objects.  So
the following is the "AVX" architecture module::

    if (mode() == "load") then
       local required = false
       local activeA = loaded_modules()
         
       for i = 1,#activeA do
          io.stderr:write("Unloading: ",activeA[i].userName,"\n")
          unload(activeA[i].userName)
       end
       setenv("SITE_CURRENT_ARCH","avx")
       for i = 1,#activeA do
          io.stderr:write("loading: ",activeA[i].userName,"\n")
          mgrload(required, activeA[i])
       end
    end   

  
