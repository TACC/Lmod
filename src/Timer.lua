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

local M            = {}
local BeautifulTbl = require("BeautifulTbl")
s_timer            = {}

local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   self.tbl     = {}
   return o
end

function M.timer(self)
   if (next(s_timer) == nil) then
      s_timer = new(self)
   end
   return s_timer
end

function M.deltaT(self, name, deltaT)
   local t           = s_timer.tbl[name] or { accT = 0.0, count = 0}
   t.accT            = t.accT  + deltaT
   t.count           = t.count + 1
   s_timer.tbl[name] = t
end

function M.report(self)
   local a   = {}
   a[#a + 1] = { "Name", "Count", "T Time", "Ave Time" }
   a[#a + 1] = { "----", "-----", "------", "--------" }

   local t = self.tbl

   for k, v in pairsByKeys(t, function(a,b) return a.accT < b.acct end) do
      a[#a+1] = { k, v.count, v.accT, v.accT/v.count }
   end

   local bt = BeautifulTbl:new{tbl = a, justifyT = {"Left", "Right", "Right", "Right"}}
   return s = bt:build_tbl()
end

return M

