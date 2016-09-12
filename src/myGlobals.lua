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
local s_validT     = {
   no = true,
   yes = true,
}

local function initialize(lmod_name, sed_name, defaultV, validT)
   validT      = validT or s_validT
   defaultV    = (defaultV or "no"):lower()
   local value = (getenv(lmod_name) or sed_name):lower()
   if (value:sub(1,1) == "@") then
      value = defaultV
   end
   if (not validT[value]) then
      value = "yes"
   end
   return value
end


------------------------------------------------------------------------
-- The global variables for Lmod:
------------------------------------------------------------------------

LuaV = (_VERSION:gsub("Lua ",""))

------------------------------------------------------------------------
-- Lmod ExitHookArray Object:
------------------------------------------------------------------------

ExitHookA = require("HookArray")

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
-- LMOD_CHECK_FOR_VALID_MODULE_FILES :  Should Lmod check TCL files for
--                                      magic string "#%Module"
------------------------------------------------------------------------

LMOD_CHECK_FOR_VALID_MODULE_FILES = initialize("LMOD_CHECK_FOR_VALID_MODULE_FILES",
                                               "@check_for_valid_module_files@",
                                               "no")

------------------------------------------------------------------------
-- LMOD_CASE_INDEPENDENT_SORTING :  make avail and spider use case
--                                  independent sorting.
------------------------------------------------------------------------


LMOD_CASE_INDEPENDENT_SORTING = initialize("LMOD_CASE_INDEPENDENT_SORTING",
                                           "@case_independent_sorting@")

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
-- LMOD_COLUMN_TABLE_WIDTH: The width of the table when using ColumnTable
------------------------------------------------------------------------

LMOD_COLUMN_TABLE_WIDTH = 80

------------------------------------------------------------------------
-- LMOD_TMOD_PATH_RULE:  Using Tmod rule where if path is already there
--                       do not prepend/append
------------------------------------------------------------------------

LMOD_TMOD_PATH_RULE = initialize("LMOD_TMOD_PATH_RULE",
                                "@tmod_path_rule@","NO")

------------------------------------------------------------------------
-- LMOD_DISABLE_SAME_NAME_AUTOSWAP: This env. var requires users to swap
--                  out rather than using the one name rule.
------------------------------------------------------------------------

LMOD_DISABLE_SAME_NAME_AUTOSWAP = initialize("LMOD_DISABLE_SAME_NAME_AUTOSWAP",
                                             "@disable_name_autoswap@")

--------------------------------------------------------------------------
-- When restoring, use specified version instead of following the default
--------------------------------------------------------------------------

LMOD_PIN_VERSIONS = initialize("LMOD_PIN_VERSIONS", "@pin_versions@")

------------------------------------------------------------------------
-- LMOD_AUTO_SWAP:  Swap instead of Error
------------------------------------------------------------------------

LMOD_AUTO_SWAP   = initialize("LMOD_AUTO_SWAP","@auto_swap@","yes")

------------------------------------------------------------------------
-- LMOD_EXACT_MATCH:  Swap instead of Error
------------------------------------------------------------------------

LMOD_EXACT_MATCH   = initialize("LMOD_EXACT_MATCH","@exact_match@","no")

------------------------------------------------------------------------
-- LMOD_AVAIL_MPATH:  Include MODULEPATH in avail search
------------------------------------------------------------------------

LMOD_MPATH_AVAIL = initialize("LMOD_MPATH_AVAIL", "@mpath_avail@")

------------------------------------------------------------------------
-- LMOD_ALLOW_TCL_MFILES:  Allow Lmod to read TCL based modules.
------------------------------------------------------------------------

LMOD_ALLOW_TCL_MFILES = initialize("LMOD_ALLOW_TCL_MFILES",
                                   "@allow_tcl_mfiles@","yes")

------------------------------------------------------------------------
-- LMOD_DUPLICATE_PATHS:  Allow the same path to be stored in PATH like
--                        vars like PATH, LD_LIBRARY_PATH, etc
------------------------------------------------------------------------

LMOD_DUPLICATE_PATHS = initialize("LMOD_DUPLICATE_PATHS",
                                  "@duplicate_paths@", "no")


LMOD_IGNORE_CACHE = getenv("LMOD_IGNORE_CACHE") or "0"
LMOD_IGNORE_CACHE = (LMOD_IGNORE_CACHE:trim() ~= "0")

------------------------------------------------------------------------
-- LMOD_CACHED_LOADS: Use spider cache on loads
------------------------------------------------------------------------
LMOD_CACHED_LOADS = initialize("LMOD_CACHED_LOADS","@cached_loads@", "no")
LMOD_CACHED_LOADS = LMOD_IGNORE_CACHE and "no" or LMOD_CACHED_LOADS

------------------------------------------------------------------------
-- LMOD_PAGER: Lmod will use this value of pager if set.
------------------------------------------------------------------------

