--------------------------------------------------------------------------
-- Fixme
-- @module myGlobals

_G._DEBUG          = false               -- Required by the new lua posix
local posix        = require("posix")
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
--  Copyright (C) 2008-2018 Robert McLay
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

local Version      = require("Version")
local cosmic       = require("Cosmic"):singleton()
local lfs          = require("lfs")
local getenv       = os.getenv
local access       = posix.access
local setenv_posix = posix.setenv

if (isNotDefined("cmdDir")) then
   _G.cmdDir = function() return pathJoin(getenv("PROJDIR"),"src") end
end

------------------------------------------------------------------------
-- The global variables for Lmod:
------------------------------------------------------------------------

LuaV = (_VERSION:gsub("Lua ",""))

------------------------------------------------------------------------
-- Lmod branch
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_BRANCH",
            default = "main",
            assignV = Version.branch()}
            

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
-- LMOD_MODULEPATH_INIT: Name of the file that can be used to initialize
--                       MODULEPATH in the startup scripts
------------------------------------------------------------------------
local mpath_init = getenv("LMOD_MODULEPATH_INIT")
local default_mpath_init = "@PKG@/init/.modulespath"
local global_mpath_init  = "/etc/lmod/.modulespath"
if (not mpath_init) then
   if (access(global_mpath_init, "r")) then
      mpath_init = global_mpath_init
   else
      mpath_init = "@modulepath_init@"
      if (mpath_init:sub(1,1) == "@") then
         mpath_init = default_mpath_init
      end
   end
   
end

cosmic:init{name    = "LMOD_MODULEPATH_INIT",
            sedV    = "@modulepath_init@",
            default = default_mpath_init,
            assignV = mpath_init}

------------------------------------------------------------------------
-- SITE_CONTROLLED_PREFIX: If a site configured lmod with direct prefix
------------------------------------------------------------------------
cosmic:init{name    = "SITE_CONTROLLED_PREFIX",
            sedV    = "@site_controlled_prefix@",
            no_env  = true,
            default = "no"}

------------------------------------------------------------------------
-- LMOD_USE_DOT_CONFIG_ONLY: only write to ~/.config/lmod for collections
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_USE_DOT_CONFIG_ONLY",
            sedV    = "@lmod_use_dot_config_only@",
            default = "no"}

------------------------------------------------------------------------
-- ModulePath: The name of the environment variable which contains the
--             directories that contain modulefiles.
------------------------------------------------------------------------

ModulePath  = "MODULEPATH"

------------------------------------------------------------------------
-- LMOD_CACHE_VERSION:    The current version for the Cache file
------------------------------------------------------------------------

LMOD_CACHE_VERSION   = 5

------------------------------------------------------------------------
-- LUAC_PATH : The path to luac
------------------------------------------------------------------------

LUAC_PATH = "@path_to_luac@"

------------------------------------------------------------------------
-- LUA_TRACING : Tracing Lmod loads and other changes.
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_TRACING",
            yn      = "no"}


------------------------------------------------------------------------
-- LMOD_DYNAMIC_SPIDER_CACHE :  Support for Dynamic Spider Caches
------------------------------------------------------------------------

cosmic:init{name = "LMOD_DYNAMIC_SPIDER_CACHE",
            sedV = "@dynamic_spider_cache@",
            yn   = "yes"}

------------------------------------------------------------------------
-- LMOD_CASE_INDEPENDENT_SORTING :  make avail and spider use case
--                                  independent sorting.
------------------------------------------------------------------------

