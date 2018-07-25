.. _system-spider-cache-label:

System Spider Cache
===================

It is now very important that sites with large modulefile
installations build system spider cache files. There is a shell script
called "update_lmod_system_cache_files" that builds a system cache
file.  It also touches a file called "system.txt".  Whatever the name
of this file is, Lmod uses this file to know that the spider cache is
up-to-date.

Lmod uses the spider cache file as a replacement for walking the directory tree
to find all modulefiles in your ``MODULEPATH``.  This means that Lmod only knows
about system modules that are found in the spider cache.  Lmod won't know about
any system modules that are not in this cache.  (Personal module files are
always found).  It turns out that reading a single file is much faster than
walking the directory tree.

The spider cache is used to speed up ``module avail`` and ``module
spider`` and not ``module load``. All the spider cache file(s) provide
is a way for Lmod to know what modules exist and any properties that a
modulefile might have.  It does not save the contents of any
modulefiles.  Lmod always reads and evaluate the actual modulefile
when performing loads, shows and similar commands.

The reason that Lmod does not use the cache with ``module load`` is that
if the spider cache is out-of-date, then Lmod will not be able to load
a module. Either Lmod uses the spider cache or it walks the
directories in ``MODULEPATH``.

A site may choose to use have the spider cache assist the ``module
load`` command by configuring Lmod or setting the environment variable::

   export LMOD_CACHED_LOADS=yes

See :ref:`env_vars-label` for more details.  Just remember that the
cache file has to be up-to-date or user's won't be able to find system
modulefiles!  Note too, that a cache file is tied to a particular set
of directories in the MODULEPATH.  Lmod knows which directories in
``MODULEPATH`` are covered by spider cache file(s) and which are
not. So having a system spider cache file and setting
LMOD_CACHED_LOADS=yes will not hamper modulefiles created
by users in personal directories.

While building the spider cache, each modulefile is evaluated for
changes to ``MODULEPATH``.  Any directories added to ``MODULEPATH``
are also walked.  This means if your site uses the software hierarchy
then the new directories added by compiler or mpi stack modulefiles
will also be searched.


Sites running Lmod have three choices:

#. Do not create a spider cache for system modules.  This will work fine as
   long as the number of modules is not too large.  You will know when it
   is time to start building a cache file when you start getting complains
   how long it takes to do any module commands.

#. If you have a formal procedure for installing packages on your system,
   then I recommend you to do the following.  Have the install procedure run
   the update_lmod_system_cache_files script.  This will create a file
   called "system.txt", which marks the time that the system was last
   updated, so that Lmod knows that the cache is still good.

#. Or you can run the update_lmod_system_cache_files script say every
   30 minutes.  This way the cache file is up-to-date.  No new module
   will be unknown for more than 30 minutes.


There are two ways to specify how cache directories and timestamp files are
specified.  You can use "--with-spiderCacheDir=dirs" and
"--with-updateSystemFn=file" to specify one or more directories with a
single timestamp file::

  ./configure --with-spiderCacheDir=/opt/mData/cacheDir --with-updateSystemFn=/opt/mdata/system.txt



If you have multiple directories each with their own timestamp file,
you can list those in a file that configure will read rather than
enumerating them with –with-spiderCacheDescript=file.  This also enables
each cache directory to have its own timestamp.  The file is only used
at configure time, not when Lmod runs, and is used like::

    cacheDir1:timestamp1
    cacheDir2:timestamp2

Lines starting with '#' and blank lines are ignored.  It is best if
each cache directory has its own timestamp file.  This file is used by
configure to modify the $LMOD_DIR/init/lmodrc.lua file.  See the
:ref:`full_example-label` for a complete example.



How to decide how many system cache directories to have
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The answer to this question depends on which machines "owns" which
modulefiles. Many sites have a single location where their modulefiles
are stored. In this case a single system cache file is all that is
required.

At TACC, we need two system cache files because we have two different
locations of files: one in the shared location and one on a local disk.
So in our case Lmod sees two cache directories. Each node builds a
spider cache of the modulefiles it "owns" and a single node (we call
it master) builds a cache for the shared location.


