Modulefile Examples from simple to complex
==========================================

Most of the time a modulefile is just a collection of setting
environment variables and prepending to PATH or other path like
variables. However, modulefiles are actually programs so you can
do a great deal if necessary.

Here we show some of the techniques that site's or user's might use in
their modulefiles.  In addition, there are many examples in the Lmod
source tree.  The ``rt`` directory contains the regression testing
suite.  Each subdirectory in ``rt`` is a separate test and below that
there will be many modulefiles.  For example see all the modulefile
associated with the load test can be found in ``rt/load/mf``.

Some simple modulefiles
~~~~~~~~~~~~~~~~~~~~~~~

An application modulefile might add to ``$PATH``, set a few other
environment variables and provide help message as well as ``whatis()``
strings.  For example the valgrind memory usage tester might look
like::

    help([[
    To use the valgrind utility on an executable called a.out:

    valgrind ./a.out
    ]])

    local version = "3.7.0"
    local base    = pathJoin("/apps/valgrind",version)
    prepend_path("PATH", pathJoin(base,"bin"))  -- /app/valgrind/3.7.0/bin
    setenv(      "SITE_VALGRIND_DIR", base)
    setenv(      "SITE_VALGRIND_INC", pathJoin(base,"include"))
    setenv(      "SITE_VALGRIND_LIB", pathJoin(base,"lib"))

    whatis("Name: ".. pkgName)
    whatis("Version: " .. fullVersion)
    whatis("Category: tools")
    whatis("URL: http://www.valgrind.org")
    whatis("Description: memory usage tester")


A library module might look like::

    help([[
    ... 
    ]])
    whatis("Name: boost")
    whatis("Version: 1.64")
    whatis("Category: Lmod/Modulefiles")
    whatis("Keywords: System, Library, C++")
    whatis("URL: http://www.boost.org")
    whatis("Description: Boost provides free peer-reviewed portable C++ source libraries.")

    setenv("SITE_BOOST_DIR","/apps/intel17/boost/1.64")
    setenv("SITE_BOOST_LIB","/apps/intel17/boost/1.64/lib")
    setenv("SITE_BOOST_INC","/apps/intel17/boost/1.64/include")
    setenv("SITE_BOOST_BIN","/apps/intel17/boost/1.64/bin")
    setenv("BOOST_ROOT","/apps/intel17/boost/1.64")
    prepend_path("LD_LIBRARY_PATH","/apps/intel17/boost/1.64/lib")
    prepend_path("PATH","/apps/intel17/boost/1.64/bin")


For improved documentation readability, help content can include markdown
formatting which Lmod automatically converts for terminal display::

    help([[
    # Scientific Computing Package

    ## Description
    This module provides **advanced numerical tools** for scientific computing.

    ## Features
    - *Fast* linear algebra routines
    - **Parallel** processing support
    - `command-line` utilities

    ## Usage
    Load the module and run:
    ```bash
    mpirun -n 4 myprogram
    ```

    See documentation at [project website](https://example.com).
    ]])

    prepend_path("PATH", "/apps/scicomp/2.1/bin")


.. _generic_modules-label:

Introspection
~~~~~~~~~~~~~

Lmod provides inspection functions that describe the name
and version of a modulefile as well as the path to the modulefile.
These functions provide a way to write "generic" modulefiles,
i.e. modulefiles that can fill in its values based on the location of the
file itself.

These ideas work best in the software hierarchy style of modulefiles.
For example: suppose the following is a modulefile for Git.  Its
modulefile is located in the "/apps/mfiles/Core/git" directory and
software is installed in "/apps/git/<version>".  The following
modulefile would work for every version of git::

   local pkg = pathJoin("/apps",myModuleName(),myModuleVersion())
   local bin = pathJoin(pkg,"bin"))
   prepend_path("PATH",bin)

   whatis("Name:        ", myModuleName())
   whatis("Version:     ", myModuleVersion())
   whatis("Description: ", "Git is a fast distributive version control system")

The contents of this modulefile can be used for multiple versions of
the git software, because the local variable bin changes the location
of the bin directory to match the version of the used as the name of
the file.  So if the module file is in
`/apps/mfiles/Core/git/2.3.4.lua` then the local variable `bin` will
be `/apps/git/2.3.4`.


Relative Paths
~~~~~~~~~~~~~~

Suppose you are interested in modules where the module and application
location are relative. Suppose that you have an $APPS directory, and
below that you have modulefiles and packages, and you would like the
modulefiles to find the absolute path of the package location. This
can be done with the ``myFileName()`` function and some lua code::

     local fn      = myFileName()                      -- 1
     local full    = myModuleFullName()                -- 2
     local loc     = fn:find(full,1,true)-2            -- 3
     local mdir    = fn:sub(1,loc)                     -- 4
     local appsDir = mdir:gsub("(.*)/","%1")           -- 5
     local pkg     = pathJoin(appsDir, full)           -- 6


