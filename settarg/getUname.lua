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

_G._DEBUG   = false               -- Required by the new lua posix
local posix = require("posix")

require("strict")
require("capture")

local getenv = os.getenv

LMOD_LD_LIBRARY_PATH = "@sys_ld_lib_path@"
if (LMOD_LD_LIBRARY_PATH:sub(1,1) == "@") then
   LMOD_LD_LIBRARY_PATH = getenv("LD_LIBRARY_PATH")
end
if (LMOD_LD_LIBRARY_PATH == "") then
   LMOD_LD_LIBRARY_PATH = nil
end

------------------------------------------------------------------------
-- LMOD_LD_PRELOAD:   LD_PRELOAD found at configure
------------------------------------------------------------------------

LMOD_LD_PRELOAD = "@sys_ld_preload@"
if (LMOD_LD_PRELOAD:sub(1,1) == "@") then
   LMOD_LD_PRELOAD = getenv("LD_PRELOAD")
end
if (LMOD_LD_PRELOAD == "") then
   LMOD_LD_PRELOAD = nil
end

s_t = {}


function getUname()

   local t = s_t
   if (next(t) ~= nil) then
      s_t = t
      return t
   end

   local masterTbl        = masterTbl()
   local machFullName     = nil
   local osName           = posix.uname("%s")
   local release          = posix.uname("%r")
   local machName         = posix.uname("%m")
   local machFamilyName   = machName
   local machDescript     = machName
   osName                 = string.gsub(osName,"[ /]","_")
   if (masterTbl.genericArch) then
      machName       = "_generic"
      machDescript   = "generic"
      machFamilyName = "generic"
   elseif (osName == "Linux" and ( machName == "x86_64" or machName:find("i[3-6]86" )) and not masterTbl.noCpuModel) then
      local cpu_family
      local model
      local count = 0
      local avx2  = false
      local f = io.open("/proc/cpuinfo","r")
      if (f) then
         while (true) do
            local line = f:read("*line")
            if (line == nil) then break end
            if (line:find("^ *cpu family")) then
               local _, _, v = line:find(".*:%s*(.*)")
               cpu_family = string.format("%02x",tonumber(v))
               count = count + 1
            elseif (line:find("^ *model name")) then
               local _, _, v = line:find(".*:%s*(.*)")
               machDescript = v
               count = count + 1
            elseif (line:find("^ *model")) then
               local _, _, v = line:find(".*:%s*(.*)")
               model = string.format("%02x",tonumber(v))
               count = count + 1
            elseif (line:find("^ *flags")) then
               local i = line:find("avx2")
               avx2 = (i ~= nil)
               count = count + 1
            end
            if (count > 3) then break end
         end
         f:close()
      end
      if (avx2 and not masterTbl.noGrouping) then
         model = "avx2"
      end
      machFullName = machName .. "_" .. cpu_family .. "_" .. model
      machName     = machFullName
   end
   t.osName         = osName .. "-" .. release
   t.machDescript   = machDescript
   t.machName       = machName
   t.machFamilyName = machFamilyName
   t.os_mach        = osName .. '-' .. machName
   t.target         = os.getenv("TARGET") or ""
   t.hostName       = capture("hostname -f"):gsub("%s+","")

   s_t = t
   return t
end
