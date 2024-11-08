.. _debugging_Lmod-label:

Debugging Lmod
==============

The debug option flag (-D, --debug) can be used to debug Lmod.  This
can be done by running the module command as follows::

   % module -D <command>  2> module.log

All the debug output is sent to wherever  stderr is directed, in this
case **module.log**.  Inside the Lmod source are function calls to the
**dbg** object.  For example in src/Hub.src, the function
M.dependencyCk() start and end like::

   function M.dependencyCk()
      dbg.start{"Hub:dependencyCk()"}
      ...
      dbg.print{"DepCk loading: ",sn," fn: ", fn,"\n"}
      ...
      dbg.fini("Hub:dependencyCk")
   end

Each time a dbg.start{} is encountered the output string is printed
and the next line is indented two more spaces.  When a dbg.fini() is
encountered, the output string unindented two spaces.  The dbg.print{}
statements are printed with the current level of indentation.  This is
designed to make it easier to understand where in the code the
printing is coming from.  The dbg.print{} function provide a way to
print the state of a variable.  The function dbg.printT("name",table)
is provided to print tables.

When trying to understand changes to the code.  it is sometimes
helpful to generate debug output from two different version of Lmod
and compare the output.

The debug output can be large so finding the section of code can
challenging so, it is sometime useful to add unique strings like::

      dbg.print{"XYZZY: DepCk loading: ",sn," fn: ", fn,"\n"}

to make the desired output easier to find.



