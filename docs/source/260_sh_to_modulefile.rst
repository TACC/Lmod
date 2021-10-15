.. _sh_to_modulefile-label:

Converting shell scripts to modulefiles
=======================================

Lmod provides a script called *sh_to_modulefile* which will convert a
script to a modulefile.  An example is::

    % $LMOD_DIR/sh_to_modulefile  ./foo.sh > foo_1.0.lua

or::

    % $LMOD_DIR/sh_to_modulefile  --output foo_1.0.lua ./foo.sh

This program defaults to generating a lua based modulefile.  It is
possible to generate a TCL modulefile with::

    % $LMOD_DIR/sh_to_modulefile  --to TCL --output foo_1.0 ./foo.sh

See::

    % $LMOD_DIR/sh_to_modulefile  --help

for all the options.

The way it works is that remembers the initial environment and runs
the script.  The program then compares the initial environment and
generate environment.  The output is a report of the environment
changes.

As of version 8.6, Lmod now tracks changes to shell aliases and shell
functions and writes them to the generated modulefile.

Converting scripts once with this command is usually best.  However,
some scripts depend on dynamic environment variable that change
between users such as the values of $HOME or $USER. In this case, the
use of the **source_sh** () modulefile function can be helpful.
