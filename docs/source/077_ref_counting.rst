Rules for PATH-like variables
=============================

Lmod provides great flexibility in handling prepending and appending
to path-like variables.  This is especially true when there are
duplicate entries.  A modulefile can modify a variable like ``PATH``
using ``append_path()`` or ``prepend_path()`` or their TCL
equivalents. For example, suppose that ``PATH=/usr/bin:/usr/local/bin`` then::

   prepend_path("PATH","/bin")

would change ``PATH`` to ``/bin:/usr/bin:/usr/local/bin``.  The
interesting question is what happens when the following is executed::

   prepend_path("PATH","/usr/bin")

That is, when ``/usr/bin`` is already in $PATH or any other duplicate entry.

LMOD_DUPLICATE_PATHS == yes
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lmod supports two main styles for dealing with duplicates.  If
$LMOD_DUPLICATE_PATHS is yes (or Lmod is configured that way).  Then
duplicates entries are allowed (assume PATH is empty)::

  prepend_path("PATH","/A")  --> PATH = /A
  prepend_path("PATH","/B")  --> PATH = /B:/A
  prepend_path("PATH","/A")  --> PATH = /A:/B:/A

When unloading a modulefile with prepend_path(), Lmod removes the first matching
entry it finds.  Reversing an append_path(), Lmod removes the last
matching entry.


LMOD_DUPLICATE_PATHS == no
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The default setting of Lmod is that duplicates are not allowed.  When
prepending, Lmod pushes the directory to be first even if it is a
duplicate (assume PATH is empty)::

  append_path("PATH","/A")   --> PATH = /A
  prepend_path("PATH","/B")  --> PATH = /B:/A
  prepend_path("PATH","/A")  --> PATH = /A:/B

When duplicates are not allowed, Lmod maintains a reference count on
each entry.  That is, Lmod knows that "/A" has appended/prepended
twice and "/B" once.  This means that two prepend_path("PATH","/A") will be
required to completely remove "/A" from $PATH.

LMOD_TMOD_PATH_RULE == yes
~~~~~~~~~~~~~~~~~~~~~~~~~~

If this env. var is set (or configured), then Lmod does not change the
order of entries but it does increase the reference count (assume
$PATH is empty)::

   
  append_path("PATH","/A")   --> PATH = /A
  prepend_path("PATH","/B")  --> PATH = /B:/A
  prepend_path("PATH","/A")  --> PATH = /B:/A

Here we see that prepending "/A" does not change the order of
directories in $PATH.  Obviously if LMOD_TMOD_PATH_RULE is yes
then duplicates are not allowed.

Special treatment for $MODULEPATH
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The MODULEPATH environment variable is treated special.  No duplicates
entries are ever allowed even if LMOD_DUPLICATE_PATHS == yes.  It
always uses reference counting for PATH entries. In order to not
confuse users.  The command::

   $ module unuse /foo/bar

will always remove the path entry, even if the reference count is
greater than 1. Also a user can always clear $MODULEPATH with::

   $ module unuse $MODULEPATH

.. _path_priority-label:

Specifying Priorities for PATH entries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are rare occasions where a site might want a directory to at the
beginning of the PATH.  This can be done by giving a priority to a
path::

    prepend_path{"PATH","/foo/bar",priority=100}

Note the use of curly braces instead of parentheses and setting
priority to a number.  Lmod groups the entries of the same priority
together.   This means that ``/foo/bar`` will likely be at the
beginning of $PATH as long as no other entry has a higher priority.

Assuming that PATH is initially empty, here is an example::

    prepend_path{"PATH","/foo",priority=100}  --> PATH = /foo
    prepend_path("PATH","/A")                 --> PATH = /foo:/A
    prepend_path("PATH","/B")                 --> PATH = /foo:/B/A

Lmod remembers the priority between invocations, meaning that you'll
get the same results even if the following where in three separate
modulefiles.


An Example of Loading and Unloading a Module
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Above we showed that there are three modes for path like variables:

#. LMOD_DUPLICATE_PATH=no   
#. LMOD_DUPLICATE_PATH=no, LMOD_TMOD_PATH_RULE=yes
#. LMOD_DUPLICATE_PATH=yes

Let's assume that $PATH = ``/A:/B:/C`` and the module FOO is::

   prepend_path("PATH","/C")

then the following table shows what happens for each of the three modes when
loading and unloading FOO. Note that ``/A(2)`` is the path entry
``/A`` a reference count of 2:


==================   =================    =================   ===========
Action                       1                   2                3
==================   =================    =================   ===========
original PATH        /A(1):/B(1):/C(1)    /A(1):/B(1):/C(1)   /A:/B:/C
module load FOO      /C(2):/A(1):/B(1)    /A(1):/B(1):/C(2)   /C:/A:/B:/C
module unload FOO    /C(1):/A(1):/B(1)    /A(1):/B(1):/C(1)   /A:/B:/C
==================   =================    =================   ===========

For mode (1) where no duplicates are allowed, upon loading FOO path
``/C`` is moved to the beginning and stays there when unloading FOO.
For mode (2), If a directory is already in ``$PATH``, it is not moved,
only the ref count is increased on load and decreased upon unload.
Finally in mode (3), loading causes ``/C`` to be placed at the
beginning and unloading removes it from the beginning.  


When duplicates are allowed and unloading a module,  Lmod does not
remember which module inserted which directory where, it just removes
the first or last entry depending on whether it was a prepend_path() or
append_path() respectively. Also there is no reference counting when
duplicates are allowed.  It is not necessary and doesn't make sense.
