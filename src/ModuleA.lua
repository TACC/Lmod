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

require("parseVersion")
require("collectionFileA")
require("serializeTbl")
require("string_utils")
require("utils")

local DirTree     = require("DirTree")
local FrameStk    = require("FrameStk")
local LocationT   = require("LocationT")
local M           = {}
local MRC         = require("MRC")
local cosmic      = require("Cosmic"):singleton()
local dbg         = require("Dbg"):dbg()
local getenv      = os.getenv
local s_moduleA   = false
local sort        = table.sort
local exact_match = cosmic:value("LMOD_EXACT_MATCH")
local find_first  = cosmic:value("LMOD_TMOD_FIND_FIRST")

-- print(__FILE__() .. ':' .. __LINE__())
----------------------------------------------------------------------
-- We use the trick of penalizing the parsed version string to mark defaults
-- The order is as follows:
--     *     -> Words like beta start with an asterisk
--   [0-9]   -> Numbers are zero patted to nine places
--     ^     -> Versions marked by default or .version or .modulerc
--     s     -> Versions marked by System .modulerc
--     u     -> Versions marked by User   .modulerc
--     ~     -> All files are less than tilde (~)


local function addPV(sn, v, pV, wV)
   if (next(v.fileT) ~= nil) then
      for fullName, vv in pairs(v.fileT) do
         local pattern = '^' .. sn:escape() .. '/'
         local version = fullName:gsub(pattern,"")
         local bn      = barefilename(fullName)
         local pV1     = parseVersion(bn)
         local value   = false
         local wV1     = pV1

         if (v.defaultT and next(v.defaultT) ~= nil) then
            value = v.defaultT.value
         end
         if (value == bn or value == fullName) then
            wV1 = '^' .. pV1:sub(2,-1)
         end

         vv.pV = (pV == "") and pV1 or pV .. '/'.. pV1
         vv.wV = (wV == "") and wV1 or wV .. '/'.. wV1
      end
   end
   if (next(v.dirT) ~= nil) then
      for fullName, vv in pairs(v.dirT) do
         local dirN   = barefilename(fullName)
         local pV1    = parseVersion(dirN):gsub("%.%*zfinal$","")
         local wV1    = pV1
         local value  = false

         if (v.defaultT and next(v.defaultT) ~= nil) then
            value = v.defaultT.value
         end

         if (value == dirN or value == fullName) then
            wV1 = '^' .. pV1:sub(2,-1)
         end
         local new_pV = (pV == "") and pV1  or pV .. '/' .. pV1
         local new_wV = (wV == "") and wV1  or wV .. '/' .. wV1
         addPV(sn, vv, new_pV, new_wV)
      end
   end
   return v
end

local function GroupIntoModules(self, level, maxdepth, mpath, dirT, T)
   if (next(dirT.fileT) ~= nil) then
      for fullName, v in pairs(dirT.fileT) do
         local defaultT = {}
         if (next(dirT.defaultT) ~= nil and (dirT.defaultT.value == fullName)) then
            defaultT = dirT.defaultT
         end
         local metaModuleT = v
         metaModuleT.pV = "~"
         metaModuleT.wV = "~"
         T[fullName] = {file = v.fn, metaModuleT = metaModuleT, fileT = {}, dirT = {}, defaultT = defaultT, mpath = mpath}
      end
   end
   for path, v in pairs(dirT.dirT) do
      local prefix = extractFullName(mpath, path)
      if (next(v.defaultT) ~= nil or next(v.dirT) == nil or level == maxdepth) then
         if (next(v.dirT) ~= nil) then
            self.__isNVV = true
         end
         T[prefix] = addPV(prefix,v,"","")
      else
         GroupIntoModules(self, level+1, maxdepth, mpath, v, T)
      end
   end
end

