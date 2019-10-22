.. _extensions-label:

================
Module Extension
================

Lmod provides a way to let users know that a package provides one or
more extension.  So for example a python package might provide the
numpy and scipy software.  But how would a user know that a it is
accessible from the python module.  Sites can create modulefiles that
support the **extension** () function::

   extension("
