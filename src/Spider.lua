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

require("string_utils")
require("fileOps")
require("pairsByKeys")
require("utils")
require("serializeTbl")
require("deepcopy")
require("loadModuleFile")

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
      local p2     = abspath(path)
      if (p2 and p2 ~= path) then
         a[p2]     = 1
      end
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

   local shell    = _G.Shell
   local tracing  = cosmic:value("LMOD_TRACING")
   local function loadMe(entryT, moduleStack, iStack, myModuleT)
      local shellNm       = "bash"
      local fn            = entryT.fn
      local sn            = entryT.sn
      local pV            = entryT.pV
      local wV            = entryT.wV
      local fullName      = entryT.fullName
      local version       = entryT.version
      moduleStack[iStack] = { mpath = mpath, sn = sn, fullName = fullName, moduleT = myModuleT, fn = fn}
      local mname         = MName:new("entryT", entryT)
      mt:add(mname, "pending")

      if (tracing == "yes") then
         local b          = {}
         b[#b + 1]        = "Spider Loading: "
         b[#b + 1]        = fullName
         b[#b + 1]        = " (fn: "
         b[#b + 1]        = fn or "nil"
         b[#b + 1]        = ")\n"
         shell:echo(concatTbl(b,""))
      end

      loadModuleFile{file=fn, help=true, shell=shellNm, reportErr=true, mList = mList}
      hook.apply("load_spider",{fn = fn, modFullName = fullName, sn = sn})
      mt:setStatus(sn, "active")
   end

   local entryT
   local moduleStack = masterTbl().moduleStack
   local iStack      = #moduleStack
   if (v.file) then
      entryT   = { fn = v.file, sn = sn, userName = sn, fullName = sn, version = false,
                   pV = v.pV, wV = v.wV }
      loadMe(entryT, moduleStack, iStack, v.metaModuleT)
   end
   if (next(v.fileT) ~= nil) then
      for fullName, vv in pairs(v.fileT) do
         vv.Version = extractVersion(fullName, sn)
         entryT   = { fn = vv.fn, sn = sn, userName = fullName, fullName = fullName,
                      version = vv.Version, pV = v.pV, wV = v.wV }
         loadMe(entryT, moduleStack, iStack, vv)
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

   for sn, vvv in pairs(dbT) do
      kywdT[sn] = {}
      local t   = kywdT[sn]
      for fn, vv in pairs(vvv) do
         local whatisS  = concatTbl(vv.whatis or {},"\n"):lower()
         local found    = false
         for i = 1,strA.n do
            local str = strA[i]
            if (sn:find(str) or whatisS:find(str)) then
               found = true
               break
            end
            if (vv.propT and next(vv.propT) ~= nil) then
               for propN,v in pairs(vv.propT) do
                  for k in pairs(v) do
                     if (k:find(str)) then
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
   --dbg.start{"l_build_parentT(keepT, mpathMapT)"}
   --dbg.printT("keepT",keepT)
   --dbg.printT("mpathMapT",mpathMapT)

   local function l_build_parentT_helper( mpath, fullNameA, fullNameT)
      --dbg.start{"l_build_parentT_helper(mpath, fullNameA, fullNameT)"}
      --dbg.print{"mpath: ",mpath,"\n"}
      --dbg.printT("fullNameA: ",fullNameA)
      --dbg.printT("fullNameT: ",fullNameT)
      
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
      --dbg.printT("resultA",resultA)
      --dbg.fini("l_build_parentT_helper")
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

   --dbg.printT("parentT",parentT)
   --dbg.fini("l_build_parentT")
   return parentT
end

local function l_build_mpathParentT(mpathMapT)
   local mpathParentT = {}
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
                   'pathA', 'lpathA', 'propT','help','pV','wV'}


function M.buildDbT(self, mpathA, mpathMapT, spiderT, dbT)
   dbg.start{"Spider:buildDbT(mpathMapT,spiderT, dbT)"}
   local mpathParentT = l_build_mpathParentT(mpathMapT)
   local keepT        = l_build_keepT(mpathA, mpathParentT, spiderT)
   local parentT      = l_build_parentT(keepT, mpathMapT)
   local mrc          = MRC:singleton()

   local function buildDbT_helper(mpath, sn, v, T)
      if (v.file) then
         local t = {}
         for i = 1,#dbT_keyA do
            local key = dbT_keyA[i]
            t[key]    = v.metaModuleT[key]
         end
         t.parentAA     = parentT[mpath]
         t.fullName     = sn
         t.hidden       = not mrc:isVisible({fullName=sn, sn=sn, fn=v.file})
         T[v.file]      = t
      end
      if (next(v.fileT) ~= nil) then
         for fullName, vv in pairs(v.fileT) do
            local t = {}
            for i = 1,#dbT_keyA do
               local key = dbT_keyA[i]
               t[key]    = vv[key]
            end
            t.parentAA   = parentT[mpath]
            t.fullName   = fullName
            t.hidden     = not mrc:isVisible({fullName=fullName, sn=sn, fn=vv.fn})
            T[vv.fn]     = t
         end
      end
      if (next(v.dirT) ~= nil) then
         for name, vv in pairs(v.dirT) do
            buildDbT_helper(mpath, sn, vv, T)
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
            buildDbT_helper(mpath, sn, v, T)
            dbT[sn] = T
         end
      end
   end
   dbg.printT("dbT",       dbT)
   dbg.fini("Spider:buildDbT")
end

function M.Level0_terse(self,dbT)
   dbg.start{"Spider:Level0_terse()"}
   local mrc         = MRC:singleton()
   local show_hidden = masterTbl().show_hidden
   local t           = {}
   local a           = {}
   for sn, vv in pairs(dbT) do
      for fn, v in pairs(vv) do
         local isActive, version = isActiveMFile(mrc, v.fullName, sn, fn)
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
   dbg.fini("Spider:Level0_terse")
   return concatTbl(a,"\n")
end

function M.Level0(self, dbT)
   local a           = {}
   local masterTbl   = masterTbl()
   local terse       = masterTbl.terse


   if (terse) then
      return self:Level0_terse(dbT)
   end

   local ia     = 0
   local banner = Banner:singleton()
   local border = banner:border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = border
   ia = ia+1; a[ia] = i18n("m_Spider_Title", {})
   ia = ia+1; a[ia] = border

   self:Level0Helper(dbT,a)

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

function M.Level0Helper(self, dbT, a)
   local t           = {}
   local show_hidden = masterTbl().show_hidden
   local term_width  = TermWidth() - 4
   local banner      = Banner:singleton()
   local mrc         = MRC:singleton()

   for sn, vv in pairs(dbT) do
      for fn,v in pairsByKeys(vv) do
         local isActive, version = isActiveMFile(mrc, v.fullName, sn, fn)
         if (show_hidden or isActive) then
            if (t[sn] == nil) then
               t[sn] = { Description = v.Description, versionA = { }, name = sn}
            end
            t[sn].versionA[v.pV] = v.fullName
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
   local border = banner:border(0)
   ia = ia+1; a[ia] = i18n("m_Spider_Tail", {border=border})
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


   local fullA = {}
   for sn, vv in pairs(dbT) do
      for fn, v in pairs(vv) do
         fullA[#fullA+1] = {sn=sn, fullName=v.fullName, fn=fn}
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
            if (mrc:isVisible({fullName=v.fullName,fn=fn,sn=origUserSearchPat})) then
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
      for _, mod in ipairs(fullA) do
         local sn = mod.sn
         local fullName = mod.fullName
         local fn = mod.fn

         -- only continue if visible
         if (show_hidden or mrc:isVisible({fullName=fullName,sn=sn,fn=fn})) then

            if sn == origUserSearchPat or fullName == origUserSearchPat then
                aT[sn] = origUserSearchPat
            end

            if sn:find(userSearchPat) or fullName:find(userSearchPat) then
                bT[sn] = userSearchPat
            end

         end
      end

      matchT = (next(aT) ~= nil) and aT or bT
      --dbg.printT("aT",aT)
      --dbg.printT("bT",bT)
   end

   if (next(matchT) == nil) then
      setWarningFlag()
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
      if (next(dbT[sn]) ~= nil) then
         local s = self:_Level1(dbT, possibleA, sn, key, helpFlg)
         if (s) then
            a[#a+1] = s
         end
      end
   end
   if (#a < 1) then
      LmodError{msg="e_No_Matching_Mods"}
      dbg.fini("Spider:spiderSearch")
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
      LmodSystemError{msg="e_dbT_sn_fail", sn = sn}
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
         if(fullName:find(key) and (show_hidden or mrc:isVisible({fullName=fullName,sn=sn,fn=fn}))) then
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

   key               = nil
   local banner      = Banner:singleton()
   local border      = banner:border(0)
   local fullVT      = {}
   local exampleV    = nil
   local Description = nil

   for fn, v in pairsByKeys(T) do
      local isActive, version = isActiveMFile(mrc, v.fullName, sn, fn)
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

   if (key == nil) then
      return
   end

   local a  = {}
   local ia = 0
   if (masterTbl.terse) then
      for k, v in pairsByKeys(fullVT) do
         ia = ia + 1; a[ia] = v .. "\n"
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
      ia = ia + 1; a[ia] = "        " .. v .. "\n"
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

function M._Level2(self, sn, entryA, possibleA)
   dbg.start{"Spider:_Level2(",sn,", entryA, possibleA)"}
   --dbg.printT("entryA",entryA)

   local show_hidden  = masterTbl().show_hidden
   local a            = {}
   local ia           = 0
   local b            = {}
   local c            = {}
   local titleIdx     = 0
   local entryT       = entryA[1]
   local fullName     = entryT.fullName
   local banner       = Banner:singleton()
   local border       = banner:border(0)
   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()
   local term_width   = TermWidth() - 4
   local availT       = {
      i18n("m_Direct_Load",{fullName=fullName}),
      i18n("m_Depend_Mods",{fullName=fullName}),
      i18n("m_Direct_Load",{fullName=fullName}) .. i18n("m_Additional_Variants",{}),
   }
   local haveCore = 0
   local haveHier = 0

   --dbg.printT("entryA[1]", entryT)


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

   ia = ia + 1; a[ia] = "Avail Title goes here.  This should never be seen\n"
   titleIdx = ia

   for k = 1, #entryA do
      entryT = entryA[k]
      if (not entryT.parentAA) then
         haveCore = 1
      else
         b[#b+1] = "      "
         haveHier = 2
      end
      if (entryT.parentAA) then
         for j = 1, #entryT.parentAA do
            local parentA = entryT.parentAA[j]
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
