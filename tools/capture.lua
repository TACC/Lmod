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

--------------------------------------------------------------------------
-- Capture output and exit status from *cmd*
-- @param cmd A string that contains a unix command.
-- @param envT A table that contains environment variables to be set/restored when running *cmd*.
function capture(cmd, envT)
   dbg.start{"capture(",cmd,")"}
   if (dbg.active()) then
      dbg.print{"cwd: ",posix.getcwd(),"\n",level=2}
   end

   local newT = {}
   envT = envT or {}

   envT["LD_LIBRARY_PATH"] = cosmic:value("LMOD_LD_LIBRARY_PATH") or ""
   envT["LD_PRELOAD"]      = cosmic:value("LMOD_LD_PRELOAD")      or ""


   for k, v in pairs(envT) do
      newT[k] = getenv(k) or false
      setenv_posix(k, v, true)
   end

   -- in Lua 5.1, p:close() does not return exit status,
   -- so we append 'echo $?' to the command to determine the exit status
   local ec_msg = "Lmod Capture Exit Code"
   if _VERSION == "Lua 5.1" then
      cmd = cmd .. '; echo "' .. ec_msg .. ': $?"'
   end

   local out
   local status
   local p   = io.popen(cmd)
   if (p ~= nil) then
      out    = p:read("*all")
      status = p:close()
   end

   -- trim 'exit code: <value>' from the end of the output and determine exit status
   if _VERSION == "Lua 5.1" then
      local exit_code = out:match(ec_msg .. ": (%d+)\n$")
      if not exit_code then
         LmodError("Failed to find '" .. ec_msg .. "' in output: " .. out)
      end
      status = exit_code == '0'
      out = out:gsub(ec_msg .. ": %d+\n$", '')
   end

   for k, v in pairs(newT) do
      if (v == false) then v = nil end
      setenv_posix(k,v, true)
   end

   if (dbg.active()) then
      dbg.start{"capture output()",level=2}
      dbg.print{out}
      dbg.fini("capture output")
   end
   --dbg.print{"status: ",status,", type(status): ",type(status),"\n"}
   dbg.fini("capture")
   return out, status
end
