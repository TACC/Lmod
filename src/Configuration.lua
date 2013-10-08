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
local BeautifulTbl = require('BeautifulTbl')
local dbg          = require('Dbg'):dbg()
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


   local tbl = {}
   tbl.prefix          = { doc = "Lmod prefix"                     , value = "@PREFIX@",               }
   tbl.path_to_lua     = { doc = "Path to Lua"                     , value = "@path_to_lua@",          }
   tbl.path_to_pager   = { doc = "Path to Pager"                   , value = "@path_to_pager@",        }
   tbl.settarg_support = { doc = "Supporting Full Settarg Use"     , value = "@lmod_settarg_support@", }
   tbl.use_dot_files   = { doc = "Using dotfiles"                  , value = "@use_dot_files@",        }
   tbl.lmod_version    = { doc = "Lmod version"                    , value = lmod_version,             }
   tbl.ancient         = { doc = "User cache file valid time(sec)" , value = "@ancient@",              }
   tbl.short_time      = { doc = "Write cache after (sec)"         , value = "@short_time@",           }
   tbl.prepend_block   = { doc = "Prepend order"                   , value = "@prepend_block@",        }
   tbl.colorize        = { doc = "Colorize Lmod"                   , value = "@colorize@",             }
   tbl.pkg             = { doc = "Pkg Class name"                  , value = Pkg.name() or "unknown",  }
   tbl.sitePkg         = { doc = "Site Pkg location"               , value = locSitePkg,               }
   tbl.luaV            = { doc = "Lua Version"                     , value = _VERSION,                 }
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
   a[#a+1]   = {"Name", "Value", "Description",}
   a[#a+1]   = {"----", "-----", "-----------",}
   
   for k, v in pairsByKeys(tbl) do
      a[#a+1] = {k, v.value, v.doc }
   end

   local bt = BeautifulTbl:new{tbl=a}
   return bt:build_tbl()
end
return M


   



