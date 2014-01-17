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
-- Var:  This class is manages the hash table that stores the "environment"
--       variables that Lmod controls.  Each instant of Var holds a single
--       environment variable, path, local variable, shell function or alias.
--       This class is at the core of Lmod.  Lmod is all about controlling
--       the user environment and this is where Lmod does this.
--
--       The other point of this class is to check to see when MODULEPATH
--       has changed.

--------------------------------------------------------------------------
-- PATH Variables:
--------------------------------------------------------------------------
-- Storing PATH variables is complicated.  Each time a path variable is
-- encountered,  it is split apart into a hash table - array structure.
-- Assuming PATH="/u/bin:/u/l/bin:/u/bin" then self.tbl contains:
--
--   self.tbl["/u/bin"]   = { 1, 3 }
--   self.tbl["/u/l/bin"] = { 2 }
--
-- Obviously the each key is the path.  The values are a weight that
-- represents where it will appear when expanded back into a path-like
-- environment variable.  If "/u/l/bin" is removed then there will be a
-- gap in the values.  Each time a path is prepended it inserts a lower
-- value.  Appending adds a higher value.  So prepending "/a/b" and
-- appending "/d/e" results in:
--
--   self.tbl["/u/bin"]   = { 1, 3 }
--   self.tbl["/u/l/bin"] = { 2 }
--   self.tbl["/a/b"]     = { 0 }
--   self.tbl["/d/e"]     = { 4 }
--
-- Originally Lmod removed duplicates. Even now MODULEPATH and
-- LMOD_DEFAULT_MODULEPATH remove duplicates.  So depending what the
-- policy that was chosen at configure time, there may duplicates or
-- not.  This is the reason for use of "remFunc" in Var:remove() and
-- "insertFunc" in Var:prepend() and Var:append().
--
--------------------------------------------------------------------------
-- PUSHENV: Supporting a stack environment variable.
--------------------------------------------------------------------------
-- A site may wish to set CC to be the name of the c compiler.  They can
-- do this with pushenv("CC","gcc").   This is implemented in this class
-- via Var:prepend() to push and Var:pop() to pop the stack.  So the trick
-- here is that all sites allow duplicates to be stored when prepending.
-- This way prepend will always work as a push even when append and remove
-- do not allow duplicates.  Then the Var:pop() member function will work
-- correctly independent of site policy towards duplicates

require("strict")
require("string_split")
require("pairsByKeys")
require("utils")
local allow_dups    = allow_dups
local dbg           = require("Dbg"):dbg()
local ModulePath    = ModulePath
local concatTbl     = table.concat
local getenv        = os.getenv
local huge          = math.huge
local posix         = require("posix")
local setenv        = posix.setenv
local systemG       = _G


local M = {}

--------------------------------------------------------------------------
-- extract(): The ctor uses this routine to initialize the variable to be
--            the value from the environment. This routine assumes that
--            all variables are path like variables here.  Not to worry
--            however, the set function mark the type as "var" and not
--            "path".  Other functions work similarly.

