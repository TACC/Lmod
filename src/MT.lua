--------------------------------------------------------------------------
-- This class controls the ModuleTable.  The ModuleTable is how Lmod
-- communicates what modules are loaded or inactive and so on between
-- module commands.
--
-- @classmod MT

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

_ModuleTable_      = ""
local DfltModPath  = DfltModPath
local ModulePath   = ModulePath
local concatTbl    = table.concat
local getenv       = os.getenv
local max          = math.max
local sort         = table.sort
local systemG      = _G
local unpack       = (_VERSION == "Lua 5.1") and unpack or table.unpack

require("string_utils")
require("fileOps")
require("serializeTbl")
require("parseVersion")
require("deepcopy")
require("utils")

local ReadLmodRC   = require("ReadLmodRC")
local Var          = require('Var')
local lfs          = require("lfs")
local dbg          = require('Dbg'):dbg()
local ColumnTable  = require('ColumnTable')
local hook         = require("Hook")
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
-- This local function walks a single directory to find
-- all the modulefiles in that directory.  This function
-- is used when moduleT is not available.  The naming
-- rule is implemented here:
--   (1) If a file is a member of a path in MODULEPATH
--       then it is a meta-module.
--   (2) If a file is a sub-directory of MODULEPATH, then
--       and there are no subdirectories (excluding
--       '.' and '..' of course), then these files are
--       version files and the names are the directory
--       (or directories) between the path in MODULEPATH
--       and here.
--   (3) If a file is in a directory with subdirectories
--       then that file is a meta-module.
--
-- Meta-modules are modulefiles that are not versioned.
-- They typically load other modules do not have to.