To make this example concrete, let's assume that applications are in
``/home/user/apps`` and the modulefiles are in ``/home/user/apps/mfiles``.
So if the modulefile is located at
``/home/user/apps/mfiles/git/1.2.lua``,
then that is the value of ``fn`` at line 1.  The ``full`` variable at
line 2 will have ``git/1.2``.  What we want is to remove the name of
the modulefile and find its parent directory.  So we use Lua string
member function on ``fn`` to find where ``full`` starts.  In most cases
``fn:find(full)`` would work to find where the "git" starts in ``fn``
The trouble is that the Lua find function is expecting a regular
expression and in particular ``.`` and ``-`` are regular expression
characters.  So here we are using ``fn:find(full,1,true)`` to tell Lua
to treat each character as is with no special meaning.

Line 3 also subtracts 2.  The find command reports the location of the
start of the string where the "g" in "git" is, We want the value of
``mdir`` to be ``/home/user/apps/mfiles`` so we need to subtract 2.
This makes ``mdir`` have the right value.  One note is that Lua is a
one based language, so locations in strings start at one.

It was important for the value of ``mdir`` to remove the trailing
``/`` so that line 5 will do its magic.  We want the parent directory
of ``mdir``, so the regular expressions says greedily grab every
character until the trailing ``/`` and the ``%1`` says to capture the
string found in and use that to set ``appsdir`` to
``/home/user/apps``.  Finally we wish to set ``pkg`` to the location
of the actual application so we combine the value of ``appsdir`` and
``full`` to set ``pkg`` to ``/home/user/apps/git/1.2``.

The nice thing about this Lua code is that it figures out the location
of the package no matter where it is, as long as the relation between
apps directories and modulefiles is consistent.

Creating modules like this can be complicated. See
:ref:`debugging_modulefiles-label` for helpful tips.


Generic Modules with the Hierarchy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This works great for Core modules. It is a little more complicated for
Compiler or MPI/Compiler dependent modules but quite useful. For a
concrete example, lets cover how to handle the boost C++ library.
This is obviously a compiler dependent module. Suppose you have the
gnu compiler collection (gcc) and the  intel compiler collection
(intel), which means that you'll have a gcc version and an intel
version for each version of booth.

In order to have generic modules for compiler dependent modules, there
must be some conventions to make this work.  A suggested way to do
this is the following:

#. Core modules are placed in `/apps/mfiles/Core`.  These are the
   compilers, programs like git and so on.
#. Core software goes in `/apps/<app-name>/<app-version>`.
   So git version 2.3.4 goes in  `/apps/git/2.3.4`
#. Compiler-dependent modulefiles go in
   `/apps/mfiles/Compiler/<compiler>/<compiler-version>/<app-name>/<app-version>`
   using the **two-digit** rule (discussed below).  So the Boost
   1.55.0 modulefile built with gcc/4.8.3 would be found in
   `/apps/mfiles/Compiler/gcc/4.8/boost/1.55.0.lua`
#. Compiler-dependent packages go in
   `/apps/<compiler-version>/<app-name>/<app-version>`.  So the same
   Boost 1.55.0 package built with gcc 4.8.3 would be placed in
   `/apps/gcc-4_8/boost/1.55.0`

The above convention depends on the **two-digit** rule.  For compilers
and mpi stack, we are making the assumption that compiler dependent
libraries built with gcc 4.8.1 can be used with gcc 4.8.3. This is not
always safe but it works well enough in practice.  The above
convention also assumes that the boost 1.55.0 package will be placed
in `/apps/gcc-4_8/boost/1.55.0`.  It couldn't go in
*/apps/gcc/4.8/...* because that is where the gcc 4.8 package would
be placed and it is not a good idea to co-mingle two different
packages in the same tree.  Another possible choice would be
*/apps/gcc-4.8/boost/1.55.0*.  It is my view that it looks too much
like the gcc version 4.8 package location where as *gcc-4_8* doesn't.

With all of the above assumptions, we can now create a generic module
file for compiler dependent modules such as Boost.  In order to make
this work, we will need to use the `hierarchyA` function.  This
function parses the path of the modulefile to return the pieces we
need to create a generic boost modulefile::

   hierA = hierarchyA(myModuleFullName(),1)

The `myModuleFullName()` function returns the full name of the
module.  So if the module is named **boost/1.55.0**, then that is what
it will return.  If your site uses module names like `lib/boost/1.55.0`
then it will return that correctly as well. The *1* tells Lmod to
return just one component from the path.  So if the modulefile is
located at `/apps/mfiles/Compiler/gcc/4.8/boost/1.55.0.lua`, then
`myModuleFullName()` returns **boost/1.55.0** and the `hierarchyA`
function returns an array with 1 entry.  In this case it returns::

   { "gcc/4.8" }

The rest of the module file then can make use to this result to form
the paths::

    local pkgName     = myModuleName()
    local fullVersion = myModuleVersion()
    local hierA       = hierarchyA(myModuleFullName(),1)
    local compilerD   = hierA[1]:gsub("/","-"):gsub("%.","_")
    local base        = pathJoin("/apps",compilerD,pkgName,fullVersion)

    whatis("Name: "..pkgName)
    whatis("Version "..fullVersion)
    whatis("Category: library")
    whatis("Description: Boost provides free peer-reviewed "..
                        " portable C++ source libraries.")
    whatis("URL: http://www.boost.org")
    whatis("Keyword: library, c++")

    setenv("TACC_BOOST_LIB", pathJoin(base,"lib"))
    setenv("TACC_BOOST_INC", pathJoin(base,"include"))

