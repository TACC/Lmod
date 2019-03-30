--------------------------------------------------------------------------
-- use io.popen to open a pipe to collect the output of a command.
-- @module capture

_G._DEBUG          = false                       -- Required by luaposix 33
local posix        = require("posix")

require("strict")

------------------------------------------------------------------------
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


local dbg          = require("Dbg"):dbg()
local getenv       = os.getenv
local setenv_posix = posix.setenv
local cosmic       = require("Cosmic"):singleton()

function lmod_system_execute(cmd)
   dbg.start{"lmod_system_execute(",cmd,")"}
   if (dbg.active()) then
      dbg.print{"cwd: ",posix.getcwd(),"\n",level=2}
   end

   local newT = {}
   local envT = {}

   envT["LD_LIBRARY_PATH"] = cosmic:value("LMOD_LD_LIBRARY_PATH") or ""
   envT["LD_PRELOAD"]      = cosmic:value("LMOD_LD_PRELOAD")      or ""

   for k, v in pairs(envT) do
      newT[k] = getenv(k)
      setenv_posix(k, v, true)
   end

   os.execute(cmd) 

   for k, v in pairs(newT) do
      setenv_posix(k,v, true)
   end

   newT = nil
   envT = nil

   dbg.fini("lmod_system_execute")
end

