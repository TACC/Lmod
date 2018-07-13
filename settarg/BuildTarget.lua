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
_G._DEBUG         = false
local posix       = require("posix")

require("strict")
require("getUname")
require("string_utils")
require("fileOps")
require("utils")
require("ProcessModuleTable")
require("pairsByKeys")

_G._DEBUG         = false               -- Required by the new lua posix
local TargValue   = require("TargValue")
local dbg         = require("Dbg"):dbg()
local STT         = require("STT")
local base64      = require("base64")
local concatTbl   = table.concat
local decode64    = base64.decode64
local encode64    = base64.encode64
local getenv      = posix.getenv
local load        = (_VERSION == "Lua 5.1") and loadstring or load
local systemG     = _G
local ModuleTable = "_ModuleTable_"

local M          = {}

BuildScenarioTbl = {}
TitleTbl         = {}
ModuleTbl        = {}
TargetList       = {}
NoFamilyList     = {}
HostnameTbl      = {}
SettargDirTmpl   = {}
TargPathLoc      = "first"

function M.default_MACH()
   return getUname().machName
end

function M.default_OS()
   dbg.start{"BuildTarget:default_OS()"}
   local name = getUname().osName
   dbg.print{"name: ",name,"\n"}
   dbg.fini("BuildTarget:default_OS")
   return name
end

