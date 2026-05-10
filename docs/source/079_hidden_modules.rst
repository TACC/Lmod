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

.. _dot_hidden_load_alias-label:

Dot-leading version directories and ``LMOD_DOT_HIDDEN_LOAD_ALIAS``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Background and rationale: `GitHub issue #817 <https://github.com/TACC/Lmod/issues/817>`__.

When the **version** (or a path segment under the short name) begins with
``.``, Lmod treats the module as **hidden** for ``avail`` and ``spider`` in
the usual way (unless ``--show_hidden``, ``--all``, site policy, or hooks say
otherwise).  By default, loading uses the **canonical name**, including the
dot: for example ``module load A/.1.0`` loads ``A/.1.0.lua``, while
``module load A/1.0`` does **not** automatically pick ``A/.1.0.lua``.

Sites may set the environment variable ``LMOD_DOT_HIDDEN_LOAD_ALIAS`` to
``yes`` (default is ``no``) to opt in to an **optional alias** for loads:

* After an exact key lookup fails, Lmod may resolve a requested version string
  without dots (e.g. ``1.2``) to a **single** sibling modulefile whose path
  differs only by dot-leading segments (e.g. ``.1.2``), **iff** that match is
  **unique**.  If more than one filesystem key normalizes the same way, the
  alias is **not** applied (ambiguous).

* If both an undotted and a dotted key exist for the same logical version (for
  example ``pkg/1.2.lua`` and ``pkg/.1.2.lua``), the **exact** undotted key
  wins; the alias is only for the case where the dotted layout is the sole
  match.

* Listing behavior is unchanged: hidden modules stay hidden from normal
  listings unless users or policy surface them as today.

When ``LMOD_DOT_HIDDEN_LOAD_ALIAS`` is ``yes`` and ``LMOD_PIN_VERSIONS`` is
``no``, ``LOADEDMODULES`` records the **logical** loaded name (e.g.
``itk/1.2``) while the module table still tracks the canonical ``fullName``
(e.g. ``itk/.1.2``).  With the alias **off** (the default), behavior matches
prior releases for ``LOADEDMODULES``.

Finally, if your site wishes to mark many modules as hidden, you can
use the hook function isVisibleHook().  See :ref:`hooks` for
details. Also see the contrib/more_hooks/SitePackage.lua file for a
worked example.
