#!/bin/sh
# Verify that installed Lua shared libraries use symlinks (SONAME, SONAMEV)
# rather than duplicated files. Run after 'make install'.
# Usage: test-lib-symlinks.sh <lib-dir>
#   lib-dir: path to installed lib (e.g. DESTDIR/path/to/lmod/lmod/lib)

set -e

LIB_DIR="${1:?Usage: $0 <lib-dir>}"

if [ ! -d "$LIB_DIR" ]; then
  echo "$0: error: lib dir not found: $LIB_DIR" >&2
  exit 1
fi

check_symlink() {
  local path="$1"
  local desc="${2:-$path}"
  if [ -e "$path" ]; then
    if [ -L "$path" ]; then
      echo "OK $desc is a symlink"
    else
      echo "FAIL $desc exists but is NOT a symlink (duplicated file)" >&2
      return 1
    fi
  fi
}

errs=0

# lfs: lfs.so, lfs.so.1 should be symlinks to lfs.so.1.0.1
if [ -f "$LIB_DIR/lfs.so.1.0.1" ] || [ -f "$LIB_DIR/lfs.so" ]; then
  check_symlink "$LIB_DIR/lfs.so.1" "lfs.so.1" || errs=$((errs + 1))
  check_symlink "$LIB_DIR/lfs.so" "lfs.so" || errs=$((errs + 1))
fi

# term/core: core.so, core.so.1 should be symlinks to core.so.1.0.1
if [ -d "$LIB_DIR/term" ]; then
  if [ -f "$LIB_DIR/term/core.so.1.0.1" ] || [ -f "$LIB_DIR/term/core.so" ]; then
    check_symlink "$LIB_DIR/term/core.so.1" "term/core.so.1" || errs=$((errs + 1))
    check_symlink "$LIB_DIR/term/core.so" "term/core.so" || errs=$((errs + 1))
  fi
fi

# tcl2lua: tcl2lua.so, tcl2lua.so.1 should be symlinks to tcl2lua.so.1.0.1
if [ -f "$LIB_DIR/tcl2lua.so.1.0.1" ] || [ -f "$LIB_DIR/tcl2lua.so" ]; then
  check_symlink "$LIB_DIR/tcl2lua.so.1" "tcl2lua.so.1" || errs=$((errs + 1))
  check_symlink "$LIB_DIR/tcl2lua.so" "tcl2lua.so" || errs=$((errs + 1))
fi

if [ $errs -gt 0 ]; then
  echo "$0: $errs check(s) failed" >&2
  exit 1
fi
echo "All library symlink checks passed."
