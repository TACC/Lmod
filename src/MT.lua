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
local decode64     = base64.decode64
local encode64     = base64.encode64
local dbg          = require("Dbg"):dbg()
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

local function l_mt_version()
   return 3
end


local function l_new(self, s, restoreFn)
   dbg.start{"MT l_new(s,restoreFn:",restoreFn,")"}
   local o         = {}

   o.c_rebuildTime = false
   o.c_shortTime   = false
   o.mT            = {}
   o.MTversion     = l_mt_version()
   o.family        = {}
   o.mpathA        = {}
   o.depthT        = {}
   o.__conflictT   = {}
   o.__stickyA     = {}
   o.__loadT       = {}
   o.__changeMPATH = false

   setmetatable(o, self)
   self.__index    = self

   local currentMPATH = getenv("MODULEPATH")
   dbg.print{"currentMPATH: ",currentMPATH,"\n"}
   if (not s) then
      if (currentMPATH) then
         local clearDblSlash = true
         o.mpathA          = path2pathA(currentMPATH,':',clearDblSlash)
         o.systemBaseMPATH = concatTbl(o.mpathA,":")
      end
      local maxdepth    = cosmic:value("LMOD_MAXDEPTH")
      o.depthT          = paired2pathT(maxdepth)
      dbg.print{"LMOD_MAXDEPTH: ",maxdepth,"\n"}
      dbg.print{"s is nil\n"}
      dbg.fini("MT l_new")
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
      ------------------------------------------------------------------
      -- Convert the list of MName constructors in to an array of mnames
      -- to hold the conflicts.
      if (o.conflictT and  next(o.conflictT) ~= nil) then
         local MName = require("MName")
         local cT = {}
         local tt = o.conflictT

         for sn, vv in pairs(tt) do
            local a = {}
            for i = 1,#vv do
               local t = tt[sn][i]
               a[i] = MName:new(t.sType, t.userName, t.action, t.is, t.ie)
            end
            cT[sn] = a
         end
         o.__conflictT = cT
      end
      o.conflictT   = nil
   end

   -- remove any mcmdT connected to a mT entry
   local mT = o.mT
   for sn, entry in pairs(mT) do
      entry.mcmdT = nil
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
      local clearDblSlash = true
      o.mpathA            = path2pathA(currentMPATH,':',clearDblSlash)
   end

   dbg.fini("MT l_new")
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
      s_mt        = l_new(self, getMT())
      if (dbg.active()) then
         dbg.print{"s_mt: ",s_mt:serializeTbl("pretty") }
      end
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
   local mT         = self.mT
   local sn         = mname:sn()
   assert(sn)
   local entry      = mT[sn] or {}
   local old_status = entry.status
   loadOrder        = loadOrder  == nil and -1 or loadOrder

   -- Issue #604: If old_status is "inactive" then ref_count must be nil.
   --             The ref_count will be bumped back up by the loading of
   --             modules that depend on the dependent modules.

   local ref_count = mname:ref_count()
   if (old_status == "inactive" and status ~= "inactive" and mname:get_depends_on_flag()) then
      ref_count = 0
   end
   mT[sn] = {
      fullName        = mname:fullName(),
      fn              = mname:fn(),
      userName        = mname:userName(),
      stackDepth      = mname:stackDepth(),
      origUserName    = mname:origUserName(),
      moduleKindT     = mname:moduleKindT{},
      forbiddenT      = mname:forbiddenT{},
      ref_count       = ref_count,
      depends_on_anyA = mname:get_depends_on_anyA(),
      status          = status,
      loadOrder       = loadOrder,
      propT           = {},
      wV              = mname:wV() or false,
   }
   if (status ~= "inactive" and old_status ~= "inactive") then
      self:safely_incr_ref_count(mname)
   end
   --dbg.print{"MT:add: sn: ", sn, ", status: ",status,", old_status: ",old_status,", ref_count: ",mT[sn].ref_count,"\n"}
end

