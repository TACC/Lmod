    What is ml?
    -----------

ml: A handy front end for the module command:
Simple usage:
 -------------
  $ ml
                           means: module list
  $ ml foo bar
                           means: module load foo bar
  $ ml -foo -bar baz goo
                           means: module unload foo bar;
                                  module load baz goo;
Command usage:
--------------

Any module command can be given after ml:

if name is avail, show, swap,...

    $ ml name  arg1 arg2 ...

Then this is the same as:

    $ module name arg1 arg2 ...

In other words you can not load a module named: show swap etc



    Using ml when Lmod is not available:
    ------------------------------------

For those of you who appreciate the ability to use the two letter
command "ml",  I'm providing this command as a standalone tar ball.
The reason to provide this command is to make it available when you
positively must use the TCL/C environment module system and do not
want to install Lmod in your own account.  All ml does is generate
module commands.  It doesn't know about the internals of the module
system.






To use:

1) unpack tarball.

2) copy ml_cmd.in.lua  to someplace.  Lets assume it is $HOME/tools

3) Find path to lua.  This may include installing lua.  Lets say it
is: /usr/local/bin/lua

4) Create a shell alias for bash and zsh:

ml()
{
   eval $(/usr/local/bin/lua $HOME/tools/ml_cmd.in.lua --old_style "$@")
}

Obviously you'll have to modify the path to lua and the path to where
ml_cmd.in.lua is to match your situation.  The option "--old_style" is
required to have ml generate the correct module command when
connecting to TCL/C modules.  It is not necessary when ml is used with
Lmod.


Enjoy.

R.


------
Notes:
------

Unless you know what you are doing, you SHOULD NOT use the ml command
alias provided above on a system where Lmod is installed.  Therefore,
for those of you who have shared home filesystems or even shared
startup files, need to be careful.