cosmic:init{name = "LMOD_CASE_INDEPENDENT_SORTING",
            sedV = "@case_independent_sorting@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_KSH_SUPPORT :  Set FPATH to support KSH users and scripts
------------------------------------------------------------------------

cosmic:init{name = "LMOD_KSH_SUPPORT",
            sedV = "@support_ksh@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_REDIRECT:  Send messages to stdout instead of stderr
------------------------------------------------------------------------
cosmic:init{name = "LMOD_REDIRECT",
            sedV = "@redirect@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_DOWNSTREAM_CONFLICTS:  Module confiicts are remember for later
--                            module loads
--                            Note: this variable can only be set
--                            at config time or via cosmic:assign() at
--                            startup
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_DOWNSTREAM_CONFLICTS",
            sedV    = "@lmod_downstream_conflicts@",
            default = "no",
            assignV = "no"}
------------------------------------------------------------------------
-- LMOD_RC:  Lmod RC list of colon separated files 
------------------------------------------------------------------------
local rcfiles = getenv("LMOD_RC")
cosmic:init{name    = "LMOD_RC",
            default = "",
            envV    = rcfiles,
            assignV = rcfiles}

------------------------------------------------------------------------
-- LMOD_FAST_TCL_INTERP:  Build and use the tcl library as part of Lmod
------------------------------------------------------------------------
cosmic:init{name = "LMOD_FAST_TCL_INTERP",
            sedV = "@fast_tcl_interp@",
            yn   = "yes"}

------------------------------------------------------------------------
-- LMOD_USING_FAST_TCL_INTERP:  Is the fast TCL interp active
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_USING_FAST_TCL_INTERP",
            yn      = "yes",
            default = "yes"}

------------------------------------------------------------------------
-- LMOD_SITEPACKAGE_LOCATION:  SitePackage.lua location
------------------------------------------------------------------------
local sitePkgLoc = "@LMOD_TOP_DIR@/libexec/SitePackage.lua"
if (sitePkgLoc:sub(1,1) == "@") then
   sitePkgLoc = "<srctree>"
end


cosmic:init{name    = "LMOD_SITEPACKAGE_LOCATION",
            default = sitePkgLoc}


------------------------------------------------------------------------
-- LMOD_CFG:  lmod_config.lua location
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_CONFIG_LOCATION",
            default = "no"}

------------------------------------------------------------------------
-- LMOD_SITE_NAME: The site name (e.g. TACC)
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_SITE_NAME",
            sedV    = "@site_name@",
            default = false}

------------------------------------------------------------------------
-- LMOD_CONFIG_DIR: The location of the Lmod config dir
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_CONFIG_DIR",
            sedV    = "@lmod_config_dir@",
            default = "/etc/lmod"}

------------------------------------------------------------------------
-- LMOD_PACKAGE_PATH: Colon separated list of directories to search for
--                    SitePackage.lua
------------------------------------------------------------------------
cosmic:assign("LMOD_PACKAGE_PATH",getenv("LMOD_PACKAGE_PATH") or "")

