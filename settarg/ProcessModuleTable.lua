-- $Id$ --
require("strict")
_ModuleTable_ = ""
local Dbg     = require("Dbg")
local systemG = _G
local load    = (_VERSION == "Lua 5.1") and loadstring or load

local function buildTargetName(name, defaultFlag, fullName)
   local result = name
   result = fullName
   result = result:gsub("/","-")
   result = result:gsub("_","-")

   return result
end

function processModuleTable(mt_string, targetTbl, tbl)
   local dbg = Dbg:dbg()
   dbg.start("processModuleTable(mt_string, targetTbl, tbl)")
   if (mt_string == nil) then return end
   assert(load(mt_string))()
   local mt        = systemG._ModuleTable_

   local masterTbl     = masterTbl()
   local stringKindTbl = masterTbl.stringKindTbl

   if (mt.version == 1) then
      local defaultA     = mt.active.default
      local fullModNameA = mt.active.fullModName
      for i,v in ipairs(mt.active.Loaded) do
         local key = stringKindTbl[v]
         if (targetTbl[key]) then
            targetTbl[key] = -1
            local K = "TARG_" .. key:upper()
            tbl[K] = buildTargetName(v, defaultA[i], fullModNameA[i])
            dbg.print("V1: K: ",K, " tbl[K]: ",tbl[K],"\n")
         end
      end
   elseif (mt.version == 2) then
      local mT = mt.mT
      for sn,v in pairs(mT) do
         local key = stringKindTbl[sn]
         if (v.status == "active" and targetTbl[key] ) then
            targetTbl[key] = -1
            local K = "TARG_" .. key:upper()
            tbl[K] = buildTargetName(sn, v.default, v.fullName)
            dbg.print("V2: K: ",K, " tbl[K]: ",tbl[K],"\n")
         end
      end
   end
   

   for k in pairs(targetTbl) do
      if (targetTbl[k] ~= -1) then
         dbg.print("Clearing k: ",k," targetTbl[k]: ", tostring(targetTbl[k]), "\n")
         local K = "TARG_" .. k:upper()
         tbl[K] = ''
      end
   end
   dbg.fini()
end
