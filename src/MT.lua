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
-- MT: This class controls the ModuleTable.  The ModuleTable is how Lmod
--     communicates what modules are loaded or inactive and so on between
--     module commands.

require("strict")
_ModuleTable_      = ""
local DfltModPath  = DfltModPath
local ModulePath   = ModulePath
local concatTbl    = table.concat
local getenv       = os.getenv
local max          = math.max
local sort         = table.sort
local systemG      = _G
local unpack       = unpack or table.unpack

require("string_utils")
require("fileOps")
require("serializeTbl")
require("parseVersion")
require("deepcopy")
require("utils")

local Var          = require('Var')
local lfs          = require("lfs")
local dbg          = require('Dbg'):dbg()
local ColumnTable  = require('ColumnTable')
local hook         = require("Hook")
local posix        = require("posix")
local deepcopy     = table.deepcopy
local load         = (_VERSION == "Lua 5.1") and loadstring or load

--module("MT")
local M = {}

function M.name(self)
   return '_ModuleTable_'
end

s_loadOrder = 0
s_mt = false

s_mtA = {}

--------------------------------------------------------------------------
-- locationTblDir(): This local function walks a single directory to find
--                   all the modulefiles in that directory.  This function
--                   is used when moduleT is not available.  The naming
--                   rule is implemented here:
--                     (1) If a file is a member of a path in MODULEPATH
--                         then it is a meta-module.
--                     (2) If a file is a sub-directory of MODULEPATH, then
--                         and there are no subdirectories (excluding
--                         '.' and '..' of course), then these files are
--                         version files and the names are the directory
--                         (or directories) between the path in MODULEPATH
--                         and here.
--                     (3) If a file is in a directory with subdirectories
--                         then that file is a meta-module.
--
--                   Meta-modules are modulefiles that are not versioned.
--                   They typically load other modules but not always.

local defaultFnT = {
   default       = 1,
   ['.modulerc'] = 2,
   ['.version']  = 3,
}


