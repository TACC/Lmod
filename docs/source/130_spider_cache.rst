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
   updated, so Lmod knows that    the cache is still good.

#. Or you can run the update_lmod_system_cache_files script say every
   30 mins.  This way the cache file is up-to-date.  No new module
   will be unknown for more 30 mins.


There are two ways to specify how cache directories and timestep files are
specified.  You can use "--with-spiderCacheDir=dirs" and
"--with-updateSystemFn=file" to specify one or more directories with a
single timestamp file.  If you have multiple directories with multiple
timestamp files you can use "--with-spiderCacheDescript=file" where the
contents of the "file" is:

    cacheDir1:timestamp1
    cacheDir2:timestamp2

lines starting with '#' and blank lines are ignored.  Also note that a
single timestamp file can be used with multiple cache directories.

