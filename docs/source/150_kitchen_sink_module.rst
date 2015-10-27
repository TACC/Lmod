Kitchen Sink Modulefiles
========================

Most of the time a modulefile is just a collection of setting
environment variables and prepending to PATH or other path like
variables. However, the modulefiles are actually programs so you can
do a great deal if necessary.

Introspection
^^^^^^^^^^^^^

Lmod provides introspection functions ask what the module name and
version among many other functions. So suppose your packages are
stored in **/apps** then the core of the module file could be
generic::

    local version = myModuleVersion()
    local pkgName = myModuleName()
    local pkg     = pathJoin("/apps",pkgName,version)

    prepend_path("PATH",            pathJoin(pkg, "bin"))
    prepend_path("LD_LIBRARY_PATH", pathJoin(pkg, "lib"))


So if the module file is name "**git/2.6.2.lua**",  then the PATH will get
prepended with **/apps/git/2.6.2/bin**.

Other useful functions are myFileName() and 
