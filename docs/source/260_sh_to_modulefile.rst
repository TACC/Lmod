.. _sh_to_modulefile-label:

Shell scripts to modulefile
===========================

As it is stated in :ref:`faq-label`, site should convert a shell
script into a modulefile.  This way the environment initialization can
be reversed when the module unloaded.  Lmod provides a script called
*sh_to_modulefile* which will convert a script to a modulefile.  An
example is::

    % $LMOD_DIR/sh_to_modulefile --output foo_1.0.lua ./foo.sh

This program defaults to generating a lua based modulefile  


