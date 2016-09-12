--------------------------------------------------------------------------
-- Spider the class that handles walking the directory tree.  It builds a
-- table called *moduleT* first.  This needs more description.
-- @classmod Spider

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
require("string_utils")
require("fileOps")
require("capture")
require("pairsByKeys")
require("pager")
require("utils")

local M = {}
_G._DEBUG          = false               -- Required by the new lua posix
local CTimer       = require("CTimer")
local ReadLmodRC   = require("ReadLmodRC")
local concatTbl    = table.concat
local dbg          = require("Dbg"):dbg()
local lfs          = require("lfs")
local max          = math.max
local posix        = require("posix")
local systemG      = _G
local getenv       = os.getenv
local sort         = table.sort
local timer        = require("Timer"):timer()
local function nothing()
end

KeyT = {Description=1, Name=1, URL=1, Version=1, Category=1, Keyword=1}

local function process(kind, value)
   if (value == nil) then return end
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   local mpath       = moduleStack[iStack].path
   local moduleT     = moduleStack[iStack].moduleT

   local a           = moduleT[mpath][kind] or {}
   for path in value:split(":") do
      path         = path_regularize(path)
      a[path]      = 1
   end
   moduleT[mpath][kind] = a
end

function processLPATH(value)
   process("lpathA",value)
end

function processPATH(value)
   process("pathA",value)
end

function processDIR(value)
   process("dirA",value)
end

function Spider_append_path(kind, t)
   local name  = t[1]
   local value = t[2]
   if (name == "MODULEPATH") then
      dbg.start{kind, "(\"",name, "\" = \"", value, "\")"}
      processNewModulePATH(value)
      dbg.fini(kind)
   elseif (name == "PATH") then
      dbg.start{kind, "(\"",name, "\" = \"", value, "\")"}
      processPATH(value)
      dbg.fini(kind)
   elseif (name == "LD_LIBRARY_PATH" or name == "CRAY_LD_LIBRARY_PATH" ) then
      dbg.start{kind, "(\"",name, "\" = \"", value, "\")"}
      processLPATH(value)
      dbg.fini(kind)
   elseif (name == "PKG_CONFIG_PATH")  then
      local i = value:find("/lib/pkgconfig$")
      if (i) then
         dbg.start{kind, "(\"",name, "\" = \"", value, "\")"}
         processLPATH(value:sub(1,i+3))
         dbg.fini(kind)
      end
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
   o.__name  = false
   return o
end

function M.setExactMatch(self, name)
   self.__name  = name
end

function M.getExactMatch(self)
   return self.__name
end

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
   local fabs = false
   if (isFile(f)) then
      fabs = f
   elseif (isFile(f..".lua")) then
      fabs = f
   end

   t.path          = f
   t.name          = sn
   t.name_lower    = sn:lower()
   t.full          = full
   t.full_lower    = full:lower()
   t.epoch         = posix.stat(f, "mtime")
   t.markedDefault = (fabs == markedDefault)
   dbg.print{"registerModuleT: f: ",f,", fabs: ",fabs,", dfltFn: ",markedDefault,
             ", marked: ",t.markedDefault,"\n"}
   t.children      = {}

   return t
end

