_G._DEBUG          = false               -- Required by the new lua posix
local posix        = require("posix")

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
--  Copyright (C) 2008-2025 Robert McLay
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

require("myGlobals")
require("string_utils")
require("fileOps")
require("pairsByKeys")
require("utils")
require("serializeTbl")
require("deepcopy")
require("loadModuleFile")
require("sandbox")

local Banner       = require("Banner")
local M            = {}
local MRC          = require("MRC")
local ModuleA      = require("ModuleA")
local MT           = require("MT")
local MName        = require("MName")
local ReadLmodRC   = require("ReadLmodRC")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local getenv       = os.getenv
local hook         = require("Hook")
local i18n         = require("i18n")
local lfs          = require("lfs")
local Pairs        = dbg.active() and pairsByKeys or pairs
local access       = posix.access
local sort         = table.sort

KeyT = {Description=true, Name=true, URL=true, Version=true, Category=true, Keyword=true}

function M.new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   o.__name  = false
   return o
end

local function l_nothing()
end

local function l_process(kind, value)
   if (value == nil) then return end
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   local moduleT     = moduleStack[iStack].moduleT

   local a           = moduleT[kind] or {}
   for path in value:split(":") do
      path         = path_regularize(path)
      a[path]      = 1
   end
   moduleT[kind] = a
end

function processLPATH(value)
   l_process("lpathA",value)
end

function processPATH(value)
   l_process("pathA",value)
end

function processDIR(value)
   l_process("dirA",value)
end

