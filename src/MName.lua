--------------------------------------------------------------------------
--  This class manages module names.  It turns out that a module
--  name is more complicated only Lmod started supporting
--  category/name/version style module names.  Lmod automatically
--  figures out what the "name", "full name" and "version" are.
--  The "MT:locationTbl()" knows the 3 components for modules that
--  can be loaded.  On the other hand, "MT:exists()" knows for
--  modules that are already loaded.
--
--  The problem is when a user gives a module name on the command
--  line.  It can be the short name or the full name.  The trouble
--  is that if the user gives "foo/bar" as a module name, it is
--  quite possible that "foo" is the name and "bar" is the version
--  or "foo/bar" is the short name.  The only way to know is to
--  consult either choice above.
--
--  Yet another problem is that a module that is loaded may not be
--  in the module may not be available to load because the
--  MODULEPATH has changed.  Or if you are loading a module then it
--  must be in the locationTbl.  So clients using this class must
--  specify to the ctor that the name of the module is one that will
--  be loaded or one that has been loaded.
--
--  Another consideration is that Lmod only allows for one "name"
--  to be loaded at a time.
--
--  @classmod MName

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

require("utils")
require("inherits")

_G._DEBUG         = false   -- Required by the new lua posix
local M           = {}
local MT          = require("MT")
local dbg         = require("Dbg"):dbg()
local lfs         = require("lfs")
local huge        = math.huge
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack
local posix       = require("posix")
local sort        = table.sort
local malias      = require("MAlias"):build()
local concatTbl   = table.concat
MName             = M
--------------------------------------------------------------------------
-- This function allows for taking the name and remove one
-- level at a time.  Lmod rules require that if a module is
-- loaded or available, that the "short" name is either
-- the name given or one level removed.  So checking for
-- a "a/b/c/d" then the short name is either "a/b/c/d" or
-- "a/b/c".  It can't be "a/b" and the version be "c/d".
-- In other words, the "version" can only be one component,
-- not a directory/file.  This function can only be called
-- with level = 0 or 1.

local function shorten(name, level)
   if (level == 0) then
      return name
   end

   local i,j = name:find(".*/")
   j = (j or 0) - 1
   return name:sub(1,j)
end

--------------------------------------------------------------------------
-- Do a prereq check to see name and/or version is loaded.
-- @param self A MName object
function M.prereq(self)
   local result  = false
   local mt      = MT:mt()
   local sn      = self:sn()
   local version = self:version()
   local full    = mt:fullName(sn)

   if (  ( not mt:have(sn,"active")) or
         ( version and full ~= self:usrName())) then
      result = self:usrName()
   end
   return result
end

--------------------------------------------------------------------------
-- Check to see if this object is loaded.
-- @param self A MName object
function M.isloaded(self)
   local mt        = MT:mt()
   local sn        = self:sn()
   local sn_active = mt:have(sn, "active")
   if (not sn_active) then
      return self:isPending()
   end
   local usrName   = self:usrName()
   if (usrName == sn) then
      return sn_active
   end
   return (usrName == mt:fullName(sn)) and sn_active
end

--------------------------------------------------------------------------
-- Check to see if the isPending module is pending.
-- @param self A MName object
function M.isPending(self)
   local mt         = MT:mt()
   local sn         = self:sn()
   local sn_pending = mt:have(sn,"pending")
   local usrName    = self:usrName()
   if (usrName == sn) then
      return sn_pending
   end
   return (usrName == mt:fullName(sn)) and sn_pending
end
--------------------------------------------------------------------------
-- Returns the "action", It can be "match", "between" or "latest".
-- @param self A MName object
function M.action(self)
   return self._action
end

