--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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
require("getUname")
require("string_split")
require("string_trim")
require("fileOps")

local Dbg         = require("Dbg")
local posix       = require("posix")
local concatTbl   = table.concat
local getenv      = posix.getenv
local load        = (_VERSION == "Lua 5.1") and loadstring or load
local masterTbl   = masterTbl
local systemG     = _G
local ModuleTable = "_ModuleTable_"
require("ProcessModuleTable")

local M          = {}

function M.default_MACH()
   local masterTbl = masterTbl()
   local results = masterTbl.mach
   if (results == "") then
      results = getenv("TARG_MACH") or "host"
   end
   if (results == "host") then
      results = getUname().machName
   end
   return results
end

function M.default_BUILD_SCENARIO()
   local dbg       = Dbg:dbg()
   local masterTbl = masterTbl()
   local MethodTbl = masterTbl.MethodTbl

   -------------------------------------------------------
   -- Search over hostname first
   local t        = getUname()
   local hostname = t.hostName
   dbg.print("in M.default_BUILD_SCENARIO\n")

   local v = nil
   while (true) do
      dbg.print("hostname: ", hostname,"\n")
      v = MethodTbl[hostname]
      if (v) then return v end
      local i = hostname:find("%.")
      if (not i) then break end
      hostname = hostname:sub(i+1)
   end

   -------------------------------------------------------
   -- Search over machName
   v = MethodTbl[t.machName] or MethodTbl[t.machFamilyName] or
       MethodTbl.default
   if (v) then return v end

   -------------------------------------------------------
   -- Return last resort default
   return "empty"
end

local function string2Tbl(s,tbl)
   local dbg = Dbg:dbg()
   dbg.start("string2Tbl(\"",s,"\", tbl)")
   local stringKindTbl = masterTbl().stringKindTbl
   for v in s:split("%s+") do
      local kind = stringKindTbl[v]
      if (kind) then
         local K = "TARG_" .. kind:upper()
         v  = (K == "TARG_BUILD_SCENARIO" and v == "empty") and "" or v
         dbg.print("v: ",v," kind: ",kind," K: ",K,"\n")

         tbl[K] = v
         
      end
   end

   
   dbg.fini()
end

function M.buildTbl(targetTbl)
   local dbg = Dbg:dbg()
   dbg.start("BuildTarget.buildTbl(targetTbl)")
   local tbl = {}

   for k in pairs(targetTbl) do
      local K   = k:upper()
      local key = "TARG_" .. K
      local v   = getenv(key)
      if (v == nil) then
         local ss = "default_" .. K
         dbg.print("ss: ", ss, "\n")
         if (M[ss]) then
            v = M[ss]()
         else
            v = ''
         end
      end
      tbl[key] = v
   end

   -- Always set mach
   tbl.TARG_MACH = M.default_MACH()
   dbg.print("tbl.TARG_MACH: ",tostring(tbl.TARG_MACH),"\n")

   if ( tbl.TARG_BUILD_SCENARIO == "empty") then
      tbl.TARG_BUILD_SCENARIO = ""
   end

   dbg.print("tbl.TARG_BUILD_SCENARIO: ",tbl.TARG_BUILD_SCENARIO ,"\n")
   local env = getenv()

   for key in pairs(env) do
      if (key:sub(1,5) == "TARG_") then
         local s = key:sub(6):lower():gsub("_family","")
         if (not targetTbl[s]) then 
            tbl[key] = ""
         end
      end
   end

   local a = {"build_scenario","mach"} 
   for _,v in ipairs(a) do
      if (targetTbl[v]) then
         targetTbl[v] = -1
      end
   end

   dbg.fini()
   return tbl
end