--------------------------------------------------------------------------
-- Report the contents of the collection. Return an empty array if the
-- collection is not found.
function M.reportContents(self, t)
   dbg.start{"mt:reportContents(",t.fn,")"}
   local a       = {}
   if (not t.fn) then
      dbg.fini("mt:reportContents")
      return a
   end
   local f = io.open(t.fn,"r")
   if (not f) then
      dbg.fini("mt:reportContents")
      return a
   end
   local s            = f:read("*all")
   local l_mt         = l_new(self, s, t.fn)
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


function M.add_actionA(self, sn, action, value)
   local entry = self.mT[sn]
   if (entry ~= nil) then
      local a = entry.actionA or {}
      a[#a+1]    = action .. "(\"MODULEPATH\",\"" .. value .."\")"
      entry.actionA = a
   end
end

function M.get_actionA(self, sn)
   local entry   = self.mT[sn]
   local actionA = {}
   if (entry ~= nil) then
      actionA = entry.actionA or {}
   end
   return actionA
end

function M.add_sh2mf_cmds(self, sn, script, mcmdA)
   local entry = self.mT[sn]
   if (entry ~= nil) then
      local a64 = {}
      for i =1, #mcmdA do
         a64[i] = encode64(mcmdA[i])
      end
      if (entry.mcmdT_64 == nil) then
         entry.mcmdT_64 = {}
      end
      local script64 = encode64(script)
      entry.mcmdT_64[script64] = a64
   end
end

function M.get_sh2mf_cmds(self, sn, script)
   local entry = self.mT[sn]
   if (entry ~= nil and entry.mcmdT_64  ~= nil
          and next(entry.mcmdT_64)      ~= nil) then
      local script64 = encode64(script)
      local a64 = entry.mcmdT_64[script64]
      if (  a64 == nil ) then return nil end
      local a = {}
      for i = 1,#a64 do
         a[i] = decode64(a64[i])
      end
      return a
   end
   return nil
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

function M.exists(self, sn, fullName)
   local entry = self.mT[sn]
   if (entry == nil) then
      return false
   end
   return (fullName == nil) or (entry.status ~= "inactive"  and entry.fullName == fullName)
end

function M.moduleKindT(self, sn)
   local entry = self.mT[sn]
   if (entry ~= nil) then
      return entry.moduleKindT
   end
   return nil
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
local function l_setLoadOrder(self)
   local a  = self:list("short","active")
   local mT = self.mT
   local sz = #a

   for i = 1,sz do
      local sn = a[i]
      mT[sn].loadOrder = i
   end
end

function M.serializeTbl(self, state)
   local make_pretty = (state == "pretty")


   local mt     = deepcopy(self)
   local rTest  = optionTbl().rt
   if (rTest) then
      mt.c_rebuildTime = false
      mt.c_shortTime   = false
   end
   l_setLoadOrder(mt)

   if (next(self.__conflictT) ~= nil) then
      local cT = mt.__conflictT
      local tt = {}

      for sn,vv in pairs(cT) do
         local a = {}
         for i=1,#vv do
            local mname = vv[i]
            a[i] = mname:print()
         end
         tt[sn] = a
      end
      mt.conflictT = tt
   end

   if (make_pretty)  then
      local mT = mt.mT
      for sn, v in pairs(mT) do
         local mcmdT_64 = mT[sn].mcmdT_64
         if (mcmdT_64 and next(mcmdT_64) ~= nil) then
            local t = {}
            for script64, mcmdA_64 in pairsByKeys(mcmdT_64) do
               local a = {}
               for i = 1,#mcmdA_64 do
                  a[i] = decode64(mcmdA_64[i])
               end
               local script = decode64(script64)
               t[script] = a
            end
            mT[sn].mcmdT = t
            if (rTest) then
               mT[sn].mcmdT_64 = nil
            end
         end
      end
   end

   local s = serializeTbl{indent = make_pretty, name = self.name(), value = mt}
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

local function l_build_AB(a,b, loadOrder, name, value)
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

   dbg.print{"MT:list(kind: ",kind,", status:",status,")\n"}

   if (kind == "short" or kind == "sn") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            a, b = l_build_AB(a, b,  v.loadOrder , k, k)
         end
      end
   elseif (kind == "userName" or kind == "fullName") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            local obj = { sn = k, fullName = v.fullName, userName = v.userName,
                          name = v[kind], fn = v.fn, loadOrder = v.loadOrder,
                          stackDepth = v.stackDepth, ref_count = v.ref_count,
                          depends_on_anyA = v.depends_on_anyA, displayName = v.fullName,
                          origUserName = v.origUserName or false,
                          moduleKindT = v.moduleKindT or {},
                          forbiddenT  = v.forbiddenT or {},
                        }
            a, b = l_build_AB(a, b, v.loadOrder, v[kind], obj )
         end
      end
   elseif (kind == "fullName_Meta") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending") and
             (v.stackDepth == 0)) then
             local obj = { sn = k, fullName = v.fullName, userName = v.userName,
                          name = v.fullName, fn = v.fn, loadOrder = v.loadOrder,
                          stackDepth = v.stackDepth, ref_count = v.ref_count,
                          depends_on_anyA = v.depends_on_anyA, displayName = v.fullName,
                          origUserName = v.origUserName or false,
                          moduleKindT = v.moduleKindT or {},
                          forbiddenT  = v.forbiddenT or {},
             }
            a, b = l_build_AB(a, b, v.loadOrder, v.fullName, obj )
         end
      end
   elseif (kind == "both") then
      for k, v in pairs(mT) do
         if ((status == "any" or status == v.status) and
             (v.status ~= "pending")) then
            a, b = l_build_AB(a, b, v.loadOrder, v.userName, v.userName )
            if (v.userName ~= k) then
               a, b = l_build_AB(a, b, v.loadOrder, k, k)
            end
            if (v.userName ~= v.fullName) then
               a, b = l_build_AB(a, b, v.loadOrder, v.fullName, v.fullName )
            end
         end
      end
   end

   local function l_loadOrder_cmp(x,y)
      if (x[1] == y[1]) then
         return x[2] < y[2]
      else
         return x[1] < y[1]
      end
   end

   sort (a, l_loadOrder_cmp)
   sort (b, l_loadOrder_cmp)

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