------------------------------------------------------------------------
-- LMOD_SYSHOST: The cluster name: (e.g. stampede)
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_SYSHOST",
            sedV    = "@syshost@",
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
-- LMOD_TMOD_FIND_FIRST:  Using Tmod rule where it uses find first for
---                       defaults.
------------------------------------------------------------------------
cosmic:init{name = "LMOD_TMOD_FIND_FIRST",
            sedV = "@tmod_find_first@",
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
-- LMOD_AVAIL_EXTENSIONS:  Display extensions with "module avail"
------------------------------------------------------------------------

cosmic:init{name = "LMOD_AVAIL_EXTENSIONS",
            sedV = "@avail_extensions@",
            yn   = "yes"}

------------------------------------------------------------------------
-- LMOD_EXACT_MATCH:  Require an exact match to load a module
--                    a.k.a no defaults
------------------------------------------------------------------------
cosmic:init{name = "LMOD_EXACT_MATCH",
            sedV = "@exact_match@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_EXPORT_MODULE:  Should the module command be exported to Bash
------------------------------------------------------------------------
cosmic:init{name = "LMOD_EXPORT_MODULE",
            sedV = "@export_module@",
            yn   = "yes"}

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
-- LMOD_TMOD_PATH_RULE:  Using Tmod rule where if path is already there
--                       do not prepend/append
------------------------------------------------------------------------
cosmic:init{name = "LMOD_TMOD_PATH_RULE",
            sedV = "@tmod_path_rule@",
            yn   = "no"}

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
cosmic:init{name = "LMOD_IGNORE_CACHE",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_CACHED_LOADS: Use spider cache on loads
------------------------------------------------------------------------
cosmic:init{name = "LMOD_CACHED_LOADS",
            sedV = "@cached_loads@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_PAGER: Lmod will use this value of pager if set.
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_PAGER",
            sedV    = "@pager@",
            default = "less"}

cosmic:init{name    = "LMOD_PAGER_OPTS",
            default = "-XqMREF"}

------------------------------------------------------------------------
-- LMOD_SYSTEM_DEFAULT_MODULES: 
------------------------------------------------------------------------
local defaultModules = getenv("LMOD_SYSTEM_DEFAULT_MODULES")

cosmic:init{name    = "LMOD_SYSTEM_DEFAULT_MODULES",
            envV    = defaultModules,
            assignV = defaultModules or "",
            default = "__unknown__" }


------------------------------------------------------------------------
-- LMOD_MODULERCFILE: The system RC file to specify aliases, defaults
--                    and hidden modules.
------------------------------------------------------------------------
local pkgRootDir = getenv("LMOD_ROOT") or pathJoin(cmdDir(), "../..")
local etcDir     = pathJoin(pkgRootDir,"etc")
local rc_dflt    = pathJoin(etcDir,"rc.lua")

if (not isFile(rc_dflt)) then
   rc_dflt   = pathJoin(etcDir,"rc")
end
local rc        = getenv("LMOD_MODULERC") or 
                  getenv("LMOD_MODULERCFILE") or
                  getenv("MODULERCFILE")
cosmic:init{name    = "LMOD_MODULERC",
            default = rc_dflt,
            envV    = rc,
            assignV = rc,
            kind    = "file"}


------------------------------------------------------------------------
-- LMOD_EXTENDED_DEFAULT: Allow for partial version matches like
--                        ml intel/17 pick the best intel 17.*
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_EXTENDED_DEFAULT",
            sedV    = "@extended_default@",
            yn      = "yes"}

------------------------------------------------------------------------
-- LMOD_QUARANTINE_VARS: A colon separated list of variable
--                       that Lmod will not change.  Note
--                       path like variables are excluded.
------------------------------------------------------------------------


LMOD_QUARANTINE_VARS = getenv("LMOD_QUARANTINE_VARS")

------------------------------------------------------------------------
-- LMOD_RTM_TESTING: If set then the author is testing Lmod
------------------------------------------------------------------------
LMOD_RTM_TESTING = getenv("LMOD_RTM_TESTING")

------------------------------------------------------------------------
-- LMOD_ADMIN_FILE: The Nag file.
------------------------------------------------------------------------
local lmod_nag_default = pathJoin(etcDir,"admin.list")
local lmod_nag         = getenv("LMOD_ADMIN_FILE")
cosmic:init{name    = "LMOD_ADMIN_FILE",
            default = lmod_nag_default,
            envV    = lmod_nag,
            assignV = lmod_nag}

------------------------------------------------------------------------
-- LMOD_AVAIL_STYLE: Used by the avail hook to control how avail output
--                   is handled.   This is a colon separated list of
--                   names.  Note that the default choice is marked by
--                   angle brackets:  A:B:<C> ==> C is the default.
--                   If no angle brackets are specified then the first
--                   entry is the default (i.e. A:B:C => A is default).
------------------------------------------------------------------------

local style = getenv("LMOD_AVAIL_STYLE")
cosmic:init{name    = "LMOD_AVAIL_STYLE",
            default = "<system>",
            envV    = style,
            assignV = style}

------------------------------------------------------------------------
-- LFS_VERSION: The version of luafilesystem being used
------------------------------------------------------------------------

cosmic:init{name    = "LFS_VERSION",
            default = "1.6.3",
            kind    = "D",
            assignV = lfs._VERSION:gsub("LuaFileSystem  *","")}

------------------------------------------------------------------------
--  ModA:  A global array used to collect from .modulerc etc files
------------------------------------------------------------------------
--
--ModA           = false
--

------------------------------------------------------------------------
-- MCP, mcp:  MainControl Program objects.  These objects implement
--            the module functions: load, setenv, prepend_path, etc.
--            MCP is always positive.  That is, load is load, setenv is
--            setenv.  Where as mcp is dynamic.  It is positive on load
--            and the reverse on unload.
------------------------------------------------------------------------
MCP            = false
mcp            = false

------------------------------------------------------------------------
-- adminA:  An array that contains module names and a message to users
--          The main purpose is to tell users that say this module is
--          deprecated.
------------------------------------------------------------------------

adminA         = {}

------------------------------------------------------------------------
-- stackTraceBackA
------------------------------------------------------------------------
stackTraceBackA = {}

------------------------------------------------------------------------
-- ShowResultsA: A place where the generated module file is written to
--               when forming a show and computing a sha1sum and
--               collecting syntax errors
------------------------------------------------------------------------
ShowResultsA = {}

------------------------------------------------------------------------
-- colorize:  It is a colorizer when connected to a term and plain when not
------------------------------------------------------------------------

colorize      = false

cosmic:init{name    = "LMOD_COLORIZE",
            sedV    = "@colorize@",
            lower   = true,
            default = "yes"}

------------------------------------------------------------------------
-- pager:     pipe output through more when connectted to a term
------------------------------------------------------------------------
pager         = false

------------------------------------------------------------------------
-- LMOD_TCLSH:   path to tclsh
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_TCLSH",
            sedV    = "@tclsh@",
            default = "tclsh"}

------------------------------------------------------------------------
-- LMOD_LD_LIBRARY_PATH:   LD_LIBRARY_PATH found at configure
------------------------------------------------------------------------

local ld_lib_path = "@sys_ld_lib_path@"
if (ld_lib_path:sub(1,1) == "@") then
   ld_lib_path = getenv("LD_LIBRARY_PATH")
end
if (ld_lib_path == "") then
   ld_lib_path = false
end

cosmic:init{name    = "LMOD_LD_LIBRARY_PATH",
            default = false,
            envV    = ld_lib_path,
            assignV = ld_lib_path}

------------------------------------------------------------------------
-- LMOD_LD_PRELOAD:   LD_PRELOAD found at configure
------------------------------------------------------------------------

local ld_preload = "@sys_ld_preload@"
if (ld_preload:sub(1,1) == "@") then
   ld_preload = getenv("LD_PRELOAD")
end
if (ld_preload == "") then
   ld_preload = nil
end

cosmic:init{name    = "LMOD_LD_PRELOAD",
            default = false,
            envV    = ld_preload,
            assignV = ld_preload}

------------------------------------------------------------------------
-- parseVersion:   generate a parsable version string from version
------------------------------------------------------------------------
parseVersion  = false


------------------------------------------------------------------------
-- s_warning:   if a warning was generated during the current run
------------------------------------------------------------------------
s_warning     = false

------------------------------------------------------------------------
-- s_status:   When set return a non-zero status
------------------------------------------------------------------------
s_status      = false

------------------------------------------------------------------------
-- s_haveWarnings:  if warning are allowed (or ignored).  For example
--                  a try-load command turns off warnings.
------------------------------------------------------------------------
s_haveWarnings = true

------------------------------------------------------------------------
-- LMOD_SITE_MSG_FILE: points to a file with site messages
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_SITE_MSG_FILE",
            sedV    = "@site_msg_file@",
            default = false}

