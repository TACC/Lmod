--------------------------------------------------------------------------
-- Report how a site has configured Lmod.
-- @classmod Configuration

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


require("capture")
require("fileOps")
require("haveTermSupport")
require("pairsByKeys")
require("serializeTbl")
require("utils")
require("string_utils")
require("colorize")
local BeautifulTbl = require('BeautifulTbl')
local ReadLmodRC   = require('ReadLmodRC')
local Version      = require("Version")
local json         = require("json")
local concatTbl    = table.concat
local dbg          = require('Dbg'):dbg()
local getenv       = os.getenv
local M            = {}

s_configuration   = false

local function locatePkg(pkg)
   local result = nil
   for path in package.path:split(";") do
      local s = path:gsub("?",pkg)
      local f = io.open(s,"r")
      if (f) then
         f:close()
         result = s
         break;
      end
   end
   return result
end


local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   local locSitePkg = locatePkg("SitePackage") or "unknown"

   if (locSitePkg ~= "unknown") then
      local std_sha1 = "28b49546421d7e01995af8053dba18623cf12f51"
      local std_md5  = "4eddeb60631cfa8d08e8f08e496fdb88"
      local HashSum  = "@path_to_hashsum@"
      if (HashSum:sub(1,1) == "@") then
         HashSum = findInPath("sha1sum")
      end

      local std_hashsum = (HashSum:find("md5") ~= nil) and std_md5 or std_sha1

      if (HashSum == nil) then
         LmodError("Unable to find HashSum program (sha1sum, md5sum or md5)")
      end

      local result = capture(HashSum .. " " .. locSitePkg)
      result       = result:gsub(" .*","")
      if (result == std_hashsum) then
         locSitePkg = "standard"
      end
   end

   local lmod_version = Version.git()
   if (lmod_version == "") then
      lmod_version = Version.tag()
   else
      lmod_version = lmod_version:gsub("[)(]","")
   end
   local readLmodRC        = ReadLmodRC:singleton()
   local settarg_support   = "@lmod_full_settarg_support@"
   local pkgName           = Pkg.name() or "unknown"
   local lmod_colorize     = getenv("LMOD_COLORIZE") or "@colorize@"
   local scDescriptT       = readLmodRC:scDescriptT()
   local numSC             = #scDescriptT
   local uname             = capture("uname -a")
   local adminFn, readable = findAdminFn()
   local activeTerm        = haveTermSupport() and "true" or colorize("red","false")
   local case_ind_sorting  = LMOD_CASE_INDEPENDENT_SORTING
   local disable1N         = LMOD_DISABLE_SAME_NAME_AUTOSWAP
   local tmod_rule         = LMOD_TMOD_PATH_RULE
   local exactMatch        = LMOD_EXACT_MATCH
   local ordering          = (LMOD_LEGACY_VERSION_ORDERING == "yes") and "legacy" or "modern"
   local cached_loads      = LMOD_CACHED_LOADS
   local ignore_cache      = LMOD_IGNORE_CACHE and "yes" or "no"
   local redirect          = LMOD_REDIRECT
   local checkValid        = LMOD_CHECK_FOR_VALID_MODULE_FILES
   local ld_preload        = LMOD_LD_PRELOAD      or "<empty>"
   local ld_lib_path       = LMOD_LD_LIBRARY_PATH or "<empty>"

   local tbl = {}
   tbl.allowTCL    = { k = "Allow TCL modulefiles"             , v = LMOD_ALLOW_TCL_MFILES,}
   tbl.autoSwap    = { k = "Auto swapping"                     , v = LMOD_AUTO_SWAP,       }
   tbl.case        = { k = "Case Independent Sorting"          , v = case_ind_sorting,     }
   tbl.colorize    = { k = "Colorize Lmod"                     , v = lmod_colorize,        }
   tbl.disable1N   = { k = "Disable Same Name AutoSwap"        , v = disable1N,            }
   tbl.dot_files   = { k = "Using dotfiles"                    , v = "@use_dot_files@",    }
   tbl.dupPaths    = { k = "Allow duplicate paths"             , v = LMOD_DUPLICATE_PATHS, }
   tbl.exactMatch  = { k = "Require Exact Match/no defaults"   , v = exactMatch,           }
   tbl.expMCmd     = { k = "Export the module command"         , v = "@export_module@",    }
   tbl.ld_preload  = { k = "LD_PRELOAD at config time"         , v = ld_preload,           }
   tbl.ld_lib_path = { k = "LD_LIBRARY_PATH at config time"    , v = ld_lib_path,          }
   tbl.lmodV       = { k = "Lmod version"                      , v = lmod_version,         }
   tbl.luaV        = { k = "Lua Version"                       , v = _VERSION,             }
   tbl.lua_json    = { k = "System lua_json"                   , v = "@have_lua_json@",    }
   tbl.lua_term    = { k = "System lua-term"                   , v = "@have_lua_term@",    }
   tbl.lua_term_A  = { k = "Active lua-term"                   , v = activeTerm,           }
   tbl.mpath_av    = { k = "avail: Include modulepath dir"     , v = LMOD_MPATH_AVAIL,     }
   tbl.mpath_root  = { k = "MODULEPATH_ROOT"                   , v = "@modulepath_root@",  }
   tbl.modRC       = { k = "MODULERCFILE"                      , v = MODULERCFILE,         }
   tbl.numSC       = { k = "number of cache dirs"              , v = numSC,                }
   tbl.ordering    = { k = "Version ordering"                  , v = ordering,             }
   tbl.pager       = { k = "Pager"                             , v = LMOD_PAGER,           }
   tbl.pager_opts  = { k = "Pager Options"                     , v = LMOD_PAGER_OPTS,      }
   tbl.path_hash   = { k = "Path to HashSum"                   , v = "@path_to_hashsum@",  }
   tbl.path_lua    = { k = "Path to Lua"                       , v = "@path_to_lua@",      }
   tbl.pin_v       = { k = "Pin Versions in restore"           , v = LMOD_PIN_VERSIONS,    }
   tbl.pkg         = { k = "Pkg Class name"                    , v = pkgName,              }
   tbl.prefix      = { k = "Lmod prefix"                       , v = "@PREFIX@",           }
   tbl.prpnd_blk   = { k = "Prepend order"                     , v = "@prepend_block@",    }
   tbl.settarg     = { k = "Supporting Full Settarg Use"       , v = settarg_support,      }
   tbl.sitePkg     = { k = "Site Pkg location"                 , v = locSitePkg,           }
   tbl.spdr_ignore = { k = "Ignore Cache"                      , v = ignore_cache,         }
   tbl.spdr_loads  = { k = "Cached loads"                      , v = cached_loads,         }
   tbl.tm_ancient  = { k = "User cache valid time(sec)"        , v = "@ancient@",          }
   tbl.tm_short    = { k = "Write cache after (sec)"           , v = "@short_time@",       }
   tbl.tm_threshold= { k = "Threshold (sec)"                   , v = Threshold,            }
   tbl.tmod_rule   = { k = "Tmod prepend PATH Rule"            , v = tmod_rule,            }
   tbl.uname       = { k = "uname -a"                          , v = uname,                }
   tbl.z01_admin   = { k = "Admin file"                        , v = adminFn,              }
   tbl.z02_admin   = { k = "Does Admin file exist"             , v = tostring(readable),   }
   tbl.redirect    = { k = "Redirect to stdout"                , v = redirect,             }
   tbl.z03_cv      = { k = "Check TCL modules for magic string", v = checkValid,           }

   o.tbl = tbl
   return o
