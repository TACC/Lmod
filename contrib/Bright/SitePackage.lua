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

require("strict")
local hook   = require("Hook")
local uname  = require("posix").uname

-- By using the hook.register function, this function "load_hook" is called
-- ever time a module is loaded with the file name and the module name.

local s_msgA = {}

function load_hook(t)
   -- the arg t is a table:
   --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
   --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)

   -- Your site can use this any way that suits.  Here are some possibilities:
   --  a) Write this information into a file in your users directory (say ~/.lmod.d/.save).
   --     Then once a day/week/month collect this data.
   --  b) have this function call syslogd to register that this module was loaded by this
   --     user
   --  c) Write the same information directly to some database.

   -- This is an example writing to syslogd:

   if (mode() ~= "load") then return end
   local user        = os.getenv("USER")
   local host        = uname("%n")
   local currentTime = epoch()
   local jobid       = os.getenv("JOB_ID") or "unknown"
   local msg         = string.format("USER=%s JOB_ID=%s MODULE=%s FULLPATH=%s HOST=%s TIME=%f",
                                     user, jobid, t.modFullName, t.fn, host, currentTime)
   local a           = s_msgA
   a[#a+1]           = msg
end

hook.register("load",load_hook)


local function l_report_loads()
   local openlog
   local syslog
   local closelog
   local logInfo
   if (posix.syslog) then
      if (type(posix.syslog) == "table" ) then
         -- Support new style posix.syslog table
         openlog  = posix.syslog.openlog
         syslog   = posix.syslog.syslog
         closelog = posix.syslog.closelog
         logInfo  = posix.syslog.LOG_INFO
      else
         -- Support original style posix.syslog functions
         openlog  = posix.openlog
         syslog   = posix.syslog
         closelog = posix.closelog
         logInfo  = 6
      end

      openlog("ModuleUsageTracking")
      for k,msg in pairs(s_msgT) do
         syslog(logInfo, msg)
      end
      closelog()
   else
      for k,msg in pairs(s_msgT) do
         lmod_system_execute("logger -t ModuleUsageTracking -p local0.info " .. msg)
      end
   end
end


ExitHookA.register(l_report_loads)
