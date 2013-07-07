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
require("utils")
require("ProcessModuleTable")

local Dbg         = require("Dbg")
local posix       = require("posix")
local base64      = require("base64")
local concatTbl   = table.concat
local decode64    = base64.decode64
local encode64    = base64.encode64
local getenv      = posix.getenv
local load        = (_VERSION == "Lua 5.1") and loadstring or load
local masterTbl   = masterTbl
local systemG     = _G
local ModuleTable = "_ModuleTable_"

local M          = {}

BuildScenarioTbl = {}
TitleTbl         = {}
ModuleTbl        = {}
TargetList       = {}
NoFamilyList     = {}

require("sandbox")


function M.default_MACH()
   return getUname().machName
end

function M.default_OS()
   local dbg = Dbg:dbg()
   dbg.start("BuildTarget:default_OS()")
   local name = getUname().osName
   dbg.print("name: ",name,"\n")
   dbg.fini("BuildTarget:default_OS")
   return name
end

function M.default_BUILD_SCENARIO(tbl)
   local dbg       = Dbg:dbg()
   dbg.start("BuildTarget:default_BUILD_SCENARIO()")
   local masterTbl = masterTbl()
   local BuildScenarioTbl = masterTbl.BuildScenarioTbl

   -------------------------------------------------------
   -- First look to see if there is TARG_BUILD_SCENARIO_STATE
   local v = getenv("TARG_BUILD_SCENARIO_STATE")
   if (v) then
      dbg.print("STATE: ",v,"\n")
      dbg.fini("BuildTarget:default_BUILD_SCENARIO")
      tbl.TARG_BUILD_SCENARIO_STATE = v
      return v
   end
   

   -------------------------------------------------------
   -- Search over hostname first
   local t        = getUname()
   local hostname = t.hostName

   while (true) do
      v = BuildScenarioTbl[hostname]
      if (v) then
         dbg.print("hostname: ", hostname," v: ",v,"\n")
         dbg.fini("BuildTarget:default_BUILD_SCENARIO")
         tbl.TARG_BUILD_SCENARIO_STATE = v
         return v
      end
      local i = hostname:find("%.")
      if (not i) then break end
      hostname = hostname:sub(i+1)
   end

   -------------------------------------------------------
   -- Search over machName
   v = BuildScenarioTbl[t.machName] or BuildScenarioTbl[t.machFamilyName] or
       BuildScenarioTbl.default
   if (v) then
      dbg.print("machName v: ",v,"\n")
      dbg.fini("BuildTarget:default_BUILD_SCENARIO")
      tbl.TARG_BUILD_SCENARIO_STATE = v
      return v
   end

   v = "empty"
   tbl.TARG_BUILD_SCENARIO_STATE = v
   dbg.print("default v: ",v,"\n")
   dbg.fini("BuildTarget:default_BUILD_SCENARIO")
   return v
end

local function string2Tbl(s,tbl)
   local dbg = Dbg:dbg()
   dbg.start("string2Tbl(\"",s,"\", tbl)")
   local stringKindTbl = masterTbl().stringKindTbl
   for v in s:split("%s+") do
      local kindT  = stringKindTbl[v]
      if (kindT == nil) then
         if (v ~= "") then
            local K = "TARG_EXTRA"
            local t = tbl[K] or {}
            t[v]    = true
            tbl[K]  = t
            dbg.print("Adding \"",v,"\" to TARG_EXTRA\n")
         end
      else
         for kind in pairs(kindT) do
            local K = "TARG_" .. kind:upper()
            if (K == "TARG_BUILD_SCENARIO" and v == "empty") then
               v                             = ""
               tbl.TARG_BUILD_SCENARIO_STATE = "empty"
            end
            dbg.print("v: ",v," kind: ",kind," K: ",K,"\n")
            tbl[K] = v
         end
      end
   end
   dbg.fini()
end

