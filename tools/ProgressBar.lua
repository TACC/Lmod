--------------------------------------------------------------------------
-- This class generates a progress bar.  To use do:
--
--       local pb = ProgressBar:new{stream = io.stdout, max = N, barWidth=100}
--       for i = 1, N do
--          pb:progress(i)
--          -- stuff you want to show progress on.
--       end
--
-- The design is to model a football field.
-- The total size is given to the ctor.  There is a "+" for every 10%
-- in progress and "|" at 50 and 100%.
--
-- @classmod ProgressBar

require("strict")

------------------------------------------------------------------------
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



local dbg   = require("Dbg"):dbg()
local M     = { barWidth = 50 }
local floor = math.floor
s_symbolT   = {}


--------------------------------------------------------------------------
-- Ctor for class
-- @param self ProgressBar object
-- @param t input table
function M.new(self, t)
   local tbl = t
   local o = {}

   setmetatable(o, self)
   self.__index  = self
   o.max      = t.max
   o.barWidth = t.barWidth or o.barWidth
   o.barWidth = math.min(o.barWidth, o.max)
   o.stream   = t.stream or io.stdout
   o.unit     = 100/o.barWidth
   o.fence    = o.unit
   o.mark     = 10

   s_symbolT[10]  = "+"
   s_symbolT[20]  = "+"
   s_symbolT[30]  = "+"
   s_symbolT[40]  = "+"
   s_symbolT[50]  = "|"
   s_symbolT[60]  = "+"
   s_symbolT[70]  = "+"
   s_symbolT[80]  = "+"
   s_symbolT[90]  = "+"
   s_symbolT[100] = "|"

   return o
end

--------------------------------------------------------------------------
-- Prints out progress
-- @param self ProgressBar object
-- @param i the index counter.
function M.progress(self,i)
   local j = floor(i/self.max*100)
   local k = floor((i+1)/self.max*100)

   if (j >= self.fence) then
      local symbol = "-"
      --print (j, k, l)
      if ((j <= self.mark and k > self.mark) or ((j == k) and j == self.mark)) then
         symbol = s_symbolT[self.mark]
         self.mark = self.mark+10
      end

      self.stream:write(symbol)
      self.stream:flush()
      self.fence = self.fence + self.unit
   end
end

--------------------------------------------------------------------------
-- Reports finish of progress bar.
-- @param self ProgressBar object
function M.fini(self)
   self.stream:write("\n")
end


return M
