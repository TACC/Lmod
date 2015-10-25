System Spider Cache
===================

Now with version 5.+ of Lmod, it is now very important that sites with
large modulefile installations build system spider cache files. There
is a file called "update_lmod_system_cache_files" that builds a system
cache file.  It also touches a file called "system.txt".  Whatever the
name of this file, Lmod uses this file to know that the spider cache
is up-to-date.

Lmod uses the spider cache file as a replacement for walking the directory tree
to find all modulefiles in your MODULEPATH.  This means that Lmod only knows
about system modules that are found in the spider cache.  Lmod won't know about
any system modules that are not in this cache.  (Personal module files are
always found).  It turns out that reading a single file is much faster than
walking the directory tree.

Sites running Lmod have three choices:

#. Do not create a spider cache for system modules.  This will work fine as
   long as the number of modules is not too large.  You will know when it
   is time to start building a cache file when you start getting complains
   how long it take to do any module commands.

#. If you have a formal proceedure for installing packages on your system
   then I recommend you do the following.  Have the install proceedure run
   the update_lmod_system_cache_files scrpt.  This will create file
   called "system.txt"  which marks the time that the system was last
   updated, so Lmod knows that the cache is still good.

#. Or you can run the update_lmod_system_cache_files script say every
   30 mins.  This way the cache file is up-to-date.  No new module
   will be unknown for more 30 mins.


There are two ways to specify how cache directories and timestep files are
specified.  You can use "--with-spiderCacheDir=dirs" and
"--with-updateSystemFn=file" to specify one or more directories with a
single timestamp file.  If you have multiple directories with multiple
timestamp files you can use "--with-spiderCacheDescript=file" where the
contents of the "file" is::

    cacheDir1:timestamp1
    cacheDir2:timestamp2

lines starting with '#' and blank lines are ignored.  Also note that a
single timestamp file can be used with multiple cache directories.

How to decide how many system cache directories to have
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is about which machines "owns" which modulefiles. At TACC, we have
two different locations of files.  Most of our modulefiles are stored
on a local disk.  Some others are stored in a shared location.  So in
our case Lmod sees two cache directories.  Each node builds a spider
cache of the modulefiles it "owns" and a single mode (we call it
master) builds a cache for the shared location.


What directories to specify?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If your site doesn't use the software hierarchy, (see
:ref:`Software-Hierarchy-label` for more details) then just use the
all the directory specified in **MODULEPATH**.  If you do use the
hierarchy, then just specify the "Core" directories.  In other words
the directories that are used to initialize Lmod and not the compiler
dependent or mpi-compiler dependent directories.

How to test the Spider Cache Generation and Usage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In a couple of steps you can generate a personal spider cache and get
the installed copy of Lmod to use it.  The first step would be to load
the lmod module and then run the **update_lmod_system_cache_files**
program and place the cache in the directory *~/moduleData/cacheDir* and
the time stamp file in *~/moduleData/system.txt*

   $ module load lmod
   $ update_lmod_system_cache_files -d ~/moduleData/cacheDir -t ~/moduleData/system.txt $LMOD_DEFAULT_MODULEPATH

Here we have use the trick that Lmod keeps track of the Core module
directories in **LMOD_DEFAULT_MODULEPATH** so it should be safe to use
whether or not your site is using the hierarchy or not.

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

Where you have changed */path/to* to match your home directory.  Now
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
