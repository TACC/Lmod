--------------------------------------------------------------------------
-- Timer is a singleton class where the whole program as well as parts
-- of the program can be timed.  To use simply create:
--     local timer = require("Timer"):timer()
--     ...
--     timer:deltaT("name", t2-t1)
-- to record.
-- @classmod Timer

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

require("pairsByKeys")

local M            = {}
local BeautifulTbl = require("BeautifulTbl")
s_timer            = false

--------------------------------------------------------------------------
-- A private Ctor for the Timer singleton class.
-- @param self An Timer object.
local function new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   self.tbl     = {}
   return o
end

--------------------------------------------------------------------------
-- The public interface to the Timer class.
-- @param self An Timer object.
function M.singleton(self)
   if (not s_timer) then
      s_timer = new(self)
   end
   return s_timer
end

--------------------------------------------------------------------------
-- The delta time accumulator.
-- @param self An Timer object.
-- @param name The name to accumulate under.
-- @param deltaT The delta time to be accumulated.
function M.deltaT(self, name, deltaT)
   local t           = s_timer.tbl[name] or { accT = 0.0, count = 0}
   t.accT            = t.accT  + deltaT
   t.count           = t.count + 1
   s_timer.tbl[name] = t
end

--------------------------------------------------------------------------
-- The report function.  It returns a string which are the results.
-- @param self An Timer object.
function M.report(self)
   local a   = {}
   a[#a + 1] = { "Name", "Count", "T Time", "Ave Time" }
   a[#a + 1] = { "----", "-----", "------", "--------" }

   local t = self.tbl

   --for k, v in pairsByKeys(t, function(a,b)
   --                           return a.accT < b.accT
   --                           end) do
   for k, v in pairs(t) do
      a[#a+1] = { k, v.count, v.accT, v.accT/v.count }
   end

   local bt = BeautifulTbl:new{tbl = a, justifyT = {"Left", "Right", "Right", "Right"}}
   return bt:build_tbl()
end

return M