The important trick is the building of the `compilerD` variable.  It
converts the `gcc/4.8` into `gcc-4_8`.  This makes the `base` variable
be: `/apps/gcc-4_8/boost/1.55.0`.

Creating modules like this can be complicated. See
:ref:`debugging_modulefiles-label` for helpful tips.

A proposed directory structure of /apps/mfiles/Compiler would be::


    .base/    gcc/  intel/

    .base/
    boost/generic.lua

    gcc/4.8/boost/

    1.55.0.lua ->  ../../../.base/boost/generic.lua

    intel/15.0.2/boost/

    1.55.0.lua -> ../../../.base/boost/generic.lua

In this way the `.base/boost/generic.lua` file will be the source file
for all the boost version build with gcc and intel compilers.


The same technique can be applied for modulefiles for Compiler/MPI
dependent packages.  In this case, we will create the phdf5
modulefile.  This is a parallel I/O package that allows for Hierarchical
output.  The modulefile is::

    local pkgName    = myModuleName()
    local pkgVersion = myModuleVersion()
    local pkgNameVer = myModuleFullName()

    local hierA      = hierarchyA(pkgNameVer,2)
    local mpiD       = hierA[1]:gsub("/","-"):gsub("%.","_")
    local compilerD  = hierA[2]:gsub("/","-"):gsub("%.","_")
    local base       = pathJoin("/apps", compilerD, mpiD, pkgNameVer)

    setenv(      "TACC_HDF5_DIR",   base)
    setenv(      "TACC_HDF5_DOC",   pathJoin(base,"doc"))
    setenv(      "TACC_HDF5_INC",   pathJoin(base,"include"))
    setenv(      "TACC_HDF5_LIB",   pathJoin(base,"lib"))
    setenv(      "TACC_HDF5_BIN",   pathJoin(base,"bin"))
    prepend_path("PATH",            pathJoin(base,"bin"))
    prepend_path("LD_LIBRARY_PATH", pathJoin(base,"lib"))

    whatis("Name: Parallel HDF5")
    whatis("Version: " .. pkgVersion)
    whatis("Category: library, mathematics")
    whatis("URL: http://www.hdfgroup.org/HDF5")
    whatis("Description: General purpose library and file format for storing scientific data (parallel I/O version)")

We use the same tricks as before,  It is just that since the module
for phdf5 built by gcc/4.8.3 and mpich/3.1.2 will be found at
`/apps/mfiles/MPI/gcc/4.8./mpich/3.1/phdf5/1.8.14.lua`. The
results of `hierarchyA(pkgNameVer,2)` would be::

    { "mpich/3.1", "gcc/4.8" }

This is because the `hierarchyA` works back up the path two elements
at a time because the full name of this package is also two elements
(phdf5/1.8.14).  The `base` variable now becomes::

    /apps/gcc-4_8/mpich-3_1/phdf5/1.8.14

The last type of modulefile that needs to be discussed is an mpi stack
modulefile such as mpich/3.1.2.  This modulefile is more complicated
because it has to implement the two-digit rule, build the path to the
package and build the new entry to the **MODULEPATH**.  The modulefile
is::

    local pkgNameVer   = myModuleFullName()
    local pkgName      = myModuleName()
    local fullVersion  = myModuleVersion()
    local pkgV         = fullVersion:match('(%d+%.%d+)%.?')

    local hierA        = hierarchyA(pkgNameVer,1)
    local compilerV    = hierA[1]
    local compilerD    = compilerV:gsub("/","-"):gsub("%.","_")
    local base         = pathJoin("/apps",compilerD,pkgName,fullVersion)
    local mpath        = pathJoin("/apps/mfiles/MPI", compilerV, pkgName, pkgV)

    prepend_path("MODULEPATH", mpath)
    setenv(      "TACC_MPICH_DIR", base)
    setenv(      "TACC_MPICH_LIB", pathJoin(base,"lib"))
    setenv(      "TACC_MPICH_BIN", pathJoin(base,"bin"))
    setenv(      "TACC_MPICH_INC", pathJoin(base,"include"))

    whatis("Name: "..pkgName)
    whatis("Version "..fullVersion)
    whatis("Category: mpi")
    whatis("Description: High-Performance Portable MPI")
    whatis("URL: http://www.mpich.org")

The **Two Digit** rule implemented by forming the `pkgV` variable. The
`base` and `mpath` are::

    base  = "/apps/gcc-4_8/mpich-3_1/phdf5/1.8.14"
    mpath = "/apps/mfiles/MPI/gcc/4.8/mpich/3.1"

The *rt* directory contains all the regression test used by Lmod.  As
such they contain many examples of modulefiles.  To complement this
description, the *rt/hierarchy/mf* directory from the source tree
contains a complete hierarchy.

