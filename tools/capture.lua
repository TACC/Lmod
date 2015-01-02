--------------------------------------------------------------------------
-- use io.popen to open a pipe to collect the output of a command.
-- @module capture

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


local dbg          = require("Dbg"):dbg()
_G._DEBUG          = false                       -- Required by luaposix 33
local posix        = require("posix")
local getenv       = os.getenv
local setenv_posix = posix.setenv

--------------------------------------------------------------------------
-- Capture stdout from *cmd*
-- @param cmd A string that contains a unix command.
-- @param envT A table that contains environment variables to be set/restored when running *cmd*.
function capture(cmd, envT)
   dbg.start{"capture(",cmd,")"}
   if (dbg.active) then
      dbg.print{"cwd: ",posix.getcwd(),"\n",level=2}
   end
   
   local newT = {}
   envT = envT or {}
   for k, v in pairs(envT) do
      newT[k] = getenv(k)
      setenv_posix(k, v, true)
   end

   local ret
   local p   = io.popen(cmd)
   if (p ~= nil) then
      ret = p:read("*all")
      p:close()
   end

   for k, v in pairs(newT) do
      setenv_posix(k,v, true)
   end
   
   if (dbg.active()) then
      dbg.start{"capture output()",level=2}
      dbg.print{ret}
      dbg.fini("capture output")
   end
   dbg.fini("capture")
   return ret
end

