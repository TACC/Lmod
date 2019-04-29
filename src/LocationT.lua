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

require("utils")
require("deepcopy")
require("collectionFileA")
require("serializeTbl")

local M        = {}
local dbg      = require("Dbg"):dbg()
local cosmic   = require("Cosmic"):singleton()

local function merge_locationT(origT, lctnT, v)
   if (v.file) then
      if (origT == nil) then
         lctnT = {file = v.file }
      end
   end
   if (next(v.fileT) ~= nil and lctnT.file == nil) then
      if (origT == nil or lctnT.fileT == nil) then
         lctnT = {fileT = v.fileT, dirT = lctnT.dirT or {}}
      else
         for k, vv in pairs(v.fileT) do
            if (lctnT.fileT[k] == nil or ( vv.wV > lctnT.fileT[k].wV)) then
               lctnT.fileT[k] = deepcopy(vv)
            end
         end
      end
   end
   if (next(v.dirT) ~= nil) then
      if (origT == nil) then
         lctnT = { dirT = deepcopy(v.dirT)}
      else
         for k, vv in pairs(v.dirT) do
            local new_origT = lctnT.dirT[k]
            local new_lctnT = new_origT or {}
            lctnT.dirT[k]   = merge_locationT(new_origT, new_lctnT, vv)
         end
      end
   end
   return lctnT
end


local function build(moduleA)
   dbg.start{"LocationT build(moduleA)"}

   local locationT = {}

   if (next(moduleA) == nil or #moduleA < 1) then
      dbg.print{"next(moduleA) == nil or #moduleA < 1\n"}
      dbg.fini("LocationT build")
      return locationT
   end
   local T = moduleA[1].T or {}

   for sn,v in pairs(T) do
      if (v.file) then
         locationT[sn] = {file = v.file, fileT = {}, dirT = {}, mpath = v.mpath }
      elseif (next(v.fileT) ~= nil) then
         locationT[sn] = {fileT = v.fileT, dirT = {}}
      elseif (next(v.dirT)) then
         locationT[sn] = {dirT = v.dirT, fileT={}}
      end
   end

   for i = 2,#moduleA do
      T = moduleA[i].T or {}
      for sn, v in pairs(T) do
         local origT   = locationT[sn]
         local lctnT   = locationT[sn] or {}
         locationT[sn] = merge_locationT(origT, lctnT, v)
      end
   end

   dbg.fini("LocationT build")
   return locationT
end

function M.new(self, moduleA)
   dbg.start{"LocationT:new(moduleA)"}
   local o = {}
   setmetatable(o,self)
   o.__locationT = build(deepcopy(moduleA))
   self.__index = self
   dbg.fini("LocationT:new")
   return o
end

function M.locationT(self)
   return self.__locationT
end

function M.search(self, name)
   --dbg.start{"LocationT:search(",name,")"}
   local locationT = self.__locationT
   
   if (next(locationT) == nil) then
      --dbg.print{"next(locationT) == nil\n"}
      --dbg.fini("LocationT:search")
      return nil, nil, nil
   end

   dbg.printT("locationT",locationT)


   -- Find sn from name by looking in locationT and if it is not there
   -- Then remove "/version" from name

   local versionStr = nil
   local sn         = name
   local v          = nil
   local idx        = nil
   while true do
      v   = locationT[sn]
      if (v) then break end
      idx = sn:match("^.*()/")
      if (idx == nil) then break end
      sn  = sn:sub(1,idx-1)
   end

   -- if v is nil then the name was not found so quit
   if (v == nil) then
      --dbg.fini("LocationT:search")
      return nil
   end

   if (v.dirT == nil and v.file == nil) then
      --dbg.print{"sn: ",sn,"\n"}
      --dbg.printT("locationT", locationT)
      --dbg.fini("LocationT:search")
      LmodError{msg="e_LocationT_Srch"}
      return nil
   end

   if (idx) then
      versionStr = name:sub(idx+1,-1)
   end

   ------------------------------------------------------------
   -- collect the list of possible matches:
   ------------------------------------------------------------

   ------------------------------------------------------------
   -- Find right "v"

   idx           = 1
   local vStr    = versionStr
   local done    = (vStr == nil)
   local jdx     = idx
   local fullStr = versionStr

   while (not done) do
      idx = versionStr:find("/",jdx)
      if (idx == nil) then
         done = true
         vStr = versionStr
      else
         vStr = versionStr:sub(1,idx-1)
         jdx  = idx + 1
      end
      local key   = pathJoin(sn, vStr)
      local value = v.dirT[key]

      if (value) then
         v       = value
         if (vStr == versionStr) then
            fullStr = nil
         end
      else
         done  = true
      end
   end

   --dbg.print{"sn:",sn,", versionStr: ",versionStr,", fullStr: ",fullStr,"\n"}
   --dbg.printT("v",v)

   local fileA = {}
   fileA[1]    = {}
   local extended_default = cosmic:value("LMOD_EXTENDED_DEFAULT")
   collectFileA(sn, fullStr, extended_default, v, fileA[1])
   --dbg.fini("LocationT:search")
   return sn, versionStr, fileA
end


return M
