--------------------------------------------------------------------------
-- This class is a singleton controlling the version and alias mapping.
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
--  Copyright (C) 2008-2017 Robert McLay
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

local M         = {}
local dbg       = require("Dbg"):dbg()
local concatTbl = table.concat
local getenv    = os.getenv
local load      = (_VERSION == "Lua 5.1") and loadstring or load
local s_MRC     = false

------------------------------------------------------------------------
-- Local functions
local l_build             
local l_parseModA
local l_buildMod2VersionT
--------------------------------------------------------------------------
-- a private ctor that is used to construct a singleton.
-- @param self A MRC object.

local function new(self, fnA)
   local o         = {}
   o.__version2modT  = {}  -- Map a sn/version string to a module fullname
   o.__alias2modT    = {}  -- Map an alias string to a module name or alias
   o.__fullNameDfltT = {}
   o.__defaultT      = {}  -- Map module sn to fullname that is the default.
   o.__mod2versionsT = {}  -- Map from full module name to versions.
   o.__hiddenT       = {}  -- Table of hidden module names.
   o.__mod2versionT  = {}

   setmetatable(o,self)
   self.__index = self

   fnA              = fnA or getModuleRCT()
   l_build(o, fnA)
   return o
end


--------------------------------------------------------------------------
-- A singleton Ctor for the MRC class
-- @param self A MRC object.


function M.singleton(self, fnA)
   dbg.start{"MRC:singleton()"}
   if (not s_MRC) then
      s_MRC = new(self, fnA)
   end
   dbg.fini("MRC:singleton")
   return s_MRC
end


function l_build(self, fnA)
   dbg.start{"MRC l_build(self,fnA)"}
   declare("modA",{})
   local whole
   local status
   local func
   local optStr = ""
      
   for i = 1, #fnA do
      local fn     = fnA[i][1]
      if (isFile(fn)) then
         local weight = fnA[i][2]
         whole, status = runTCLprog("RC2lua.tcl", optStr, fn)
         if (not status) then
            LmodError{msg = "e_Unable_2_parse", path = fn}
         end
         
         status, func = pcall(load, whole)
         if (not status or not func) then
            LmodError{msg = "e_Unable_2_parse", path = fn}
         end
         func()
         
         l_parseModA(self, modA, weight)
      end
   end
   dbg.fini("MRC l_build")
end

function l_parseModA(self, modA, weight)
   dbg.start{"MRC l_parseModA(modA, weight)"}
   for i = 1,#modA do
      repeat 
         local entry = modA[i]
         dbg.print{"entry.kind: ",entry.kind, "\n"}

         if (entry.kind == "module-version") then
            local fullName = entry.module_name
            fullName = self:resolve(fullName)
            dbg.print{"self:resolve(fullName): ",fullName, "\n"}
   
            local _, _, shorter, mversion = fullName:find("(.*)/(.*)")
            dbg.print{"(2) fullName: ",fullName,", shorter: ",shorter,", mversion: ",mversion,"\n"}
            if (shorter == nil) then
               LmodWarning{msg="w_Broken_FullName", fullName= fullName}
               break
            end
            
            local a = entry.module_versionA
            for j = 1,#a do
               local version = a[j]
               dbg.print{"j: ",j, ", version: ",version, "\n"}
               if (version == "default") then
                  dbg.print{"Setting default: ",fullName, "\n"}
                  self.__fullNameDfltT[fullName] = weight
               else
                  local key = shorter .. '/' .. version
                  self.__version2modT[key] = fullName
                  dbg.print{"v2m: key: ",key,": ",fullName,"\n"}
               end
            end
         elseif (entry.kind == "module-alias") then
            dbg.print{"name: ",entry.name,", mfile: ", entry.mfile,"\n"}
            self.__alias2modT[entry.name] = entry.mfile
         elseif (entry.kind == "hide-version") then
            dbg.print{"mfile: ", entry.mfile,"\n"}
            self.__hiddenT[entry.mfile] = true
         end
      until true
   end
   dbg.fini("MRC:parseModA")
end

