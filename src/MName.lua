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

local exact_match = cosmic:value("LMOD_EXACT_MATCH")

function M.className(self)
   return self.my_name
end

local function l_lessthan(a,b)
   return a < b
end

local function l_lessthan_equal(a,b)
   return a <= b
end



function M.new(self, sType, name, action, is, ie)
   --dbg.start{"Mname:new(",sType,")"}

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
      }
   end

   local default_action = (exact_match == "yes") and "exact" or "match"

   if (not action) then
      action = masterTbl().latest and "latest" or default_action
   end

   local o = s_findT[action]:create()

   is             = is or false
   ie             = ie or false
   o.__sn         = false
   o.__version    = false
   o.__fn         = false
   o.__versionStr = false
   o.__sType      = sType
   o.__wV         = false
   o.__waterMark  = "MName"
   o.__action     = action
   o.__range_fnA  = { l_lessthan_equal, l_lessthan_equal }
   o.__show_range = { is, ie}
   if (is and (is:sub(1,1) == "<" or is:sub(-1) == "<")) then
      o.__range_fnA[1]  = l_lessthan
      is = is:gsub("<","")
   end
   if (ie and (ie:sub(1,1) == "<" or ie:sub(-1) == "<")) then
      o.__range_fnA[2]  = l_lessthan
      ie = ie:gsub("<","")
   end
   o.__is         = is 
   o.__ie         = ie 
   o.__have_range = is or ie
   o.__range      = { o.__is and parseVersion(o.__is) or " ", o.__ie and parseVersion(o.__ie) or "~" }
   o.__actionNm   = action

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

   --dbg.fini("MName:new")
   return o
end


