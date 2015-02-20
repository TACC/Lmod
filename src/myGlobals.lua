--------------------------------------------------------------------------
-- Fixme
-- @module myGlobals

require("strict")
--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2014 Robert McLay
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
_G._DEBUG          = false               -- Required by the new lua posix
local posix        = require("posix")
local getenv       = os.getenv
local setenv_posix = posix.setenv

local function initialize(lmod_name, sed_name, defaultV)
   local defaultV = defaultV or "no"
   local value = (getenv(lmod_name) or sed_name):lower()
   if (value:sub(1,1) == "@") then
      value = defaultV
   end
   if (value ~= "no") then
      value = "yes"
   end
   return value
end


------------------------------------------------------------------------
-- The global variables for Lmod:
------------------------------------------------------------------------

LuaV = (_VERSION:gsub("Lua ",""))

------------------------------------------------------------------------
-- Internally Lmod uses LC_ALL -> "C" so that the user environment won't
-- break things.
------------------------------------------------------------------------
setenv_posix("LC_ALL","C",true)

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
-- LUAC_PATH : The path to luac
------------------------------------------------------------------------

LUAC_PATH = "@path_to_luac@"

------------------------------------------------------------------------
-- LMOD_CASE_INDEPENDENT_SORTING :  make avail and spider use case
--                                  independent sorting.
------------------------------------------------------------------------


LMOD_CASE_INDEPENDENT_SORTING = getenv("LMOD_CASE_INDEPENDENT_SORTING") or
                                "@case_independent_sorting@"

------------------------------------------------------------------------
-- LMOD_REDIRECT:  Send messages to stdout instead of stderr
------------------------------------------------------------------------
LMOD_REDIRECT = initialize("LMOD_REDIRECT", "@redirect@")

------------------------------------------------------------------------
-- LMOD_SYSTEM_NAME:  When on a shared file system, use this to
--                    form the cache name and collection names.
------------------------------------------------------------------------

LMOD_SYSTEM_NAME = getenv("LMOD_SYSTEM_NAME")

------------------------------------------------------------------------
-- LMOD_DISABLE_SAME_NAME_AUTOSWAP: This env. var requires users to swap
--                  out rather than using the one name rule. 
------------------------------------------------------------------------

LMOD_DISABLE_SAME_NAME_AUTOSWAP = initialize("LMOD_DISABLE_SAME_NAME_AUTOSWAP",
                                             "@disable_name_autoswap@")

------------------------------------------------------------------------
-- LMOD_AUTO_SWAP:  Swap instead of Error
------------------------------------------------------------------------

LMOD_AUTO_SWAP   = initialize("LMOD_AUTO_SWAP","@auto_swap@")

------------------------------------------------------------------------
-- LMOD_AVAIL_MPATH:  Include MODULEPATH in avail search
------------------------------------------------------------------------

LMOD_MPATH_AVAIL = initialize("LMOD_MPATH_AVAIL", "@mpath_avail@")

------------------------------------------------------------------------
-- LMOD_ALLOW_TCL_MFILES:  Allow Lmod to read TCL based modules.
------------------------------------------------------------------------

LMOD_ALLOW_TCL_MFILES = getenv("LMOD_ALLOW_TCL_MFILES") or
                        "@allow_tcl_mfiles@"

------------------------------------------------------------------------
-- LMOD_DUPLICATE_PATHS:  Allow the same path to be stored in PATH like
--                       vars like PATH, LD_LIBRARY_PATH, etc
------------------------------------------------------------------------

LMOD_DUPLICATE_PATHS = getenv("LMOD_DUPLICATE_PATHS") or "@duplicate_paths@"



LMOD_IGNORE_CACHE = getenv("LMOD_IGNORE_CACHE") or "0"
LMOD_IGNORE_CACHE = (LMOD_IGNORE_CACHE:trim() ~= "0")


------------------------------------------------------------------------
-- LMOD_PAGER: Lmod will use this value of pager if set.
------------------------------------------------------------------------

LMOD_PAGER = getenv("LMOD_PAGER")


------------------------------------------------------------------------
-- LMOD_RTM_TESTING: If set then the author is testing Lmod
------------------------------------------------------------------------

