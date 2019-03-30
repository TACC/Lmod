_G._DEBUG             = false               -- Required by the new lua posix
local posix           = require("posix")

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

require("string_utils")
require("pairsByKeys")
require("utils")
require("myGlobals")
require("serializeTbl")

local M               = {}
local abs             = math.abs
local ceil            = math.ceil
local concatTbl       = table.concat
local cosmic          = require("Cosmic"):singleton()
local dbg             = require("Dbg"):dbg()
local envPrtyName     = "__LMOD_Priority_"
local envRefCountName = "__LMOD_REF_COUNT_"
local getenv          = os.getenv
local log             = math.log
local min             = math.min
local max             = math.max
local huge            = math.huge
local setenv_posix    = posix.setenv
local tmod_path_rule  = cosmic:value("LMOD_TMOD_PATH_RULE")
local ln10_inv        = 1.0/log(10.0)
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

local function l_extract_Lmod_var_table(self, envName)
   local value = getenv(envName .. self.name)
   if (envName .. self.name == "__LMOD_REF_COUNT_MODULEPATH") then
      dbg.print{"__LMOD_REF_COUNT_MODULEPATH: ",value,"\n"}
   end

   local t     = {}
   if (value == nil) then
      return t
   end

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
      local cached_loads = cosmic:value("LMOD_CACHED_LOADS")
      local spider_cache = (cached_loads ~= 'no')
      local moduleA      = require("ModuleA"):singleton{spider_cache = spider_cache}
      moduleA:update{spider_cache = spider_cache}
      dbg.fini("chkMP")
   end
end