------------------------------------------------------------------------
-- LMOD_LANG: points to a file with site messages
------------------------------------------------------------------------

cosmic:init{name    = "LMOD_OVERRIDE_LANG",
            sedV    = "@lang@",
            default = false}

local langEnv = getenv("LMOD_LANG") or getenv("LANG")
if (langEnv) then
   langEnv = langEnv:gsub("_.*","")
end

local lang = cosmic:value("LMOD_OVERRIDE_LANG") or langEnv

cosmic:init{name    = "LMOD_LANG",
            default = "en",
            sedV    = "@lang@",
            envV    = langEnv,
            assignV = lang}

------------------------------------------------------------------------
-- LMOD_SETTARG_FULL_SUPPORT: remember the settarg support level to
--                            report value in the configuration report.
------------------------------------------------------------------------

cosmic:init{name = "LMOD_SETTARG_FULL_SUPPORT",
            sedV = "@lmod_settarg_full_support@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_ANCIENT_TIME:  the time in seconds when the cache file is considered old
------------------------------------------------------------------------
local ancient_dflt  = 86400
local ancientEnv    = getenv("LMOD_ANCIENT_TIME")
local ancientSedV   = "@ancient@"
local ancient       = tonumber(ancientEnv) or tonumber(ancientSedV)
cosmic:init{name    = "LMOD_ANCIENT_TIME",
            default = ancient_dflt,
            envV    = ancientEnv,
            sedV    = ancientSedV,
            assignV = ancient}
ancient = cosmic:value("LMOD_ANCIENT_TIME")
------------------------------------------------------------------------
-- shortLifeCache: If building the cache file is fast then shorten the
--                 ancient to this time.
------------------------------------------------------------------------
shortLifeCache = ancient/12

------------------------------------------------------------------------
-- LMOD_SHORT_TIME: the time in seconds when building the cache file is quick
--                  enough to be computed every time rather than cached.
------------------------------------------------------------------------

local shortTime_dflt = 2
local shortTimeEnv   = getenv("LMOD_SHORT_TIME")
local shortTimeSedV  = "@short_time@"
local shortTime      = tonumber(shortTimeEnv) or tonumber(shortTimeSedV)
cosmic:init{name     = "LMOD_SHORT_TIME",
            default  = shortTime_dflt,
            envV     = shortTimeEnv,
            sedV     = shortTimeSedV,
            assignV  = shortTime}



------------------------------------------------------------------------
-- Threshold:  The amount of time to wait before printing the cache
--             rebuild message.  (It has to be 1 second or greater).
------------------------------------------------------------------------
local threshold_dflt = 1
local thresholdEnv   = getenv("LMOD_THRESHOLD")
local threshold      = tonumber(thresholdEnv)
cosmic:init{name     = "LMOD_THRESHOLD",
            default  = threshold_dflt,
            envV     = thresholdEnv,
            assignV  = threshold}


------------------------------------------------------------------------
-- LMOD_ALLOW_ROOT_USE
------------------------------------------------------------------------
cosmic:init{name = "LMOD_ALLOW_ROOT_USE",
            sedV = "@lmod_allow_root_use@",
            yn   = "yes"}

------------------------------------------------------------------------
-- LMOD_HAVE_LUA_TERM
------------------------------------------------------------------------
cosmic:init{name = "LMOD_HAVE_LUA_TERM",
            sedV = "@have_lua_term@",
            yn   = "no"}



------------------------------------------------------------------------
-- MODULEPATH_ROOT
------------------------------------------------------------------------
cosmic:init{name    = "MODULEPATH_ROOT",
            sedV    = "@modulepath_root@",
            default = ""}

------------------------------------------------------------------------
-- LMOD_HASHSUM_PATH
------------------------------------------------------------------------
local HashSum      = "@hashsum@"
local found        = false
if (HashSum:sub(1,1) == "@") then
   local a = { "gsha1sum", "sha1sum", "shasum", "md5sum", "md5" }
   for i = 1,#a do
      HashSum, found = findInPath(a[i])
      if (found) then break end
   end
   if (not found) then
      HashSum = nil
   end
end

cosmic:init{name    = "LMOD_HASHSUM_PATH",
            sedV    = "@hashsum@",
            default = HashSum}

------------------------------------------------------------------------
-- MODULES_AUTO_HANDLING: If true the make prereq -> depends_on
--                        prereq_any -> depends_on_any
------------------------------------------------------------------------

cosmic:init{name    = "MODULES_AUTO_HANDLING",
            sedV    = "@modules_auto_handling@",
            default = "no"}

------------------------------------------------------------------------
-- PATH_TO_LUA
------------------------------------------------------------------------
cosmic:init{name    = "PATH_TO_LUA",
            sedV    = "@path_to_lua@",
            default = "lua"}

------------------------------------------------------------------------
-- usrCacheDir: user cache directory
------------------------------------------------------------------------
usrCacheDir          = pathJoin(getenv("HOME"),".cache/lmod")

------------------------------------------------------------------------
-- updateSystemFn: The system file that is touched everytime the system
--                 is updated.
------------------------------------------------------------------------

updateSystemFn="@updateSystemFn@"

------------------------------------------------------------------------
-- Prepend path block order.
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_PREPEND_BLOCK",
            sedV    = "@prepend_block@",
            lower   = true,
            default = "normal"}