LMOD_RTM_TESTING = getenv("LMOD_RTM_TESTING")


------------------------------------------------------------------------
-- LMOD_AVAIL_STYLE: Used by the avail hook to control how avail output
--                   is handled.   This is a colon separated list of
--                   names.  Note that the default choice is marked by
--                   angle brackets:  A:B:<C> ==> C is the default.
--                   If no angle brackets are specified then the first
--                   entry is the default (i.e. A:B:C => A is default.
------------------------------------------------------------------------

LMOD_AVAIL_STYLE = getenv("LMOD_AVAIL_STYLE") or "<system>"
if (LMOD_AVAIL_STYLE == "") then
   LMOD_AVAIL_STYLE = "<system>"
end

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
require("capture")

------------------------------------------------------------------------
-- adminT:  A table that contains module names and a message to users
--          The main purpose is to tell users that say this module is
--          deprecated.
------------------------------------------------------------------------

adminT         = {}

------------------------------------------------------------------------
-- ShowResultsA: A place where the generated module file is written to
--               when forming a show and computing a sha1sum
------------------------------------------------------------------------
ShowResultsA = {}

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
ancient = tonumber(getenv("LMOD_ANCIENT_TIME")) or tonumber("@ancient@") or 86400

------------------------------------------------------------------------
-- shortTime: the time in seconds when building the cache file is quick
--            enough to be computed every time rather than cached.
------------------------------------------------------------------------

shortTime = tonumber(getenv("LMOD_SHORT_TIME")) or tonumber("@short_time@") or 10.0


------------------------------------------------------------------------
-- Threshold:  The amount of time to wait before printing the cache
--             rebuild message.  (It has to be 1 second or greater).
------------------------------------------------------------------------
Threshold = tonumber(getenv("LMOD_THRESHOLD")) or 1

------------------------------------------------------------------------
-- shortLifeCache: If building the cache file is fast then shorten the
--                 ancient to this time.
------------------------------------------------------------------------
shortLifeCache = ancient/12

------------------------------------------------------------------------
-- sysCacheDir:  The system directory location.
------------------------------------------------------------------------
sysCacheDirs    = getenv("LMOD_SPIDER_CACHE_DIRS") or "@cacheDirs@"



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
usrCacheDir   = pathJoin(getenv("HOME"),".lmod.d",USER_CACHE_DIR_NAME)
usrSaveDir    = pathJoin(getenv("HOME"),".lmod.d",USER_SAVE_DIR_NAME)
usrSBatchDir  = pathJoin(getenv("HOME"),".lmod.d",USER_SBATCH_DIR_NAME)

------------------------------------------------------------------------
-- updateSystemFn: The system file that is touched everytime the system
--                 is updated.
------------------------------------------------------------------------

updateSystemFn="@updateSystemFn@"

------------------------------------------------------------------------
-- Prepend path block order.
s_prependBlock  = "@prepend_block@"


------------------------------------------------------------------------
-- s_propT:  Where the property table is stored
------------------------------------------------------------------------
s_propT  = {}

------------------------------------------------------------------------
-- s_rcFileA: list of active RC files
------------------------------------------------------------------------
s_rcFileA  = {}

------------------------------------------------------------------------
-- s_scDescriptT: Where the system cache descript table is stored.
------------------------------------------------------------------------
s_scDescriptT  = {}




------------------------------------------------------------------------
-- GIT_VERSION: The exact git version of Lmod
------------------------------------------------------------------------

GIT_VERSION = "@git_version@"

------------------------------------------------------------------------
-- epoch
------------------------------------------------------------------------
epoch      = false
epoch_type = false

--------------------------------------------------------------------------
-- Accept functions: Allow or ignore TCL mfiles
--------------------------------------------------------------------------
accept_fn       = false
accept_extT     = false

------------------------------------------------------------------------
-- allow dups function: allow for duplicate entries in PATH like vars.
------------------------------------------------------------------------
allow_dups      = false

------------------------------------------------------------------------
-- When building the reverseMapT use the preloaded modules
------------------------------------------------------------------------
Use_Preload     = false


PkgBase = false
PkgLmod = false
