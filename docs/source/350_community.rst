.. _community-label:

============================================
Support Community Modules Collections Safely
============================================


Sites may wish to include community based packages use the module
system.  However not all users at a site want to know about a
specialized group of modules.  Also the community may provide bugg
modules.  There is a way to protect your regular users from the
different collections.

The goals of this method are the following:

#. All users just see a gateway module for each collection.
#. The modules in the collection do not show up in avail or spider for regular users.
#. To see the collection a user must load the gateway module.
#. After loading the gateway module then will "module avail" and "module spider" show the collection.
#. Optionally sites can provide a spider cache for each separate collection if it is large.

Suppose you have a group that provides a collection of biology
packages.  Lets call the gateway module "biology".  Here is a
prototype module where you are going provide a spider cache for the collection::

     if ( mode() ~= "spider" ) then
        prepend_path("MODULEPATH",    "/path/to/biology/modulefiles")
     end

     -- Only do the following if you are providing a spider cache for
     -- this collection
     prepend_path("LMOD_RC",         "/path/to/biology/lmodrc.lua")

If you are providing a spider cache for the collection then your site
will need a lmodrc.lua file for the collection::

     scDescriptT = {
       {
         ["dir"]      =  "/path/to/biology/spider_cache",
         ["timestamp"] = "/path/to/biology/timestamp",
       },
     }    

Finally you need to build the spider cache.  This can be done with
**update_lmod_system_cache_files**::

    % $LMOD_DIR/update_lmod_system_cache_files -d /path/to/biology/spider_cache -t /path/to/biology/timestamp /path/to/modulefiles

This command to update the cache files must be done every time there
are new modulefiles added to the collection and typically has to be
run with a privileged account or one that can write to the
directories.  It may be best if the cache file is regenerated
automatically (say every 30 minutes) to keep it up-to-date.

Also it is important that all the paths match between the gateway
modulefile, the lmodrc.lua file and command line above.




 