local function l_processNewModulePATH(path)
   dbg.start{"l_processNewModulePATH(path)"}

   local optionTbl   = optionTbl()
   local dirStk      = optionTbl.dirStk
   local mpath_new   = path_regularize(path)
   dirStk[#dirStk+1] = mpath_new

   local mpathMapT   = optionTbl.mpathMapT
   local moduleStack = optionTbl.moduleStack
   local iStack      = #moduleStack
   local mpath_old   = moduleStack[iStack].mpath
   local moduleT     = moduleStack[iStack].moduleT
   local fullName    = moduleStack[iStack].fullName
   local t           = mpathMapT[mpath_new] or {}

   if (mpath_new ~= mpath_old) then
      t[fullName]          = mpath_old
      mpathMapT[mpath_new] = t
      moduleT.changeMPATH  = true
   end
   dbg.printT("mpathMapT",mpathMapT)
   dbg.fini("l_processNewModulePATH")
end

function Spider_dynamic_mpath()
   local optionTbl   = optionTbl()
   local moduleStack = optionTbl.moduleStack
   local iStack      = #moduleStack
   local moduleT     = moduleStack[iStack].moduleT
   moduleT.changeMPATH = true
end

function Spider_append_path(kind, t)
   local name  = t[1]
   local value = t[2]
   if (name == "MODULEPATH") then
      dbg.start{kind, "(\"",name, "\" = \"", value, "\")"}
      l_processNewModulePATH(value)
      dbg.fini(kind)
   elseif (name == "PATH") then
      dbg.start{kind, "(\"",name, "\" = \"", value, "\")"}
      if (value ~= ".") then
         processPATH(value)
      end
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

local shellNm = "bash"

local function l_loadMe(entryT, moduleStack, iStack, myModuleT, mt, mList, mpath, sn, msg)
   local shell         = _G.Shell
   local tracing       = cosmic:value("LMOD_TRACING")
   local fn            = entryT.fn
   local sn            = entryT.sn
   local fullName      = entryT.fullName
   local version       = entryT.version
   moduleStack[iStack] = { mpath = mpath, sn = sn, fullName = fullName, moduleT = myModuleT, fn = fn}
   local mname         = MName:new("entryT", entryT)
   mt:add(mname, "pending")

   if (tracing == "yes") then
      tracing_msg{msg, fullName, " (fn: ", fn or "nil", ")"}
   end

   loadModuleFile{file=fn, help=true, shell=shellNm, reportErr=false,
                  mList = mList, forbiddenT = {}}
   hook.apply("load_spider",{fn = fn, modFullName = fullName, sn = sn})
   mt:setStatus(sn, "active")
   reset_env()
end

local function l_findModules(mpath, mt, mList, sn, v, moduleT)
   local entryT
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   if (next(v.fileT) ~= nil) then
      for fullName, vv in Pairs(v.fileT) do
         vv.Version = extractVersion(fullName, sn)
         entryT   = { fn = vv.fn, sn = sn, userName = fullName, fullName = fullName,
                      version = vv.Version }
         l_loadMe(entryT, moduleStack, iStack, vv, mt, mList, mpath, sn, "Spider Loading:       ")
      end
   end
   if (next(v.dirT) ~= nil) then
      for name, vv in Pairs(v.dirT) do
         l_findModules(mpath, mt, mList, sn, vv)
      end
   end
end

local function l_findChangeMPATH_modules(mpath, mt, mList, sn, v, moduleT)
   local entryT
   local moduleStack = optionTbl().moduleStack
   local iStack      = #moduleStack
   if (next(v.fileT) ~= nil) then
      for fullName, vv in pairs(v.fileT) do
         if (vv.changeMPATH == true) then
            vv.Version = extractVersion(fullName, sn)
            entryT   = { fn = vv.fn, sn = sn, userName = fullName, fullName = fullName,
                         version = vv.Version }
            l_loadMe(entryT, moduleStack, iStack, vv, mt, mList, mpath, sn,"Spider Loading again: ")
         end
      end
   end
   if (next(v.dirT) ~= nil) then
      for name, vv in pairs(v.dirT) do
         l_findChangeMPATH_modules(mpath, mt, mList, sn, vv)
      end
   end
end

function M.searchSpiderDB(self, strA, dbT, providedByT)
   dbg.start{"Spider:searchSpiderDB({",concatTbl(strA,","),"},spider, dbT)"}
   local optionTbl = optionTbl()

   if (not optionTbl.regexp) then
      for i = 1, strA.n do
         strA[i] = strA[i]:caseIndependent()
      end
   end

   local kywdT     = {}

   for sn, vvv in pairs(dbT) do
      kywdT[sn] = {}
      local t   = kywdT[sn]
      for fn, vv in pairs(vvv) do
         local whatisS  = concatTbl(vv.whatis or {},"\n"):lower()
         local found    = false
         local help     = vv.help or ""
         for i = 1,strA.n do
            local str = strA[i]
            if (sn:find(str) or whatisS:find(str) or help:find(str)) then
               found = true
               break
            end
            if (vv.propT and next(vv.propT) ~= nil) then
               for propN,v in pairs(vv.propT) do
                  for k in pairs(v) do
                     if (k:find(str)) then
                        dbg.print{"k: ",k,"\n"}
                        found = true
                        break
                     end
                  end
               end
            end
         end
         if (found) then
            t[fn] = vv
         end
      end
      if (next(kywdT[sn]) == nil) then
         kywdT[sn] = nil
      end
   end

   local kywdExtsT = {}
   for sn, vv in pairs(providedByT) do
      for i = 1, strA.n do
         local str = strA[i]
         if (sn:find(str)) then
            kywdExtsT[sn] = vv
         end
      end
   end

   dbg.fini("Spider:searchSpiderDB")
   return kywdT, kywdExtsT
end

function M.findAllModules(self, mpathA, spiderT, mpathMapT)
   dbg.start{"Spider:findAllModules(",concatTbl(mpathA,", "),")"}
   spiderT.version = LMOD_CACHE_VERSION

   local tracing         = cosmic:value("LMOD_TRACING")
   local dynamicCache    = (cosmic:value("LMOD_DYNAMIC_SPIDER_CACHE") ~= "no")
   local mt              = deepcopy(MT:singleton())
   local maxdepthT       = mt:maxDepthT()
   local optionTbl       = optionTbl()
   local moduleDirT      = {}
   optionTbl.moduleStack = {{}}
   optionTbl.dirStk      = {}
   optionTbl.mpathMapT   = {}


   local mList           = ""
   local exit            = os.exit
   os.exit               = l_nothing

   --local mcp_old   = mcp
   dbg.print{"mcpStack: ",mcpStack,"\n"}
   mcpStack:push(mcp)
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   mcp = MainControl.build("spider")


   sandbox_set_os_exit(l_nothing)
   if (tracing == "no" and not dbg.active()) then
      dbg.print{"Turning off stdio\n"}
      turn_off_stdio()
   end
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

   local dirStk = optionTbl.dirStk
   for i = 1,#mpathA do
      local mpath = mpathA[i]
      if (isDir(mpath)) then
         dirStk[#dirStk+1] = path_regularize(mpath)
      end
   end

   local seenT = {}

   while(#dirStk > 0) do
      repeat

         -- Pop top of dirStk
         local mpath     = dirStk[#dirStk]
         dirStk[#dirStk] = nil

         -- skip mpath if directory does not exist
         -- or can not be read
         local attr  = lfs.attributes(mpath)
         if (not attr or attr.mode ~= "directory" or
             (not access(mpath,"rx")))               then break end

         -- skip mpath directory if already walked.
         if (seenT[mpath] or not isDir(mpath)) then break end

         if (spiderT[mpath] == nil ) then
            dbg.print{"Running l_findModules on: ", mpath,"\n"}
            if (tracing == "yes") then
               tracing_msg{"Full spider search on ",mpath}
            end

            local moduleA     = ModuleA:__new({mpath}, maxdepthT):moduleA()
            local T           = moduleA[1].T
            for sn, v in Pairs(T) do
               l_findModules(mpath, mt, mList, sn, v)
            end
            spiderT[mpath] = moduleA[1].T
         elseif (dynamicCache) then
            dbg.print{"Running l_findChangeMPATH_modules on: ", mpath,"\n"}
            if (tracing == "yes") then
               tracing_msg{"dynamic spider search on ",mpath}
            end
            for sn, v in pairs(spiderT[mpath]) do
               l_findChangeMPATH_modules(mpath, mt, mList, sn, v)
            end
         end
         seenT[mpath]   = true
      until true
   end

   dbg.print{"Resetting os.exit back\n"}
   os.exit               = exit
   sandbox_set_os_exit(exit)
   if (tracing == "no" and not dbg.active()) then
      turn_on_stdio()
      dbg.print{"stderr back on\n"}
   end

   local t = optionTbl.mpathMapT
   if (next(t) ~= nil) then
      for k,v in pairs(t) do
         mpathMapT[k] = v
      end
   end

   dbg.printT("mpathMapT",mpathMapT)
   --mcp = mcp_old
   mcp = mcpStack:pop()
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("Spider:findAllModules")
end

function extend(a,b)
   local tblInsert = table.insert
   for i = 1,#b do
      tblInsert(a, b[i])
   end
   return a
end

function reverse(a)
   local n = #a
   for i = 1, n/2 do
      a[i], a[n] = a[n], a[i]
      n = n - 1
   end
   return a
end

function copy(a)
   local b = {}
   for k,v in pairs(a) do
      b[k] = v
   end
   return b
end

------------------------------------------------------------
-- Convert the mpathMapT to parentT.
-- So if the mpathMapT looks like
--     mpathMapT = {
--        ["%ProjDir%/Compiler/gcc/5.9"]  = {
--           ["gcc/5.9.3"] = "%ProjDir%/Core",
--           ["gcc/5.9.2"] = "%ProjDir%/Core",
--        },
--        ["%ProjDir%/MPI/gcc/5.9/mpich/17.200"]  = {
--           ["mpich/17.200.1"] = "%ProjDir%/Compiler/gcc/5.9",
--           ["mpich/17.200.2"] = "%ProjDir%/Compiler/gcc/5.9",
--        },
--        ["%ProjDir%/MPI/gcc/5.9/mpich/17.200/petsc/3.4"]  = {
--           ["petsc/3.4-cxx"]   = "%ProjDir%/MPI/gcc/5.9/mpich/17.200",
--           ["petsc/3.4-cmplx"] = "%ProjDir%/MPI/gcc/5.9/mpich/17.200",
--        },
--     }
-- Then parentT looks like:
--     parentT = {
--        ['%ProjDir%/Compiler/gcc/5.9'] =
--           {
--              {"gcc/5.9.3"},
--              {"gcc/5.9.2"},
--           },
--
--        ['%ProjDir%/Compiler/gcc/5.9/mpich/17.200'] =
--           {
--              {"gcc/5.9.3", "mpich/17.200.1"},
--              {"gcc/5.9.3", "mpich/17.200.2"},
--              {"gcc/5.9.2", "mpich/17.200.1"},
--              {"gcc/5.9.2", "mpich/17.200.2"},
--           },
--        ["%ProjDir%/MPI/gcc/5.9/mpich/17.200/petsc/3.4"]  =
--           {
--              {"gcc/5.9.3", "mpich/17.200.1", "petsc/3.4-cxx"  },
--              {"gcc/5.9.3", "mpich/17.200.2", "petsc/3.4-cxx"  },
--              {"gcc/5.9.2", "mpich/17.200.1", "petsc/3.4-cxx"  },
--              {"gcc/5.9.2", "mpich/17.200.2", "petsc/3.4-cxx"  },
--              {"gcc/5.9.3", "mpich/17.200.1", "petsc/3.4-cmplx"},
--              {"gcc/5.9.3", "mpich/17.200.2", "petsc/3.4-cmplx"},
--              {"gcc/5.9.2", "mpich/17.200.1", "petsc/3.4-cmplx"},
--              {"gcc/5.9.2", "mpich/17.200.2", "petsc/3.4-cmplx"},
--           },
--     }
--
------------------------------------------------------------------------
-- The logic for this routine was originally written by Kenneth Hoste in
-- python after yours truly couldn't work it out.

local function l_build_parentT(keepT, mpathMapT)
   dbg.start{"l_build_parentT(keepT, mpathMapT)"}
   dbg.printT("keepT",keepT)
   dbg.printT("mpathMapT",mpathMapT)

   local function l_build_parentT_helper( mpath, fullNameA, fullNameT)
      dbg.start{"l_build_parentT_helper(mpath, fullNameA, fullNameT)"}
      dbg.print{"mpath: ",mpath,"\n"}
      dbg.printT("fullNameA: ",fullNameA)
      dbg.printT("fullNameT: ",fullNameT)

      local resultA
      if (not mpathMapT[mpath]) then
         resultA = { fullNameA }
      else
         resultA = {}
         for fullName, mpath2 in pairs(mpathMapT[mpath]) do
            if (not fullNameT[fullName]) then
               local tmpA    = copy(fullNameA)
               local tmpT    = copy(fullNameT)
               if (keepT[mpath2]) then
                  tmpA[#tmpA+1]  = fullName
                  tmpT[fullName] = true
               end
               resultA = extend(resultA, l_build_parentT_helper(mpath2, tmpA, tmpT))
            end
         end
      end
      dbg.printT("resultA",resultA)
      dbg.fini("l_build_parentT_helper")
      return resultA
   end

   local parentT = {}
   for mpath, v in pairs(mpathMapT) do
      parentT[mpath] = {}
      local A        = parentT[mpath]

      for fullName, mpath2 in pairs(v) do
         A = extend(A, l_build_parentT_helper(mpath2, {fullName}, {[fullName] = true}))
      end
   end

   for mpath, AA in pairs(parentT) do
      for i = 1, #AA do
         reverse(AA[i])
      end
   end

   dbg.printT("parentT",parentT)
   dbg.fini("l_build_parentT")
   return parentT
end

local function l_build_mpathParentT(mpathMapT)
   dbg.start{"l_build_mpathParentT(mpathMapT)"}
   local mpathParentT = {}
   dbg.printT("mpathMapT",mpathMapT)
   for mpath, vv in pairs(mpathMapT) do
      local a = mpathParentT[mpath] or {}
      for k, v in pairs(vv) do
         local found = false
         for i = 1,#a do
            if (a[i] == v) then
               found = true
               break
            end
         end
         if (not found) then
            a[#a+1] = v
         end
      end
      mpathParentT[mpath]  = a
   end
   dbg.fini("l_build_mpathParentT")
   return mpathParentT
end

-- mpathParentT = {
--    ["%ProjDir%/Compiler/gcc/5.9"]         = { "%ProjDir%/Core", "%ProjDir%/Core2"},
--    ["%ProjDir%/MPI/gcc/5.9/mpich/17.200"] = { "%ProjDir%/Compiler/gcc/5.9"},
-- }


local function l_search_mpathParentT(mpath, keepT, mpathParentT)
   local a = mpathParentT[mpath]
   if (not a) then
      return false
   end

   local found = false
   for i = 1,#a do
      mpath = a[i]
      if (keepT[mpath] or l_search_mpathParentT(mpath, keepT, mpathParentT)) then
         return true
      end
   end
   return false
end

local function l_build_keepT(mpathA, mpathParentT, spiderT)
   local keepT = {}
   for i = 1,#mpathA do
      keepT[mpathA[i]] = true
   end

   for mpath, vv in pairs(spiderT) do
      if (mpath ~= 'version') then
         if (not keepT[mpath] and l_search_mpathParentT(mpath, keepT, mpathParentT)) then
            keepT[mpath] = true
         end
      end
   end

   return keepT
end

local dbT_keyA = { 'Description', 'Category', 'URL', 'Version', 'whatis', 'dirA',
                   'family','pathA', 'lpathA', 'propT','help','pV','wV','provides'}


function M.buildDbT(self, mpathMapT, spiderT, dbT)
   dbg.start{"Spider:buildDbT(mpathMapT,spiderT, dbT)"}
   dbg.printT("mpathMapT",mpathMapT)
   local mpathParentT = l_build_mpathParentT(mpathMapT)
   dbg.printT("spiderT",spiderT)
   dbg.printT("mpathParentT",mpathParentT)
   local mpathA = {}
   for k, v in pairs(spiderT) do
      if (k ~= "version") then
         mpathA[#mpathA + 1] = k
      end
   end
   dbg.printT("mpathA",mpathA)
   local keepT        = l_build_keepT(mpathA, mpathParentT, spiderT)
   local parentT      = l_build_parentT(keepT, mpathMapT)
   local mrc          = MRC:singleton()

   local function l_cmp(a,b)
      return a[1] > b[1]
   end
   local function l_buildDbT_helper(mpath, sn, v, T)
      local kind = false
      if (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            local t = {}
            for i = 1,#dbT_keyA do
               local key = dbT_keyA[i]
               t[key]    = vv[key]
            end
            if (parentT[mpath] and next(parentT[mpath]) ~= nil) then
               dbg.printT("parentAA",parentT[mpath])
               sort(parentT[mpath], l_cmp)
            end
            t.parentAA    = parentT[mpath]
            t.mpath       = vv.mpath
            t.fullName    = fullName
            local resultT = mrc:isVisible{fullName=fullName, sn=sn, fn=vv.fn, mpathA=mpathA, mpath = vv.mpath}
            t.hidden      = not resultT.isVisible
            kind          = resultT.moduleKindT.kind
            if (not vv.dot_version and (kind ~= "hard")) then
               T[vv.fn]  = t
            end
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            l_buildDbT_helper(mpath, sn, vv, T)
         end
      end
   end


   dbg.printT("mpathA",      mpathA)
   dbg.printT("mpathMapT",   mpathMapT)
   dbg.printT("mpathParentT",mpathParentT)
   dbg.printT("keepT",       keepT)
   dbg.printT("parentT",     parentT)


   if (next(spiderT) == nil) then
      dbg.print{"empty spiderT\n"}
      dbg.fini("Spider:buildDbT")
      return
   end

   for mpath, vv in pairs(spiderT) do
      dbg.print{"mpath: ",mpath, ", keepT[mpathT]: ",tostring(keepT[mpath]),"\n"}
      if (mpath ~= 'version' and keepT[mpath]) then
         for sn, v in pairs(vv) do
            local T = dbT[sn] or {}
            l_buildDbT_helper(mpath, sn, v, T)
            dbT[sn] = T
         end
      end
   end
   dbg.printT("dbT",       dbT)
   dbg.fini("Spider:buildDbT")
end

function M.buildProvideByT(self, dbT, providedByT)
   dbg.start{"Spider:buildProvideByT(dbT, providedByT)"}

   local mrc = MRC:singleton()
   for sn, vv in pairs(dbT) do
      for fullPath, v in pairs(vv) do
         local resultT = mrc:isVisible{fullName=v.fullName, sn=sn, fn=fullPath, mpath=v.mpath}
         local hidden  = not resultT.isVisible
         if (v.provides ~= nil) then
            local providesA = v.provides
            for i = 1, #providesA do
               local fullName = providesA[i]
               local _,_, sn  = fullName:find("^([^/]*)")
               local T        = providedByT[sn] or {}
               local A        = T[fullName] or {}
               local parentAA = v.parentAA
               if (parentAA == nil) then
                  A[#A+1] = {fullName = v.fullName, pV = v.pV, hidden = hidden,
                             my_name = fullName, mpath = v.mpath}
               else
                  for j = 1,#parentAA do
                     local hierStr = concatTbl(parentAA[j]," ")
                     A[#A+1] = {fullName = v.fullName .. " (" .. hierStr .. ")", pV = v.pV,
                                hidden = hidden, my_name = fullName, mpath = v.mpath}
                  end
               end
               T[fullName]     = A
               providedByT[sn] = T
            end
         end
      end
   end

   local function l_cmp(a, b)
      if (a.pV > b.pV) then
         return true
      elseif (a.pV == b.pV) then
         return a.fullName > b.fullName
      else
         return false
      end
   end

   for sn, vv in pairs(providedByT) do
      for fullName, v in pairs(vv) do
         sort(v, l_cmp)
      end
   end

   dbg.printT("providedByT",providedByT)
   dbg.fini("Spider:buildProvideByT")
end


function M.Level0_terse(self,dbT, providedByT)
   dbg.start{"Spider:Level0_terse()"}
   local mrc         = MRC:singleton()
   local t           = {}
   local a           = {}

   mrc:set_display_mode("spider")

   for sn, vv in pairs(dbT) do
      for fn, v in pairs(vv) do
         local resultT = mrc:isVisible{fullName=v.fullName,sn=sn,fn=fn, mpath = v.mpath}
         if (resultT.isVisible) then
            local forbiddenT = mrc:isForbidden{fullName=v.fullName, sn=sn, fn=fn, mpath = v.mpath}
            if (sn == v.fullName) then
               t[sn] = decorateModule(sn, resultT, forbiddenT)
            else
               -- print out directory name (e.g. gcc) for tab completion.
               t[sn]     = sn .. "/"
               local key = sn .. "/" .. v.pV
               t[key]    = decorateModule(v.fullName, resultT, forbiddenT)
            end
         end
      end
   end

   for sn, vv in pairs(providedByT) do
      t[sn] = t[sn] or sn .. "/"
      for fullName, A in pairs(vv) do
         t[fullName] = t[fullName] or fullName
      end
   end

   for k,v in pairsByKeys(t) do
      a[#a+1] = v
   end
   a[#a+1] = ""
   dbg.fini("Spider:Level0_terse")
   return concatTbl(a,"\n")
end

function M.Level0(self, dbT, providedByT)
   local a = {}

   if (optionTbl().terse) then
      return self:Level0_terse(dbT, providedByT)
   end

   local ia     = 0
   local banner = Banner:singleton()
   local border = banner:border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = border
   ia = ia+1; a[ia] = i18n("m_Spider_Title", {})
   ia = ia+1; a[ia] = border

   self:Level0Helper(dbT, providedByT, a)

   return concatTbl(a,"")
end

--------------------------------------------------------------------------
-- Convert both argument to lower case and compare.
-- @param a input string
-- @param b input string
local function l_case_independent_cmp_by_name(a,b)
   local a_lower = a:lower()
   local b_lower = b:lower()

   if (a_lower  == b_lower ) then
      return a < b
   else
      return a_lower < b_lower
   end
end

local function l_computeColor(resultT, forbiddenT)
   local fT = forbiddenT
   if (not fT or next(fT) == nil) then
      fT = {forbiddenState = "normal"}
   end
   if (fT.forbiddenState ~= "normal") then
      return fT.forbiddenState
   end
   if (resultT.moduleKindT.kind ~= "normal") then
      return "hidden"
   end
   return false
end

function M.Level0Helper(self, dbT, providedByT, a)
   local t           = {}
   local optionTbl   = optionTbl()
   local mrc         = MRC:singleton()
   local show_hidden = mrc:show_hidden()
   local term_width  = TermWidth() - 4
   local banner      = Banner:singleton()

   for sn, vv in pairs(dbT) do
      for fn,v in pairsByKeys(vv) do
         local resultT = mrc:isVisible{fullName=v.fullName,sn=sn,fn=fn, mpath = v.mpath}
         if (resultT.isVisible) then
            local forbiddenT = mrc:isForbidden{fullName=v.fullName,sn=sn,fn=fn, mpath = v.mpath}
            if (t[sn] == nil) then
               t[sn] = { Description = v.Description, versionA = { }, name = sn}
            end
            local color = l_computeColor(resultT, forbiddenT)
            dbg.print{"fullName: ",v.fullName,", color: ",color,"\n"}
            dbg.printT("resultT",resultT)
            dbg.printT("forbiddenT",forbiddenT or {})

            t[sn].versionA[v.pV] = colorize(color, v.fullName)
         end
      end
   end

   local have_providedBy = false
   if (next(providedByT) ~= nil) then
      for sn, vv in pairs(providedByT) do
         for fullName, A in pairs(vv) do
            local isVisible = show_hidden
            if (not show_hidden) then
               for i = 1, #A do
                  if (not A[i].hidden) then
                     isVisible = true
                     break
                  end
               end
            end
            if (isVisible) then
               have_providedBy = true
               local version = extractVersion(fullName,sn)
               local pV      = parseVersion(version)
               if ( t[sn] == nil) then
                  t[sn] = {versionA = { }, name = sn}
               end
               t[sn].versionA[pV] = colorize("blue",fullName) .. " (E)"
            end
         end
      end
   end

   local ia  = #a
   local cmp = (cosmic:value("LMOD_CASE_INDEPENDENT_SORTING") == "yes") and
                l_case_independent_cmp_by_name or nil

   for k,v in pairsByKeys(t,cmp) do
      local len = 0
      ia = ia + 1; a[ia] = "  " .. v.name .. ":"
      len = len + a[ia]:len()
      for kk,full in pairsByKeys(v.versionA) do
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
   if (have_providedBy) then
      ia = ia + 1
      a[ia] = i18n("m_ProvidedBy")
   end

   local border = banner:border(0)
   ia = ia+1; a[ia] = i18n("m_Spider_Tail", {border=border})
end

function M.setExactMatch(self, name)
   self.__name  = name
end

function M.getExactMatch(self)
   return self.__name
end

function M.spiderSearch(self, dbT, providedByT, userSearchPat, helpFlg)
   dbg.start{"Spider:spiderSearch(dbT,providedByT,\"",userSearchPat,"\",",helpFlg,")"}
   local mrc         = MRC:singleton()
   local optionTbl   = optionTbl()

   mrc:set_display_mode("spider")

   local show_hidden = mrc:show_hidden()

   dbg.print{"show_hidden: ",show_hidden,"\n"}

   --dbg.printT("dbT",dbT)

   local origUserSearchPat = userSearchPat
   if (not optionTbl.regexp) then
      userSearchPat = userSearchPat:caseIndependent()
   end

   ------------------------------------------------------------
   -- Match rules in dbT
   --
   -- 1) Matching original user search pattern in dbT
   --    Check for possibles.  Count

   -- 2) Matching one Full only -> Level 2
   --
   -- 3) Matching sn but there is only 1 fullName -> Level 2
   --
   -- 4) Matching sn or full with multiple versions -> Level1

   local a         = {}
   local matchT    = {}
   local T         = dbT[origUserSearchPat]
   local TT        = providedByT[origUserSearchPat]

   if (T  and next(T)  ~= nil) then dbg.printT("dbT->T",T)          else dbg.print{"no T\n"} end
   if (TT and next(TT) ~= nil) then dbg.printT("providedBy->TT",TT) else dbg.print{"no TT\n"} end

   local look4poss = false
   if (T or TT) then
      -- Must check for any valid modulefiles or providesBy
      dbg.print{"Have T or TT\n"}

      local found = true
      if (not show_hidden) then
         found = false
         if (T) then
            dbg.print{"Have T\n"}
            for fn, v in pairs(T) do
               local resultT = mrc:isVisible{fullName=v.fullName,fn=fn,sn=origUserSearchPat, mpath=v.mpath}
               if (resultT.isVisible) then
                  found = true
                  break
               end
            end
         end
         if (TT and not found) then
            dbg.print{"Have TT\n"}
            for fullName, A in pairs(TT) do
               for i = 1,#A do
                  if (not A[i].hidden) then
                     found = true
                     break
                  end
               end
            end
         end
      end

      if (found) then
         matchT[origUserSearchPat] = origUserSearchPat
         look4poss                 = true
      end
   else
      dbg.print{"Do not have T or TT\n"}
      -- If here then no exact match has been found in either dbT or providedByT, so
      -- Step 1 copy all sn and fullNames to fullA

      local aT = {}
      local bT = {}
      dbg.print{"userSearchPat: ",userSearchPat,"\n"}
      local fullA = {}
      for sn, vv in pairs(dbT) do
         for fn, v in pairs(vv) do
            local resultT = mrc:isVisible{fullName=v.fullName,sn=sn,fn=fn, mpath = v.mpath}
            if (resultT.isVisible) then
                fullA[#fullA+1] = {sn=sn, fullName=v.fullName}
            end
         end
      end
      for sn, vv in pairs(providedByT) do
         for fullName, A in pairs(vv) do
            for i = 1,#A do
               if (show_hidden or (not A[i].hidden)) then
                  fullA[#fullA+1] = {sn=sn, fullName=fullName}
                  break
               end
            end
         end
      end

      dbg.printT("fullA: ",fullA)

      -- Step 2: find matches: if exact match then place in aT,
      --         otherwise partial matches go in bT
      local my_sn = nil
      for i = 1, #fullA do
         local mod      = fullA[i]
         local sn       = mod.sn
         local fullName = mod.fullName

         if (sn == origUserSearchPat or fullName == origUserSearchPat) then
            aT[sn] = origUserSearchPat
         end

         if (sn:find(userSearchPat) or fullName:find(userSearchPat)) then
            bT[sn] = userSearchPat
         end
         my_sn = sn
      end

      -- Step 3: Prefer exact matches (aT) if any to partial matches (bT)
      matchT = (next(aT) ~= nil) and aT or bT
      local matchMe = "bT"
      if (next(aT) ~= nil) then
         matchMe = "aT"
      end

      dbg.printT("aT",aT)
      dbg.printT("bT",bT)
   end

   if (next(matchT) == nil) then
      if (optionTbl.terse) then
         dbg.fini("Spider:spiderSearch")
         return ""
      end
      LmodSystemError{msg="e_Failed_2_Find", name=origUserSearchPat}
   end

   local possibleA = {}
   if (look4poss) then
      for sn, v in pairsByKeys(dbT) do
         if (sn:find(userSearchPat) and sn ~= origUserSearchPat) then
            possibleA[#possibleA+1] = sn
            self:setExactMatch(origUserSearchPat)
         end
      end
   end

   for sn, key in pairsByKeys(matchT) do
      if ((dbT[sn] and next(dbT[sn]) ~= nil) or (providedByT[sn] and next(providedByT[sn]) ~= nil)) then
         local s = self:_Level1(dbT, providedByT, possibleA, sn, key, helpFlg)
         if (s) then
            a[#a+1] = s
         end
      end
   end
   if (#a < 1) then
      if (optionTbl.terse) then
         dbg.fini("Spider:spiderSearch")
         return ""
      end
      LmodError{msg="e_No_Matching_Mods"}
      dbg.fini("Spider:spiderSearch")
   end

   dbg.fini("Spider:spiderSearch")
   return concatTbl(a,"")
end

function M._Level1(self, dbT, providedByT, possibleA, sn, key, helpFlg)
   dbg.start{"Spider:_Level1(dbT, providedByT, possibleA, sn: \"",sn,"\", key: \"",key,"\")"}
   local optionTbl   = optionTbl()
   local term_width  = TermWidth() - 4
   local mrc         = MRC:singleton()
   local show_hidden = mrc:show_hidden()
   local T           = dbT[sn]
   local TT          = providedByT[sn]
   local tailMsg     = nil
   local sort        = table.sort
   if (T == nil and TT == nil) then
      LmodSystemError{msg="e_dbT_sn_fail", sn = sn}
   end

   dbg.printT("providedByT",providedByT)


   local function l_countEntries()
      local m_count  = 0
      local p_count  = 0
      local aa       = {}
      local bb       = {}
      local cc       = {}
      local dd       = {}
      local entryMA  = {}
      local entryPA  = {}
      local fullName = nil
      local fName2   = nil
      if (T) then
         dbg.print{"Have T in l_countEntries\n"}
         dbg.print{"key: ",key,"\n"}
         for fn, v in pairs(T) do
            local resultT = mrc:isVisible{fullName=v.fullName,sn=sn,fn=fn, mpath = v.mpath}
            if (resultT.isVisible) then
               v.fn=fn
               if (v.fullName == key) then
                  aa[#aa + 1] = v
               end
               if(v.fullName:find(key) ) then
                  bb[#bb + 1] = v
                  fullName    = v.fullName
               end
            end
         end
      end
      if (#aa > 0) then
         m_count  = 1
         entryMA  = aa
         fullName = aa[1].fullName
      else
         m_count = #bb
         entryMA = bb
      end

      local function cmp(a,b)
         return a.fn < b.fn
      end

      sort(entryMA,cmp)

      --io.stderr:write("m_count: ",m_count,"\n")
      --for i = 1,#aa do
      --   io.stderr:write("aa i:",i,": ",aa[i].fullName,"\n")
      --end

      if (TT) then
         dbg.print{"Have TT in l_countEntries. key: ",key,"\n"}
         for sn, vv in pairs(providedByT) do
            for k, A in pairs(vv) do
               for i = 1,#A do
                  local v = A[i]
                  dbg.print{"k: ",k,", fullName of module: ",v.fullName,"\n"}
                  if (not v.hidden or show_hidden) then
                     if (k == key) then
                        dbg.print{"  key :",key," matches\n"}
                        cc[#cc+1]        = A[i]
                        fName2           = colorize("blue",k) .. " (E)"
                     end
                     if (k:find(key)) then
                        dbg.print{"  key :",key," find match\n"}
                        dd[#dd+1]        = A[i]
                        fName2           = colorize("blue",k) .. " (E)"
                     end
                  end
               end
            end
         end
      end

      if (not tailMsg and fName2) then
         tailMsg = i18n("m_ProvidedBy",{})
      end
      fullName = fullName or fName2

      dbg.print{"(TT) fullName: ",fullName,"\n"}
      if (next(cc) ~= nil) then
         p_count = 1
         entryPA = cc
      else
         p_count = #dd
         entryPA = dd
      end

      local nameT    = {}
      local numNames = 0
      for i = 1, #entryMA do
         local fullName = entryMA[i].fullName
         if (nameT[fullName] == nil ) then
            nameT[fullName] = true
            numNames = numNames + 1
         end
      end

      for i = 1, #entryPA do
         local fullName = entryPA[i].my_name
         if (nameT[fullName] == nil ) then
            nameT[fullName] = true
            numNames = numNames + 1
         end
      end

      nameT = nil

      return m_count, entryMA, p_count, entryPA, numNames, fullName, tailMsg
   end

   local m_count, entryMA, p_count, entryPA, numNames, fullName, tailMsg = l_countEntries()

   dbg.print{"m_count: ",m_count,", p_count: ",p_count,", fullName: ",fullName,"\n"}

   dbg.printT("entryMA",entryMA)
   dbg.printT("entryPA",entryPA)

   if ((m_count == 1 and p_count == 0) or (m_count == 0 and p_count == 1) or
       (numNames == 1)) then
      --io.stderr:write("going level 2: fullName: ",fullName,"\n")
      local s = self:_Level2(sn, fullName, entryMA, entryPA, possibleA, tailMsg, key)
      dbg.fini("Spider:_Level1")
      return s
   end

   key               = nil
   local banner      = Banner:singleton()
   local border      = banner:border(0)
   local fullVT      = {}
   local exampleV    = nil
   local Description = nil
   local kk0         = ""

   if (T) then
      dbg.print{"Have T\n"}
      for fn, v in pairsByKeys(T) do
         local resultT = mrc:isVisible{fullName=v.fullName, sn=sn, fn=fn, mpath = v.mpath}
         if (resultT.isVisible) then
            local version  = extractVersion(v.fullName, sn)
            local kk       = sn .. "/" .. parseVersion(version)
            if (fullVT[kk] == nil) then
               key         = sn
               Description = v.Description
               fullVT[kk]  = { fullName = v.fullName, Category = v.Category,
                               propT = v.propT, parentAA = v.parentAA }
            end
            if (kk > kk0) then
               kk0      = kk
               exampleV = v.fullName
            end
         end
      end
   end

   if (TT) then
      dbg.print{"Have TT\n"}
      for fullName, A in pairsByKeys(TT) do
         for i = 1,#A do
            if (show_hidden or not A[i].hidden) then
               local kk = sn .. "/" .. parseVersion(extractVersion(fullName, sn)) .. ' (E)'
               if (fullVT[kk] == nil) then
                  key         = sn
                  Description = nil
                  fullVT[kk]  = { fullName = colorize("blue",fullName) .. ' (E)', providedBy = true}
               end
               if (kk > kk0) then
                  kk       = kk0
                  exampleV = fullName
               end
            end
         end
      end
   end

   dbg.printT("T",T)
   dbg.printT("entryMA",entryMA)
   dbg.printT("fullVT", fullVT)


   if (key == nil) then
      dbg.print{"key is nil\n"}
      dbg.fini("Spider:_Level1")
      return ""
   end

   local a  = {}
   local ia = 0
   if (optionTbl.terse) then
      for k, v in pairsByKeys(fullVT) do
         if (not v.providedBy) then
            ia = ia + 1; a[ia] = v.fullName .. "\n"
         end
      end
      return concatTbl(a,"")
   end

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   ia = ia + 1; a[ia] = "  " .. key .. ":\n"
   ia = ia + 1; a[ia] = border
   if (Description) then
      ia = ia + 1; a[ia] = i18n("m_Description", {descript = Description:fillWords("      ",term_width)})
   end
   ia = ia + 1; a[ia] = i18n("m_Versions",{})
   for k, v in pairsByKeys(fullVT) do
      local decoration = hook.apply("spider_decoration",v)
      decoration = decoration and " ("..decoration..")" or ""
      local str = v.fullName .. decoration
      ia = ia + 1; a[ia] = "        " .. str .. "\n"
   end

   if (next(possibleA) ~= nil) then
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
      ia = ia + 1; a[ia] = i18n("m_Other_possible",{b=concatTbl(b,"  ")})
   end

   if (tailMsg) then
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = tailMsg
   end

   if (helpFlg) then
      ia = ia + 1; a[ia] = "\n"
      local name = self:getExactMatch()
      if (name) then
         ia = ia + 1; a[ia] = i18n("m_Regex_Spider",{border=border, name=name})
      end
      ia = ia + 1; a[ia] = i18n("m_Spdr_L1",{border=border,key=key,exampleV=exampleV})
   end

   dbg.fini("Spider:_Level1")
   return concatTbl(a,"")
end

function M._Level2(self, sn, fullName, entryA, entryPA, possibleA, tailMsg, key)
   dbg.start{"Spider:_Level2(\"",sn,"\", \"",fullName,"\", entryA, entryPA, possibleA, tailMsg, key: \"",key or "nil","\")"}
   --dbg.printT("entryA",entryA)

   local optionTbl    = optionTbl()
   local mrc          = MRC:singleton();    mrc:set_display_mode("spider")
   local show_hidden  = mrc:show_hidden()
   local terse        = optionTbl.terse
   local a            = {}
   local ia           = 0
   local b            = {}
   local c            = {}
   local titleIdx     = 0
   local entryT       = entryA[1] or {}
   local banner       = Banner:singleton()
   local border       = banner:border(0)
   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()
   local term_width   = TermWidth() - 4
   local availT       = {
      i18n("m_Direct_Load",   {fullName=fullName}),
      i18n("m_Depend_Mods",   {fullName=fullName}),
      i18n("m_Direct_Load",   {fullName=fullName}) .. i18n("m_Additional_Variants",{}),
      i18n("m_ProvByModules", {fullName=fullName})
   }
   local haveCore = 0
   local haveHier = 0

   dbg.printT("entryA[1]", entryT)
   dbg.printT("entryPA", entryPA)

   -- Early return for terse mode:
   -- - If user searched for a specific module/version (key == fullName), show prerequisites
   -- - If user searched for a module name and got one match (key != fullName), show module name
   -- This fixes the asymmetry issue while preserving the expected behavior for specific version searches
   if (terse and fullName and (next(entryA) ~= nil or next(entryPA) ~= nil)) then
      -- If key matches fullName, user searched for specific version - show prerequisites
      if (key and key == fullName) then
         -- Fall through to show prerequisites (existing behavior)
      else
         -- User searched for module name, got one match - show module name (fix asymmetry)
         dbg.fini("Spider:_Level2")
         return fullName .. "\n"
      end
   end

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   ia = ia + 1; a[ia] = "  " .. sn .. ": "
   ia = ia + 1; a[ia] = fullName
   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   if (entryT.Description) then
      ia = ia + 1; a[ia] = i18n("m_Description", {descript = entryT.Description:fillWords("      ", term_width)})
   end

   if (entryT.propT ) then
      ia = ia + 1; a[ia] = i18n("m_Properties",{})
      for kk, vv in pairs(propDisplayT) do
         if (entryT.propT[kk]) then
            for kkk in pairs(entryT.propT[kk]) do
               if (vv.displayT[kkk]) then
                  ia = ia + 1; a[ia] = vv.displayT[kkk].doc:fillWords("      ", term_width)
               end
            end
         end
      end
      ia = ia + 1; a[ia] = "\n"
   end

   if (next(possibleA) ~= nil) then
      local bb  = {}
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
      ia = ia + 1; a[ia] = i18n("m_Other_matches",{bb=concatTbl(bb,", ")})
   end

   if (next(entryA) ~= nil) then
      ia = ia + 1; a[ia] = "Avail Title goes here.  This should never be seen\n"
      titleIdx = ia

      for k = 1, #entryA do
         local my_entryT = entryA[k]
         if (not my_entryT.parentAA) then
            haveCore = 1
         else
            b[#b+1] = "      "
            haveHier = 2
         end
         if (my_entryT.parentAA) then
            for j = 1, #my_entryT.parentAA do
               local parentA = my_entryT.parentAA[j]
               for i = 1, #parentA do
                  b[#b+1] = parentA[i]
                  b[#b+1] = '  '
               end
               b[#b] = "\n      "
            end
            if (#b > 0) then
               b[#b] = "\n" -- Remove the final space add newline instead
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
               d[k] = 1
            end
         end
         local x = {}
         c = {}
         for k in pairs(d) do
            c[#c+1] = k
            x[#x+1] = k:gsub("^ *","")
         end
         table.sort(c)
         c[#c+1] = " "
         ia = ia + 1; a[ia] = concatTbl(c,"\n")
         if (terse) then
            table.sort(x)
            return concatTbl(x,"\n")
         end
      end
   end

   if (next(entryPA) ~= nil) then
      dbg.print{"Building list of modules that provide this package\n"}
      c  = {}
      ia = ia + 1; a[ia] = i18n("m_ProvidedFrom",{})
      dbg.print{"#entryPA: ",#entryPA,"\n"}
      dbg.printT("entryPA",entryPA)
      for i = 1,#entryPA do
         local v = entryPA[i]
         dbg.printT("v",v)
         if (not v.hidden or show_hidden) then
            c[#c+1] = "\n       " .. v.fullName
         end
      end
      c[#c+1] = "\n"
      ia = ia + 1; a[ia] = concatTbl(c,"")
      dbg.print{"results: \"",a[ia],"\"\n"}
      ia = ia + 1; a[ia] = "\n"
   end


   if (entryT.provides ~= nil) then
      local c = {}
      for ic = 1, #entryT.provides do
         c[ic] = colorize("blue",entryT.provides[ic]) .. " (E)"
      end

      ia = ia + 1; a[ia] = i18n("m_ModProvides",{})
      ia = ia + 1; a[ia] = "\n       " .. concatTbl(c,", ")
      ia = ia + 1; a[ia] = "\n"
   end

   if (entryT.help ~= nil) then
      ia = ia + 1; a[ia] = "\n    Help:\n"
      for s in entryT.help:split("\n") do
         ia = ia + 1; a[ia] = "      "
         ia = ia + 1; a[ia] = s
         ia = ia + 1; a[ia] = "\n"
      end
   end

   if (tailMsg) then
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = tailMsg
   end


   ia = ia + 1; a[ia] = "\n"
   local name = self:getExactMatch()
   if (name) then
      ia = ia + 1; a[ia] = i18n("m_Regex_Spider",{border=border,name=name})
   end

   dbg.fini("Spider:_Level2")
   return concatTbl(a,"")
end

function M.listModules(self, dbT)
   local listT = {}
   for sn, vv in pairs(dbT) do
      for fn, v in pairs(vv) do
         listT[fn] = true
      end
   end
   return listT
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
