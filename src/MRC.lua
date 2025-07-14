-- Site create .modulerc files to specify that certain strings can be
-- also know as.  Here are some examples:
--
-- In the intel/ directory there might be a .modulerc file that can
-- contain:
--
--    #%Module
--    module-version intel/15.0.3 default 15.0 15
--    module-version /14.0.1 default 14.0 14
--
-- Note that a leading slash means that it matches the directory name
-- (i.e. intel).  There can only be one default.  In this case the last
-- one controls.
--
--
-- @classmod MRC

_G._DEBUG      = false
local posix    = require("posix")
require("strict")

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

require("fileOps")
require("utils")
require("mrc_load")
require("deepcopy")

local M         = {}
local dbg       = require("Dbg"):dbg()
local cosmic    = require("Cosmic"):singleton()
local concatTbl = table.concat
local getenv    = os.getenv
local load      = (_VERSION == "Lua 5.1") and loadstring or load
local s_MRC     = false
local hook      = require("Hook")

local pack      = (_VERSION == "Lua 5.1") and argsPack or table.pack  -- luacheck: compat

------------------------------------------------------------------------
-- Local functions
local l_build
--------------------------------------------------------------------------
-- a private ctor that is used to construct a singleton.
-- @param self A MRC object.

local function l_new(self, fnA)
   dbg.start{"MRC l_new(fnA)"}
   local o               = {}
   o.__mpathT            = {}  -- mpath dependent values for alias2modT, version2modT
                               -- and hiddenT.
   o.__version2modT      = {}  -- Map a sn/version string to a module fullname
   o.__alias2modT        = {}  -- Map an alias string to a module name or alias
   o.__fullNameDfltT     = {}  -- Map for fullName (in pieces) to weights
   o.__defaultT          = {}  -- Map module sn to fullname that is the default.

   o.__forbiddenT        = {}  -- Table of forbidden modules
                               -- from LMOD_MODULERC files only
   o.__hiddenT           = {}  -- Table of hidden modules
                               -- from LMOD_MODULERC files only
   o.__mod2versionT      = false  -- Map from full module name to versions.
   o.__full2aliasesT     = false
   setmetatable(o,self)
   self.__index = self

   l_build(o, fnA or getModuleRCT())
   dbg.fini("MRC l_new")
   return o
end


--------------------------------------------------------------------------
-- A singleton Ctor for the MRC class
-- @param self A MRC object.

local s_Epoch        = nil
local s_Is_dst       = nil
local s_Show_HiddenT = nil
local s_displayMode  = nil
function M.singleton(self, fnA)
   dbg.start{"MRC:singleton()"}
   if (not s_MRC) then
      s_MRC = l_new(self, fnA)
   end
   if (not s_Epoch) then
      s_Epoch  = math.floor(epoch())
      local tm = posix.localtime(s_Epoch)
      s_Is_dst = tm.is_dst
   end

   if (not s_Show_HiddenT) then
      s_Show_HiddenT = s_MRC:sane_show_hidden()
   end

   dbg.fini("MRC:singleton")
   return s_MRC
end

local s_tmTransT = {
   is_dst   = true,
   tm_hour  = "hour",
   tm_isdst = "is_dst",
   tm_mday  = "monthDay",
   tm_min   = "min",
   tm_mon   = "month",
   tm_sec   = "sec",
   tm_wday  = "weekday",
   tm_yday  = "yearday",
   tm_year  = "year",
}
   
local function l_convertOldtm(tm)
   local t = {}
   if (tm.tm_mon) then
      for k, v in pairs(tm) do
         t[k] = v
         local key = s_tmTransT[k]
         if (key) then
            t[key] = v
         end
      end
      t.year = 1900 + t.year
   else
      t = tm
   end
   return t
end

local function l_convertStr2TM(tStr, tm, is_dst)
   if (not tStr:find("T")) then
      tStr = tStr .. "T00:00"
   end
   local d = posix.strptime(tStr,"%Y-%m-%dT%H:%M")
   for k,v in pairs(d) do
      tm[k] = v
   end
   tm.is_dst = is_dst
