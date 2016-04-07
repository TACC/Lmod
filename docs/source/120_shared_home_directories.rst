Lmod on Shared Home File Systems
================================

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