s_findT = false
--------------------------------------------------------------------------
-- This ctor takes "sType" to lookup in either the
-- locationTbl() or the exists() depending on whether it is
-- "load" for modules to be loaded (available) or it is
-- already loaded.  Knowing the short name it is possible to
-- figure out the version (if one exists).  If the module name
-- doesn't exist then the short name (sn) and version are set
-- to false.  The last argument is "action".  Normally this
-- argument is nil, which implies the value is "match".  Other
-- choices are "atleast", ...
--
-- @param self A MName object
-- @param sType The type which can be "entryT", "load", "mt"
-- @param name The name of the module.
-- @param[opt] action The matching action if not nil it can be
-- "atleast", "between" or "latest".
-- @param[opt] is start version.
-- @param[opt] ie end version.
-- @return An MName object
function M.new(self, sType, name, action, is, ie)

   if (not s_findT) then
      local Match    = require("MN_Match")
      local Latest   = require("MN_Latest")
      local Between  = require("MN_Between")
      local Exact    = require("MN_Exact")

      local findT      = {}
      findT["exact"]   = Exact
      findT["match"]   = Match
      findT["latest"]  = Latest
      findT["between"] = Between
      findT["atleast"] = Between
      s_findT          = findT
   end

   local default_action = (LMOD_EXACT_MATCH == "yes") and "exact" or "match"



   if (not action) then
      action = masterTbl().latest and "latest" or default_action
   end
   local o = s_findT[action]:create()

   o._sn        = false
   o._version   = false
   o._sType     = sType
   o._input     = name
   o._waterMark = "MName"
   if (sType == "entryT" ) then
      local t = name
      o._name = t.userName
   else
      o._name = (name or ""):trim():gsub("/+$","")  -- remove any trailing '/'
   end
   o._action   = action
   o._is       = is or ''
   o._ie       = ie or tostring(99999999)
   o._range    = {}
   o._range[1] = is
   o._range[2] = ie -- This can be nil and that is O.K.

   o._actName = action

   return o
end

