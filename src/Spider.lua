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
require("string_split")
require("string_trim")
require("fileOps")
require("fillWords")
require("capture")
require("pairsByKeys")
require("pager")

local M = {}

local CTimer       = require("CTimer")
local dbg          = require("Dbg"):dbg()
local timer        = require("Timer"):timer()
local concatTbl    = table.concat
local lfs          = require("lfs")
local posix        = require("posix")
local systemG      = _G
local gettimeofday = posix.gettimeofday

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

function Spider_append_path(kind, name, value)
   if (name == "MODULEPATH") then
      dbg.start{kind,"(MODULEPATH=\"",name,"\", value=\"",value,"\")"}
      processNewModulePATH(value)
      dbg.fini(kind)
   elseif (name == "PATH") then
      processPATH(value)
   elseif (name == "LD_LIBRARY_PATH") then
      processLPATH(value)
   end
end

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
      iStack        = iStack+1
      moduleStack[iStack] = {path = path, full = full,
                             moduleT = moduleT[path].children, fn= v}
      dbg.print{"Top of Stack: ",iStack, " Full: ", full, " file: ", path, "\n"}
      moduleT[path].children[v] = {}
      moduleT[path].children.version = Cversion
      M.findModulesInDir(0,v, v, "", moduleT[path].children[v])
      moduleStack[iStack] = nil
   end

   dbg.fini("processNewModulePATH")
end

------------------------------------------------------------
--module("Spider")
------------------------------------------------------------

local function versionFile(path)
   dbg.start{"versionFile(",path,")"}
   local f       = io.open(path,"r")
   if (not f)                        then
      dbg.print{"could not find: ",path,"\n"}
      dbg.fini("versionFile")
      return nil
   end
   local s       = f:read("*line")
   f:close()
   if (not s:find("^#%%Module"))      then
      dbg.print{"could not find: #%Module\n"}
      dbg.fini("versionFile")
      return nil
   end
   local cmd = pathJoin(cmdDir(),"ModulesVersion.tcl") .. " " .. path
   dbg.fini("versionFile")
   return capture(cmd):trim()
end

local function findMarkedDefault(mpath, path)
   local mt       = MT:mt()
   local localDir = true
   dbg.start{"Spider:findMarkedDefault(",mpath,", ", path,")"}

   --if (prefix == "") then
   --   dbg.fini("Spider:findMarkedDefault")
   --   return nil
   --end

   local default = abspath(path .. "/default", localDir)
   if (default == nil) then
      local vFn = abspath(pathJoin(path,".version"), localDir)
      if (isFile(vFn)) then
         local vf = versionFile(vFn)
         if (vf) then
            local f = pathJoin(path,vf)
            default = abspath(f,localDir)
            if (default == nil) then
               local fn = vf .. ".lua"
               local f  = pathJoin(path,fn)
               default  = abspath(f,localDir)
               dbg.print{"(2) f: ",f," default: ", default, "\n"}
            end
         end
      end
   end
   if (default) then
      default = abspath(default, localDir)
   end
   dbg.print{"(4) default: \"",default,"\"\n"}

   dbg.fini("Spider:findMarkedDefault")
   return default
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

   t.path          = f
   t.name          = sn
   t.name_lower    = sn:lower()
   t.full          = full
   t.full_lower    = full:lower()
   t.epoch         = posix.stat(f, "mtime")
   t.markedDefault = (f == markedDefault)
   t.children      = {}

   return t
end


