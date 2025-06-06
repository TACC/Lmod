.. _deepdive_mname_resolution:

From Module Name to Module Path: The Journey of an MName Object
===============================================================

When a user issues a command like ``module load foo/1.0``, Lmod needs to translate the string "foo/1.0" into a concrete path to a modulefile on the filesystem. This transformation is primarily orchestrated by **MName objects**, with significant help from other components like `ModuleA`, `LocationT`, `DirTree`, and `collectionFileA`.

An ``MName`` (Module Name) object, defined in ``src/MName.lua``, is Lmod's primary internal representation of a module name. It encapsulates not just the name, but also the logic to find and resolve that name to a specific file.

The process can be broken down as follows:

**MName Instantiation (`MName:new()`)**

-   When Lmod processes a command involving a module name (e.g., in `l_usrLoad()` from `src/cmdfuncs.lua`), it creates an ``MName`` object using `MName:new(sType, name, action, ...)`.

    -   `sType`: Specifies the context, commonly "load" when trying to find a new module to load, or "mt" when referring to an already loaded module in the Module Table.
    -   `name`: The raw string provided by the user (e.g., "foo/1.0"). This is stored internally as `__userName` after basic cleaning (trimming whitespace, removing trailing "/" or ".lua").
    -   `action`: Determines the search strategy. Examples include "exact" (find this specific version), "match" (find a suitable match, possibly a default), or "latest". This `action` results in the instantiation of a specialized MName variant (e.g., ``MN_Exact`` from ``src/MN_Exact.lua``, ``MN_Match`` from ``src/MN_Match.lua``) that inherits from the base ``MName`` class. These variants define specific search steps.

-   At this stage, core properties of the MName object like `__fn` (the resolved filepath), `__sn` (the short name, e.g., "foo"), and `__version` are typically initialized to `false`. The actual resolution is deferred.

**Lazy Evaluation (`l_lazyEval()`)**

-   The MName object doesn't immediately search for the module file upon creation. Instead, it performs **lazy evaluation**. The actual resolution logic is triggered by the `l_lazyEval(self)` function within `MName.lua`.
-   This function is called automatically the first time a resolved property (like `:fn()`, `:sn()`, `:version()`, or `:valid()`) is accessed on the ``MName`` object.
-   The core of `l_lazyEval()` for an `sType` of "load" involves these steps:

    1.  **Get `ModuleA` Singleton**: It obtains an instance of ``ModuleA`` (from ``src/ModuleA.lua``) using `ModuleA:singleton{spider_cache = ...}`. ``ModuleA`` is responsible for knowing about all available modules, either by reading a pre-computed spider cache or by actively scanning the `MODULEPATH`.
    2.  **Initial Name Resolution**: The `__userName` might be further resolved or canonicalized using `MRC:resolve()` (ModuleRC or Resolution Control).
    3.  **Search via `ModuleA`**: It calls `moduleA:search(userName)` to get a preliminary list of candidate module files. This is a critical step where `ModuleA` looks up the `userName`.

**`ModuleA:search()` - The Two Paths**

The behavior of `moduleA:search(userName)` depends on whether Lmod determines the module path structure to be primarily Name/Version/Version (NVV) or not. This is tracked by the `ModuleA.__isNVV` flag. For a general overview of how Lmod picks modules in these different layouts, see :ref:`nv_rules-label` and :ref:`NVV-label`.

**N/V Path (Standard Name/Version Layouts)**

-   If `ModuleA.__isNVV` is `false`, the search is delegated to a ``LocationT`` object. (See :ref:`nv_rules-label` for more details on N/V rules).
-   **`LocationT:new(moduleA_data)`**:

    -   If a ``LocationT`` object (`src/LocationT.lua`) hasn't been created yet for the current `ModuleA` data, it's instantiated.
    -   The `LocationT` constructor (specifically its local `l_build` function) takes `ModuleA.__moduleA` (which is an array of module structures, one for each `MODULEPATH` directory) and *merges* them into a single, unified tree representation (`self.__locationT`).
    -   The merging logic (`l_merge_locationT` in `LocationT.lua`) handles potential conflicts if the same module/version exists in multiple `MODULEPATH` directories. It uses the `wV` (weighted version string, which includes default priorities) to decide which version takes precedence in the unified view. This ensures consistent resolution across the entire `MODULEPATH`.
