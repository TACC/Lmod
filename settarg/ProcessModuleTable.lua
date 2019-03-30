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

require("strict")
_ModuleTable_ = ""
local TargValue = require("TargValue")
local dbg       = require("Dbg"):dbg()
local systemG   = _G
local load      = (_VERSION == "Lua 5.1") and loadstring or load

function extractVersion(fullName, sn)
   local pattern = '^' .. sn:escape() .. '/?'
   local version = fullName:gsub(pattern,"")
   if (version == "") then
      version = false
   end
   return version
end

function processModuleTable(mt_string, targetTbl, tbl)
   dbg.start{"processModuleTable(mt_string, targetTbl, tbl)"}
   if (mt_string == nil) then return end
   assert(load(mt_string))()
   local mt        = systemG._ModuleTable_

   local stringKindTbl = masterTbl().stringKindTbl

   local mT = mt.mT
   for sn,v in pairs(mT) do
      local kindT = stringKindTbl[sn]
      if (kindT and next(kindT) ~= nil) then
         for key in pairs(kindT) do
            if (v.status == "active" and targetTbl[key] ) then
               targetTbl[key] = -1
               local K = "TARG_" .. key:upper()
               tbl[K]  = TargValue:new{sn = sn, version = extractVersion(v.fullName, sn)}
               dbg.print{"V2: K: ",K, " tbl[K]: ",tbl[K]:display(),"\n"}
            end
         end
      end
   end

   for k in pairs(targetTbl) do
      if (targetTbl[k] ~= -1) then
         dbg.print{"Clearing k: ",k," targetTbl[k]: ", tostring(targetTbl[k]), "\n"}
         local K = "TARG_" .. k:upper()
         tbl[K] = false
      end
   end
   dbg.fini("processModuleTable")
end
