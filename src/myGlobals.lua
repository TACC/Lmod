--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

require("fileOps")

------------------------------------------------------------------------
-- The global variables for Lmod:
------------------------------------------------------------------------

------------------------------------------------------------------------
-- ModulePath: The name of the environment variable which contains the
--             directories that contain modulefiles.  This
------------------------------------------------------------------------

ModulePath  = "MODULEPATH"

------------------------------------------------------------------------
-- DfltModPath: The name of the env. var. which holds the "Core"
--              modulefile directories.  No compiler or MPI dependent
--              modulefiles directory should ever be part of this list.
------------------------------------------------------------------------

DfltModPath = "LMOD_DEFAULT_MODULEPATH"

------------------------------------------------------------------------
-- LMODdir:     The directory where the cache file, default files
--              and module table state files go.
------------------------------------------------------------------------

LMODdir     = ".lmod.d"

------------------------------------------------------------------------
-- varTbl:      The global table of environment variables that the
--              modules are setting or modifying.
------------------------------------------------------------------------

varTbl      = {}

------------------------------------------------------------------------
-- Cversion:    The current version for the Cache file
------------------------------------------------------------------------

Cversion      = 3

------------------------------------------------------------------------
-- LMOD_DUPLICATE_PATH:  Allow the same path to be stored in PATH like
--                       vars like PATH, LD_LIBRARY_PATH, etc
------------------------------------------------------------------------

LMOD_DUPLICATE_PATH = os.getenv("LMOD_DUPLICATE_PATH") or "@duplicate_path@"

------------------------------------------------------------------------
-- defaultMpathA: The array of paths that are hold the default
--                (non-hierarchical) MODULEPATH
------------------------------------------------------------------------

defaultMpathA = {}

------------------------------------------------------------------------
-- MT:        The table that hold the Module Table Class.
------------------------------------------------------------------------

MT            = {}

------------------------------------------------------------------------
-- Master:    The table that hold the Master Table Class.
------------------------------------------------------------------------

Master         = {}

------------------------------------------------------------------------
-- MCP, mcp:  Master Control Program objects.  These objects implement
--            the module functions: load, setenv, prepend_path, etc.
--            MCP is always positive.  That is, load is load, setenv is
--            setenv.  Where as mcp is dynamic.  It is positive on load
--            and the reverse on unload.
------------------------------------------------------------------------
MCP            = {}
mcp            = {}

------------------------------------------------------------------------
-- capture:   The shell script capture function.
------------------------------------------------------------------------
capture        = nil
require("capture")

------------------------------------------------------------------------
-- adminT:  A table that contains module names and a message to users
--          The main purpose is to tell users that say this module is
--          deprecated.
------------------------------------------------------------------------

adminT         = {}

------------------------------------------------------------------------
-- ComputeModuleResultsA: A place where the generated module file
--                        is written to when computing the sha1sum
------------------------------------------------------------------------
ComputeModuleResultsA = {}

------------------------------------------------------------------------
-- colorize:  It is a colorizer when connected to a term and plain when not
------------------------------------------------------------------------

colorize      = false
------------------------------------------------------------------------
-- pager:     pipe output through more when connectted to a term
------------------------------------------------------------------------
pager         = false



------------------------------------------------------------------------
-- s_warning:   if a warning was generated during the current run
------------------------------------------------------------------------
s_warning     = false

------------------------------------------------------------------------
-- s_haveWarnings:  if warning are allowed (or ignored).  For example
--                  a try-load command turns off warnings.
------------------------------------------------------------------------
s_haveWarnings = true


------------------------------------------------------------------------
-- ancient:  the time in seconds when the cache file is considered old
------------------------------------------------------------------------
ancient = getenv("LMOD_ANCIENT_TIME") or tonumber("@ancient@") or 86400

------------------------------------------------------------------------
-- shortTime: the time in seconds when building the cache file is quick
--            enough to be computed every time rather than cached.
------------------------------------------------------------------------

shortTime = getenv("LMOD_SHORT_TIME") or tonumber("@short_time@") or 10.0


------------------------------------------------------------------------
-- shortLifeCache: If building the cache file is fast then shorten the
--                 ancient to this time.
------------------------------------------------------------------------
shortLifeCache = ancient/12

------------------------------------------------------------------------
-- sysCacheDir:  The system directory location.
------------------------------------------------------------------------
sysCacheDirs    = os.getenv("LMOD_SPIDER_CACHE_DIRS") or "@cacheDirs@"

------------------------------------------------------------------------
-- USE_DOT_FILES: Use ~/.lmod.d/.cache or ~/.lmod.d/__cache__
------------------------------------------------------------------------

USE_DOT_FILES = "@use_dot_files@"

------------------------------------------------------------------------
-- usrCacheDir: user cache directory
------------------------------------------------------------------------
USER_CACHE_DIR_NAME  = ".cache"
USER_SAVE_DIR_NAME   = ".save"
USER_SBATCH_DIR_NAME = ".saveBatch"
if ( USE_DOT_FILES:lower() == "no" ) then
  USER_CACHE_DIR_NAME  = "__cache__"
  USER_SAVE_DIR_NAME   = "__save__"
  USER_SBATCH_DIR_NAME = "__saveBatch__"
end
usrCacheDir   = pathJoin(os.getenv("HOME"),".lmod.d",USER_CACHE_DIR_NAME)
usrSaveDir    = pathJoin(os.getenv("HOME"),".lmod.d",USER_SAVE_DIR_NAME)
usrSBatchDir  = pathJoin(os.getenv("HOME"),".lmod.d",USER_SBATCH_DIR_NAME)
------------------------------------------------------------------------
-- usrCacheFileA: Array of user cache files
------------------------------------------------------------------------
usrCacheFileA = {
      { file = pathJoin(usrCacheDir,   "moduleT.lua"),     fileT = "your"  },
   }

------------------------------------------------------------------------
-- updateSystemFn: The system file that is touched everytime the system
--                 is updated.
------------------------------------------------------------------------

updateSystemFn="@updateSystemFn@"

------------------------------------------------------------------------
-- s_propT:  Where the property table is stored
------------------------------------------------------------------------
s_propT  = {}

------------------------------------------------------------------------
-- s_scDescriptT: Where the system cache descript table is stored.
------------------------------------------------------------------------
s_scDescriptT  = {}


------------------------------------------------------------------------
-- GIT_VERSION: The exact git version of Lmod
------------------------------------------------------------------------

GIT_VERSION = "@git_version@"