function M.init_EXTRA()
   local dbg = Dbg:dbg()
   dbg.start("BuildTarget.init_EXTRA()")
   
   local t = {}
   local extra = getenv("TARG_EXTRA_ENCODED_ARRAY") 
   if (not extra) then
      dbg.print("Empty TARG_EXTRA_ENCODED_ARRAY\n")
   else
      for v64 in extra:split(":") do
         local v = decode64(v64)
         t[v]    = true
         dbg.print("Adding ",v," to initial value of TARG_EXTRA\n")
      end
   end
   dbg.fini("BuildTarget.init_EXTRA")
   return t
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
         if (M[ss]) then
            v = M[ss](tbl)
         else
            v = ''
         end
         dbg.print("ss: ", ss," v: ",v,"\n")
      end
      tbl[key] = v
   end

   -- Always extract EXTRA from environment
   tbl.TARG_EXTRA = M.init_EXTRA()

   -- Always set mach
   tbl.TARG_MACH           = M.default_MACH()
   tbl.TARG_MACH_DESCRIPT  = getUname().machDescript
   targetTbl.mach          = -1
   targetTbl.mach_descript = -1

   -- Always set os and os_family
   tbl.TARG_OS         = M.default_OS()
   tbl.TARG_OS_FAMILY  = tbl.TARG_OS:gsub("-.*","")
   targetTbl.os        = -1
   targetTbl.os_family = -1

   local method = tbl.TARG_BUILD_SCENARIO
   if (tbl.TARG_BUILD_SCENARIO_STATE and tbl.TARG_BUILD_SCENARIO_STATE == "empty") then
      method = "empty"
   end

   local env = getenv()

   for key in pairs(env) do
      if (key:sub(1,5) == "TARG_") then
         local s = key:sub(6):lower():gsub("_family","")
         if (not targetTbl[s]) then 
            tbl[key] = ""
         end
      end
   end

   tbl.TARG_BUILD_SCENARIO_STATE = method
   tbl.TARG_BUILD_SCENARIO       = method
   if (method == "empty") then
      tbl.TARG_BUILD_SCENARIO    = ""
   end

   dbg.print("tbl.TARG_BUILD_SCENARIO_STATE: ",tbl.TARG_BUILD_SCENARIO_STATE ,"\n")
   local a = {"build_scenario","mach", "extra",} 
   for _,v in ipairs(a) do
      if (targetTbl[v]) then
         targetTbl[v] = -1
      end
   end

   dbg.fini()
   return tbl
end