end

local function l_convertTimeStr_to_epoch(tStr)
   if (posix.strptime == nil or posix.mktime == nil) then
      LmodError{msg="e_Newer_posix_reqd"}
   end

   local tm = {}
   local ok, msg = pcall(l_convertStr2TM, tStr, tm, s_Is_dst)
   if (not ok) then
      LmodError{msg="e_Malformed_time",tStr = tStr}
   end
   dbg.print{"tStr: ",tStr,"\n"}
   dbg.printT("tm", tm)
   tm = l_convertOldtm(tm)
   return posix.mktime(tm)
end



function M.__clear(self)
   --dbg.start{"MRC:__clear()"}
   s_MRC = nil
   --dbg.fini("MRC:__clear")
end

function l_build(self, fnA)
   dbg.start{"MRC l_build(self,fnA)"}
   --dbg.printT("fnA",fnA)
   for i = 1, #fnA do
      local fn     = fnA[i][1]
      if (isFile(fn)) then
         local weight = fnA[i][2]
         local modA   = mrc_load(fn)
         self:parseModA(modA, weight)
      end
   end
   dbg.fini("MRC l_build")
end

local function l_save_su_weights(self, fullName, weight)
   local a = {}
   local n = 0
   for s in fullName:split("/") do
      n    = n + 1
      a[n] = s
   end

   local function l_su_weight_helper(i,n,a,t,weight)
      local s = a[i]
      t[s] = t[s] or {}
      if (i == n) then
         t[s].weight = weight
         return
      else
         t[s].tree   = t[s].tree or {}
         l_su_weight_helper(i+1,n,a,t[s].tree, weight)
      end
   end

   l_su_weight_helper(1,n,a,self.__fullNameDfltT,weight)
end

function M.parseModA(self, modA, weight)
   dbg.start{"MRC:parseModA(modA, weight: \"",weight,"\")"}

   for i = 1,#modA do
      repeat
         local entry = modA[i]
         if (entry.action == "module_version") then
            local fullName = entry.module_name
            fullName = self:resolve({}, fullName)

            local _, _, shorter, mversion = fullName:find("(.*)/(.*)")
            if (shorter == nil) then
               LmodWarning{msg="w_Broken_FullName", fullName= fullName}
               break
            end

            local a = entry.module_versionA
            for j = 1,#a do
               local version = a[j]
               if (version == "default") then
                  l_save_su_weights(self, fullName, weight)
               else
                  local key = shorter .. '/' .. version
                  self.__version2modT[key] = fullName
               end
            end
         elseif (entry.action == "module_alias") then
            self.__alias2modT[entry.name] = entry.mfile
         elseif (entry.action == "hide_version") then
            self.__hiddenT[entry.mfile] = {kind="hidden"}
         elseif (entry.action == "hide_modulefile") then
            self.__hiddenT[entry.mfile] = {kind="hidden"}
         elseif (entry.action == "hide") then
            self.__hiddenT[entry.name] = entry
         elseif (entry.action == "forbid") then
            self.__forbiddenT[entry.name] = entry
         end
      until true
   end
   dbg.fini("MRC:parseModA")
end