function M.findModulesInDir(level, mpath, path, prefix, moduleT)
   local t1
   dbg.start{"findModulesInDir(level= ",level,", mpath=\"",mpath,"\", path=\"",path,
             "\", prefix=\"",prefix,"\")"}

   --if (level == 0) then
   --   t1   = epoch()
   --   dbg.print{"t1: ",t1,"\n"}
   --end
   local attr = lfs.attributes(path)
   if (not attr or  type(attr) ~= "table" or attr.mode ~= "directory" or
       not posix.access(path,"rx")) then
      dbg.print{"Directory: ",path," is non-existant or is not readable\n"}
      dbg.fini("findModulesInDir")
      return
   end

   local shellN          = "bash"
   local masterTbl       = masterTbl()
   local moduleStack     = masterTbl.moduleStack
   local iStack          = #moduleStack
   local mt              = MT:mt()
   local mnameT          = {}
   local dirA            = {}
   local ignoreT         = ignoreFileT()
   local cTimer          = CTimer:cTimer()

   for file in lfs.dir(path) do
      if (not ignoreT[file] and file:sub(-1,-1) ~= "~" and
          file:sub(1,8) ~= ".version" ) then
         local f        = pathJoin(path,file)
         local readable = posix.access(f,"r")
         local full     = pathJoin(prefix, file):gsub("%.lua","")
         attr           = lfs.attributes(f)

         ------------------------------------------------------------
         -- Since cache files are build by root but read by users
         -- make sure that any user can read a file owned by root.

         if (readable) then
            local st    = posix.stat(f)
            if (st.uid == 0 and not st.mode:find("......r..")) then
               readable = false
            end
         end

         if (not attr or not readable) then
            -- do nothing for this case
         elseif (readable and attr.mode == 'file' and file ~= "default") then
            dbg.print{"mnameT[",full,"].file: ",f,"\n"}
            mnameT[full] = {file=f, mpath = mpath}
         elseif (attr.mode == "directory" and file:sub(1,1) ~= ".") then
            dbg.print{"dirA: f:", f,"\n"}
            dirA[#dirA + 1] = { fn = f, mname = full }
         end
      end
   end

   cTimer:test()

   if (#dirA > 0 or prefix == '') then
      for k,v in pairs(mnameT) do
         local full = k
         local sn   = k
         moduleT[v.file] = registerModuleT(full, sn, v.file, nil)
         moduleStack[iStack] = {path= v.file, sn = sn, full = full, moduleT = moduleT, fn = v.file}
         dbg.print{"Top of Stack: ",iStack, " Full: ", full, " file: ", v.file, "\n"}

         local t = {fn = v.file, modFullName = k, modName = sn, default = true, hash = 0}
         mt:add(t,"pending")
         loadModuleFile{file=v.file, shell=shellN, reportErr=true}
         mt:setStatus(t.modName,"active")
         dbg.print{"Saving: Full: ", k, " Name: ", k, " file: ",v.file,"\n"}
      end
      for i = 1, #dirA do
         M.findModulesInDir(level+1,mpath, dirA[i].fn, dirA[i].mname .. '/', moduleT)
      end
   else
      local markedDefault   = findMarkedDefault(mpath, path)
      for full,v in pairs(mnameT) do
         local sn   = shortName(full)
         moduleT[v.file] = registerModuleT(full, sn, v.file, markedDefault)
         moduleStack[iStack] = {path=v.file, sn = sn, full = full, moduleT = moduleT, fn = v.file}
         dbg.print{"Top of Stack: ",iStack, " Full: ", full, " file: ", v.file, "\n"}
         local t = {fn = v.file, modFullName = full, modName = sn, default = 0, hash = 0}
         mt:add(t,"pending")
         loadModuleFile{file=v.file, shell=shellN, reportErr=true}
         mt:setStatus(t.modName,"active")
         dbg.print{"Saving: Full: ", full, " Name: ", sn, " file: ",v.file,"\n"}
      end
   end
   dbg.fini("findModulesInDir")
end

function M.findAllModules(moduleDirA, moduleT)
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
         M.findModulesInDir(0, v, v, "", moduleT[v])
      end
   end
   os.exit     = exit

   ------------------------------------------------------------
   -- clear temporary MT
   mt.popMT()
   dbg.fini("Spider:findAllModules")
end

function M.buildSpiderDB(a, moduleT, dbT)
   dbg.start{"Spider.buildSpiderDB({",concatTbl(a,","),"},moduleT, dbT)"}

   dbg.print{"moduleT.version: ",moduleT.version,"\n"}

   local version = moduleT.version or 0

   if ( version < Cversion) then
      LmodError("old version moduleT\n")
   else
      dbg.print{"Current version moduleT.\n"}
      for mpath, v in pairs(moduleT) do
         if (type(v) == "table") then
            dbg.print{"mpath: ",mpath, "\n"}
            M.singleSpiderDB(a,v, dbT)
         end
      end
   end
   dbg.fini("Spider.buildSpiderDB")
end

function M.singleSpiderDB(a, moduleT, dbT)
   dbg.start{"Spider.singleSpiderDB({",concatTbl(a,","),"},moduleT, dbT)"}
   for path, value in pairs(moduleT) do
      dbg.print{"path: ",path,"\n"}
      local nameL = value.name_lower or value.name:lower()
      dbT[nameL]  = dbT[nameL] or {}
      local t     = dbT[nameL]

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
      t[path].parent = parent
      if (next(value.children)) then
         a[#a+1] = t[path].full
         M.buildSpiderDB(a, value.children, dbT)
         a[#a]   = nil
      end
   end
   dbg.fini("Spider.singleSpiderDB")
end

function M.searchSpiderDB(strA, a, moduleT, dbT)
   dbg.start{"Spider:searchSpiderDB({",concatTbl(a,","),"},moduleT, dbT)"}

   local version = moduleT.version or 0

   if (version < Cversion) then
      LmodError("old version moduleT.\n")
   else
      dbg.print{"Current version moduleT\n"}
      for mpath, v in pairsByKeys(moduleT) do
         if (type(v) == "table") then
            dbg.print{"mpath: ",mpath, "\n"}
            M.singleSearchSpiderDB(strA, a, v, dbT)
         end
      end
   end
   dbg.fini("Spider:searchSpiderDB")
end

function M.singleSearchSpiderDB(strA, a, moduleT, dbT)
   dbg.start{"Spider.singleSearchSpiderDB()"}

   for path, value in pairsByKeys(moduleT) do
      local nameL   = value.name_lower or ""
      local full    = value.full
      local fullL   = value.full_lower or full:lower()
      local whatisT = value.whatis or {}
      local whatisS = concatTbl(whatisT,"\n")

      if (dbT[nameL] == nil) then
         dbT[nameL] = {}
      end
      local t = dbT[nameL]

      local found = false
      for i = 1,#strA do
         local str = strA[i]:lower()
         if (nameL:find(str,1,true)   or nameL:find(str)    or
             whatisS:find(str,1,true) or whatisS:find(str)) then
            dbg.print{"found txt in nameL: ",nameL,"\n"}
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
         M.searchSpiderDB(strA, a, value.children, dbT)
         a[#a]   = nil
      end
   end
   dbg.fini("Spider.singleSearchSpiderDB")
end

function M.Level0(dbT)
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
                  t[v.full] = v.full
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
   local banner = border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "The following is a list of the modules currently available:\n"
   ia = ia+1; a[ia] = banner

   M.Level0Helper(dbT,a)

   return concatTbl(a,"")
end

function M.Level0Helper(dbT,a)
   local t          = {}
   local term_width = TermWidth() - 4

   for kk,vv in pairs(dbT) do
      for k,v in pairsByKeys(vv) do
         local version = extractVersion(v.full, v.name)
         if ((version or ""):sub(1,1) ~= ".") then
            if (t[kk] == nil) then
               t[kk] = { Description = v.Description, Versions = { }, name = v.name}
               t[kk].Versions[v.full] = 1
            else
               t[kk].Versions[v.full] = 1
            end
         end
      end
   end

   local ia = #a

   for k,v in pairsByKeys(t) do
      local len = 0
      ia = ia + 1; a[ia] = "  " .. v.name .. ":"
      len = len + a[ia]:len()
      for kk,_ in pairsByKeys(v.Versions) do
         ia = ia + 1; a[ia] = " " .. kk; len = len + a[ia]:len() + 1
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
   local banner = border(0)
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "To learn more about a package enter:\n\n"
   ia = ia+1; a[ia] = "   $ module spider Foo\n\n"
   ia = ia+1; a[ia] = "where \"Foo\" is the name of a module\n\n"
   ia = ia+1; a[ia] = "To find detailed information about a particular package you\n"
   ia = ia+1; a[ia] = "must enter the version if there is more than one version:\n\n"
   ia = ia+1; a[ia] = "   $ module spider Foo/11.1\n"
   ia = ia+1; a[ia] = banner

end


local function countEntries(t, searchName)
   local count   = 0
   local nameCnt = 0
   local fullCnt = 0
   local full    = false
   local searchL = (searchName or ""):lower()
   for k,v in pairs(t) do
      local version = extractVersion(v.full, v.name) or ""
      if (version:sub(1,1) ~= ".") then
         count = count + 1
         if (not full) then
            full = v.full
         end
         if (v.name_lower:find(searchL,1, true) or v.name_lower:find(searchL)) then
            nameCnt = nameCnt + 1
            full  = v.full
         end
         if (v.full_lower == searchL) then
            fullCnt = fullCnt + 1
            full  = v.full
         end
      end
   end
   return count, nameCnt, fullCnt, full
end

function M.spiderSearch(dbT, searchName, help)
   dbg.start{"Spider:spiderSearch(dbT,\"",searchName,"\")"}
   local found = false
   local A  = {}
   A[1]     = searchName:lower()
   local sn = shortName(searchName):lower()
   if (sn ~= A[1]) then
      A[2]  = sn
   end

   local a     = {}
   for i = 1, #A do
      local searchL = A[i]
      local T = dbT[searchL]
      if (T) then
         dbg.print{"Found exact match: searchL: ",searchL,"\n"}
         local s = M._Level1(searchL, T, searchName, help)
         if (s) then
            a[#a+1] = s
         end
         found = true
      end
   end

   if (not found) then
      for k, v in pairsByKeys(dbT) do
         for i = 1, #A do
            local searchL = A[i]
            if (k:find(searchL,1,true) or k:find(searchL)) then
               found = true
               dbg.print{"Found inexact match: searchL: ",searchL,", k: ",k,"\n"}
               local s = M._Level1(k, v, searchName, help)
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
   end
   dbg.fini("Spider:spiderSearch")
   return concatTbl(a,"")
end

function M._Level1(key, T, searchName, help)
   dbg.start{"Spider:_Level1(",key,", T,\"",searchName,"\",help)"}
   local term_width = TermWidth() - 4

   if (T == nil) then
      dbg.print{"No entry called: \"",searchName, "\" in dbT\n"}
      dbg.fini("Spider:_Level1")
      return ""
   end

   local cnt, nameCnt, fullCnt, full = countEntries(T, searchName)
   dbg.print{"Number of entries: ",cnt ," name count: ",nameCnt,
             " full count: ",fullCnt, " full: ", full, "\n"}
   dbg.print{"key: \"",key,"\" searchName: \"",searchName,"\"\n"}

   --if ((key:len() < searchName:len() and fullCnt == 0 ) or
   --    (cnt == 0 and fullCnt == 0)) then
   if (nameCnt == 0 and fullCnt == 0) then
      LmodSystemError("Unable to find: \"",searchName,"\"")
      dbg.fini("Spider:_Level1")
      return ""
   end

   if (cnt == 1 or nameCnt == 1 or fullCnt > 0) then
      local s = M._Level2(T, searchName, full)
      dbg.fini("Spider:_Level1")
      return s
   end



   local banner = border(2)
   local VersionT = {}
   local exampleV = nil
   local key = nil
   local Description = nil
   for k, v in pairsByKeys(T) do
      local version = extractVersion(v.full, v.name) or ""
      if (version:sub(1,1) ~= ".") then
         if (VersionT[k] == nil) then
            key              = v.name
            Description      = v.Description
            VersionT[v.full] = 1
            exampleV         = v.full
         else
            VersionT[v.full] = 1
         end
      end
   end

   local a  = {}
   local ia = 0

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = banner
   ia = ia + 1; a[ia] = "  " .. key .. ":\n"
   ia = ia + 1; a[ia] = banner
   if (Description) then
      ia = ia + 1; a[ia] = "    Description:\n"
      ia = ia + 1; a[ia] = fillWords("      ",Description,term_width)
      ia = ia + 1; a[ia] = "\n\n"

   end
   ia = ia + 1; a[ia] = "     Versions:\n"
   for k, v in pairsByKeys(VersionT) do
      ia = ia + 1; a[ia] = "        " .. k .. "\n"
   end

   if (help) then
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = banner
      ia = ia + 1; a[ia] = "  To find detailed information about "
      ia = ia + 1; a[ia] = key
      ia = ia + 1; a[ia] = " please enter the full name.\n  For example:\n\n"
      ia = ia + 1; a[ia] = "     $ module spider "
      ia = ia + 1; a[ia] = exampleV
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = banner
   end

   dbg.fini("Spider:_Level1")
   return concatTbl(a,"")

end

function M._Level2(T, searchName, full)
   dbg.start{"Spider:_Level2(T,\"",searchName,"\", \"",full,"\")"}
   local a  = {}
   local ia = 0
   local b  = {}
   local c  = {}
   local titleIdx = 0

   local propDisplayT = getPropT()

   local term_width = TermWidth() - 4
   local tt = nil
   local banner = border(2)
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
            ia = ia + 1; a[ia] = banner
            ia = ia + 1; a[ia] = "  " .. tt.name .. ": "
            ia = ia + 1; a[ia] = tt.full
            ia = ia + 1; a[ia] = "\n"
            ia = ia + 1; a[ia] = banner
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

   if (tt == nil) then
      LmodSystemError("Unable to find: \"",searchName,"\"")
   end

   dbg.fini("Spider:_Level2")
   return concatTbl(a,"")
end

function M.listModules(moduleT, tbl)
   if (moduleT.version == nil) then
      M.listModulesHelper(moduleT, tbl)
   else
      for mpath, v in pairs(moduleT) do
         if (type(v) == "table") then
            M.listModulesHelper(v, tbl)
         end
      end
   end
end

function M.listModulesHelper(moduleT, tbl)
   for kk,vv in pairs(moduleT) do
      tbl[vv.path] = 1
      if (next(vv.children)) then
         for k, v in pairs(vv.children) do
            if (type(v) == "table") then
               M.listModulesHelper(v, tbl)
            end
         end
      end
   end
end

function M.dictModules(T,tbl)
   for kk,vv in pairs(T) do
      kk      = kk:gsub(".lua$","")
      tbl[kk] = 0
      if (next(vv.children)) then
         for k, v in pairs(vv.children) do
            if (type(v) == "table") then
               M.dictModules(v, tbl)
            end
         end
      end
   end
end

return M
