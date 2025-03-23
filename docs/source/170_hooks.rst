.. _hooks:

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
   this one in the install directory.  This is good for testing but
   it is recommended that sites use the second method for permanent
   changes.  Otherwise changes may be lost when upgrading Lmod.

#. Create a file named "SitePackage.lua" in a different directory separate
   from the Lmod installed directory and it will override the one in the Lmod
   install directory.  Then you should modify your z00_lmod.sh and
   z00_lmod.csh (or however you initialize the "module" command)
   with::

       (for bash, zsh)
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


Hook tips
---------

# If you want to know which modules are being loaded, use the FrameStack::

    local frameStk = FrameStk:singleton()
    -- check if anything else gets loaded
    if not frameStk:empty() then
        print("This modules has no dependencies loaded.")
    end

    -- the module at the top of the FrameStack is the one the user requested
    local userload = (frameStk:atTop()) and "yes" or "no"

# If you want to know which modules are loaded, you can use the ModuleTable::

    local mt = MT:singleton()
    if mt:exists('shortname') then
        print("Module shortname is loaded")
    end

# If you want to know the short name or path of a loaded module, you can use the ModuleTable::

    local mname   = MName:new("mt", FullModuleName)
    local sn      = mname:sn()
    local version = mname:version()

.. _hook_functions:

Hook functions
--------------

The following is the list of hooks supported by Lmod. To use these hooks
will require some Lua coding expertise and studying how the hooks are
used in the Lmod program.  


**load** (...):
  This function is called after a modulefile is loaded in "load"
  mode. Use **load_spider()** hook instead when desiring a hook during
  spider evaluation.

**unload** (...):
  This function is called after a modulefile is unloaded in "unload" mode.

**colorize_fullName** (fullName, sn):
  (Returns: string)
  Allows a site to colorize how module names are displayed in "module
  av" and "module list".

**parse_updateFn** (...):
  This hook returns the time on the timestamp file.

**writeCache** (...):
  This hook return whether a cache should be written.

**SiteName** (...): 
  (Returns: string: SiteName)
  This hook is used to specify Site Name. It is used to generate
  family prefix:  ``site_FAMILY_COMPILER`` ``site_FAMILY_MPI``

**msgHook** (...):
  (Return: string)
  Hook to print messages after avail, list, spider.

**errWarnMsgHook** (...):
  (Returns: string)
  Hook to print messages after LmodError, LmodWarning, LmodMessage.

**groupName** (...):
  (Returns: string)
  This hook adds the arch and os name to moduleT.lua to make it safe
  on shared filesystems.

**category** (...):
  (Returns: array)
  Allows sites to control what categories are printed for the command
  **module category**.


**avail** (...):
  Map directory names to labels

**restore** (...):
  This hook is run after restore operation

**startup** (UsrCmd):
  This hook is run when Lmod is called but before any command is run.

**finalize** (UsrCmd):
  This hook is run just before Lmod generates its output of
  environment variables and aliases and shell functions and exits.

**packagebasename** (s_patDir, s_patLib):
  This hook gives you a table with the current patterns that spider uses to
  construct the reverse map.

**load_spider** (...):
  This hook is called when spider is evaluating a modulefile.

**isVisibleHook** (modT):
  This hook is called when evaluating whether a module is visible or hidden. It's
  argument is a table containing: fullName, sn (short name), fn (file path) and
  isVisible (boolean) of the module.

**reverseMapPathFilter** (keepA, ignoreA):
  (Returns: 2 arrays)
  This hook returns two arrays: *keepA* and *ignoreA*.  The *keepA* is
  an array of paths patterns that a site wishes to be stored in the spider
  cache. The *ignoreA* is an array of path patterns to ignore in the
  cache. See *src/StandardPackage.lua* has an example on how to
  implement this hook.  This hook is used to control the directories
  that are included/excluded in the reverseMap.

**spider_decoration** (table):
  (Returns: table)
  This hook provide a way for a site to add decoration to spider level
  1 output.  The table passed in contains the whatis category and the
  property table.  See *rt/uitSitePkg/mf/site_scripts/SitePackage.lua*
  for a complete example.

**decorate_module** (table):
  (Returns: table)
  This hook allows a site to add contents to a module file (e.g. add
  ``add_property(...)`` based on the location of the module file). It
  provides a table ``{path, name, version, contents}`` as a parameter and
  should return an indexed table of strings to add to the module file as lines.
  

Example Hook: msgHook
---------------------

A site might like to control the output of list, avail, and spider
commands by adding text to the beginning or end of the generated text.

Here is an example of how to use the  msgHook.  So inside a site's
SitePackage.lua file one would do::

    local hook = require("Hook")

    function myMsgHook(kind,a)
       if (kind == "avail") then

          -- Here is text that would go at the top of avail:
          table.insert(a,1,"This system has ...\n")
          table.insert(a,2,"blah blah blah ...\n")
          table.insert(a,3,"more blah blah blah ...\n")

          -- Here is text that would go at the end of avail:
          a[#a+1] = "More blah blah ...\n"
          a[#a+1] = "yet more blah blah ...\n"
       elseif (kind == "list") then
          ...
       elseif (kind == "spider") then
          ...
       end
       return a
    end

    hook.register("msgHook", myMsgHook)

As you can see you can add text to the beginning and/or the end of the
text that is generated by avail, spider and list.

.. _registering_multiple_hook_functions-label:

Registering Multiple Hook functions
-----------------------------------

Lmod 8.7.35+ supports sites registering multiple functions for a
single hook.  The function **hook.register()** now takes an optional
third argument to control how the functions are evaluated.
For example, a site may wish to register more than one
load hook::


    local function load_hook_a(t)
        local frameStk  = require("FrameStk"):singleton()
        local mt        = frameStk:mt()
        local simpleName = string.match(t.modFullName, "(.-)/")
        LmodMessage("Load hook A called on " .. simpleName)
    end

    local function load_hook_b(t)
        local frameStk  = require("FrameStk"):singleton()
        local mt        = frameStk:mt()
        local simpleName = string.match(t.modFullName, "(.-)/")
        LmodMessage("Load hook B called on " .. simpleName)
    end

    hook.register("load", load_hook_a)
    hook.register("load", load_hook_b) -- overwrites the previous hook,
    -- expected output for 'module load my_software/version':
    -- Load hook B called on my_software

    hook.register("load", load_hook_a)
    hook.register("load", load_hook_b, "replace") -- overwrites the previous hook function,
    -- expected output for 'module load my_software/version':
    -- Load hook B called on my_software

    -- > the following will run load_hook_a then load_hook_b.
    hook.register("load", load_hook_a)           -- initializes the load hook function
    hook.register("load", load_hook_b, "append") -- appends to the previous hook function.
    -- expected output for 'module load my_software/version':
    -- Load hook A called on my_software
    -- Load hook B called on my_software

    -- > the following will run load_hook_b then load_hook_a
    hook.register("load", load_hook_a)            -- initializes the load hook function
    hook.register("load", load_hook_b, "prepend") -- prepends to the previous hook function
    -- expected output for 'module load my_software/version':
    -- Load hook B called on my_software
    -- Load hook A called on my_software

Note that if the optional third argument (the action argument) is not
provided, the default behaviour is "replace". 

There are some hooks (such as groupName, SiteName, etc) that require
return values.  The last registered hook function will be used to return
the value.