end

--------------------------------------------------------------------------
-- A Configuration Singleton Ctor.
-- @param self A Configuration object.
-- @return A Configuration Singleton.
function M.configuration(self)
   if (not s_configuration) then
      s_configuration = new(self)
   end
   return s_configuration
end

--------------------------------------------------------------------------
-- Report the current configuration.
-- @param self A Configuration object
-- @return the configuration report as a single string.
function M.report(self)
   local readLmodRC = ReadLmodRC:singleton()
   local a          = {}
   local tbl        = self.tbl
   a[#a+1]          = {"Description", "Value", }
   a[#a+1]          = {"-----------", "-----", }

   for _, v in pairsByKeys(tbl) do
      a[#a+1] = {v.k, v.v }
   end

   local b = {}
   local bt = BeautifulTbl:new{tbl=a}
   b[#b+1]  = bt:build_tbl()
   b[#b+1]  = "\n"

   local rcFileA = readLmodRC:rcFileA()
   if (#rcFileA) then
      b[#b+1] = "Active RC file(s):"
      b[#b+1] = "------------------"
      for i = 1, #rcFileA do
         b[#b+1] = rcFileA[i]
      end
      b[#b+1]  = "\n"
   end


   local scDescriptT = readLmodRC:scDescriptT()
   if (#scDescriptT > 0) then
      a = {}
      a[#a+1]   = {"Cache Directory",  "Time Stamp File",}
      a[#a+1]   = {"---------------",  "---------------",}
      for i = 1, #scDescriptT do
         a[#a+1] = { scDescriptT[i].dir, scDescriptT[i].timestamp}
      end
      bt = BeautifulTbl:new{tbl=a}
      b[#b+1]  = bt:build_tbl()
      b[#b+1]  = "\n"
   end

   local border = banner:border(2)
   local str    = " Lmod Property Table:"
   b[#b+1]  = border
   b[#b+1]  = str
   b[#b+1]  = border
   b[#b+1]  = "\n"
   b[#b+1]  = serializeTbl{ indent = true, name="propT", value = readLmodRC:propT() }
   b[#b+1]  = "\n"

   return concatTbl(b,"\n")
end

-- Report the current configuration in json format.
-- It can have 3 keys:
-- - 'config': the Lmod configuration
-- - 'cache': list of caches
-- - 'rcfiles': list of all active rcfiles
-- - 'propt': the current propT table
-- @param self A Configuration object
-- @return the configuration report in json as a single string.
function M.report_json(self)
   local tbl = self.tbl
   local cfg = {}

   for k, v in pairs(tbl) do
       cfg[k] = v.v
   end

   local res = {}
   res.config = cfg

   local readLmodRC = ReadLmodRC:singleton()
   local rcFileA = readLmodRC:rcFileA()
   if (#rcFileA) then
       local a = {}
       for i = 1, #rcFileA do
           a[#a+1] = rcFileA[i]
       end
       res.rcfiles = a
   end

   local scDescriptT = readLmodRC:scDescriptT()
   if (#scDescriptT > 0) then
       local a = {}
       for i = 1, #scDescriptT do
           a[#a+1] = {scDescriptT[i].dir, scDescriptT[i].timestamp}
       end
       res.cache = a
   end

   res.propt = readLmodRC:propT()

   return json.encode(res)
end

return M