local function readDotFiles()
   local masterTbl = masterTbl()
   
   -------------------------------------------------------
   -- Load system then user default table.

   local a = { pathJoin(masterTbl.execDir,".settarg.lua"),
               pathJoin(getenv('HOME') or '',".settarg.lua"),
   }

   local MethodMstrTbl = {}
   local TitleMstrTbl  = {}
   local ModuleMstrTbl = {}
   local stringKindTbl = {}
   local familyTbl     = {}

   for _, fn  in ipairs(a) do
      local f = io.open(fn,"r")
      if (f) then
         local s  = f:read("*all")
         assert(load(s))()
         f:close()

         for k in pairs(systemG.MethodTbl) do
            MethodMstrTbl[k] = systemG.MethodTbl[k]
         end

         for k in pairs(systemG.TitleTbl) do
            TitleMstrTbl[k] = systemG.TitleTbl[k]
         end

         for k in pairs(systemG.ModuleTbl) do
            ModuleMstrTbl[k] = systemG.ModuleTbl[k]
            for _, v in ipairs(ModuleMstrTbl[k]) do
               stringKindTbl[v] = k
            end
         end
         for k in pairs(ModuleMstrTbl) do
            familyTbl[k] = 1
         end
         for i = 1, #systemG.NoFamilyList do
            local k = systemG.NoFamilyList[i]
            familyTbl[k] = nil
         end
      end
   end

   masterTbl.TitleTbl      = TitleMstrTbl
   masterTbl.MethodTbl     = MethodMstrTbl
   masterTbl.stringKindTbl = stringKindTbl
   masterTbl.ModuleTbl     = ModuleMstrTbl
   masterTbl.targetList    = systemG.TargetList
   masterTbl.familyTbl     = familyTbl
end

function M.exec(shell, targetList)
   local dbg         = Dbg:dbg()
   local name        = shell:name() or "unknown"
   dbg.start("BuildTarget.exec(\"",tostring(name),"\", (",
             concatTbl(targetList or {},", "),"))")
   local masterTbl   = masterTbl()
   local envVarsTbl  = {}
   local target      = masterTbl.target or getenv('TARGET') or ''
   local t           = getUname()

   masterTbl.envVarsTbl  = envVarsTbl

   readDotFiles()
   targetList = targetList or masterTbl.targetList
   local familyTbl  = masterTbl.familyTbl
   local targetTbl = {}
   for i,v in ipairs(targetList) do
      targetTbl[v] = i
   end

   

   local tbl = M.buildTbl(targetTbl)
   
   string2Tbl(table.concat(masterTbl.pargs," ") or '',tbl)

   processModuleTable(shell:getMT(ModuleTable), targetTbl, tbl)

   -- Remove options
   for i = 1,#masterTbl.remOptions do
      local rem = masterTbl.remOptions[i]
      dbg.print("remove opt: ",rem,"\n")
      for k,v in pairs(tbl) do
         if (k == rem or v == rem) then
            dbg.print("removing k: ",k," v: ",v,"\n")
            tbl[k] = ""
         end
      end
   end

   local a = {}
   for _,v in ipairs(targetList) do
      local K = "TARG_" .. v:upper()
      a[#a + 1] = tbl[K]
      if (familyTbl[v]) then
         local KK = K .. "_FAMILY"
         envVarsTbl[KK] = tbl[K]:gsub("-.*","")
      end
   end

   for k in pairs(tbl) do
      envVarsTbl[k] = tbl[k]
   end

   target = table.concat(a,"_")
   target = target:gsub("_+","_")
   target = target:gsub("_$","")

   envVarsTbl.BUILDTARGET = target
   envVarsTbl.TARG_TARGET = target
   envVarsTbl.TARG        = (getenv('TARGET_PREFIX') or '') .. "_" .. target

   local TitleTbl = masterTbl.TitleTbl

   -- Remove TARG_MACH when it is the same as the host.
   if (tbl.TARG_MACH == getUname().machName) then
      for i = 1,#a do
         local v = a[i]
         if (v == tbl.TARG_MACH) then
            table.remove(a,i)
            break
         end
      end
   end

   local aa = {}
   for _,v in ipairs(a) do
      local _, _, name, version = v:find("([^-]*)-?(.*)")

      if (v:len() > 0) then
         local s = TitleTbl[name] or v
         if (TitleTbl[name] and version ~= "" ) then
            s = TitleTbl[name] .. "-" .. version
         end
         aa[#aa+1] = s
      end
   end
   local s                          = table.concat(aa," "):trim()
   local paren                      = ""
   if (s ~= "") then
      paren                         = "("..s..")"
   end
   envVarsTbl.TARG_TITLE_BAR        = s
   envVarsTbl.TARG_TITLE_BAR_PAREN  = paren

   if (masterTbl.purgeFlag) then
      for k in pairs(envVarsTbl) do
         envVarsTbl[k] = ""
      end
   end


   dbg.fini()
end

return M
