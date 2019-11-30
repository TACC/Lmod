.. _extensions-label:

=================
Module Extensions
=================

Lmod provides a way to let users know that a package provides one or
more extension.  So for example a python package might provide the
numpy and scipy software.  But how would a user know that a it is
accessible from the python module.  Sites can create modulefiles that
support the **extensions** () function::

   extensions("numpy/1.12, scipy/1.1")

In tcl, this can be written as::

   extensions numpy/1.12 scipy/1.1

The names in the string need to be of the form "name/version"
only. The case of the name doesn't matter.  Category/Name/Version is
not supported.  Neither is "Name/Version/Version".
  
Users can use module spider to learn about what is extensions are
available::

    $ module spider

      ...
      numpy: numpy/1.12 (E), numpy/1.16.4 (E)
      ...
      scipy: scipy/1.1 (E), scipy/1.2.2 (E)
      ...

The trailing (E) lets users know that this software is an extension
provided by another module and is not a module itself.  Also if color
is turned on extensions are displayed in blue.

To find out about what extensions exists of a particular software
extension users can do::


   $ module spider numpy

    numpy:
      Versions:
         numpy/1.12 (E)
         numpy/1.16.4 (E)


To find out which modules provide the extension a user can do::


   $ module spider numpy/1.16.4

     numpy: numpy/1.16.4
     This extension is provided by the following modules. To access the extension you must load one. Note that any module names in parentheses show the module location in the software hierarchy.
       python2/2.7.14
       python2/2.7 (intel/11.2)
       python2/2.7 (intel/11.0)
       python2/2.7 (gcc/4.2.5)
       python2/2.7 (gcc/4.2.3)

Users can find out what extensions exist by using the **module**
**avail** command::

   $ module avail

   ...
   This is a list of module extensions
     numpy (E)    scipy (E)

Note that the name of the extension is shown without any version
information.  The command **module avail** shows modules that can be
loaded.  A user *cannot* load an extension directly.  If a user tries
to load an extension directly, Lmod knows that it is an extension and
directs the user to use **module** **spider** to find where the
extension is. Again if color is turned on then the names of the
extensions are in blue. Sites or users can set the environment
variable LMOD_COLORIZE  to "no" to turn off color.


