--------------------------------------------------------------------------
-- Fix me
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
require("pairsByKeys")
require("serializeTbl")
require("utils")
require("string_utils")
require("colorize")
local BeautifulTbl = require('BeautifulTbl')
local Version      = require("Version")
local concatTbl    = table.concat
local dbg          = require('Dbg'):dbg()
local getenv       = os.getenv
local rep          = string.rep
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


      local std_sha1 = "038082232d235d9f9278975749eafe791a206a87"

      local HashSum = "@path_to_hashsum@"
      if (HashSum:sub(1,1) == "@") then
         HashSum = findInPath("sha1sum")
      end

      local result = capture(HashSum .. " " .. locSitePkg)
      result       = result:gsub(" .*","")
      if (result == std_sha1) then
         locSitePkg = "standard"
      end
   end

   local lmod_version = Version.git()
   if (lmod_version == "") then
      lmod_version = Version.tag()
   else
      lmod_version = lmod_version:gsub("[)(]","")
   end
   local settarg_support   = "@lmod_full_settarg_support@"
   local pkgName           = Pkg.name() or "unknown"
   local lmod_colorize     = getenv("LMOD_COLORIZE") or "@colorize@"
   local scDescriptT       = getSCDescriptT()
   local numSC             = #scDescriptT
   local uname             = capture("uname -a")
   local adminFn, readable = findAdminFn()
   local activeTerm        = haveTermSupport() and "true" or colorize("red","false")

   local tbl = {}
   tbl.prefix     = { k = "Lmod prefix"                   , v = "@PREFIX@",                    }
   tbl.dupPaths   = { k = "Allow duplicate paths"         , v = LMOD_DUPLICATE_PATHS,          }
   tbl.path_lua   = { k = "Path to Lua"                   , v = "@path_to_lua@",               }
   tbl.path_pager = { k = "Path to Pager"                 , v = "@path_to_pager@",             }
   tbl.path_hash  = { k = "Path to HashSum"               , v = "@path_to_hashsum@",           }
   tbl.settarg    = { k = "Supporting Full Settarg Use"   , v = settarg_support,               }
   tbl.dot_files  = { k = "Using dotfiles"                , v = "@use_dot_files@",             }
   tbl.numSC      = { k = "number of cache dirs"          , v = numSC,                         }
   tbl.lmodV      = { k = "Lmod version"                  , v = lmod_version,                  }
   tbl.ancient    = { k = "User cache valid time(sec)"    , v = "@ancient@",                   }
   tbl.short_tm   = { k = "Write cache after (sec)"       , v = "@short_time@",                }
   tbl.prpnd_blk  = { k = "Prepend order"                 , v = "@prepend_block@",             }
   tbl.colorize   = { k = "Colorize Lmod"                 , v = lmod_colorize,                 }
   tbl.allowTCL   = { k = "Allow TCL modulefiles"         , v = LMOD_ALLOW_TCL_MFILES,         }
   tbl.mpath_av   = { k = "avail: Include modulepath dir" , v = LMOD_MPATH_AVAIL,              }
   tbl.mpath_root = { k = "MODULEPATH_ROOT"               , v = "@modulepath_root@",           }
   tbl.pkg        = { k = "Pkg Class name"                , v = pkgName,                       }
   tbl.sitePkg    = { k = "Site Pkg location"             , v = locSitePkg,                    }
   tbl.lua_term   = { k = "System lua-term"               , v = "@have_lua_term@",             }
   tbl.lua_json   = { k = "System lua_json"               , v = "@have_lua_json@",             }
   tbl.lua_term_A = { k = "Active lua-term"               , v = activeTerm,                    }
   tbl.uname      = { k = "uname -a"                      , v = uname,                         }
   tbl.z01_admin  = { k = "Admin file"                    , v = adminFn,                       }
   tbl.z02_admin  = { k = "Does Admin file exist"         , v = tostring(readable),            }
   tbl.luaV       = { k = "Lua Version"                   , v = _VERSION,                      }
   tbl.case       = { k = "Case Independent Sorting"      , v = LMOD_CASE_INDEPENDENT_SORTING, }

   o.tbl = tbl
   return o
end

function M.configuration(self)
   if (not s_configuration) then
      s_configuration = new(self)
   end
   return s_configuration
end

function M.report(self)
   local a   = {}
   local tbl = self.tbl
   a[#a+1]   = {"Description", "Value", }
   a[#a+1]   = {"-----------", "-----", }

   for k, v in pairsByKeys(tbl) do
      a[#a+1] = {v.k, v.v }
   end

   local b = {}
   local bt = BeautifulTbl:new{tbl=a}
   b[#b+1]  = bt:build_tbl()
   b[#b+1]  = "\n"

   local rcFileA = getRCFileA()
   if (#rcFileA) then
      b[#b+1] = "Active RC file(s):"
      b[#b+1] = "------------------"
      for i = 1, #rcFileA do
         b[#b+1] = rcFileA[i]
      end
      b[#b+1]  = "\n"
   end


   local scDescriptT = getSCDescriptT()
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
   b[#b+1]  = serializeTbl{ indent = true, name="propT", value = getPropT() }
   b[#b+1]  = "\n"

   return concatTbl(b,"\n")
end
return M
