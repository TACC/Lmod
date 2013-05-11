--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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

require("strict")
_ModuleTable_      = ""
local DfltModPath  = DfltModPath
local ModulePath   = ModulePath
local concatTbl    = table.concat
local getenv       = os.getenv
local ignoreT      = { ['.'] =1, ['..'] = 1, CVS=1, ['.git'] = 1, ['.svn']=1,
                       ['.hg']= 1, ['.bzr'] = 1,}
local max          = math.max
local sort         = table.sort
local systemG      = _G
local varTbl       = varTbl

require("string_split")
require("fileOps")
require("serializeTbl")
require("parseVersion")
require("deepcopy")

local Var          = require('Var')
local lfs          = require('lfs')
local pathJoin     = pathJoin
local Dbg          = require('Dbg')
local ColumnTable  = require('ColumnTable')
local posix        = require("posix")
local deepcopy     = table.deepcopy

--module("MT")
local M = {}

function M.name(self)
   return '_ModuleTable_'
end

s_loadOrder = 0
s_mt = false

s_mtA = {}

local function locationTblDir(mpath, path, prefix, locationT, availT)
   local dbg  = Dbg:dbg()
   --dbg.start("MT:locationTblDir(mpath=",mpath,", path=",path,", prefix=",prefix,",locationT)")

   local attr = lfs.attributes(path)
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory" or not posix.access(path,"x")) then
      --dbg.fini("MT:locationTblDir")
      return
   end

   local mnameT = {}
   local dirA   = {}

   for file in lfs.dir(path) do
      if (file:sub(1,1) ~= "." and file ~= "CVS" and file:sub(-1,-1) ~= "~") then
         local f = pathJoin(path,file)
         attr    = lfs.attributes(f) or {}
         local readable = posix.access(f,"r")
         if (not readable or not attr) then
            -- do nothing for non-readable non-existant files
         elseif (attr.mode == 'file' and file ~= "default") then
            local mname = pathJoin(prefix, file):gsub("%.lua","")
            mnameT[mname] = {file=f, mpath = mpath}
         elseif (attr.mode == "directory") then
            dirA[#dirA + 1] = { fullName = f, mname = pathJoin(prefix, file) } 
         end
      end
   end
   if (#dirA > 0 or prefix == '') then
      for k,v in pairs(mnameT) do
         local a      = locationT[k] or {}
         a[#a+1]      = v
         locationT[k] = a
         --dbg.print("Adding Meta module: ",k," file: ", v.file,"\n")
         availT[k]    = {}
      end
      for i = 1, #dirA do
         locationTblDir(mpath, dirA[i].fullName,  dirA[i].mname, locationT, availT)
      end
   else
      local a           = locationT[prefix] or {}
      --dbg.print("adding Regular module: file: ",path, " mpath: ", prefix, "\n")
      a[#a+1]           = { file = path, mpath = mpath}
      locationT[prefix] = a
      availT[prefix]    = {}
      local vA          = {}
      for full, v in pairs(mnameT) do
         local version = full:gsub(".*/","")
         local parseV  = concatTbl(parseVersion(version), ".")
         vA[#vA+1]     = {parseV, version, v.file}
      end
      sort(vA, function(a,b) return a[1] < b[1] end )
      local a = {}
      for i = 1, #vA do
         a[#a+1] = {version = vA[i][2], file = vA[i][3]}
      end
      --dbg.print("Setting availT[",prefix,"]: with ",#a, " entries\n")
      availT[prefix] = a
   end
   --dbg.fini("MT:locationTblDir")
end

local function buildLocWmoduleT(mpath, moduleT, mpathT, lT, availT)
   local dbg       = Dbg:dbg()
   dbg.start("MT:buildLocWmoduleT(mpath, moduleT, mpathA, lT, availT)")
   dbg.print("mpath: ", mpath,"\n")
   
   local availEntryT = availT[mpath]

   for f, vv in pairs(moduleT) do
      
      local defaultModule = false
      local sn            = vv.name
      local a             = lT[sn] or {}
      if (a[mpath] == nil) then
         a[mpath] = { file = pathJoin(mpath,sn), mpath = mpath }
      end
      lT[sn]   = a
      
      a = availEntryT[sn] or {}

      local version   = extractVersion(vv.full, sn)

      if (version) then
         local parseV = concatTbl(parseVersion(version), ".")
         a[parseV]  = { version = version, file = f, parseV = parseV}
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


local function buildAllLocWmoduleT(moduleT, mpathA, locationT, availT)
   local dbg       = Dbg:dbg()
   dbg.start("MT:buildAllLocWmoduleT(moduleT, mpathA, locationT, availT)")

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

   for mpath in pairs(mpathT) do
      local mpmT = moduleT[mpath]
      if (mpmT) then
         buildLocWmoduleT(mpath, mpmT, mpathT, lT, availT)
      end
   end

   for mpath, vvv in pairs(availT) do
      for sn, vv in pairs(vvv) do
         local aa = {}
         for parseV, v in pairsByKeys(vv) do
            aa[#aa + 1] = v
         end
         availT[mpath][sn] = aa
      end
   end

   for sn, vv in pairs(lT) do

      local a = {}
      for mpath, v in pairs(vv) do
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
   dbg.fini("MT:buildAllLocWmoduleT")
end


local function build_locationTbl(mpathA)

   local dbg       = Dbg:dbg()
   dbg.start("MT:build_locationTbl(mpathA)")
   local locationT = {}
   local availT    = {}

   local fast      = true
   local cache     = _G.Cache:cache()
   local moduleT   = cache:build(fast)
   
   dbg.print("moduleT: ", not (not moduleT),"\n")

   if (moduleT) then
      buildAllLocWmoduleT(moduleT, mpathA, locationT, availT)
   else
      for i = 1, #mpathA do
         local mpath = mpathA[i]
         availT[mpath] = {}
         locationTblDir(mpath, mpath, "", locationT, availT[mpath])
      end
   end

   
   if (dbg.active()) then
      dbg.print("availT: \n")
      for mpath, vv in pairs(availT) do
         dbg.print("  mpath: ", mpath,":\n")

         for sn , v in pairsByKeys(vv) do

            dbg.print("    ",sn,":")
            for i = 1, #v do
               io.stderr:write(" ",v[i].version,",")
            end
            io.stderr:write("\n")
         end
      end
      dbg.print("locationT: \n")
      for sn, vv in pairs(locationT) do
         dbg.print("  sn: ", sn,":\n")
         for i = 1, #vv do
            dbg.print("    ",vv[i].file,"\n")
         end
      end
   end
   dbg.fini("MT:build_locationTbl")
   return locationT, availT
end


local function columnList(stream, msg, a)
   local t = {}
   table.sort(a)
   for i = 1, #a do
      t[#t + 1] = '  ' .. i .. ') ' .. tostring(a[i])
   end
   stream:write(msg)
   local ct = ColumnTable:new{tbl=t}
   stream:write(ct:build_tbl(),"\n")
end


local function new(self, s)
   local dbg  = Dbg:dbg()
   dbg.start("MT:new()")
   local o            = {}

   o.c_rebuildTime    = false
   o.c_shortTime      = false
   o.mT               = {}
   o.version          = 2
   o.family           = {}
   o.mpathA           = {}
   o.baseMpathA       = {}
   o._same            = true
   o._MPATH           = ""
   o._locationTbl     = {}
   o._availT          = {}
   o._loadT           = {}

   o._changePATH      = false
   o._changePATHCount = 0

   setmetatable(o,self)
   self.__index = self

   local active, total

   local v             = getenv(ModulePath)
   o.systemBaseMPATH   = path_regularize(v)

   dbg.print("systemBaseMPATH: \"", v, "\"\n")
   if (not s) then
      local v             = getenv(ModulePath)
      o.systemBaseMPATH   = path_regularize(v)
      dbg.print("setting systemBaseMPATH: ", v, "\n")
      varTbl[DfltModPath] = Var:new(DfltModPath, v)
      o:buildBaseMpathA(v)
      dbg.print("Initializing ", DfltModPath, ":", v, "\n")
   else
      assert(loadstring(s))()
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
      local baseMpath = concatTbl(o.baseMpathA,":")
      dbg.print("baseMpath: ", baseMpath, "\n")

      if (_ModuleTable_.systemBaseMPATH == nil) then
         dbg.print("setting self.systemBaseMPATH to baseMpath\n")
	 o.systemBaseMPATH = path_regularize(baseMpath)
      end

      varTbl[DfltModPath] = Var:new(DfltModPath, baseMpath)
   end
   o.inactive         = {}

   dbg.print("(2) systemBaseMPATH: ",o.systemBaseMPATH,"\n")

   dbg.fini("MT:new")
   return o
end

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
                      mType   = active.mType[i], hash = hash,
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
   


function M.getRebuildTime(self)
   return self.c_rebuildTime
end

function M.getShortTime(self)
   return self.c_shortTime
end

function M.setRebuildTime(self, long, short)
   local dbg = Dbg:dbg()
   dbg.start("MT:setRebuildTime(long: ",long,", short: ",short,")")
   self.c_rebuildTime = long
   self.c_shortTime   = short
   dbg.fini("MT:setRebuildTime")
end


local function setupMPATH(self,mpath)
   local dbg = Dbg:dbg()
   dbg.start("MT:setupMPATH(self,mpath: \"",mpath,"\")")
   self._same = self:sameMPATH(mpath)
   if (not self._same) then
      self:buildMpathA(mpath)
   end
   self._locationTbl, self._availT = build_locationTbl(self.mpathA)
   dbg.fini("MT:setupMPATH")
end

local dcT = {function_immutable = true, metatable_immutable = true}

function M.mt(self)
   if (not s_mt) then
      local dbg  = Dbg:dbg()
      dbg.start("mt()")
      local shell        = systemG.Master:master().shell
      s_mt               = new(self, shell:getMT())
      s_mtA[#s_mtA+1]    = s_mt
      dbg.print("Original s_mtA[",#s_mtA,"]: ",tostring(s_mtA[#s_mtA]),"\n")
      M.cloneMT(self)   -- Save original MT in stack
      varTbl[ModulePath] = Var:new(ModulePath)
      setupMPATH(s_mt, varTbl[ModulePath]:expand())
      if (not s_mt._same) then
         s_mt:reloadAllModules()
      end
      dbg.print("s_mt: ",tostring(s_mt), " s_mtA[",#s_mtA,"]: ",tostring(s_mtA[#s_mtA]),"\n")
      dbg.fini("mt")
   end
   return s_mt
end


function M.cloneMT()
   local dbg = Dbg:dbg()
   dbg.start("MT.cloneMT()")
   local mt = deepcopy(s_mt, dcT)
   dbg.print("s_mt: ", tostring(s_mt)," mt: ", tostring(mt),"\n")
   s_mtA[#s_mtA+1] = mt
   s_mt = mt
   dbg.print("Now using s_mtA[",#s_mtA,"]: ",tostring(s_mt),"\n")
   dbg.fini("MT.cloneMT")
end

function M.popMT()
   local dbg = Dbg:dbg()
   dbg.start("MT.popMT()")
   s_mt = s_mtA[#s_mtA-1]
   dbg.print("Now using s_mtA[",#s_mtA-1,"]: ",tostring(s_mt),"\n")

   s_mtA[#s_mtA] = nil    -- mark for garage collection

   dbg.fini("MT.popMT")
end

function M.origMT()
   local dbg = Dbg:dbg()
   dbg.start("MT.origMT()")
   dbg.print("Original s_mtA[1]: ",tostring(s_mtA[1]),"\n")
   dbg.fini("MT.origMT")
   return s_mtA[1]
end


function M.getMTfromFile(self,fn, msg)
   local dbg  = Dbg:dbg()
   dbg.start("mt:getMTfromFile(",fn,")")
   local f = io.open(fn,"r")
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

   local l_mt   = new(self, s)
   local mpath  = l_mt._MPATH
   local t      = {}
   local a      = {}  -- list of "worker-bee" modules
   local m      = {}  -- list of "manager"    modules

   local activeA = l_mt:list("userName","active")

   ---------------------------------------------
   -- If any module specified in the "default" file
   -- is a default then use the short name.  This way
   -- getting the modules from the "getdefault" specified
   -- file will work even when the defaults have changed.

   for i = 1,#activeA do
      local entry = activeA[i]
      local sn    = entry.sn
      local name  = entry.name
      t[sn]       = {name = name, hash = l_mt:getHash(sn)}
      local mType = l_mt:mType(sn)
      if (mType == "w") then
         a[#a+1] = name
      else
         m[#m+1] = name
      end
      dbg.print("name: ",name," isDefault: ",entry.defaultFlg,
                " mType: ", mType, "\n")
   end
   
   local savedBaseMPATH = concatTbl(l_mt.baseMpathA,":")
   dbg.print("Saved baseMPATH: ",savedBaseMPATH,"\n")
   varTbl[ModulePath] = Var:new(ModulePath,mpath)
   dbg.print("(1) varTbl[ModulePath]:expand(): ",varTbl[ModulePath]:expand(),"\n")
   Purge()
   dbg.print("(2) varTbl[ModulePath]:expand(): ",mpath,"\n")

   ------------------------------------------------------------
   -- If the new system has changed report it, fix MODULEPATH by
   --    1) remove the saved basePATH
   --    2) append the new system basePATH
   -- This way the MODULEPATH is correctly updated to the new
   -- baseMPATH
   dbg.print("self.systemBaseMPATH: ",self.systemBaseMPATH,"\n")
   dbg.print("l_mt.systemBaseMPATH: ",l_mt.systemBaseMPATH,"\n")
   if (self.systemBaseMPATH ~= l_mt.systemBaseMPATH) then
      LmodWarning("The system MODULEPATH has changed: ",
                  "Please rebuild your saved collection\n")
      dbg.fini("MT:getMTfromFile")
      return false
   end


   ------------------------------------------------------------
   -- Clear MT and load modules from saved modules stored in
   -- "t" from above.
   local sbMP = self.systemBaseMPATH
   s_mt = new(self,nil)

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


   posix.setenv(self:name(),"",true)
   setupMPATH(s_mt, mpath)
   s_mt:buildBaseMpathA(savedBaseMPATH)
   varTbl[DfltModPath] = Var:new(DfltModPath,savedBaseMPATH)

   dbg.print("(3) varTbl[ModulePath]:expand(): ",varTbl[ModulePath]:expand(),"\n")
   local mcp_old = mcp
   mcp           = MCP
   mcp:load(unpack(a))
   mcp           = mcp_old

   local master = systemG.Master:master()

   master.fakeload(unpack(m))

   activeA = s_mt:list("userName","active")

   dbg.print("#activeA: ",#activeA,"\n")
   local activeT = {}

   for i = 1,#activeA do
      local entry = activeA[i]
      local sn    = entry.sn
      dbg.print("activeA: i:",i,", sn: ",sn,", name: ",entry.name,"\n")
      activeT[sn] = entry
   end

   local aa = {}
   for sn, v in pairs(t) do
      if (not activeT[sn]) then
         dbg.print("did not find activeT sn: ",sn,"\n")
         aa[#aa+1] = v.name
         t[sn]     = nil -- do not need to check hash for a non-existant module
      end
   end

   activeA = nil  -- done with activeA
   activeT = nil  -- done with activeT
   if (#aa > 0) then
      LmodWarning("The following modules were not loaded: ", concatTbl(aa," "),"\n\n")
   end

   aa = {}
   s_mt:setHashSum()
   for sn, v  in pairs(t) do
      if(v.hash ~= s_mt:getHash(sn)) then
         aa[#aa + 1] = v.name
      end
   end

   
   if (#aa > 0) then
      LmodWarning("The following modules have changed: ", concatTbl(aa,", "),"\n")
      LmodWarning("Please re-create this collection\n")
      return false
   end


   s_mt:hideHash()

   local n = "__LMOD_DEFAULT_MODULES_LOADED__"
   varTbl[n] = Var:new(n)
   varTbl[n]:set("1")
   dbg.print("baseMpathA: ",concatTbl(self.baseMpathA,":"),"\n")

   dbg.fini("MT:getMTfromFile")
   return true
end
   
function M.changePATH(self)
   if (not self._changePATH) then
      assert(self._changePATHCount == 0)
      self._changePATHCount = self._changePATHCount + 1
   end
   self._changePATH = true
end

function M.beginOP(self)
   if (self._changePATH == true) then
      self._changePATHCount = self._changePATHCount + 1
   end
end

function M.endOP(self)
   if (self._changePATH == true) then
      self._changePATHCount = max(self._changePATHCount - 1, 0)
   end
end

function M.safeToCheckZombies(self)
   local result = self._changePATHCount == 0 and self._changePATH
   local s      = "nil"
   if (result) then  s = "true" end
   if (self._changePATHCount == 0) then
      self._changePATH = false
   end
   return result
end


function M.setfamily(self,familyNm,mName)
   local results = self.family[familyNm]
   self.family[familyNm] = mName
   local n = "LMOD_FAMILY_" .. familyNm:upper()
   MCP:setenv(n, mName)
   n = "TACC_FAMILY_" .. familyNm:upper()
   MCP:setenv(n, mName)
   return results
end

function M.unsetfamily(self,familyNm)
   local n = "LMOD_FAMILY_" .. familyNm:upper()
   MCP:unsetenv(n, "")
   n = "TACC_FAMILY_" .. familyNm:upper()
   MCP:unsetenv(n, "")
   self.family[familyNm] = nil
end

function M.getfamily(self,familyNm)
   if (familyNm == nil) then
      return self.family
   end
   return self.family[familyNm]
end


function M.locationTbl(self, key)
   return self._locationTbl[key]
end

function M.availT(self)
   return self._availT
end

function M.sameMPATH(self, mpath)
   return self._MPATH == mpath
end

function M.module_pathA(self)
   return self.mpathA
end

local function path2pathA(mpath)
   local a = {}
   if (mpath) then 
      for path in mpath:split(':') do
         a[#a+1] = path_regularize(path)
      end
   end
   return a
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

function M.reloadAllModules(self)
   local master = systemG.Master:master()
   local count  = 0
   local ncount = 5

   local changed = false
   local done    = false
   while (not done) do
      local same  = master:reloadAll()
      if (not same) then
         changed = true
      end
      count       = count + 1
      if (count > ncount) then
         LmodError("ReLoading more than ", ncount, " times-> exiting\n")
      end
      done = self:sameMPATH(varTbl[ModulePath]:expand())
   end

   local safe = master:safeToUpdate()
   if (not safe and changed) then
      LmodError("MODULEPATH has changed: run \"module update\" to repair\n")
   end
   return not changed
end

function M.add(self, t, status)
   local dbg   = Dbg:dbg()
   dbg.start("MT:add(t,",status,")")
   dbg.print("MT:add:  short: ",t.modName,", full: ",t.modFullName,"\n")
   dbg.print("MT:add: fn: ",t.fn,", default: ",t.default,"\n")
   local loadOrder
   if (status == "inactive") then
      loadOrder = -1
   else
      s_loadOrder = s_loadOrder + 1
      loadOrder   = s_loadOrder
   end
   dbg.print("MT:add: loadOrder: ",loadOrder,"\n")
   local mT = self.mT
   mT[t.modName] = { fullName  = t.modFullName,
                     short     = t.modName,
                     FN        = t.fn,
                     default   = t.default,
                     mType     = t.mType,
                     status    = status,
                     loadOrder = loadOrder,
                     propT     = {},
   }
   if (t.hash and t.hash ~= 0) then
      mT[t.modName].hash = t.hash
   end
   dbg.fini("MT:add")
end

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
   end
   local dbg = Dbg:dbg()
   dbg.print("MT:setStatus(",sn,",",status,")\n")
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

function M.list(self, kind, status)
   local dbg  = Dbg:dbg()
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
            dbg.print("MT:list: v.short: ", v.short, ", full: ",v.fullName,"\n")
            local obj = {sn   = v.short,   full       = v.fullName,
                         name = v[nameT], defaultFlg = v.default }
            a[icnt] = { v.loadOrder, obj }
         end
      end
   else
      for k,v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            icnt  = icnt + 1
            a[icnt] = { v.loadOrder, v[kind]}
         end
      end
   end

   table.sort (a, function(x,y) return x[1] < y[1] end)

   for i = 1, icnt do
      b[i] = a[i][2]
   end

   a = nil -- finished w/ a.
   return b
end

function M.setHashSum(self)
   local mT   = self.mT
   local dbg  = Dbg:dbg()
   dbg.start("MT:setHashSum()")

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
      LmodError("Unable to find computeHashSum\n")
   end

   local path = "@path_to_lua@:" .. os.getenv("PATH")

   
   local luaCmd = findInPath("lua",path)

   if (luaCmd == "") then
      LmodError("Unable to find lua\n")
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
         a[#a + 1]  = "--sn"
         a[#a + 1]  = v.short
         a[#a + 1]  = v.FN
         local cmd  = concatTbl(a," ")
         dbg.print("cmd: ", cmd,"\n")
         local s    = capture(cmd)
         v.hash     = s:sub(1,-2)
      end
   end
   dbg.fini("MT:setHashSum")
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
   local dbg   = Dbg:dbg()
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

function M.mType(self, sn)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.mType
end

function M.set_mType(self, sn, value)
   local mT    = self.mT
   local entry = mT[sn]
   if (entry ~= nil) then
      mT[sn].mType = value
   end
end

function M.reportKeys(self)
   local dbg = Dbg:dbg()
   local mT  = self.mT
   for k,v in pairs(mT) do
      dbg.print("MT:reportKeys(): Key: ",k, ", status: ",v.status,"\n")
   end
end


function M.remove(self, sn)
   local dbg = Dbg:dbg()
   local mT  = self.mT
   mT[sn]    = nil
end

function M.safeToSave(self)
   local mT = self.mT
   local a  = {}
   for k,v in pairs(mT) do
      if (v.status == "active" and v.mType == "mw") then
         a[#a+1] = k
      end
   end
   return a
end



function M.add_property(self, sn, name, value)
   local dbg = Dbg:dbg()
   dbg.start("MT:add_property(\"",sn,"\", \"",name,"\", \"",value,"\")")
   
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
                "\nCheck spelling and case of name\n")
   end
   local validT = propKindT.validT
   if (validT == nil) then
      LmodError("MT:add_property(): system property table has no validT table for: ", name,
                "\nCheck spelling and case of name\n")
   end

   local propT        = entry.propT
   propT[name]        = propT[name] or {}
   local t            = propT[name]

   for v in value:split(":") do
      if (validT[v] == nil) then
         LmodError("MT:add_property(): The validT table for ", name," has no entry for: ", value,
                   "\nCheck spelling and case of name\n")
      end
      t[v] = 1
   end
   entry.propT[name]  = t

   dbg.fini("MT:add_property")
end

function M.remove_property(self, sn, name, value)
   local dbg = Dbg:dbg()
   dbg.start("MT:remove_property(\"",sn,"\", \"",name,"\", \"",value,"\")")
   
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
                "\nCheck spelling and case of name\n")
   end
   local validT = propKindT.validT
   if (validT == nil) then
      LmodError("MT:remove_property(): system property table has no validT table for: ", name,
                "\nCheck spelling and case of name\n")
   end

   local propT        = entry.propT or {}
   local t            = propT[name] or {}

   for v in value:split(":") do
      if (validT[v] == nil) then
         LmodError("MT:add_property(): The validT table for ", name," has no entry for: ", value,
                   "\nCheck spelling and case of name\n")
      end
      t[v] = nil
   end
   entry.propT       = propT
   entry.propT[name] = t
   dbg.fini("MT:remove_property")
end


function M.list_property(self, idx, sn, style, legendT)
   local dbg    = Dbg:dbg()
   dbg.start("MT:list_property(\"",sn,"\", \"",style,"\")")
   local dbg = Dbg:dbg()
   local mT    = self.mT
   local entry = mT[sn]

   if (entry == nil) then
      LmodError("MT:list_property(): Did not find module entry: ",sn,
                ". This should not happen!\n")
   end

   local resultA      = colorizePropA(style, entry.fullName, entry.propT, legendT)

   table.insert(resultA, 1, "  "  .. tostring(idx) ..")")

   local tLen = resultA[1]:len() + resultA[2]:len() + tostring(resultA[3]):len()
   dbg.print("result: \"",resultA[1],"\", \"",resultA[2],
             "\", \"",resultA[3],"\"\n")

   dbg.print("tlen: ",tLen," lenA: ",resultA[1]:len()," ",resultA[2]:len(),
             " ",tostring(resultA[3]):len(),"\n")

   dbg.fini("MT:list_property")
   return resultA
end

function M.userLoad(self, sn,usrName)
   local dbg    = Dbg:dbg()
   dbg.start("MT:userLoad(",sn,")")
   local loadT  = self._loadT
   loadT[sn]    = usrName
   dbg.fini("MT:userLoad")
end
function M.reportChanges(self)
   local dbg    = Dbg:dbg()
   local master = systemG.Master:master()

   dbg.start("MT:reportChanges()")

   if (not master.shell:isActive()) then
      dbg.print("Expansion is inactive\n")
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

   for sn, v in pairs(mT) do
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
                  changedA[#changedA+1] = v.fullName .. " => " .. fullN
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
      columnList(io.stderr,"\nDue to MODULEPATH changes the following have been reloaded:\n",
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


function M.serializeTbl(self)
   local dbg = Dbg:dbg()
   
   s_mt.activeSize = s_mt:setLoadOrder()

   local s = _G.serializeTbl{ indent=false, name=self.name(), value=s_mt}
   return s:gsub("[ \n]","")
end

return M