local function readDotFiles()
   local dbg       = Dbg:dbg()
   local masterTbl = masterTbl()
   
   -------------------------------------------------------
   -- Load system then user default table.

   local a = { pathJoin(masterTbl.execDir,".settarg.lua"),
               pathJoin(getenv('HOME') or '',".settarg.lua"),
   }

   local projectConfig = findFileInTree(".settarg.lua")

   if (projectConfig ~= a[2]) then
      a[#a+1] = projectConfig
   end

   local MethodMstrTbl = {}
   local TitleMstrTbl  = {}
   local ModuleMstrTbl = {}
   local stringKindTbl = {}
   local familyTbl     = {}

   for _, fn  in ipairs(a) do
      dbg.print("fn: ",fn,"\n")
      local f = io.open(fn,"r")
      if (f) then
         local whole  = f:read("*all")
         f:close()

         --local status, msg = sandbox_run(whole)
         --if (not status) then
         --   io.stderr:write(msg,"\n")
         --   os.exit(1)
         --end

         assert(load(whole))()

         for k in pairs(systemG.BuildScenarioTbl) do
            MethodMstrTbl[k] = systemG.BuildScenarioTbl[k]
         end

         for k in pairs(systemG.TitleTbl) do
            TitleMstrTbl[k] = systemG.TitleTbl[k]
         end

         for k in pairs(systemG.ModuleTbl) do
            ModuleMstrTbl[k] = systemG.ModuleTbl[k]
            for _, v in ipairs(ModuleMstrTbl[k]) do
               local t          = stringKindTbl[v] or {}
               t[k]             = true
               stringKindTbl[v] = t
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

   masterTbl.TitleTbl         = TitleMstrTbl
   masterTbl.BuildScenarioTbl = MethodMstrTbl
   masterTbl.stringKindTbl    = stringKindTbl
   masterTbl.ModuleTbl        = ModuleMstrTbl
   masterTbl.targetList       = systemG.TargetList
   masterTbl.familyTbl        = familyTbl

end

function M.exec(shell)
   local dbg         = Dbg:dbg()
   local name        = shell:name() or "unknown"
   dbg.start("BuildTarget.exec(\"",name,")")
   local masterTbl   = masterTbl()
   local envVarsTbl  = {}
   local target      = masterTbl.target or getenv('TARGET') or ''
   local t           = getUname()

   masterTbl.envVarsTbl  = envVarsTbl

   readDotFiles()
   local targetList = masterTbl.targetList
   local familyTbl  = masterTbl.familyTbl
   local targetTbl = {}

   targetList[#targetList+1] = "extra"
   for i,v in ipairs(targetList) do
      targetTbl[v] = i
   end

   local tbl = M.buildTbl(targetTbl)
   
   string2Tbl(concatTbl(masterTbl.pargs," ") or '',tbl)
   processModuleTable(shell:getMT(ModuleTable), targetTbl, tbl)

   -- Remove options from TARG_EXTRA

   for i = 1,#masterTbl.remOptions do
      local rem = masterTbl.remOptions[i]
      dbg.print("remove opt: ",rem,"\n")
      local t = tbl.TARG_EXTRA 
      if (next(t) ~= nil) then
         t[rem] = nil
      end
   end

   if (next(tbl.TARG_EXTRA) == nil or masterTbl.purgeFlag) then
      tbl.TARG_EXTRA               = false
      tbl.TARG_EXTRA_ENCODED_ARRAY = false
   else
      local t = tbl.TARG_EXTRA
      local a = {}
      local b = {}
      for k in pairsByKeys(t) do
         a[#a+1] = k
         b[#b+1] = encode64(k)
      end
      tbl.TARG_EXTRA               = concatTbl(a,"_")
      tbl.TARG_EXTRA_ENCODED_ARRAY = concatTbl(b,":")
   end

   local a = {}
   for _,v in ipairs(targetList) do
      local K     = "TARG_" .. v:upper()
      local KK    = K .. "_FAMILY"
      local entry = tbl[K]
      if (not entry) then
         envVarsTbl[KK] = false
      else
         a[#a + 1]   = entry
         if (familyTbl[v]) then
            local value    = entry:gsub("-.*","")
            envVarsTbl[KK] = value
            dbg.print("envVarsTbl[",KK,"]: ",value,"\n")
         end
      end
   end


   for k in pairs(tbl) do
      envVarsTbl[k] = tbl[k]
   end

   target = concatTbl(a,"_")
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
         if (s) then
            if (TitleTbl[name] and version ~= "" ) then
               s = TitleTbl[name] .. "-" .. version
            end
            aa[#aa+1] = s
         end
      end
   end
   local s                          = concatTbl(aa," "):trim()
   local paren                      = ""
   if (s ~= "") then
      paren                         = "("..s..")"
   end
   envVarsTbl.TARG_TITLE_BAR        = s
   envVarsTbl.TARG_TITLE_BAR_PAREN  = paren

   if (masterTbl.destroyFlag) then
      for k in pairs(envVarsTbl) do
         envVarsTbl[k] = ""
      end
      -------------------------------------------------------
      -- For csh users this variable must have value.
      envVarsTbl.TARG_TITLE_BAR_PAREN  = " "
   end


   dbg.fini()
end

return M
