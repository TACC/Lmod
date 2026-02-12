.. _load_failure_suggestions:

Load Failure Suggestions (Issue #804)
======================================

When you run ``module load boost/1.75.0`` and the module exists but cannot load because its dependency (e.g., a compiler) is missing, Lmod shows an error. Instead of only suggesting ``module spider boost/1.75.0``, Lmod now shows ready-to-copy-paste commands like ``module load gcc/10.0 boost/1.75.0``. If you asked for multiple modules at once, the suggestion includes all of them in the order you requested.

This document describes how that feature works and how to maintain or modify it.

Purpose
-------

When a load fails due to missing dependencies, Lmod queries the spider cache to find which modules satisfy those dependencies. It then formats the result as one or more ``module load`` commands. The goal is to let users fix the failure without running ``module spider`` on each module.

Separation of Concerns
----------------------

Two internal tables serve different roles:

- **``s_allRequestedT``**: The user's original request. Set exactly once at the command entry point in ``src/cmdfuncs.lua`` via ``mcp:setOriginalUserRequest(lA)``. Nested ``load_usr`` calls (e.g., from family swaps inside ``src/Hub.lua``) do not go through ``cmdfuncs``, so they never overwrite this table. This keeps the suggestion aligned with what the user typed.

- **``s_loadT``**: Tracks every module Lmod attempts to load, including those pulled in by ``depends_on`` or other nested loads. Populated by ``l_registerUserLoads`` at all stack depths. Used to detect which modules actually failed (``l_compareRequestedLoadsWithActual``).

We use ``s_allRequestedT`` for formatting suggestions because it reflects the user's intent. We use ``s_loadT`` for failure detection because it includes dependency failures. Keeping them separate avoids corrupting the suggestion when internal operations trigger nested loads.

Code Flow
---------

1. **Entry**: In ``src/cmdfuncs.lua``, ``l_usrLoad`` receives the parsed module list ``lA``. Before calling ``mcp:load_usr(lA)``, it calls ``mcp:setOriginalUserRequest(lA)`` to store the user's request.

2. **Load and failure detection**: ``load_usr`` registers the requested modules in ``s_loadT`` and delegates to ``load``. On return, ``mustLoad`` calls ``l_compareRequestedLoadsWithActual()`` to find which entries in ``s_loadT`` are not active. Those become ``kA`` (show names) and ``kB`` (user names).

3. **Suggestions**: If any modules failed and are "known" (exist but could not load), ``l_error_on_missing_loaded_modules`` obtains the spider database ``dbT`` from ``Cache:singleton()``. It calls ``l_format_dependency_commands(kA, kB, dbT)`` to build the suggestion text.

4. **Message**: The result is passed as the ``suggest_cmd`` placeholder into the ``e_Failed_Load_2`` message. See :ref:`localization`.

Phase 2 Filtering
-----------------

The suggestion must include all user-requested modules that make sense with each dependency path, but not modules that conflict with that path. A conflict occurs when the user requested a module with the same short name as something in the path but a different version (e.g., user asked for ``gcc/11`` but the path requires ``gcc/10.0``).

``l_build_modules_for_path(path, failingSet)`` implements this:

- Build a set of short names from ``path`` (e.g., ``{"gcc"}`` for ``{"gcc/10.0"}``).
- Walk ``s_allRequestedT`` in the user's order.
- Include a module if it is in ``failingSet``, or if its short name is not in the path set.
- Exclude a module if its short name is in the path set and it is not failing (it would conflict).

Example: User runs ``module load gcc/10.0 gcc/11 boost/1.75.0``. Only ``boost`` fails. The dependency path is ``gcc/10.0``. We include ``boost/1.75.0`` (failing) but not ``gcc/11`` (same short name as path, different version).

Key Functions
-------------

- **``M.setOriginalUserRequest(self, mA)``**: Stores the user's request in ``s_allRequestedT``. Called only from ``cmdfuncs.lua`` before ``load_usr``.

- **``l_build_modules_for_path(path, failingSet)``**: Returns the ordered list of user-requested module names to append after ``path``, with conflicts filtered out.

- **``l_format_dependency_commands(kA, kB, dbT)``**: Uses ``l_collect_all_parentAA`` and ``l_find_common_paths`` to get dependency paths, then ``l_build_modules_for_path`` to build each command. Limits output to 5 suggestions and sorts them alphabetically for deterministic output.

Message Customization
---------------------

The suggestion text is inserted via the ``%{suggest_cmd}`` placeholder in the ``e_Failed_Load_2`` message in ``messageDir/en.lua``. When there are no suggestions (e.g., cache unavailable), ``suggest_cmd`` is an empty string. To change the wording or layout, edit the message or use a site override. See :ref:`localization`.

Testing
-------

The regression tests for this feature live in ``rt/load_suggest_cmd/``. They cover:

- Single module with one or several dependency options (e.g., boost via gcc or intel).
- Multiple modules with common paths (e.g., boost and hdf5 both needing gcc).
- Core modules plus failing modules (e.g., python/3.9 loads, boost fails; suggestion includes python).
- Order preservation (user order kept in suggestions).
- Pre-loaded modules (e.g., python already loaded, then ``load python boost``; suggestion still correct).
- Multi-level dependencies (e.g., petsc needs gcc and openmpi).

To run these tests, use the ``t`` command from the testing framework. See the :ref:`lmod_testing_guide` for setup and usage.

How to Modify
-------------

- **Change the suggestion format**: Edit ``l_format_dependency_commands`` in ``src/MainControl.lua``. The max number of suggestions (5) and the prefix ("   Or load any one of these options:\n") are defined there.

- **Change conflict rules**: Edit ``l_build_modules_for_path``. The logic that compares short names and ``pathSnSet`` controls which modules are excluded.

- **Change the message text**: Edit ``e_Failed_Load_2`` in ``messageDir/en.lua`` or provide a site override. Keep the ``%{suggest_cmd}`` placeholder.

- **Add new behavior**: The main extension points are ``l_format_dependency_commands`` (to alter which commands are shown) and the Cache/spider logic (to change how dependency paths are discovered).