function M.empty(self)
   local mT    = self.mT
   return next(mT) == nil
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
-- List the fullname with possible property
-- @param self An MT object.
-- @param idx The index in the list.
-- @param sn The short name
-- @param style How to colorize.
-- @param legendT The legend table.
function M.list_w_property(self, idx, sn, style, legendT)
   dbg.start{"MT:list_w_property(\"",sn,"\", \"",style,"\")"}
   local mT          = self.mT
   local entry       = mT[sn]
   local mrc         = MRC:singleton()

   if (entry == nil) then
      LmodError{msg="e_No_Mod_Entry", routine = "MT:list_w_property()", name = sn}
   end

   local resultA = colorizePropA(style, self, {fullName=entry.fullName, origUserName=entry.origUserName, sn=sn, fn=entry.fn},
                                 mrc, entry.propT, legendT, entry.forbiddenT)
   dbg.print{"resultA: ",resultA[1]," ",resultA[2],"\n"}
   if (resultA[2]) then
      resultA[2] = "(" .. resultA[2] .. ")"
   end

   local cstr    = string.format("%3d)",idx)

   table.insert(resultA, 1, cstr)
   dbg.fini("MT:list_w_property")
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
-- @return existence.
function M.have(self, sn, status)
   local entry = self.mT[sn]
   if (entry == nil) then
      return false
   end
   return ((status == "any") or (status == entry.status))
end

