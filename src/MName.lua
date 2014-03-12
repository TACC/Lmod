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
-- MName: This class manages module names.  It turns out that a module
--        name is more complicated only Lmod started supporting
--        category/name/version style module names.  Lmod automatically
--        figures out what the "name", "full name" and "version" are.
--        The "MT:locationTbl()" knows the 3 components for modules that
--        can be loaded.  On the other hand, "MT:exists()" knows for
--        modules that are already loaded.

--        The problem is when a user gives a module name on the command
--        line.  It can be the short name or the full name.  The trouble
--        is that if the user gives "foo/bar" as a module name, it is
--        quite possible that "foo" is the name and "bar" is the version
--        or "foo/bar" is the short name.  The only way to know is to
--        consult either choice above.
--
--        Yet another problem is that a module that is loaded may not be
--        in the module may not be available to load because the
--        MODULEPATH has changed.  Or if you are loading a module then it
--        must be in the locationTbl.  So clients using this class must
--        specify to the ctor that the name of the module is one that will
--        be loaded or one that has been loaded.
--
--        Another consideration is that Lmod only allows for one "name"
--        to be loaded at a time.

require("strict")
require("utils")
require("inherits")

local M           = {}
local MT          = require("MT")
local dbg         = require("Dbg"):dbg()
local lfs         = require("lfs")
local huge        = math.huge
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack
local posix       = require("posix")
local sort        = table.sort
MName             = M
--------------------------------------------------------------------------
-- shorten(): This function allows for taking the name and remove one
--            level at a time.  Lmod rules require that if a module is
--            loaded or available, that the "short" name is either
--            the name given or one level removed.  So checking for
--            a "a/b/c/d" then the short name is either "a/b/c/d" or
--            "a/b/c".  It can't be "a/b" and the version be "c/d".
--            In other words, the "version" can only be one component,
--            not a directory/file.  This function can only be called
--            with level = 0 or 1.

local function shorten(name, level)
   if (level == 0) then
      return name
   end

   local i,j = name:find(".*/")
   j = (j or 0) - 1
   return name:sub(1,j)
end

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


function M.action(self)
   return self._action
end

--------------------------------------------------------------------------
-- MName:new(): This ctor takes "sType" to lookup in either the
--              locationTbl() or the exists() depending on whether it is
--              "load" for modules to be loaded (available) or it is
--              already loaded.  Knowing the short name it is possible to
--              figure out the version (if one exists).  If the module name
--              doesn't exist then the short name (sn) and version are set
--              to false.  The last argument is "action".  Normally this
--              argument is nil, which implies the value is "match".  Other
--              choices are "atleast", ...

s_findT = false
function M.new(self, sType, name, action, is, ie)

   if (not s_findT) then
      local Match    = require("MN_Match")
      local Latest   = require("MN_Latest")
      local Between  = require("MN_Between")

      local findT   = {}
      findT["match"]   = Match
      findT["latest"]  = Latest
      findT["between"] = Between
      findT["atleast"] = Between
      s_findT          = findT
   end

   if (not action) then
      action = masterTbl().latest and "latest" or "match"
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
      name    = (name or ""):gsub("/+$","")  -- remove any trailing '/'
      o._name = name
   end
   o._action   = action
   o._is       = is or ''
   o._ie       = ie or tostring(1234567890)
   o._range    = {}
   o._range[1] = is
   if (ie ) then
      o._range[2] = ie
   end

   o._actName = action

   return o
end

--------------------------------------------------------------------------
-- MName:buildA(...): Return an array of MName objects

