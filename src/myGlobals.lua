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
--  Copyright (C) 2008-2016 Robert McLay
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

require("declare")
require("fileOps")

_G._DEBUG          = false               -- Required by the new lua posix
local cosmic       = require("Cosmic"):singleton()
local posix        = require("posix")
local getenv       = os.getenv
local setenv_posix = posix.setenv

local function initialize(lmod_name, sed_name, defaultV)
   defaultV    = (defaultV or "no"):lower()
   local value = (getenv(lmod_name) or sed_name):lower()
   if (value:sub(1,1) == "@") then
      value = defaultV
   end
   return value
end

if (isNotDefined("cmdDir")) then
   _G.cmdDir = function() return pathJoin(getenv("PROJDIR"),"src") end
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
-- LMODdir:     The directory where the cache file, default files
--              and module table state files go.
------------------------------------------------------------------------

LMODdir     = ".lmod.d"

------------------------------------------------------------------------
-- LMOD_CACHE_VERSION:    The current version for the Cache file
------------------------------------------------------------------------

LMOD_CACHE_VERSION   = 5

------------------------------------------------------------------------
-- LUAC_PATH : The path to luac
------------------------------------------------------------------------

LUAC_PATH = "@path_to_luac@"

------------------------------------------------------------------------
-- LMOD_CASE_INDEPENDENT_SORTING :  make avail and spider use case
--                                  independent sorting.
------------------------------------------------------------------------

cosmic:init{name = "LMOD_CASE_INDEPENDENT_SORTING",
            sedV = "@case_independent_sorting@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_REDIRECT:  Send messages to stdout instead of stderr
------------------------------------------------------------------------
cosmic:init{name = "LMOD_REDIRECT",
            sedV = "@redirect@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_SITE_NAME: The site name (e.g. TACC)
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_SITE_NAME",
            sedV    = "@site_name@",
            default = false}

------------------------------------------------------------------------
-- LMOD_SYSTEM_NAME:  When on a shared file system, use this to
--                    form the cache name and collection names.
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_SYSTEM_NAME",
            default = false}

------------------------------------------------------------------------
-- LMOD_COLUMN_TABLE_WIDTH: The width of the table when using ColumnTable
------------------------------------------------------------------------

LMOD_COLUMN_TABLE_WIDTH = 80