local function extract(self)
   local myValue = self.value or getenv(self.name) or ""
   local pathTbl = {}
   local imax    = 0
   local imin    = 1
   local pathA   = {}
   local sep     = self.sep

   if (myValue ~= '') then
      pathA = path2pathA(myValue, sep)

      for i,v in ipairs(pathA) do
         local a    = pathTbl[v] or {}
         a[#a + 1]  = i
         pathTbl[v] = a
         imax       = i
      end
   end
   self.value  = myValue
   self.type   = 'path'
   self.tbl    = pathTbl
   self.imin   = imin
   self.imax   = imax
   self.export = true
end

--------------------------------------------------------------------------
-- Var:new():  The ctor for this class.  It uses extract to build its
--             initial value from the environment.

function M.new(self, name, value, sep)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.value      = value
   o.name       = name
   o.sep        = sep or ":"
   extract(o)
   setenv(name, value, true)
   return o
end

--------------------------------------------------------------------------
-- Var:prt() This member function is here just when debugging.

function M.prt(self,title)
   dbg.print {title,"\n"}
   dbg.print {"name:  \"", self.name, "\"\n"}
   dbg.print {"imin:  \"", self.imin, "\"\n"}
   dbg.print {"imax:  \"", self.imax, "\"\n"}
   dbg.print {"value: \"", self.value,"\"\n"}
   if (not self.tbl or type(self.tbl) ~= "table" or next(self.tbl) == nil) then
      dbg.print{"tbl is empty\n"}
      return
   end
   for k,v in pairs(self.tbl) do
      dbg.print {"   \"",k,"\":"}
      for ii = 1,#v do
         io.stderr:write(" ",v[ii])
      end
      dbg.print {"\n"}
   end
   dbg.print {"\n"}
end

--------------------------------------------------------------------------
-- chkMP(): This function is called to let Lmod know that the MODULEPATH
--          has changed.

local function chkMP(name)
   if (name == ModulePath) then
      dbg.print{"calling reEvalModulePath()\n"}
      local mt = systemG.MT:mt()

      mt:changePATH()
      mt:reEvalModulePath()
   end
end

--------------------------------------------------------------------------
--  The following three local functions implement the dup/no_dup
--  functionality:
--     removeAll():   no dups allowed
--     removeFirst(): dups allowed, called when reversing prepend_path
--     removeLast():  dups allowed, called when reversing append_path

local function removeAll(a)
   return nil
end

local function removeFirst(a)
   table.remove(a,1)
   if (next(a) == nil) then
      a = nil
   end
   return a
end

local function removeLast(a)
   a[#a] = nil
   if (next(a) == nil) then
      a = nil
   end
   return a
end

whereT = {
   all    = removeAll,
   first  = removeFirst,
   last   = removeLast,
}

--------------------------------------------------------------------------
-- Var:remove(): remove an entry in a path.  The remove action depends on
--               "where".  Note that the final action of this routine is
--               to push the new value into the current environment so that
--               any modules loaded will also know the new value.

function M.remove(self, value, where)
   if (value == nil) then return end

   where = allow_dups(true) and where or "all"
   local remFunc = whereT[where] or removeAll
   local pathA   = path2pathA(value, self.sep)
   local tbl     = self.tbl

   for i = 1, #pathA do
      local path = pathA[i]
      if (tbl[path]) then
         tbl[path] = remFunc(self.tbl[path])
         chkMP(self.name)
      end
   end
   local v    = self:expand()
   self.value = v
   setenv(self.name, v, true)
end

--------------------------------------------------------------------------
-- Var:pop(): Remove the top value and return the second value or nil if
--            none are left.

function M.pop(self)
   local imin   = self.imin
   local min2   = math.huge
   local result = nil

   if (dbg.active()) then self:prt("(1) Var:pop()") end

   for k, idxA in pairs(self.tbl) do
      local v = idxA[1]
      if (idxA[1] == imin) then
         self.tbl[k] = removeFirst(idxA)
         v = idxA[1] or huge
      end
      if (v < min2) then
         min2   = v
         result = k
      end
   end

   if (min2 < huge) then
      self.imin = min2
   end

   local v    = self:expand()
   self.value = v
   setenv(self.name, v, true)
   return result
end

--------------------------------------------------------------------------
-- The following three local functions implement the dup/no_dup
-- functionality:
--     unique(): no dups allowed
--     first():  dups allowed, call by prepend.
--     last():   dups allowed, call by append.

local function unique(a, value)
   a = { value }
   return a
end

local function first(a, value)
   table.insert(a,1, value)
   return a
end

local function last(a, value)
   a[#a+1] = value
   return a
end


--------------------------------------------------------------------------
-- Var:prepend(): Prepend an entry into a path. [[nodups]] controls
--                policies on duplication by setting [[insertFunc]].

function M.prepend(self, value, nodups)
   if (value == nil) then return end

   local pathA         = path2pathA(value, self.sep)
   local is, ie, iskip = prepend_order(#pathA)
   local insertFunc    = nodups and unique or first

   local tbl  = self.tbl
   local imin = self.imin
   for i = is, ie, iskip do
      local path = pathA[i]
      imin       = imin - 1
      local a    = tbl[path] or {}
      tbl[path]  = insertFunc(a, imin)
      chkMP(self.name)
   end
   self.imin = imin

   local v    = self:expand()
   self.value = v
   setenv(self.name, v, true)
end

--------------------------------------------------------------------------
-- Var:append(): Append an entry into a path. [[nodups]] controls
--               policies on duplication by setting [[insertFunc]].

function M.append(self, value, nodups)
   if (value == nil) then return end
   nodups           = not allow_dups(not nodups)
   local pathA      = path2pathA(value, self.sep)
   local insertFunc = nodups and unique or last

   local tbl  = self.tbl
   local imax = self.imax
   for i = 1, #pathA do
      local path = pathA[i]
      imax       = imax + 1
      local a    = tbl[path] or {}
      tbl[path]  = insertFunc(a, imax)
      chkMP(self.name)
   end
   self.imax  = imax
   local v    = self:expand()
   self.value = v
   setenv(self.name, v, true)
end

--------------------------------------------------------------------------
-- Master: The following are simple set/unset functions.

function M.set(self,value)
   self.value = value or ''
   self.type  = 'var'
   if (value == '') then value = nil end
   setenv(self.name, value, true)
end

function M.unset(self)
   self.value = ''
   self.type  = 'var'
   setenv(self.name, nil, true)
end

function M.setLocal(self,value)
   self.value = value
   self.type  = 'local_var'
end

function M.unsetLocal(self,value)
   self.value = ''
   self.type  = 'local_var'
end

function M.setAlias(self,value)
   self.value = value
   self.type  = 'alias'
end

function M.unsetAlias(self,value)
   self.value = ''
   self.type  = 'alias'
end

function M.setShellFunction(self,bash_func,csh_func)
   self.value = {bash_func,csh_func}
   self.type  = 'shell_function'
end

function M.unsetShellFunction(self,bash_func,csh_func)
   self.value = ''
   self.type  = 'shell_function'
end

--------------------------------------------------------------------------
-- Master:myType() - return the var type.
function M.myType(self)
   return self.type
end

--------------------------------------------------------------------------
-- Master:expand(): Expand the value into a string.   Obviously non-path
--                  types are simply returned.
--
--                  It is a two step process to expand the path variables.
--                  First table (self.tbl) is flipped where now the indices
--                  are the keys and the paths are the values.  This creates
--                  [[t]] with integer keys with possible gaps.  Then second
--                  loop uses pairByKeys to pick keys from lowest to highest.

function M.expand(self)
   if (self.type ~= 'path') then
      return self.value, self.type
   end

   local t       = {}
   local pathA   = {}
   local pathStr = ""
   local sep     = self.sep

   -- Step 1: Make a sparse array with path as values
   for k, v in pairs(self.tbl) do
      for ii = 1,#v do
         t[v[ii]] = k
      end
   end

   -- Step 2: Use pairByKeys to copy paths into pathA in correct order.

   local n = 0
   for _,v in pairsByKeys(t) do
      n = n + 1
      v = path_regularize(v)
      if (v == ' ') then
         v = ''
      end
      pathA[n] = v
   end

   -- Step 3: convert pathA array into "sep" separated string.
   --         Also Handle "" at end of "path"
   if (n == 1 and pathA[1] == "") then
      pathStr = sep .. sep
   else
      pathStr = concatTbl(pathA,sep)
      if (pathA[#pathA] == "") then
         pathStr = pathStr .. sep
      end
   end

   -- Step 4: Remove leading and trailing ':' from PATH string
   --         Note this cleanup is only for PATH and no other
   --         path variables.
   if (self.name == 'PATH') then
      pathStr = pathStr:gsub('^:+','')
      pathStr = pathStr:gsub(':+$','')
      if (pathStr:find('::')) then
         pathStr = pathStr:gsub('::+',":")
      end
   end
   return pathStr, self.type
end

return M