------------------------------------------------------------------------
-- LMOD_MAXDEPTH: directory and max depth in terms of categories.
--                This is a per directory specification that can be
--                overridden by a .version etc file.
------------------------------------------------------------------------
cosmic:init{name    = "LMOD_MAXDEPTH",
            sedV    = "@maxdepth@",
            default = ""}

------------------------------------------------------------------------
-- LMOD_HIDDEN_ITALIC - Use italic instead of DIM for hidden modules
------------------------------------------------------------------------
cosmic:init{name = "LMOD_HIDDEN_ITALIC",
            sedV = "@LMOD_HIDDEN_ITALIC@",
            yn   = "no"}

------------------------------------------------------------------------
-- LMOD_FILE_IGNORE_PATTERNS
-----------------------------------------------------------------------
local patternA = {"%.version[-._].*",  "%.modulerc[-._].*"}
cosmic:init{name    = "LMOD_FILE_IGNORE_PATTERNS",
            assignV = patternA,
            default = patternA}

------------------------------------------------------------------------
-- GIT_VERSION: The exact git version of Lmod
------------------------------------------------------------------------

GIT_VERSION = "@git_version@"

------------------------------------------------------------------------
-- epoch
------------------------------------------------------------------------
epoch      = false
epoch_type = false

------------------------------------------------------------------------
-- runTCLprog: a program to process TCL programs
------------------------------------------------------------------------
runTCLprog = false

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
-- hub:
------------------------------------------------------------------------

hub         = false

TraceCounter   = 0
ReloadAllCntr  = 0


PkgBase = false
PkgLmod = false
