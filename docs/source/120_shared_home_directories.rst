.. _shared_home_file_system:


Lmod on Shared Home File Systems
================================

Many sites have a single Operating System and one set of modules
across their cluster.  If a site has more than one cluster, they may
chose to have a separate home directory for each cluster.  Some sites
may wish to have multiple clusters share a single home directory.
While this strategy has some advantages, it complicates things for
your users and administrators.  If your site has a single home
directory sharing between two or more clusters, you have a shared
home file system.

As a further complication, your site may or may not have a shared home
file system even if you have two or more clusters.  If you have
separate login nodes for each cluster then you do have a shared home
file system.  If you have a single login which can submit jobs to
different clusters then you do not have a shared home file system.

The way to think about this is each cluster is going to have at least
some modules which are different.  Module collections need to be
unique to each cluster.  The trick described below will make them
unique for each cluster.

Sites that use a shared home file system across multiple clusters
should take some extra steps to ensure the smooth running of Lmod.
Typically each cluster will use different modules.

There are three steps that will make Lmod run smoothly on a shared
home filesystem:

#. It is best to have a separate installation of Lmod on each
   cluster.
#. Define the environment variable "LMOD_SYSTEM_NAME" uniquely for
   each cluster.
#. If you build a system spider cache, then build a separate cache for
   each cluster.

A separate installation on each cluster is the safest way to install
Lmod.  It is possible to have a single installation but since there is
some C code build with Lmod, this has to work on all clusters.  Also
the location of the Lua interpreter must be exactly the same on each
cluster.

It is also recommended that you set "LMOD_SYSTEM_NAME" outside of a
modulefile. It would be bad if a module purge would clear that value.
When you set this variable, it makes the module collections and user
spider caches unique for a given cluster.

A separate system spider cache is really the only way to go.
Otherwise a "module spider" will report modules that don't exist on
the current cluster.  If you have a separate install of Lmod on each
cluster then you can specify the location of system cache at configure
time.  If you don't, you can use the "LMOD_RC" environment to specify
the location of the lmodrc.lua file uniquely on each cluster.

Lmod knows about the system spider cache from the lmodrc.lua file.  If
you install separate instances of Lmod on each cluster, Lmod builds
the scDescriptT table for you.  Otherwise you can modify lmodrc.lua to
point to the system cache by adding scDescriptT to the end of the file::

   scDescriptT = {
     {
       ["dir"] = "<location of your system cache directory>,
       ["timestamp"] = "<location of your timestamp file",
     },
   }

where you have filled in the location of both the system cache directory
and timestamp file.



