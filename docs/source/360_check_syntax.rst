.. _checking_syntax-label:

Checking Syntax in Your Sites Modulefiles
=========================================

As of Lmod (8.4.3+), it is possible to check the syntax of your sites
module tree(s).  The command **check_module_tree_syntax** will walk
your module directories just like the spider command.  But the spider
command does not report warning and errors, the
**check_module_tree_syntax** command does.  This command is meant to
be run by a Site's staff and not users as it is designed to catch
modulefile errors *before* your users do.

To run do::

     $LMOD_DIR/check_module_tree_syntax $MODULEPATH

This command will report all the modulefiles that have syntax errors.

Check for multiple ways set a marked default
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lmod has multiple ways to mark a default (See
:ref:`setting-default-label` for more details).  With a large module
tree it can be difficult to know that a particular a directory that
contains multiple modulefiles has more than one file to mark a
default.

When this command walks the module tree reading, it also checks for
multiple ways to mark a default.  For example if a directory has:

   .version    1.0.lua   2.0.lua  3.0.lua  default@

Where symlink default points to the file 2.0.lua. The command will
report that this directory has multiple files marking a default.


Using the --checkSyntax option to check the syntax of a module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tools that generate modulefiles may wish to check the syntax of a
modulefile before installing it.  For example, TACC builds RPMs that
include the package and the modulefile.  They use Lmod to check the
syntax of a modulefile *without* having to have the tree installed.

In other words, this options ignores the Lmod commands like
**execute{}**, **load()**, **depends_on()** and other Lmod commands
that would require a whole module tree be present.

To use put the modulefile in a sub-directory with just the modulefile
in it.  Then set $MODULEPATH to point to that sub-directory. Then load
the module as follows::

    module --checkSyntax load <modulefile>

Where <modulefile> is modulefile you wish to test.
