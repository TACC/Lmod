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

require("inherits")
require("utils")
require("string_utils")

local FrameStk    = require("FrameStk")
local M           = {}
local MRC         = require("MRC")
local ModuleA     = require("ModuleA")
local MT          = require("MT")
local concatTbl   = table.concat
local cosmic      = require("Cosmic"):singleton()
local dbg         = require("Dbg"):dbg()
local sort        = table.sort
local s_findT     = false
local timer       = require("Timer"):singleton()

function M.className(self)
   return self.my_name
end

local function l_lessthan(a,b)
   return a < b
end

local function l_lessthan_equal(a,b)
   return a <= b
end

local s_rangeFuncT = { ["<="] = {func = l_lessthan_equal, name = "<="},
                       ["<"]  = {func = l_lessthan,       name = "<"},
                     }


function M.new(self, sType, name, action, is, ie)
   dbg.start{"Mname:new(",sType,", name: ",name,", action: ", action,")"}
   local exact_match = cosmic:value("LMOD_EXACT_MATCH")

   if (not s_findT) then
      local Match   = require("MN_Match")
      local Exact   = require("MN_Exact")
      local Latest  = require("MN_Latest")
      local Between = require("MN_Between")
      s_findT       = {
         exact   = Exact,
         match   = Match,
         latest  = Latest,
         between = Between,
         atleast = Between,
         atmost  = Between,
      }
   end

   local default_action = (exact_match == "yes") and "exact" or "match"

   if (not action) then
      action = optionTbl().latest and "latest" or default_action
   end

   local o = s_findT[action]:create()

   is                  = is or false
   ie                  = ie or false
   o.__isOrig          = is
   o.__ieOrig          = ie
   o.__sn              = false
   o.__version         = false
   o.__fn              = false
   o.__versionStr      = false
   o.__dependsOn       = false
   o.__moduleKindT     = nil
   o.__ref_count       = nil
   o.__depends_on_anyA = nil
   o.__sType           = sType
   o.__wV              = false
   o.__waterMark       = "MName"
   o.__action          = action
   o.__range_fnA       = { s_rangeFuncT["<="], s_rangeFuncT["<="]}
   o.__show_range      = { is, ie}
   if (is and (is:sub(1,1) == "<" or is:sub(-1) == "<")) then
      o.__range_fnA[1]  = s_rangeFuncT["<"]
      is = is:gsub("<","")
   elseif (is and (is:sub(1,1) == ">" or is:sub(-1) == ">")) then
      o.__range_fnA[1]  = s_rangeFuncT["<"]
      is = is:gsub(">","")
   end
   if (ie and (ie:sub(1,1) == "<" or ie:sub(-1) == "<")) then
      o.__range_fnA[2]  = s_rangeFuncT["<"]
      ie = ie:gsub("<","")
   end
   o.__is         = is
   o.__ie         = ie
   o.__have_range = is or ie
   o.__range      = { o.__is and parseVersion(o.__is) or " ", o.__ie and parseVersion(o.__ie) or "~" }

   if (sType == "entryT") then
      local t      = name
      o.__sn       = t.sn
      o.__version  = t.version
      o.__userName = t.userName
      o.__fn       = t.fn
   elseif (sType == "inherit") then
      local t      = name
      o.__fullName = build_fullName(t.sn, t.version)
      o.__t        = t
   else
      -- remove any trailing '/'s and any trailing .lua$
      o.__userName   = (name or ""):trim():gsub("/+$",""):gsub("%.lua$","")
   end

   dbg.fini("MName:new")
   return o
end



--------------------------------------------------------------------------
-- This l_overRide_sType() function is here to convert
--    mcp:conflict(MName:buildA("mt",...))
--    where the list of userNames might include between("A","1.0","2.0")
--    Functions like between assume "load".  Where as conflict, prereq etc
--    need "mt".

local function l_overRide_sType(mname, sTypeIn)
   mname.__sType = sTypeIn
end

