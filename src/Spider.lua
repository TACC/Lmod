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
--  Copyright (C) 2008-2014 Robert McLay
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

--------------------------------------------------------------------------
-- Spider.lua: This Class walks the MODULEPATH.
--------------------------------------------------------------------------

require("TermWidth")
require("strict")
require("string_utils")
require("fileOps")
require("escape")
require("fillWords")
require("capture")
require("pairsByKeys")
require("pager")
require("caseIndependent")
require("utils")

local M = {}

local CTimer       = require("CTimer")
local concatTbl    = table.concat
local dbg          = require("Dbg"):dbg()
local lfs          = require("lfs")
local max          = math.max
local posix        = require("posix")
local systemG      = _G
local gettimeofday = posix.gettimeofday
local sort         = table.sort
local timer        = require("Timer"):timer()
local function nothing()
end

KeyT = {Description=1, Name=1, URL=1, Version=1, Category=1, Keyword=1}

function processLPATH(value)
   if (value == nil) then return end
   local masterTbl      = masterTbl()
   local moduleStack    = masterTbl.moduleStack
   local iStack         = #moduleStack
   local path           = moduleStack[iStack].path
   local moduleT        = moduleStack[iStack].moduleT

   local lpathA         = moduleT[path].lpathA or {}
   value                = path_regularize(value)
   lpathA[value]        = 1
   moduleT[path].lpathA = lpathA
end

function processPATH(value)
   if (value == nil) then return end

   local masterTbl     = masterTbl()
   local moduleStack   = masterTbl.moduleStack
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT

   local pathA         = moduleT[path].pathA or {}
   value               = path_regularize(value)
   pathA[value]        = 1
   moduleT[path].pathA = pathA
end

function Spider_append_path(kind, t)
   local name  = t[1]
   local value = t[2]
   if (name == "MODULEPATH") then
      dbg.start{kind,"(MODULEPATH=\"",name,"\", value=\"",value,"\")"}
      processNewModulePATH(value)
      dbg.fini(kind)
   elseif (name == "PATH") then
      dbg.start{kind, "(PATH: \"",name,"\", value=\"",value,"\")"}
      processPATH(value)
      dbg.fini(kind)
   elseif (name == "LD_LIBRARY_PATH") then
      dbg.start{kind, "(LD_LIBRARY_PATH: \"",name,"\", value=\"",value,"\")"}
      processLPATH(value)
      dbg.fini(kind)
   end
end

local modulepathT = {}

function processNewModulePATH(value)
   if (value == nil) then return end
   dbg.start{"processNewModulePATH(value=\"",value,"\")"}

   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   if (masterTbl.no_recursion) then
      dbg.fini("processNewModulePATH")
      return
   end

   for v in value:split(":") do
      v = path_regularize(v)
      dbg.print{"v: ", v,"\n"}
      local path    = moduleStack[iStack].path
      local full    = moduleStack[iStack].full
      local moduleT = moduleStack[iStack].moduleT
      dbg.print{"path: ",path,"\n"}
      if ( modulepathT[v] ) then
         moduleT[path].children[v]      = modulepathT[v]
         moduleT[path].children.version = Cversion
      else
         iStack              = iStack+1
         moduleStack[iStack] = {path = path, full = full,
                                moduleT = moduleT[path].children, fn= v}
         dbg.print{"Top of Stack: ",iStack, " Full: ", full, " file: ", path, "\n"}
         moduleT[path].children[v] = {}
         moduleT[path].children.version = Cversion
         M.findModulesInDir(v, v, "", moduleT[path].children[v])
         modulepathT[v]      = true
         moduleStack[iStack] = nil
         modulepathT[v]      = moduleT[path].children[v]
         iStack              = iStack - 1
      end
   end

   dbg.fini("processNewModulePATH")
end

------------------------------------------------------------
--module("Spider")
------------------------------------------------------------

function M.new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   self.__name  = false
   return o
end