LMOD_PAGER      = getenv("LMOD_PAGER") or "@path_to_pager@"
LMOD_PAGER_OPTS = getenv("LMOD_PAGER_OPTS") or "-XqMREF"


MODULERCFILE = getenv("MODULERCFILE") or pathJoin(cmdDir(),"../../etc/rc")

------------------------------------------------------------------------
-- LMOD_RTM_TESTING: If set then the author is testing Lmod
------------------------------------------------------------------------

LMOD_RTM_TESTING = getenv("LMOD_RTM_TESTING")

------------------------------------------------------------------------
-- LMOD_ADMIN_FILE: The Nag file.
------------------------------------------------------------------------
LMOD_ADMIN_FILE = getenv("LMOD_ADMIN_FILE") or pathJoin(cmdDir(),"../../etc/admin.list")

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
-- stackTraceBackA 
------------------------------------------------------------------------
stackTraceBackA = {}

------------------------------------------------------------------------
-- ShowResultsA: A place where the generated module file is written to
--               when forming a show and computing a sha1sum
------------------------------------------------------------------------
ShowResultsA = {}

------------------------------------------------------------------------
-- colorize:  It is a colorizer when connected to a term and plain when not
------------------------------------------------------------------------

LMOD_COLORIZE = initialize("LMOD_COLORIZE","@colorize@","yes",
                           {yes = true, no = true, force = true})



LMOD_LEGACY_VERSION_ORDERING = initialize("LMOD_LEGACY_VERSION_ORDERING",
                                          "@legacy_ordering@","no")

------------------------------------------------------------------------
-- LMOD_TCLSH:   path to tclsh
------------------------------------------------------------------------

LMOD_TCLSH = "@tclsh@"
if (LMOD_TCLSH:sub(1,1) == "@") then
   LMOD_TCLSH = "tclsh"
end

------------------------------------------------------------------------
-- LMOD_LD_LIBRARY_PATH:   LD_LIBRARY_PATH found at configure
------------------------------------------------------------------------

LMOD_LD_LIBRARY_PATH = "@sys_ld_lib_path@"
if (LMOD_LD_LIBRARY_PATH:sub(1,1) == "@") then
   LMOD_LD_LIBRARY_PATH = getenv("LD_LIBRARY_PATH")
end
if (LMOD_LD_LIBRARY_PATH == "") then
   LMOD_LD_LIBRARY_PATH = nil
end

------------------------------------------------------------------------
-- LMOD_LD_PRELOAD:   LD_PRELOAD found at configure
------------------------------------------------------------------------

LMOD_LD_PRELOAD = "@sys_ld_preload@"
if (LMOD_LD_PRELOAD:sub(1,1) == "@") then
   LMOD_LD_PRELOAD = getenv("LD_PRELOAD")
end
if (LMOD_LD_PRELOAD == "") then
   LMOD_LD_PRELOAD = nil
end

------------------------------------------------------------------------
-- parseVersion:   generate a parsable version string from version
------------------------------------------------------------------------
parseVersion  = false


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
-- USE_DOT_FILES: Use ~/.lmod.d/.cache or ~/.lmod.d/__cache__
------------------------------------------------------------------------

USE_DOT_FILES = "@use_dot_files@"

------------------------------------------------------------------------
-- usrCacheDir: user cache directory
------------------------------------------------------------------------
USER_CACHE_DIR_NAME  = ".cache"
USER_SAVE_DIR_NAME   = ".save"
if ( USE_DOT_FILES:lower() == "no" ) then
  USER_CACHE_DIR_NAME  = "__cache__"
  USER_SAVE_DIR_NAME   = "__save__"
  USER_SBATCH_DIR_NAME = "__saveBatch__"
end
usrCacheDir   = pathJoin(getenv("HOME"),".lmod.d",USER_CACHE_DIR_NAME)
usrSaveDir    = pathJoin(getenv("HOME"),".lmod.d",USER_SAVE_DIR_NAME)

------------------------------------------------------------------------
-- updateSystemFn: The system file that is touched everytime the system
--                 is updated.
------------------------------------------------------------------------

updateSystemFn="@updateSystemFn@"

------------------------------------------------------------------------
-- Prepend path block order.
LMOD_PREPEND_BLOCK  = initialize("LMOD_PREPEND_BLOCK","@prepend_block@",
                                 "normal")


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

------------------------------------------------------------------------
-- allow dups function: allow for duplicate entries in PATH like vars.
------------------------------------------------------------------------
allow_dups      = false

------------------------------------------------------------------------
-- prepend_order function: specify the order when prepending paths.
------------------------------------------------------------------------
prepend_order   = false

------------------------------------------------------------------------
-- When building the reverseMapT use the preloaded modules
------------------------------------------------------------------------
Use_Preload     = false


PkgBase = false
PkgLmod = false
