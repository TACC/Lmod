.. _hidden_modules-label:

Hidden Modules
^^^^^^^^^^^^^^

To see hidden modules a user can do::

    $ module --show_hidden avail
    $ module --show_hidden spider

or::

    $ module --all avail
    $ module --all spider

or::

    $ module -A avail
    $ module -A spider



To hide modules, a site can name a module with a leading "." for the
version or the name:

The following tree contains 3 modules, 2 hidden and one not::

    $ tree -a modulefiles                  

    modulefiles
    ├── .B
    │   └── 3.0.lua
    └── A
        ├── .1.0.lua
        └── 2.0.lua

    $ module avail

     A/2.0 (D)

    $ module --show_hidden avail

     .B/3.0 (H)    A/.1.0 (H)    A/2.0 (D)

It is also possible to mark modules with functions in modulerc files.
See :ref:`modulerc-label` for details on how to mark by using the
modulerc files.

Remember that hidden modules can be loaded with normal commands unless
its hidden type is **hard**.

Finally, if your site wishes to mark many modules as hidden, you can
use the hook function isVisibleHook().  See :ref:`hooks` for
details. Also see the contrib/more_hooks/SitePackage.lua file for a
worked example.
