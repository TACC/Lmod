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

require("strict")

require("capture")
require("fileOps")
require("pairsByKeys")
require("serializeTbl")
require("utils")
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
      local std_sha1 = "2c2c49b67c4b8310273480360552eaa69713a462"
      
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
   local settarg_support = "@lmod_settarg_support@"
   local pkgName         = Pkg.name() or "unknown"
   local lmod_colorize   = getenv("LMOD_COLORIZE") or "@colorize@"
   local scDescriptT     = getSCDescriptT()
   local numSC           = #scDescriptT
   local uname           = capture("uname -a")

   local tbl = {}
   tbl.prefix     = { doc = "Lmod prefix"                 , value = "@PREFIX@",           }  
   tbl.dupPaths   = { doc = "Allow duplicate paths"       , value = LMOD_DUPLICATE_PATHS, }
   tbl.path_lua   = { doc = "Path to Lua"                 , value = "@path_to_lua@",      }
   tbl.path_pager = { doc = "Path to Pager"               , value = "@path_to_pager@",    }
   tbl.path_hash  = { doc = "Path to HashSum"             , value = "@path_to_hashsum@",  }
   tbl.settarg    = { doc = "Supporting Full Settarg Use" , value = settarg_support,      }
   tbl.dot_files  = { doc = "Using dotfiles"              , value = "@use_dot_files@",    }
   tbl.numSC      = { doc = "number of cache dirs"        , value = numSC,                }
   tbl.lmodV      = { doc = "Lmod version"                , value = lmod_version,         }
   tbl.ancient    = { doc = "User cache valid time(sec)"  , value = "@ancient@",          }
   tbl.short_tm   = { doc = "Write cache after (sec)"     , value = "@short_time@",       }
   tbl.prpnd_blk  = { doc = "Prepend order"               , value = "@prepend_block@",    }
   tbl.colorize   = { doc = "Colorize Lmod"               , value = lmod_colorize,        }
   tbl.mpath_root = { doc = "MODULEPATH_ROOT"             , value = "@modulepath_root@",  }
   tbl.pkg        = { doc = "Pkg Class name"              , value = pkgName,              }
   tbl.sitePkg    = { doc = "Site Pkg location"           , value = locSitePkg,           }
   tbl.uname      = { doc = "uname -a"                    , value = uname,                }
   tbl.luaV       = { doc = "Lua Version"                 , value = _VERSION,             }

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
      a[#a+1] = {v.doc, v.value }
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

   local twidth = TermWidth()
   local banner = rep("-", twidth - 2)
   local str    = " Lmod Property Table: "
   b[#b+1]  = banner
   b[#b+1]  = str
   b[#b+1]  = banner
   b[#b+1]  = "\n"
   b[#b+1]  = serializeTbl{ indent = true, name="propT", value = getPropT() }
   b[#b+1]  = "\n"

   return concatTbl(b,"\n")
end
return M


   



