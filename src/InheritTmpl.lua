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
require("fileOps")

local M            = {}
local MName        = require("MName")
local MT           = MT
local Dbg          = require("Dbg")
local lfs          = require("lfs")
local posix        = require('posix')
local remove       = table.remove
local systemG      = _G


--module("InheritTmpl")

s_inheritTmpl = {}

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   return o
end

function M.inheritTmpl(self)
   if (next(s_inheritTmpl) == nil) then
      s_inheritTmpl = new(self)
      MT            = systemG.MT
   end
   return s_inheritTmpl
end

local searchTbl = {'.lua',''}

function M.find_module_file(fullModuleName, oldFn)
   local dbg      = Dbg:dbg()
   dbg.start("InheritTmpl:find_module_file(",fullModuleName,",",oldFn, ")")

   local t        = { fn = nil, modFullName = nil, modName = nil, default = 0, hash = 0}
   local mt       = MT:mt()
   local mname    = MName:new("load", fullModuleName)
   local sn       = mname:sn()
   local localDir = true
   

   local pathA = mt:locationTbl(sn)

   if (pathA == nil or #pathA == 0) then
      dbg.fini()
      return t
   end
   local fn, result, rstripped
   local foundOld = false
   local oldFn_stripped = oldFn:gsub("%.lua$","")

   for ii, vv in ipairs(pathA) do
      local mpath  = vv.mpath
      fn           = pathJoin(vv.file, mname:version())
      result       = nil
      dbg.print("ii: ",ii," mpath: ",mpath," vv.file: ",vv.file," fn: ",fn,"\n")
      for i = 1, #searchTbl do
         local f        = fn .. searchTbl[i]
         local attr     = lfs.attributes(f)
         local readable = posix.access(f,"r")
         dbg.print('(1) fn: ',fn," f: ",f,"\n")
         if (readable and attr and attr.mode == "file") then
            result = f
            rstripped = result:gsub("%.lua$","")
            break
         end
      end

      dbg.print("(2) result: ", result, " foundOld: ", foundOld,"\n")
      if (foundOld) then
         break
      end


      if (result and rstripped == oldFn_stripped) then
         foundOld = true
         result = nil
      end
      dbg.print("(3) result: ", result, " foundOld: ", foundOld,"\n")
   end

   dbg.print("fullModuleName: ",fullModuleName, " fn: ", result,"\n")
   t.modFullName = fullModuleName
   t.fn          = result
   dbg.fini()
   return t
end

return M
