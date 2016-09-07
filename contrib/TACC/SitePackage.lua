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
require("serializeTbl")
require("myGlobals")
require("string_utils")
require("lmod_system_execute")
local Dbg    = require("Dbg")
local dbg    = Dbg:dbg()
PkgBase      = require("PkgBase")
local hook   = require("Hook")
local lfs    = require("lfs")
local getenv = os.getenv
local uname  = require("posix").uname

Pkg = PkgBase.build("PkgTACC")

--------------------------------------------------------------------------
-- load_hook(): Here we record the any modules loaded.

local s_msgA = {}

local function load_hook(t)
   -- the arg t is a table:
   --     t.modFullName:  the module full name: (i.e: gcc/4.7.2)
   --     t.fn:           The file name: (i.e /apps/modulefiles/Core/gcc/4.7.2.lua)

   -- Your site can use this any way that suits.  Here are some possibilities:
   --  a) Write this information into a file in your users directory (say ~/.lmod.d/.save).
   --     Then once a day/week/month collect this data.
   --  b) have this function call syslogd to register that this module was loaded by this
   --     user
   --  c) Write the same information directly to some database.

   dbg.start{"load_hook(t)"}

   if (mode() ~= "load") then return end
   local user        = os.getenv("USER")
   local host        = uname("%n")
   local currentTime = epoch()
   local msg         = string.format("user=%s module=%s path=%s host=%s time=%f",
                                     user, t.modFullName, t.fn, host, currentTime)
   local a           = s_msgA
   a[#a+1]           = msg

   dbg.fini()
end

buildHostsT = {
   ["build.stampede.tacc.utexas.edu"]    = 1,
   ["c560-904.stampede.tacc.utexas.edu"] = 1,
   ["c560-903.stampede.tacc.utexas.edu"] = 1,
   ["c560-902.stampede.tacc.utexas.edu"] = 1,
   ["c560-901.stampede.tacc.utexas.edu"] = 1,
   ["build.ls4.tacc.utexas.edu"]         = 1,
}

--------------------------------------------------------------------------
-- writeCache_hook(): set dontWriteCache on build machines

local function writeCache_hook(t)
   local userName = getenv("USER")
   local host     = uname("%n")

   if (buildHostsT[host]) then
      t.dontWriteCache = true
   end
end

local function parse_updateFn_hook(updateSystemFn, t)
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



function avail_hook(t)
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

local function report_loads()

   local a = s_msgA
   for i = 1,#a do
      local msg = a[i]
      lmod_system_execute("logger -t ModuleUsageTracking -p local0.info " .. msg)
   end
end

local orig_tonumber = tonumber

function safe_tonumber(a,b)
   if (type(b) == "number") then
      return orig_tonumber(a,b)
   end
   return orig_tonumber(a,10)
end



ExitHookA.register(report_loads)


hook.register("avail",          avail_hook)
hook.register("load",           load_hook)
hook.register("parse_updateFn", parse_updateFn_hook)
hook.register("writeCache",     writeCache_hook)

sandbox_registration { Pkg      = Pkg,
                       tonumber = safe_tonumber,
                     }