function M.buildA(self,sType, ...)
   local arg = pack(...)
   local a = {}

   for i = 1, arg.n do
      local v = arg[i]
      if (type(v) == "string" ) then
         a[#a + 1] = self:new(sType, v)
      elseif (type(v) == "table") then
         a[#a + 1] = v
      end
   end
   return a
end

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

local function lazyEval(self)
   local sType = self._sType
   if (sType == "entryT") then
      local t       = self._input
      self._sn      = t.sn
      self._version = extractVersion(t.fullName, t.sn)
      return
   end

   local mt   = MT:mt()
   local name = self._name
   if (sType == "load") then
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
-- MName:sn(): Return the short name

function M.sn(self)
   if (not self._sn) then
      lazyEval(self)
   end

   return self._sn
end

--------------------------------------------------------------------------
-- MName:usrName(): Return the user specified name.  It could be the
--                  short name or the full name.

function M.usrName(self)
   return self._name
end

--------------------------------------------------------------------------
-- MName:version(): Return the version for the module.  Note that the
--                  version is nil if not known.

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
-- followDefault(): This local function is used to find a default file
--                  that maybe in symbolic link chain. This returns
--                  the absolute path.

local function followDefault(path)
   if (path == nil) then return nil end
   dbg.start{"followDefault(path=\"",path,"\")"}
   local attr      = lfs.symlinkattributes(path)
   local result    = path
   local accept_fn = accept_fn

   if (attr == nil) then
      result = nil
   elseif (attr.mode == "link") then
      local rl = posix.readlink(path)
      local a  = {}
      local n  = 0
      for s in path:split("/") do
         n = n + 1
         a[n] = s or ""
      end

      a[n] = ""
      local i  = n
      for s in rl:split("/") do
         if (s == "..") then
            i = i - 1
         else
            a[i] = s
            i    = i + 1
         end
      end
      result = concatTbl(a,"/")
   end
   dbg.print{"result: ",result,"\n"}
   dbg.fini("followDefault")
   if (not accept_fn(result)) then
      result = false
   end
   return result
end

function M.find_exact_match(self, pathA)
   dbg.start{"MName:find_exact_match(pathA, t)"}
   local usrName    = self:usrName()
   dbg.print{"UserName: ", usrName , "\n"}
   local t          = { fn = nil, modFullName = nil, modName = nil, default = 0}
   local found      = false
   local result     = nil
   local fullName   = ""
   local modName    = ""
   local sn         = self:sn()
   local searchExtT = accept_extT()
   local numExts    = #searchExtT

   for ii = 1, #pathA do
      local vv    = pathA[ii]
      local mpath = vv.mpath
      local fn    = pathJoin(vv.file, self:version())
      found       = false
      result      = nil

      for i = 1, numExts do
         local v        = searchExtT[i]
         local f        = fn .. v
         local attr     = lfs.attributes(f)
         local readable = posix.access(f,"r")

         if (readable and attr and attr.mode == "file") then
            result = f
            found  = true
            break;
         end
      end

      if (found) then
         local _, j = result:find(mpath, 1, true)
         fullName  = result:sub(j+2):gsub("%.lua$","")
         dbg.print{"fullName: ",fullName,"\n"}
         dbg.print{"found:", found, " fn: ",fn,"\n"}
         break
      end
   end


   if (found) then
      t.fn          = result
      t.modFullName = fullName
      t.modName     = sn
      dbg.print{"modName: ",sn," fn: ", result," modFullName: ", fullName,
                " default: ",t.default,"\n"}
   else
      dbg.print{"Did not find: ",usrName,"\n"}
   end

   dbg.fini("MName:find_exact_match")
   return found, t
end



--------------------------------------------------------------------------
-- followDotVersion(): This local function takes the file pointed to by the 
--                     .version file and looks to see if that file exists
--                     in the current mpath directory.  Note that this file
--                     might have a .lua extension.

local function followDotVersion(mpath, sn, version)
   local accept_fn  = accept_fn
   local fn         = pathJoin(mpath, sn, version)
   local searchExtT = accept_extT()
   local numExts    = #searchExtT
   local result     = nil

   for i = 1, numExts do
      local v        = searchExtT[i]
      local f        = fn .. v
      local attr     = lfs.attributes(f)
      local readable = posix.access(f,"r")

      if (readable and attr and attr.mode == "file") then
         result = f
         break
      end
   end

   return result
end


searchDefaultT = { "/default", "/.version" }

function M.find_marked_default(self, pathA)
   dbg.start{"MName:find_marked_default(pathA, t)"}
   local usrName   = self:usrName()
   local sn        = self:sn()
   local accept_fn = accept_fn
   local t         = { fn = nil, modFullName = nil, modName = nil, default = 0}
   local found     = false
   local result    = nil
   local fullName  = ""
   local modName   = ""
   local Master    = Master

   dbg.print{"usrName: ", usrName, "\n"}
   dbg.print{"sn:      ", sn, "\n"}
   if (sn ~= usrName) then
      dbg.print{"Sn and user name do not match\n"}
      return found, t
   end
      
   for ii = 1, #pathA do
      local vv    = pathA[ii]
      local mpath = vv.mpath
      local fn    = vv.file
      found       = false
      result      = nil

      for i = 1, 2 do
         local v        = searchDefaultT[i]
         local f        = fn .. v
         local attr     = lfs.attributes(f)
         local readable = posix.access(f,"r")

         if (readable and attr and attr.mode == "file") then
            result = f
            if (v == "/default") then
               result    = followDefault(result)
               if (result) then
                  t.default = 1
                  found  = true
                  break
               end
            elseif (v == "/.version") then
               local vf = Master.versionFile(result)
               if (vf and accept_fn(vf)) then
                  result = followDotVersion(mpath, sn, vf)
                  if (result) then
                     t.default = 1
                     t.fn      = result
                     dbg.print {"(1) .version: result: ", result,"\n"}
                     found     = true
                     break;
                  end
               end
            end
         end
      end
      if (found) then
         dbg.print{"%%RTM%% result: ",result,", mpath: ",mpath,"\n"}
         local _, j = result:find(mpath, 1, true)
         fullName  = result:sub(j+2):gsub("%.lua$","")
         dbg.print{"fullName: ",fullName,", fn: ",fn,"\n"}
         break
      end
   end

   if (found) then
      t.fn          = result
      t.modFullName = fullName
      t.modName     = self:sn()
      dbg.print{"modName: ",sn," fn: ", result," modFullName: ", fullName,
                " default: ",t.default,"\n"}
   end

   dbg.fini("MName:find_marked_default")
   return found, t
end

function M.find_latest(self, pathA)
   dbg.start{"MName:find_latest(pathA, t)"}
   local found     = false
   local t         = { fn = nil, modFullName = nil, modName = nil, default = 0}
   local usrName   = self:usrName()
   local sn        = self:sn()
   dbg.print{"usrName: ", usrName, "\n"}
   dbg.print{"sn:      ", sn, "\n"}
   if (sn ~= usrName) then
      dbg.print{"Sn and user name do not match\n"}
      dbg.fini("MName:find_latest")
      return found, t
   end


   local result    = nil
   local fullName  = ""
   local modName   = ""
   local Master    = Master


   result          = lastFileInPathA(pathA)
   if (result) then
      local file    = result.file
      local _, j    = file:find(result.mpath, 1, true)
      t.modFullName = file:sub(j+2):gsub("%.lua$","")
      found         = true
      t.default     = 1
      t.fn          = file
      t.modName     = sn
      dbg.print{"modName: ",sn," fn: ", file," modFullName: ", t.modFullName,
                " default: ",t.default,"\n"}
   end

   dbg.fini("MName:find_latest")
   return found, t
end

function M.find_marked_default_between(self, pathA)
   dbg.start{"MName:find_marked_default_between(pathA, t)"}

   local t     = { fn = nil, modFullName = nil, modName = nil, default = 0}
   local found = false

   found, t = self:find_marked_default(pathA, t)

   local left       = parseVersion(self._is)
   local right      = parseVersion(self._ie)
   local version    = extractVersion(t.modFullName, t.modName)
   local pv         = parseVersion(version)
   if (pv < left or  pv > right) then
      found     = false
      t.default = 0
      t.fn      = nil
   end

   dbg.fini("MName:find_marked_default_between")
   return found, t
end

function M.find_between(self, pathA)
   dbg.start{"MName:find_between(pathA, t)"}
   dbg.print{"UserName: ", self:usrName(), "\n"}

   local t     = { fn = nil, modFullName = nil, modName = nil, default = 0}
   local found = false
   local a     = allVersions(pathA)

   sort(a, function(a,b)
             if (a.pv == b.pv) then
                return a.idx < b.idx
             else
                return a.pv < b.pv
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
      found         = true
   end

   dbg.fini("MName:find_between")
   return found, t
end

function M.show(self)
   return '"' .. self:usrName() .. '"'
end


function M.find(self)
   dbg.start{"MName:find(",self:usrName(),")"}
   local t        = { fn = nil, modFullName = nil, modName = nil, default = 0}
   local mt       = MT:mt()
   local fullName = ""
   local modName  = ""
   local sn       = self:sn()
   local Master   = Master
   dbg.print{"MName:find sn: ",sn,"\n"}

   local pathA = mt:locationTbl(sn)
   if (pathA == nil or #pathA == 0) then
      dbg.print{"did not find key: \"",sn,"\" in mt:locationTbl()\n"}
      dbg.fini("MName:find")
      return t
   end

   local found = false
   local stepA = self:steps()
   for i = 1, #stepA do
      local func = stepA[i]
      found, t   = func(self, pathA)
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
