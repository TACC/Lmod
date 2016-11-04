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
--  Copyright (C) 2008-2016 Robert McLay
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

require("string_utils")
require("fileOps")
require("pairsByKeys")
require("utils")
require("serializeTbl")
require("deepcopy")
require("loadModuleFile")

_G._DEBUG          = false               -- Required by the new lua posix
local Banner       = require("Banner")
local M            = {}
local MRC          = require("MRC")
local ModuleA      = require("ModuleA")
local MT           = require("MT")
local MName        = require("MName")
local ReadLmodRC   = require("ReadLmodRC")
local concatTbl    = table.concat
local dbg          = require("Dbg"):dbg()
local getenv       = os.getenv
local lfs          = require("lfs")
local posix        = require("posix")
local access       = posix.access

KeyT = {Description=true, Name=true, URL=true, Version=true, Category=true, Keyword=true}

function M.new(self)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   self.__name  = false
   return o
end

local function nothing()
end

local function process(kind, value)
   if (value == nil) then return end
   local moduleStack = masterTbl().moduleStack
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
   process("lpathA",value)
end

function processPATH(value)
   process("pathA",value)
end

function processDIR(value)
   process("dirA",value)
end

local function processNewModulePATH(path)
   local masterTbl   = masterTbl()
   local dirStk      = masterTbl.dirStk 
   local mpath_new   = path_regularize(path)
   dirStk[#dirStk+1] = mpath_new

   local mpathMapT   = masterTbl.mpathMapT
   local moduleStack = masterTbl.moduleStack
   local iStack      = #moduleStack
   local mpath_old   = moduleStack[iStack].mpath
   local fullName    = moduleStack[iStack].fullName
   local t           = mpathMapT[mpath_new] or {}
   t[fullName]       = mpath_old

   mpathMapT[mpath_new] = t
   
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


local function findModules(mpath, mt, mList, sn, v, moduleT)

   local function loadMe(mpath, mt, entryT, mList, moduleStack, iStack, moduleT)
      local shellNm       = "bash"
      local fn            = entryT.fn
      local sn            = entryT.sn
      local pV            = entryT.pV
      local wV            = entryT.wV
      local fullName      = entryT.fullName
      local version       = entryT.version
      moduleStack[iStack] = { mpath = mpath, sn = sn, fullName = fullName, moduleT = moduleT, fn = fn}
      local mname         = MName:new("entryT", entryT)
      mt:add(mname, "pending")
      loadModuleFile{file=fn, shell=shellNm, mList, reportErr=true, mList = mList}
      mt:setStatus(sn, "active")
   end

   local entryT
   local moduleStack = masterTbl().moduleStack
   local iStack      = #moduleStack
   if (v.file) then
      entryT   = { fn = v.file, sn = sn, userName = sn, fullName = sn, version = false,
                   pV = v.pV, wV = v.wV }
      loadMe(mpath, mt, entryT, mList, moduleStack, iStack, v.metaModuleT)
   end
   if (next(v.fileT) ~= nil) then
      for fullName, vv in pairs(v.fileT) do
         entryT   = { fn = vv.fn, sn = sn, userName = fullName, fullName = fullName,
                      version = extractVersion(fullName, sn),
                      pV = v.pV, wV = v.wV }
         loadMe(mpath, mt, entryT, mList, moduleStack, iStack, vv)
      end
   end
   if (next(v.dirT) ~= nil) then
      for name, vv in pairs(v.dirT) do
         findModules(mpath, mt, mList, sn, vv)
      end
   end
end

function M.searchSpiderDB(self, strA, dbT)
   dbg.start{"Spider:searchSpiderDB({",concatTbl(strA,","),"},spider, dbT)"}
   local masterTbl = masterTbl()
   
   if (not masterTbl.regexp) then
      for i = 1, strA.n do
         strA[i] = strA[i]:caseIndependent()
      end
   end

   local kywdT = {}
   
   for sn, vv in pairs(dbT) do
      kywdT[sn] = {}
      local t   = kywdT[sn]
      for fn, v in pairs(vv) do
         local whatisS  = concatTbl(v.whatis or {},"\n"):lower()
         local found    = false
         for i = 1,strA.n do
            local str = strA[i]
            if (sn:find(str) or whatisS:find(str)) then
               found = true
               break
            end
         end
         if (found) then
            t[fn] = v
         end
      end
      if (next(kywdT[sn]) == nil) then
         kywdT[sn] = nil
      end
   end
         
   dbg.fini("Spider:searchSpiderDB")
   return kywdT
end   




function M.findAllModules(self, mpathA, spiderT)
   dbg.start{"Spider:findAllModules(",concatTbl(mpathA,", "),")"}
   spiderT.version = LMOD_CACHE_VERSION

   local mt              = deepcopy(MT:singleton())
   local maxdepthT       = mt:maxDepthT()
   local masterTbl       = masterTbl()
   local moduleDirT      = {}
   masterTbl.moduleStack = {{}}
   masterTbl.dirStk      = {}
   masterTbl.mpathMapT   = {}

   local mList           = ""
   local exit            = os.exit
   os.exit               = nothing
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

   local dirStk = masterTbl.dirStk
   for _, mpath in ipairs(mpathA) do
      if (isDir(mpath)) then
         dirStk[#dirStk+1] = path_regularize(mpath)
      end
   end

   while(#dirStk > 0) do
      repeat
         
         -- Pop top of dirStk
         local mpath     = dirStk[#dirStk]
         dirStk[#dirStk] = nil

         -- skip mpath directory if already walked.
         if (spiderT[mpath]) then break end  

         -- skip mpath if directory does not exist
         -- or can not be read
         local attr  = lfs.attributes(mpath)
         if (not attr or attr.mode ~= "directory" or
             (not access(mpath,"rx")))               then break end

         local moduleA     = ModuleA:__new({mpath}, maxdepthT):moduleA()
         local T           = moduleA[1].T
         for sn, v in pairs(T) do
            findModules(mpath, mt, mList, sn, v)
         end
         spiderT[mpath] = moduleA[1].T
      until true
   end

   os.exit               = exit
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
   for i = 1, #a do
      b[i] = a[i]
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
--        ['%ProjDir%/spec/Spider/h/mf1/Compiler/gcc/5.9'] =
--           {
--              {"gcc/5.9.3"},
--              {"gcc/5.9.2"},
--           },
--     
--        ['%ProjDir%/spec/Spider/h/mf1/Compiler/gcc/5.9/mpich/17.200'] =
--           {
--              {"gcc/5.9.3", "mpich/17.200.1"},
--              {"gcc/5.9.3", "mpich/17.200.2"},
--              {"gcc/5.9.2", "mpich/17.200.1"},
--              {"gcc/5.9.2", "mpich/17.200.2"},
--           },     
--        ["%ProjDir%/spec/Spider/h/mf1/MPI/gcc/5.9/mpich/17.200/petsc/3.4"]  =
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

local function build_parentT(mpathMapT)

   local function build_parentT_helper( mpath, fullNameA)
      local resultA
      if (not mpathMapT[mpath]) then
         resultA = { fullNameA }
      else
         resultA = {}
         for fullName, mpath2 in pairs(mpathMapT[mpath]) do
            local tmpA    = copy(fullNameA)
            tmpA[#tmpA+1] = fullName
            resultA = extend(resultA, build_parentT_helper(mpath2, tmpA))
         end
      end
      return resultA
   end

   local parentT = {}
   for mpath, v in pairs(mpathMapT) do
      parentT[mpath] = {}
      local A        = parentT[mpath]

      for fullName, mpath2 in pairs(v) do
         A = extend(A, build_parentT_helper(mpath2, {fullName}))
      end
   end

   for mpath, AA in pairs(parentT) do
      for i = 1, #AA do
         reverse(AA[i])
      end
   end

   return parentT
end

local dbT_keyA = { 'Description', 'Category', 'URL', 'Version', 'whatis', 'dirA',
                   'pathA', 'lpathA', 'propT','help','pV'}


function M.buildDbT(self, mpathMapT, spiderT, dbT)

   local parentT   = build_parentT(mpathMapT)


   local function buildDbT_helper(mpath, sn, v, T)
      if (v.file) then
         local t = {}
         for i = 1,#dbT_keyA do
            local key = dbT_keyA[i]
            t[key]    = v.metaModuleT[key]
         end
         t.parentAA     = parentT[mpath]
         t.fullName     = sn
         T[v.file]      = t
      elseif (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            local t = {}
            for i = 1,#dbT_keyA do
               local key = dbT_keyA[i]
               t[key]    = vv[key]
            end
            t.parentAA   = parentT[mpath]
            t.fullName   = fullName
            T[vv.fn]     = t
         end
      elseif (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            buildDbT_helper(mpath, sn, vv, T)
         end
      end
   end

   dbg.start{"Spider:buildDbT(mpathMapT,spiderT, dbT)"}

   if (next(spiderT) == nil) then
      dbg.print{"empty spiderT\n"}
      dbg.fini("Spider:buildDbT")
      return
   end

   for mpath, vv in pairs(spiderT) do
      if (mpath ~= 'version') then
         for sn, v in pairs(vv) do
            local T = dbT[sn] or {}
            buildDbT_helper(mpath, sn, v, T)
            dbT[sn] = T
         end
      end
   end
   dbg.fini("Spider:buildDbT")
end         

function M.Level0(self, dbT)
   local a           = {}
   local masterTbl   = masterTbl()
   local show_hidden = masterTbl.show_hidden
   local terse       = masterTbl.terse
   local mrc         = MRC:singleton()


   if (terse) then
      dbg.start{"Spider:Level0()"}
      local t  = {}
      for sn, vv in pairs(dbT) do
         for fn, v in pairs(vv) do
            local isActive, version = isActiveMFile(mrc, v.fullName, sn)
            if (show_hidden or isActive) then
               if (sn == v.fullName) then
                  t[sn] = sn
               else
                  -- print out directory name (e.g. gcc) for tab completion.
                  t[sn]     = sn .. "/"
                  local key = sn .. "/" .. v.pV
                  t[key]    = v.fullName
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
   local banner = Banner:singleton()
   local border = banner:border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = border
   ia = ia+1; a[ia] = "The following is a list of the modules currently available:\n"
   ia = ia+1; a[ia] = border

   self:Level0Helper(dbT,a)

   return concatTbl(a,"")
end

function M.Level0Helper(self, dbT, a)
   local t           = {}
   local show_hidden = masterTbl().show_hidden
   local term_width  = TermWidth() - 4
   local banner      = Banner:singleton()
   local mrc         = MRC:singleton()

   for sn, vv in pairs(dbT) do
      for fn,v in pairsByKeys(vv) do
         local isActive, version = isActiveMFile(mrc, v.fullName, sn)
         if (show_hidden or isActive) then
            if (t[sn] == nil) then
               t[sn] = { Description = v.Description, versionA = { }, name = sn}
            end
            t[sn].versionA[v.pV] = v.fullName
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

function M.setExactMatch(self, name)
   self.__name  = name
end

function M.getExactMatch(self)
   return self.__name
end

function M.spiderSearch(self, dbT, userSearchPat, helpFlg)
   dbg.start{"Spider:spiderSearch(dbT,\"",userSearchPat,"\",",helpFlg,")"}
   local masterTbl   = masterTbl()
   local show_hidden = masterTbl.show_hidden
   local mrc         = MRC:singleton()

   --dbg.printT("dbT",dbT)


   local fullT = {}
   for sn, vv in pairs(dbT) do
      fullT[sn] = sn
      for fn, v in pairs(vv) do
         fullT[v.fullName] = sn
      end
   end


   local origUserSearchPat = userSearchPat
   if (not masterTbl.regexp) then
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
   local look4poss = false
   if (T) then
      --dbg.print{"found single entry in dbT with sn: ", origUserSearchPat,"\n"}

      -- Must check for any valid modulefiles
      local found = true
      if (not show_hidden) then
         found = false
         for fn, v in pairs(T) do
            if (isVisible(mrc, v.fullName)) then
               found = true
               break
            end
         end
      end
            
      if (found) then
         matchT[origUserSearchPat] = origUserSearchPat
         look4poss                 = true
      end
   else
      local aT = {}
      local bT = {}
      dbg.print{"userSearchPat: ",userSearchPat,"\n"}
      for key, sn in pairs(fullT) do
         if (key == origUserSearchPat and (show_hidden or isVisible(mrc,key))) then
            aT[sn] = origUserSearchPat
         end
         if (key:find(userSearchPat) and (show_hidden or isVisible(mrc,key))) then
            dbg.print{"  key: ",key,", sn: ",sn,"\n"}
            bT[sn] = userSearchPat
         end
      end
      matchT = (next(aT) ~= nil) and aT or bT
      --dbg.printT("aT",aT)
      --dbg.printT("bT",bT)
   end

   if (next(matchT) == nil) then
      setWarningFlag()
      LmodSystemError("Unable to find: \"",origUserSearchPat,"\"\n")
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
      local s = self:_Level1(dbT, possibleA, sn, key, helpFlg)
      if (s) then
         a[#a+1] = s
      end
   end
   dbg.fini("Spider:spiderSearch")
   return concatTbl(a,"")
end   

function M._Level1(self, dbT, possibleA, sn, key, helpFlg)
   dbg.start{"Spider:_Level1(dbT, sn: \"",sn,"\", key: \"",key,"\")"}
   local masterTbl   = masterTbl()
   local show_hidden = masterTbl.show_hidden
   local term_width  = TermWidth() - 4
   local mrc         = MRC:singleton()
   local T           = dbT[sn]
   if (T == nil) then
      LmodSystemError("dbT[sn] failed for sn: ", sn,"\n")
   end

   local function countEntries()
      local count  = 0
      local aa     = {}
      local bb     = {}
      local entryA = {}
      for fn, v in pairs(T) do
         local fullName = v.fullName
         if (fullName == key) then
            aa[#aa + 1] = v
         end
         if(fullName:find(key) and (show_hidden or isVisible(mrc,fullName))) then
            bb[#bb + 1] = v
         end
      end
      if (next(aa) ~= nil) then
         count  = 1
         entryA = aa
      else
         count  = #bb
         entryA = bb
      end
      return count, entryA
   end
            
   local count, entryA = countEntries()
   if (count == 1) then
      local s = self:_Level2(sn, entryA, possibleA)
      dbg.fini("Spider:_Level1")
      return s
   end

   local T           = dbT[sn]
   local key         = nil
   local banner      = Banner:singleton()
   local border      = banner:border(0)
   local fullVT      = {}
   local exampleV    = nil
   local Description = nil

   for fn, v in pairsByKeys(T) do
      local isActive, version = isActiveMFile(mrc, v.fullName, sn)
      if (show_hidden or isActive) then
         local kk            = sn .. "/" .. parseVersion(version)
         if (fullVT[kk] == nil) then
            key         = sn
            Description = v.Description
            fullVT[kk]  = v.fullName
            exampleV    = v.fullName
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
   for k, v in pairsByKeys(fullVT) do
      ia = ia + 1; a[ia] = "        " .. v .. "\n"
   end

   if (next(possibleA) ~= nil) then
      local b   = {}
      local sum = 17
      for ja = 1, #possibleA do
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

   if (helpFlg) then
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

function M._Level2(self, sn, entryA, possibleA)
   dbg.start{"Spider:_Level2(",sn,", entryA, possibleA)"}
   --dbg.printT("entryA",entryA)

   local show_hidden = masterTbl().show_hidden
   local a           = {}
   local ia          = 0
   local b           = {}
   local c           = {}
   local titleIdx    = 0

   local entryT       = entryA[1]
   local fullName     = entryT.fullName
   local banner       = Banner:singleton()
   local border       = banner:border(0)
   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()
   local term_width   = TermWidth() - 4
   local availT       = {
      "\n    This module can be loaded directly: module load " .. fullName .. "\n",
      "\n    You will need to load all module(s) on any one of the lines below before the \"" .. fullName .. "\" module is available to load.\n",
      "\n    This module can be loaded directly: module load " .. fullName .. "\n" ..
      "\n    Additional variants of this module can also be loaded after loading the following modules:\n",
   }
   local haveCore = 0
   local haveHier = 0

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   ia = ia + 1; a[ia] = "  " .. sn .. ": "
   ia = ia + 1; a[ia] = fullName
   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = border
   if (entryT.Description) then
      ia = ia + 1; a[ia] = "    Description:\n"
      ia = ia + 1; a[ia] = entryT.Description:fillWords("      ", term_width)
      ia = ia + 1; a[ia] = "\n"
   end
   if (entryT.propT ) then
      ia = ia + 1; a[ia] = "    Properties:\n"
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
      for ja = 1, #possibleA do
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

   for i = 1, #entryA do
      entryT = entryA[i]
      if (not entryT.parentAA) then
         haveCore = 1
      else
         b[#b+1] = "      "
         haveHier = 2
      end
      if (entryT.parentAA) then
         for i = 1, #entryT.parentAA do
            local entryA = entryT.parentAA[i]
            for j = 1, #entryA do
               b[#b+1] = entryA[j]
               b[#b+1] = '  '
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

   if (entryT and entryT.help ~= nil) then
      ia = ia + 1; a[ia] = "\n    Help:\n"
      for s in entryT.help:split("\n") do
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