--------------------------------------------------------------------------
-- The ctor uses this routine to initialize the variable to be
-- the value from the environment. This routine assumes that
-- all variables are path like variables here.  Not to worry
-- however, the set function mark the type as "var" and not
-- "path".  Other functions work similarly.
local function l_extract(self, nodups)
   local myValue   = self.value or getenv(self.name)
   local pathTbl   = {}
   local imax      = 0
   local imin      = 1
   local pathA     = {}
   local sep       = self.sep
   local priorityT = l_extract_Lmod_var_table(self, envPrtyName)
   local refCountT = l_extract_Lmod_var_table(self, envRefCountName)

   if (myValue and myValue ~= '') then
      pathA = path2pathA(myValue, sep)
      for i,v in ipairs(pathA) do
         local vv       = pathTbl[v] or {num = -1, idxA = {}}
         local num      = vv.num 
         if (num == -1) then
            local refCount = false
            local vA       = refCountT[v]
            if (vA) then
               refCount = tonumber(vA[1])
            end
            num = (refCount or 1) - 1
         end

         local priority = 0
         local vA       = priorityT[v]
         if (vA) then
            priority = vA[1]
         end
         
         local idxA    = vv.idxA
         if (nodups) then
            --if (self.name == ModulePath) then 
            --   vv.num = 1
            --else
            --   vv.num = num + 1
            --end
            vv.num = num + 1
            if (next(idxA) == nil) then
               idxA[1] = {i,priority}
            end
         else
            idxA[#idxA+1] = {i,priority}
            vv.num        = num + 1
         end
         imax       = i
         pathTbl[v] = vv
      end
   end

   self.nodups = nodups
   self.value  = myValue
   self.type   = 'path'
   self.tbl    = pathTbl
   self.imin   = imin
   self.imax   = imax
   self.export = true
end

--------------------------------------------------------------------------
-- The ctor for this class.  It uses l_extract to build its
-- initial value from the environment.
-- @param self A Var object.
-- @param name The name of the variable.
-- @param value The value assigned to the variable.
-- @param nodup If true then no duplicate entries in path like variable.
-- @param sep The separator character.  (By default it is ":")
function M.new(self, name, value, nodup, sep)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.value      = value
   o.name       = name
   o.sep        = sep or ":"
   if (name == ModulePath) then
      nodup = true
   end
   l_extract(o, nodup)
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
local function l_remFunc(vv, where, priority, nodups, force)
   local num  = vv.num
   local idxA = vv.idxA
   if (nodups) then
      vv.num = (force) and 0 or num - 1
      if (vv.num < 1) then
         vv = nil
      end
   elseif (where == "all" or abs(priority) > 0) then
      local oldPriority = 0
      if (next(idxA) ~= nil) then
         oldPriority = tonumber(idxA[1][2])
      end
      if (oldPriority == priority or nodups) then
         vv = nil
      end
   elseif (where == "first" ) then
      table.remove(idxA,1)
      vv.num = num - 1
      if (next(idxA) == nil) then
         vv = nil
      end
   elseif (where == "last" ) then
      idxA[#idxA] = nil
      vv.num = num - 1
      if (next(idxA) == nil) then
         vv = nil
      end
   end
   return vv
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
function M.remove(self, value, where, priority, nodups, force)
   if (value == nil) then return end
   priority = priority or 0

   if (where == "first") then
      priority = - priority
   end

   where = allow_dups(true) and where or "all"
   local pathA   = path2pathA(value, self.sep)
   local tbl     = self.tbl
   local adding  = false

   local tracing  = cosmic:value("LMOD_TRACING")
   if (tracing == "yes" and self.name == ModulePath ) then
      local shell      = _G.Shell
      local frameStk   = require("FrameStk"):singleton()
      local stackDepth = frameStk:stackDepth()
      local indent     = ("  "):rep(stackDepth+1)
      local b          = {}
      b[#b + 1]        = indent
      b[#b + 1]        = "Removing: "
      b[#b + 1]        = value
      b[#b + 1]        = " from MODULEPATH\n"
      shell:echo(concatTbl(b,""))
   end

   for i = 1, #pathA do
      local path = pathA[i]
      if (tbl[path]) then
         tbl[path]   = l_remFunc(tbl[path], where, priority, nodups, force)
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
local function insertFunc(vv, idx, isPrepend, nodups, priority)
   local num  = vv.num
   local idxA = vv.idxA
   if (nodups or abs(priority) > 0) then
      local oldPriority = 0
      if (next(idxA) ~= nil) then
         oldPriority = tonumber(idxA[1][2])
      end
      if (priority < 0) then
         priority = min(priority, oldPriority)
      elseif (priority > 0) then
         priority = max(priority, oldPriority)
      end

      if (num == 0 ) then
         return { num = 1, idxA = {{idx,priority}} }
      else
         vv.num  = num + 1
         if (tmod_path_rule == "no") then
            vv.idxA = {{idx,priority}}
         end
         return vv
      end
   elseif (isPrepend) then
      table.insert(idxA,1, {idx, priority})
      vv.num = num + 1
   else
      idxA[#idxA+1] = {idx, priority}
      vv.num = num + 1
   end
   return vv
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
      l_extract(self, nodups)
   end

   if (self.name == ModulePath) then
      nodups = true
   end
   self.type           = 'path'
   priority            = priority or 0
   local pathA         = path2pathA(value, self.sep)
   local is, ie, iskip = prepend_order(#pathA)
   local isPrepend     = true
   local adding        = true
   local p2A           ={}

   local tbl  = self.tbl

   local tracing  = cosmic:value("LMOD_TRACING")
   if (tracing == "yes" and self.name == ModulePath ) then
      local shell      = _G.Shell
      local frameStk   = require("FrameStk"):singleton()
      local stackDepth = frameStk:stackDepth()
      local indent     = ("  "):rep(stackDepth+1)
      local b          = {}
      b[#b + 1]        = indent
      b[#b + 1]        = "Prepending: "
      b[#b + 1]        = value
      b[#b + 1]        = " to MODULEPATH\n"
      shell:echo(concatTbl(b,""))
   end
   
   local imin = min(self.imin, 0)
   local name = self.name
   for i = is, ie, iskip do
      local path = pathA[i]
      imin       = imin - 1
      local vv   = tbl[path]
      tbl[path]  = insertFunc(vv or {num = 0, idxA = {}},
                              imin, isPrepend, nodups, priority)
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
   local name = self.name
   nodups = (not allow_dups(not nodups)) or (name == ModulePath)

   if (value == nil) then return end
   if (self.type ~= 'path') then
      l_extract(self, nodups)
   end

   self.type        = 'path'
   priority         = tonumber(priority or "0")
   local pathA      = path2pathA(value, self.sep)
   local isPrepend  = false
   local adding     = true
   
   local tracing  = cosmic:value("LMOD_TRACING")
   if (tracing == "yes" and name == ModulePath ) then
      local shell      = _G.Shell
      local frameStk   = require("FrameStk"):singleton()
      local stackDepth = frameStk:stackDepth()
      local indent     = ("  "):rep(stackDepth+1)
      local b          = {}
      b[#b + 1]        = indent
      b[#b + 1]        = "Appending: "
      b[#b + 1]        = value
      b[#b + 1]        = " to MODULEPATH\n"
      shell:echo(concatTbl(b,""))
   end

   local tbl  = self.tbl
   local imax = self.imax
   for i = 1, #pathA do
      local path = pathA[i]
      imax       = imax + 1
      local vv   = tbl[path]
      tbl[path]  = insertFunc(vv or {num = 0, idxA = {}}, imax, isPrepend, nodups, priority)
   end
   self.imax   = imax
   local value = self:expand()
   self.value  = value
   if (not value) then value = nil end
   setenv_posix(name, value, true)
   chkMP(name, value, adding)
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
   local adding = true
   chkMP(self.name, value, adding)
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

   for k, vv in pairs(self.tbl) do
      local idxA = vv.idxA
      local v = idxA[1][1]
      dbg.print{"v: ",v,", imin: ",imin,", min2: ",min2,"\n"}
      if (v == imin) then
         vv          = l_remFunc(vv, "first", 0, false)
         self.tbl[k] = vv
         if (vv ~= nil) then
            v = vv.idxA[1][1]
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
   if (not v) then v = nil end
   setenv_posix(self.name, v, true)
   local adding = false
   chkMP(self.name, v, adding)
   return result
end

--------------------------------------------------------------------------
-- This member function is here just when debugging.
-- @param self A Var object.
-- @param title A Descriptive title.
function M.prt(self,title)
   dbg.start{"Var:prt(\"",title,"\")"}
   dbg.print{"name:   \"", self.name,   "\"\n"}
   dbg.print{"nodups: ",   self.nodups, "\n"}
   dbg.print{"imin:   ",   self.imin,   "\n"}
   dbg.print{"imax:   ",   self.imax,   "\n"}
   local v = self.value
   if (type(self.value) == "string") then
      v = "\"" .. self.value .. "\""
   end
   dbg.print{"value: ", v, "\n"}
   if (not self.tbl or type(self.tbl) ~= "table" or next(self.tbl) == nil) then
      dbg.print{"tbl is empty\n"}
      dbg.fini ("Var:prt")
      return
   end
   if (dbg.active()) then
      dbg.print{"tbl:\n"}
      for k,vv in pairsByKeys(self.tbl) do
         local num  = vv.num
         local idxA = vv.idxA
         dbg.print{"   \"",k,"(",num,")\":"}
         for ii = 1,#idxA do
            io.stderr:write(" {",tostring(idxA[ii][1]), ", ",tostring(idxA[ii][2]),"} ")
         end
         dbg.print{"\n"}
      end
   end
   dbg.print{"\n"}
   dbg.fini ("Var:prt")
end

function M.setRefCount(self, refCountT)
   local tbl = self.tbl
   for k, vv in pairs(tbl) do
      vv.num = refCountT[k] or 1
   end
end

function M.refCountT(self)
   local refCountT = {}
   local tbl = self.tbl
   for k, vv in pairs(tbl) do
      refCountT[k] = vv.num
   end

   return refCountT
end


--------------------------------------------------------------------------
-- Unset the environment variable.
-- @param self A Var object
function M.unset(self)
   self.value = false
   self.type  = 'var'
   setenv_posix(self.name, nil, true)
   local adding = false
   chkMP(self.name, nil, adding)
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
      return self.value, self.type, {}, {}
   end

   local env_name
   local t         = {}
   local pathA     = {}
   local pathStr   = false
   local sep       = self.sep
   local prT       = {}
   local maxV      = max(abs(self.imin), self.imax) + 1
   local factor    = 10^ceil(log(maxV)*ln10_inv+1)
   local resultA   = {}
   local tbl       = self.tbl
   local sAA       = {}
   -- Step 1: Make a sparse array with path as values

   for k, vv in pairsByKeys(tbl) do
      local idxA = vv.idxA
      for ii = 1,#idxA do
         local duo      = idxA[ii]
         local value    = tonumber(duo[1])
         local priority = tonumber(duo[2])
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

   if (self.nodups) then
      for i = 1,n do
         local path = pathA[i]
         local vv   = tbl[path]
         if (vv) then
            sAA[#sAA+1] = path .. ":" .. tostring(vv.num)
         end
      end
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
   --         path-like variables.
   if (self.name == 'PATH') then
      pathStr = pathStr:gsub('^:+','')
      pathStr = pathStr:gsub(':+$','')
      if (pathStr:find('::')) then
         pathStr = pathStr:gsub('::+',":")
      end
   end



   local priorityStrT = {}
   env_name   = envPrtyName .. self.name
   local oldV = getenv(env_name)
   if (next(prT) == nil) then
      if (oldV) then
         priorityStrT[env_name] = false
      end
   else
      local sA = {}
      for k,priority in pairsByKeys(prT) do
         sA[#sA+1] = k .. ':' .. tostring(priority)
      end
      local s = concatTbl(sA,';')
      if (oldV ~= s) then
         priorityStrT[env_name] = s
      end
   end

   local refCountT = {}
   if (self.nodups) then
      env_name = envRefCountName .. self.name
      oldV     = getenv(env_name)
      if (next(sAA) == nil) then
         if (oldV) then
            refCountT[env_name] = false
         end
      else
         local s = concatTbl(sAA,';')
         if (oldV ~= s) then
            refCountT[env_name] = s
         end
      end
   end

   if (next(tbl) == nil) then pathStr = false end
   return pathStr, "path", priorityStrT, refCountT
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
