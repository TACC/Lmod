require("strict")
_ModuleTable_      = ""
local DfltModPath  = DfltModPath
local Error        = LmodError
local Load         = Load
local Master       = Master
local ModulePath   = ModulePath
local Purge        = Purge
local Set          = Set
local UnLoad       = UnLoad
local Unset        = Unset
local assert       = assert
local concatTbl    = table.concat
local expert       = expert
local getenv       = os.getenv
local ignoreT      = { ['.'] =1, ['..'] = 1, CVS=1, ['.git'] = 1, ['.svn']=1,
                       ['.hg']= 1, ['.bzr'] = 1,}
local io           = io
local ipairs       = ipairs
local loadstring   = loadstring
local max          = math.max
local next         = next
local os           = os
local pairs        = pairs
local prtErr       = prtErr
local setmetatable = setmetatable
local string       = string
local systemG      = _G
local tostring     = tostring
local type         = type
local unpack       = unpack
local varTbl       = varTbl
local Set          = Set

require("string_split")
require("fileOps")
require("serializeTbl")

local Mlist        = require("Mlist")
local Var          = require('Var')
local lfs          = require('lfs')
local pathJoin     = pathJoin
local Dbg          = require('Dbg')
local ColumnTable  = require('ColumnTable')
local posix        = require("posix")

--module("MT")
local M = {}

function M.name(self)
   return '_ModuleTable_'
end

s_mt = nil