--------------------------------------------------------------------------
-- Return an array of MName objects
-- @param self A MName object
-- @param sType The type which can be "entryT", "load", "mt"
-- @return An array of MName objects.
function M.buildA(self,sType, argT)
   local a    = {}

   for i = 1, argT.n do
      local v = argT[i]
      if (type(v) == "string" ) then
         a[#a + 1] = self:new(sType, v:trim())
      elseif (type(v) == "table") then
         l_overRide_sType(v,sType)
         a[#a + 1] = v
      end
   end
   return a
end

local function l_lazyEval(self)
   dbg.start{"l_lazyEval(",self.__userName,")"}

   local sType   = self.__sType
   if (sType == "mt") then
      local t1       = epoch()
      local frameStk = FrameStk:singleton()
      local mt       = frameStk:mt()
      local sn       = mt:lookup_w_userName(self.__userName)
      --dbg.print{"sn: ",sn,"\n"}
      if (sn) then
         self.__sn              = sn
         self.__fn              = mt:fn(sn)
         self.__version         = mt:version(sn)
         self.__stackDepth      = mt:stackDepth(sn)
         self.__wV              = mt:wV(sn)
         self.__ref_count       = mt:get_ref_count(sn)
         self.__depends_on_anyA = mt:get_depends_on_anyA(sn)
      end
      timer:deltaT("l_lazyEval", epoch() - t1)
      dbg.fini("l_lazyEval via mt")
      return
   end

   local cached_loads = cosmic:value("LMOD_CACHED_LOADS")
   local moduleA = ModuleA:singleton{spider_cache = (cached_loads ~= "no")}
   if (sType == "inherit") then
      local t  = self.__t
      local fn = moduleA:inherited_search(self.__fullName, t.fn)
      if (fn) then
         self.__fn       = fn
         self.__sn       = t.sn
         self.__version  = t.version
         self.__userName = build_fullName(t.sn, t.version)
         self.__wV       = t.wV
      end

      dbg.fini("l_lazyEval via inherit")
      return
   end

   assert(sType == "load", "unknown sType: "..sType)
   local mrc                   = MRC:singleton()
   local frameStk              = FrameStk:singleton()
   local mt                    = frameStk:mt()
   local origUserName          = self:userName()
   local userName              = mrc:resolve(mt:modulePathA(), self:userName())
   local sn, versionStr, fileA = moduleA:search(userName)
   dbg.printT("fileA",fileA)
   dbg.print{"l_lazyEval: orig: ",origUserName,", userName: ",userName, ", sn: ",sn,", versionStr: ",versionStr,"\n"}
   mrc:applyWeights(sn, fileA)

   if (origUserName ~= userName) then
      self.__origUserName = origUserName
   end
   dbg.print{"l_lazyEval: self.__origUserName: ",self.__origUserName,"\n"}

   self.__userName   = userName
   self.__sn         = sn
   self.__versionStr = versionStr
   self.__stackDepth = self.__stackDepth or frameStk:stackDepth()

   if (not sn) then
      dbg.fini("l_lazyEval via no sn")
      return
   end

   local stepA   = self:steps()
   local version
   local fn
   local wV
   local found
   local funcName
   local mpath
   local moduleKindT

   dbg.printT("fileA",fileA)
   dbg.print{"#stepA: ",#stepA,"\n"}
   dbg.print{"userName: ",self.__userName,"\n"}
   dbg.print{"sn: ",self.__sn,"\n"}


   for i = 1, #stepA do
      local func = stepA[i]
      found, fn, version, wV, moduleKindT, mpath, funcName = func(self, fileA)
      dbg.print{"found: ",found,", funcName: ",funcName,"\n"}
      if (found) then
         self.__fn          = fn
         self.__version     = version
         self.__wV          = wV
         self.__moduleKindT = moduleKindT
         self.__mpath       = mpath
         if (self.__action == "latest" or self.__sn ~= self.__userName) then
            self.__userName = build_fullName(self.__sn, version)
         end
         break
      end
   end
   
   ---------------------------------------------------------------
   -- If found then check to see if this MName object is forbidden

   if (found) then
      self.__forbiddenT = mrc:isForbidden{fullName=build_fullName(self.__sn, version),
                                          sn = self.__sn, fn = self.__fn,
                                          mpath = self.__mpath}
   end

   local tt = self.__moduleKindT or {}
   dbg.print{"l_lazyEval: sn: ",self.__sn, ", version: ",self.__version, ", fn: ",self.__fn,", wV: ",self.__wV,", userName: ",self.__userName,"\n"}
   dbg.print{"fn: ",self.__fn,", kind: ",tt.kind,"\n"}
   dbg.fini("l_lazyEval")
end


function M.valid(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__fn
end

function M.moduleKindT(self)
   if (not self.__moduleKindT) then
      return nil
   end
   local moduleKindT   = self.__moduleKindT
   local hidden_loaded = moduleKindT.hidden_loaded or nil
   local t = nil
   if (moduleKindT.kind ~= "normal") then
      t = {kind = moduleKindT.kind, hidden_loaded = hidden_loaded}
   end
   return t
end

function M.isVisible(self)
   if (not self.__moduleKindT) then
      return true
   end
   local moduleKindT   = self.__moduleKindT
   return moduleKindT.kind == "normal"
end

function M.userName(self)
   return self.__userName
end

function M.origUserName(self)
   return self.__origUserName
end

function M.sn(self)
   if (not self.__sn) then
      --dbg.start{"Mname:sn()"}
      l_lazyEval(self)
      --dbg.fini("Mname:sn")
   end
   return self.__sn
end

function M.fn(self)
   if (not self.__fn) then
      --dbg.start{"Mname:fn()"}
      l_lazyEval(self)
      --dbg.fini("Mname:fn")
   end
   return self.__fn
end

function M.version(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__version
end

function M.wV(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__wV
end

function M.stackDepth(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   local stackDepth = self.__stackDepth == nil and 0 or self.__stackDepth
   return stackDepth
end

function M.setStackDepth(self, depth)
   self.__stackDepth = depth
end

function M.set_ref_count(self, count)
   self.__ref_count = count
end

function M.set_depends_on_anyA(self, depends_on_anyA)
   self.__depends_on_anyA = depends_on_anyA
end

function M.get_depends_on_anyA(self, sn)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__depends_on_anyA
end

function M.ref_count(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__ref_count
end

function M.fullName(self)
   if (not self.__sn) then
      --dbg.start{"Mname:fullName()"}
      l_lazyEval(self)
      --dbg.fini("Mname:fullName")
      if (not self.__fn) then
         return nil
      end
   end
   return build_fullName(self.__sn, self.__version)
end

------------------------------------------------------------
-- It turns that Tmod searching all directories in MODULEPATH
-- for an exact version match.  It stops at the first exact
-- match it finds.
--
-- For choosing a default (either marked or highest) it stops
-- looking in any other directories after it finds the first
-- match.  So if the user looks for "icr" and there is one in
-- the mf directory, it won't look in mf2.
--
-- Lmod (for NV) uses the following rules:
--    1) Find first exact match
--    2) Find first marked default
--    3) Find highest.
--
--  The new rules are the following:
--  For a Site that uses NVV then:
--     1) Find exact match (first found)
--     2) Find first marked default in the first matching sn
--     3) Find first highest in the first matching sn
--
--  The cool thing is that when the site uses NV for all
--  modulefiles (and not NVV), then locationT is used and all
--  sn are combined.  So the same rules can be used for sites
--  that use NV and NVV.

--  Originally, this code tried to find the "best" exact match.
--  That is it would find the first exact match then keep looking
--  for marked default.  There is no trouble with NV.  Since there
--  is only fileA[1] (because of the locationT).  This code will find
--  the best match.  That is the one with the highest marked default.

--  The trouble is with NVV.  Suppose you have:
--           M1                  M2
--           icr                 icr
--           *64                 64
--       3.7 3.8  3.9          3.8 *3.9
--
--  where * means that M1/icr/*64/3.9  will be higher than M2/icr/64/*3.9.
--  I don't see a way around this.  So the rule is that only the 1st
--  modulepath entry is where defaults are search for.  Only exact match
--  search pass the first modulepath.  Note when I said first MODULEPATH
--  directory that doesn't mean the very first directory.  No it means the
--  first directory that has the sn.

-- The rule is that if there is One directory that is using NVV then
-- the whole module tree is treated as NVV.


local function l_find_exact_match(self, must_have_version, fileA)
   --dbg.start{"MName l_find_exact_match(must_have_version:,",must_have_version,",fileA)"}
   local versionStr  = self.__versionStr
   local mrc         = MRC:singleton()
   local fn          = false
   local version     = false
   local pV          = " "  -- this is less than the lowest possible weight
   local wV          = false
   local moduleKindT = {}
   local found       = false
   local mpath       = false
   if (must_have_version and not versionStr) then
      return found, fn, version
   end

   for j = 1, #fileA do
      local blockA = fileA[j]
      for i = 1, #blockA do
         local entry   = blockA[i]
         --dbg.print{"entry.fullName: ",entry.fullName,", entry.fn: ",entry.fn,"\n"}
         if (entry.version == versionStr and entry.pV > pV ) then
            local resultT = mrc:isVisible{fullName=entry.fullName,sn=entry.sn,fn=entry.fn, mpath=entry.mpath,
                                          visibleT = {soft = true, hidden = true}}
            --dbg.printT("resultT",resultT)
            if (resultT.isVisible)  then
               pV          = entry.pV
               wV          = entry.wV
               fn          = entry.fn
               mpath       = entry.mpath
               version     = entry.version or false
               moduleKindT = resultT.moduleKindT
               found       = true
               self.__range = { pV, pV }
               break
            end
         end
      end
      if (found) then break end
   end

   --dbg.print{"found: ",found,", fn: ",fn,", version: ", version,", wV: ",wV,
   --         ", kind: ",moduleKindT.kind,"\n"}
   --dbg.fini("MName l_find_exact_match")
   return found, fn, version, wV, moduleKindT, mpath
end


------------------------------------------------------------------------
-- M.find_exact_match() is more difficult because there are possibly
-- more than one marked default:
--    1) The filesystem can mark a default           (weighted by '^')
--    2) The system admins can have a modulerc file. (weighted by 's')
--    3) The user can have a ~/.modulerc file.       (weighted by 'u')

function M.find_exact_match(self, fileA)
   --dbg.start{"MName:find_exact_match(fileA)"}
   local must_have_version = true
   local found, fn, version, wV, moduleKindT, mpath  = l_find_exact_match(self, must_have_version, fileA)
   --dbg.fini("MName:find_exact_match")
   return found, fn, version, wV, moduleKindT, mpath, "find_exact_match"
end
------------------------------------------------------------------------
-- This routine is almost the same as M.find_exact_match
-- But this routine is here to find moduleName w/o versions
-- (namely meta modules).  But modules with version have a
-- higher priority over meta modules.

function M.find_exact_match_meta_module(self, fileA)
   --dbg.start{"MName:find_exact_match_meta_module(fileA)"}
   local must_have_version = false
   local found, fn, version, wV, moduleKindT, mpath = l_find_exact_match(self, must_have_version, fileA)
   --dbg.fini("MName:find_exact_match_meta_module")
   return found, fn, version, wV, moduleKindT, mpath, "find_exact_match_meta_module"
end

local function l_find_highest_by_key(self, key, fileA)
   --dbg.start{"MName: l_find_highest_by_key(key:\"",key,"\",fileA)"}
   local mrc         = MRC:singleton()
   local idx         = nil
   local fn          = false
   local moduleKindT = {}
   local found       = false
   local version     = false
   local pV          = false
   local wV          = false
   local mpath       = false
   fileA             = fileA or {}
   local blockA

   local function l_cmp_pV(a,b)
      return a.pV > b.pV
   end

   local function l_cmp_wV(a,b)
      return a.wV > b.wV
   end

   local l_cmp = (key == "pV") and l_cmp_pV or l_cmp_wV


   dbg.printT("fileA: ",fileA)
   for j = 1,#fileA do
      blockA = fileA[j]
      sort(blockA, l_cmp) -- sort by appropriate weight (pV or wV)
      dbg.printT("blockA: ",blockA)
      
      for i = 1,#blockA do
         local entry   = blockA[i]
         local v       = entry[key]
         local resultT = mrc:isVisible{fullName=entry.fullName,sn=entry.sn,fn=entry.fn, mpath=entry.mpath,
                                       visibleT = {soft = true}}
         if (isMarked(v) or resultT.isVisible) then
            idx         = i
            pV          = entry.pV
            wV          = entry.wV
            mpath       = entry.mpath
            moduleKindT = resultT.moduleKindT
            dbg.print{"saving fullName: ", entry.fullName,"\n"}
            break;
         end
      end
      dbg.print{"idx: ",idx,"\n"}
      if (idx) then break end
   end
   if (idx) then
      fn           = blockA[idx].fn
      version      = blockA[idx].version or false
      found        = true
      self.__range = { pV, pV }
   end
   --dbg.print{"found: ",found,", fn: ",fn,", version: ", version,", wV: ",wV,
   --          ", kind: ",moduleKindT.kind,"\n"}
   --dbg.fini("MName: l_find_highest_by_key")
   return found, fn, version, wV, moduleKindT, mpath, "l_find_highest_by_key("..key..")"
end

------------------------------------------------------------------------
-- M.find_highest() finds the highest using the weighted


function M.find_highest(self, fileA)
   return l_find_highest_by_key(self, "wV",fileA)
end

function M.find_latest(self, fileA)
   return l_find_highest_by_key(self,"pV",fileA)
end

function M.find_between(self, fileA)
   --dbg.start{"MName:find_between(fileA)"}
   local blockA = fileA[1] or {}
   sort(blockA, function(x,y)
           return x.wV > y.wV
           end)
   dbg.printT("blockA", blockA)

   local mrc         = MRC:singleton()
   local fn          = false
   local version     = false
   local lowerBound  = self.__range[1]
   local upperBound  = self.__range[2]
   local lowerFn     = self.__range_fnA[1].func
   local upperFn     = self.__range_fnA[2].func

   local wV          = nil
   local mpath       = false
   local kind        = nil
   local idx         = nil
   local found       = false
   local moduleKindT = {}
   for j = 1,#blockA do
      local entry = blockA[j]
      local v     = entry.pV
      if (lowerFn(lowerBound,v) and upperFn(v,upperBound)) then
         local resultT = mrc:isVisible{fullName=entry.fullName,sn=entry.sn,fn=entry.fn, mpath=entry.mpath,
                                       visibleT = {soft = true}}
         if (isMarked(entry.wV) or resultT.isVisible ) then
            idx         = j
            wV          = entry.wV
            mpath       = entry.mpath
            moduleKindT = resultT.moduleKindT
            break
         end
      end
   end
   if (idx) then
      fn      = blockA[idx].fn
      version = blockA[idx].version
      found   = true
      if (found) then
         self.__userName = build_fullName(self.__sn,version)
      end
   end
   --dbg.fini("MName:find_between")
   return found, fn, version, wV, moduleKindT, mpath, "find_between"
end

local function l_rangeCk(self, version, result_if_found, result_if_not_found)
   --dbg.start{"l_rangeCk(self, version: ",version,", result_if_found: ",result_if_found,", result_if_not_found: ",result_if_not_found,")"}
   local have_range = false
   local result     = result_if_not_found
   if (not self.__have_range) then
      --dbg.print{"no range\n"}
      --dbg.fini("l_rangeCk")
      return have_range, result
   end

   have_range       = true
   local lowerBound = self.__range[1]
   local upperBound = self.__range[2]
   local lowerFn    = self.__range_fnA[1]
   local upperFn    = self.__range_fnA[2]
   local pV         = parseVersion(version)
   --dbg.print{"lowerBound: ",lowerBound,"\n"}
   --dbg.print{"upperBound: ",upperBound,"\n"}
   --dbg.print{"pV:         ",pV,"\n"}
   --dbg.print{"lowerFn: ",lowerFn.name,", lowerFn.func(lowerBound, pV): ",lowerFn.func(lowerBound, pV),"\n"}
   --dbg.print{"upperFn: ",upperFn.name,", upperFn.func(pV, upperBound): ",upperFn.func(pV, upperBound),"\n"}

   if (lowerFn.func(lowerBound, pV) and upperFn.func(pV, upperBound)) then
      result = result_if_found
   end

   --dbg.fini("l_rangeCk")
   return have_range, result
end

function M.isloaded(self)
   --dbg.start{"MName:isloaded()"}
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local sn        = self:sn()
   local status    = mt:status(sn)
   local sn_status = ((status == "active") or (status == "pending"))
   if (not sn_status) then
      --dbg.fini("MName:isloaded")
      return sn_status
   end

   local have_range, result = l_rangeCk(self, mt:version(sn), sn_status, false)
   if (have_range) then
      --dbg.fini("MName:isloaded")
      return result
   end

   local userName  = self:userName()
   if (userName == sn              or
       userName == mt:userName(sn) or
       userName == mt:fullName(sn)) then
      --dbg.print{"fullName: ",mt:fullName(sn),", status: ",sn_status,"\n"}
      --dbg.fini("MName:isloaded")
      return sn_status
   end

   --dbg.print{"fullName: ",mt:fullName(sn),", status: false\n"}
   --dbg.fini("MName:isloaded")
   return false
end

function M.isPending(self)
   local frameStk   = FrameStk:singleton()
   local mt         = frameStk:mt()
   local sn         = self:sn()
   local sn_pending = mt:have(sn,"pending")
   local userName   = self:userName()
   if (userName == sn            or
       userName == mt:fullName(sn)) then
      return sn_pending
   end
   return false
end

function M.defaultKind(self)
   local kindT = {
      ["^"] = "marked",
      s     = "system",
      u     = "user",
   }

   local kind = self:wV():gsub("^.*/",""):sub(1,1)
   return kindT[kind] or "none"
end



-- Do a prereq check to see name and/or version is loaded.
-- @param self A MName object
function M.prereq(self)
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local sn        = self:sn()
   local fullName  = mt:fullName(sn)
   local userName  = self:userName()
   local status    = mt:status(sn)
   local sn_status = ((status == "active") or (status == "pending"))

   if (not sn_status) then
      -- The sn is not active or pending -> did not meet prereq
      return userName
   end

   local have_range, result = l_rangeCk(self, mt:version(sn), false, userName)
   if (have_range) then
      return result
   end

   if (userName == sn or userName == fullName) then
      -- The userName matched the either the sn or fullName
      -- stored in the MT
      return false
   end

   local i,j = fullName:find(userName)
   if (i == 1 and fullName:sub(j+1,j+1) == '/') then
      return false
   end

   -- userName did not match.
   return userName
end

function M.conflictCk(self, mt)
   dbg.start{"MName:conflictCk(mt)"}
   local userName = false
   local sn       = self:sn()
   if (not (sn and mt:have(sn,"active"))) then
      dbg.print{"1) userName: ",userName,"\n"}
      dbg.fini("MName:conflictCk")
      return userName
   end

   local have_range, result = l_rangeCk(self, mt:version(sn), mt:fullName(sn), false)
   if (have_range) then
      dbg.fini("MName:conflictCk")
      return result
   end

   local self_userName = self:userName()
   --dbg.print{"self_userName: ",self_userName,", sn: ",sn,", userName: ",userName,"\n"}
   if (self_userName == sn or extractVersion(self_userName, sn) == mt:version(sn)) then
      userName = self_userName
   end
   --dbg.print{"3) userName: ",userName,"\n"}
   dbg.fini("MName:conflictCk")
   return userName
end

function M.downstreamConflictCk(self, mnameIn)
   local snIn = mnameIn:sn()
   dbg.start{"MName:downstreamConflictCk(snIn:", snIn,")"}

   dbg.print{"self:userName(): ", self:userName(),"\n"}

   local have_range, result = l_rangeCk(self, mnameIn:version(), mnameIn:userName(), false)
   if (have_range) then
      dbg.print{"2 result: ",result,"\n"}
      dbg.fini( "MName:downstreamConflictCk")
      return result
   end

   result = false
   --dbg.print{"self: ",self,"\n"}
   --dbg.print{"mnameIn: ",mnameIn,"\n"}
   if (self:userName() == snIn or extractVersion(self:userName(), snIn) == mnameIn:version()) then
      result = snIn
   end

   dbg.fini( "MName:downstreamConflictCk")
   return result
end

function M.forbiddenT(self)
   return self.__forbiddenT
end

function M.set_depends_on_flag(self, value)
   if (type(value) == "number") then
      self.__dependsOn = value > 0
   elseif (type(value) == "boolean") then
      self.__dependsOn = value
   else
      self.__dependsOn = false
   end
   return self
end

function M.get_depends_on_flag(self)
   return self.__dependsOn
end

-- reset the private variable to force a new l_lazyEval.
function M.reset(self)
   self.__sn         = nil
   self.__fn         = nil
   self.__version    = nil
   self.__stackDepth = nil
end

function M.actionName(self)
   return self.__action
end


--------------------------------------------------------------------------
-- Return the string of the user name of the module.
-- @param self A MName object
function M.show(self)
   return '"' .. self:userName() .. '"'
end

function M.print(self)
   local t = { sType    = self.__sType,
               userName = self.__userName,
               action   = self.__action,
               is       = self.__isOrig,
               ie       = self.__ieOrig,
   }
   return t
end

function M.get_version_description(self)
   local t = {}
   if (self.__have_range) then
      t.kind  = "between"
      t.value = { self.__isOrig, self.__ieOrig}
   else
      local version = (self.__action == "latest") and self.__version 
          or extractVersion(self.__userName, self.__sn)
      if (version) then
         t.kind  = "fixed"
         t.value = version
      else
         t.kind  = "bool"
         t.value = true
      end
   end
   if (dbg.active()) then
      local s = serializeTbl{indent = true, value = t}
      dbg.print{"MName:get_version_description(): sn: ",self:sn(), ", version: ",s,"\n"}
   end
   return t
end
      


return M