What directories to specify?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If your site doesn't use the software hierarchy, (see
:ref:`Software-Hierarchy-label` for more details) then just use
all the directory specified in **MODULEPATH**.  If you do use the
hierarchy, then just specify the "Core" directories,
i.e. the directories that are used to initialize Lmod but not the compiler
dependent or mpi-compiler dependent directories.





.. _update_cache_sh-label:

How to test the Spider Cache Generation and Usage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In a couple of steps you can generate a personal spider cache and get
the installed copy of Lmod to use it.  The first step would be to load
the lmod module and then run the **update_lmod_system_cache_files**
program and place the cache in the directory *~/moduleData/cacheDir* and
the time stamp file in *~/moduleData/system.txt*::

   $ module load lmod
   $ update_lmod_system_cache_files -d ~/moduleData/cacheDir -t ~/moduleData/system.txt $MODULEPATH

If you using Lmod 6 then replace **MODULEPATH** with
**LMOD_DEFAULT_MODULEPATH** instead.


Next you need to find your site's copy of lmodrc.lua.  This can be
found by running::

    $ module --config
    ...

    Active RC file(s):
    ------------------
    /opt/apps/lmod/6.0.14/init/lmodrc.lua

It is likely your site will have it in a different location.  Please
copy that file to ~/lmodrc.lua.  Then change the bottom of the file to
be::

    scDescriptT = {
      {
        ["dir"]       = "/path/to/moduleData/cacheDir",
        ["timestamp"] = "/path/to/moduleData/system.txt",
      },
    }

where you have changed */path/to* to match your home directory.  Now
set::

    $ export LMOD_RC=$HOME/lmodrc.lua

Then you can check to see that it works by running::

    $ module --config
    ...

    Cache Directory              Time Stamp File
    ---------------              ---------------
    $HOME/moduleData/cacheDir    $HOME/moduleData/system.txt

Where **$HOME** is replaced by your real home directory.  Now you can
test that it works by doing::


    $ module avail

The above command should be much faster than running without the
cache::

    $ module --ignore_cache avail


.. _full_example-label:

An Example Setup
^^^^^^^^^^^^^^^^

Suppose that your site has three different modulefile trees.  This can
be handle in two very different ways.  If each tree is on the same
computer you can have one spider cache that knows about all three.

Assuming that the tree modulefile trees are named::

    /sw/ab/modulefiles
    /sw/cd/modulefiles
    /sw/ef/modulefiles

If all tree directory trees are owned by same computer then one
can configure Lmod with::

    $ ./configure --with-spiderCacheDir=/sw/mData/cacheDir --with-updateSystemFn=/sw/mData/cacheTS.txt

And build the cache file with::

    $ export MODULEPATH=/sw/ab/modulefiles:/sw/cd/modulefiles:/sw/ef/modulefiles
    $ update_lmod_system_cache_files -d /sw/mData/cacheDir -t /sw/mData/cacheTS.txt  $MODULEPATH

Now suppose you have the same three module directories but they reside
on three different computers or are managed by three different
groups. So for any number of reasons you might have to have multiple
spider cache files.  In this case your site would configure Lmod
with a spider cache description file (call say:
spiderCacheDescript.txt) that contains::

    /sw/ab/mData/cacheDir:/sw/ab/mData/cacheTS.txt
    /sw/cd/mData/cacheDir:/sw/cd/mData/cacheTS.txt
    /sw/ef/mData/cacheDir:/sw/ef/mData/cacheTS.txt

Next Lmod is configured with this spiderCacheDescript.txt file, which
is only used to configure Lmod.::

    $ ./configure --with-spiderCacheDescript=/path/to/spiderCacheDescript.txt

Then on each machine or group builds a separate cache file for each
directory. Here we assume that there are three different computers
(ab, cd, ef).

So on the ab computer you run::

    $ update_lmod_system_cache_files -d /sw/ab/mData/cacheDir -t /sw/ab/mData/cacheTS.txt  /sw/ab/modulefiles

On the cd computer you run::

    $ update_lmod_system_cache_files -d /sw/cd/mData/cacheDir -t /sw/cd/mData/cacheTS.txt  /sw/cd/modulefiles

On the ef computer you run::

    $ update_lmod_system_cache_files -d /sw/ef/mData/cacheDir -t /sw/ef/mData/cacheTS.txt  /sw/ef/modulefiles


Each of these cache file generation command **must** run every time
the modulefiles change, either by content or files are added or
removed.


