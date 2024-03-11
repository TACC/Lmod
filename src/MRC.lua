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
local concatTbl = table.concat
local getenv    = os.getenv
local load      = (_VERSION == "Lua 5.1") and loadstring or load
local s_MRC     = false
local hook      = require("Hook")

local function l_argsPack(...)
   local argA = { n = select("#", ...), ...}
   return argA
end
local pack      = (_VERSION == "Lua 5.1") and l_argsPack or table.pack  -- luacheck: compat

------------------------------------------------------------------------
-- Local functions
local l_build
local l_buildMod2VersionT
--------------------------------------------------------------------------
-- a private ctor that is used to construct a singleton.
-- @param self A MRC object.

local function l_new(self, fnA)
   --dbg.start{"MRC l_new(fnA)"}
   local o              = {}
   o.__mpathT           = {}  -- mpath dependent values for alias2modT, version2modT
                              -- and hiddenT.
   o.__version2modT     = {}  -- Map a sn/version string to a module fullname
   o.__alias2modT       = {}  -- Map an alias string to a module name or alias
   o.__fullNameDfltT    = {}
   o.__defaultT         = {}  -- Map module sn to fullname that is the default.
   o.__hiddenT          = {}  -- Table of hidden module names and modulefiles.
   o.__mod2versionT     = {}  -- Map from full module name to versions.
   o.__full2aliasesT    = {}
   o.__mergedAlias2modT = {}
   setmetatable(o,self)
   self.__index = self

   l_build(o, fnA or getModuleRCT())
   --dbg.fini("MRC l_new")
   return o
end


--------------------------------------------------------------------------
-- A singleton Ctor for the MRC class
-- @param self A MRC object.


function M.singleton(self, fnA)
   --dbg.start{"MRC:singleton()"}
   if (not s_MRC) then
      s_MRC = l_new(self, fnA)
   end
   --dbg.fini("MRC:singleton")
   return s_MRC
end


function M.__clear(self)
   --dbg.start{"MRC:__clear()"}
   s_MRC = nil
   --dbg.fini("MRC:__clear")
end

function l_build(self, fnA)
   --dbg.start{"MRC l_build(self,fnA)"}
   --dbg.printT("fnA",fnA)
   for i = 1, #fnA do
      local fn     = fnA[i][1]
      if (isFile(fn)) then
         local weight = fnA[i][2]
         local modA   = mrc_load(fn)
         self:parseModA(modA, weight)
      end
   end
   --dbg.fini("MRC l_build")
end

function M.parseModA(self, modA, weight)
   --dbg.start{"MRC:parseModA(modA, weight: \"",weight,"\")"}

   for i = 1,#modA do
      repeat
         local entry = modA[i]
         --dbg.print{"entry.kind: ",entry.kind, "\n"}

         if (entry.kind == "module_version") then
            local fullName = entry.module_name
            fullName = self:resolve({}, fullName)
            --dbg.print{"self:resolve({}, fullName): ",fullName, "\n"}

            local _, _, shorter, mversion = fullName:find("(.*)/(.*)")
            --dbg.print{"(2) fullName: ",fullName,", shorter: ",shorter,", mversion: ",mversion,"\n"}
            if (shorter == nil) then
               LmodWarning{msg="w_Broken_FullName", fullName= fullName}
               break
            end

            local a = entry.module_versionA
            for j = 1,#a do
               local version = a[j]
               --dbg.print{"j: ",j, ", version: ",version, "\n"}
               if (version == "default") then
                  --dbg.print{"Setting default: ",fullName, "\n"}
                  self.__fullNameDfltT[fullName] = weight
               else
                  local key = shorter .. '/' .. version
                  self.__version2modT[key] = fullName
                  --dbg.print{"v2m: key: ",key,": ",fullName,"\n"}
               end
            end
         elseif (entry.kind == "module_alias") then
            --dbg.print{"name: ",entry.name,", mfile: ", entry.mfile,"\n"}
            self.__alias2modT[entry.name] = entry.mfile
         elseif (entry.kind == "hide_version") then
            --dbg.print{"mfile: ", entry.mfile,"\n"}
            self.__hiddenT[entry.mfile] = true
         elseif (entry.kind == "hide_modulefile") then
            --dbg.print{"mfile: ", entry.mfile,"\n"}
            self.__hiddenT[entry.mfile] = true
         end
      until true
   end
   --dbg.fini("MRC:parseModA")
end

function l_buildMod2VersionT(self, mpathA)
   --dbg.start{"l_buildMod2VersionT(self, mpathA)"}
   local v2mT = {}
   local m2vT = {}
   local f2aT = {}
   local mA2T = {}

   --dbg.printT("self.__version2modT", self.__version2modT)
   --dbg.printT("self.__alias2modT",   self.__alias2modT)
   --dbg.printT("mrcMpathT", self.__mpathT)


   local t
   for i = #mpathA, 1, -1 do
      local mpath = mpathA[i]
      if (self.__mpathT[mpath]) then
         t = self.__mpathT[mpath].version2modT
         if (t) then
            for k, v in pairs(t) do
               v2mT[k] = v
            end
         end
         t = self.__mpathT[mpath].alias2modT
         if (t) then
            for k, v in pairs(t) do
               mA2T[k] = v
            end
         end
      end
   end

   local t = self.__version2modT
   for k, v in pairs(t) do
      v2mT[k] = v
   end

   local t = self.__alias2modT
   for k, v in pairs(t) do
      mA2T[k] = v
   end
      
   --dbg.printT("v2mT",v2mT)

   for k, v in pairs(v2mT) do
      v       = self:resolve(mpathA, v)
      local t = m2vT[v] or {}
      t[k]    = true
      m2vT[v] = t
   end
   for modname, vv in pairsByKeys(m2vT) do
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
   self.__mod2versionT  = m2vT
   self.__full2aliasesT = f2aT
   self.__mergedAlias2modT = mA2T
   --dbg.printT("full2aliasesT",    f2aT)
   --dbg.printT("mod2versionT",     m2vT)
   --dbg.printT("mergedAlias2modT", mA2T)
   --dbg.fini("l_buildMod2VersionT")
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
   dbg.print{"MRC:resolve: 1) name: ",name,", value: ",value,"\n"}
   if (value ~= nil) then
      name  = value
      value = self:resolve(mpathA, value)
   end

   if (name == "intel/15") then
      dbg.printT("version2modT",self.__version2modT)
      dbg.printT("mpathT",self.__mpathT)
   end
   
   value = l_find_alias_value("version2modT", self.__version2modT, self.__mpathT, mpathA, name)
   dbg.print{"MRC:resolve: 2) name: ",name,", value: ",value,"\n"}
   if (value == nil) then
      value = name
   else
      name  = value
      value = self:resolve(mpathA, value)
   end
   return value
