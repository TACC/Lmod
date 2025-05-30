Lmod Overview
~~~~~~~~~~~~~

This overview is for developers who wish to understand how Lmod works.  We will outline the actions that 
Lmod takes when it is given a command. In particular we will show how Lmod loads the following simple modulefiles::

    setenv("Foo", "bar")
    prepend_path("PATH", "/home/user/bin")

In Lmod simplist terms takes commands from the user to change the state of the user's environment.  
It does this by loading and unloading modulefiles. When Lmod takes a command, it modifies an internal
table of key value pairs.   Finally, once the command is completed, Lmod will output the table 
of key value pairs to stdout.

The output is typically written as shell commands.  The choice of shell is picked by the user.   The module command in its simplest form
is a shell function in bash and a shell alias in tcsh/csh.  







