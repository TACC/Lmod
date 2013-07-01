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

require("pairsByKeys")
local BeautifulTbl = require('BeautifulTbl')
local Dbg          = require('Dbg')
local M            = {}

s_configuration   = false

local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   local tbl = {}
   tbl.prefix               = { doc = "Lmod prefix"                               , value = "@PREFIX@",               }
   tbl.path_to_lua          = { doc = "Path to Lua"                               , value = "@path_to_lua@",          }
   tbl.path_to_pager        = { doc = "Path to Pager"                             , value = "@path_to_pager@",        }
   tbl.lmod_settarg_support = { doc = "Supporting Full Settarg Use"               , value = "@lmod_settarg_support@", }
   tbl.use_dot_files        = { doc = "Using dotfiles"                            , value = "@use_dot_files@",        }
   tbl.git_version          = { doc = "Lmod git version"                          , value = "@git@",                  }
   tbl.ancient              = { doc = "How long the user cache file is valid"     , value = "@ancient@",              }
   tbl.short_time           = { doc = "Cache Build time at which file is written" , value = "@short_time@",           }
   tbl.prepend_block        = { doc = "Order in which prepends are done"          , value = "@prepend_block@",        }
   tbl.colorize             = { doc = "Colorize Lmod"                             , value = "@colorize@",             }
   tbl.pkg                  = { doc = "Pkg Class name"                            , value = Pkg.name() or "unknown",                  }

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
   a[#a+1]   = {"Name","Description", "Value"}
   a[#a+1]   = {"----","-----------", "-----"}
   
   for k, v in pairsByKeys(tbl) do
      a[#a+1] = {k, v.doc, v.value}
   end

   local bt = BeautifulTbl:new{tbl=a}
   return bt:build_tbl()
end
return M


   