local function locationTblDir(mpath, path, prefix, locationT, availT)
   --dbg.start{"locationTblDir(",mpath,",",path,",",prefix,")"}
   local attr = lfs.attributes(path)
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory"
       or not posix.access(path,"x")) then
      --dbg.fini("locationTblDir")
      return
   end

   local mnameT     = {}
   local dirA       = {}
   local defaultFn  = false
   local defaultIdx = 1000000  -- default idx must be bigger than index for .version
   -----------------------------------------------------------------------------
   -- Read every relevant file in a directory.  Copy directory names into dirA.
   -- Copy files into mnameT.
   local ignoreT = ignoreFileT()

   for file in lfs.dir(path) do
      local idx       = defaultFnT[file] or defaultIdx
      if (idx < defaultIdx) then
         defaultIdx = idx
         defaultFn  = pathJoin(abspath(path),file)
      else
         local fileDflt  = file:sub(1,8)
         local firstChar = file:sub(1,1)
         local lastChar  = file:sub(-1,-1)
         local firstTwo  = file:sub(1,2)
         
         if (ignoreT[file]    or lastChar == '~' or ignoreT[fileDflt] or
             firstChar == '#' or lastChar == '#' or firstTwo == '.#') then
            -- nothing happens here
         else
            local f = pathJoin(path,file)
            attr    = lfs.attributes(f) or {}
            local readable = posix.access(f,"r")
            if (not readable or not attr) then
               -- do nothing for non-readable or non-existant files
            elseif (attr.mode == 'file' and file ~= "default") then
               local mname = pathJoin(prefix, file):gsub("%.lua$","")
               mnameT[mname] = {file=f:gsub("%.lua$",""), mpath = mpath}
            elseif (attr.mode == "directory" and file:sub(1,1) ~= ".") then
               dirA[#dirA + 1] = { fullName = f, mname = pathJoin(prefix, file) }
            end
         end
      end
   end

   if (#dirA > 0 or prefix == '') then
      --------------------------------------------------------------------------
      -- If prefix is '' then this directory in directly under MODULEPATH so
      -- any files are meta-modules.  Also if there are files when there are
      -- directories then these files are also meta-modules.

      -- Copy any meta-modules into the array stored at locationT[k].
      for k,v in pairs(mnameT) do
         --dbg.print{"k: ",k,"\n"}
         local a      = locationT[k] 
         if (a == nil) then
            local d, f = splitFileName(v.file)
            f          = pathJoin(abspath(d),f):gsub("%.lua$","")
            a          = {}
            a.default  = {fn=f, kind="last", num = 1}
         end
         a[#a+1]      = v
         locationT[k] = a
         availT[k]    = {}
         availT[k][0] = v
         
      end

      -- For any directories found recursively call locationDir to process.
      for i = 1, #dirA do
         locationTblDir(mpath, dirA[i].fullName,  dirA[i].mname, locationT, availT)
      end
   elseif (next(mnameT) ~= nil) then
      ------------------------------------------------------------------------
      -- If here, then there are no directories and this is not a top level
      -- directory. So any files found here are versions for the module.
      -- The "name" of the module is the "prefix".

      local a           = locationT[prefix] or {}
      a[#a+1]           = {file = path, mpath = mpath}
      local numPathA    = #a
      locationT[prefix] = a
      availT[prefix]    = {}
      local vA          = {}

      ------------------------------------------------------------------------
      -- Sort the files by parseVersion order and store them in "availT[prefix]".
      for full, v in pairs(mnameT) do
         local version = full:gsub(".*/","")
         local parseV  = parseVersion(version)
         vA[#vA+1]     = {parseV, version, v.file}
      end
      sort(vA, function(a,b) return a[1] < b[1] end )
      local a = {}
      for i = 1, #vA do
         a[i] = {version = vA[i][2], file = vA[i][3]}
      end
      --dbg.print{"Adding ",prefix," to availT, #a: ",#a,"\n"}
      availT[prefix] = a
      --dbg.print{"prefix: ",prefix,", defaultFn: ",defaultFn, "\n"}

      if (defaultFn) then
         local d, v = splitFileName(defaultFn)
         v          = "/" .. v
         if (v == "/default") then
            defaultFn = abspath_localdir(defaultFn):gsub("%.lua$","")
         else
            v         = versionFile(v, prefix, defaultFn, true)
            defaultFn = pathJoin(abspath(d),v):gsub("%.lua$","")
         end
         local num = max(#vA, numPathA)
         locationT[prefix].default = {fn = defaultFn, kind="marked", num = #vA}
      else
         local d = abspath(pathJoin(mpath, prefix))
         defaultFn = pathJoin(d, a[#a].version):gsub("%.lua$","")
         locationT[prefix].default = {fn = defaultFn, kind="last", num = #vA}
      end
   end
   -- dbg.fini("locationTblDir")
end



--------------------------------------------------------------------------
-- buildLocWmoduleT(): This local function walks a single directory in
--                     moduleT.  This routine fills in availT[mpath} and
--                     the local copy of the locationT "lT".


local function buildLocWmoduleT(mpath, moduleT, mpathT, lT, availT)
   dbg.start{"MT:buildLocWmoduleT(mpath, moduleT, mpathA, lT, availT)"}
   dbg.print{"mpath: ", mpath,"\n"}

   local Pairs       = dbg.active() and pairsByKeys or pairs
   local availEntryT = availT[mpath]

   for f, vv in Pairs(moduleT) do

      --------------------------------------------------------------------
      --

      local defaultModule = false
      local sn            = vv.name
      local a             = lT[sn] or {}
      if (a[mpath] == nil) then
         a[mpath] = { file = pathJoin(mpath,sn), mpath = mpath, fullFn = vv.path}
      end
      lT[sn]   = a

      a = availEntryT[sn] or {}

      local version   = extractVersion(vv.full, sn)

      if (version) then
         local parseV = parseVersion(version)
         a[parseV]    = { version = version, file = f, parseV = parseV,
                          markedDefault = vv.markedDefault}
      else
         a[0]         = { version = 0, file = f, markedDefault = false,
                          parseV = "z"}
      end
      availEntryT[sn] = a

      for k, v in pairs(vv.children) do
         if (mpathT[k]) then
            buildLocWmoduleT(k, vv.children[k], mpathT, lT, availT)
         end
      end
   end
   dbg.fini("MT:buildLocWmoduleT")
end

--------------------------------------------------------------------------
-- buildAllLocWmoduleT(): This routine walks moduleT for all directories
--                        stored there. Once all the directories have been
--                        traversed by [[buildLocWmoduleT]], [[availT]] is
--                        rebuilt to have the entries in parseVersion order
--                        and locationT is sorted as well.
--
--   availT[mpath][sn] = {
--                         {version=..., file=..., parseV=...,
--                           markedDefault=T/F},
--                       }
--
--  When sn is a meta module then
--   availT[mpath][sn][0] = {version=..., file=..., parseV=...,
--                           markedDefault=T/F},
--
--   locationT[sn] = {
--                    default = {fn=, num=,
--                               kind=[last,marked] }
--                    {mpath=..., file=..., fullFn=...},
--                    {mpath=..., file=..., fullFn=...},
--                   }

local function buildAllLocWmoduleT(moduleT, mpathA, locationT, availT)
   --dbg.start{"MT:buildAllLocWmoduleT(moduleT, mpathA, locationT, availT)"}


   -----------------------------------------------------------------------
   -- Initialize [[mpathT]] and [[availT]] for directories in [[mpathA]]
   -- that exist.


   local Pairs  = dbg.active() and pairsByKeys or pairs
   local mpathT = {}
   local lT     = {}  -- temporary locationT
   for i = 1,#mpathA do
      local mpath = mpathA[i]
      local attr  = lfs.attributes(mpath)
      if (attr and attr.mode == "directory") then
         mpathT[mpath] = i
         availT[mpath] = {}
      end
   end

   -----------------------------------------------------------------------
   -- For each directory in [[mpathT]] process that table in [[moduleT]]
   for mpath in Pairs(mpathT) do
      local mpmT = moduleT[mpath]
      if (mpmT) then
         buildLocWmoduleT(mpath, mpmT, mpathT, lT, availT)
      end
   end

   -----------------------------------------------------------------------
   -- Rebuild [[availT]] to have the versions in parseVersion order.

   for mpath, vvv in Pairs(availT) do
      for sn, vv in Pairs(vvv) do
         local aa = {}
         for parseV, v in pairsByKeys(vv) do
            if (parseV == 0) then
               aa[0] = v
            else
               aa[#aa + 1] = v
            end
         end
         availT[mpath][sn] = aa
      end
   end

   -----------------------------------------------------------------------
   -- Sort [[locationT]] as well.
   for sn, vv in Pairs(lT) do
      local a = {}
      for mpath, v in Pairs(vv) do
         a[#a + 1] = {mpathT[mpath], v}
      end
      sort(a, function (x,y) return x[1] < y[1] end)

      local b = {}
      for i = 1, #a do
         b[i] = a[i][2]
      end
      locationT[sn] = b
   end
   lT = nil  -- Done with lT

   -- Use both locationT and availT to find the default modulefile
   -- and store it in locationT.

   for sn, pathA in Pairs(locationT) do
      local found = false
      for ii = 1, #pathA do
         local mpath    = pathA[ii].mpath
         local versionA = availT[mpath][sn]
         for i = 1, #versionA do
            local v = versionA[i]
            if (v.markedDefault) then
               local num  = max(#versionA, #pathA)
               local d, f = splitFileName(v.file)
               local fn   = pathJoin(abspath(d), f)
               locationT[sn].default = {fn = fn, kind="marked", num = num}
               found = true
               break
            end
         end
         if (found) then break end
      end
      if (not found) then
         local lastValue = false
         local lastKey   = ''
         local sum       = 0
         for i = 1, #pathA do
            local versionA = availT[pathA[i].mpath][sn]
            local num      = #versionA
            local pv       = versionA[num].parseV
            if (pv > lastKey) then
               lastKey   = pv
               lastValue = versionA[num]
            end
            sum = sum + num
         end
         local d, f            = splitFileName(lastValue.file)
         local fn              = pathJoin(abspath(d), f)
         --local fn              = lastValue.file
         locationT[sn].default = {fn = fn, kind = "last", num = sum}
      end
   end

   --dbg.fini("MT:buildAllLocWmoduleT")
end


--------------------------------------------------------------------------
-- build_locationTbl(): Build [[locationT]] either by using [[moduleT]] if
--                      it exists or use [[locationTblDir]] to walk the
--                      directories.

local function build_locationTbl(mpathA)

   dbg.start{"MT:build_locationTbl(mpathA)"}
   local locationT = {}
   local availT    = {}
   local Pairs     = dbg.active() and pairsByKeys or pairs

   if (varTbl[ModulePath] == nil or varTbl[ModulePath]:expand() == "") then
      dbg.print{"MODULEPATH is undefined\n"}
      dbg.fini("MT:build_locationTbl")
      return {}, {}
   end

   local fast      = true
   local cache     = _G.Cache:cache()
   local moduleT   = cache:build(fast)

   dbg.print{"moduleT: ", not (not moduleT),"\n"}

   if (moduleT) then
      buildAllLocWmoduleT(moduleT, mpathA, locationT, availT)
   else
      for i = 1, #mpathA do
         local mpath = mpathA[i]
         availT[mpath] = {}
         locationTblDir(mpath, mpath, "", locationT, availT[mpath])
      end
   end

   --local oldLocationT = locationT
   --
   --locationT = {}
   --for i = 1, #mpathA do
   --   local defaultFn   = false
   --   local defaultKind = false
   --   local mpath       = mpathA[i]
   --   local vv          = availT[mpath]
   --   for sn, v = pairs(vv) do
   --      local a        = locationT[sn]           
   --      if (a) then
   --         local defaultEntry = a.default
   --         defaultKind        = defaultEntry.kind
   --      else
   --         a = {}
   --      end
   --      a = {mpath = mpath, file = pathJoin(mpath,sn) }
   --
   --      for 
   --      if (defaultKind ~= "marked") then
   --         if (v.markedDefault) then
   --            defaultFn = v.
   --   
   --      a = locationT[sn] or {}
   --      v = {mpath=mpath, f
         
   if (dbg.active()) then
      dbg.print{"availT: \n"}
      for mpath, vv in Pairs(availT) do
         dbg.print{"  mpath: ", mpath,":\n"}

         for sn , v in Pairs(vv) do
            dbg.print{"    ",sn,":"}
            for i = 1, #v do
               io.stderr:write(" ",v[i].version,",")
            end
            io.stderr:write("\n")
         end
      end
      dbg.print{"locationT: \n"}
      for sn, vv in Pairs(locationT) do
         dbg.print{"  sn: ", sn,":\n"}
         for i = 1, #vv do
            dbg.print{"    ",vv[i].file,"\n"}
         end
         if (vv.default) then
            dbg.print{"    ",vv.default.kind," Default: ",vv.default.fn,"\n"}
         end
      end
   end
   dbg.fini("MT:build_locationTbl")
   return locationT, availT
end

--------------------------------------------------------------------------
-- columnList(): Generate a columeTable with a title.

local function columnList(stream, msg, a)
   local t = {}
   sort(a)
   for i = 1, #a do
      local cstr = string.format("%3d) ",i)
      t[#t + 1] = cstr .. tostring(a[i])
   end
   stream:write(msg)
   local ct = ColumnTable:new{tbl=t}
   stream:write(ct:build_tbl(),"\n")
end

local function mt_version()
   return 2
end

------------------------------------------------------------------------
-- MT:new(): local ctor for MT.  It uses [[s]] to be the initial value.

local function new(self, s, restore)
   dbg.start{"MT:new()"}
   local o            = {}

   o.c_rebuildTime    = false
   o.c_shortTime      = false
   o.mT               = {}
   o.version          = mt_version()
   o.family           = {}
   o.mpathA           = {}
   o.baseMpathA       = {}
   o._same            = true
   o._MPATH           = ""
   o._locationTbl     = false
   o._availT          = false
   o._loadT           = {}
   o._stickyA         = {}

   o._changePATH      = false
   o._changePATHCount = 0

   setmetatable(o,self)
   self.__index = self

   local active, total

   local currentMPATH  = getenv(ModulePath)
   o.systemBaseMPATH   = path_regularize(currentMPATH)

   dbg.print{"systemBaseMPATH:       \"", currentMPATH, "\"\n"}
   dbg.print{"(1) o.systemBaseMPATH: \"", o.systemBaseMPATH, "\"\n"}
   if (not s) then
      dbg.print{"setting systemBaseMPATH: ", currentMPATH, "\n"}
      varTbl[DfltModPath] = Var:new(DfltModPath, currentMPATH)
      o:buildBaseMpathA(currentMPATH)
      dbg.print{"Initializing ", DfltModPath, ":", currentMPATH, "\n"}
   else
      dbg.print{"s: ",s,"\n"}
      assert(load(s))()
      local _ModuleTable_ = systemG._ModuleTable_

      if (_ModuleTable_.version == 1) then
         s_loadOrder = o:convertMT(_ModuleTable_)
      else
         for k,v in pairs(_ModuleTable_) do
            o[k] = v
         end
         local icount = 0
         for k in pairs(o.mT) do
            icount = icount + 1
         end
         s_loadOrder = icount
      end
      o._MPATH = concatTbl(o.mpathA,":")
      dbg.print{"(1) o._MPATH: ",o._MPATH,"\n"}
      local baseMPATH = concatTbl(o.baseMpathA,":")
      dbg.print{"(2) o.systemBaseMPATH: \"", o.systemBaseMPATH, "\"\n"}
      dbg.print{"baseMPATH: ", baseMPATH, "\n"}

      if (_ModuleTable_.systemBaseMPATH == nil) then
         dbg.print{"setting self.systemBaseMPATH to baseMPATH\n"}
	 o.systemBaseMPATH = path_regularize(baseMPATH)
         o._MPATH = o.systemBaseMPATH
      end
      -----------------------------------------------------------------
      -- Compare MODULEPATH from environment versus ModuleTable
      if (currentMPATH == nil or currentMPATH == o._MPATH) then
         varTbl[DfltModPath] = Var:new(DfltModPath, baseMPATH)
         dbg.print{"buildBaseMpathA(",baseMPATH,")\n"}
         o:buildBaseMpathA(baseMPATH)
      else
         dbg.print{"currentMPATH:        ",currentMPATH,"\n"}
         dbg.print{"_MPATH:              ",o._MPATH,"\n"}
         dbg.print{"baseMPATH:           ",o.systemBaseMPATH,"\n"}
         if (o._MPATH ~= currentMPATH and not restore) then
            o:resolveMpathChanges(currentMPATH, baseMPATH)
         end
      end
   end
   o.inactive         = {}

   dbg.print{"(2) systemBaseMPATH: ",o.systemBaseMPATH,"\n"}

   dbg.fini("MT:new")
   return o
end

--------------------------------------------------------------------------
-- MT:convertMT() - Translate a version 1 MT into current version.

function M.convertMT(self, v1)
   local active = v1.active
   local a      = active.Loaded
   local sz     = #a
   for i = 1, sz do
      local sn    = a[i]
      local hash  = nil
      if (active.hash and active.hash[i]) then
         hash = active.hash[i]
      end

      local t     = { fn = active.FN[i], modFullName = active.fullModName[i],
                      default = active.default[i], modName = sn,
                      hash = hash,
      }
      self:add(t,"active")
   end

   local aa    = {}
   local total = v1.total
   a           = total.Loaded
   for i = 1, #a do
      local sn = a[i]
      if (not self:have(sn,"active")) then
         local t = { modFullName = total.fullModName[i], modName = sn }
         self:add(t,"inactive")
         aa[#aa+1] = sn
      end
   end

   self.mpathA     = v1.mpathA
   self.baseMpathA = v1.baseMpathA
   self.inactive   = aa

   return sz   -- Return the new loadOrder number.
end

--------------------------------------------------------------------------
-- Get/Set functions for shortTime and rebuild time for cache.

function M.getRebuildTime(self)
   return self.c_rebuildTime
end

function M.getShortTime(self)
   return self.c_shortTime
end

function M.setRebuildTime(self, long, short)
   dbg.start{"MT:setRebuildTime(long: ",long,", short: ",short,")",level=2}
   self.c_rebuildTime = long
   self.c_shortTime   = short
   dbg.fini("MT:setRebuildTime")
end

--------------------------------------------------------------------------
-- setupMPATH(): Build locationTbl and availT based on new MODULEPATH.

local function setupMPATH(self,mpath)
   dbg.start{"MT:setupMPATH(self,mpath: \"",mpath,"\")"}
   self._same = self:sameMPATH(mpath)
   if (not self._same) then
      self:buildMpathA(mpath)
   end
   dbg.fini("MT:setupMPATH")
end

--------------------------------------------------------------------------
-- MT:mt(): Public access to MT function.  For the most part this is a
--          singleton class.  The trouble is that there is a stack of
--          MT on certain occations.  So this member function will construct
--          one, then clone itself.  This way there is an original one for
--          later comparison.

function M.mt(self)
   if (not s_mt) then
      dbg.start{"mt()"}
      s_mt               = new(self, getMT())
      s_mtA[#s_mtA+1]    = s_mt
      dbg.print{"Original s_mtA[",#s_mtA,"]: ",tostring(s_mtA[#s_mtA]),"\n", level=2}
      M.cloneMT(self)   -- Save original MT in stack
      varTbl[ModulePath] = Var:new(ModulePath, getenv(ModulePath))
      setupMPATH(s_mt, varTbl[ModulePath]:expand())
      dbg.print{"s_mt._same: ",s_mt._same, "\n"}
      if (not s_mt._same) then
         s_mt:reloadAllModules()
      end
      dbg.print{"s_mt: ",tostring(s_mt), " s_mtA[",#s_mtA,"]: ",tostring(s_mtA[#s_mtA]),"\n",
                level=2}
      dbg.fini("mt")
   end
   return s_mt
end

--------------------------------------------------------------------------
-- MT:cloneMT(): deepcopy and push on stack

local dcT = {function_immutable = true, metatable_immutable = true}
function M.cloneMT()
   --dbg.start{"MT.cloneMT()"}
   local mt = deepcopy(s_mt, dcT)
   mt:pushMT()
   s_mt = mt
   --dbg.print{"Now using s_mtA[",#s_mtA,"]: ",tostring(s_mt),"\n"}
   --dbg.fini("MT.cloneMT")
end

--------------------------------------------------------------------------
-- MT:pushMT(): push self on stack.

function M.pushMT(self)
   s_mtA[#s_mtA+1] = self
end

--------------------------------------------------------------------------
-- MT:popMT(): Pop the stack and set [[s_mt]] to be the current value.

function M.popMT()
   dbg.start{"MT.popMT()"}
   s_mt = s_mtA[#s_mtA-1]
   dbg.print{"Now using s_mtA[",#s_mtA-1,"]: ",tostring(s_mt),"\n", level=2}
   s_mtA[#s_mtA] = nil    -- mark for garage collection
   dbg.fini("MT.popMT")
end


--------------------------------------------------------------------------
-- MT:origMT(): Return the original MT from bottom of stack.

function M.origMT()
   dbg.start{"MT.origMT()"}
   dbg.print{"Original s_mtA[1]: ",tostring(s_mtA[1]),"\n", level=2}
   dbg.print{"s_mtA[1].shortTime: ",s_mtA[1].shortTime,"\n", level=2}
   dbg.fini("MT.origMT")
   return s_mtA[1]
end


--------------------------------------------------------------------------
-- MT:getMTfromFile(): Read in a user collection of modules and make it
--                     the new value of [[s_mt]].  This routine is probably
--                     too complicated by half.  The idea is that we read
--                     the collection to get the list of modules requested.
--                     We also need the base MODULEPATH as a replacement.
--
--  To complicate things we must check for:
--    a) make sure that the hash values are the same between old and new.
--    b) make sure that the system base path has not changed.  To detect this
--       there are now two base modulepaths.  The system base modulepath is
--       the one when there is no _ModuleTable_ in the environment.  Then there
--       is a second one which contains any module use commands by the user.


function M.getMTfromFile(self,t)
   dbg.start{"mt:getMTfromFile(",t.fn,")"}
   local f              = io.open(t.fn,"r")
   local msg            = t.msg
   local collectionName = t.name
   if (not f) then
      LmodErrorExit()
   end
   local s = f:read("*all")
   f:close()

   if (msg) then
      io.stderr:write("Restoring modules to ",msg,"\n")
   end
   -----------------------------------------------
   -- Initialize MT with file: fn
   -- Save module name in hash table "t"
   -- with Hash Sum as value

   local restore = true
   local l_mt    = new(self, s, restore)
   local mpath   = l_mt._MPATH

   local activeA = l_mt:list("userName","active")

   ---------------------------------------------
   -- If any module specified in the "default" file
   -- is a default then use the short name.  This way
   -- getting the modules from the "getdefault" specified
   -- file will work even when the defaults have changed.
   local t = {}

   for i = 1,#activeA do
      local      sn = activeA[i].sn
      t[sn]         = l_mt:getHash(sn)
      dbg.print{"sn: ",sn,", hash: ", t[sn], "\n"}
   end


   local savedBaseMPATH = concatTbl(l_mt.baseMpathA,":")
   dbg.print{"Saved baseMPATH: ",savedBaseMPATH,"\n"}
   varTbl[ModulePath] = Var:new(ModulePath,mpath)
   dbg.print{"(1) varTbl[ModulePath]:expand(): ",varTbl[ModulePath]:expand(),"\n"}
   local force = true
   Purge(force)
   dbg.print{"(2) varTbl[ModulePath]:expand(): ",mpath,"\n"}

   ------------------------------------------------------------
   -- If the new system has changed report it, fix MODULEPATH by
   --    1) remove the saved basePATH
   --    2) append the new system basePATH
   -- This way the MODULEPATH is correctly updated to the new
   -- baseMPATH
   dbg.print{"self.systemBaseMPATH: ",self.systemBaseMPATH,"\n"}
   dbg.print{"l_mt.systemBaseMPATH: ",l_mt.systemBaseMPATH,"\n"}
   if (self.systemBaseMPATH ~= l_mt.systemBaseMPATH) then
      LmodWarning("The system MODULEPATH has changed: ",
                  "Please rebuild your saved collection.\n")
      dbg.fini("MT:getMTfromFile")
      return false
   end


   ------------------------------------------------------------
   -- Clear MT and load modules from saved modules stored in
   -- "t" from above.
   local sbMP = self.systemBaseMPATH
   dbg.print{"mt (self): ", tostring(self), "\n", level=2}
   s_mt = new(self,nil)
   dbg.print{"(1) s_mt: ", tostring(s_mt), "\n", level=2}
   s_mt:pushMT()

   ------------------------------------------------------------
   -- This is a hack.  The system base MODULEPATH is set when
   -- the very first run of Lmod.  If there is no ModuleTable in the
   -- environment then MODULEPATH is used to set the system base MPATH.
   -- It is detected when a new MT is constructed and the MT is nil.
   -- Well the line above this comment is also constructing a MT where
   -- the module table in the environment value is ignored.  So this
   -- hack is here to make sure that the value of the system Base MPATH
   -- remains what is was.  There should be a better way to do this
   -- but I can't think of one at the moment.
   s_mt.systemBaseMPATH = sbMP


   -----------------------------------------------------------------------
   -- Save the new system base modulepath.
   s_mt:buildBaseMpathA(savedBaseMPATH)
   setupMPATH(s_mt, savedBaseMPATH)
   varTbl[DfltModPath] = Var:new(DfltModPath,savedBaseMPATH)

   
   -----------------------------------------------------------------------
   -- Save the shortTime found from Module Collection file:
   s_mt.c_shortTime = l_mt.c_shortTime

   -----------------------------------------------------------------------
   -- Load all modules: use Mgrload load for all modules

   local MName   = _G.MName
   local mcp_old = mcp
   mcp           = MasterControl.build("mgrload")

   local mA        = {}
   for i = 1, #activeA do
      local entry = activeA[i]
      local name  = entry.name
      mA[#mA+1]   = MName:new("load",name)
   end
   MCP.load(mcp,mA)
   mcp = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}

   -----------------------------------------------------------------------
   -- Now check to see that all requested modules got loaded.
   activeA = s_mt:list("userName","active")
   if (#activeA == 0 ) then
      LmodWarning("You have no modules loaded because the collection \"",
                  collectionName, "\" is empty!\n")
   end
   dbg.print{"#activeA: ",#activeA,"\n"}
   local activeT = {}

   for i = 1,#activeA do
      local entry = activeA[i]
      local sn    = entry.sn
      dbg.print{"activeA: i:",i,", sn: ",sn,", name: ",entry.name,"\n"}
      activeT[sn] = entry
   end

   local aa = {}
   for sn, v in pairs(t) do
      if (not activeT[sn]) then
         dbg.print{"did not find activeT sn: ",sn,"\n"}
         aa[#aa+1] = v.name
         t[sn]     = nil -- do not need to check hash for a non-existant module
      end
   end

   activeA = nil  -- done with activeA
   activeT = nil  -- done with activeT
   if (#aa > 0) then
      LmodWarning("The following modules were not loaded: ",
                  concatTbl(aa," "),"\n\n")
   end

   --------------------------------------------------------------------------
   -- Check that the hash sums match between collection and current values.

   aa = {}
   s_mt:setHashSum()
   for sn, v  in pairs(t) do
      dbg.print{"HASH sn: ",sn, ", t hash: ",v, "s hash: ", s_mt:getHash(sn), "\n"}
      if(v ~= s_mt:getHash(sn)) then
         aa[#aa + 1] = sn
      end
   end


   if (#aa > 0) then
      LmodWarning("The following modules have changed: ", concatTbl(aa,", "),"\n")
      LmodWarning("Please re-create this collection.\n")
      return false
   end


   s_mt:hideHash()

   -----------------------------------------------------------------------
   -- Set environment variable __LMOD_DEFAULT_MODULES_LOADED__ so that
   -- users have a way to know that their default collection was safely
   -- read in.

   if (collectionName == "default") then
      local n = "__LMOD_DEFAULT_MODULES_LOADED__"
      varTbl[n] = Var:new(n,"1")
   end

   dbg.print{"baseMpathA: ",concatTbl(self.baseMpathA,":"),"\n"}
   dbg.fini("MT:getMTfromFile")
   return true
end

--------------------------------------------------------------------------
-- resolveMpathChanges: Handle when MODULEPATH is changed outside of Lmod
function M.resolveMpathChanges(self, currentMPATH, baseMPATH)
   dbg.start{"MT:resolveMpathChanges(currentMPATH, baseMPATH)"}
   local usrMpathA  = path2pathA(currentMPATH)
   local mpathA     = self.mpathA
   local kU         = #usrMpathA
   local kM         = #mpathA
   local mU         = 0
   local mM         = 0

   if (kM > kU) then
      dbg.fini("MT:resolveMpathChanges")
      return
   end

   for i = kM, 1, -1 do
      if (usrMpathA[kU] ~= mpathA[i]) then
         mU = kU
         mM = i
         break
      end
      kU = kU - 1
   end

   dbg.print{"mU: ",mU,", mM: ",mM,"\n"}
   if ( mM ~= 0) then
      local a = {}
      a[#a+1] = "The environment MODULEPATH has been changed in unexpected ways.\n"
      a[#a+1] = "Lmod is unable to use given MODULEPATH. It is using: \n    \""
      a[#a+1] = concatTbl(mpathA,":")
      a[#a+1] = "\".\nPlease use \"module use ...\" to change MODULEPATH instead."

      LmodWarning(concatTbl(a,""))

   else
      local a = {}
      for i = 1,kU do
         a[i] = usrMpathA[i]
      end
      local dmp    = concatTbl(a,":") .. ":" .. baseMPATH
      varTbl[DfltModPath] = Var:new(DfltModPath, dmp)
      varTbl[ModulePath]  = Var:new(ModulePath, currentMPATH)
      self:buildBaseMpathA(dmp)

      dbg.print{"currentMPATH: ",currentMPATH,"\n"}
      dbg.print{"MPATH:        ",concatTbl(self.mpathA,":"),"\n"}
   end
   dbg.fini("MT:resolveMpathChanges")
end



--------------------------------------------------------------------------
-- These routine are used to decide when it is safe to reload modules.
-- The idea is that when there is a change in MODULEPATH, MT:changePATH
-- is called. Every time a module is loaded MT:beginOP() is called.
-- Afterwards MT:endOP() is called.  The routine MT:safeToCheckZombies()
-- returns true when the count is zero and self._changePATH is also true.
-- It then changes self._changePATH to nil so future calls to
-- safeToCheckZombies will be false.


function M.changePATH(self)
   if (not self._changePATH) then
      assert(self._changePATHCount == 0)
      self._changePATHCount = self._changePATHCount + 1
   end
   self._changePATH = true
   --dbg.print{"MT:changePATH: self._changePATH: ",self._changePATH,
   --          " count: ",self._changePATHCount,"\n"}
 end

function M.beginOP(self)
   if (self._changePATH == true) then
      self._changePATHCount = self._changePATHCount + 1
   end
   --dbg.print{"MT:beginOP: self._changePATH: ",self._changePATH, " count: ",self._changePATHCount,"\n"}
end

function M.endOP(self)
   if (self._changePATH == true) then
      self._changePATHCount = max(self._changePATHCount - 1, 0)
   end
   --dbg.print{"MT:endOP: self._changePATH: ",self._changePATH, " count: ",self._changePATHCount,"\n"}
end

function M.zombieState(self)
   return self._changePATHCount == 0 and self._changePATH
end

function M.safeToCheckZombies(self)
   local result = self._changePATHCount == 0 and self._changePATH
   local s      = (result) and "true" or "nil"
   if (self._changePATHCount == 0) then
      self._changePATH = false
   end
   return result
end

--------------------------------------------------------------------------
-- Get/Set functions for family.

s_familyA = false
local function buildFamilyPrefix()
   if (not s_familyA) then
      s_familyA    = {}
      s_familyA[1] = "LMOD_FAMILY_"
      local siteName = hook.apply("SiteName")
      if (siteName) then
         s_familyA[2] = siteName .. "_FAMILY_"
      end
   end
   return s_familyA
end


function M.setfamily(self,familyNm,mName)
   local results = self.family[familyNm]
   self.family[familyNm] = mName
   local familyA = buildFamilyPrefix()
   for i = 1,#familyA do
      local n = familyA[i] .. familyNm:upper()
      MCP:setenv(n, mName)
   end
   return results
end

function M.unsetfamily(self,familyNm)
   local familyA = buildFamilyPrefix()
   for i = 1,#familyA do
      local n = familyA[i] .. familyNm:upper()
      MCP:unsetenv(n, "")
   end
   self.family[familyNm] = nil
end

function M.getfamily(self,familyNm)
   if (familyNm == nil) then
      return self.family
   end
   return self.family[familyNm]
end

--------------------------------------------------------------------------
-- Simple Get/Set functions.

function M.locationTbl(self, key)
   if (not self._locationTbl) then
      self._locationTbl, self._availT = build_locationTbl(self.mpathA)
   end
   if (key == nil) then
      return self._locationTbl
   end
   return self._locationTbl[key]
end

function M.availT(self)
   if (not self._availT) then
      self._locationTbl, self._availT = build_locationTbl(self.mpathA)
   end
   return self._availT
end

function M.sameMPATH(self, mpath)
   return self._MPATH == mpath
end

function M.module_pathA(self)
   return self.mpathA
end

function M.buildMpathA(self, mpath)
   local mpathA = path2pathA(mpath)
   self.mpathA = mpathA
   self._MPATH = concatTbl(mpathA,":")
end

function M.buildBaseMpathA(self, mpath)
   self.baseMpathA = path2pathA(mpath)
end


function M.getBaseMPATH(self)
   return concatTbl(self.baseMpathA,":")
end

function M.reEvalModulePath(self)
   self:buildMpathA(varTbl[ModulePath]:expand())
   self._locationTbl, self._availT = build_locationTbl(self.mpathA)
end

function M.clearLocationAvailT(self)
   self._locationTbl = false
   self._availT      = false
end


function M.reloadAllModules(self)
   dbg.start{"MT:reloadAllModules()"}
   local master = _G.Master:master()
   dbg.print{"after init call to Master:master()\n"}
   local count  = 0
   local ncount = 5

   local changed = false
   local done    = false
   while (not done) do
      dbg.print{"Calling master:reloadAll()\n"}
      local same  = master:reloadAll()
      if (not same) then
         changed = true
      end
      count       = count + 1
      if (count > ncount) then
         dbg.print{"ReLoading more than ", ncount, " times-> exiting.\n"}
         return
      end
      done = self:sameMPATH(varTbl[ModulePath]:expand())
   end

   local safe = master:safeToUpdate()
   if (not safe and changed) then
      LmodError("MODULEPATH has changed: run \"module update\" to repair.\n")
   end
   dbg.fini("MT:reloadAllModules")
   return
end

--------------------------------------------------------------------------
--  MT:add(): Adds a module to MT.

function M.add(self, t, status)
   dbg.start{"MT:add(t,",status,")"}
   dbg.print{"MT:add:  short: ",t.modName,", full: ",t.modFullName,"\n"}
   dbg.print{"MT:add: fn: ",t.fn,", default: ",t.default,"\n"}
   local loadOrder
   if (status == "inactive") then
      loadOrder = -1
   end
   dbg.print{"MT:add: loadOrder: ",loadOrder,"\n"}
   local mT = self.mT
   mT[t.modName] = { fullName  = t.modFullName,
                     short     = t.modName,
                     FN        = t.fn,
                     default   = t.default,
                     status    = status,
                     loadOrder = loadOrder,
                     propT     = {},
   }
   if (t.hash and t.hash ~= 0) then
      mT[t.modName].hash = t.hash
   end
   dbg.fini("MT:add")
end

--------------------------------------------------------------------------
-- MT:list(): Return a array of modules currently in MT.  The list is
--            always sorted in loadOrder.
--
-- There are three kinds of returns for this member function.
--    mt:list("userName",...) returns an object containing an table
--                            which has the short, full, etc.
--    mt:list("both",...) returns the short and full name of
--    mt:list(... , ...) returns a simply array of names.

function M.list(self, kind, status)
   local mT   = self.mT
   local icnt = 0
   local a    = {}
   local b    = {}

   if (kind == "userName") then
      for k,v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            icnt  = icnt + 1
            local nameT = "short"
            if (v.default ~= 1) then
               nameT = "fullName"
            end
            local obj = {sn   = v.short,   full       = v.fullName,
                         name = v[nameT], defaultFlg = v.default }
            a[icnt] = { v.loadOrder, v[nameT], obj }
         end
      end
   elseif (kind == "both") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            icnt  = icnt + 1
            a[icnt] = { v.loadOrder, v.short, v.short}
            if (v.short ~= v.fullName) then
               icnt  = icnt + 1
               a[icnt] = { v.loadOrder, v.fullName, v.fullName}
            end
         end
      end
   else
      if (status == "sticky") then
         for sn, v in pairs(mT) do
            if (self:haveProperty(sn,"lmod","sticky")) then
               icnt = icnt + 1
               a[icnt] = { v.loadOrder, v[kind], v[kind]}
            end
         end
      else
         for k,v in pairs(mT) do
            if ((status == "any" or status == v.status) and
                (v.status ~= "pending")) then
               icnt  = icnt + 1
               a[icnt] = { v.loadOrder, v[kind], v[kind]}
            end
         end
      end
   end

   sort (a, function(x,y)
               if (x[1] == y[1]) then
                  return x[2] < y[2]
               else
                  return x[1] < y[1]
               end
            end)

   for i = 1, icnt do
      b[i] = a[i][3]
   end

   a = nil -- finished w/ a.
   return b
end

--------------------------------------------------------------------------
-- Simple Get/Set functions for entries in MT.

function M.userName(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end

   if (entry.default == 1) then
      return entry.short
   end
   return entry.fullName
end

function M.fileName(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.FN
end

function M.setStatus(self, sn, status)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      entry.status = status
      if (status == "active") then
         s_loadOrder     = s_loadOrder + 1
         entry.loadOrder = s_loadOrder
      end
   end
   dbg.print{"MT:setStatus(",sn,",",status,")\n"}
end

function M.getStatus(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      return entry.status
   end
   return nil
end

function M.exists(self, sn)
   local mT    = self.mT
   return (mT[sn] ~= nil)
end

function M.have(self, sn, status)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return false
   end
   return ((status == "any") or (status == entry.status))
end


function M.hideHash(self)
   local mT   = self.mT
   for k,v in pairs(mT) do
      if (v.status == "active") then
         v.hash    = nil
      end
   end
end

function M.markDefault(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      mT[sn].default = 1
   end
end

function M.default(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return (entry.default ~= 0)
end

function M.usrName(self,sn)
   if (self:default(sn)) then
      return sn
   end
   return self:fullName(sn)
end

function M.setLoadOrder(self)
   local a  = self:list("short","active")
   local mT = self.mT
   local sz = #a

   for i = 1,sz do
      local sn = a[i]
      mT[sn].loadOrder = i
   end
   return sz
end

function M.fullName(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.fullName
end

function M.Version(self, sn)
   local full = self:fullName(sn)
   if (not full) then
      return full
   end

   local i, j = full:find(".*/")
   if (not j) then
      return ""
   end

   return full:sub(j+1,-1)
end

function M.short(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.short
end

function M.getHash(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.hash
end

function M.hideHash(self)
   local mT   = self.mT
   for k,v in pairs(mT) do
      if (v.status == "active") then
         v.hash    = nil
      end
   end
end

function M.markDefault(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      mT[sn].default = 1
   end
end

function M.default(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return (entry.default ~= 0)
end

function M.usrName(self,sn)
   if (self:default(sn)) then
      return sn
   end
   return self:fullName(sn)
end

function M.setLoadOrder(self)
   local a  = self:list("short","active")
   local mT = self.mT
   local sz = #a

   for i = 1,sz do
      local sn = a[i]
      mT[sn].loadOrder = i
   end
   return sz
end

function M.fullName(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.fullName
end

function M.Version(self, sn)
   local full = self:fullName(sn)
   if (not full) then
      return full
   end

   local i, j = full:find(".*/")
   if (not j) then
      return ""
   end

   return full:sub(j+1,-1)
end

function M.short(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.short
end


--------------------------------------------------------------------------
-- MT:setHashSum(): Use [[computeHashSum]] to compute hash for each active
--                  module in MT.

function M.setHashSum(self)
   local mT   = self.mT
   dbg.start{"MT:setHashSum()"}

   local chsA   = { "computeHashSum", "computeHashSum.in.lua", }
   local cmdSum = false
   local found  = false

   for i = 1,2 do
      cmdSum  = pathJoin(cmdDir(),chsA[i])
      if (isFile(cmdSum)) then
         found = true
         break
      end
   end

   if (not found) then
      LmodError("Unable to find computeHashSum.\n")
   end

   local path   = "@path_to_lua@:" .. os.getenv("PATH")
   local luaCmd = findInPath("lua",path)

   if (luaCmd == "") then
      LmodError("Unable to find lua.\n")
   end

   local cmdA = {}
   cmdA[#cmdA+1] = luaCmd
   cmdA[#cmdA+1] = cmdSum
   if (dbg.active()) then
      cmdA[#cmdA+1] = "--indentLevel"
      cmdA[#cmdA+1] = tostring(dbg.indentLevel()+1)
      cmdA[#cmdA+1] = "-D"
   end
   local cmdStart = concatTbl(cmdA," ")

   for k,v in pairs(mT) do
      local a = {}
      if (v.status == "active") then
         a[#a + 1]  = cmdStart
         a[#a + 1]  = "--fullName"
         a[#a + 1]  = v.fullName
         a[#a + 1]  = "--usrName"
         a[#a + 1]  = self:usrName(v.short)
         a[#a + 1]  = "--sn"
         a[#a + 1]  = v.short
         a[#a + 1]  = v.FN
         local cmd  = concatTbl(a," ")
         dbg.print{"cmd: ", cmd,"\n"}
         local s    = capture(cmd)
         v.hash     = s:sub(1,-2)
      end
   end
   dbg.fini("MT:setHashSum")
end


function M.reportKeys(self)
   local mT  = self.mT
   for k,v in pairs(mT) do
      dbg.print{"MT:reportKeys(): Key: ",k, ", status: ",v.status,"\n"}
   end
end


function M.pushInheritFn(self,sn,fn)
   local mT    = self.mT
   local fnI   = mT[sn].fnI or {}
   fnI[#fnI+1] = fn
   mT[sn].fnI  = fnI
end

function M.popInheritFn(self,sn)
   local mT   = self.mT
   local fn   = nil
   local fnI  = mT[sn].fnI
   if (fnI and #fnI > 0) then
      fn = table.remove(fnI)
      if (#fnI == 0) then
         mT[sn].fnI = nil
      end
   end
   return fn
end

function M.remove(self, sn)
   local mT  = self.mT
   mT[sn]    = nil
end

--------------------------------------------------------------------------
-- MT:add_property() add a property to an active module.


function M.add_property(self, sn, name, value)
   dbg.start{"MT:add_property(\"",sn,"\", \"",name,"\", \"",value,"\")"}

   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:add_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end
   local propDisplayT = getPropT()
   local propKindT    = propDisplayT[name]

   if (propKindT == nil) then
      LmodError("MT:add_property(): system property table has no entry for: ", name,
                "\nCheck spelling and case of name.\n")
   end
   local validT = propKindT.validT
   if (validT == nil) then
      LmodError("MT:add_property(): system property table has no validT table for: ", name,
                "\nCheck spelling and case of name.\n")
   end

   local propT        = entry.propT
   propT[name]        = propT[name] or {}
   local t            = propT[name]

   for v in value:split(":") do
      if (validT[v] == nil) then
         LmodError("MT:add_property(): The validT table for ", name," has no entry for: ", value,
                   "\nCheck spelling and case of name.\n")
      end
      t[v] = 1
   end
   entry.propT[name]  = t

   dbg.fini("MT:add_property")
end

--------------------------------------------------------------------------
-- MT:remove_property() remove a property to an active module.

function M.remove_property(self, sn, name, value)
   dbg.start{"MT:remove_property(\"",sn,"\", \"",name,"\", \"",value,"\")"}

   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:remove_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end
   local propDisplayT = getPropT()
   local propKindT    = propDisplayT[name]

   if (propKindT == nil) then
      LmodError("MT:remove_property(): system property table has no entry for: ", name,
                "\nCheck spelling and case of name.\n")
   end
   local validT = propKindT.validT
   if (validT == nil) then
      LmodError("MT:remove_property(): system property table has no validT table for: ", name,
                "\nCheck spelling and case of name.\n")
   end

   local propT        = entry.propT or {}
   local t            = propT[name] or {}

   for v in value:split(":") do
      if (validT[v] == nil) then
         LmodError("MT:add_property(): The validT table for ", name," has no entry for: ", value,
                   "\nCheck spelling and case of name.\n")
      end
      t[v] = nil
   end
   entry.propT       = propT
   entry.propT[name] = t
   dbg.fini("MT:remove_property")
end

--------------------------------------------------------------------------
-- MT:list_property(): What it says.

function M.list_property(self, idx, sn, style, legendT)
   dbg.start{"MT:list_property(\"",sn,"\", \"",style,"\")"}
   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:list_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end

   local resultA = colorizePropA(style, entry.fullName, entry.propT, legendT)

   local cstr    = string.format("%3d)",idx)

   table.insert(resultA, 1, cstr)

   local tLen = resultA[1]:len() + resultA[2]:len() + tostring(resultA[3]):len()
   dbg.fini("MT:list_property")
   return resultA
end

function M.haveProperty(self, sn, propName, propValue)
   local entry = self.mT[sn]
   if (entry == nil or entry.propT == nil or entry.propT[propName] == nil ) then
      return nil
   end
   return entry.propT[propName][propValue]
end

--------------------------------------------------------------------------
-- MT:userLoad(): Mark a module as having been loaded by user request.
--                This is used by MT:reportChanges() to not print. So
--                if a user does this:
--                   $ module swap mvapich2 mvapich2/1.9
--                Lmod will not report that mvapich2 has been reloaded.

function M.userLoad(self, sn,usrName)
   dbg.start{"MT:userLoad(",sn,")"}
   local loadT  = self._loadT
   loadT[sn]    = usrName
   dbg.fini("MT:userLoad")
end

--------------------------------------------------------------------------
-- MT:reportChanges(): Compare the original MT with the current one.
--                     Report any modules that have become inactive or
--                     active.  Or report that a module has swapped or a
--                     version has changed.

function M.reportChanges(self)
   local master = systemG.Master:master()

   dbg.start{"MT:reportChanges()"}

   if (not master.shell:isActive()) then
      dbg.print{"Expansion is inactive\n"}
      dbg.fini("MT:reportChanges")
      return
   end

   local origMT    = M.origMT()
   local mT        = origMT.mT
   local inactiveA = {}
   local activeA   = {}
   local changedA  = {}
   local reloadA   = {}
   local loadT     = self._loadT

   for sn, v in pairsByKeys(mT) do
      if (self:have(sn,"inactive") and v.status == "active") then
         local name = v.fullName
         if (v.default == 1) then
            name = v.short
         end
         inactiveA[#inactiveA+1] = name
      elseif (self:have(sn,"active")) then
         if ( v.status == "inactive") then
            activeA[#activeA+1] = self:fullName(sn)
         elseif (self:fileName(sn) ~= v.FN) then
            if (self:fullName(sn) == v.fullName) then
               reloadA[#reloadA+1] = v.fullName
            else
               local usrName = loadT[sn]
               local fullN   = self:fullName(sn)
               if (usrName ~= fullN) then
                  changedA[#changedA+1] = v.fullName .. " => " .. self:fullName(sn)
               end
            end
         end
      end
   end

   local entries = false

   if (#inactiveA > 0) then
      entries = true
      columnList(io.stderr,"\nInactive Modules:\n", inactiveA)
   end
   if (#activeA > 0) then
      entries = true
      columnList(io.stderr,"\nActivating Modules:\n", activeA)
   end
   if (#reloadA > 0) then
      entries = true
      columnList(io.stderr,"\nDue to MODULEPATH changes the following "
                    .."have been reloaded:\n",
                 reloadA)
   end
   if (#changedA > 0) then
      entries = true
      columnList(io.stderr,"\nThe following have been reloaded with a version change:\n", changedA)
   end

   if (entries) then
      io.stderr:write("\n")
   end

   dbg.fini("MT:reportChanges")
end

--------------------------------------------------------------------------
-- MT:serializeTbl(): A wrapper for serializeTbl and all the white space
--                   removed.

function M.serializeTbl(self, state)
   dbg.print{"self: ",tostring(self),"\n", level=2}
   dbg.print{"s_mt: ",tostring(s_mt),"\n", level=2}

   s_mt.activeSize = self:setLoadOrder()

   if (not state) then
      local s = _G.serializeTbl{ indent=false, name=s_mt:name(), value=s_mt}
      return s:gsub("%s+","")
   else
      return _G.serializeTbl{ indent=true, name=s_mt:name(), value=s_mt}
   end
end

function M.addStickyA(self, sn)
   local a        = self._stickyA
   local entry    = self.mT[sn]
   local default  = entry.default
   local userName = self:userName(sn)
   local fullName = (default == 1 ) and sn or entry.fullName

   a[#a+1] = {sn = sn, FN = entry.FN, fullName = fullName,
              userName = userName }
end

function M.getStickyA(self)
   return self._stickyA
end

return M