local function build(self, maxdepthT, dirA)
   dbg.start{"ModuleA build()"}
   local moduleA = {}
   local sz      = #dirA
   dbg.print{"#dirA: ",sz,"\n"}
   for i = 1,sz do
      local mpath    = dirA[i].mpath
      dbg.print{"mpath: ",mpath,"\n"}
      local dirT     = dirA[i].dirT
      local T        = {}
      local maxdepth = maxdepthT[mpath] or -1
      local level    = 1
      GroupIntoModules(self, level, maxdepth, mpath, dirT, T)
      moduleA[#moduleA + 1] = {mpath = mpath, T = T}
   end
   dbg.fini("ModuleA build")
   return moduleA
end

local function find_vA(name, moduleA)
   -- First find sn and collect all v's into vA
   local versionStr = nil
   local vA         = {}
   local sn         = name
   local idx        = nil
   local done       = false

   while true do
      for i = 1, #moduleA do
         local v = moduleA[i].T[sn]
         if (v) then
            done        = true
            vA[#vA + 1] = v
         end
      end
      if (done) then break end
      idx = sn:match("^.*()/")
      if (idx == nil) then break end
      sn = sn:sub(1,idx-1)
   end

   -- If there is nothing in vA then the name is not in moduleA.
   if (next(vA) == nil) then
      return nil
   end

   if (idx) then
      versionStr = name:sub(idx+1,-1)
   end
   dbg.print{"sn: ",sn,", versionStr: ",versionStr,"\n"}
   dbg.printT("vA",vA)
   return sn, versionStr, vA
end

local function find_vB(sn, versionStr, vA)
   local fullStr = versionStr
   local vB      = {}

   for i = 1,#vA do
      local v       
      local vv   = vA[i]
      local done = (versionStr == nil)
      local idx  = 1
      local vStr = versionStr
      local jdx  = idx
      while (not done) do
         idx = versionStr:find("/",jdx)
         if (idx == nil) then
            done = true
            vStr = versionStr
         else
            vStr = versionStr:sub(1,idx-1)
            jdx  = idx + 1
         end
         local key   = pathJoin(sn, vStr)
         local value = vv.dirT[key]
         if (value) then
            v = value
            if (vStr == versionStr) then
               fullStr = nil
            end
         else
            done = true
         end
      end
      if (versionStr == nil or next{v} == nil) then
         vB[#vB + 1] = vv
      elseif (v) then
         vB[#vB + 1] = v
      end
   end
   dbg.printT("vB",vB)
   return fullStr, vB
end

local function search(name, moduleA)
   dbg.start{"ModuleA search(",name,",moduleA)"}
   -- First find sn and collect all v's into vA

   local sn, versionStr, vA = find_vA(name, moduleA)
   if (sn == nil) then return nil end
   local fullStr, vB        = find_vB(sn, versionStr, vA)

   dbg.print{"name: ",name,", sn: ",sn,", versionStr: ",versionStr, " fullStr: ",fullStr,"\n"}

   local extended_default = cosmic:value("LMOD_EXTENDED_DEFAULT")

   local fileA = {}
   for i = 1,#vB do
      fileA[i] = {}
      collectFileA(sn, fullStr, extended_default, vB[i], fileA[i])
   end
   dbg.fini("ModuleA search")
   return sn, versionStr, fileA
end

function M.applyWeights(self,fullNameDfltT)

   for fullName, weight in pairs(fullNameDfltT) do
      repeat
         local sn, versionStr, vA = find_vA(fullName, self.__moduleA)
         if (sn == nil) then break end
         local fullStr, vB        = find_vB(sn,  versionStr, vA)
         
         for i = 1, #vB do
            local v = vB[i]
            if (next(v.fileT) ~= nil) then
               if (fullStr) then
                  local k = pathJoin(sn, fullStr)
                  local vv = v.fileT[k]
                  if (vv) then
                     local idx = vv.wV:match("^.*()/")
                     if (idx) then
                        vv.wV = vv.wV:sub(1,idx) .. weight .. vv.wV:sub(idx+2,-1)
                     else
                        vv.wV = weight .. vv.wV:sub(2,-1)
                     end
                  end
               end
            end
         end
      until true
   end
end


function M.__find_all_defaults(self)
   local moduleA     = self.__moduleA
   local defaultT    = self.__defaultT
   local show_hidden = masterTbl().show_hidden
   local mrc         = MRC:singleton()

   local function find_all_defaults_helper(level,isNVV, mpath, sn, v)
      local weight, keepLooking, fn, idx
      local ext, count, myfullName 
      local found = false
      
      if (defaultT[sn]) then
         weight      = defaultT[sn].weight
         count       = defaultT[sn].count
         keepLooking = true
         if ( level == 1 and isNVV) then
            keepLooking = false
         end
      else
         weight      = " "
         keepLooking = true
         count       = 0
      end

      if (keepLooking) then
         if (v.file and (show_hidden or mrc:isVisible({fullName=sn, sn=sn, fn=v.file}))) then
            defaultT[sn] = {weight = "999999999.*zfinal", fullName = sn, fn = v.file, count = 1}
         elseif (next(v.fileT) ~= nil) then
            for fullName, vv in pairs(v.fileT) do
               local vis = mrc:isVisible({fullName=fullName, sn=sn, fn=vv.fn}) or isMarked(vv.wV)
               if (show_hidden or vis) then
                  count = count + 1
                  if (vis and (vv.wV > weight)) then
                     found      = true
                     weight     = vv.wV
                     ext        = vv.luaExt and ".lua" or ""
                     fn         = pathJoin(mpath, fullName .. ext)
                     myfullName = fullName
                  end
               end
            end
            if (found) then
               defaultT[sn] = { weight = weight, fullName = myfullName,
                                fn = fn, count = count}
            end
            if (defaultT[sn]) then
               defaultT[sn].count = count
            end
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            find_all_defaults_helper(level+1,isNVV, mpath, sn, vv)
         end
      end
   end 

   local isNVV      = self.__isNVV
   local level      = 0
   for i = 1, #moduleA do
      local T      = moduleA[i].T
      local mpath  = moduleA[i].mpath
      for sn, v in pairs(T) do
         find_all_defaults_helper(level+1,isNVV, mpath, sn, v)
      end
   end

   local t = {}
   for k,v in pairs(defaultT) do
      t[v.fn] = { sn = k, count = v.count, fullName = v.fullName, weight = v.weight }
   end
   self.__defaultT = t
end


function M.build_availA(self)
   dbg.start{"ModuleA:build_availA()"}
   local show_hidden = masterTbl().show_hidden
   local mrc         = MRC:singleton()

   local function build_availA_helper(mpath, sn, v, A)
      local icnt = #A
      if (v.file ) then
         if (show_hidden or mrc:isVisible({fullName=sn,sn=sn,fn=v.file})) then
            local metaModuleT = v.metaModuleT or {}
            A[icnt+1] = { fullName = sn, pV = sn, fn = v.file, sn = sn, propT = metaModuleT.propT}
         end
      end
      if (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            if (show_hidden or mrc:isVisible({fullName=fullName,sn=sn,fn=vv.fn})) then
               icnt    = icnt + 1
               A[icnt] = { fullName = fullName, pV = pathJoin(sn,vv.pV), fn = vv.fn, sn = sn, propT = vv.propT}
            end
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            build_availA_helper(mpath, sn, vv, A)
         end
      end
   end

   
   local moduleA = self.__moduleA
   local availA  = {}
   local cmp     = (cosmic:value("LMOD_CASE_INDEPENDENT_SORTING") == "yes") and
                    case_independent_cmp or regular_cmp

   for i = 1, #moduleA do
      local T         = moduleA[i].T
      local mpath     = moduleA[i].mpath
      availA[i]       = {mpath = mpath, A= {}}
      for sn, v in pairs(T) do
         build_availA_helper(mpath, sn, v, availA[i].A)
      end
      sort(availA[i].A, cmp)
   end
   dbg.fini("ModuleA:build_availA")
   return availA
end

function M.inherited_search(self, search_fullName, orig_fn)
   dbg.start{"ModuleA:inherited_search(",search_fullName,",",orig_fn,")"}

   local function inherited_search_helper(key, count, v)
      dbg.start{"inherited_search_helper(",key,",", count,",v)"}
      local fn = false
      if (v.file) then
         if (search_fullName == key) then
            if (count == 0) then
               if (v.file == orig_fn) then
                  fn = v.file
                  count = 1
               end
            elseif (count == 1) then
               fn = v.file
               count = 2
            end
            dbg.print{"found matching v.file\n"}
            dbg.fini("inherited_search_helper")
            return fn, count
         end
      elseif (next(v.fileT) ~= nil) then
         local entryT = v.fileT[search_fullName]
         if (entryT) then
            if (count == 0) then
               if (entryT.fn == orig_fn) then
                  fn    = entryT.fn
                  count = 1
               end
            elseif (count == 1) then
               fn    = entryT.fn
               count = 2
            end
            dbg.print{"found matching v.fileT\n"}
            dbg.fini("inherited_search_helper")
            return fn , count
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            fn, count = inherited_search_helper(name, count, vv)
            if (fn) then
               dbg.fini("inherited_search_helper")
               return fn, count
            end
         end
      end

      dbg.fini("inherited_search_helper")
      return fn, count
   end

   local moduleA = self.__moduleA
   local count   = 0
   local fn      = false
   for i = 1, #moduleA do
      local T     = moduleA[i].T
      local mpath = moduleA[i].mpath
      dbg.print{"mpath: ",mpath,"\n"}
      for key, v in pairs(T) do
         fn, count = inherited_search_helper(key, count, v)
         if (count == 2) then
            dbg.print{"found fn: ",fn,"\n"}
            dbg.fini("ModuleA:inherited_search")
            return fn
         end
      end
   end
   dbg.fini("ModuleA:inherited_search")
   return fn
end

function M.search(self, name)
   if (self.__isNVV) then
      return search(name, self.__moduleA)
   end

   if (not self.__locationT) then
      self.__locationT = LocationT:new(self.__moduleA)
   end

   return self.__locationT:search(name)
end

local function l_checkforNV(T)
   for sn, vv in pairs(T) do
      if (next(vv.dirT) ~= nil) then
         return false
      end
   end
   return true
end

local function build_from_spiderT(spiderT)
   dbg.start{"ModuleA build_from_spiderT(spiderT)"}
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local mpathA   = mt:modulePathA()
   local moduleA  = {}
   local isNV     = find_first == "no"
   for i = 1, #mpathA do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         dbg.print{"pulling mpath: ",mpath," into moduleA\n"}
         local T = spiderT[mpath] 
         if (T and next(T) ~= nil) then
            moduleA[#moduleA+1] = { mpath = mpath, T = deepcopy(T) }
            if (isNV) then
               isNV = l_checkforNV(T)
            end
         end
      end
   end
   dbg.fini("ModuleA build_from_spiderT")
   return moduleA, not isNV
end

------------------------------------------------------------
-- This routine updates the self.__moduleA array when 
-- MODULEPATH changes.  It has to know about how the Ctor
-- works so any changes there might be reflected here.

function M.update(self, t)
   t                  = t or {}
   dbg.start{"ModuleA:update(spider_cache=",t.spider_cache,")"}
   local frameStk     = FrameStk:singleton()
   local mt           = frameStk:mt()
   local varT         = frameStk:varT()
   local currentMPATH = varT[ModulePath]:expand()
   local mpathA       = path2pathA(currentMPATH)
   local terse        = masterTbl().terse

   ------------------------------------------------------------
   -- Store away the old moduleA entries in T (hash table).
   -- They will be reused as request by the new module path
   -- array.

   local T = {}
   local moduleA = self.__moduleA
   for i = 1,#moduleA do
      local mpath = moduleA[i].mpath
      T[mpath]    = moduleA[i].T
   end

   ------------------------------------------------------------
   -- Loop over new mpathA and either build or reuse from
   -- before.

   moduleA = {}
   for i = 1,#mpathA do
      repeat 
         local mpath = mpathA[i]
         if (not isDir(mpath)) then break end
         local entry = T[mpath]
         if (entry) then
            dbg.print{"Reusing mpath: ",mpath,"\n"}
            moduleA[#moduleA + 1] = { mpath = mpath, T = entry }
         else
            dbg.print{"building mpath: ",mpath,"\n"}
            local spiderT = false
            local dbT     = false
            if (t.spider_cache) then
               local cache = require("Cache"):singleton{quiet=terse, buildCache=true}
               spiderT, dbT = cache:build()
            end
            local mA_obj = self:__new( {mpath}, mt:maxDepthT(), getModuleRCT(), spiderT)
            local mA     = mA_obj:moduleA()
            moduleA[#moduleA + 1] = { mpath = mA[1].mpath, T = mA[1].T} 

            ------------------------------------------------------------------
            -- must transfer isNVV state over from new mpath entry.
            if (not self.__isNVV) then
               self.__isNVV = mA_obj:isNVV()
            end
         end
      until true
   end
   self.__defaultT  = {}
   self.__locationT = false
   self.__moduleA   = moduleA
   mt:updateMPathA(mpathA)
   dbg.fini("ModuleA:update")
end


function M.__new(self, mpathA, maxdepthT, moduleRCT, spiderT)
   dbg.start{"ModuleA:__new()"}
   local o = {}
   setmetatable(o,self)

   local dirTree   = false
   self.__index    = self
   o.__isNVV       = (find_first ~= "no")
   spiderT         = spiderT or {}
   if (next(spiderT) ~= nil) then
      o.__spiderBuilt        = true
      dbg.print{"calling build_from_spiderT()\n"}
      dbg.printT("spiderT",spiderT)
      o.__moduleA, o.__isNVV = build_from_spiderT(spiderT)
   else
      dbg.print{"calling DirTree:new()\n"}
      dirTree         = DirTree:new(mpathA)
      o.__spiderBuilt = false
      o.__moduleA     = build(o, maxdepthT, dirTree:dirA())
   end

   dbg.printT("moduleA:",o.__moduleA)
   dbg.print{"isNVV: ",o.__isNVV,"\n"}
   if (moduleRCT and next(moduleRCT) ~= nil) then
      dbg.print{"apply weights\n"}
      local mrc       = MRC:singleton(moduleRCT)
      o:applyWeights(mrc:fullNameDfltT())
   end
   o.__locationT   = false
   o.__defaultT    = {}

   dbg.fini("ModuleA:__new")
   return o
end

function M.moduleA(self)
   return self.__moduleA
end

function M.isNVV(self)
   return self.__isNVV
end

function M.spiderBuilt(self)
   return self.__spiderBuilt
end

function M.locationT(self)
   if (self.__isNVV) then
      return {}
   end
   if (not self.__locationT) then
      self.__locationT = LocationT:new(self.__moduleA)
   end
   return self.__locationT:locationT()
end

function M.defaultT(self)
   if (exact_match == "yes") then
      return self.__defaultT
   end

   if (next(self.__defaultT) == nil) then
      self:__find_all_defaults()
   end
   return self.__defaultT
end

function M.singleton(self, t)
   --dbg.start{"ModuleA:singleton(t)"}
   t = t or {}
   if (t.reset or (s_moduleA and s_moduleA:spiderBuilt())) then
      --dbg.print{"Wiping out old value of s_moduleA\n"}
      self:__clear()
   end
   if (not s_moduleA) then
      local frameStk = FrameStk:singleton()
      local mt       = frameStk:mt()
      local spiderT  = false
      local dbT      = false

      if (t.spider_cache) then
         --dbg.print{"calling cache:build()\n"}
         local cache  = require("Cache"):singleton{quiet=masterTbl().terse, buildCache=true}
         spiderT, dbT = cache:build()
      end
      s_moduleA = self:__new(mt:modulePathA(), mt:maxDepthT(), getModuleRCT(), spiderT)
   end

   --dbg.fini("ModuleA:singleton")
   return s_moduleA
end



function M.__clear(self)
   dbg.start{"ModuleA:__clear()"}
   local MT = require("MT")
   s_moduleA = false
   MT:__clearMT{testing=true}
   dbg.fini("ModuleA:__clear")
end

return M
