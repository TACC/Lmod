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
entries are ever allowed.  Also there no reference counting for PATH
entries stored in $MODULEPATH. Adding the same directory to
$MODULEPATH will not effect the reference count.  It is always ``1``.
This way a user can always clear $MODULEPATH with::

   $ module unuse $MODULEPATH

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