function M.find_possible_sn(self, userName)
   local sn_match = false
   local sn = userName
   while true do
      if (self:exists(sn)) then
         sn_match = true
         break
      end
      local idx = sn:match("^.*()/")
      if (idx == nil) then break end
      sn = sn:sub(1,idx-1)
   end
   if (not sn_match) then
      sn = userName
   end
   return sn_match, sn
end


function M.lookup_w_userName(self,userName)
   -- Check if userName is a sn

   local sn_match, sn = self:find_possible_sn(userName)

   if (not sn_match) then return false end

   -- Case 1:  userName -> sn ?
   if (userName == sn) then
      return sn
   end

   -- Case 2:  userName -> fullName ?
   local fullName = self:fullName(sn)
   if (userName == fullName) then
      return sn
   end

   -- Case 3: Partial match?
   local partial_match = ("^"..userName:escape().."/"):gsub('//+','/')
   if (fullName:find(partial_match)) then
      return sn
   end
   return false
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

function M.safely_incr_ref_count(self,mname)
   local sn    = mname:sn()
   assert(sn)
   local entry = self.mT[sn]
   if (entry == nil) then
      dbg.print{"MT:safely_incr_ref_count(): Did not find: ",sn,"\n"}
      return
   end
   local depends_on_flag = mname:get_depends_on_flag()
   if (not depends_on_flag and not entry.ref_count) then
      dbg.print{"MT:safely_incr_ref_count(): depends_on_flag not set ",sn,"\n"}
      return
   end
   entry.ref_count = (entry.ref_count or 0) + 1
   dbg.print{"MT:safely_incr_ref_count(): stackDepth > 0, sn: ",sn,", new ref_count: ",entry.ref_count,"\n"}
   return
end

function M.decr_ref_count(self,sn)
   local entry = self.mT[sn]
   if (entry == nil or not entry.ref_count) then
      dbg.print{"MT:decr_ref_count(): sn: ",sn, ", ref_count: nil\n"}
      return nil
   end
   local ref_count = entry.ref_count - 1
   entry.ref_count = ref_count
   dbg.print{"MT:decr_ref_count(): sn: ",sn, ", ref_count: ",ref_count,"\n"}
   return ref_count
end

function M.get_ref_count(self,sn)
   local entry = self.mT[sn]
   if (entry == nil or not entry.ref_count) then
      return nil
   end
   dbg.print{"MT:get_ref_count(): sn: ",sn, ", ref_count: ",entry.ref_count,"\n"}
   return entry.ref_count
end

function M.get_depends_on_anyA(self,sn)
   local entry = self.mT[sn]
   if (entry == nil or not entry.ref_count) then
      return nil
   end
   return entry.depends_on_anyA
end

