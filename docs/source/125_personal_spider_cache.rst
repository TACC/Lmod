.. _user-spider-cache-label:

User Spider Cache
=================

In :ref:`system-spider-cache-label`, we described how to build a
system cache.  If there is no system cache available then Lmod can
produce a user based spider cache.  It gets written to
**~/.lmod.d/.cache**.  It is designed to provide improved speed of
performing doing module avail or module spider.  But it is not without
its problems.  The first point is that if Lmod thinks any spider cache
is valid, it uses it for the MODULEPATH directories it covers then it
uses it instead of walking the tree.


Personal Cache rules:

#. If it can't find a valid cache then Lmod walks the tree to find all
   available modules and builds the spider cache in memory.
#. If the time it takes to build the cache is longer than the contents
   of env var. LMOD_SHORT_TIME (default 2 seconds) then Lmod writes
   the cache file into the ~/.lmod.d/.cache directory.
#. A user's cache is assumed to be valid for the contents of
   LMOD_ANCIENT_TIME (default 86400 seconds or 24 hours) based on the
   date associated with the cache file.


Sites can change these defaults at configure time.  Users can set the
environment variables to change their personal setting.

To turn off the generation of a user cache, one can set
LMOD_SHORT_TIME to some big number of seconds.  For example::

     export LMOD_SHORT_TIME=86400

would say that Lmod only write the user cache file if it took longer
than 1 day (=86400 seconds).  A second way do to this is do make the
user cache directory unwritable::

     $ rm -rf    ~/.lmod.d/.cache
     $ chmod 500 ~/.lmod.d/.cache
