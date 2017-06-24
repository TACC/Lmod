.. _sh_to_modulefile-label:

Converting shell scripts to modulefiles
=======================================

As it is stated in :ref:`faq-label`, site should convert a shell
script into a modulefile.  This way the environment initialization can
be reversed when the module unloaded.  Lmod provides a script called
*sh_to_modulefile* which will convert a script to a modulefile.  An
example is::

    % $LMOD_DIR/sh_to_modulefile  ./foo.sh > foo_1.0.lua

or::

    % $LMOD_DIR/sh_to_modulefile  --output foo_1.0.lua ./foo.sh

This program defaults to generating a lua based modulefile.  It is
possible to generate a TCL modulefile with::

    % $LMOD_DIR/sh_to_modulefile  --style TCL --output foo_1.0 ./foo.sh

See::

    % $LMOD_DIR/sh_to_modulefile  --help

for all the options.

The way it works is that remembers the initial environment and runs
the script.  The program then compares the initial environment and
generate environment.  The output is a report of the environment
changes.

Note that it doesn't know about any aliases or shell functions that
the script creates.  They will have to added by hand.
