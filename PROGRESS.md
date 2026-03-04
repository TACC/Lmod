# Issue #805 Progress

## Summary

**Issue**: [Followup on "Show command to load module on failure" #804](https://github.com/TACC/Lmod/issues/805)

When loading multiple modules with disjoint dependency hierarchies (e.g., Python under GCCcore, QGIS under GCC+OpenMPI), Lmod suggests incorrect commands that would fail (e.g., `module load GCCcore/12.3.0 Python QGIS` when QGIS only exists under GCC/12.3.0 OpenMPI/4.1.5).

## Investigation (2026-02-16)

### Module Tree (from `modules.tar.gz`)

Reporter provided `modules.tar.gz` (minimal HMNS tree based in `/scratch/ake/mtest`).

**Structure**:
- **Python**: Under `Compiler/GCCcore/{12.3.0,13.2.0,13.3.0}/Python/` (GCCcore level only)
- **QGIS**: Under `MPI/GCC/12.3.0/OpenMPI/4.1.5/QGIS/` (full MPI stack required)

Spider cache `parentAA`:
- Python: `{"GCCcore/12.3.0"}`, `{"GCCcore/13.2.0"}`, `{"GCCcore/13.3.0"}`
- QGIS: `{"GCC/12.3.0", "OpenMPI/4.1.5"}`

### Root Cause

`l_find_common_paths` uses `l_paths_compatible`, which treats paths as compatible only when one is a **prefix** of the other. GCCcore paths and GCC/OpenMPI paths are **disjoint** (no prefix relationship), so `l_find_common_paths` correctly returns empty.

When `commonPaths` is empty, we **fall back** to per-module path generation (lines 396–421). The fallback adds a command for **every** path of **every** failing module, without checking whether that path works for the **other** failing modules. Result:

- Commands from Python’s paths: `GCCcore/12.3.0 Python QGIS`, `GCCcore/13.2.0 Python QGIS`, etc. (invalid for QGIS)
- Commands from QGIS’s path: `GCC/12.3.0 OpenMPI/4.1.5 Python QGIS` (valid)

All of these are added; invalid suggestions are not filtered out.

### Developer Hypothesis vs. Findings

The developer suspected the spider cache might be wrong. Investigation shows the cache is correct; `parentAA` reflects the hierarchy. The issue is in our **fallback logic**, which does not require that a suggested path works for all failing modules.

## Fix (Implemented)

### Case A: Python + QGIS (disjoint but compatible)

**Heuristic when `commonPaths` is empty (disjoint hierarchies):**

1. **Most-constrained modules**: Collect paths only from modules with the **fewest** paths.
2. **Prefer longest path when tied**: When multiple modules tie (e.g., both n=1), suggest only the **longest** path(s). Longer paths are more specific and more likely to satisfy all modules (e.g., GCC/OpenMPI pulls in GCCcore via depends_on).

For Python+QGIS, only QGIS contributes (n=1 vs Python’s n=3), so we suggest `module load GCC/12.3.0 OpenMPI/4.1.5 Python QGIS`.

### Case B: CubeWriter + QGIS (incompatible toolchains)

Reporter feedback (Feb 17): When modules have **no** common toolchain (e.g., CubeWriter under GCCcore/13.3.0, QGIS under GCC/12.3.0 OpenMPI), do not suggest invalid commands. Instead show: *"These modules cannot be loaded together - they require incompatible toolchains."*

**Implementation**: When multiple modules contribute candidates (nContributors > 1), filter each candidate: keep only paths that are compatible with **all** failing modules (via `l_paths_compatible`). If no path passes, return the incompatible-toolchains message instead of invalid suggestions.

For CubeWriter+QGIS: both contribute (n=1 each). CubeWriter’s path (GCCcore/13.3.0) is incompatible with QGIS’s (GCC/OpenMPI), and vice versa. Filter removes both; we show the message.

### Case C: Pre-loaded toolchain (Feb 19 feedback)

Reporter: When user runs `ml GCC/12.3.0 OpenMPI/4.1.5 CubeWriter QGIS`, CubeWriter fails. We had suggested `module load GCCcore/13.3.0 GCC/12.3.0 OpenMPI/4.1.5 CubeWriter QGIS` — wrong for HMNS.

**Implementation**: Collect parent paths of currently loaded modules; filter suggestions that conflict. If all filtered, show: *"The requested module(s) require a toolchain that is incompatible with the currently loaded environment."*

## Next Steps

1. ~~Implement the fix~~ Done.
2. ~~Add regression test~~ Done: `rt/load_suggest_cmd_805/` (Python+QGIS, CubeWriter+QGIS, pre-loaded toolchain).
3. **Respond on issue #805**: Report findings, implemented fix, and test reference.
4. ~~Run existing tests~~ Done: `load_suggest_cmd` and `load_suggest_cmd_805` pass.

## Files Touched

- `modules.tar.gz` – Reporter’s minimal module tree (project root)
- `mtest_extract/` – Extracted tree used for local testing
- `src/MainControl.lua` – `l_format_dependency_commands` fallback (lines 396–421)