--------------------------------------------------------------------------
-- Return an array of MName objects
-- @param self A MName object
-- @param sType The type which can be "entryT", "load", "mt"
-- @return An array of MName objects.
function M.buildA(self,sType, ...)
   local argA = pack(...)
   local a    = {}

   for i = 1, argA.n do
      local v = argA[i]
      if (type(v) == "string" ) then
         a[#a + 1] = self:new(sType, v:trim())
      elseif (type(v) == "table") then
         a[#a + 1] = v
      end
   end
   return a
end

local function l_lazyEval(self)
   dbg.start{"l_lazyEval(",self.__userName,")"}

   local sType   = self.__sType
   if (sType == "mt") then
      local frameStk = FrameStk:singleton()
      local mt       = frameStk:mt()
      local sn       = mt:lookup_w_userName(self.__userName)
      dbg.print{"sn: ",sn,"\n"}
      if (sn) then
         self.__sn         = sn
         self.__fn         = mt:fn(sn)
         self.__version    = mt:version(sn)
         self.__stackDepth = mt:stackDepth(sn)
         self.__wV         = mt:wV(sn)
      end
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
   local userName              = mrc:resolve(mt:modulePathA(), self:userName())
   local sn, versionStr, fileA = moduleA:search(userName)
   dbg.print{"l_lazyEval: userName: ",userName, ", sn: ",sn,", versionStr: ",versionStr,"\n"}

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
   dbg.printT("fileA",fileA)
   --dbg.print{"#stepA: ",#stepA,"\n"}

   for i = 1, #stepA do
      local func = stepA[i]
      found, fn, version, wV = func(self, fileA)
      if (found) then
         self.__fn      = fn
         self.__version = version
         self.__wV      = wV
         if (self.__actionNm == "latest") then
            self.__userName = build_fullName(self.__sn, version)
         end
         break
      end
   end
   dbg.print{"l_lazyEval: sn: ",self.__sn, ", version: ",self.__version, ", fn: ",self.__fn,", wV: ",self.__wV,"\n"}
   dbg.print{"fn: ",self.__fn,"\n"}
   dbg.fini("l_lazyEval")
end


function M.valid(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__fn
end


function M.userName(self)
   return self.__userName
end

function M.sn(self)
   if (not self.__sn) then
      dbg.start{"Mname:sn()"}
      l_lazyEval(self)
      dbg.fini("Mname:sn")
   end
   return self.__sn
end

function M.fn(self)
   if (not self.__fn) then
      dbg.start{"Mname:fn()"}
      l_lazyEval(self)
      dbg.fini("Mname:fn")
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

function M.setRefCount(self, count)
   self.__ref_count = count
end

function M.ref_count(self)
   if (not self.__sn) then
      l_lazyEval(self)
   end
   return self.__ref_count
end

function M.fullName(self)
   if (not self.__sn) then
      dbg.start{"Mname:fullName()"}
      l_lazyEval(self)
      dbg.fini("Mname:fullName")
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


------------------------------------------------------------------------
-- M.find_exact_match() is more difficult because there are possibly
-- more than one marked default:
--    1) The filesystem can mark a default           (weighted by '^')
--    2) The system admins can have a modulerc file. (weighted by 's')
--    3) The user can have a ~/.modulerc file.       (weighted by 'u')


function M.find_exact_match(self, fileA)
   dbg.start{"MName:find_exact_match(fileA)"}
   local versionStr = self.__versionStr
   local fn         = false
   local version    = false
   local pV         = " "  -- this is less than the lowest possible weight
   local wV         = false
   local found      = false
   if (not versionStr) then
      dbg.print{"found: ",found,", fn: ",fn,", version: ", version,"\n"}
      dbg.fini("MName:find_exact_match")
      return found, fn, version
   end
      
   for i = 1, #fileA do
      local a = fileA[i]
      for j = 1, #a do
         local entry = a[j]
         if (entry.version == versionStr and entry.pV > pV ) then
            pV      = entry.pV
            wV      = entry.wV
            fn      = entry.fn
            version = entry.version or false
            found   = true
            self.__range = { pV, pV }
            break
         end
      end
   end

   dbg.print{"found: ",found,", fn: ",fn,", version: ", version,"\n"}
   dbg.fini("MName:find_exact_match")
   return found, fn, version, wV
end

function M.find_exact_match_meta_module(self, fileA)
   dbg.start{"MName:find_exact_match_meta_module(fileA)"}
   local versionStr = self.__versionStr
   local fn         = false
   local version    = false
   local pV         = " "  -- this is less than the lowest possible weight
   local wV         = false
   local found      = false
   for i = 1, #fileA do
      local a = fileA[i]
      for j = 1, #a do
         local entry = a[j]
         if (entry.version == versionStr and entry.pV > pV ) then
            pV      = entry.pV
            wV      = entry.wV
            fn      = entry.fn
            version = entry.version or false
            found   = true
            self.__range = { pV, pV }
            break
         end
      end
   end

   dbg.print{"found: ",found,", fn: ",fn,", version: ", version,"\n"}
   dbg.fini("MName:find_exact_match_meta_module")
   return found, fn, version, wV
end


local function l_find_highest_by_key(self, key, fileA)
   dbg.start{"MName:find_by_key(key:\"",key,"\",fileA)"}
   local mrc     = MRC:singleton()
   local a       = fileA[1] or {}
   local weight  = " "  -- this is less than the lower possible weight.
   local idx     = nil
   local fn      = false
   local found   = false
   local version = false
   local pV      = false
   local wV      = false

   for j = 1,#a do
      local entry = a[j]
      local v     = entry[key]
      if (mrc:isVisible{fullName=entry.fullName,sn=entry.sn,fn=entry.fn} or isMarked(v)) then
         if (v > weight) then
            idx    = j
            weight = v
            pV     = entry.pV
            wV     = entry.wV
         end
      end
   end
   if (idx) then
      fn           = a[idx].fn
      version      = a[idx].version or false
      found        = true
      self.__range = { pV, pV }
   end
   dbg.print{"found: ",found,", fn: ",fn,", version: ", version,", wV: ",wV,"\n"}
   dbg.fini("MName:find_by_key")
   return found, fn, version, wV
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
   local a     = fileA[1] or {}
   sort(a, function(x,y)
           return x.pV < y.pV
           end)

   local fn         = false
   local version    = false
   local lowerBound = self.__range[1]
   local upperBound = self.__range[2]
   local lowerFn    = self.__range_fnA[1]
   local upperFn    = self.__range_fnA[2]

   local pV         = lowerBound
   local wV         = " "  -- this is less than the lower possible weight.

   --dbg.print{"lower: ",pV,"\n"}
   --dbg.print{"upper: ",upperBound,"\n"}
   --dbg.print{"wV:    \"",wV,"\"\n\n"}

   local idx        = nil
   local found      = false
   for j = 1,#a do
      local entry = a[j]
      local v     = entry.pV
      --dbg.print{"pV: ",pV,", v: ",v,", upper: \"",upperBound,"\"\n"}
      --dbg.print{"pV <= v: ",pV <= v, ", v <= upperBound: ",v <= upperBound,", entry.wV > wV: ",entry.wV > wV,"\n"}

      if (lowerFn(pV,v) and upperFn(v,upperBound) and entry.wV > wV) then
         idx = j
         pV  = v
         wV  = entry.wV
      end
   end
   if (idx) then
      fn      = a[idx].fn
      version = a[idx].version
      found   = true
      if (found) then
         self.__userName = build_fullName(self.__sn,version)
      end
   end
   --dbg.fini("MName:find_between")
   return found, fn, version, wV
end

function M.find_inherit_match(self,fileA)
   local a = fileA[1] or {}
end

function M.isloaded(self)
   dbg.start{"MName:isloaded()"}
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local sn        = self:sn()
   local status    = mt:status(sn)
   local sn_status = ((status == "active") or (status == "pending"))
   if (sn_status and self.__have_range) then
      local pV = parseVersion(mt:version(sn))
      if ((self.__range[1] <= pV) and (pV <= self.__range[2])) then
         return sn_status
      end
   end

   local userName  = self:userName()
   if (userName == sn              or
       userName == mt:userName(sn) or
       userName == mt:fullName(sn)) then
      dbg.fini("MName:isloaded")
      return sn_status
   end

   dbg.fini("MName:isloaded")
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

   if (self.__have_range) then
      local pV = parseVersion(mt:version(sn))
      if ((self.__range[1] <= pV) and (pV <= self.__range[2])) then
         return false
      end
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

-- reset the private variable to force a new l_lazyEval.
function M.reset(self)
   self.__sn         = nil
   self.__fn         = nil
   self.__version    = nil
   self.__stackDepth = nil
end

--------------------------------------------------------------------------
-- Return the string of the user name of the module.
-- @param self A MName object
function M.show(self)
   return '"' .. self:userName() .. '"'
end

return M
