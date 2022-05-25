.. _tcl2lua-label:

How does Lmod convert TCL modulefile into Lua
=============================================

Lmod uses a TCL program called **tcl2lua.tcl** to read TCL modulefiles
and convert them to lua.  The whole TCL modulefile evaluated by the
TCL interpreter.  This is *NOT* a source to source translation.

The purpose of **tcl2lua.tcl** is to evaluate the regular TCL command
but replace "module functions", such as **prepend-path** or
**setenv**, and converted to Lua functions.  For example, suppose you have
the following simple TCL modulefile for git::

    #%Module
    set appDir          $env(APP_DIR)
    set version         2.0.3

    prepend-path        PATH "$appDir/git/$version/bin"

Assuming that the environment variable APP_DIR is */apps* then the
entire output of the **tcl2lua.tcl** program would be::

   prepend_path("PATH", "/apps/git/2.0.3/bin")

Note that all the normal TCL code has been evaluated and the TCL
**prepend-path** command  has been converted to a lua **prepend_path**
function call.

Normally this works fine.  However, because Lmod does evaluate the
actions of a TCL module file as a two-step process, it can cause
problems.  In particular, suppose you have two TCL modulefiles:

Centos::

    #%Module
    setenv SYSTEM_NAME Centos

And B::

    #%Module
    module load Centos

    if { $env(SYSTEM_NAME) == "Centos" } {
       # do something
    }

When Lmod tries to translate the B modulefile into lua it fails::

   load("Centos")
   LmodError([[/opt/mfiles/B: (???): can't read "env(SYSTEM_NAME)": no such variable]])

This is because unlike the TCL/C Module system, the **module load
Centos** command is converted to a function call, but it won't load the module
in time for the test to be evaluated properly.

The only solution is convert the B modulefile into a Lua modulefile (B.lua)::

   load("Centos")
   if (os.getenv("SYSTEM_NAME") == "Centos") then
     -- Do something
   end

The Centos modulefile does not have to be translated in order for this to
work, just the B modulefile.


As a side note, you are free to put Lua modules in the same tree that the
TCL/C Module system uses.  It will ignore files that the first line is
not #%Module and Lmod will pick B.lua over B.