local function l_build_reverse_maps_from_v2mT(self, mpath, v2mT)
   dbg.start{"MRC:l_build_reverse_maps_from_v2mT(mpath: ",mpath,")"}
   local t    = {}
   local m2vT = {}
   local f2aT = {}
   local mpathA = {mpath}

   dbg.printT("RTM v2mT",v2mT)

   for k, v in pairs(v2mT) do
      local key = self:resolve(mpathA, v)
      local tt  = t[key] or {}
      tt[k]     = true
      t[key]    = tt
   end
   --dbg.printT("RTM t",t)
   for modname, vv in pairsByKeys(t) do
      local a = {}
      local b = {}
      for k in pairsByKeys(vv) do
         a[#a+1] = k:gsub("^.*/","")
         b[#b+1] = k
      end
      local s = concatTbl(a,":")
      m2vT[modname] = s
      f2aT[modname] = b
   end

   dbg.printT("m2vT", m2vT)

   dbg.fini("MRC:l_build_reverse_maps_from_v2mT")
   return m2vT, f2aT
end


local function l_build_m2vT_f2aT(self, mpath)
   dbg.start{"l_build_m2vT_f2aT(self, mpath)"}
   if (not self.__mod2versionT) then
      self.__mod2versionT, self.__full2aliasesT =
         l_build_reverse_maps_from_v2mT(self, mpath, self.__version2modT)
   end

   if (not self.__mpathT[mpath]) then
      self.__mpathT[mpath] = {}
   end
   if (not self.__mpathT[mpath].mod2versionT) then
      self.__mpathT[mpath].mod2versionT, self.__mpathT[mpath].full2aliasesT =
         l_build_reverse_maps_from_v2mT(self, mpath, self.__mpathT[mpath].version2modT or {})
   end
   dbg.fini("l_build_m2vT_f2aT")
end

local function l_findKeyA(self, mpathA, tbl_kind)
   local a = {}
   local t = {}
   local kindT = "__" .. tbl_kind
   for k in pairs(self[kindT]) do
      if (not t[k]) then
         a[#a+1] = k
         t[k] = true
      end
   end
   for i = #mpathA, 1, -1 do
      local mpath = mpathA[i]
      if (self.__mpathT[mpath]) then
         local tt = self.__mpathT[mpath][tbl_kind]
         if (tt) then
            for k in pairs(tt) do
               if (not t[k]) then
                  a[#a+1] = k
                  t[k] = true
               end
            end
         end
      end
   end
   table.sort(a)
   return a
end

function M.pairsForMRC_aliases(self, mpathA)
   local a = l_findKeyA(self, mpathA, "alias2modT")

   local i = 0
   local iter = function ()
      i = i + 1
      local ans = nil
      local k   = a[i]
      if (k == nil) then return nil end
      ans = self.__alias2modT[k]
      if (not ans) then
         for i = #mpathA, 1, -1 do
            local mpath = mpathA[i]
            if (self.__mpathT[mpath]) then
               local tt = self.__mpathT[mpath].alias2modT
               if (tt and tt[k]) then
                  ans = tt[k]
               end
            end
         end
      end
      return k, ans
   end
   return iter
end

local function l_find_alias_value(tblName, t, mrcMpathT, mpathA, key)
   local value = t[key]
   if (value) then
      return value
   end
   for i = 1, #mpathA  do
      local mpath = mpathA[i]
      if (mrcMpathT[mpath] and mrcMpathT[mpath][tblName]) then
         value = mrcMpathT[mpath][tblName][key]
         if (value) then
            return value
         end
      end
   end
   return value
end

function M.resolve(self, mpathA, name)
   local value = l_find_alias_value("alias2modT", self.__alias2modT, self.__mpathT, mpathA, name)
   --dbg.print{"MRC:resolve: (1) name: ",name,", value: ",value,"\n"}
   if (value ~= nil) then
      name  = value
      value = self:resolve(mpathA, value)
   end

   value = l_find_alias_value("version2modT", self.__version2modT, self.__mpathT, mpathA, name)
   --dbg.print{"MRC:resolve: (2) name: ",name,", value: ",value,"\n"}
   if (value == nil) then
      value = name
   else
      name  = value
      value = self:resolve(mpathA, value)
   end
   return value
end

function M.search_mapT(self, tbl_kind, mpath, key)
   dbg.start{"MRC:search_mapT(", tbl_kind,", mpath: ",mpath,", key: ",key,")"}
   l_build_m2vT_f2aT(self, mpath)
   local ans = self["__"..tbl_kind][key] or self.__mpathT[mpath][tbl_kind][key]
   dbg.fini("MRC:search_mapT")
   return ans
end

local function l_store_mpathT(self, mpath, tblName, key, value)
   if ( not self.__mpathT[mpath] ) then
      self.__mpathT[mpath] = {}
   end
   if ( not self.__mpathT[mpath][tblName] ) then
      self.__mpathT[mpath][tblName] = {}
   end
   self.__mpathT[mpath][tblName][key] = value
end


function M.parseModA_for_moduleA(self, name, mpath, modA)
   dbg.start{"MRC:parseModA_for_moduleA(name: ",name,", mpath: ",mpath,", modA)"}
   local defaultV = false
   for i = 1,#modA do
      local entry = modA[i]
      --dbg.print{"entry.action: ",entry.action, "\n"}

      if (entry.action == "module_version") then
         local fullName = entry.module_name
         if (fullName:sub(1,1) == '/') then
            fullName = name .. fullName
         end
         fullName = self:resolve({mpath}, fullName)
         --dbg.print{"resolve(fullName): ",fullName, "\n"}
         --dbg.print{"(2) fullName: ",fullName, "\n"}

         local a = entry.module_versionA
         for j = 1,#a do
            local version = a[j]
            --dbg.print{"j: ",j, ", version: ",version, "\n"}
            if (version == "default") then
               --dbg.print{"Setting default: ",fullName, "\n"}
               defaultV = fullName
            else
               local _, _, shorter, mversion = fullName:find("(.*)/(.*)")
               if (shorter) then
                  local key = shorter .. '/' .. version
                  l_store_mpathT(self, mpath, "version2modT", key, fullName);
                  --dbg.print{"v2m: key: ",key,": ",fullName,"\n"}
               end
            end
         end
      elseif (entry.action == "set_default_version") then
         --dbg.print{"version: ",entry.version,"\n"}
         defaultV = entry.version
      elseif (entry.action == "module_alias") then
         local fullName = entry.name
         if (fullName:sub(1,1) == '/') then
            fullName = name .. fullName
         end
         local mfile = entry.mfile
         --dbg.print{"fullName: ",fullName,", mfile: ", mfile,"\n"}
         l_store_mpathT(self, mpath, "alias2modT", fullName, mfile);
      elseif (entry.action == "hide_version" or entry.action == "hide_modulefile") then
         --dbg.print{"mfile: ", entry.mfile,"\n"}
         l_store_mpathT(self, mpath, "hiddenT", entry.mfile, {kind = "hidden"});
      elseif (entry.action == "hide") then
         l_store_mpathT(self, mpath, "hiddenT", entry.name, entry);
      elseif (entry.action == "forbid") then
         l_store_mpathT(self, mpath, "forbiddenT", entry.name, entry);
      end
   end
   dbg.fini("MRC:parseModA_for_moduleA")
   return defaultV
end


function M.fullNameDfltT(self)
   return self.__fullNameDfltT
end

function M.mrcMpathT(self)
   return self.__mpathT
end

function M.extract(self)
   local t = { hiddenT      = self.__hiddenT,
               version2modT = self.__version2modT,
               alias2modT   = self.__alias2modT,
   }
   return t, self.__mpathT
end
function M.export(self)
   local t, mrcMpathT = self:extract()
   local a = {}
   --a[1] = serializeTbl{indent = true, name = "mrcT",      value = t         }
   --a[2] = serializeTbl{indent = true, name = "mrcMpathT", value = mrcMpathT }
   --return concatTbl(a,"\n")
   return serializeTbl{indent = true, name = "mrcMpathT", value = mrcMpathT }
end

local function l_find_resultT(self, tbl_kind, replaceT, mpath, wantedA)
   dbg.start{"MRC:l_find_resultT( tbl_kind, replaceT, mpath, wantedA)"}
   local resultT = false
   local Tkind   = "__" .. tbl_kind
   local tt      = {}
   local ttt     = self[Tkind] or {}

   if (self.__mpathT[mpath] and self.__mpathT[mpath][tbl_kind]) then
      tt  = self.__mpathT[mpath][tbl_kind]
   end
   dbg.print{"mpath: ",mpath,"\n"}
   dbg.printT("wantedA",wantedA)
   dbg.printT("ttt", ttt)
   dbg.printT("tt", tt)
   dbg.printT("mpathT", self.__mpathT)

   local mpathA = {mpath}
   for i = 1,#wantedA do
      local wanted = wantedA[i]
      local key    = self:resolve(mpathA, wanted)
      local ans    = ttt[key] or tt[key]
      if (ans) then
         if (type(ans) == "table") then
            resultT = ans
         else
            resultT = replaceT
         end
         dbg.printT("resultT",resultT)
         dbg.fini("MRC:l_find_resultT")
         return resultT
      end
   end
   dbg.fini("MRC:l_find_resultT (false)")
   return resultT
end

local function l_findHiddenState(self, modT)
   dbg.start{"l_findHiddenState(self, modT)"}
   local fn      = modT.fn
   local sn      = modT.sn
   local wantedA = { modT.sn, modT.fullName, fn, ((fn or ""):gsub("%.lua$","")) }
   local _
   local n = modT.fullName
   while (n and n ~= sn) do
      _, _, n = n:find("(.*)/.*")
      wantedA[#wantedA + 1] = n
   end

   local resultT = l_find_resultT(self, "hiddenT", {kind = "hidden"}, modT.mpath, wantedA)

   -- Apply isVisibleHook, convert false isVisible flag to resultT.
   if (hook.exists("isVisibleHook")) then
      modT.isVisible = true
      hook.apply("isVisibleHook", modT)
      if (not modT.isVisible) then
         resultT        = resultT or {}
         resultT.kind   = "hidden"
         resultT.name   = modT.fullName
      end
   end

   dbg.fini("MRC:l_findHiddenState")
   return resultT
end

local function l_findForbiddenState(self, mpath, sn, fullName, fn)
   dbg.start{"l_findForbiddenState(self, mpath, sn, fullName:",fullName,", fn)"}
   local wantedA = { sn, fullName, fn, ((fn or ""):gsub("%.lua$","")) }
   local _
   local n = fullName
   while (n and n ~= sn) do
      _, _, n = n:find("(.*)/.*")
      wantedA[#wantedA + 1] = n
   end
   local resultT = l_find_resultT(self, "forbiddenT", {}, mpath, wantedA)

   dbg.fini("l_findForbiddenState")
   return resultT or {}
end

function M.import(self, mrcMpathT)
   dbg.start{"MRC:import()"}
   if (mrcMpathT and next(mrcMpathT) ~= nil) then
      for mpath, v in pairs(mrcMpathT) do
         for tblName, vv in pairs(v) do
            for key, value in pairs(vv) do
               l_store_mpathT(self, mpath, tblName, key, value)
            end
         end
      end
   end
   dbg.print{"mrcMpathT :",self.__mpathT,"\n"}
   self:update()
   dbg.fini("MRC:import")
end

local function l_intersection(myArray, myTable)
   local match = false
   for i = 1,#myArray do
      if (myTable[myArray[i]]) then
         match = true
         break
      end
   end
   return match
end

local function l_check_time_range(resultT, nearlyDays)
   local T_start  = math.mininteger or 0
   local T_end    = math.maxinteger or math.huge

   local T_before = (resultT.before) and l_convertTimeStr_to_epoch(resultT.before) or T_end
   local T_after  = (resultT.after)  and l_convertTimeStr_to_epoch(resultT.after)  or T_start

   if (s_Epoch <= T_before and  s_Epoch >= T_after) then
      return "inRange"
   end
   if (s_Epoch + nearlyDays * 86400 >= T_after) then
      return "nearly"
   end
   return "notActive"
end

local function l_check_user_groups(resultT)
   local usrFlg  = resultT.userT     and resultT.userT[myConfig("username")]
   local grpFlg  = resultT.groupT    and l_intersection(myConfig("usergroups"),resultT.groupT)
   local nUsrFlg = resultT.notUserT  and resultT.notUserT[myConfig("username")]
   local nGrpFlg = resultT.notGroupT and l_intersection(myConfig("usergroups"),resultT.notGroupT)

   local flag    = (usrFlg or grpFlg) or (not (resultT.userT or resultT.groupT) and
                                       not (nUsrFlg or nGrpFlg))

   --dbg.print{"l_check_user_groups: usrFlg: ",usrFlg,", nUsrFlg: ",nUsrFlg,"\n"}
   --dbg.print{" flag: ",flag,"\n"}

   return flag
end


local time2FstateT = {
   inRange   = "forbid",
   nearly    = "nearly",
   notActive = "normal",
}

local function l_check_forbidden_modifiers(fullName, resultT)
   dbg.start{"l_check_forbidden_modifiers(fullName, resultT)"}

   local forbiddenState = "normal"

   if (l_check_user_groups(resultT)) then
      local nearlyDays = cosmic:value("LMOD_NEARLY_FORBIDDEN_DAYS")
      local timeFlag   = l_check_time_range(resultT, nearlyDays)
      forbiddenState   = time2FstateT[timeFlag]
   end

   dbg.fini("l_check_forbidden_modifiers")
   return forbiddenState
end

local function l_check_hidden_modifiers(fullName, resultT, visibleT, show_hidden)
   dbg.start{"l_check_hidden_modifiers(fullName, resultT, visibleT, show_hidden)"}
   local count         = false
   local hide_active   = (l_check_time_range(resultT, 0) == "inRange" and
                          l_check_user_groups(resultT))


   if (not hide_active) then
      dbg.fini("l_check_hidden_modifiers")
      --     isVisible, hidden_loaded, kind,     count
      return true,      false,         "normal", true
   end
   local isVisible
   if (show_hidden) then
      isVisible = (resultT.kind ~= "hard")
      count     = isVisible
   else
      isVisible = (visibleT[resultT.kind] ~= nil)
   end


   --dbg.print{"fullName: ",fullName,", resultT.kind: ", resultT.kind, ", count: ",count,"\n"}
   dbg.fini("l_check_hidden_modifiers")
   return isVisible, resultT.hidden_loaded, resultT.kind, count
end


-- modT is a table with: sn, fullName and fn
function M.isVisible(self, modT)
   dbg.start{"MRC:isVisible(modT}"}
   local frameStk      = require("FrameStk"):singleton()
   local mt            = frameStk:mt()
   local mpathA        = modT.mpathA or mt:modulePathA()
   local mpath         = modT.mpath
   local fullName      = modT.fullName
   local fn            = modT.fn
   local sn            = modT.sn
   local show_hidden   = self:show_hidden()
   local isVisible     = true
   local visibleT      = modT.visibleT or {}
   local kind          = "normal"
   local hidden_loaded = false
   local count         = false
   local my_resultT    = nil
   ------------------------------------------------------------
   -- resultT is nil if the modulefile is normal or
   -- {kind="hidden|soft|hard"
   --   before="<time>" after="<time>",
   --   hidden_loaded = true|nil, }
   -- if hidden.

   modT.mname = frameStk:mname()
   modT.mt    = mt

   ------------------------------------------------------------
   -- If sn is already in the ModuleTable then use MT data instead

   dbg.print{"fullName: ",fullName,"\n"}
   dbg.printT("visibleT",visibleT)


   if (mt:exists(sn,fullName)) then
      local moduleKindT = mt:moduleKindT(sn)
      if (not moduleKindT) then
         my_resultT = { isVisible = true, count = true, moduleKindT = {kind = "normal" }}
      else
         my_resultT = { isVisible = show_hidden or visibleT[moduleKindT.kind], count = true, moduleKindT = moduleKindT }
      end
      dbg.printT("mt:exists(sn): true, my_resultT",my_resultT)
      dbg.fini("(1) MRC:isVisible")
      return my_resultT
   end


   local resultT     = l_findHiddenState(self, modT)
   dbg.print{"RTM type(resultT): ",type(resultT),"\n"}
   if (type(resultT) == "table" ) then
      dbg.printT("from hidden State resultT",resultT)
      isVisible, hidden_loaded, kind, count = l_check_hidden_modifiers(fullName, resultT, visibleT, show_hidden)
      dbg.print{"(1)isVisible: ",isVisible,"\n"}
   elseif (fullName:sub(1,1) == ".") then
      isVisible = (visibleT.hidden == true or show_hidden)
      count     = show_hidden
      kind      = "hidden"
      dbg.print{"(2)isVisible: ",isVisible,"\n"}
   else
      local idx = fullName:find("/%.")
      isVisible = (idx == nil) or (visibleT.hidden == true) or show_hidden
      kind      = (idx == nil) and "normal" or "hidden"
      count     = show_hidden or (idx == nil)
      dbg.print{"(3)isVisible: ",isVisible,"\n"}
   end

   my_resultT       = { isVisible = isVisible,
                        moduleKindT = {kind=kind, hidden_loaded = hidden_loaded},
                        count = count }

   dbg.print{"fullName: ",fullName,", isVisible: ",isVisible,", kind: ",kind,", show_hidden: ", show_hidden,", count: ",count,", hidden_loaded: ",hidden_loaded,"\n"}
   dbg.printT("my_resultT",my_resultT)
   dbg.fini("(2) MRC:isVisible")
   return my_resultT
end

function M.isForbidden(self, modT)
   --dbg.start{"MRC:isForbidden(modT}"}
   local frameStk     = require("FrameStk"):singleton()
   local mname        = frameStk:mname()
   local mt           = frameStk:mt()
   local mpath        = modT.mpath
   local fullName     = modT.fullName
   local fn           = modT.fn
   local sn           = modT.sn

   assert(mpath,"WTF")

   local resultT      = l_findForbiddenState(self, mpath, sn, fullName, fn)

   --dbg.print{"fullName: ",fullName,"\n"}
   --dbg.printT("resultT",resultT)

   if (resultT.action ~= "forbid") then
      --dbg.fini("MRC:isForbidden")
      return nil
   end

   local forbiddenState = l_check_forbidden_modifiers(fullName, resultT)

   modT.forbiddenState = forbiddenState
   modT.mname          = mname
   modT.mt             = mt
   modT.message        = resultT.message
   modT.nearlymessage  = resultT.nearlymessage
   hook.apply("isForbiddenHook",modT)

   local my_resultT  = {forbiddenState = modT.forbiddenState, message = modT.message,
                        nearlymessage = modT.nearlymessage, after = resultT.after}

   --dbg.fini("MRC:isForbidden")
   return my_resultT
end

function M.update(self, fnA)
   --dbg.start{"MRC:update(fnA)"}
   fnA = fnA or getModuleRCT()
   l_build(self,fnA)
   --dbg.fini("MRC:update")
end

function l_find_all_su_defaults(k, t, b, resultA)
   b[#b+1] = k
   if (t.tree) then
      t = t.tree
      for kk, v in pairs(t) do
         l_find_all_su_defaults(kk,v,deepcopy(b), resultA)
      end
   elseif (t.weight) then
      resultA[#resultA+1] = { version = concatTbl(b,"/"), weight = t.weight}
   else
      LmodError{msg="e_SU_defaults"}
   end
end

function M.find_wght_for_fullName(self, fullName, wV)
   dbg.start{"MRC:find_wght_for_fullName(fullName: \"",fullName,")"}
   local t = self.__fullNameDfltT
   if (not fullName) then
      dbg.fini("MRC:find_wght_for_fullName: no fullName")
      return wV
   end


   -- split fullName into an array on '/' --> fnA
   local fnA = {}
   local n   = 0
   for s in fullName:split("/") do
      n      = n + 1
      fnA[n] = s
   end

   -- if fnA  has no parts then quit.
   if (n < 1) then
      dbg.fini("MRC:find_wght_for_fullName: fnA has no parts")
      return wV
   end

   -- Search thru t to see if fullName is marked with (su) defaults
   local found = false
   for i = 1, n do
      local s = fnA[i]
      if (t[s]) then
         t = t[s].tree or t[s]
         found = (i == n)
      end
   end

   if (not found) then
      dbg.fini("MRC:find_wght_for_fullName: not found")
      return wV
   end

   local weight = t.weight
   local idx    = wV:match("^.*()/")
   if (weight) then
      if (idx) then
         wV = wV:sub(1,idx) .. weight .. wV:sub(idx+2,-1)
      else
         wV = weight .. wV:sub(2,-1)
      end
   end

   dbg.print{"found weight: ",weight,", wV: ",wV,"\n"}
   dbg.fini("MRC:find_wght_for_fullName")
   return wV
end


function M.applyWeights(self, sn, fileA)
   dbg.start{"MRC:applyWeights(sn: \"",sn,"\", fileA)"}
   local t = self.__fullNameDfltT

   if (not (sn and fileA and next(fileA) ~= nil)) then
      dbg.fini("MRC:applyWeights via no sn or fileA")
      return
   end

   dbg.printT("fullNameDfltT: ", t)


   -- split sn into an array on '/' --> snA
   local snA = {}
   local n = 0
   for s in sn:split("/") do
      n      = n + 1
      snA[n] = s
   end

   -- if snA  has no parts then quit.
   if (n < 1) then
      return
   end


   -- Search thru t to see if sn is a marked (su) defaults
   local found = false
   for i = 1, n do
      local s = snA[i]
      if (t[s]) then
         t = t[s].tree or t[s]
         found = (i == n)
      end
   end

   -- If not found then there are no marked (su) defaults.
   if (not found) then
      dbg.fini("MRC:applyWeights sn not found")
      return
   end


   -- search thru self.__fullNameDfltT that has our sn for marked su defaults
   -- resultA looks like:
   -- resultA = { {version = "14.1", weight = "u"}, { version = "12.1", weight = "s"}, }

   local resultA = {}
   for k, v in pairs(t) do
      l_find_all_su_defaults(k,v,{},resultA)
   end

   dbg.printT("resultA",resultA)
   -- Now use resultA to mark su defaults in fileA

   for k = 1,#fileA do
      local blockA = fileA[k]
      for j = 1,#blockA do
         local entry   = blockA[j]
         local version = entry.version
         for i = 1, #resultA do
            local suEntry = resultA[i]
            if (version == suEntry.version) then
               local weight = suEntry.weight
               local idx    = entry.wV:match("^.*()/")
               if (idx) then
                  entry.wV = entry.wV:sub(1,idx) .. weight .. entry.wV:sub(idx+2,-1)
               else
                  entry.wV = weight .. entry.wV:sub(2,-1)
               end
            end
         end
      end
   end
   dbg.printT("fileA: ", fileA)
   dbg.fini("MRC:applyWeights")
end

function M.set_display_mode(self,kind)
   s_displayMode = kind
end

local s_validT = {
   no     = "no",
   yes    = "all",
   all    = "all",
   spider = "spider",
   list   = "list",
   avail  = "avail",
}

function M.sane_show_hidden(self)
   local showH = (cosmic:value("LMOD_SHOW_HIDDEN") or "no"):lower()
   local showHiddenT = {}
   if (showH:find(":")) then
      local a = path2pathA(showH)
      for i = 1,#a do
         local v = s_validT[a[i]] or "all"
         showHiddenT[v] = true
      end
   else
      showHiddenT[s_validT[showH] or "all"] = true
   end
   return showHiddenT
end

function M.show_hidden()
   assert(s_displayMode, "display mode not set!")
   return s_Show_HiddenT["all"] or s_Show_HiddenT[s_displayMode]
end


return M