function M.setExactMatch(self, name)
   self.__name  = name
end

function M.getExactMatch(self)
   return self.__name
end


--local function findMarkedDefault(mpath, path)
--   local mt       = MT:mt()
--   local localDir = true
--   --dbg.start{"Spider:findMarkedDefault(",mpath,", ", path,")"}
--   mpath         = abspath(mpath)
--   path          = abspath(path)
--   local i,j     = path:find(mpath)
--   local sn      = ""
--   if (j and path:sub(j+1,j+1) == '/') then
--      sn = path:sub(j+2)
--   end
--   local localdir = true
--   local default  = pathJoin(path, "default")
--   default        = abspath_localdir(default) 
--   if (default == nil) then
--      local dfltA = {"/.modulerc", "/.version"}
--      local vf    = false
--      for i = 1, #dfltA do
--         local n   = dfltA[i]
--         local vFn = abspath_localdir(pathJoin(path, n))
--         if (isFile(vFn)) then
--            vf = versionFile(n, sn, vFn)
--            break
--         end
--      end
--      if (vf) then
--         local f = pathJoin(path,vf)
--         default = abspath_localdir(f)
--         if (default == nil) then
--            local fn = vf .. ".lua"
--            local f  = pathJoin(path,fn)
--            default  = abspath_localdir(f)
--         end
--      end
--   end
--   if (default) then
--      default = abspath_localdir(default)
--   end
--   --dbg.print{"(4) default: \"",default,"\"\n"}
--
--   --dbg.fini("Spider:findMarkedDefault")
--   return default or false
--end


--------------------------------------------------------------------------
-- Keep this function.  Yes this function is not safe with c/n/v name
-- schemes but it is O.K. The places that this function is used in this
-- file have been deemed safe.

local function shortName(full)
   local i,j = full:find(".*/")
   return full:sub(1,(j or 0) - 1)
end

local function registerModuleT(full, sn, f, markedDefault)
   local t = {}

   local fabs      = abspath_localdir(f)
   if (not fabs) then
      fabs = abspath_localdir(f..".lua"):gsub("%.lua$","")
   end
   t.path          = f
   t.name          = sn
   t.name_lower    = sn:lower()
   t.full          = full
   t.full_lower    = full:lower()
   t.epoch         = posix.stat(f, "mtime")
   t.markedDefault = (fabs == markedDefault)
   t.children      = {}

   return t
end

