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


--------------------------------------------------------------------------
-- Banner: Control the banner and border functions:
--------------------------------------------------------------------------


require("strict")
require("TermWidth")
local M         = {}
local concatTbl = table.concat
local dbg       = require("Dbg"):dbg()
local floor     = math.floor
local hook      = require("Hook")
local max       = math.max
local rep       = string.rep

local s_bannerT = false


local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   local twidth = TermWidth()
   o.__termwidth = hook.apply("bannerWidth", twidth)
   o.__nspacesG  = 0
   o.__borderG   = false
   return o
end


function M.banner(self)
   if (not s_bannerT) then
      s_bannerT = new(self)
   end

   return s_bannerT
end

function M.width(self)
   return self.__termwidth
end

function M.border(self, nspaces)
   if (not self.__borderG or nspaces ~= self.__nspacesG) then
      self.__nspacesG = nspaces
      local myWidth   = self:width() - 4 - nspaces
      local a = {}
      a[1] = rep("  ", nspaces)
      a[2] = rep('-', myWidth)
      a[3] = "\n"
      self.__borderG  =  concatTbl(a,"")
   end
   return self.__borderG
end

function M.bannerStr(self, str)
   local a       = {}
   local myWidth = self:width()
   local len     = str:len() + 2
   local lcount  = floor((myWidth - len)/2)
   local rcount  = myWidth - lcount - len
   a[#a+1] = rep("-",lcount)
   a[#a+1] = " "
   a[#a+1] = str
   a[#a+1] = " "
   a[#a+1] = rep("-",rcount)
   return concatTbl(a,"")
end

return M