------------------------------------------------------------------------
-- LMOD_TMOD_PATH_RULE:  Using Tmod rule where if path is already there
--                       do not prepend/append
------------------------------------------------------------------------
cosmic:init{name = "LMOD_TMOD_PATH_RULE",
            sedV = "@tmod_path_rule@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_DISABLE_SAME_NAME_AUTOSWAP: This env. var requires users to swap
--                  out rather than using the one name rule.
------------------------------------------------------------------------
cosmic:init{name = "LMOD_DISABLE_SAME_NAME_AUTOSWAP",
            sedV = "@disable_name_autoswap@",
            yn   = "no"}

--------------------------------------------------------------------------
-- When restoring, use specified version instead of following the default
--------------------------------------------------------------------------
cosmic:init{name = "LMOD_PIN_VERSIONS",
            sedV = "@pin_versions@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_AUTO_SWAP:  Swap instead of Error when there is a family conflict
------------------------------------------------------------------------

cosmic:init{name = "LMOD_AUTO_SWAP",
            sedV = "@auto_swap@",
            yn   = "yes"}

------------------------------------------------------------------------
-- LMOD_EXACT_MATCH:  Require an exact match to load a module
--                    a.k.a no defaults
------------------------------------------------------------------------
cosmic:init{name = "LMOD_EXACT_MATCH",
            sedV = "@exact_match@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_AVAIL_MPATH:  Include MODULEPATH in avail search
------------------------------------------------------------------------
cosmic:init{name = "LMOD_MPATH_AVAIL",
            sedV = "@mpath_avail@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_ALLOW_TCL_MFILES:  Allow Lmod to read TCL based modules.
------------------------------------------------------------------------
cosmic:init{name = "LMOD_ALLOW_TCL_MFILES",
            sedV = "@allow_tcl_mfiles@",
            yn   = "yes"}

------------------------------------------------------------------------
-- LMOD_DUPLICATE_PATHS:  Allow the same path to be stored in PATH like
--                        vars like PATH, LD_LIBRARY_PATH, etc
------------------------------------------------------------------------

cosmic:init{name = "LMOD_DUPLICATE_PATHS",
            sedV = "@duplicate_paths@",
            yn   = "no"}


------------------------------------------------------------------------
-- LMOD_IGNORE_CACHE:  Ignore user and system caches and rebuild if needed
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_IGNORE_CACHE",
            default = false}

------------------------------------------------------------------------
-- LMOD_CACHED_LOADS: Use spider cache on loads
------------------------------------------------------------------------
cosmic:init{name = "LMOD_CACHED_LOADS",
            sedV = "@cached_loads@",
            yn   = "no"}

local ignore_cache = cosmic:value("LMOD_IGNORE_CACHE")
local cached_loads = cosmic:value("LMOD_CACHED_LOADS")

cosmic:assign("LMOD_CACHED_LOADS",ignore_cache and "no" or cached_loads)

------------------------------------------------------------------------
-- LMOD_PAGER: Lmod will use this value of pager if set.
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_PAGER",
            sedV    = "@pager@",
            default = "less"}
cosmic:init{name    = "LMOD_PAGER_OPTS",
            default = "-XqMREF"}

local rc_dflt   = pathJoin(cmdDir(),"../../etc/rc")
local rc        = getenv("LMOD_MODULERCFILE") or getenv("MODULERCFILE") or rc_dflt
cosmic:init{name    = "LMOD_MODULERCFILE",
            default = rc_dflt,
            assignV = rc,
            kind    = "file"}

------------------------------------------------------------------------
-- LMOD_RTM_TESTING: If set then the author is testing Lmod
------------------------------------------------------------------------
LMOD_RTM_TESTING = getenv("LMOD_RTM_TESTING")

------------------------------------------------------------------------
-- LMOD_ADMIN_FILE: The Nag file.
------------------------------------------------------------------------
local lmod_nag_default = pathJoin(cmdDir(),"../../etc/admin.list")
local lmod_nag         = getenv("LMOD_ADMIN_FILE") or lmod_nag_default
cosmic:init{name    = "LMOD_ADMIN_FILE",
            default = lmod_nag_default,
            assignV = lmod_nag,
            kind    = "file"}

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
-- MCP, mcp:  Master Control Program objects.  These objects implement
--            the module functions: load, setenv, prepend_path, etc.
--            MCP is always positive.  That is, load is load, setenv is
--            setenv.  Where as mcp is dynamic.  It is positive on load
--            and the reverse on unload.
------------------------------------------------------------------------
MCP            = false
mcp            = false

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

colorize      = false

cosmic:init{name = "LMOD_COLORIZE", sedV = "@colorize@", default="yes"}

------------------------------------------------------------------------
-- pager:     pipe output through more when connectted to a term
------------------------------------------------------------------------
pager         = false


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
if ( USE_DOT_FILES:lower() == "no" ) then
  USER_CACHE_DIR_NAME  = "__cache__"
end
usrCacheDir   = pathJoin(getenv("HOME"),".lmod.d",USER_CACHE_DIR_NAME)

------------------------------------------------------------------------
-- updateSystemFn: The system file that is touched everytime the system
--                 is updated.
------------------------------------------------------------------------

updateSystemFn="@updateSystemFn@"

------------------------------------------------------------------------
-- Prepend path block order.
------------------------------------------------------------------------
LMOD_PREPEND_BLOCK  = initialize("LMOD_PREPEND_BLOCK","@prepend_block@",
                                 "normal")

------------------------------------------------------------------------
-- LMOD_MAXDEPTH: directory and max depth in terms of categories.
--                This is a per directory specification that can be
--                overridden by a .version etc file.
------------------------------------------------------------------------
LMOD_MAXDEPTH = initialize("LMOD_MAXDEPTH","@maxdepth@","")

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

prtHdr          = false
ModuleName      = false
ModuleFn        = false
FullName        = false

------------------------------------------------------------------------
-- Shell Object: Bash, Csh, etc
------------------------------------------------------------------------

Shell          = false

------------------------------------------------------------------------
-- master: 
------------------------------------------------------------------------

master         = false



PkgBase = false
PkgLmod = false