function M.findModulesInDir(mpath, path, prefix, moduleT)
   local t1
   dbg.start{"findModulesInDir(mpath=\"",mpath,"\", path=\"",path,
             "\", prefix=\"",prefix,"\")"}

   local Pairs = dbg.active() and pairsByKeys or pairs
   local attr  = lfs.attributes(path)
   if (not attr or  type(attr) ~= "table" or attr.mode ~= "directory" or
       not posix.access(path,"rx")) then
      dbg.print{"Directory: ",path," is non-existant or is not readable\n"}
      dbg.fini("findModulesInDir")
      return
   end

   local Pairs       = dbg.active() and pairsByKeys or pairs
   local shellN      = "bash"
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   local mt          = MT:mt()
   local ignoreT     = ignoreFileT()
   local cTimer      = CTimer:cTimer()
   local accept_fn   = accept_fn
   local defaultIdx  = 1000000  -- default idx must be bigger than index for .version

   local mnameT      = {}
   local dirA        = {}
   local defaultFn   = walk_directory_for_mf(mpath, path, prefix, dirA, mnameT)
   
   cTimer:test()

   if (#dirA > 0 or prefix == '') then
      for k,v in Pairs(mnameT) do
         local full = k
         local sn   = k
         moduleT[v.fn] = registerModuleT(full, sn, v.fn, nil)
         moduleStack[iStack] = {path= v.fn, sn = sn, full = full, moduleT = moduleT, fn = v.fn}
         dbg.print{"Top of Stack: ",iStack, " Full: ", full, " fn: ", v.fn, "\n"}

         local t = {fn = v.fn, modFullName = k, modName = sn, default = true, hash = 0}
         mt:add(t,"pending")
         loadModuleFile{file=v.fn, shell=shellN, reportErr=true}
         mt:setStatus(t.modName,"active")
         dbg.print{"Saving: Full: ", k, " Name: ", k, " file: ",v.fn,"\n"}
      end
      for i = 1, #dirA do
         M.findModulesInDir(mpath, dirA[i].fullName, dirA[i].mname .. '/', moduleT)
      end
   else
      if (defaultFn) then
         local d, v = splitFileName(defaultFn)
         v          = "/" .. v
         if (v == "/default") then
            defaultFn = abspath_localdir(defaultFn)
         else
            local sn  = prefix:gsub("/+$","")
            v         = versionFile(v, sn, defaultFn, true)
            local f   = pathJoin(d,v)
            defaultFn = abspath_localdir(f)
            if (defaultFn == nil) then
               f      = f .. ".lua"
               defaultFn = abspath_localdir(f)
            end
         end
      end
      dbg.print{"defaultFn: ",defaultFn,"\n"}
      for full,v in Pairs(mnameT) do
         local sn   = shortName(full)
         moduleT[v.fn] = registerModuleT(full, sn, v.fn, defaultFn)
         moduleStack[iStack] = {path=v.fn, sn = sn, full = full, moduleT = moduleT,
                                fn = v.fn}
         dbg.print{"Top of Stack: ",iStack, " Full: ", full, " fn: ", v.fn, "\n"}
         local t = {fn = v.fn, modFullName = full, modName = sn, default = 0, hash = 0}
         mt:add(t,"pending")
         loadModuleFile{file=v.fn, shell=shellN, reportErr=true}
         mt:setStatus(t.modName,"active")
         dbg.print{"Saving: Full: ", full, " Name: ", sn, " fn: ",v.fn,"\n"}
      end
   end
   dbg.fini("findModulesInDir")
end

function M.findAllModules(self, moduleDirA, moduleT)
   dbg.start{"Spider:findAllModules(",concatTbl(moduleDirA,", "),")"}

   if (next(moduleT) == nil) then
      moduleT.version = Cversion
   end

   local masterTbl       = masterTbl()
   local moduleDirT      = {}
   masterTbl.moduleDirT  = moduleDirT
   masterTbl.moduleT     = moduleT
   masterTbl.moduleStack = {{}}
   local exit            = os.exit
   os.exit               = nothing
   local mt              = MT:mt()

   ------------------------------------------------------------
   -- Create a temporary Module Table to spider all modulefiles
   -- clear it when finished.
   mt.cloneMT()

   for _,v in ipairs(moduleDirA) do
      local mpath = path_regularize(v)
      local attr  = lfs.attributes(mpath)
      if (attr and attr.mode == "directory" and
          posix.access(mpath,"rx") and moduleDirT[v] == nil) then
         moduleDirT[v] = 1
         moduleT[v]    = {}
         M.findModulesInDir(v, v, "", moduleT[v])
      end
   end
   os.exit     = exit

   ------------------------------------------------------------
   -- clear temporary MT
   mt.popMT()
   dbg.fini("Spider:findAllModules")
end

function M.buildSpiderDB(self, a, moduleT, dbT)
   dbg.start{"Spider:buildSpiderDB({",concatTbl(a,","),"},moduleT, dbT)"}
   dbg.print{"moduleT.version: ",moduleT.version,"\n"}

   if (next(moduleT) == nil) then
      dbg.fini("Spider:buildSpiderDB")
      return
   end

   local version = moduleT.version or 0

   if ( version < Cversion) then
      LmodError("old version moduleT\n")
   else
      dbg.print{"Current version moduleT.\n"}
      local Pairs = dbg.active() and pairsByKeys or pairs
      for mpath, v in Pairs(moduleT) do
         if (type(v) == "table") then
            dbg.print{"mpath: ",mpath, "\n"}
            self:singleSpiderDB(a,v, dbT)
         end
      end
   end
   dbg.fini("Spider:buildSpiderDB")
end

function M.singleSpiderDB(self, a, moduleT, dbT)
   dbg.start{"Spider:singleSpiderDB({",concatTbl(a,","),"},moduleT, dbT)"}
   local Pairs = dbg.active() and pairsByKeys or pairs
   for path, value in Pairs(moduleT) do
      dbg.print{"path: ",path,"\n"}
      local name  = value.name
      dbT[name]   = dbT[name] or {}
      local t     = dbT[name]

      for k, v in pairs(value) do
         if (t[path] == nil) then
            t[path] = {}
         end
         if (k ~= "children") then
            t[path][k] = v
         end
      end
      local parent = t[path].parent or {}
      local entry  = concatTbl(a,":")
      local found  = false
      for i = 1,#parent do
         if ( entry == parent[i]) then
            found = true
            break;
         end
      end
      if (not found) then
         parent[#parent+1] = entry
      end
      sort(parent)

      t[path].parent = parent
      if (next(value.children)) then
         a[#a+1] = t[path].full
         self:buildSpiderDB(a, value.children, dbT)
         a[#a]   = nil
      end
   end
   dbg.fini("Spider:singleSpiderDB")
end

function M.searchSpiderDB(self, strA, a, moduleT, dbT)
   dbg.start{"Spider:searchSpiderDB({",concatTbl(a,","),"},moduleT, dbT)"}

   local version = moduleT.version or 0

   if (version < Cversion) then
      LmodError("old version moduleT.\n")
   else
      dbg.print{"Current version moduleT\n"}
      for mpath, v in pairsByKeys(moduleT) do
         if (type(v) == "table") then
            dbg.print{"mpath: ",mpath, "\n"}
            self:singleSearchSpiderDB(strA, a, v, dbT)
         end
      end
   end
   dbg.fini("Spider:searchSpiderDB")
end

function M.singleSearchSpiderDB(self, strA, a, moduleT, dbT)
   dbg.start{"Spider:singleSearchSpiderDB()"}

   for path, value in pairsByKeys(moduleT) do
      local name    = value.name or ""
      local full    = value.full
      local whatisT = value.whatis or {}
      local whatisS = concatTbl(whatisT,"\n")

      if (dbT[name] == nil) then
         dbT[name] = {}
      end
      local t = dbT[name]

      local found = false
      for i = 1,#strA do
         local str = strA[i]:lower()
         if (name:find(str) or whatisS:find(str)) then
            dbg.print{"found txt in name: ",name,"\n"}
            found = true
            break
         end
      end
      if (found) then
         for k, v in pairs(value) do
            if (t[path] == nil) then
               t[path] = {}
            end
            if (k ~= "children") then
               t[path][k] = v
            end
         end
         local parent = t[path].parent or {}
         parent[#parent+1] = concatTbl(a,":")
         t[path].parent = parent
      end
      if (next(value.children)) then
         a[#a+1] = full
         self:searchSpiderDB(strA, a, value.children, dbT)
         a[#a]   = nil
      end
   end
   dbg.fini("Spider:singleSearchSpiderDB")
end

function M.Level0(self, dbT)
   local a         = {}
   local masterTbl = masterTbl()
   local terse     = masterTbl.terse

   if (terse) then
      dbg.start{"Spider:Level0()"}
      local t  = {}
      for kk, vv in pairs(dbT) do
         for k, v in pairs(vv) do
            local version = extractVersion(v.full, v.name)
            if ((version or ""):sub(1,1) ~= ".") then
               if (v.name == v.full) then
                  t[v.name] = v.name
               else
                  -- print out directory name (e.g. gcc) for tab completion.
                  t[v.name] = v.name .. "/"
                  local key = v.name .. "/" .. parseVersion(version)
                  t[key]    = v.full
               end
            end
         end
      end
      for k,v in pairsByKeys(t) do
         a[#a+1] = v
      end
      dbg.fini("Spider:Level0")
      return concatTbl(a,"\n")
   end


   local ia     = 0
   local border = banner:border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = border
   ia = ia+1; a[ia] = "The following is a list of the modules currently available:\n"
   ia = ia+1; a[ia] = border

   self:Level0Helper(dbT,a)

   return concatTbl(a,"")
end

function M.Level0Helper(self, dbT,a)
   local t          = {}
   local term_width = TermWidth() - 4

   for kk,vv in pairs(dbT) do
      for k,v in pairsByKeys(vv) do
         local version = extractVersion(v.full, v.name)
         if ((version or ""):sub(1,1) ~= ".") then
            if (t[kk] == nil) then
               t[kk] = { Description = v.Description, Versions = { }, name = v.name}
            end
            t[kk].Versions[parseVersion(version)] = v.full
         end
      end
   end

   local ia  = #a
   local cmp = (LMOD_CASE_INDEPENDENT_SORTING:lower():sub(1,1) == "y") and 
               case_independent_cmp or nil
   for k,v in pairsByKeys(t,cmp) do
      local len = 0
      ia = ia + 1; a[ia] = "  " .. v.name .. ":"
      len = len + a[ia]:len()
      for kk,full in pairsByKeys(v.Versions) do
         ia = ia + 1; a[ia] = " " .. full; len = len + a[ia]:len() + 1
         if (len > term_width) then
            a[ia] = " ..."
            ia = ia + 1; a[ia] = ","
            break;
         end
         ia = ia + 1; a[ia] = ","
      end
      a[ia] = "\n"  -- overwrite the last comma
      if (v.Description) then
         ia = ia + 1; a[ia] = fillWords("    ",v.Description, term_width)
         ia = ia + 1; a[ia] = "\n"
      end
      ia = ia + 1; a[ia] = "\n"
   end
   local border = banner:border(0)
   ia = ia+1; a[ia] = border
   ia = ia+1; a[ia] = "To learn more about a package enter:\n\n"
   ia = ia+1; a[ia] = "   $ module spider Foo\n\n"
   ia = ia+1; a[ia] = "where \"Foo\" is the name of a module\n\n"
   ia = ia+1; a[ia] = "To find detailed information about a particular package you\n"
   ia = ia+1; a[ia] = "must enter the version if there is more than one version:\n\n"
   ia = ia+1; a[ia] = "   $ module spider Foo/11.1\n"
   ia = ia+1; a[ia] = border

end


local function countEntries(t, sn, searchPat, searchName)
   dbg.start{"countEntries(t,\"",sn,"\", \"", searchPat,"\", \"",searchName,"\")"}
   local count   = 0
   local nameCnt = 0
   local fullCnt = 0
   local full    = false
   local search  = (searchPat or "")
   local searchV = extractVersion(searchName, sn)
   for k,v in pairs(t) do
      local version = extractVersion(v.full, v.name) or ""
      dbg.print{"\nversion: ",version, ", searchV: ",searchV,"\n"}
      if (version:sub(1,1) ~= ".") then
         count = count + 1
         if (not full and not searchV) then
            full = v.full
            dbg.print{"(1) setting full: ",full,"\n"}
         end
         if (v.name:find(search)) then
            nameCnt = nameCnt + 1
            dbg.print{"(2) nameCnt\n"}
            if (not searchV or version == searchV) then
               full  = v.full
               dbg.print{"(2) setting full: ",full,"\n"}
            end
         end
         local i, j = v.full:find(searchName)
         if (i) then
            local flen = v.full:len()
            if (flen == j - i + 1) then
               fullCnt = fullCnt + 1
               full  = v.full
               dbg.print{"(3) setting full: ",full,"\n"}
            end
         end
      end
   end
   dbg.fini("countEntries")
   return count, nameCnt, fullCnt, full
end

function M.spiderSearch(self, dbT, searchName, help)
   dbg.start{"Spider:spiderSearch(dbT,\"",searchName,"\")"}
   local found     = false
   local masterTbl = masterTbl()

   local A  = {}
   A[1]     = { orig = searchName, pattern = searchName }
   local sn = shortName(searchName)
   if (sn ~= A[1].orig) then
      A[2]  = { orig = sn, pattern = sn }
   end

   if (not masterTbl.regexp) then
      for i = 1, #A do
         A[i].pattern = caseIndependent(A[i].pattern)
      end
   end

   local a     = {}
   for i = 1, #A do
      local search = A[i].orig
      local T = dbT[search]
      if (T) then
         local possibleA = {}
         local ja        = 0
         for k, v in pairsByKeys(dbT) do
            for j = 1, #A do
               local searchPat = A[j].pattern
               if (k:find(searchPat) and k ~= search) then
                  ja = ja + 1; possibleA[ja] = k
               end
            end
         end

         if (ja > 0) then
            self:setExactMatch(searchName)
         end

         dbg.print{"Found exact match: search: ",search,"\n"}
         local s     = self:_Level1(A[i].pattern, search, T, searchName, possibleA, help)
         if (s) then
            a[#a+1] = s
         end
         found = true
      end
   end



   if (not found) then
      for k, v in pairsByKeys(dbT) do
         for i = 1, #A do
            local search = A[i].pattern
            if (k:find(search)) then
               found = true
               dbg.print{"Found inexact match: search: ",search,", k: ",k,"\n"}
               local s = self:_Level1(A[i].pattern, k, v, searchName, {}, help)
               if (s) then
                  a[#a+1] = s
               end
            end
         end
      end
   end

   if (not found) then
      setWarningFlag()
      io.stderr:write("Unable to find: \"",searchName,"\"\n")

      if (escape(searchName) ~= searchName) then
         io.stderr:write("\nRegular Expressions require:\n   $ module -r spider '",searchName,"'\n")
      end
         

   end
   dbg.fini("Spider:spiderSearch")
   return concatTbl(a,"")
end

function M._Level1(self, searchPat, key, T, searchName, possibleA, help)
   dbg.start{"Spider:_Level1(",searchPat,", ", key,", T,\"",searchName,"\",help=",help,")"}
   local term_width = TermWidth() - 4

   if (T == nil) then
      dbg.print{"No entry called: \"",searchName, "\" in dbT\n"}
      dbg.fini("Spider:_Level1")
      return ""
   end

   local cnt, nameCnt, fullCnt, full = countEntries(T, key, searchPat, searchName)
   dbg.print{"Number of entries: ",cnt ," name count: ",nameCnt,
             " full count: ",fullCnt, " full: ", full, "\n"}
   dbg.print{"key: \"",key,"\" searchName: \"",searchName,"\"\n"}

   --if ((key:len() < searchName:len() and fullCnt == 0 ) or
   --    (cnt == 0 and fullCnt == 0)) then
   if ((nameCnt == 0 and fullCnt == 0) or (not full)) then
      LmodSystemError("Unable to find: \"",searchName,"\"")
      dbg.fini("Spider:_Level1")
      return ""
   end

   if (cnt == 1 or nameCnt == 1 or fullCnt > 0) then
      local s = self:_Level2(T, searchName, full, possibleA)
      dbg.fini("Spider:_Level1")
      return s
   end

   local border = banner:border(0)
   local VersionT = {}
   local exampleV = nil
   local key = nil
   local Description = nil
   for k, v in pairsByKeys(T) do
      local version = extractVersion(v.full, v.name) or ""
      if (version:sub(1,1) ~= ".") then
         local kk            = v.name .. "/" .. parseVersion(version)
         if (VersionT[kk] == nil) then
            key              = v.name
            Description      = v.Description
            VersionT[kk]     = v.full
            exampleV         = v.full
         end
      end
   end

   local a  = {}
   local ia = 0

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   ia = ia + 1; a[ia] = "  " .. key .. ":\n"
   ia = ia + 1; a[ia] = border
   if (Description) then
      ia = ia + 1; a[ia] = "    Description:\n"
      ia = ia + 1; a[ia] = fillWords("      ",Description,term_width)
      ia = ia + 1; a[ia] = "\n\n"
   end
   ia = ia + 1; a[ia] = "     Versions:\n"
   for k, v in pairsByKeys(VersionT) do
      ia = ia + 1; a[ia] = "        " .. v .. "\n"
   end

   if (#possibleA > 0) then
      local b   = {}
      local sum = 17
      local num = #possibleA
      for ja = 1, num do
         b[#b+1] = possibleA[ja]
         sum     = sum + possibleA[ja]:len() + 2
         if (sum > term_width and ja < num - 1) then
            b[#b+1] = "..."
            break
         end
      end
      ia = ia + 1; a[ia] = "\n     Other possible modules matches:\n        "
      ia = ia + 1; a[ia] = concatTbl(b,", ")
      ia = ia + 1; a[ia] = "\n"
   end

   if (help) then
      ia = ia + 1; a[ia] = "\n"
      local name = self:getExactMatch()
      if (name) then
         ia = ia + 1; a[ia] = border
         ia = ia + 1; a[ia] = "  To find other possible module matches do:\n"
         ia = ia + 1; a[ia] = "      module -r spider '.*"
         ia = ia + 1; a[ia] = name
         ia = ia + 1; a[ia] = ".*'\n\n"
      end

      ia = ia + 1; a[ia] = border
      ia = ia + 1; a[ia] = "  To find detailed information about "
      ia = ia + 1; a[ia] = key
      ia = ia + 1; a[ia] = " please enter the full name.\n  For example:\n\n"
      ia = ia + 1; a[ia] = "     $ module spider "
      ia = ia + 1; a[ia] = exampleV
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = border
   end

   dbg.fini("Spider:_Level1")
   return concatTbl(a,"")

end

function M._Level2(self, T, searchName, full, possibleA)
   dbg.start{"Spider:_Level2(T,\"",searchName,"\", \"",full,"\",possibleA)"}
   local a  = {}
   local ia = 0
   local b  = {}
   local c  = {}
   local titleIdx = 0

   local propDisplayT = getPropT()

   local term_width = TermWidth() - 4
   local tt = nil
   local border = banner:border(0)
   local availT = {
      "\n    This module can be loaded directly: module load " .. full .. "\n",
      "\n    This module can only be loaded through the following modules:\n",
      "\n    This module can be loaded directly: module load " .. full .. "\n" ..
      "\n    Additional variants of this module can also be loaded after the loading the following modules:\n",
   }
   local haveCore = 0
   local haveHier = 0
   local mnameL   = searchName:lower()

   full = full or ""
   local fullL = full:lower()
   for k,v in pairs(T) do
      dbg.print{"vv.full: ",v.full," searchName: ",searchName," k: ",k," full:", full,"\n"}
      local vfullL = v.full_lower or v.full:lower()
      if (vfullL == mnameL or vfullL == fullL) then
         if (tt == nil) then
            tt = v
            ia = ia + 1; a[ia] = "\n"
            ia = ia + 1; a[ia] = border
            ia = ia + 1; a[ia] = "  " .. tt.name .. ": "
            ia = ia + 1; a[ia] = tt.full
            ia = ia + 1; a[ia] = "\n"
            ia = ia + 1; a[ia] = border
            if (tt.Description) then
               ia = ia + 1; a[ia] = "    Description:\n"
               ia = ia + 1; a[ia] = fillWords("      ",tt.Description, term_width)
               ia = ia + 1; a[ia] = "\n"
            end
            if (tt.propT ) then
               ia = ia + 1; a[ia] = "    Properties:\n"
               for kk, vv in pairs(propDisplayT) do
                  if (tt.propT[kk]) then
                     for kkk in pairs(tt.propT[kk]) do
                        if (vv.displayT[kkk]) then
                           ia = ia + 1; a[ia] = fillWords("      ",vv.displayT[kkk].doc, term_width)
                        end
                     end
                  end
               end
               ia = ia + 1; a[ia] = "\n"
            end

            if (#possibleA > 0) then
               local b   = {}
               local sum = 17
               local num = #possibleA
               for ja = 1, num do
                  b[#b+1] = possibleA[ja]
                  sum     = sum + possibleA[ja]:len() + 2
                  if (sum > term_width - 7 and ja < num - 1) then
                     b[#b+1] = "..."
                     break
                  end
               end
               ia = ia + 1; a[ia] = "\n     Other possible modules matches:\n        "
               ia = ia + 1; a[ia] = concatTbl(b,", ")
               ia = ia + 1; a[ia] = "\n"
            end

            ia = ia + 1; a[ia] = "Avail Title goes here.  This should never be seen\n"
            titleIdx = ia
         end
         if (#v.parent == 1 and v.parent[1] == "default") then
            haveCore = 1
         else
            b[#b+1] = "      "
            haveHier = 2
         end

         for i = 1, #v.parent do
            local entry = v.parent[i]
            for s in entry:split(":") do
               if (s ~= "default") then
                  b[#b+1] = s
                  b[#b+1] = ', '
               end
            end
            b[#b] = "\n      "
         end
         if (#b > 0) then
            b[#b] = "\n" -- Remove final comma add newline instead
            c[#c+1] = concatTbl(b,"")
            b = {}
         end
      end
   end
   a[titleIdx] = availT[haveCore+haveHier]
   if (#c > 0) then

      -- remove any duplicates
      local s = concatTbl(c,"")
      local d = {}
      for k in s:split("\n") do
         d[k] = 1
      end
      c = {}
      for k in pairs(d) do
         c[#c+1] = k
      end
      table.sort(c)
      c[#c+1] = " "
      ia = ia + 1; a[ia] = concatTbl(c,"\n")
   end

   if (tt and tt.help ~= nil) then
      ia = ia + 1; a[ia] = "\n    Help:\n"
      for s in tt.help:split("\n") do
         ia = ia + 1; a[ia] = "      "
         ia = ia + 1; a[ia] = s
         ia = ia + 1; a[ia] = "\n"
      end
   end

   ia = ia + 1; a[ia] = "\n"
   local name = self:getExactMatch()
   if (name) then
      ia = ia + 1; a[ia] = border
      ia = ia + 1; a[ia] = "  To find other possible module matches do:\n"
      ia = ia + 1; a[ia] = "      module -r spider '.*"
      ia = ia + 1; a[ia] = name
      ia = ia + 1; a[ia] = ".*'\n\n"
   end

   if (tt == nil) then
      LmodSystemError("Unable to find: \"",searchName,"\"")
   end

   dbg.fini("Spider:_Level2")
   return concatTbl(a,"")
end

function M.listModules(self, moduleT, tbl)
   if (moduleT.version == nil) then
      self:listModulesHelper(moduleT, tbl)
   else
      for mpath, v in pairs(moduleT) do
         if (type(v) == "table") then
            self:listModulesHelper(v, tbl)
         end
      end
   end
end

function M.listModulesHelper(self, moduleT, tbl)
   for kk,vv in pairs(moduleT) do
      tbl[vv.path] = 1
      if (next(vv.children)) then
         for k, v in pairs(vv.children) do
            if (type(v) == "table") then
               self:listModulesHelper(v, tbl)
            end
         end
      end
   end
end

function M.dictModules(self, T,tbl)
   for kk,vv in pairs(T) do
      kk      = kk:gsub("%.lua$","")
      tbl[kk] = 0
      if (next(vv.children)) then
         for k, v in pairs(vv.children) do
            if (type(v) == "table") then
               self:dictModules(v, tbl)
            end
         end
      end
   end
end

return M