function M.default_HOST()
   local masterTbl = masterTbl()
   local hostTbl   = masterTbl.HostTbl
   local hostName  = getUname().hostName
   local hostA     = {}

   for v in hostName:split("%.") do
      hostA[#hostA+1] = v
   end
   local result   = hostA[1]
   if (#hostA == 1) then
      return result
   end

   local a = {}
   for i = 1,#hostTbl do
      local entry = tonumber(hostTbl[i])
      if (entry <= #hostA) then
         a[#a+1] = hostA[entry]
      end
   end

   if (#a > 0) then
      result = concatTbl(a,".")
   end
   return result
end


function M.default_BUILD_SCENARIO(tbl)
   dbg.start{"BuildTarget:default_BUILD_SCENARIO()"}
   local masterTbl        = masterTbl()
   local BuildScenarioTbl = masterTbl.BuildScenarioTbl
   local stt              = STT:stt()

   -------------------------------------------------------
   -- First look to see if there is TARG_BUILD_SCENARIO_STATE
   local v = stt:getBuildScenarioState()
   if (v ~= "unknown") then
      dbg.print{"STATE: ",v,"\n"}
      dbg.fini("BuildTarget:default_BUILD_SCENARIO")
      return v
   end


   -------------------------------------------------------
   -- Search over hostname first
   local t        = getUname()
   local hostname = t.hostName

   while (true) do
      v = BuildScenarioTbl[hostname]
      if (v) then
         dbg.print{"hostname: ", hostname," v: ",v,"\n"}
         dbg.fini("BuildTarget:default_BUILD_SCENARIO")
         stt:setBuildScenarioState(v)
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
      dbg.print{"machName v: ",v,"\n"}
      stt:setBuildScenarioState(v)
      dbg.fini("BuildTarget:default_BUILD_SCENARIO")
      return v
   end

   v = "empty"
   stt:setBuildScenarioState(v)
   dbg.print{"default v: ",v,"\n"}
   dbg.fini("BuildTarget:default_BUILD_SCENARIO")
   return v
end

local function string2Tbl(s,tbl)
   dbg.start{"string2Tbl(\"",s,"\", tbl)"}
   local stt           = STT:stt()
   local stringKindTbl = masterTbl().stringKindTbl
   for v in s:split("%s+") do
      local kindT  = stringKindTbl[v]
      if (kindT == nil) then
         if (v ~= "") then
            stt:add2ExtraT(v)
            dbg.print{"Adding \"",v,"\" to TARG_EXTRA\n"}
         end
      else
         for kind in pairs(kindT) do
            local K = "TARG_" .. kind:upper()
            if (K == "TARG_BUILD_SCENARIO") then
               stt:setBuildScenarioState(v)
            end
            dbg.print{"v: ",v," kind: ",kind," K: ",K,"\n"}
            tbl[K] = TargValue:new{value=v}
         end
      end
   end
   dbg.fini("string2Tbl")
end

function M.buildTbl(targetTbl)
   dbg.start{"BuildTarget.buildTbl(targetTbl)"}
   local tbl = {}
   local stt = STT:stt()

   for k in pairsByKeys(targetTbl) do
      local K   = k:upper()
      local key = "TARG_" .. K
      local v   = getenv(key)
      dbg.print{"key: ",key,", v: ",v,"\n"}
      if (v == nil) then
         local ss = "default_" .. K
         if (M[ss]) then
            v = M[ss](tbl)
         end
         dbg.print{"ss: ", ss," v: ",v,"\n"}
      end
      if (v) then
         tbl[key] = TargValue:new{value=v}
      end
   end

   -- Always set mach
   tbl.TARG_MACH           = TargValue:new{value=M.default_MACH()}
   tbl.TARG_MACH_DESCRIPT  = TargValue:new{value=getUname().machDescript}
   targetTbl.mach          = -1
   targetTbl.mach_descript = -1
   dbg.print{"M.default_MACH(): ",M.default_MACH(),"\n"}
   dbg.print{"tbl.TARG_MACH: ",tbl.TARG_MACH:display(),"\n"}



   -- Always set os and os_family
   local os_name       = M.default_OS()
   tbl.TARG_OS         = TargValue:new{value=os_name}
   tbl.TARG_OS_FAMILY  = TargValue:new{value=os_name:gsub("-.*","")}
   targetTbl.os        = -1
   targetTbl.os_family = -1

   -- Always set host
   tbl.TARG_HOST       = TargValue:new{value=M.default_HOST()}
   targetTbl.host      = -1

   -- Clear
   stt:clearEnv(tbl, targetTbl)

   local a = {"build_scenario","mach", "extra",}
   for _,v in ipairs(a) do
      if (targetTbl[v]) then
         targetTbl[v] = -1
      end
   end

   dbg.fini("BuildTarget.buildTbl")
   return tbl
end

local function readDotFiles()
   local masterTbl = masterTbl()

   -------------------------------------------------------
   -- Load system then user default table.
   local settarg_rc = getenv("LMOD_SETTARG_RC")
   if (not settarg_rc or not isFile(settarg_rc)) then
      settarg_rc = pathJoin(masterTbl.execDir,"settarg_rc.lua")
   end

   local a = { settarg_rc,
               pathJoin(getenv('HOME') or '',".settarg.lua"),
   }

   local projectConfig = findFileInTree(".settarg.lua")

   if (projectConfig ~= a[2]) then
      a[#a+1] = projectConfig
   end

   local SttgConfFnA    = {}
   local MethodMstrTbl  = {}
   local TitleMstrTbl   = {}
   local ModuleMstrTbl  = {}
   local stringKindTbl  = {}
   local familyTbl      = {}
   local HostTbl        = {}
   local SettargDirTmpl = {}
   local TargPathLoc    = "first"

   for _, fn  in ipairs(a) do
      repeat
         dbg.print{"fn: ",fn,"\n"}
         local f = io.open(fn,"r")
         if (f) then

            SttgConfFnA[#SttgConfFnA+1] = fn

            local whole  = f:read("*all")
            f:close()

            if (type(whole) ~= "string") then break end
            local ok
            local func, msg = load(whole)
            if (func) then
               ok, msg = pcall(func)
            else
               ok = false
            end

            if (not ok) then
               io.stderr:write("Error: Unable to load: ",fn,"\n",
                               "  ", msg,"\n");
               os.exit(1)
            end

            TargPathLoc = systemG.TargPathLoc

            for k,v in pairs(systemG.SettargDirTemplate) do
               SettargDirTmpl[k] = v
            end

            for k,v in pairs(systemG.BuildScenarioTbl) do
               dbg.print{"BS: k: ",k," v: ",v,"\n"}
               MethodMstrTbl[k] = v
            end

            for k,v in pairs(systemG.HostnameTbl) do
               HostTbl[k] = v
            end

            for k,v in pairsByKeys(systemG.TitleTbl) do
               dbg.print{"Title: k: ",k," v: ",v,"\n"}
               TitleMstrTbl[k] = v
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
      until true
   end

   masterTbl.TargPathLoc      = getenv("LMOD_SETTARG_TARG_PATH_LOCATION") or TargPathLoc
   masterTbl.HostTbl          = HostTbl
   masterTbl.TitleTbl         = TitleMstrTbl
   masterTbl.BuildScenarioTbl = MethodMstrTbl
   masterTbl.stringKindTbl    = stringKindTbl
   masterTbl.ModuleTbl        = ModuleMstrTbl
   masterTbl.targetList       = systemG.TargetList
   masterTbl.familyTbl        = familyTbl
   masterTbl.SettargDirTmpl   = SettargDirTmpl
   masterTbl.SttgConfFnA      = SttgConfFnA
end

function M.exec(shell)
   local shell_name  = shell:name() or "unknown"
   dbg.start{"BuildTarget.exec(\"",shell_name,")"}
   local masterTbl   = masterTbl()
   local envVarsTbl  = {}
   local target      = masterTbl.target or getenv('TARGET') or ''
   local t           = getUname()
   local stt         = STT:stt()

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
   processModuleTable(shell:getMT(), targetTbl, tbl)


   tbl.TARG_BUILD_SCENARIO = TargValue:new{value=stt:getBuildScenario()}
   --dbg.print{"BUILD_SCENARIO_STATE: ",stt:getBuildScenarioState(),"\n"}

   -- Remove options from TARG_EXTRA

   if (masterTbl.purgeFlag) then
      stt:purgeExtraT()
   else
      stt:removeFromExtra(masterTbl.remOptions)
   end

   tbl.TARG_EXTRA = TargValue:new{value=stt:getEXTRA()}

   local entryA = {}
   local a      = {}
   for _,v in ipairs(targetList) do
      local K     = "TARG_" .. v:upper()
      local KK    = K .. "_FAMILY"
      local entry = tbl[K]
      if (not entry) then
         envVarsTbl[KK] = false
      else
         entryA[#entryA + 1] = entry
         a[#a+1]             = entry:display(true)  -- The true says change '/' into '-'
         if (familyTbl[v]) then
            local t        = entry:value()
            envVarsTbl[KK] = t.sn
         end
      end
   end


   for k in pairs(tbl) do
      if (tbl[k]) then
         envVarsTbl[k] = tbl[k]:display()
      end
   end

   target = concatTbl(a,"_")
   target = target:gsub("_+","_")
   target = target:gsub("_$","")

   envVarsTbl.TARG_SUMMARY = target

   local SettargDirTmpl = masterTbl.SettargDirTmpl

   local b = {}

   for i = 1,#SettargDirTmpl do
      local n = SettargDirTmpl[i]
      if (n:sub(1,1) ~= "$") then
         b[#b+1] = n
      else
         n = n:sub(2,-1)
         if (n == "TARG_SUMMARY") then
            b[#b+1] = target
         else
            b[#b+1] = getenv(n) or ""
         end
      end
   end

   envVarsTbl.TARG         = concatTbl(b,"")
   if (envVarsTbl.TARG:sub(1,1) == "/") then
      envVarsTbl.TARG = "." .. envVarsTbl.TARG
   end

   local TitleTbl = masterTbl.TitleTbl

   -- Remove TARG_MACH when it is the same as the host.
   local mach = tbl.TARG_MACH:display()
   dbg.print{"TARG_MACH:",mach,", uname mach: ",getUname().machName,"\n"}
   if (mach == getUname().machName) then
      for i = 1,#entryA do
         local v = entryA[i]:display()
         if (v == mach) then
            table.remove(entryA,i)
            break
         end
      end
   end

   local aa = {}
   for i = 1,#entryA do
      local t     = entryA[i]:value()
      local name  = t.value or t.sn
      local tname = TitleTbl[name]
      local s     = tname or name
      if (s) then
         if (tname and t.version and t.version ~= "") then
            s = tname .. "/" .. t.version
         end
         aa[#aa+1] = s
      end
   end

   --local aa = {}
   --for _,v in ipairs(a) do
   --   local _, _, name, version = v:find("([^-]*)-?(.*)")
   --   if (v:len() > 0) then
   --      local s = TitleTbl[name] or v
   --      if (s) then
   --         if (TitleTbl[name] and version ~= "" ) then
   --            s = TitleTbl[name] .. "/" .. version
   --         end
   --         aa[#aa+1] = s
   --      end
   --   end
   --end
   local s                          = concatTbl(aa," "):trim()
   local paren_s                    = ""
   if (s ~= "") then
      paren_s                       = "("..s..")"
   end
   envVarsTbl.TARG_TITLE_BAR        = s
   envVarsTbl.TARG_TITLE_BAR_PAREN  = paren_s

   if (masterTbl.destroyFlag) then
      for k in pairs(envVarsTbl) do
         envVarsTbl[k] = ""
      end
      -------------------------------------------------------
      -- For csh users this variable must have value.
      envVarsTbl.TARG_TITLE_BAR_PAREN  = " "
   end

   if (envVarsTbl.TARG_TITLE_BAR_PAREN == "") then
      envVarsTbl.TARG_TITLE_BAR_PAREN = " "
   end

   stt:registerVars(envVarsTbl)
   local old_stt = getSTT() or ""
   local new_stt = stt:serializeTbl()
   if (old_stt ~= new_stt) then
      envVarsTbl._SettargTable_ = new_stt
   end
   dbg.fini("BuildTarget.exec")
end

return M
