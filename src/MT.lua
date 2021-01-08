--------------------------------------------------------------------------
-- This class controls the ModuleTable.  The ModuleTable is how Lmod
-- communicates what modules are loaded or inactive and so on between
-- module commands.
--
-- @classmod MT

_G._DEBUG          = false
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

require("deepcopy")
require("declare")
require("utils")
require("serializeTbl")

local ColumnTable  = require("ColumnTable")
local M            = {}
local MRC          = require("MRC")
local ReadLmodRC   = require("ReadLmodRC")
local base64       = require("base64")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local encode64     = base64.encode64
local floor        = math.floor
local getenv       = os.getenv
local hook         = require("Hook")
local i18n         = require("i18n")
local load         = (_VERSION == "Lua 5.1") and loadstring or load
local min          = math.min
local posix_setenv = posix.setenv
local s_loadOrder  = 0
local s_mt         = false
local s_name       = "_ModuleTable_"
local s_familyA    = false
local sort         = table.sort
local strfmt       = string.format
local abs          = math.abs

function M.name(self)
   return s_name
end

local function mt_version()
   return 3
end


local function new(self, s, restoreFn)
   dbg.start{"MT new(s,restoreFn:",restoreFn,")"}
   local o         = {}

   o.c_rebuildTime   = false
   o.c_shortTime     = false
   o.mT              = {}
   o.MTversion       = mt_version()
   o.family          = {}
   o.mpathA          = {}
   o.depthT          = {}
   o.__stickyA     = {}
   o.__loadT       = {}
   o.__changeMPATH = false

   setmetatable(o, self)
   self.__index    = self

   local currentMPATH = getenv("MODULEPATH")
   dbg.print{"currentMPATH: ",currentMPATH,"\n"}
   if (not s) then
      if (currentMPATH) then
         o.mpathA          = path2pathA(currentMPATH)
         o.systemBaseMPATH = concatTbl(o.mpathA,":")
      end
      local maxdepth    = cosmic:value("LMOD_MAXDEPTH")
      o.depthT          = paired2pathT(maxdepth)
      dbg.print{"LMOD_MAXDEPTH: ",maxdepth,"\n"}
      dbg.print{"s is nil\n"}
      dbg.fini("MT new")
      return o
   end

   declare(s_name)

   local func, msg = load(s)
   local ok

   if (func) then
      ok, msg = pcall(func)
   else
      ok = false
   end

   local _ModuleTable_ = _G[s_name] or _G._ModuleTable_


   ------------------------------------------------------------------------
   -- Do not call LmodError or LmodSystemError here.  It leads to an
   -- endless loop !!

   if (not ok or type(_ModuleTable_) ~= "table" ) then
      if (restoreFn) then
         io.stderr:write(i18n("e_coll_corrupt",{fn=restoreFn}))
         LmodErrorExit()
      else
         io.stderr:write(i18n("e_MT_corrupt",{}))
         LmodErrorExit()
      end
   end

   if (_ModuleTable_.version == 2) then
      o:__convertMT(_ModuleTable_)
   else
      for k,v in pairs(_ModuleTable_) do
         o[k] = v
      end
   end

   local icount = 0
   for k in pairs(o.mT) do
      icount = icount + 1
   end
   s_loadOrder = icount

   ------------------------------------------------------------
   -- No matter what the MODULEPATH was before use the current
   -- environment value. Unless it is a module restore

   if (not restoreFn) then
      o.mpathA = path2pathA(currentMPATH)
   end

   dbg.fini("MT new")
   return o
end

function M.singleton(self, t)
   t = t or {}
   if (t.testing) then
      dbg.print{"Clearing s_mt\n"}
      s_mt = false
      __removeEnvMT()
   end
   if (not s_mt) then
      dbg.start{"MT:singleton()"}
      s_mt        = new(self, getMT())
      dbg.fini("MT:singleton")
   end
   return s_mt
end

function M.__clearMT(self, t)
   if (t.testing == true) then
      dbg.print{"Clearing s_mt\n"}
      s_mt  = false
   end
end