function l_buildMod2VersionT(self)
   dbg.start{"l_buildMod2VersionT(self)"}
   local v2mT = self.__version2modT
   local m2vT = {}

   for k, v in pairs(v2mT) do
      local ov= v
      v       = self:resolve(v)
      local t = m2vT[v] or {}
      t[k]    = true
      m2vT[v] = t
   end
   for modname, vv in pairs(m2vT) do
      local a = {}
      for k in pairsByKeys(vv) do
         a[#a+1] = k:gsub("^.*/","")
      end
      local s = concatTbl(a,":")
      m2vT[modname] = s
   end
   self.__mod2versionT = m2vT
   dbg.fini("l_buildMod2VersionT")
end

function M.resolve(self, name)
   local value = self.__alias2modT[name]
   if (value ~= nil) then
      name  = value
      value = self:resolve(value)
   end

   value = self.__version2modT[name]
   if (value == nil) then
      value = name
   else
      name  = value
      value = self:resolve(value)
   end
   return value

end

function M.getMod2VersionT(self, key)
   if (next(self.__mod2versionT) == nil) then
      l_buildMod2VersionT(self)
   end
   return self.__mod2versionT[key]
end


function M.parseModA_for_moduleA(self, name, modA)
   dbg.start{"MRC:parseModA_for_moduleA(",name,", modA)"}
   local defaultV = false
   for i = 1,#modA do
      local entry = modA[i]
      dbg.print{"entry.kind: ",entry.kind, "\n"}

      if (entry.kind == "module-version") then
         local fullName = entry.module_name
         if (fullName:sub(1,1) == '/') then
            fullName = name .. fullName
         end
         fullName = self:resolve(fullName)
         dbg.print{"resolve(fullName): ",fullName, "\n"}
         dbg.print{"(2) fullName: ",fullName, "\n"}
   
         local _, _, shorter, mversion = fullName:find("(.*)/(.*)")
         local a = entry.module_versionA
         for j = 1,#a do
            local version = a[j]
            dbg.print{"j: ",j, ", version: ",version, "\n"}
            if (version == "default") then
               dbg.print{"Setting default: ",fullName, "\n"}
               defaultV = fullName
            else
               local key = shorter .. '/' .. version
               self.__version2modT[key] = fullName
               dbg.print{"v2m: key: ",key,": ",fullName,"\n"}
            end
         end
      elseif (entry.kind == "set-default-version") then
         dbg.print{"version: ",entry.version,"\n"}
         defaultV = entry.version
      elseif (entry.kind == "module-alias") then
         local fullName = entry.name
         if (fullName:sub(1,1) == '/') then
            fullName = name .. fullName
         end
         fullName = self:resolve(fullName)
         local mfile = entry.mfile
         if (mfile:sub(1,1) == '/') then
            mfile = name .. mfile
         end
         dbg.print{"fullName: ",fullName,", mfile: ", mfile,"\n"}
         self.__alias2modT[fullName] = mfile
      elseif (entry.kind == "hide-version") then
         dbg.print{"mfile: ", entry.mfile,"\n"}
         self.__hiddenT[entry.mfile] = true
      end
   end
   dbg.fini("MRC:parseModA_for_moduleA")
   return defaultV
end


function M.fullNameDfltT(self)
   return self.__fullNameDfltT
end

function M.export(self)
   local t = { hiddenT      = self.__hiddenT,
               version2modT = self.__version2modT,
               alias2modT   = self.__alias2modT,
   }
   return serializeTbl{indent = true, name = "mrcT", value = t }
end

local s_must_convert = true
function M.getHiddenT(self,k)
   local t = {}
   if (s_must_convert) then
      s_must_convert = false

      local hT = self.__hiddenT
      for key in pairs(hT) do
         t[self:resolve(key)] = true
      end
      self.__hiddenT = t
   end
   return self.__hiddenT[k]
end

function M.import(self, mrcT)
   for kk,vv in pairs(mrcT) do
      local key = "__" .. kk
      local t   = self[key]
      for k,v in pairs(vv) do
         t[k] = v
      end
   end
end

function M.isVisible(self, name)
   if (self:getHiddenT(name)) then
      return false
   end
   if (name:sub(1,1) == ".") then
      return false
   end
   local idx = name:find("/%.")
   return idx == nil
end

function M.update(self, fnA)
   dbg.start{"MRC:update(fnA)"}
   fnA = fnA or getModuleRCT()
   l_build(self,fnA)
   dbg.fini("MRC:update")
end

return M
