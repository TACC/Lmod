.. _debugging_modulefiles-label:

Debugging Modulefiles
=====================

Most modulefiles are simple combination of a ``help()`` message, a
couple of ``setenv()`` and a ``prepend_path()`` or two and don't
require much in the way of debugging.  However modulefiles are a
program and might need debugging.

Using `module show` to check a modulefile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can check how Lmod will evaluate a module file by using `module
show`. Lmod evaluates a modulefile and prints out the module
commands.  If the modulefile is syntactically then `module show` will
report the module commands such as `setenv()` and `prepend_path()`
etc.

Note that if the originally modulefile is written in TCL, the output
will be in Lua.

TCL modulefiles
~~~~~~~~~~~~~~~

As was discuss in :ref:`tcl2lua-label`, Lmod converts TCL modulefiles
into a lua modulefile by executing normal tcl commands and translates
TCL module commands into lua functions.  To see what Lmod does with
your TCL modulefile, you can run ``tcl2lua.tcl`` to see the
translation::

    $ $LMOD_DIR/tcl2lua.tcl <path_to_modulefile>

For example, suppose you have a TCL modulefile in
``~/my_modules/foo/1.0``::

    #%Module

    global env
    set home $env(HOME)
    set pkg "$home/foo"
    prepend-path PATH $pkg/bin
    setenv FOO_DIR $pkg  

Then running the command produces::


    $ $LMOD_DIR/tcl2lua.tcl ~/my_modules/foo/1.0

    prepend_path{"PATH","/home/user/foo/bin",delim=":",priority="0"}
    setenv("FOO_DIR","/home/user/foo")

Lua Modulefiles
~~~~~~~~~~~~~~~

It is important to remember that Lmod uses a two part process to
change your environment.  The lmod program produces text that is
appropriate for the shell choice: bash commands for bash shell; csh
commands for C-shell and so on.  Then that text is evaluated by the
shell to change your environment.

We can take advantage of this two part process to debug modulefiles by
getting Lmod to produce the commands but not evaluate them.  So
starting with a simple lua modulefile called ``~/my_modules/foo/1.0.lua``::


    local home = os.getenv("HOME")
    local pkg  = pathJoin(home,"foo")
    io.stderr:write("home: ",home,"\n")
    io.stderr:write("pkg:  ",pkg,"\n")

    prepend_path("PATH",pathJoin(pkg,"bin"))
    setenv("FOO",pathJoin(pkg,"bin"))

You can see that the above modulefile contains two extra print debugging
statements that you'll want to remove after debugging.  Running the
Lmod command produces::


    $ module use ~/my_modules
    $ $LMOD_CMD bash load foo/1.0

    home: /home/user
    pkg:  /home/user/foo
    FOO="/home/user/foo/bin";
    export FOO;
    PATH="/home/user/foo/bin:..."
    export PATH;
    ...


Actually the lmod command will produce much more text.  It contains
other environment variables such as::

     LOADEDMODULES="...";
     export LOADEDMODULES;
     __LMFILES__="...";
     export __LMFILES__;
     MODULEPATH="...";
     export MODULEPATH;
     __LMOD_REF_COUNT_PATH="/home/user/foo/bin:1;..."
     export __LMOD_REF_COUNT_PATH;
     PATH="/home/user/foo/bin:..."
     export PATH;
     _ModuleTable001_="...";
     export _ModuleTable001_;
     _ModuleTable_Sz_="6";
     export _ModuleTable_Sz_;

``LOADEDMODULES`` and ``__LMFILES__`` are the list of modules loaded
and their locations. These variables are made available to be
compatible with Tmod and can be used by modulefiles. Variables like 
``__LMOD_REF_COUNT_PATH`` are used to support reference counting for
path like variables.  Finally, Lmod uses a lua table called the
``_ModuleTable_`` which contains the information used between Lmod
invocations.  This table is base64 encoded and split into 256 character
blocks and stored in ``$_ModuleTable001, $_ModuleTable002, ...``
