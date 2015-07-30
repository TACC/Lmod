Generic Modules
===============

Lmod provides inspection functions that describe the name
and version of a modulefile as well as the path to the modulefile.
These functions provide a way to write "generic" modulefiles.  That is
modulefiles that can fill in its values based on the location of the
file itself.  

These ideas work best in the software hierarchy style of modulefiles.
For example: Suppose the following is a modulefile for Git.  Its
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
the git software because the local variable bin changes the location
of the bin directory to match the version of the used as the name of
the file.  So if the module file is in
`/apps/mfiles/Core/git/2.3.4.lua` then the local variable `bin` will
be `/apps/git/2.3.4`.


This works great for Core modules, It is a little more complicated for
Compiler or MPI/Compiler dependent modules but quite useful. For a
concrete example, lets cover how to handle the boost C++ library.
This is obviously a compiler dependent module. Suppose you have the
gnu compiler collection (gcc) and the  intel compiler collection
(intel), which means that you'll have a gcc version and an intel
version for each version of booth.

In order to have generic modules for compiler dependent modules there
must be some conventions to make this work.  A suggested way to do
this is the following:

#. Core modules are placed in `/apps/mfiles/Core`.  These are the
   comoilers, programs like git and so on.
#. Core software goes in `/apps/<app-name>/<app-version>`.
   So git version 2.3.4 goes in  `/apps/git/2.3.4`
#. Compiler-dependent module files go in
   `/apps/mfiles/Compiler/<compiler>/<compiler-version>/<app-name>/<app-version>`
   using the **two-digit** rule (discussed below).  So the Boost
   1.55.0 modulefile built with gcc/4.8.3 would be found in
   `/apps/mfiles/Compiler/gcc/4.8/boost/1.55.0.lua`
#. Compiler-dependent packages go in
   `/apps/<compiler-version>/<app-name>/<app-version>.  So the same
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
*/apps/gcc-4.8/boost/1.55.0*.  It is my view that that looks too much
like the gcc version 4.8 package location where as *gcc-4_8* doesn't.

With all of the above assumptions we can now create a generic module
file for compiler dependent modules such as Boost.  In order to make
this work we will need to use the `hierarchyA` function.  This
function parses the path of the modulefile to return the pieces we
need to create a generic boost modulefile::

   hierA = hierarchyA(myModuleFullName(),1)

The `myModuleFullName()` function returns the full name of the
module.  So if the module is named **boost/1.55.0** then that is what
it will return.  If your site use module names like `lib/boost/1.55.0`
then it will return that correctly as well. The `1` tells Lmod to
return just one component fromt the path.

   