--------------------------------------------------------------------------
-- Return an array of MName objects
-- @param self A MName object
-- @param sType The type which can be "entryT", "load", "mt"
-- @return An array of MName objects.
function M.buildA(self,sType, ...)
   local arg = pack(...)
   local a = {}

   for i = 1, arg.n do
      local v = arg[i]
      if (type(v) == "string" ) then
         a[#a + 1] = self:new(sType, v:trim())
      elseif (type(v) == "table") then
         a[#a + 1] = v
      end
   end
   return a
end

--------------------------------------------------------------------------
-- Convert an array of MName objects into a string.
-- @param self A MName object
function M.convert2stringA(self, ...)
   local arg = pack(...)
   local a = {}
   for i = 1, arg.n do
      local v      = arg[i]
      local action = v.action()
      if (action == "match") then
         a[#a+1] = '"' .. v:usrName() .. '"'
      else
         local b = {}
         b[#b+1] = action
         b[#b+1] = '("'
         b[#b+1] = v.sn()
         b[#b+1] = '","'
         b[#b+1] = v.version()
         b[#b+1] = '")'
         a[#a+1] = concatTbl(b,"")
      end
   end

   return a
end

--------------------------------------------------------------------------
-- Based on *sType* finish constructing the MName object.
-- @param self A MName object
local function lazyEval(self)
   local sType = self._sType
   if (sType == "entryT") then
      local t       = self._input
      self._sn      = t.sn
      self._version = extractVersion(t.fullName, t.sn)
      return
   end

   local mt   = MT:mt()

   ------------------------------------------------------------------------
   -- Must resolve user name which might be an alias to a real module name

   local name = self._name
   if (sType == "load") then
      self._name = malias:resolve(self._name)
      name       = self._name
      for level = 0, 1 do
         local n = shorten(name, level)
         if (mt:locationTbl(n)) then
            self._sn      = n
            break
         end
      end
   else
      for level = 0, 1 do
         local n = shorten(name, level)
         if (mt:exists(n)) then
            self._sn      = n
            self._version = mt:Version(n)
            break
         end
      end
   end

   if (self._sn and not self._version) then
      self._version = extractVersion(self._name, self._sn)
   end
end


--------------------------------------------------------------------------
-- Return the short name
-- @param self A MName object
function M.sn(self)
   if (not self._sn) then
      lazyEval(self)
   end

   return self._sn
end

--------------------------------------------------------------------------
-- Return the user specified name.  It could be the
-- short name or the full name.
-- @param self A MName object
function M.usrName(self)
   return self._name
end

--------------------------------------------------------------------------
-- Return the version for the module.  Note that the
-- version is nil if not known.
-- @param self A MName object
function M.version(self)
   dbg.start{"MName:version()"}
   dbg.print{"sType:   ", self._sType,"\n"}
   if (self._sn == false) then
      lazyEval(self)
   end
   dbg.print{"sn:      ", self._sn,"\n"}
   dbg.print{"name:    ", self._name,"\n"}
   dbg.print{"version: ", self._version,"\n"}

   if ((self._sn and self._sn == self._name) and
       (self._sType == "load" or self._sType == "userName")) then
      dbg.fini("MName:version")
      return nil
   end
   if (not self._version) then
      lazyEval(self)
   end
   dbg.fini("MName:version")
   return self._version
end

--------------------------------------------------------------------------
-- Build the initial table for reporting a module file location.
-- @return the initial table.
local function module_locationT()
   return { fn = nil, modFullName = nil, modName = nil, version = nil, default = 0}
end

--------------------------------------------------------------------------
-- Look for the module name via an exact match.
-- @param self A MName object
-- @param pathA An array of paths to search
-- @return True or false
-- @return A table describing the module if found.
function M.find_exact_match(self, pathA)
   dbg.start{"MName:find_exact_match(pathA, t)"}
   local usrName    = self:usrName()
   dbg.print{"UserName: ", usrName , "\n"}
   local t          = module_locationT()
   local found      = false
   local result     = nil
   local fullName   = ""
   local sn         = self:sn()

   for ii = 1, #pathA do
      local vv       = pathA[ii]
      local mpath    = vv.mpath
      local versionT = vv.versionT
      local version  = self:version() or 0

      local fn       = versionT[version]
      if (fn) then
         result = fn
         local _, j = result:find(mpath, 1, true)
         found      = true
         fullName   = result:sub(j+2):gsub("%.lua$","")
         dbg.print{"fullName: ",fullName,"\n"}
         dbg.print{"found:    ",found, " fn: ",fn,"\n"}
         break
      end
   end

   if (found) then
      t.fn          = result
      t.modFullName = fullName
      t.modName     = sn
      t.version     = extractVersion(t.modFullName, t.modName)
      dbg.print{"modName: ",sn," fn: ", result," modFullName: ", fullName,
                " default: ",t.default,"\n"}
   else
      dbg.print{"Did not find: ",usrName,"\n"}
   end

   dbg.fini("MName:find_exact_match")
   return found, t
end



--------------------------------------------------------------------------
-- Look for the module name via a marked default.
-- @param self A MName object
-- @param pathA An array of paths to search
-- @return True or false
-- @return A table describing the module if found.
function M.find_default(self, pathA, defaultEntry)
   dbg.start{"MName:find_default(pathA, t)"}
   local t        = module_locationT()
   if (self:version()) then
      return false, t
   end
   local found    = true
   t.fn           = defaultEntry.fn
   t.modFullName  = defaultEntry.fullName
   t.modName      = self:sn()
   t.default      = 1
   t.version      = extractVersion(t.modFullName, t.modName)
   dbg.print{"modName: ",t.modName," fn: ", t.fn," modFullName: ", t.modFullName,
             " default: ",t.default," version: ",t.version,"\n"}
   dbg.fini("MName:find_default")
   return found, t
end

--------------------------------------------------------------------------
-- Look for the module name via the "latest" version.
-- @param self A MName object
-- @param pathA An array of paths to search
-- @return True or false
-- @return A table describing the module if found.
function M.find_latest(self, pathA)
   dbg.start{"MName:find_latest(pathA, t)"}
   local found     = false
   local t         = module_locationT()
   local usrName   = self:usrName()
   local sn        = self:sn()
   dbg.print{"usrName: ", usrName, "\n"}
   dbg.print{"sn:      ", sn, "\n"}
   if (sn ~= usrName) then
      dbg.print{"Sn and user name do not match\n"}
      dbg.fini("MName:find_latest")
      return found, t
   end

   local fullName  = ""
   local modName   = ""
   local result    = lastFileInPathA(pathA)

   if (result) then
      local file    = result.file
      local _, j    = file:find(result.mpath, 1, true)
      t.modFullName = file:sub(j+2):gsub("%.lua$","")
      found         = true
      t.default     = 0
      t.fn          = file
      t.modName     = sn
      t.version     = extractVersion(t.modFullName, t.modName)
      dbg.print{"modName: ",sn," fn: ", file," modFullName: ", t.modFullName,
                " default: ",t.default," version: ",t.version,"\n"}
   end

   dbg.fini("MName:find_latest")
   return found, t
end

--------------------------------------------------------------------------
-- Look for the module name where the version is "between" and is a marked
-- default.
-- @param self A MName object
-- @param pathA An array of paths to search
-- @return True or false
-- @return A table describing the module if found.
function M.find_default_between(self, pathA, defaultEntry)
   dbg.start{"MName:find_marked_default_between(pathA, t)"}

   local t     = module_locationT()
   local found = false

   found, t = self:find_default(pathA, defaultEntry)

   local left       = parseVersion(self._is)
   local right      = parseVersion(self._ie)
   local version    = t.version
   local pv         = parseVersion(version)

   if (pv < left or  pv > right) then
      found     = false
      t.default = 0
      t.fn      = nil
   end

   dbg.print{"left:    ",left,"\n"}
   dbg.print{"right:   ",right,"\n"}
   dbg.print{"version: ",version,"\n"}
   dbg.print{"pv:      ",pv,"\n"}
   dbg.print{"default: ",t.default,"\n"}
   dbg.fini("MName:find_marked_default_between")
   return found, t
end

--------------------------------------------------------------------------
-- Look for the module name where the version is "between".
-- @param self A MName object
-- @param pathA An array of paths to search
-- @return True or false
-- @return A table describing the module if found.
function M.find_between(self, pathA)
   dbg.start{"MName:find_between(pathA, t)"}
   dbg.print{"UserName: ", self:usrName(), "\n"}

   local t     = module_locationT()
   local found = false
   local a     = allVersions(pathA)

   sort(a, function(x,y)
             if (x.pv == y.pv) then
                return x.idx < y.idx
             else
                return x.pv  < y.pv
             end
           end
   )

   local left       = parseVersion(self._is)
   local right      = parseVersion(self._ie)

   local idx        = false
   for i = #a, 1, -1 do
      local v = a[i]
      if (left <= v.pv and v.pv <= right) then
         idx = i
         break
      end
   end

   if (idx ) then
      local v       = a[idx]
      t.fn          = v.file
      local _, j    = v.file:find(v.mpath, 1, true)
      t.modFullName = v.file:sub(j+2):gsub("%.lua$","")
      t.default     = 0
      t.modName     = self:sn()
      t.version     = extractVersion(t.modFullName, t.modName)
      found         = true
   end

   dbg.fini("MName:find_between")
   return found, t
end

--------------------------------------------------------------------------
-- Return the string of the user name of the module.
-- @param self A MName object
function M.show(self)
   return '"' .. self:usrName() .. '"'
end


--------------------------------------------------------------------------
-- Find the module based on the "steps" each class has registered.
-- @param self A MName object
-- @return A table describing the module.
function M.find(self)
   dbg.start{"MName:find(",self:usrName(),")"}
   local t        = module_locationT()
   local mt       = MT:mt()
   local fullName = ""
   local modName  = ""
   local sn       = self:sn()
   dbg.print{"MName:find sn: ",sn,"\n"}

   local pathA, defaultEntry = mt:locationTbl(sn)
   if (pathA == nil or #pathA == 0) then
      dbg.print{"did not find key: \"",sn,"\" in mt:locationTbl()\n"}
      dbg.fini("MName:find")
      return t
   end

   local found = false
   local stepA = self:steps()
   for i = 1, #stepA do
      local func = stepA[i]
      found, t   = func(self, pathA, defaultEntry)
      dbg.print{"(1) t.fn: ", t.fn, "\n"}
      if (found) then
         break
      end
   end

   dbg.print{"(2) t.fn: ", t.fn, "\n"}

   dbg.fini("MName:find")
   return t
end

return M
