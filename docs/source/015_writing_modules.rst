An Introduction to Writing Modulefiles
======================================

This is a different kind of introduction to Lmod.  Here we will remind
you what Lmod is doing to change the environment via modulefiles.
Then we will start with the four functions that are typically needed
for any modulefile. From there we will talk about intermediate level
module functions when things get more complicated.  Finally we will
discuss the advanced module functions to flexibly control your site
via modules.  All the Lua module functions available are described at
:ref:`lua_modulefile_functions-label`.  This discussion shows how
they can be used.


A Reminder of what Lmod is doing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All Lmod is doing is changing the environment.  Suppose you want to
use the "ddt" debugger installed on your system which is made
available to you via the module.  If you try to execute ddt without
the module loaded you get::

   $ ddt
   bash: command not found: ddt

   $ module load ddt
   $ ddt

After the ddt module is loaded, executing **ddt** now works.  Let's
remind ourselves why this works.  If you try checking the environment
before loading the ddt modulefile::

   $ env | grep -i ddt
   $ module load ddt
   $ env | grep -i ddt

   DDTPATH=/opt/apps/ddt/5.0.1/bin
   LD_LIBRARY_PATH=/opt/apps/ddt/5.0.1/lib:...
   PATH=/opt/apps/ddt/5.0.1/bin:...

   $ module unload ddt
   $ env | grep -i ddt
   $


The first time we check the environment we find that there is no
**ddt** stored there.  But the second time there we see that the PATH
and LD_LIBRARY_PATH have been modified.  Note that we have shorten the
path-like variables to show the important changes.  There are also
several environment variables which have been set.  After unloading
the module all the references for ddt have been removed. We can see
what the modulefile looks like by doing::

   $ module show ddt

   help([[
   For detailed instructions, go to:
      https://...

   ]])
   whatis("Version: 5.0.1")
   whatis("Keywords: System, Utility")
   whatis("URL: http://content.allinea.com/downloads/userguide.pdf")
   whatis("Description: Parallel, graphical, symbolic debugger")

   setenv(       "DDTPATH",        "/opt/apps/ddt/5.0.1/bin")
   prepend_path( "PATH",           "/opt/apps/ddt/5.0.1/bin")
   prepend_path( "LD_LIBRARY_PATH","/opt/apps/ddt/5.0.1/lib")

Modulefiles state the actions that need to happen when loading.
For example the above modulefile uses **setenv** and **prepend_path**
to set environment variables and prepend to the **PATH**.  If the
above modulefile is unloaded then the **setenv** actually unsets the
environment variable.  The **prepend_path** removes the element from
the **PATH** variable.  That is unload causes the functions to be
reversed.

Basic Modulefiles
^^^^^^^^^^^^^^^^^

There are two main module functions required, namely **setenv** and
**prepend_path**; and two functions to provide documentation **help**
and **whatis**.  The modulefile for ddt shown above contains all the
basics required to create one.  Suppose you are writing this module
file for ddt version 5.0.1 and you are placing it in the standard
location for your site, namely */apps/modulefiles* and this directory
is already in **MODULEPATH**.  Then in the directory
*/apps/modulefiles/ddt* you create a file called *5.0.1.lua* which
contains the modulefile shown above.


This is the typical way of setting a modulefile up.  Namely the
package name is the name of the directory, *ddt*, and version name,
*5.0.1* is the name of the file with the *.lua* extension added.  We
add the lua extension to all modulefile written in Lua.  All
modulefiles without the lua extension are assumed to be written in
TCL.

If another version of ddt becomes available, say *5.1.2*, we create
another file called *5.1.2.lua* to become the new modulefile for the
new version of *ddt*.

When a user does *module help ddt*, the arguments to the **help** function
are written out to the user.  The **whatis** function provides a way
to describe the function of the application or library.  This data can
be used by search tools such as **module keyword** *search_words*.
Here at TACC we also use that data to provide search capability via
the web interface to modules we provide.


Intermediate Level Modulefiles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The four basic functions describe above is all that is necessary for
the majority of modulefiles for application and libraries.  The
intermediate level is designed to describe some situations that come
up as you need to provide more than just packages modulefile but need
to set up a system.


Meta Modules
------------

Some sites create a single module to load a default set of modules for all
users to start from.   This is typically called a meta module because
it loads other modules.  As an example of that, we here at TACC
have created the TACC module to provide a default compiler, mpi stack
and other modules::

   help([[
   The TACC modulefile defines ...
   ]])

   -- 1 --
   if (os.getenv("USER") ~= "root") then
     append_path("PATH",  ".")
   end

   -- 2 --
   load("intel", "mvapich2")

   -- 3 --
   try_load("xalt")

   -- 4 --
   -- Environment change - assume single threaded.
   if (mode() == "load" and os.getenv("OMP_NUM_THREADS") == nil) then
     setenv("OMP_NUM_THREADS","1")
   end

This modulefile shows the use of four new functions. The first one is
**append_path**.  This function is similar to **prepend_path** except
that the value is placed at the end of the path-like variable instead
of the beginning.  We add ``.`` to our user's path at the end, except for
root.  This way our new users don't get surprised with some programs in
their current directory that do not run.  We used the **os.getenv**
function built-in to Lua to get the value of environment variable
"USER".