function M.__convertMT(self, v2)
   self.MTversion       = 3;
   self.c_rebuildTime   = v2.c_rebuildTime
   self.c_shortTime     = v2.c_shortTime
   self.depthT          = {}
   self.family          = v2.family
   self.mpathA          = v2.mpathA
   self.systemBaseMPATH = v2.systemBaseMPATH
   local mT             = {}
   for sn, vv in pairs(v2.mT) do
      local v     = {}
      v.fn        = vv.FN
      v.fullName  = vv.fullName
      v.hash      = vv.hash
      v.loadOrder = vv.loadOrder
      v.propT     = vv.propT
      v.status    = vv.status
      v.wV        = vv.wV
      v.userName  = (vv.default == 1) and sn or v.fullName
      mT[sn]      = v
   end
   self.mT = mT
end

function __removeEnvMT()
   local SzStr = "_ModuleTable_Sz_"
   local piece = "_ModuleTable%03d_"
   local nblks = tonumber(getenv(SzStr) or "") or 0
   posix_setenv(SzStr,nil, true)
   for i = 1, nblks do
      local envNm = strfmt(piece,i)
      posix_setenv(envNm, nil, true)
   end
end

--------------------------------------------------------------------------
-- Return the original MT from bottom of stack.

function M.add(self, mname, status, loadOrder)
   local mT    = self.mT
   local sn    = mname:sn()
   loadOrder   = loadOrder  == nil and -1 or loadOrder
   assert(sn)
   mT[sn] = {
      fullName   = mname:fullName(),
      fn         = mname:fn(),
      userName   = mname:userName(),
      stackDepth = mname:stackDepth(),
      ref_count  = mname:ref_count(),
      status     = status,
      loadOrder  = loadOrder,
      propT      = {},
      wV         = mname:wV() or false,
   }
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
   local s            = f:read("*all")
   local l_mt         = new(self, s, t.fn)
   local pin_versions = cosmic:value("LMOD_PIN_VERSIONS")
   local kind         = (pin_versions == "no") and "userName" or "fullName"
   local activeA      = l_mt:list(kind, "active")
   for i = 1, #activeA do
      a[#a+1] = activeA[i].name
   end

   f:close()
   dbg.fini("mt:reportContents")
   return a
end

------------------------------------------------------------------------
-- Mark Changing MODULEPATH

function M.changeMPATH(self)
   return self.__changeMPATH
end

function M.set_MPATH_change_flag(self)
   dbg.print{"MT:set_MPATH_change_flag(self)\n"}
   self.__changeMPATH = true
end

function M.reset_MPATH_change_flag(self)
   self.__changeMPATH = false
end


function M.setStatus(self, sn, status)
   local entry = self.mT[sn]
   if (entry ~= nil) then
      entry.status = status
      if (status == "active") then
         s_loadOrder     = s_loadOrder + 1
         entry.loadOrder = s_loadOrder
      end
   end
end

function M.status(self, sn)
   local entry = self.mT[sn]
   if (entry ~= nil) then
      return entry.status
   end
   return nil
end

function M.exists(self, sn)
   local entry = self.mT[sn]
   return (entry ~= nil)
end

--------------------------------------------------------------------------
-- Set the rebuild and short time for the cache
-- @param long The long time before rebuilding user cache.
-- @param short The short time before rebuilding user cache.
function M.setRebuildTime(self, long, short)
   dbg.start{"MT:setRebuildTime(long: ",long,", short: ",short,")",level=2}
   self.c_rebuildTime = long
   self.c_shortTime   = short
   dbg.fini("MT:setRebuildTime")
end

--------------------------------------------------------------------------
-- Set the load order by using MT:list()
-- @param self An MT object.
local function setLoadOrder(self)
   local a  = self:list("short","active")
   local mT = self.mT
   local sz = #a

   for i = 1,sz do
      local sn = a[i]
      mT[sn].loadOrder = i
   end
end

function M.serializeTbl(self, state)
   local indent = (state == "pretty")
   local mt     = self
   if (masterTbl().rt) then
      mt               = deepcopy(self)
      mt.c_rebuildTime = false
      mt.c_shortTime   = false
   end

   setLoadOrder(mt)
   local s = serializeTbl{indent = indent, name = self.name(), value = mt}
   if (not indent) then
      s = s:gsub("%s+","")
   end
   return s
end

function M.encodeMT(self)
   local s     = self:serializeTbl()
   return build_MT_envT(s)
end

--------------------------------------------------------------------------
-- Clear the entry for *sn* from the module table.
-- @param self An MT object.
-- @param sn The short name.
function M.remove(self, sn)
   local mT  = self.mT
   mT[sn]    = nil
end

local function build_AB(a,b, loadOrder, name, value)
   if (loadOrder > 0) then
      a[#a+1] = { loadOrder, name, value }
   else
      b[#b+1] = { abs(loadOrder), name, value }
   end
   return a, b
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
   local a    = {}
   local b    = {}

   if (kind == "short" or kind == "sn") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            a, b = build_AB(a, b,  v.loadOrder , k, k)
         end
      end
   elseif (kind == "userName" or kind == "fullName") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            local obj = { sn = k, fullName = v.fullName, userName = v.userName,
                          name = v[kind], fn = v.fn, loadOrder = v.loadOrder,
                          stackDepth = v.stackDepth, ref_count = v.ref_count}
            a, b = build_AB(a, b, v.loadOrder, v[kind], obj )
         end
      end
   elseif (kind == "both") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            a, b = build_AB(a, b, v.loadOrder, v.userName, v.userName )
            if (v.userName ~= k) then
               a, b = build_AB(a, b, v.loadOrder, k, k)
            end
            if (v.userName ~= v.fullName) then
               a, b = build_AB(a, b, v.loadOrder, v.fullName, v.fullName )
            end
         end
      end
   end

   local function loadOrder_cmp(x,y)
      if (x[1] == y[1]) then
         return x[2] < y[2]
      else
         return x[1] < y[1]
      end
   end

   sort (a, loadOrder_cmp)
   sort (b, loadOrder_cmp)

   local B = {}

   for i = 1, #a do
      B[i] = a[i][3]
   end

   for i = 1, #b do
      B[#B+1] = b[i][3]
   end

   a = nil -- finished w/ a.
   b = nil -- finished w/ b.
   return B
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
      LmodError{msg="e_No_Mod_Entry", routine = "MT:add_property()",name = sn}
   end
   local readLmodRC   = ReadLmodRC:singleton()

   local propT        = entry.propT
   propT[name]        = propT[name] or {}
   local t            = propT[name]

   readLmodRC:validPropValue(name, value, t)
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
      LmodError{msg="e_No_Mod_Entry", routine = "MT:remove_property()",name = sn}
   end
   local readLmodRC   = ReadLmodRC:singleton()
   local propDisplayT = readLmodRC:propT()
   local propKindT    = propDisplayT[name]

   if (propKindT == nil) then
      LmodError{msg="e_No_PropT_Entry", routine = "MT:remove_property()", location = "entry", name = name}
   end
   local validT = propKindT.validT
   if (validT == nil) then
      LmodError{msg="e_No_PropT_Entry", routine = "MT:remove_property()", location = "validT table", name = name}
   end

   local propT        = entry.propT or {}
   local t            = propT[name] or {}

   for v in value:split(":") do
      if (validT[v] == nil) then
         LmodError{msg="e_No_ValidT_Entry", routine = "MT:remove_property()", name = name, value = value}
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
   local mrc   = MRC:singleton()

   if (entry == nil) then
      LmodError{msg="e_No_Mod_Entry", routine = "MT:list_property()", name = sn}
   end

   local resultA = colorizePropA(style, {fullName=entry.fullName,sn=sn,fn=entry.fn}, mrc, entry.propT, legendT)
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
-- Does the *sn* exist with a particular *status*.
-- @param self An MT object.
-- @param sn the short module name.
-- @param status The status.
-- @return existance.
function M.have(self, sn, status)
   local entry = self.mT[sn]
   if (entry == nil) then
      return false
   end
   return ((status == "any") or (status == entry.status))
end

function M.userName(self, sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.userName
end

function M.fullName(self, sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.fullName
end

function M.wV(self, sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.wV
end

function M.fn(self, sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.fn
end

function M.version(self,sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return nil
   end
   return extractVersion(entry.fullName, sn)
end

function M.stackDepth(self,sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return nil
   end
   return entry.stackDepth or 0
end

function M.incr_ref_count(self,sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      return
   end
   entry.ref_count = (entry.ref_count or 0) + 1
   return
end

function M.decr_ref_count(self,sn)
   local entry = self.mT[sn]
   if (entry == nil or entry.ref_count == nil) then
      return 0
   end
   local ref_count = entry.ref_count - 1
   entry.ref_count = ref_count
   return ref_count
end

function M.get_ref_count(self,sn)
   local entry = self.mT[sn]
   if (entry == nil or entry.ref_count == nil) then
      return 0
   end
   return entry.ref_count
end

function M.updateMPathA(self, value)
   if (type(value) == "string") then
      self.mpathA = path2pathA(value)
   elseif (type(value) == "table") then
      self.mpathA = value
   elseif (type(value) == "nil") then
      self.mpathA = path2pathA("")
   end
end

function M.modulePathA(self)
   return self.mpathA
end

function M.maxDepthT(self)
   return self.depthT
end

--------------------------------------------------------------------------
-- Return the shortTime time.
-- @param self An MT object.
function M.getShortTime(self)
   return self.c_shortTime
end

--------------------------------------------------------------------------
-- Return the rebuild time.
-- @param self An MT object.
function M.getRebuildTime(self)
   return self.c_rebuildTime
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
-- Mark a module as sticky.
-- @param self An MT object.
-- @param sn the short name
function M.addStickyA(self, sn)
   local a     = self.__stickyA
   local entry = self.mT[sn]
   a[#a+1]     = {sn = sn, fn = entry.fn, version = extractVersion(entry.fullName, sn),
                  userName = entry.userName }
end

--------------------------------------------------------------------------
-- Return the array of sticky modules.
-- @param self An MT object.
function M.getStickyA(self)
   return self.__stickyA
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
function M.userLoad(self, sn, userName)
   dbg.start{"MT:userLoad(",sn,")"}
   self.__loadT[sn] = userName
   dbg.fini("MT:userLoad")
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
   stream:write(msg or "")
   local ct = ColumnTable:new{tbl=t, width=cwidth}
   stream:write(ct:build_tbl(),"\n")
end

--------------------------------------------------------------------------
-- Compare the original MT with the current one.
-- Report any modules that have become inactive or
-- active.  Or report that a module has swapped or a
-- version has changed.
-- @param self An MT object.
function M.reportChanges(self)
   dbg.start{"MT:reportChanges()"}

   if (not Shell:isActive()) then
      dbg.print{"Expansion is inactive\n"}
      dbg.fini("MT:reportChanges")
      return
   end

   local origMT    = require("FrameStk"):singleton():origMT()
   local mT_orig   = origMT.mT
   local inactiveA = {}
   local activeA   = {}
   local changedA  = {}
   local reloadA   = {}
   local loadT     = self.__loadT

   for sn, v_orig in pairsByKeys(mT_orig) do
      if (self:have(sn,"inactive") and v_orig.status == "active") then
         inactiveA[#inactiveA+1] = v_orig.userName
      elseif (self:have(sn,"active")) then
         if ( v_orig.status == "inactive") then
            activeA[#activeA+1] = self:fullName(sn)
         elseif (self:fn(sn)       ~= v_orig.fn) then
            if  (self:fullName(sn) == v_orig.fullName) then
               reloadA[#reloadA+1] =  v_orig.fullName
            else
               local userName = loadT[sn]
               local fullName = self:fullName(sn)
               if (userName ~= fullName) then
                  changedA[#changedA+1] = v_orig.fullName .. " => " .. self:fullName(sn)
               end
            end
         end
      end
   end

   local entries = false

   if (#inactiveA > 0) then
      entries = true
      columnList(io.stderr,i18n("m_Inactive_Modules",{}), inactiveA)
   end
   if (#activeA > 0) then
      entries = true
      columnList(io.stderr,i18n("m_Activate_Modules",{}), activeA)
   end
   if (#reloadA > 0) then
      entries = true
      columnList(io.stderr,i18n("m_Reload_Modules",{}), reloadA)
   end
   if (#changedA > 0) then
      entries = true
      columnList(io.stderr,i18n("m_Reload_Version_Chng",{}), changedA)
   end

   if (entries) then
      io.stderr:write("\n")
   end

   dbg.fini("MT:reportChanges")
end

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
-- Push the inheritance file into a stack.
-- @param self An MT object.
-- @param sn the short name.
-- @param fn the file name.
function M.pushInheritFn(self,sn, mname)
   local mT           = self.mT
   local mnameA       = mT[sn].mnameA or {}
   local entryT       = { sn = mname:sn(),           fn = mname:fn(),
                          version = mname:version(), userName= mname:userName() }
   mnameA[#mnameA+1]  = entryT
   mT[sn].mnameA      = mnameA
end

--------------------------------------------------------------------------
-- Pop the inheritance file from the stack.
-- @param self An MT object.
-- @param sn the short name.
-- @param fn the file name.
-- @return the filename on top of the stack.
function M.popInheritFn(self, sn)
   local mT      = self.mT
   local mnameA  = mT[sn].mnameA
   local mname   = false
   if (mnameA and next(mnameA) ~= nil) then
      local entryT = table.remove(mnameA)
      mname = require("MName"):new("entryT",entryT)
      if (next(mnameA) == nil) then
         mT[sn].mnameA = nil
      end
   end
   return mname
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
      LmodError{msg="e_Failed_2_Find", name = "computeHashSum"}
   end

   local path   = "@path_to_lua@:" .. os.getenv("PATH")
   local luaCmd, found = findInPath("lua",path)

   if (not found) then
      LmodError{msg="e_Failed_2_Find", name = "lua"}
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

   for sn,v in pairs(mT) do
      local a = {}
      if (v.status == "active") then
         a[#a + 1]  = cmdStart
         a[#a + 1]  = "--fullName"
         a[#a + 1]  = v.fullName
         a[#a + 1]  = "--userName"
         a[#a + 1]  = v.userName
         a[#a + 1]  = "--sn"
         a[#a + 1]  = sn
         a[#a + 1]  = v.fn
         local cmd  = concatTbl(a," ")
         local s    = capture(cmd)
         v.hash     = s:sub(1,-2)
         dbg.print{"cmd: ", cmd,", v.hash: \"",v.hash,"\"\n"}
      end
   end
   dbg.fini("MT:setHashSum")
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
      io.stderr:write(i18n("m_Restore_Coll",{msg=msg}))
   end
   -----------------------------------------------
   -- Initialize MT with file: fn
   -- Save module name in hash table "tt"
   -- with Hash Sum as value

   local restoreFn = tt.fn
   dbg.print{"s: ",s,"\n"}
   local l_mt       = new(self, s, restoreFn)
   local activeA    = l_mt:list("userName","active")
   local savedMPATH = concatTbl(l_mt.mpathA,":")
   local tracing    = cosmic:value("LMOD_TRACING")

   ---------------------------------------------
   -- If any module specified in the "default" file
   -- is a default then use the short name.  This way
   -- getting the modules from the collection specified
   -- file will work even when the defaults have changed.
   local t = {}

   for i = 1,#activeA do
      local sn = activeA[i].sn
      t[sn]    = l_mt:getHash(sn)
      dbg.print{"sn: ",sn,", hash: ", t[sn], "\n"}
   end

   local force = true
   Purge(force)

   local savedBaseMPATH = l_mt.systemBaseMPATH
   dbg.print{"Saved baseMPATH: ",savedBaseMPATH,"\n"}
   dbg.print{"Current BaseMPATH: ",self.systemBaseMPATH,"\n"}
   if (self.systemBaseMPATH ~= savedBaseMPATH) then
      LmodWarning{msg="w_MPATH_Coll"}
      if (collectionName ~= "default") then
         LmodErrorExit()
      end
      dbg.fini("MT:getMTfromFile")
      return false
   end

   ------------------------------------------------------------
   -- Build a new MT with only the savedBaseMPATH from before.
   -- This means resetting s_mt, s_frameStk and defining
   -- MODULEPATH in the environment.  Then we can rebuild a fresh
   -- FrameStk and MT.
   local FrameStk = require("FrameStk")
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()

   dbg.print{"(1) mt.systemBaseMPATH: ",mt.systemBaseMPATH,"\n"}
   dbg.print{"savedBaseMPATH: ",savedBaseMPATH,"\n"}
   s              = serializeTbl{indent=true, name=s_name, value=mt}
   dbg.print{"mt after purge",s,"\n"}
   local envMT = build_MT_envT(s)
   for k,v in pairs(envMT) do
      posix_setenv(k,v,true)
   end


   s_mt = false
   __removeEnvMT()
   FrameStk:__clear()
   dbg.print{"Setting MODULEPATH to: ",savedMPATH,"\n"}
   posix_setenv(ModulePath, savedMPATH, true)
   frameStk = FrameStk:singleton()
   mt       = frameStk:mt()
   mt.systemBaseMPATH = savedBaseMPATH
   dbg.print{"savedBaseMPATH: ",savedBaseMPATH,"\n"}
   dbg.print{"(2) mt.systemBaseMPATH: ",mt.systemBaseMPATH,"\n"}
   mt:updateMPathA(savedMPATH)

   if (tracing == "yes") then
      io.stderr:write("  Using collection:      ", tt.fn,"\n")
      io.stderr:write("  Setting MODULEPATH to: ", savedBaseMPATH,"\n")
   end


   dbg.print{"(3) mt.systemBaseMPATH: ",mt.systemBaseMPATH,"\n"}
   local cached_loads = cosmic:value("LMOD_CACHED_LOADS")
   local use_cache    = (cached_loads ~= 'no')
   local moduleA      = require("ModuleA"):singleton{spider_cache=use_cache}
   moduleA:update{spider_cache = use_cache }
   dbg.print{"(4) mt.systemBaseMPATH: ",mt.systemBaseMPATH,"\n"}

   -----------------------------------------------------------------------
   -- Save the shortTime found from Module Collection file:
   mt.c_shortTime = l_mt.c_shortTime

   -----------------------------------------------------------------------
   -- Load all modules: use Mgrload load for all modules

   local MName   = require("MName")
   local mcp_old = mcp
   mcp           = MasterControl.build("mgrload","load")

   -----------------------------------------------
   -- Normally we load the user name which means
   -- that defaults will be followed.  However
   -- some sites/users wish to use the fullname
   -- and not follow defaults.
   local pin_versions = cosmic:value("LMOD_PIN_VERSIONS")
   local knd          = (pin_versions == "no") and "userName" or "fullName"
   local mA           = {}

   -- remember to transfer the old stackDepth to the new mname object.
   for i = 1, #activeA do
      local mname = MName:new("load",activeA[i][knd])
      mname:setRefCount(activeA[i].ref_count)
      mname:setStackDepth(activeA[i].stackDepth)
      mA[#mA+1]   = mname
   end
   MCP.load(mcp,mA)
   mcp        = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   mt         = frameStk:mt()
   local varT = frameStk:varT()
   varT[ModulePath]:setRefCount(l_mt.mpathRefCountT or {})

   -----------------------------------------------------------------------
   -- Now check to see that all requested modules got loaded.
   activeA = mt:list("userName","active")
   if (#activeA == 0 ) then
      LmodWarning{msg="w_Empty_Coll",collectionName=collectionName}
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
         aa[#aa+1] = sn
         t[sn]     = nil -- do not need to check hash for a non-existant module
      end
   end

   activeA = nil  -- done with activeA
   activeT = nil  -- done with activeT
   if (#aa > 0) then
      sort(aa)
      LmodWarning{msg="w_Mods_Not_Loaded",module_list=concatTbl(aa," ")}
   end

   --------------------------------------------------------------------------
   -- Check that the hash sums match between collection and current values.

   aa = {}
   mt:setHashSum()
   for sn, hash  in pairs(t) do
      dbg.print{"HASH sn: ",sn, ", t hash: ",hash, "s hash: ", mt:getHash(sn), "\n"}
      if(hash ~= mt:getHash(sn)) then
         aa[#aa + 1] = sn
      end
   end

   if (#aa > 0) then
      sort(aa)
      LmodWarning{msg="w_Broken_Coll", collectionName = collectionName, module_list = concatTbl(aa,"\", \"")}
      if (collectionName ~= "default") then
         LmodErrorExit()
      end
      return false
   end

   mt:hideHash()

   -----------------------------------------------------------------------
   -- Set environment variable __LMOD_DEFAULT_MODULES_LOADED__ so that
   -- users have a way to know that their default collection was safely
   -- read in.

   if (collectionName == "default") then
      local Var  = require("Var")
      local n    = "__LMOD_DEFAULT_MODULES_LOADED__"
      local varT = frameStk:varT()
      varT[n]    = Var:new(n,"1")
   end
   mt = frameStk:mt()
   dbg.fini("MT:getMTfromFile")
   return true
end

function M.setMpathRefCountT(self, refCountT)
   self.mpathRefCountT = refCountT
end
function M.hideMpathRefCountT(self, refCountT)
   self.mpathRefCountT = nil
end

function M.resetMPATH2system(self)
   self.mpathA = path2pathA(self.systemBaseMPATH)
   return self.systemBaseMPATH
end

return M