function M.save_depends_on_any(self, sn, child_sn)
   local entry = self.mT[sn]
   assert(entry)
   local anyA = entry.depends_on_anyA or {}
   anyA[#anyA + 1] = child_sn
   entry.depends_on_anyA = anyA
end

function M.pop_depends_on_any(self, sn)
   local entry = self.mT[sn]
   assert(entry)
   if (not (entry.depends_on_anyA and next(entry.depends_on_anyA) ~= nil)) then
      return nil
   end
   local child_sn = table.remove(entry.depends_on_anyA,1)
   return child_sn
end

function M.pop_depends_on_any_ck(self,sn)
   dbg.start{"MT:pop_depends_on_any_ck(sn: \"",sn,"\")"}
   local entry = self.mT[sn]
   assert(entry)
   if (not (entry.depends_on_anyA and next(entry.depends_on_anyA) ~= nil)) then
      dbg.fini("MT:pop_depends_on_any_ck with no doA")
      return nil
   end
   if (not entry.__depends_on_any_ckA) then
      entry.__depends_on_any_ckA = deepcopy(entry.depends_on_anyA)
   end
   local child_sn = table.remove(entry.__depends_on_any_ckA,1)
   dbg.print{"child_sn: ",child_sn,"\n"}
   dbg.fini("MT:pop_depends_on_any_ck")
   return child_sn
end


function M.updateMPathA(self, value)
   if (type(value) == "string") then
      local clearDblSlash = true
      self.mpathA         = path2pathA(value,':',clearDblSlash)
   elseif (type(value) == "table") then
      self.mpathA = value
   elseif (type(value) == "nil") then
      self.mpathA = {} -- path2pathA("")
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
local function l_columnList(stream, msg, a)
   local cwidth = optionTbl().rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()
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
      l_columnList(io.stderr,i18n("m_Inactive_Modules",{}), inactiveA)
   end
   if (#activeA > 0) then
      entries = true
      l_columnList(io.stderr,i18n("m_Activate_Modules",{}), activeA)
   end
   if (#reloadA > 0) then
      entries = true
      l_columnList(io.stderr,i18n("m_Reload_Modules",{}), reloadA)
   end
   if (#changedA > 0) then
      entries = true
      l_columnList(io.stderr,i18n("m_Reload_Version_Chng",{}), changedA)
   end

   if (entries) then
      io.stderr:write("\n")
   end

   dbg.fini("MT:reportChanges")
end

--------------------------------------------------------------------------
-- Build the name of the *family* env. variable.
local function l_buildFamilyPrefix()
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
   local familyA = l_buildFamilyPrefix()
   for i = 1,#familyA do
      local n = familyA[i] .. familyNm:upper()
      MCP:setenv{n, mName}
      MCP:setenv{n .. "_VERSION", myModuleVersion()}
   end
   return results
end

--------------------------------------------------------------------------
-- Unset the family
-- @param self An MT object
-- @param familyNm
function M.unsetfamily(self,familyNm)
   local familyA = l_buildFamilyPrefix()
   for i = 1,#familyA do
      local n = familyA[i] .. familyNm:upper()
      MCP:unsetenv{n, ""}
      MCP:unsetenv{n .. "_VERSION", ""}
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

   local luaCmd = findLuaProg()
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
   local l_mt       = l_new(self, s, restoreFn)
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


   mcp:purge{force=true}

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
   s              = self:serializeTbl()
   if (dbg.active()) then
      local ss = self:serializeTbl("pretty")
      dbg.print{"mt after purge",ss,"\n"}
   end
   local envMT = build_MT_envT(s)
   for k,v in pairs(envMT) do
      posix_setenv(k,v,true)
   end


   s_mt = false
   __removeEnvMT()

   local varT = frameStk:varT()
   FrameStk:__clear()
   dbg.print{"Setting MODULEPATH to: ",savedMPATH,"\n"}
   posix_setenv(ModulePath, savedMPATH, true)
   frameStk = FrameStk:singleton{varT = varT}
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
   --local mcp_old = mcp
   mcpStack:push(mcp)
   mcp           = MainControl.build("mgrload","load")

   -----------------------------------------------
   -- Normally we load the user name which means
   -- that defaults will be followed.  However
   -- some sites/users wish to use the fullname
   -- and not follow defaults.
   local pin_versions = cosmic:value("LMOD_PIN_VERSIONS")
   local knd          = (pin_versions == "no") and "userName" or "fullName"
   local mA           = {}

   -- remember to transfer the old stackDepth to the new mname object.
   -- If a dependent module is loaded, it gets a one less reference count
   -- (and not zero).  The reason is that collections are loaded by a MgrLoad
   -- Therefore a dependent module load is only seen once.  In a "Mgrload"
   -- depends_on() function is a fake load.
   for i = 1, #activeA do
      local mname = MName:new("load",activeA[i][knd])
      local ref_count = activeA[i].ref_count
      if (ref_count) then
         ref_count = ref_count - 1
      end
      mname:set_depends_on_anyA(activeA[i].depends_on_anyA)
      mname:set_depends_on_flag(activeA[i].ref_count)
      mname:set_ref_count(ref_count)
      mname:setStackDepth(activeA[i].stackDepth)
      mA[#mA+1]   = mname
   end
   dbg.print{"Running MCP.load(mcp, mA)\n"}
   MCP.load(mcp,mA)
   --mcp        = mcp_old
   mcp        = mcpStack:pop()
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   mt         = frameStk:mt()
   local varT = frameStk:varT()
   varT[ModulePath]:set_ref_countT(l_mt.mpathRefCountT or {})

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
         t[sn]     = nil -- do not need to check hash for a non-existent module
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

function M.extractModulesFiles(self)
   local a = self:list("fullName","active")
   local loadA = {}
   local fileA = {}
   local status = true
   for i = 1,#a do
      loadA[#loadA+1] = a[i].fullName
      fileA[#fileA+1] = a[i].fn
   end
   local loadStr = nil
   local fileStr = nil
   if (next (loadA) ~= nil) then
      loadStr = concatTbl(loadA,":")
      fileStr = concatTbl(fileA,":")
   end

   local oldV = getenv("LOADEDMODULES")
   dbg.print{"RTM: oldV: ",oldV,", loadStr: ",loadStr,"\n"}

   if (oldV == loadStr) then
      status = false
   elseif (oldV and not loadStr) then
      loadStr = nil
      fileStr = nil
   end
   return status, loadStr, fileStr
end


function M.setMpathRefCountT(self, refCountT)
   self.mpathRefCountT = refCountT
end
function M.hideMpathRefCountT(self, refCountT)
   self.mpathRefCountT = nil
end

function M.resetMPATH2system(self)
   local clearDblSlash = true
   self.mpathA         = path2pathA(self.systemBaseMPATH,':',clearDblSlash)
   return self.systemBaseMPATH
end

function M.name_w_possible_alias(self, entry, kind)
   local moduleName = entry.fullName
   if (kind ~= "terse") then
      moduleName    = hook.apply("colorize_fullName", moduleName, entry.sn) or moduleName
   end

   if (entry.origUserName) then
      if (kind == "terse") then
         moduleName = entry.fullName .. "\n" .. entry.origUserName
      else
         moduleName = entry.origUserName .. " -> " .. moduleName
      end
   end
   return moduleName
end

------------------------------------------------------------------------
-- Register Downstream conflicts
function M.registerConflicts(self, mname, mA)
   if (dbg.active()) then
      local s = mAList(mA)
      dbg.start{"MT:registerConflicts(sn:", mname:sn(),",mA={"..s.."})"}
   end
   local sn = mname:sn()
   local a  = deepcopy(mA)
   local A  = self.__conflictT[sn] or {}
   for i = 1,#a do
      A[#A+1] = a[i]
   end
   self.__conflictT[sn] = A
   dbg.fini("MT:registerConflicts")
end
------------------------------------------------------------------------
-- Unregister Downstream conflicts
function M.removeConflicts(self, mname)
   local sn = mname:sn()
   if (dbg.active()) then
      dbg.start{"MT:removeConflicts(sn:", sn,")"}
   end
   self.__conflictT[sn] = nil
   dbg.fini("MT:removeConflicts")
end

function M.haveDSConflict(self, mnameIn)
   if (dbg.active()) then
      local snIn   = mnameIn:sn()
      dbg.start{"MT:haveDSConflict(sn:", snIn,")"}
   end

   local cT    = self.__conflictT
   local MName = require("MName")
   for sn, vv in pairs(cT) do
      dbg.print{"upstreamSn: ",sn,"\n"}
      for i = 1,#vv do
         local conflict_mname = vv[i]
         dbg.print{"conflict_mname:userName(): ",conflict_mname:userName(),"\n"}
         local userName_in_MT = self:lookup_w_userName(conflict_mname:userName())
         dbg.print{"userName_in_MT: ",userName_in_MT,"\n"}
         if (self:lookup_w_userName(conflict_mname:userName())) then
            local snUpstream  = conflict_mname:downstreamConflictCk(mnameIn)
            if (snUpstream) then
               return sn
            end
         end
      end
   end

   dbg.fini("MT:haveDSConflict")
   return false
end


return M