local function buildAvailT(mpath, path, prefix, availT)

   dbg.start{"buildAvailT(mpath: ",mpath,", path: ", path,",\"", prefix,"\", availT)"}
   local mnameT     = {}
   local dirA       = {}
   local defaultFn  = walk_directory_for_mf(mpath, path, prefix, dirA, mnameT)

   dbg.print{"defaultFn: ",defaultFn,", path: ",path,"\n"}

   if (#dirA > 0 or prefix == '') then
      --------------------------------------------------------------------------
      -- If prefix is '' then this directory in directly under MODULEPATH so
      -- any files are meta-modules.  Also if there are files when there are
      -- directories then these files are also meta-modules.
      dbg.print{"#dirA: ",#dirA,", n: ",dirA.n,"\n"}

      -- Copy any meta-modules into the array availT[k][0].
      for k,v in pairs(mnameT) do
         --if (not v.version) then
            dbg.print{"Meta Module: ",k,"\n"}
            availT[k]        = {}
            availT[k][0]     = v
            availT[k].total  = 0
            availT[k].hidden = 0
         --end
      end


      -- For any directories found recursively call buildAvailT to process.
      for i = 1, #dirA do
         buildAvailT(mpath, dirA[i].fullName,  dirA[i].mname, availT)
      end
   elseif (next(mnameT) ~= nil) then
      ------------------------------------------------------------------------
      -- If here, then there are no directories and this is not a top level
      -- directory. So any files found here are versions for the module.
      -- The "name" of the module is the "prefix".

      availT[prefix]    = {}
      local vA          = {}

      ------------------------------------------------------------------------
      -- Sort the files by parseVersion order and store them in "availT[prefix]".
      for full, v in pairs(mnameT) do
         local version = v.version
         local parseV  = parseVersion(version)
         vA[#vA+1]     = {parseV, version, v.fn}
      end
      sort(vA, function(a,b) return a[1] < b[1] end )
      local a = {}
      local total  = #vA
      local hidden = 0
      for i = 1, total do
         local version = vA[i][2]
         a[i] = {version = version, fn = vA[i][3], parseV=vA[i][1]}
         if (version:sub(1,1) == ".") then hidden = hidden + 1 end
      end
      a.total  = total
      a.hidden = hidden
      availT[prefix] = a

      dbg.print{"availT[",prefix,"].total: ",a.total,"\n"}
      if (defaultFn) then
         local d, v = splitFileName(defaultFn)
         v          = "/" .. v
         if (v == "/default") then
            dbg.print{"Before defaultFn: ",defaultFn,"\n"}
            defaultFn = walk_link(defaultFn)
            dbg.print{"After defaultFn: ",defaultFn,"\n"}
         else
            v            = versionFile(v, prefix, defaultFn, true)
            if (not v) then
               dbg.fini("buildAvailT")
               return
            else
               local f   = pathJoin(d,v)
               dbg.print{"return from versionFile: v: ",v,", f:",f,"\n"}
               if (isFile(f)) then
                  defaultFn = f
               elseif (isFile(f .. ".lua")) then
                  defaultFn = f .. ".lua"
               else
                  dbg.fini("buildAvailT")
                  return
               end
            end
         end
         local num = #vA
         availT[prefix].default    = {fn = defaultFn, kind="marked", num = num}
      end
   end
   dbg.fini("buildAvailT")
end



--------------------------------------------------------------------------
-- This local function walks a single directory in
-- moduleT.  This routine fills in availT[mpath} and
-- the local copy of the locationT "lT".
local function buildLocWmoduleT(mpath, moduleT, mpathT, availT)
   dbg.start{"MT:buildLocWmoduleT(mpath, moduleT, mpathA, availT)"}
   dbg.print{"mpath: ", mpath,"\n"}
   local Pairs       = dbg.active() and pairsByKeys or pairs
   local availEntryT = availT[mpath]

   for f, vv in Pairs(moduleT) do

      --------------------------------------------------------------------
      --

      local defaultModule = false
      local sn            = vv.name
      local a             = availEntryT[sn] or {}

      local version   = extractVersion(vv.full, sn)

      if (version) then
         local parseV = parseVersion(version)
         a[parseV]    = { version = version, fn = f, parseV = parseV,
                          markedDefault = vv.markedDefault}
      else
         a[0]         = { version = 0, fn = f, markedDefault = false,
                          parseV = "z"}
      end
      availEntryT[sn] = a

      for k, v in pairs(vv.children) do
         if (mpathT[k]) then
            buildLocWmoduleT(k, vv.children[k], mpathT, availT)
         end
      end
   end
   dbg.fini("MT:buildLocWmoduleT")
end

--------------------------------------------------------------------------
-- This routine walks moduleT for all directories
-- stored there. Once all the directories have been
-- traversed by [[buildLocWmoduleT]], [[availT]] is
-- rebuilt to have the entries in parseVersion order
-- and locationT is sorted as well.
--
--    availT[mpath][sn] = {
--                          {version=..., fn=..., parseV=...,
--                           markedDefault=T/F},
--                        }
--
-- When sn is a meta module then
--
--    availT[mpath][sn][0] = {version=..., fn=..., parseV=...,
--                           markedDefault=T/F},
--
local function buildAllLocWmoduleT(moduleT, mpathA, availT, adding, pathEntry)
   dbg.start{"MT:buildAllLocWmoduleT(moduleT, mpathA, availT, adding: ",
             adding,", pathEntry: ",pathEntry,")"}

   -----------------------------------------------------------------------
   -- Initialize [[mpathT]] and [[availT]] for directories in [[mpathA]]
   -- that exist.


   local Pairs  = dbg.active() and pairsByKeys or pairs
   local mpathT = {}
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
         buildLocWmoduleT(mpath, mpmT, mpathT, availT)
      end
   end

   -----------------------------------------------------------------------
   -- Rebuild [[availT]] to have the versions in parseVersion order.

   for mpath, vvv in Pairs(availT) do
      for sn, vv in Pairs(vvv) do
         local aa = {}
         local defaultT = false
         dbg.print{"sn: ",sn,"\n"}
         for parseV, v in pairsByKeys(vv) do
            dbg.print{"  v.version: ", v.version, ", parseV: ",parseV,"\n"}
            if (parseV == 0) then
               aa[0] = v
            else
               aa[#aa + 1] = v
            end
            if (v.markedDefault) then
               defaultT = {kind="marked", fn = v.fn}
            end
         end
         availT[mpath][sn] = aa
         if (defaultT) then
            availT[mpath][sn].default = defaultT
         end
      end
   end

   dbg.fini("MT:buildAllLocWmoduleT")
end


--------------------------------------------------------------------------
-- Generate a columeTable with a title.
local function columnList(stream, msg, a)
   local cwidth = masterTbl().rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()
   local t      = {}
   sort(a)
   for i = 1, #a do
      local cstr = string.format("%3d) ",i)
      t[#t + 1] = cstr .. tostring(a[i])
   end
   stream:write(msg)
   local ct = ColumnTable:new{tbl=t, width=cwidth}
   stream:write(ct:build_tbl(),"\n")
end

local function mt_version()
   return 2
end

------------------------------------------------------------------------
-- local ctor for MT.  It uses [[s]] to be the initial value.
local function new(self, s, restoreFn)
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
   if (currentMPATH) then
      currentMPATH     = concatTbl(path2pathA(currentMPATH),':')
   end

   o.systemBaseMPATH   = path_regularize(currentMPATH)

   dbg.print{"systemBaseMPATH:       \"", currentMPATH, "\"\n"}
   dbg.print{"(1) o.systemBaseMPATH: \"", o.systemBaseMPATH, "\"\n"}
   if (not s) then
      dbg.print{"setting systemBaseMPATH: ", currentMPATH, "\n"}
      varTbl[DfltModPath] = Var:new(DfltModPath, currentMPATH)
      o:buildBaseMpathA(currentMPATH)
      dbg.print{"Initializing ", DfltModPath, ":", currentMPATH, "\n"}
   else
      systemG._ModuleTable_ = false
      local func, msg = load(s)
      local status
      if (func) then
         status, msg = pcall(func)
      else
         status = false
      end

      local _ModuleTable_ = systemG._ModuleTable_

      if (not status or type(_ModuleTable_) ~= "table" ) then
         if (restoreFn) then
            LmodError("The module collection file is corrupt. Please remove: ",
                      restoreFn,"\n")
         else
            LmodError("The module table stored in the environment is corrupt.\n",
                      "please execute the command \" clearMT\" and reload your modules.\n")
         end
      end


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
         if (o._MPATH ~= currentMPATH and not restoreFn) then
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
-- Build *locationT* either by using *moduleT* if it exists or use
-- *buildAvailT* to walk the directories.
--    locationT[sn] = {
--                     default = {fn=, num=,
--                                kind=[last,marked] }
--                     {mpath=..., file=..., versionT = {}},
--                     {mpath=..., file=..., versionT = {}},
--                    }
-- Where versionT is
--     versionT[version] = fn
--
-- @param self An MT object
-- @param mpathA
-- @param adding
-- @param pathEntry
-- @return The locationT table.
-- @return The availT table.
function M._build_locationTbl(self, mpathA, adding, pathEntry)

   dbg.start{"MT:_build_locationTbl(mpathA, adding: ", adding,
             ", pathEntry: \"",pathEntry,"\")"}

   if (varTbl[ModulePath] == nil or varTbl[ModulePath]:expand() == "") then
      dbg.print{"MODULEPATH is undefined\n"}
      dbg.fini("MT:_build_locationTbl")
      return {}, {}
   end

   local Pairs        = dbg.active() and pairsByKeys or pairs
   local locationT    = {}
   local availT       = {}
   local mustWalkDirs = true
   if (type (self._availT) == "table") then
      if (adding == false and pathEntry) then
         availT = self._availT
         if (availT[pathEntry]) then
            mustWalkDirs      = false
            availT[pathEntry] = nil
            dbg.print{"Fast removal of directory: ",pathEntry,"\n"}
         end
      end
   end

   if (mustWalkDirs) then
      local fast       = true
      dbg.print{"LMOD_CACHED_LOADS: ",LMOD_CACHED_LOADS,"\n"}
      local cache      = _G.Cache:cache{buildCache = LMOD_CACHED_LOADS ~= "no"}
      local moduleT    = cache:build(fast)

      dbg.print{"moduleT: ", not (not moduleT),"\n"}

      if (moduleT) then
         buildAllLocWmoduleT(moduleT, mpathA, availT, adding, pathEntry)
      else
         availT = self._availT or {}
         for i = 1, #mpathA do
            local mpath = mpathA[i]
            if ( availT[mpath] == nil) then
               availT[mpath] = {}
               buildAvailT(mpath, mpath, "", availT[mpath])
            end
         end
      end
   end

   --------------------------------------------------------------------------
   -- Use availT to build locationT

   for i = 1, #mpathA do
      local defaultEntry = false
      local defaultFn    = false
      local defaultKind  = false
      local parseV       = false
      local numVersions  = false
      local mpath        = mpathA[i]
      local vv           = availT[mpath] or {}
      for sn, v in pairs(vv) do
         local a         = locationT[sn]
         local total     = #v
         local hidden    = 0
         local versionT  = {}

         if (total == 0) then
            versionT[0] = v[0].fn
         else
            for j = 1,total do
               local version = v[j].version
               versionT[version] = v[j].fn
               if (version:sub(1,1) == ".") then
                  hidden = hidden + 1
               end
            end
         end
         v.total  = total
         v.hidden = hidden

         if (a) then
            defaultEntry = a.default
            defaultKind  = defaultEntry.kind
            parseV       = defaultEntry.parseV
            defaultFn    = defaultEntry.fn
            numVersions  = defaultEntry.numVersions
         else
            a            = {}
            defaultEntry = {parseV = " ", kind = "unknown", fn = false, numVersions = 0}
            defaultKind  = "unknown"
            defaultFn    = false
            parseV       = " "
            numVersions  = 0
         end
         local value = {mpath = mpath, file = pathJoin(mpath,sn), versionT = versionT}

         local changed = false

         if (defaultKind ~= "marked") then
            if (v.default) then
               defaultFn   = v.default.fn
               defaultKind = "marked"
               changed     = true
               numVersions = numVersions + total
            end
         end
         if (defaultKind ~= "marked") then
            local entry  = v[total]
            local pv     = entry.parseV
            local firstC = "x"
            numVersions  = numVersions + total - hidden

            if (type(entry.version) == "string") then
               firstC = entry.version:sub(1,1)
            end

            if ( (not pv) or (not parseV) or (not firstC)) then
               dbg.print{"pv: ", pv, ", parseV: ",parseV,", firstC: ",firstC,"\n"}
               dbg.print{"mpath:   ",mpath,"\n"}
               dbg.print{"sn:      ",sn,"\n"}
               dbg.print{"entry.v: ", entry.version,"\n"}
            end
            if ((total == 0 or pv > parseV) and  firstC ~= ".") then
               defaultKind = "last"
               parseV      = pv
               defaultFn   = entry.fn
               changed     = true
            end
         end
         if (changed) then
            local _, j            = defaultFn:find(mpath,1, true)
            defaultEntry.fullName = defaultFn:sub(j+2):gsub("%.lua$","")
            defaultEntry.kind     = defaultKind
            defaultEntry.parseV   = parseV or " "
            defaultEntry.fn       = defaultFn
         end
         defaultEntry.numVersions = numVersions
         defaultEntry.num         = max(numVersions, #a+1)
         --dbg.print{"sn: ",sn,", numVersions: ",numVersions,", #a+1: ",#a+1," ,dfltFn: ",defaultFn,"\n"}

         a[#a+1]               = value
         locationT[sn]         = a
         locationT[sn].default = defaultEntry

      end
   end

   if (dbg.active()) then
      dbg.print{"availT: \n"}
      for mpath, vv in Pairs(availT) do
         dbg.print{"  mpath: ", mpath,":\n"}

         for sn , v in Pairs(vv) do
            dbg.print{"    ",sn,"(t: ",v.total,", h: ",v.hidden,"):"}
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
            dbg.print{"    file: ",vv[i].file,":"}
            for version in Pairs(vv[i].versionT) do
               io.stderr:write(" ",version)
            end
            io.stderr:write("\n")
         end
         if (vv.default) then
            dbg.print{"    ",vv.default.kind," Default: ",vv.default.fn,"\n"}
         end
      end
   end
   dbg.fini("MT:_build_locationTbl")
   return locationT, availT
end

--------------------------------------------------------------------------
-- Translate a version 1 MT into current version.
-- @param self An MT object.
-- @param v1 A version 1 MT object.
-- @return A new version of MT object.
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
-- Return the rebuild time.
-- @param self An MT object.
function M.getRebuildTime(self)
   return self.c_rebuildTime
end

--------------------------------------------------------------------------
-- Return the shortTime time.
-- @param self An MT object.
function M.getShortTime(self)
   return self.c_shortTime
end

--------------------------------------------------------------------------
-- Record the long and short time.
-- @param self An MT object.
-- @param long The long time before rebuilting user cache.
-- @param short The short time before rebuilting user cache.
function M.setRebuildTime(self, long, short)
   dbg.start{"MT:setRebuildTime(long: ",long,", short: ",short,")",level=2}
   self.c_rebuildTime = long
   self.c_shortTime   = short
   dbg.fini("MT:setRebuildTime")
end

--------------------------------------------------------------------------
-- Build locationTbl and availT based on new MODULEPATH.
-- @param self An MT object.
-- @param mpath the MODULEPATH.
local function setupMPATH(self,mpath)
   dbg.start{"MT:setupMPATH(self,mpath: \"",mpath,"\")"}
   self._same = self:sameMPATH(mpath)
   if (not self._same) then
      self:buildMpathA(mpath)
   end
   dbg.fini("MT:setupMPATH")
end

--------------------------------------------------------------------------
-- Public access to MT function.  For the most part this is a
-- singleton class.  The trouble is that there is a stack of
-- MT on certain occations.  So this member function will construct
-- one, then clone itself.  This way there is an original one for
-- later comparison.
-- @param self An MT object
-- @return An MT object.
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


local dcT = {function_immutable = true, metatable_immutable = true}
--------------------------------------------------------------------------
-- deepcopy and push on stack
function M.cloneMT()
   --dbg.start{"MT.cloneMT()"}
   local mt = deepcopy(s_mt, dcT)
   mt:pushMT()
   s_mt = mt
   --dbg.print{"Now using s_mtA[",#s_mtA,"]: ",tostring(s_mt),"\n"}
   --dbg.fini("MT.cloneMT")
end

--------------------------------------------------------------------------
-- push self on stack.
-- @param self An MT object.
function M.pushMT(self)
   s_mtA[#s_mtA+1] = self
end

--------------------------------------------------------------------------
-- Pop the stack and set *s\_mt* to be the current value.
function M.popMT()
   dbg.start{"MT.popMT()"}
   s_mt = s_mtA[#s_mtA-1]
   dbg.print{"Now using s_mtA[",#s_mtA-1,"]: ",tostring(s_mt),"\n", level=2}
   s_mtA[#s_mtA] = nil    -- mark for garage collection
   dbg.fini("MT.popMT")
end


--------------------------------------------------------------------------
-- Return the original MT from bottom of stack.
function M.origMT()
   dbg.start{"MT.origMT()"}
   dbg.print{"Original s_mtA[1]: ",tostring(s_mtA[1]),"\n", level=2}
   dbg.print{"s_mtA[1].shortTime: ",s_mtA[1].shortTime,"\n", level=2}
   dbg.fini("MT.origMT")
   return s_mtA[1]
end


--------------------------------------------------------------------------
-- Read in a user collection of modules and make it
-- the new value of [[s_mt]].  This routine is probably
-- too complicated by half.  The idea is that we read
-- the collection to get the list of modules requested.
-- We also need the base MODULEPATH as a replacement.
--
-- To complicate things we must check for:
--    1.  make sure that the hash values are the same between old and new.
--    2.  make sure that the system base path has not changed.  To detect this
--        there are now two base modulepaths.  The system base modulepath is
--        the one when there is no _ModuleTable_ in the environment.  Then there
--        is a second one which contains any module use commands by the user.
-- @param self An MT object
-- @param t A table containing the collection filename and the collection name.
-- @return True or false.
function M.getMTfromFile(self,tt)
   dbg.start{"mt:getMTfromFile(",tt.fn,")"}
   local f              = io.open(tt.fn,"r")
   local msg            = tt.msg
   local collectionName = tt.name
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
   -- Save module name in hash table "tt"
   -- with Hash Sum as value

   local restoreFn = tt.fn
   dbg.print{"s: \"",s,"\"\n"}
   local l_mt      = new(self, s, restoreFn)
   local mpath     = l_mt._MPATH

   local activeA = l_mt:list("userName","active")

   ---------------------------------------------
   -- If any module specified in the "default" file
   -- is a default then use the short name.  This way
   -- getting the modules from the "getdefault" specified
   -- file will work even when the defaults have changed.
   local t = {}

   for i = 1,#activeA do
      local sn = activeA[i].sn
      t[sn]    = l_mt:getHash(sn)
      dbg.print{"sn: ",sn,", hash: ", t[sn], "\n"}
   end


   local savedBaseMPATH = concatTbl(l_mt.baseMpathA,":")
   dbg.print{"Saved baseMPATH: ",savedBaseMPATH,"\n"}
   varTbl[ModulePath] = Var:new(ModulePath,savedBaseMPATH)
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
      if (collectionName ~= "default") then
         LmodErrorExit()
      end
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
   mcp           = MasterControl.build("mgrload","load")


   -----------------------------------------------
   -- Normally we load the user name which means
   -- that defaults will be followed.  However
   -- some sites/users wish to use the fullname
   -- and not follow defaults.
   local knd = (LMOD_PIN_VERSIONS == "no") and "name" or "full"
   local mA  = {}

   for i = 1, #activeA do
      local name = activeA[i][knd]
      mA[#mA+1]  = MName:new("load",name)
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
   for sn, v  in pairsByKeys(t) do
      dbg.print{"HASH sn: ",sn, ", t hash: ",v, "s hash: ", s_mt:getHash(sn), "\n"}
      if(v ~= s_mt:getHash(sn)) then
         aa[#aa + 1] = sn
      end
   end

   if (#aa > 0) then
      LmodWarning("One or more modules in your ",collectionName,
                  " collection have changed: \"", concatTbl(aa,"\", \""),"\".")
      LmodMessage("To see the contents of this collection do:")
      LmodMessage("  $ module describe ",collectionName)
      LmodMessage("To rebuild the collection, load the modules you wish then do:")
      LmodMessage("  $ module save ",collectionName)
      LmodMessage("If you no longer want this module collection do:")
      LmodMessage("  rm ~/.lmod.d/",collectionName,"\n")
      LmodMessage("For more information execute 'module help' or " ..
                  "see http://lmod.readthedocs.org/\n")
      LmodMessage("No change in modules loaded\n\n")
      if (collectionName ~= "default") then
         LmodErrorExit()
      end
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
-- Handle when MODULEPATH is changed outside of Lmod
-- @param self An MT object.
-- @param currentMPATH Current MODULEPATH
-- @param baseMPATH original MODULEPATH
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
      a[#a+1] = "Lmod is unable to use given MODULEPATH. It is using:\n\n\""
      a[#a+1] = concatTbl(mpathA,":")
      a[#a+1] = "\".\n\nPlease use \"module use ...\" to change MODULEPATH instead."

      local ss = concatTbl(a,"")


      LmodWarning(ss)

   else
      local a = {}
      for i = 1,kU do
         a[i] = usrMpathA[i]
      end
      local dmp = (kU == 0) and baseMPATH or concatTbl(a,":") .. ":" .. baseMPATH
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
-- @param self An MT object
function M.changePATH(self)
   if (not self._changePATH) then
      assert(self._changePATHCount == 0)
      self._changePATHCount = self._changePATHCount + 1
   end
   self._changePATH = true
   --dbg.print{"MT:changePATH: self._changePATH: ",self._changePATH,
   --          " count: ",self._changePATHCount,"\n"}
 end

--------------------------------------------------------------------------
-- Begin operation.  Used in conjunction with *MT:changePATH()*
-- @param self An MT object
function M.beginOP(self)
   if (self._changePATH == true) then
      self._changePATHCount = self._changePATHCount + 1
   end
   --dbg.print{"MT:beginOP: self._changePATH: ",self._changePATH, " count: ",self._changePATHCount,"\n"}
end

--------------------------------------------------------------------------
-- End operation.  Used in conjunction with *MT:changePATH()*
-- @param self An MT object
function M.endOP(self)
   if (self._changePATH == true) then
      self._changePATHCount = max(self._changePATHCount - 1, 0)
   end
   --dbg.print{"MT:endOP: self._changePATH: ",self._changePATH, " count: ",self._changePATHCount,"\n"}
end

--------------------------------------------------------------------------
-- Return if in zombie state.
-- @param self An MT object
function M.zombieState(self)
   return self._changePATHCount == 0 and self._changePATH
end

--------------------------------------------------------------------------
-- Report if clear of zombies.
-- @param self An MT object
function M.safeToCheckZombies(self)
   local result = self._changePATHCount == 0 and self._changePATH
   if (self._changePATHCount == 0) then
      self._changePATH = false
   end
   return result
end

s_familyA = false
--------------------------------------------------------------------------
-- Build the name of the *family* env. variable.
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


--------------------------------------------------------------------------
-- Set the family
-- @param self An MT object
-- @param familyNm
-- @param nName
function M.setfamily(self,familyNm,mName)
   local results = self.family[familyNm]
   self.family[familyNm] = mName
   local familyA = buildFamilyPrefix()
   for i = 1,#familyA do
      local n = familyA[i] .. familyNm:upper()
      MCP:setenv(n, mName)
      MCP:setenv(n .. "_VERSION", myModuleVersion())
   end
   return results
end

--------------------------------------------------------------------------
-- Unset the family
-- @param self An MT object
-- @param familyNm
function M.unsetfamily(self,familyNm)
   local familyA = buildFamilyPrefix()
   for i = 1,#familyA do
      local n = familyA[i] .. familyNm:upper()
      MCP:unsetenv(n, "")
      MCP:unsetenv(n .. "_VERSION", "")
   end
   self.family[familyNm] = nil
end

--------------------------------------------------------------------------
-- Get the family
-- @param self An MT object
-- @param familyNm
function M.getfamily(self,familyNm)
   if (familyNm == nil) then
      return self.family
   end
   return self.family[familyNm]
end

--------------------------------------------------------------------------
-- Return the locations for a particular key or the whole location table
-- for a nil key.
-- @param self An MT object
-- @param key
-- @return for a nil key return the whole location table, otherwise return the
-- the location for the specified key
function M.locationTbl(self, key)
   if (not self._locationTbl) then
      self._locationTbl, self._availT = self:_build_locationTbl(self.mpathA)
      dbg.print{"set self._availT\n"}
   end
   if (key == nil) then
      return self._locationTbl
   end
   if (not self._locationTbl[key]) then
      return self._locationTbl[key], nil
   end
   return self._locationTbl[key], self._locationTbl[key].default
end

--------------------------------------------------------------------------
-- Return the *availT* table.
-- @param self An MT object
function M.availT(self)
   if (not self._availT) then
      self._locationTbl, self._availT = self:_build_locationTbl(self.mpathA)
      dbg.print{"set self._availT\n"}
   end
   return self._availT
end

--------------------------------------------------------------------------
-- Is *mpath* the same as the internal value.
-- @param self An MT object
-- @param mpath A MODULEPATH string value.
-- @return True if the same at the internal value.
function M.sameMPATH(self, mpath)
   return self._MPATH == mpath
end

--------------------------------------------------------------------------
-- Return an array of path elements from the internal value.
-- @param self An MT object
-- @return an array of path elements from the internal value.
function M.module_pathA(self)
   return self.mpathA
end

--------------------------------------------------------------------------
-- Build internal array and string from passed in mpath.
-- @param self An MT object
-- @param mpath string of the MODULEPATH
function M.buildMpathA(self, mpath)
   local mpathA = path2pathA(mpath)
   self.mpathA = mpathA
   self._MPATH = concatTbl(mpathA,":")
end

--------------------------------------------------------------------------
-- Build internal array for base MODULEPATH.
-- @param self An MT object
-- @param mpath string of the MODULEPATH
function M.buildBaseMpathA(self, mpath)
   self.baseMpathA = path2pathA(mpath)
end

--------------------------------------------------------------------------
-- Return the string version of base MODULEPATH
-- @param self An MT object
function M.getBaseMPATH(self)
   return concatTbl(self.baseMpathA,":")
end

--------------------------------------------------------------------------
-- Force a re-evaluation of the internal copies of *locationT* and *availT*.
-- @param self An MT object
-- @param adding
-- @param pathEntry
function M.reEvalModulePath(self, adding, pathEntry)
   dbg.start{"MT:reEvalModulePath(adding: ",adding,", pathEntry: ",pathEntry,")"}
   self:buildMpathA(varTbl[ModulePath]:expand())
   self._locationTbl, self._availT = self:_build_locationTbl(self.mpathA, adding, pathEntry)
   dbg.print{"set self._availT\n"}
   dbg.fini("MT:reEvalModulePath")
end

--------------------------------------------------------------------------
-- Clear the internal copies of *locationT* and *availT*
-- @param self An MT object
function M.clearLocationAvailT(self)
   dbg.print{"Calling MT:clearLocationAvailT(self)\n"}
   self._locationTbl = false
   self._availT      = false
end


--------------------------------------------------------------------------
-- Reload all modules.
-- @param self An MT object
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
-- Adds a module to MT.
-- @param self An MT object
-- @param t
-- @param status
function M.add(self, t, status)
   dbg.start{"MT:add(t,",status,")"}
   dbg.print{"MT:add:  short: ",t.modName,", full: ",t.modFullName,"\n"}
   dbg.print{"MT:add: fn: ",t.fn,", default: ",t.default,"\n"}
   local mT = self.mT
   mT[t.modName] = { fullName  = t.modFullName,
                     short     = t.modName,
                     FN        = t.fn,
                     default   = t.default,
                     status    = status,
                     loadOrder = -1,
                     propT     = {},
   }
   if (t.hash and t.hash ~= 0) then
      mT[t.modName].hash = t.hash
   end
   dbg.fini("MT:add")
end

--------------------------------------------------------------------------
-- Return a array of modules currently in MT.  The list is
-- always sorted in loadOrder.
--
-- There are three kinds of returns for this member function.
--    mt:list("userName",...) returns an object containing an table
--                            which has the short, full, etc.
--    mt:list("fullName",...) returns the list modules with their
--                            fullNames.
--    mt:list("both",...) returns the short and full name of
--    mt:list(... , ...) returns a simply array of names.
-- @param self An MT object
-- @param kind
-- @param status
-- @return An array of modules matching the kind and status
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
            local obj = {sn   = v.short,   full      = v.fullName,
                         name = v[nameT], defaultFlg = v.default,
                         fn   = v.FN }
            a[icnt] = { v.loadOrder, v[nameT], obj }
         end
      end
   elseif (kind == "fullName") then
      for k,v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            icnt  = icnt + 1
            local nameT = "fullName"
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
-- Return the name of the module that user requested.  It will be short
-- name if the user requested the default.  Otherwise, it will be the
-- full name.
-- @param self An MT object
-- @param sn the short module name
-- @return the name of the module.
function M.usrName(self, sn)
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

--------------------------------------------------------------------------
-- Return the filename associated with the *sn*.
-- @param self An MT object
-- @param sn the short module name
-- @return The filename.
function M.fileName(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.FN
end

--------------------------------------------------------------------------
-- Set the status.  Typically either *pending* or *active*.
-- @param self An MT object.
-- @param sn the short module name.
-- @param status The status.
-- @return The filename.
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

--------------------------------------------------------------------------
-- Get the current status.  Typically either *pending* or *active*.
-- @param self An MT object.
-- @param sn the short module name.
-- @param status The status.
-- @return The status
function M.getStatus(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      return entry.status
   end
   return nil
end

--------------------------------------------------------------------------
-- Does the *sn* exist?
-- @param self An MT object.
-- @param sn the short module name.
-- @return existance.
function M.exists(self, sn)
   local mT    = self.mT
   return (mT[sn] ~= nil)
end

--------------------------------------------------------------------------
-- Does the *sn* exist with a particular *status*.
-- @param self An MT object.
-- @param sn the short module name.
-- @param status The status.
-- @return existance.
function M.have(self, sn, status)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return false
   end
   return ((status == "any") or (status == entry.status))
end


--------------------------------------------------------------------------
-- Remove the computed hash values from each entry in the module table.
-- @param self An MT object.
function M.hideHash(self)
   local mT   = self.mT
   for k,v in pairs(mT) do
      if (v.status == "active") then
         v.hash    = nil
      end
   end
end

--------------------------------------------------------------------------
-- Mark *sn* entry as being default.
-- @param self An MT object.
-- @param sn the short module name.
function M.markDefault(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      mT[sn].default = 1
   end
end

--------------------------------------------------------------------------
-- Mark *sn* entry as being default.
-- @param self An MT object.
-- @param sn the short module name.
function M.default(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return (entry.default ~= 0)
end

--------------------------------------------------------------------------
-- Set the load order by using MT:list()
-- @param self An MT object.
-- @return the number of entries in *mT*
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

--------------------------------------------------------------------------
-- Return the full name of the module including version if it exists.
-- @param self An MT object.
-- @param sn The short name
-- @return the full name.
function M.fullName(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.fullName
end

--------------------------------------------------------------------------
-- Return the version of a module or "" if it doesn't.
-- @param self An MT object.
-- @param sn The short name
-- @return the version.
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

--------------------------------------------------------------------------
-- Clear the hash value.
-- @param self An MT object.
-- @param sn The short name.
-- @return The hash value.
function M.hideHash(self)
   local mT   = self.mT
   for k,v in pairs(mT) do
      if (v.status == "active") then
         v.hash    = nil
      end
   end
end

--------------------------------------------------------------------------
-- Get the hash value for the entry.
-- @param self An MT object.
-- @param sn The short name.
-- @return The hash value.
function M.getHash(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.hash
end

--------------------------------------------------------------------------
-- Use *computeHashSum* to compute hash for each active module in MT.
-- @param self An MT object.
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

   if (luaCmd == nil) then
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


--------------------------------------------------------------------------
-- A debug routine to report the module short name and status.
-- @param self An MT object.
function M.reportKeys(self)
   local mT  = self.mT
   for k,v in pairs(mT) do
      dbg.print{"MT:reportKeys(): Key: ",k, ", status: ",v.status,"\n"}
   end
end


--------------------------------------------------------------------------
-- Push the inheritance file into a stack.
-- @param self An MT object.
-- @param sn the short name.
-- @param fn the file name.
function M.pushInheritFn(self,sn,fn)
   local mT    = self.mT
   local fnI   = mT[sn].fnI or {}
   fnI[#fnI+1] = fn
   mT[sn].fnI  = fnI
end

--------------------------------------------------------------------------
-- Pop the inheritance file from the stack.
-- @param self An MT object.
-- @param sn the short name.
-- @param fn the file name.
-- @return the filename on top of the stack.
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

--------------------------------------------------------------------------
-- Clear the entry for *sn* from the module table.
-- @param self An MT object.
-- @param sn The short name.
function M.remove(self, sn)
   local mT  = self.mT
   mT[sn]    = nil
end

--------------------------------------------------------------------------
-- add a property to an active module.
-- @param self An MT object.
-- @param sn The short name
-- @param name the property name
-- @param value the value for the property name.
function M.add_property(self, sn, name, value)
   dbg.start{"MT:add_property(\"",sn,"\", \"",name,"\", \"",value,"\")"}

   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:add_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end
   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()
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
-- Remove a property to an active module.
-- @param self An MT object.
-- @param sn The short name
-- @param name the property name
-- @param value the value for the property name.
function M.remove_property(self, sn, name, value)
   dbg.start{"MT:remove_property(\"",sn,"\", \"",name,"\", \"",value,"\")"}

   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:remove_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end
   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()
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
-- List the property
-- @param self An MT object.
-- @param idx The index in the list.
-- @param sn The short name
-- @param style How to colorize.
-- @param legendT The legend table.
function M.list_property(self, idx, sn, style, legendT)
   dbg.start{"MT:list_property(\"",sn,"\", \"",style,"\")"}
   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:list_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end

   local resultA = colorizePropA(style, entry.fullName, entry.propT, legendT)
   if (resultA[2]) then
      resultA[2] = "(" .. resultA[2] .. ")"
   end

   local cstr    = string.format("%3d)",idx)

   table.insert(resultA, 1, cstr)
   dbg.fini("MT:list_property")
   return resultA
end

--------------------------------------------------------------------------
-- Return the value of this property or nil.
-- @param self An MT object.
-- @param sn The short name.
-- @param propName The property name.
-- @param propValue The property value.
function M.haveProperty(self, sn, propName, propValue)
   local entry = self.mT[sn]
   if (entry == nil or entry.propT == nil or entry.propT[propName] == nil ) then
      return nil
   end
   return entry.propT[propName][propValue]
end

--------------------------------------------------------------------------
-- Mark a module as having been loaded by user request.
-- This is used by MT:reportChanges() to not print. So
-- if a user does this:
--      $ module swap mvapich2 mvapich2/1.9
-- Lmod will not report that mvapich2 has been reloaded.
-- @param self An MT object.
-- @param sn The short name.
-- @param usrName The name the user specified for the module.
function M.userLoad(self, sn, usrName)
   dbg.start{"MT:userLoad(",sn,")"}
   local loadT  = self._loadT
   loadT[sn]    = usrName
   dbg.fini("MT:userLoad")
end

--------------------------------------------------------------------------
-- Compare the original MT with the current one.
-- Report any modules that have become inactive or
-- active.  Or report that a module has swapped or a
-- version has changed.
-- @param self An MT object.
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
-- Report the contents of the collection. Return an empty array if the
-- collection is not found.
function M.reportContents(self, t)
   dbg.start{"mt:reportContents(",t.fn,")"}
   local f = io.open(t.fn,"r")
   local a       = {}
   if (not f) then
      dbg.fini("mt:reportContents")
      return a
   end
   local s       = f:read("*all")
   local l_mt    = new(self, s, t.fn)
   local kind    = (LMOD_PIN_VERSIONS == "no") and "userName" or "fullName"
   local activeA = l_mt:list(kind, "active")
   for i = 1, #activeA do
      a[#a+1] = activeA[i].name
   end

   f:close()
   dbg.fini("mt:reportContents")
   return a
end

--------------------------------------------------------------------------
-- A wrapper for serializeTbl.
-- @param self An MT object.
-- @param state If true then return serialized table indented, otherwise
-- extra spaces removed.
-- @return The serialized table.
function M.serializeTbl(self, state)
   dbg.print{"self: ",tostring(self),"\n", level=2}
   dbg.print{"s_mt: ",tostring(s_mt),"\n", level=2}

   s_mt.activeSize = self:setLoadOrder()

   if (state) then
      return _G.serializeTbl{ indent=true, name=s_mt:name(), value=s_mt}
   else
      local s = _G.serializeTbl{ indent=false, name=s_mt:name(), value=s_mt}
      return s:gsub("%s+","")
   end
end

--------------------------------------------------------------------------
-- Mark a module as sticky.
-- @param self An MT object.
-- @param sn the short name
function M.addStickyA(self, sn)
   local a        = self._stickyA
   local entry    = self.mT[sn]
   local default  = entry.default
   local userName = self:usrName(sn)
   local fullName = (default == 1 ) and sn or entry.fullName

   a[#a+1] = {sn = sn, FN = entry.FN, fullName = fullName,
              userName = userName }
end

--------------------------------------------------------------------------
-- Return the array of sticky modules.
-- @param self An MT object.
function M.getStickyA(self)
   return self._stickyA
end

return M
