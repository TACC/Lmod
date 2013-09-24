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

local M    = {}
local dbg  = require("Dbg"):dbg()
local MT   = require("MT")
local pack = (_VERSION == "Lua 5.1") and argsPack or table.pack

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

--------------------------------------------------------------------------
-- MName:new(): This ctor takes "sType" to lookup in either the
--              locationTbl() or the exists() depending on whether it is
--              "load" for modules to be loaded (available) or it is
--              already loaded.  Knowing the short name it is possible to
--              figure out the version (if one exists).  If the module name
--              doesn't exist then the short name (sn) and version are set 
--              to false.  The last argument is "action".  Normally this
--              argument is nil, which implies the value is "equal".  Other
--              choices are "atleast", ...

function M.new(self, sType, name, action)
   local o = {}
   setmetatable(o,self)
   self.__index = self

   o._sn      = false
   o._version = false
   o._sType   = sType
   o._input   = name
   if (sType == "entryT" ) then
      local t = name
      o._name = t.userName
   else
      name    = (name or ""):gsub("/+$","")  -- remove any trailing '/'
      o._name = name
   end
   o._action  = action or "equal"
   return o
end

--function M.new(self, sType, name, action)
--   local o = {}
--   setmetatable(o,self)
--   self.__index = self
--   local mt = MT:mt()
--
--   local sn      = false
--   local version = false
--
--   if (sType == "entryT") then
--      local t = name
--      sn      = t.sn
--      name    = t.userName
--      version = extractVersion(t.fullName, sn)
--   else
--      name    = (name or ""):gsub("/+$","")  -- remove any trailing '/'
--      if (sType == "load") then
--         for level = 0, 1 do
--            local n = shorten(name, level)
--            if (mt:locationTbl(n)) then
--               sn = n
--               break
--            end
--         end
--      elseif(sType == "userName") then
--         if (mt:exists(name)) then
--            sn      = name
--            name    = name
--         else
--            local n = shorten(name, 1)
--            if (mt:exists(n) )then
--               sn = n
--            end
--         end
--      else
--         for level = 0, 1 do
--            local n = shorten(name, level)
--            if (mt:exists(n)) then
--               sn      = n
--               version = mt:Version(sn)
--               break
--            end
--         end
--      end
--   end
--
--   if (sn) then
--      o._sn       = sn
--      o._name     = name
--      o._version  = version or extractVersion(name, sn)
--      o.watermark = "Lmod"
--   end
--
--   return o
--end

--------------------------------------------------------------------------
-- MName:buildA(...): Return an array of MName objects

function M.buildA(self,sType, ...)
   local arg = pack(...)
   local a = {}

   for i = 1, arg.n do
      local v = arg[i]
      if (type(v) == "string" ) then
         a[#a + 1] = self:new(sType, v, "equal")
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
      if (action == "equal") then
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
   dbg.start("lazyEval(self)")
   local sType = self._sType
   if (sType == "entryT") then
      local t       = self._input
      self._sn      = t.sn
      self._version = extractVersion(t.fullName, t.sn)
      dbg.fini("lazyEval")
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
   dbg.fini("lazyEval")
end


--------------------------------------------------------------------------
-- MName:sn(): Return the short name

function M.sn(self)
   if (not self._sn) then
      dbg.start("MName:sn()")
      lazyEval(self)
      dbg.fini("MName:sn")
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
   if (self._sn and self._sn == self._name) then return end
   if (not self._version) then
      dbg.start("MName:version()")
      lazyEval(self)
      dbg.fini("MName:version")
   end
   return self._version
end

return M