end



function M.getMod2VersionT(self, mpathA, key)
   if (next(self.__mod2versionT) == nil) then
      l_buildMod2VersionT(self, mpathA)
   end
   return self.__mod2versionT[key]
end

function M.getFull2AliasesT(self, mpathA, key)
   if (next(self.__full2aliasesT) == nil) then
      l_buildMod2VersionT(self, mpathA)
   end
   return self.__full2aliasesT[key]
end

function M.getAlias2ModT(self, mpathA)
   if (next(self.__mergedAlias2modT) == nil) then
      l_buildMod2VersionT(self, mpathA)
   end
   return self.__mergedAlias2modT
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
   --dbg.start{"MRC:parseModA_for_moduleA(name: ",name,", mpath: ",mpath,", modA)"}
   local defaultV = false
   for i = 1,#modA do
      local entry = modA[i]
      --dbg.print{"entry.kind: ",entry.kind, "\n"}

      if (entry.kind == "module_version") then
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
      elseif (entry.kind == "set_default_version") then
         --dbg.print{"version: ",entry.version,"\n"}
         defaultV = entry.version
      elseif (entry.kind == "module_alias") then
         local fullName = entry.name
         if (fullName:sub(1,1) == '/') then
            fullName = name .. fullName
         end
         local mfile = entry.mfile
         --dbg.print{"fullName: ",fullName,", mfile: ", mfile,"\n"}
         l_store_mpathT(self, mpath, "alias2modT", fullName, mfile);
      elseif (entry.kind == "hide_version" or entry.kind == "hide_modulefile") then
         --dbg.print{"mfile: ", entry.mfile,"\n"}
         l_store_mpathT(self, mpath, "hiddenT", entry.mfile, true);
      end
   end
   --dbg.fini("MRC:parseModA_for_moduleA")
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
   a[1] = serializeTbl{indent = true, name = "mrcT",      value = t         }
   a[2] = serializeTbl{indent = true, name = "mrcMpathT", value = mrcMpathT }
   return concatTbl(a,"\n")
end

local s_must_convert = true
function M.getHiddenT(self, mpathA, k)
   local t = {}
   if (s_must_convert) then
      s_must_convert = false

      local hT
      for i = #mpathA, 1, -1 do
         local mpath = mpathA[i]
         if (self.__mpathT[mpath]) then
            hT = self.__mpathT[mpath].hiddenT
            if (hT) then
               for key in pairs(hT) do
                  t[self:resolve(mpathA, key)] = true
               end
            end
         end
      end

      hT = self.__hiddenT
      for key in pairs(hT) do
         t[self:resolve(mpathA, key)] = true
      end
      self.__hiddenT = t
   end
   return self.__hiddenT[k]
end

local function l_import_helper(self,entryT)
   if (entryT and next(entryT) ~= nil) then
      for kk,vv in pairs(entryT) do
         local key = "__" .. kk
         local t   = self[key]
         for k,v in pairs(vv) do
            t[k] = v
         end
      end
   end
end

function M.import(self, mrcT, mrcMpathT)
   --dbg.start{"MRC:import()"}
   --dbg.print{"mrcMpathT :",mrcMpathT,"\n"}
   if (mrcMpathT and next(mrcMpathT) ~= nil) then
      for mpath, v in pairs(mrcMpathT) do
         for tblName, vv in pairs(v) do
            for key, value in pairs(vv) do
               l_store_mpathT(self, mpath, tblName, key, value)
            end
         end
      end
   end
   l_import_helper(self, mrcT)
   --dbg.fini("MRC:import")
end

-- modT is a table with: sn, fullName and fn
function M.isVisible(self, modT)
   local frameStk  = require("FrameStk"):singleton()
   local mname     = frameStk:mname()
   local mt        = frameStk:mt()
   local mpathA    = modT.mpathA or mt:modulePathA()
   local name      = modT.fullName
   local fn        = modT.fn
   local isVisible = true

   if (self:getHiddenT(mpathA, name) or self:getHiddenT(mpathA, fn)) then
      isVisible = false
   elseif (name:sub(1,1) == ".") then
      isVisible = false
   else
      local idx = name:find("/%.")
      isVisible = idx == nil
   end

   modT.isVisible = isVisible
   modT.mname     = mname
   modT.mt        = mt
   hook.apply("isVisibleHook", modT)

   return modT.isVisible
end

function M.update(self, fnA)
   --dbg.start{"MRC:update(fnA)"}
   fnA = fnA or getModuleRCT()
   l_build(self,fnA)
   --dbg.fini("MRC:update")
end



return M
