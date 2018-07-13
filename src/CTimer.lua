--------------------------------------------------------------------------
-- This class is a singleton to act as a timer.
-- @classmod CTimer

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

require("utils")
local M       = {}
local dbg     = require("Dbg"):dbg()

s_cTimer = false

local function new(self, msg, threshold, active, timeout)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   timeout     = tonumber(timeout or -1.0)
   o.state     = active and "init" or "dead"
   o.start     = epoch()
   o.msg       = msg
   o.threshold = threshold
   o.timeout   = (timeout > 1.0e-8) and timeout or -1.0
   return o
end

--------------------------------------------------------------------------
-- Singleton Class builder
-- @param self A CTimer object
-- @param msg stored message
-- @param threshold Threshold before message is printed.
-- @param active Active state
-- @param timeout A timeout (if positive) when an error will be reported.
-- @return A CTimer singleton object.
function M.singleton(self, msg, threshold, active, timeout)
   if (not s_cTimer) then
      s_cTimer = new(self, msg, threshold, active, timeout)
   end
   return s_cTimer
end

--------------------------------------------------------------------------
-- Check the time.  Print message if change from start passes the threshold.
-- @param self A CTimer object
function M.test(self)
   local delta   = epoch() - self.start
   local timeout = self.timeout
   if (timeout > 0 and delta > timeout) then
      error()
   end

   if (self.state == "init") then
      dbg.start{"CTimer:test()", level=2}
      dbg.print{"delta: ",delta,"\n"}
      if (delta > self.threshold) then
         io.stderr:write(self.msg)
         self.state = "activeMsg"
      end
      dbg.fini("CTimer:test")
   end
end

--------------------------------------------------------------------------
-- Quit timer
-- @param self A CTimer object.
-- @param endMsg ending message.
function M.done(self,endMsg)
   if (self.state == "activeMsg") then
      io.stderr:write(endMsg,"\n")
      self.state = "done"
   end
end

return M