The second function is **load**, this function loads the modulefiles
specified.  This function takes one or more names.  Here we are
specifying a default compiler and mpi stack. The third function
is **try_load**, which is similar to **load** except that there is no
error reported if the module can't be found. Any other errors found
during loading will be reported.

The fourth block of code shows how we set **OMP_NUM_THREADS**.  We wish
to set **OMP_NUM_THREADS** to have a default value of 1, but only if the
value hasn't already been set and we only want to do this when the
module is being loaded and not at any other time.  So when this module
is loaded for the first time **mode()** will return "load" and
**OMP_NUM_THREADS** won't have a value. The **setenv** will set it
to 1.  If the TACC module is unloaded, the **mode()** will be "unload"
so the if test will be false and therefore the **setenv** will not be
reversed.  If the user changes **OMP_NUM_THREADS** and reloads the
TACC modulefile, their value won't change because
**os.getenv("OMP_NUM_THREADS")** will return a non-nil value,
therefore the **setenv** command won't run.   Now this may not be the
best way to handle this.  It might be better to set
**OMP_NUM_THREADS** in a file that is sourced in /etc/profile.d/ and
have all the important properties.  Namely that there will be a
default value that the user can change. However this example shows how
to do something tricky in a modulefile.

Typically meta modules are a single file and not versioned.  So the
TACC modulefile can be found at */apps/modulefiles/TACC.lua*.  There
is no requirement that this will be this way but it has worked well in
practice.


Modules with dependencies
-------------------------

Suppose that you have a package which needs libraries or an
application.  For example the octave application needs gnuplot.  Let's
assume that you have a separate applications for both.  Inside the
octave module you can do::

    prereq("gnuplot")
    ...

So if you execute::

    $ module unload gnuplot
    $ module load octave
    $ module load gnuplot octave
    $ module unload octave

The second module command will fail, but the third one will succeed
because we have met the prerequisites.   The advantage of using prereq
is after fourth module command is executed, the gnuplot module will be
loaded.

This can be contrasted with including the load of gnuplot in the
octave modulefile::

    load("gnuplot")
    ...

This simplifies the loading of the octave module.  The trouble is that
when a user does the following::

    $ module load   gnuplot
    $ module load   octave
    $ module unload octave

is that after unloading *octave*, the *gnuplot* module is also unloaded.
It seems better to either use the **prereq** function shown above or
use the **always_load** function in the octave module::

    always_load("gnuplot")
    ...

Then when a user does::

    $ module load   gnuplot
    $ module load   octave
    $ module unload octave

The *gnuplot* module will still be loaded after unloading *octave*.
This will lead to the least confusion to users.


Fancy dependencies
------------------

Sometimes an application may depend on another application but it has
to be a certain version or newer.  Lmod can support this with the
**atleast** modifier to both **load**, **always_load** or **prereq**.  For example::

   -- Use either the always_load or prereq but not both:

   prereq(     atleast("gnuplot","5.0"))
   always_load(atleast("gnuplot","5.0"))

The **atleast** modifier to **prereq** or **always_load** will succeed
if the version of gnuplot is 5.0 or greater.


Assigning Properties
--------------------

Modules can have properties that will be displayed in a *module list* or
*module avail*.  Properties can be anything but they must be specified
in the *lmodrc.lua* file.  You are free to add to the list. For
example, to specify a module to be experimental all you need to do is::

   add_property("state","experimental")

Any properties you set must be defined in the **lmodrc.lua** file. In
the source tree the properties are in init/lmodrc.lua.  A more
detailed discussion of the lmodrc.lua file can be found at :ref:`lmodrc-label`

Pushenv
-------

Lmod allows you to save the state in a stack hidden in the environment.
So if you want to set the **CC** environment variable to contain the name
of the compiler.::

   -- gcc --
   pushenv("CC","gcc")

   -- mpich --
   pushenv("CC","mpicc")

If the user executes the following::


   #                                      SETENV         PUSHENV
   $ export CC=cc;         echo $CC  # -> CC=cc          CC=cc
   $ module load   gcc;    echo $CC  # -> CC=gcc         CC=gcc
   $ module load   mpich;  echo $CC  # -> CC=mpicc       CC=mpicc
   $ module unload mpich;  echo $CC  # -> CC is unset    CC=gcc
   $ module unload gcc;    echo $CC  # -> CC is unset    CC=cc

We see that the value of **CC** is maintained as a stack variable when
we use *pushenv* but not when we use *setenv*.

Setting aliases and shell functions
-----------------------------------

Sometimes you want to set an alias as part of a module.  For example
the visit program requires the version to be specified when running
it.  So for version 2.9 of visit, the alias is set::

    set_alias("visit","visit -v 2.9")

Whether this will expand correctly depends on the shell.  While C-shell
allows argument expansion in aliases, Bash and Zsh do not.  Bash and
Zsh use shell functions instead.  For example the ml shell function
can be set like this::

    local bashStr = 'eval $($LMOD_DIR/ml_cmd "$@")'
    local cshStr  = "eval `$LMOD_DIR/ml_cmd $*`"
    set_shell_function("ml",bashStr,cshStr)

Please note that aliases in bash are not expanded for non-interactive
shells.  This means that it won't work in bash shell scripts.  Please
change the shell alias to use the ``set_shell_function`` instead.
Shell functions do work in both interactive and non-interactive
shells.