-   **`LocationT:search(name)`**:

    -   This method takes the `name` and first determines the base "short name" (`sn`) by looking up keys in its unified `__locationT` tree. For "foo/1.0", `sn` would become "foo", and `versionStr` would be "1.0".
    -   It then navigates this merged tree using `sn` and the components of `versionStr` to find the specific module structure node (`v`).
    -   Finally, it calls `collectFileA(sn, versionStr, extended_default, v, output_table)` to populate `output_table` with candidate files from this node `v`. `collectFileA` is defined in `src/collectionFileA.lua`.

**N/V/V Path (Name/Version/Version Layouts)**

-   If `ModuleA.__isNVV` is `true`, `ModuleA` uses its internal `l_search(name, moduleA_data)` function (local to `ModuleA.lua`). (See :ref:`NVV-label` for more details on N/V/V rules).
-   **`l_find_vA(name, moduleA_data)`**: This helper function first parses the input `name` to identify a base short name (`sn`) and the remaining version string (`versionStr`). It then searches through all entries in `moduleA_data` (i.e., each `MODULEPATH` directory's unmerged view) to find all occurrences of this `sn`. It returns an array (`vA`) of module structures for `sn`, one for each `MODULEPATH` where it was found.
-   **`l_find_vB(sn, versionStr, vA)`**: This further refines `vA` by trying to navigate within each structure using the `versionStr` to pinpoint the exact version requested. It returns `vB`, a list of these version-specific nodes.
-   **`l_search` (Continued)**: It iterates through each node in `vB`. For each, it calls `collectFileA(sn, fullStr, extended_default, node, output_table_for_this_mpath)`.
-   The result `fileA` from `ModuleA:search()` in NVV mode is an array of arrays (e.g., `[ [files_from_path1], [files_from_path2] ]`), reflecting that the same NVV module might be found in multiple `MODULEPATH` locations.

**`collectFileA()` - Gathering Candidates**

-   Defined in `src/collectionFileA.lua`, `collectFileA(sn, versionStr, extended_default, v, fileA_output)` is the workhorse that populates `fileA_output` with actual file details from a given module structure node `v`.
-   If `versionStr` is provided, it attempts an exact match within `v.fileT`. If `extended_default` is on, it might also do prefix matching.
-   If no `versionStr` is given (or if searching for "default"), it collects all files from `v.fileT`.
-   It recursively calls itself for any subdirectories in `v.dirT`, ensuring all relevant files under a resolved module node are collected.

**`MName`'s Final Selection: Applying Steps**

-   After `ModuleA:search()` (via either path) returns `sn`, `versionStr`, and `fileA` (the list of candidate file structures), the `l_lazyEval()` function in `MName.lua` takes over again.
-   It retrieves a list of search functions (steps) using `self:steps()`. These steps are defined by the specialized MName `action` type (e.g., `MN_Exact.lua` provides `MName.find_exact_match`).
-   It iterates through these step functions (e.g., `MName.find_exact_match()`, `MName.find_highest()`), applying each one to the `fileA` list.

    -   These functions use the `pV` (parsed version for sorting) and `wV` (weighted version, including default priorities) attributes that were added to file entries by `ModuleA` (originally during its `l_addPV` processing of `DirTree` output).

-   The first step function that successfully finds and selects a single module file from `fileA` determines the outcome. This populates `self.__fn` (the final filepath), `self.__version`, and other properties on the ``MName`` object.

**The Role of `DirTree`**

-   While `ModuleA` provides the searchable data, it often gets this data from `DirTree` (``src/DirTree.lua``) if a spider cache isn't being used.
-   When `ModuleA` is initialized, `DirTree:new(mpathA)` is called.
-   `DirTree` scans each path in `MODULEPATH` recursively (`l_walk_tree` and `l_walk` functions). It identifies modulefiles, directories, and special files like `.version` or `.modulerc`.
-   It builds a hierarchical tree structure (`dirA`) representing the filesystem layout, noting file paths, canonical names, and information about defaults.
-   This `dirA` output is then processed by `ModuleA`'s `l_build` and `l_GroupIntoModules` functions, which restructure it and add the crucial `pV` and `wV` properties, creating the `ModuleA.__moduleA` data that `LocationT` or `ModuleA.l_search` will consume.

In summary, converting a module name string to a path is a sophisticated process involving initial parsing into an ``MName`` object, lazy evaluation to trigger a search through ``ModuleA`` (which uses either a merged `LocationT` view or a direct NVV search), collection of candidates by `collectFileA`, and finally, rule-based selection by the ``MName`` object based on its defined action and the weighted properties of the candidates. 