local function build_locationTbl(tbl, pathA)
   local dbg = Dbg:dbg()
   for _,path in ipairs(pathA)  do
      local attr = lfs.attributes(path)
      if ( attr and attr.mode == "directory") then
         for file in lfs.dir(path) do
            local f = pathJoin(path,file)
            local readable = posix.access(f,"r")
            if (readable and not ignoreT[file]) then
               local a   = tbl[file] or {}
               file      = file:gsub("%.lua$","")
               a[#a+1]   = {file = f, mpath = path }
               tbl[file] = a
            end
         end
      end
   end
end


local function new(self, s)
   local dbg  = Dbg:dbg()
   dbg.start("MT:new()")
   local o            = {}

   o.active           = Mlist:new()
   o.total            = Mlist:new()

   o.version          = 1

   o.family           = {}
   o.mpathA           = {}
   o.baseMpathA       = {}
   o._same            = true
   o._MPATH           = ""
   o._locationTbl     = {}

   o._changePATH      = false
   o._changePATHCount = 0

   setmetatable(o,self)
   self.__index = self

   local active, total

   if (not s) then
      local v             =  getenv(ModulePath)
      varTbl[DfltModPath] = Var:new(DfltModPath, v)
      o:buildBaseMpathA(v)
      dbg.print("Initializing ", DfltModPath, ":", v, "\n")
   else
      assert(loadstring(s))()
      local _ModuleTable_ = systemG._ModuleTable_
      for k in pairs(_ModuleTable_) do
         if (    k == 'active') then
            active = _ModuleTable_[k]
         elseif (k == 'total' )  then
            total  = _ModuleTable_[k]
         else
            o[k] = _ModuleTable_[k]
         end
      end
      o._MPATH = concatTbl(o.mpathA,":")
      varTbl[DfltModPath] = Var:new(DfltModPath, concatTbl(o.baseMpathA,":"))
   end

   if (active and active.Loaded) then
      local mTypeA = active.mType or {}
      for i,v in ipairs(active.Loaded) do
         local hashV = nil
         if (active.hash) then
            hashV = active.hash[i]
         end
         local mType = mTypeA[i] or "mw"
         local t = { fn = active.FN[i], modFullName = active.fullModName[i],
                    default = active.default[i], hash = hashV, modName=v,
                    mType = mType, }
         o:addActive(t)
      end
      mTypeA = total.mType or {}
      for i,v in ipairs(total.Loaded) do
         local mType = mTypeA[i] or "mw"
         local t = { fn = total.FN[i], modFullName = total.fullModName[i],
                     default = total.default[i], modName=v, mType = mType, }
         o:addTotal(t)
      end
   end

   o._inactive        = o.inactive or {}
   o.inactive         = {}

   dbg.fini()
   return o
end

local function setupMPATH(self,mpath)
   self._same = self:sameMPATH(mpath)
   if (not self._same) then
      self:buildMpathA(mpath)
   end
   build_locationTbl(self._locationTbl,self.mpathA)
end

function M.mt(self)
   if (s_mt == nil) then
      local dbg  = Dbg:dbg()
      dbg.start("mt()")
      local shell        = systemG.Master:master().shell
      s_mt               = new(self, shell:getMT(self:name()))
      varTbl[ModulePath] = Var:new(ModulePath)
      setupMPATH(s_mt, varTbl[ModulePath]:expand())
      if (not s_mt._same) then
         s_mt:reloadAllModules()
      end
      dbg.fini()
   end
   return s_mt
end

function M.getMTfromFile(self,fn)
   local dbg  = Dbg:dbg()
   dbg.start("mt:getMTfromFile(",fn,")")
   local f = io.open(fn,"r")
   if (not f) then
      io.stdout:write("false\n")
      os.exit(1)
   end
   local s = f:read("*all")
   f:close()

   -----------------------------------------------
   -- Initialize MT with file: fn
   -- Save module name in hash table "t"
   -- with Hash Sum as value

   local l_mt  = new(self, s)
   local mpath = l_mt._MPATH
   local t     = {}
   local a     = {}  -- list of "worker-bee" modules
   local m     = {}  -- list of "manager"    modules
   for _,v in ipairs(l_mt:listActive()) do
      local isDefault = l_mt:defaultModuleActive(v)
      if (isDefault) then
         t[v] = l_mt.active:getHashSum(v)
      else
         _, v = l_mt:modFullNameActive(v)
         t[v] = l_mt.active:getHashSum(v)
      end

      local mType     = l_mt:mTypeActive(v)
      if (mType == "w") then
         a[#a+1] = v
      else
         m[#m+1] = v
      end
   end

   
   varTbl[ModulePath] = Var:new(ModulePath,mpath)
   dbg.print("(1) varTbl[ModulePath]:expand(): ",varTbl[ModulePath]:expand(),"\n")
   Purge()
   mpath = varTbl[ModulePath]:expand()
   dbg.print("(2) varTbl[ModulePath]:expand(): ",mpath,"\n")

   -----------------------------------------------------------
   -- Clear MT and load modules from saved modules stored in
   -- "t" from above.
   local baseMPATH = concatTbl(self.baseMpathA,":")
   s_mt = new(self,nil)
   posix.setenv(self:name(),"",true)
   setupMPATH(s_mt, mpath)
   s_mt:buildBaseMpathA(baseMPATH)
   varTbl[DfltModPath] = Var:new(DfltModPath,baseMPATH)

   dbg.print("(3) varTbl[ModulePath]:expand(): ",varTbl[ModulePath]:expand(),"\n")
   Load(unpack(a))

   local master = systemG.Master:master()

   master.fakeload(unpack(m))
   
   --dbg.print("Finding modules to unload:\n")
   a = {}
   for _,v in ipairs(s_mt:listActive()) do
      local isDefault = s_mt:defaultModuleActive(v)
      if (not isDefault) then
         local vv = v
         _, v = s_mt:modFullNameActive(vv)
      end
      if (not t[v]) then
         --dbg.print("  Did not find v:",v,"\n")
         a[#a+1] = v
      end
   end

   if (#a > 0) then
      Error("The following modules have been loaded and should not have:\n",
                "  ",concatTbl(a,", "),"\n",
                "This should not happen!\n")
   end

   s_mt:assignHashSumActive()
   a = {}
   for v in pairs(t) do
      if(t[v] ~= s_mt.active:getHashSum(v)) then
         a[#a + 1] = v
      end
   end

   if (#a > 0) then
      Error("The following modules have changed: ", concatTbl(a," "),"\n",
            "Please reset this default setup\n")
   end

   local n = "__LMOD_DEFAULT_MODULES_LOADED__"
   varTbl[n] = Var:new(n)
   varTbl[n]:set("1")
   dbg.print("baseMpathA: ",concatTbl(self.baseMpathA,":"),"\n")

   dbg.fini()
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
   Set(n, mName)
   n = "TACC_FAMILY_" .. familyNm:upper()
   Set(n, mName)
   return results
end

function M.unsetfamily(self,familyNm)
   local n = "LMOD_FAMILY_" .. familyNm:upper()
   Unset(n, "")
   n = "TACC_FAMILY_" .. familyNm:upper()
   Unset(n, "")
   self.family[familyNm] = nil
end

function M.getfamily(self,familyNm)
   if (familyNm == nil) then
      return self.family
   end
   return self.family[familyNm]
end


function M.locationTbl(self, fn)
   return self._locationTbl[fn]
end

function M.sameMPATH(self, mpath)
   return self._MPATH == mpath
end

function M.module_pathA(self)
   return self.mpathA
end

function M.buildMpathA(self, mpath)
   local mpathA = {}
   for path in mpath:split(":") do
      mpathA[#mpathA + 1] = path
   end
   self.mpathA = mpathA
   self._MPATH = concatTbl(mpathA,":")
end

function M.buildBaseMpathA(self, mpath)
   local mpathA = {}
   for path in mpath:split(":") do
      mpathA[#mpathA + 1] = path
   end
   self.baseMpathA = mpathA
end


function M.getBaseMPATH(self)
   return concatTbl(self.baseMpathA,":")
end

function M.reEvalModulePath(self)
   self:buildMpathA(varTbl[ModulePath]:expand())
   self._locationTbl = {}
   build_locationTbl(self._locationTbl, self.mpathA)
end

function M.reloadAllModules(self)
   local dbg    = Dbg:dbg()
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
         Error("ReLoading more than ", ncount, " times-> exiting\n")
      end
      done = self:sameMPATH(varTbl[ModulePath]:expand())
   end

   local safe = master:safeToUpdate()
   if (not safe and changed) then
      Error("MODULEPATH has changed: run \"module update\" to repair\n")
   end
   return not changed
end


------------------------------------------------------------
-- Pass-Thru function modules in the Active list


function M.addActive(self, t)
   self.active:add(t)
end

function M.fileNameActive(self,moduleName)
   return self.active:fileName(moduleName)
end

function M.haveModuleActive(self,moduleName)
   return self.active:haveModule(moduleName)
end

function M.haveModuleAnyActive(self,moduleName)
   return self.active:haveModuleAny(moduleName)
end

function M.listActive(self)
   return self.active:list()
end

function M.loadActiveList(self)
   local a = self.active:list()
   return concatTbl(a,":")
end

function M.assignHashSumActive(self)
   self.active:assignHashSum()
end

function M.getHashSumActive(self)
   self.active:getHashSum()
end

function M.defaultModuleActive(self,idx)
   return self.active:defaultModule(idx)
end

function M.modFullNameActive(self,moduleName)
   return self.active:modFullName(moduleName)
end

function M.mTypeActive(self,moduleName)
   return self.active:moduleType(moduleName)
end

function M.removeActive(self, moduleName)
   self.active:remove(moduleName)
end

function M.safeToSaveActive(self)
   return self.active:safeToSave()
end

------------------------------------------------------------
-- Pass-Thru function modules in the Total list

function M.addTotal(self, t)
   self.total:add(t)
end

function M.fileNameTotal(self,moduleName)
   return self.total:fileName(moduleName)
end

function M.haveModuleTotal(self,moduleName)
   return self.total:haveModule(moduleName)
end

function M.haveModuleAnyTotal(self,moduleName)
   return self.total:haveModuleAny(moduleName)
end

function M.listTotal(self)
   return self.total:list()
end

function M.defaultModuleTotal(self,moduleName)
   return self.total:defaultModule(moduleName)
end

function M.modFullNameTotal(self,moduleName)
   return self.total:modFullName(moduleName)
end

function M.removeTotal(self, moduleName)
   self.total:remove(moduleName)
end


function M.loadTotalList(self)
   local a = self.total:list()
   return concatTbl(a,":")
end

local function bool(a)
   local result = "false"
   if (a) then result = "true" end
   return result
end


function M.changeInactive(self)
   local master = systemG.Master:master()
   local a      = self:listTotal()
   local t      = {}
   local aa     = self._inactive

   local prt    = not expert()
   local ct 

   ------------------------------------------------------------
   -- print out newly activated Modules

   local i = 0
   for _,v in ipairs(aa) do
      if (self:haveModuleAnyActive(v)) then
         local fullName = self:modFullNameActive(v)
         i    = i + 1
         t[i] = '  ' .. i .. ') ' .. fullName
         master:reloadClear(fullName)
      end
   end
   if (i > 0 and prt) then
      io.stderr:write("Activating Modules:\n")
      ct = ColumnTable:new{tbl=t, prt=prtErr}
      ct:print_tbl()
      t = {}
   end

   ------------------------------------------------------------
   -- Form new inactive list
   aa = {}
   for _,v in ipairs(a) do
      if (not self:haveModuleAnyActive(v)) then
         t[v]      = 1
         aa[#aa+1] = v
      end
   end
   self.inactive = aa
   local same = (#aa == #self._inactive)
   if (same) then
      for _,v in ipairs(self._inactive) do
         if (not t[v]) then
            same = false
            break
         end
      end
   end

   if (not same and #aa > 0 and prt) then
      t = {}
      for i,v in ipairs(aa) do
         t[#t + 1] = '  ' .. i .. ') ' .. v
      end
      io.stderr:write("Inactive Modules:\n")
      ct = ColumnTable:new{tbl=t, prt=prtErr}
      ct:print_tbl()
   end

   return same
end


function M.serializeTbl(self)
   local s = _G.serializeTbl{ indent=false, name=self.name(), value=s_mt}
   return s:gsub("[ \n]","")
end

return M
