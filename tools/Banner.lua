--- This handle banners used in Lmod.
-- @classmod Banner

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

require("TermWidth")
local M         = {}
local concatTbl = table.concat
local dbg       = require("Dbg"):dbg()
local floor     = math.floor
local max       = math.max
local rep       = string.rep

local s_bannerT = false

local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index  = self
   o.__termwidth = TermWidth()
   o.__nspacesG  = 0
   o.__borderG   = false
   return o
end

--- The singleton ctor for the class.
-- @param self Banner object.

function M.singleton(self)
   if (not s_bannerT) then
      s_bannerT = new(self)
   end

   return s_bannerT
end

--------------------------------------------------------------------------
-- Access function return the current terminal width.
-- @param self Banner object
-- @return the current termwidth

function M.width(self)
   return self.__termwidth
end

--------------------------------------------------------------------------
-- Member function to register a number spaces between term width and banner.
-- @param self Banner object
-- @param nspaces the number of spaces to the left of the banner.
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

--------------------------------------------------------------------------
-- Member function to output the banner itself with str in the middle.
-- @param self Banner object
-- @param str input string.
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

---- finis -----
return M
