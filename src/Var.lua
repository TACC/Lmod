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
--  Copyright (C) 2008-2017 Robert McLay
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

require("string_utils")
require("pairsByKeys")
require("utils")
require("myGlobals")

_G._DEBUG            = false               -- Required by the new lua posix
local M              = {}
local abs            = math.abs
local ceil           = math.ceil
local concatTbl      = table.concat
local cosmic         = require("Cosmic"):singleton()
local dbg            = require("Dbg"):dbg()
local envPrtyName    = "NVV_Priority_"
local getenv         = os.getenv
local log            = math.log
local min            = math.min
local max            = math.max
local huge           = math.huge
local posix          = require("posix")
local setenv_posix   = posix.setenv
local tmod_path_rule = cosmic:value("LMOD_TMOD_PATH_RULE")
local ln10_inv       = 1.0/log(10.0)
--------------------------------------------------------------------------
-- Rebuild the path-like priority table.  So for a PATH with priorities
-- would have:
--     __LMOD_PRIORITY_PATH=/a/b/c:-100;/d/e/f:-1000
-- The entries are separated by semicolons and the key-value pairs
-- are separated by colons.  The results are a table:
--
--     t['/a/b/c'] =  -100
--     t['/d/e/f'] = -1000
--
-- @param self A Var object.

