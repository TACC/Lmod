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
--  Copyright (C) 2008-2016 Robert McLay
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
require("serializeTbl")
require("myGlobals")
require("string_utils")
require("lmod_system_execute")
require("capture")
local Dbg     = require("Dbg")
local dbg     = Dbg:dbg()
PkgBase       = require("PkgBase")
local hook    = require("Hook")
local lfs     = require("lfs")
local getenv  = os.getenv
local uname   = require("posix").uname
local cosmic  = require("Cosmic"):singleton()
local syshost = cosmic:value("LMOD_SYSHOST")

Pkg = PkgBase.build("PkgTACC")

--------------------------------------------------------------------------
-- load_hook(): Here we record the any modules loaded.

local s_msgT = {}

local function l_load_hook(t)
   -- the arg t is a table:
   --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
   --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)

   -- Your site can use this any way that suits.  Here are some possibilities:
   --  a) Write this information into a file in your users directory (say ~/.lmod.d/.save).
   --     Then once a day/week/month collect this data.
   --  b) have this function call syslogd to register that this module was loaded by this
   --     user
   --  c) Write the same information directly to some database.

   dbg.start{"l_load_hook(t)"}

   if (mode() ~= "load") then return end
   local user        = os.getenv("USER")
   local host        = syshost
   if (not host) then
      local i,j, first
      i,j, first, host = uname("%n"):find("([^.]*)%.([^.]*)%.")
      if (not host) then
         local fullhost = capture("hostname -f"):trim()
         if (fullhost:find("%.")) then
            i,j, first, host = fullhost:find("([^.]*)%.([^.]*)%.")
         else
            host = fullhost
         end
      end
   end

   local currentTime = epoch()
   local msg         = string.format("user='%s' module='%s' path='%s' host='%s' time='%f'",
                                     user, t.modFullName, t.fn, host or "<unknown_syshost>", currentTime)
   s_msgT[t.modFullName] = msg
   dbg.fini()
end

local function l_parse_updateFn_hook(updateSystemFn, t)
   local attr = lfs.attributes(updateSystemFn)
   if (not attr or type(attr) ~= "table") then
      return
   end

   t.lastUpdateEpoch = attr.modification
   local f           = assert(io.open(updateSystemFn,"r"))
   local whole       = f:read("*all")
   f:close()

   for line in whole:split("\n") do
      line = line:trim()
      if (not line:find("^[#!-]")) then
         local i =  line:find("=")
         if (i) then
            local k = line:sub(1,i-1):trim()
            local v = line:sub(i+1,-1):trim()
            t[k] = v
         end
      end
   end
   t.hostType = t.nodeType or "unknown"
end

local mapT =
{
   grouped = {
      ['/opt/modulefile']      = "Core Modules",
      ['/opt/apps/modulefile'] = "Core Modules",
      ['/opt/apps/xsede/.*']   = "XSEDE Core modules",
      ['/mvapich2']            = "MVAPICH2 Dependent Modules",
      ['/opt/apps/intel.*']    = "Intel Compiler Dependent Modules",
   },
}



local function l_avail_hook(t)
   dbg.print{"avail hook called\n"}
   local availStyle = masterTbl().availStyle
   local styleT     = mapT[availStyle]
   if (not availStyle or availStyle == "system" or styleT == nil) then
      return
   end

   for k,v in pairs(t) do
      for pat,label in pairs(styleT) do
         if (k:find(pat)) then
            t[k] = label
            break
         end
      end
   end
end

local function l_report_loads()
   if (posix.syslog) then
      posix.syslog.openlog("ModuleUsageTracking")
      for k,msg in pairs(s_msgT) do
         posix.syslog.syslog(posix.syslog.LOG_INFO, msg)
      end
      posix.syslog.closelog()
   else
      for k,msg in pairs(s_msgT) do
         lmod_system_execute("logger -t ModuleUsageTracking -p local0.info " .. msg)
      end
   end
end

local orig_tonumber = tonumber

function safe_tonumber(a,b)
   if (type(b) == "number") then
      return orig_tonumber(a,b)
   end
   return orig_tonumber(a,10)
end

local function l_colorize_fullName(fullName, sn)
   local version       = extractVersion(fullName, sn)
   local version_color = getenv("LMOD_DISPLAY_VERSION_COLOR")
   local sn_color      = getenv("LMOD_DISPLAY_SN_COLOR")
   local meta_color    = getenv("LMOD_DISPLAY_META_COLOR")

   ---- colorize() will use `plain` if `color` is not found.
   local moduleName
   if (version) then
      moduleName  =  colorize(sn_color, sn) .. colorize(version_color, "/"..version)
   else
      moduleName  = colorize(meta_color, sn)
   end
   return moduleName
end

ExitHookA.register(l_report_loads)


hook.register("colorize_fullName", l_colorize_fullName)
hook.register("avail",             l_avail_hook)
hook.register("load",              l_load_hook)
hook.register("parse_updateFn",    l_parse_updateFn_hook)

sandbox_registration { Pkg      = Pkg,
                       tonumber = safe_tonumber,
                     }
