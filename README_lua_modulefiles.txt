                     Writing Lua Modulefiles
                     -----------------------

You have a choice of using lua or TCL as the implementation language
for your modulefiles.  Modulefiles with the ".lua" extension are
treated as lua files.  Otherwise the modulefile is assumed to be in
TCL.

The TCL modulefiles are translated by a small tcl program in the src
directory:  tcl2lua.tcl.  Each time a TCL module is accessed it is
translated by this TCL program into lua.   This is very quick so there
is little immediate need to translate your TCL modules into lua.

Your modulefiles can be a mix of lua and TCL.  You should keep all the
modules in a single directory in one language or the other but
different module directories can be a mix.

Examples of both lua and TCL modules are stored in the mf directory
tree.

Also the tcl2lua.tcl program can be used to help translate TCL modules
into lua ones.  Below is simple module: 7.1


    #%Module3.1.6#####################################################################
    ##
    ## PGI Compilers
    ##
    proc ModulesHelp { } {
            puts stderr "\n\tVersion 7.1\n"
    }

    module-whatis   "loads the PGI compiler environment"

    # for Tcl script use only
    set     version                     7.1

    set moduleshome     "/opt/apps/modulefiles/TACC_COMPILER/pgi/7.1"

    setenv          PGI             /opt/apps/pgi/7.1
    prepend-path    PATH            /opt/apps/pgi/7.1/linux86-64/7.1-2/bin
    prepend-path    MANPATH         /opt/apps/pgi/7.1/linux86-64/7.1-2/man
    prepend-path    LD_LIBRARY_PATH /opt/apps/pgi/7.1/linux86-64/7.1-2/libso
    prepend-path    MODULEPATH      "$moduleshome"

It is translated by the tcl2lua.tcl program:

   $ tcl2lua.tcl -h 7.1  > 7.1.lua

Where 7.1.lua is:

   whatis("loads the PGI compiler environment")
   setenv("PGI","/opt/apps/pgi/7.1")
   prepend_path("PATH","/opt/apps/pgi/7.1/linux86-64/7.1-2/bin")
   prepend_path("MANPATH","/opt/apps/pgi/7.1/linux86-64/7.1-2/man")
   prepend_path("LD_LIBRARY_PATH","/opt/apps/pgi/7.1/linux86-64/7.1-2/libso")
   prepend_path("MODULEPATH","/opt/apps/modulefiles/TACC_COMPILER/pgi/7.1")
   help([[

           Version 7.1

   ]])

If you look at the tcl2lua.tcl program, you will see that the native
TCL commands are just evaluated and the module commands just print out
the arguments.    In particular any if tests in the TCL are just
evaluated.  So when the TCL if tests are important, they will have to
be hand translated into lua.

See http://www.lua.org  for more details on lua and/or the
well-written book on lua:

  "Programming in Lua" by Roberto Ierusalimschy


************************************************************************
NOTE: If you use the tcl2lua.tcl program, you obviously require that
TCL is installed.   But you would have anyway if you have already been
using modules.
************************************************************************