function M.findModulesInDir(mpath, path, prefix, moduleT)
   local t1
   dbg.start{"Spider:findModulesInDir(mpath=\"",mpath,"\", path=\"",path,
             "\", prefix=\"",prefix,"\")"}

   local attr  = lfs.attributes(path)
   if (not attr or  type(attr) ~= "table" or attr.mode ~= "directory" or
       not posix.access(path,"rx")) then
      dbg.print{"Directory: ",path," does not exist or is not readable\n"}
      dbg.fini("Spider:findModulesInDir")
      return
   end

   local Pairs       = dbg.active() and pairsByKeys or pairs
   local shellN      = "bash"
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   local mt          = MT:mt()
   local cTimer      = CTimer:cTimer()
   local accept_fn   = accept_fn
   local defaultIdx  = 1000000  -- default idx must be bigger than index for .version

   local mnameT      = {}
   local dirA        = {}
   local defaultFn   = walk_directory_for_mf(mpath, path, prefix, dirA, mnameT)

   --------------------------------------------------------------------------
   -- Build the list of modules loaded before spider was run:
   local mList = ""
   if (Use_Preload) then
      local a = {}
      mList   = getenv("LOADEDMODULES") or ""
      for mod in mList:split(":") do
         local i = mod:find("/[^/]*$")
         if (i) then
            a[#a+1] = mod:sub(1,i-1)
         end
         a[#a+1] = mod
      end
      mList = concatTbl(a,":")
   end


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
         loadModuleFile{file=v.fn, shell=shellN, help=true, reportErr=true, mList = mList}
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
            defaultFn = walk_link(defaultFn)
         else
            local sn  = prefix:gsub("/+$","")
            v         = versionFile(v, sn, defaultFn, true)
            local f   = pathJoin(d,v)
            if (isFile(f)) then
               defaultFn = f
            elseif (isFile(f .. ".lua")) then
               defaultFn = f .. ".lua"
            end
            dbg.print{"defaultFn: ",defaultFn,", f: ",f,", v: ",v,", sn: ",sn,"\n"}
         end
      end
      dbg.print{"defaultFn: ",defaultFn,"\n"}
      for full,v in Pairs(mnameT) do
         local sn   = v.sn
         moduleT[v.fn] = registerModuleT(full, sn, v.fn, defaultFn)
         moduleStack[iStack] = {path=v.fn, sn = sn, full = full, moduleT = moduleT,
                                fn = v.fn}
         dbg.print{"Top of Stack: ",iStack, " Full: ", full, " fn: ", v.fn, "\n"}
         local t = {fn = v.fn, modFullName = full, modName = sn, default = 0, hash = 0}
         mt:add(t,"pending")
         loadModuleFile{file=v.fn, shell=shellN, help=true, reportErr=true, mList = mList}
         mt:setStatus(t.modName,"active")
         dbg.print{"Saving: Full: ", full, " Name: ", sn, " fn: ",v.fn,"\n"}
      end
   end
   dbg.fini("Spider:findModulesInDir")
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
      local whatisS = concatTbl(whatisT,"\n"):lower()

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
   local a           = {}
   local masterTbl   = masterTbl()
   local show_hidden = masterTbl.show_hidden
   local terse       = masterTbl.terse


   if (terse) then
      dbg.start{"Spider:Level0()"}
      local t  = {}
      for kk, vv in pairs(dbT) do
         for k, v in pairs(vv) do
            local isActive, version = isActiveMFile(v.full, v.name)
            if (show_hidden or isActive) then
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
   local t           = {}
   local show_hidden = masterTbl().show_hidden
   local term_width  = TermWidth() - 4

   for kk,vv in pairs(dbT) do
      for k,v in pairsByKeys(vv) do
         local isActive, version = isActiveMFile(v.full, v.name)
         --dbg.print{"show_hidden: ", show_hidden,", isActive: ", isActive,", version: ",version,", full: ",v.full,", sn: ",v.name,"\n"}
         if (show_hidden or isActive) then
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
         ia = ia + 1; a[ia] = v.Description:fillWords("    ", term_width)
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


local function countEntries(t, sn, searchPat, searchName, show_hidden)
   dbg.start{"countEntries(t,\"",sn,"\", \"", searchPat,"\", \"",searchName,"\", ",show_hidden,")"}

   local count   = 0
   local nameCnt = 0
   local fullCnt = 0
   local full    = false
   local search  = (searchPat or "")
   local searchV = extractVersion(searchName:lower(), sn:lower())
   for k,v in pairs(t) do
      local isActive, version = isActiveMFile(v.full, v.name)
      dbg.print{"\nversion: ",version, ", searchV: ",searchV,"\n"}



      if (show_hidden or isActive) then
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
         local i, j = v.full:find(searchName,1,true)
         if (not i) then
            i, j = v.full:find(searchName)
         end
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
         A[i].pattern = A[i].pattern:caseIndependent()
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
            found   = true
            a[#a+1] = s
         end
      end
   end



   if (not found) then
      for k, v in pairsByKeys(dbT) do
         for i = 1, #A do
            local search = A[i].pattern
            if (k:find(search)) then
               dbg.print{"Found inexact match: search: ",search,", k: ",k,"\n"}
               local s = self:_Level1(A[i].pattern, k, v, searchName, {}, help)
               if (s) then
                  a[#a+1] = s
                  found = true
               end
            end
         end
      end
   end

   if (not found) then
      setWarningFlag()
      LmodSystemError("Unable to find: \"",searchName,"\"\n")
   end
   dbg.fini("Spider:spiderSearch")
   return concatTbl(a,"")
end

function M._Level1(self, searchPat, key, T, searchName, possibleA, help)
   dbg.start{"Spider:_Level1(",searchPat,", ", key,", T,\"",searchName,"\",help=",help,")"}
   local term_width  = TermWidth() - 4
   local masterTbl   = masterTbl()
   local show_hidden = masterTbl.show_hidden
   if (T == nil) then
      dbg.print{"No entry called: \"",searchName, "\" in dbT\n"}
      dbg.fini("Spider:_Level1")
      return false
   end

   local cnt, nameCnt, fullCnt, full = countEntries(T, key, searchPat, searchName, show_hidden)
   dbg.print{"Number of entries: ",cnt ," name count: ",nameCnt,
             " full count: ",fullCnt, " full: ", full, "\n"}
   dbg.print{"key: \"",key,"\" searchName: \"",searchName,"\"\n"}

   --if ((key:len() < searchName:len() and fullCnt == 0 ) or
   --    (cnt == 0 and fullCnt == 0)) then
   if ((nameCnt == 0 and fullCnt == 0) or (not full)) then
      dbg.print{"did not to find: \"",searchName,"\"\n"}
      dbg.fini("Spider:_Level1")
      return false
   end

   if (cnt == 1 or nameCnt == 1 or fullCnt > 0) then
      local s = self:_Level2(T, searchName, full, possibleA)
      dbg.fini("Spider:_Level1")
      return s
   end

   key               = nil
   local border      = banner:border(0)
   local VersionT    = {}
   local exampleV    = nil
   local Description = nil
   for k, v in pairsByKeys(T) do
      local isActive, version = isActiveMFile(v.full, v.name)
      if (show_hidden or isActive) then
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

   if (masterTbl.terse) then
      for k, v in pairsByKeys(VersionT) do
         ia = ia + 1; a[ia] = v .. "\n"
      end
      return concatTbl(a,"")
   end

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   ia = ia + 1; a[ia] = "  " .. key .. ":\n"
   ia = ia + 1; a[ia] = border
   if (Description) then
      ia = ia + 1; a[ia] = "    Description:\n"
      ia = ia + 1; a[ia] = Description:fillWords("      ",term_width)
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
      ia = ia + 1; a[ia] = concatTbl(b,"  ")
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
      ia = ia + 1; a[ia] = "  For detailed information about a specific \""
      ia = ia + 1; a[ia] = key
      ia = ia + 1; a[ia] = "\" module (including how to load the modules) use the module's full name.\n"
      ia = ia + 1; a[ia] = "  For example:\n\n"
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
   local show_hidden = masterTbl().show_hidden
   local a  = {}
   local ia = 0
   local b  = {}
   local c  = {}
   local titleIdx = 0

   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()

   local term_width = TermWidth() - 4
   local tt = nil
   local border = banner:border(0)
   local availT = {
      "\n    This module can be loaded directly: module load " .. full .. "\n",
      "\n    You will need to load all module(s) on any one of the lines below before the \"" .. full .. "\" module is available to load.\n",
      "\n    This module can be loaded directly: module load " .. full .. "\n" ..
      "\n    Additional variants of this module can also be loaded after loading the following modules:\n",
   }
   local haveCore = 0
   local haveHier = 0
   local mnameL   = searchName:lower()

   full = full or ""
   local fullL = full:lower()
   for k,v in pairs(T) do
      dbg.print{"v.full: ",v.full," searchName: ",searchName," k: ",k," full:", full,",v.name:",v.name,"\n"}
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
               ia = ia + 1; a[ia] = tt.Description:fillWords("      ", term_width)
               ia = ia + 1; a[ia] = "\n"
            end
            if (tt.propT ) then
               ia = ia + 1; a[ia] = "    Properties:\n"
               for kk, vv in pairs(propDisplayT) do
                  if (tt.propT[kk]) then
                     for kkk in pairs(tt.propT[kk]) do
                        if (vv.displayT[kkk]) then
                           ia = ia + 1; a[ia] = vv.displayT[kkk].doc:fillWords("      ", term_width)
                        end
                     end
                  end
               end
               ia = ia + 1; a[ia] = "\n"
            end

            if (#possibleA > 0) then
               local bb   = {}
               local sum = 17
               local num = #possibleA
               for ja = 1, num do
                  bb[#bb+1] = possibleA[ja]
                  sum     = sum + possibleA[ja]:len() + 2
                  if (sum > term_width - 7 and ja < num - 1) then
                     bb[#bb+1] = "..."
                     break
                  end
               end
               ia = ia + 1; a[ia] = "\n     Other possible modules matches:\n        "
               ia = ia + 1; a[ia] = concatTbl(bb,", ")
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
                  b[#b+1] = '  '
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
      if (show_hidden) then
         for k in s:split("\n") do
            d[k] = 1
         end
      else
         for k in s:split("\n") do
            if (not (k:find("^%.") or k:find("/%."))) then
               d[k] = 1
            end
         end
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