local function build_priorityT(self)
   local value   = getenv(envPrtyName .. self.name)
   if (value == nil) then
      return {}
   end

   local t = {}
   local a = false
   for outer in value:split(";") do
      local istate = 0
      for entry in outer:split(":") do
         istate = istate + 1
         if (istate == 1) then
            t[entry] = {}
            a        = t[entry]
         else
            a[#a+1]  = entry
         end
      end
   end
   return t
end

--------------------------------------------------------------------------
-- This function is called to let Lmod know that the MODULEPATH
-- has changed.
-- @param name The variable name
-- @param adding True if adding to path.
-- @param pathEntry The new value.
local function chkMP(name, value, adding)
   if (name == ModulePath) then
      dbg.start{"chkMP(\"MODULEPATH\", value: ",value,", adding:",adding,")"}
      local mt = require("FrameStk"):singleton():mt()
      mt:set_MPATH_change_flag()
      mt:updateMPathA(value)
      local moduleA      = require("ModuleA"):singleton()
      local cached_loads = cosmic:value("LMOD_CACHED_LOADS")
      moduleA:update{spider_cache = (cached_loads ~= 'no')}
      dbg.fini("chkMP")
   end
end

--------------------------------------------------------------------------
-- The ctor uses this routine to initialize the variable to be
-- the value from the environment. This routine assumes that
-- all variables are path like variables here.  Not to worry
-- however, the set function mark the type as "var" and not
-- "path".  Other functions work similarly.
local function extract(self)
   local myValue   = self.value or getenv(self.name)
   local pathTbl   = {}
   local imax      = 0
   local imin      = 1
   local pathA     = {}
   local sep       = self.sep
   local priorityT = build_priorityT(self)

   if (myValue and myValue ~= '') then
      pathA = path2pathA(myValue, sep)

      for i,v in ipairs(pathA) do
         local a        = pathTbl[v] or {}
         local priority = 0
         local vA       = priorityT[v]
         if (vA) then
            priority = vA[1]
         end
         a[#a + 1]  = {i,priority}
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
-- The ctor for this class.  It uses extract to build its
-- initial value from the environment.
-- @param self A Var object.
-- @param name The name of the variable.
-- @param value The value assigned to the variable.
-- @param sep The separator character.  (By default it is ":")
function M.new(self, name, value, sep)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.value      = value
   o.name       = name
   o.sep        = sep or ":"
   extract(o)
   if (not value) then value = nil end
   setenv_posix(name, value, true)
   return o
end

function M.myName(self)
   return self.name
end

--------------------------------------------------------------------------
--  This handles removing entries from a path like variable.
--  @param a An array of values.
--  @param where Where to remove and how: {"first", "last", "all"}
--  @param priority The priority of the path if any (default is zero)
local function remFunc(a, where, priority, nodups)
   if (where == "all" or abs(priority) > 0) then
      local oldPriority = 0
      if (next(a) ~= nil) then
         oldPriority = tonumber(a[1][2])
      end
      if (oldPriority == priority or nodups) then
         a = nil
      end
   elseif (where == "first" ) then
      table.remove(a,1)
      if (next(a) == nil) then
         a = nil
      end
   elseif (where == "last" ) then
      a[#a] = nil
      if (next(a) == nil) then
         a = nil
      end
   end
   return a
end

--------------------------------------------------------------------------
-- Remove an entry in a path.  The remove action depends on
-- "where".  Note that the final action of this routine is
-- to push the new value into the current environment so that
-- any modules loaded will also know the new value.
-- @param self A Var object
-- @param value The value to remove
-- @param where where it should be removed from {"first", "last", "all"}
-- @param priority The priority of the entry.
-- @param nodup If true then there are no duplicates allowed.
function M.remove(self, value, where, priority, nodups)
   if (value == nil) then return end
   priority = priority or 0

   if (where == "first") then
      priority = - priority
   end

   where = allow_dups(true) and where or "all"
   local pathA   = path2pathA(value, self.sep)
   local tbl     = self.tbl
   local adding  = false

   for i = 1, #pathA do
      local path = pathA[i]
      if (tbl[path]) then
         tbl[path]   = remFunc(self.tbl[path], where, priority, nodups)
      end
   end
   local v    = self:expand()
   self.value = v
   if (not v) then v = nil end
   setenv_posix(self.name, v, true)
   chkMP(self.name, v, adding)
end

--------------------------------------------------------------------------
-- insert index into table with priority.  If nodup or this
-- particular path entry has a priority then there is only
-- one entry in the path.  Otherwise insert [[idx]] at
-- beginning for prepends and at the end for appends.
-- @param a Input array of entries in path like variable.
-- @param idx the index value for the entry.
-- @param isPrepend True if a prepend.
-- @param nodups True if no duplications are allowed.
-- @param priority The priority value.
local function insertFunc(a, idx, isPrepend, nodups, priority)
   if (nodups or abs(priority) > 0) then
      if (priority == 0) then
         return { {idx,priority}  }
      end

      local oldPriority = 0
      if (next(a) ~= nil) then
         oldPriority = tonumber(a[1][2])
      end

      if (priority < 0) then
         if (priority <= oldPriority) then
            return { {idx,priority}  }
         end
      elseif (oldPriority > 0 and priority > oldPriority) then
         return { {idx,priority}  }
      end
   elseif (isPrepend) then
      table.insert(a,1, {idx, priority})
   else
      a[#a+1] = {idx, priority}
   end
   return a
end

--------------------------------------------------------------------------
-- Prepend an entry into a path. [[nodups]] controls
-- policies on duplication by setting [[insertFunc]].
--
-- Report an error/warning when appending/prepending a path element
-- without the same priority
-- @param self A Var object
-- @param value The value to prepend
-- @param nodups True if no duplications are allowed.
-- @param priority The priority value.
function M.prepend(self, value, nodups, priority)
   if (value == nil) then return end

   if (self.type ~= 'path') then
      extract(self)
   end

   self.type           = 'path'
   priority            = priority or 0
   local pathA         = path2pathA(value, self.sep)
   local is, ie, iskip = prepend_order(#pathA)
   local isPrepend     = true
   local adding        = true
   local p2A           ={}

   local tbl  = self.tbl

   local imin = min(self.imin, 0)
   for i = is, ie, iskip do
      local path = pathA[i]
      imin       = imin - 1
      local   a  = tbl[path]
      if (tmod_path_rule == "no" or not a) then
         tbl[path]   = insertFunc(a or {}, imin, isPrepend, nodups, priority)
      end
   end
   self.imin = imin

   local v    = self:expand()
   self.value = v
   if (not v) then v = nil end
   setenv_posix(self.name, v, true)

   chkMP(self.name, v, adding)
end

--------------------------------------------------------------------------
-- Append an entry into a path. [[nodups]] controls
-- policies on duplication by setting [[insertFunc]].
-- @param self A Var object
-- @param value The value to prepend
-- @param nodups True if no duplications are allowed.
-- @param priority The priority value.
function M.append(self, value, nodups, priority)
   if (value == nil) then return end
   if (self.type ~= 'path') then
      extract(self)
   end
   self.type        = 'path'
   nodups           = not allow_dups(not nodups)
   priority         = tonumber(priority or "0")
   local pathA      = path2pathA(value, self.sep)
   local isPrepend  = false
   local adding     = true
   
   local tbl  = self.tbl
   local imax = self.imax
   for i = 1, #pathA do
      local path = pathA[i]
      imax       = imax + 1
      local a    = tbl[path]
      if (tmod_path_rule == "no" or not a) then
         tbl[path]   = insertFunc(a or {}, imax, isPrepend, nodups, priority)
      end
   end
   self.imax  = imax
   local v    = self:expand()
   self.value = v
   if (not v) then v = nil end
   setenv_posix(self.name, v, true)
   chkMP(self.name, v, adding)
end

--------------------------------------------------------------------------
-- Set the environment variable to *value*
-- @param self A Var object
-- @param value the value to set.
function M.set(self,value)
   if (not value) then value = false end
   self.value = value
   self.type  = 'var'
   if (not value) then value = nil end
   setenv_posix(self.name, value, true)
end

--------------------------------------------------------------------------
-- Remove the top value and return the second value or nil if
-- none are left.
-- @param self A Var object.
function M.pop(self)
   self.type    = 'path'
   local imin   = self.imin
   local min2   = huge
   local result = nil

   --if (dbg.active()) then
   --   print(__FILE__() .. ':' .. __LINE__())
   --   self:prt("(1) Var:pop()")
   --   print(__FILE__() .. ':' .. __LINE__())
   --end

   for k, idxA in pairs(self.tbl) do
      local v = idxA[1][1]
      dbg.print{"v: ",v,", imin: ",imin,", min2: ",min2,"\n"}
      if (v == imin) then
         idxA        = remFunc(idxA, "first", 0)
         self.tbl[k] = idxA
         if (idxA ~= nil) then
            v = idxA[1][1]
         else
            v = huge
         end
      end
      dbg.print{"v: ",v,"\n"}
      if (v < min2) then
         min2   = v
         result = k
      end
      dbg.print{"min2: ",min2,"\n"}
   end
   dbg.print{"imin: ",imin,", min2: ",min2,"\n"}
   if (min2 < huge) then
      self.imin = min2
   end

   local v    = self:expand()
   self.value = v
   --if (dbg.active()) then
   --   self:prt("(2) Var:pop()")
   --end
   if (not v) then v = nil end
   setenv_posix(self.name, v, true)
   return result
end

--------------------------------------------------------------------------
-- Unset the environment variable.
-- @param self A Var object
function M.unset(self)
   self.value = false
   self.type  = 'var'
   setenv_posix(self.name, nil, true)
end

--------------------------------------------------------------------------
-- Expand the value into a string.   Obviously non-path
-- types are simply returned.
--
-- It is a two step process to expand the path variables.
-- First table (self.tbl) is flipped where now the indices
-- are the keys and the paths are the values.  This creates
-- [[t]] with integer keys with possible gaps.  Then second
-- loop uses pairByKeys to pick keys from lowest to highest.
-- @param self A Var object.
function M.expand(self)
   if (self.type ~= 'path') then
      return self.value, self.type, {}
   end

   local t       = {}
   local pathA   = {}
   local pathStr = false
   local sep     = self.sep
   local prT     = {}
   local maxV    = max(abs(self.imin), self.imax) + 1
   local factor  = 10^ceil(log(maxV)*ln10_inv+1)
   local resultA = {}
   local tbl     = self.tbl

   -- Step 1: Make a sparse array with path as values
   for k, vA in pairs(tbl) do
      for ii = 1,#vA do
         local pair     = vA[ii]
         local value    = pair[1]
         local priority = pair[2]
         local idx      = value + factor*priority
         t[idx]         = k
         if (abs(priority) > 0) then
            prT[k] = priority
         end
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


   -- Step 2.1: Remove extra trailing empty strings, keep only one.

   local i = n
   while (pathA[i] == "") do
      i = i - 1
   end
   i = i + 2
   for j = i, n do
      pathA[j] = nil
   end
   n = #pathA
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

   local priorityStrT = {}
   local env_name = envPrtyName .. self.name
   if (next(prT) == nil) then
      if (getenv(env_name)) then
         priorityStrT[env_name] = false
      end
   else
      local sA = {}
      for k,priority in pairsByKeys(prT) do
         sA[#sA+1] = k .. ':' .. tostring(priority)
      end
      priorityStrT[env_name] = concatTbl(sA,';')
   end

   if (next(tbl) == nil) then pathStr = false end

   return pathStr, "path", priorityStrT
end

--------------------------------------------------------------------------
-- Set the alias.
-- @param self A Var object.
-- @param value the text of the alias.
function M.setAlias(self,value)
   if (not value) then value = false end
   self.value = value
   self.type  = 'alias'
end

--------------------------------------------------------------------------
-- unset the alias.
-- @param self A Var object.
function M.unsetAlias(self)
   self.value = false
   self.type  = 'alias'
end

--------------------------------------------------------------------------
-- Set a shell function for Bash and C-shell
-- @param self A Var object.
-- @param bash_func A bash function string.
-- @param csh_func A C-shell function string.
function M.setShellFunction(self,bash_func,csh_func)
   self.value = {bash_func,csh_func}
   self.type  = 'shell_function'
end

--------------------------------------------------------------------------
-- Unset a shell function for Bash and C-shell
-- @param self A Var object.
function M.unsetShellFunction(self)
   self.value = false
   self.type  = 'shell_function'
end


return M
