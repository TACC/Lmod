require("strict")
require("fileOps")

local M            = {}
local MT           = MT
local Dbg          = require("Dbg")
local lfs          = require("lfs")
local ipairs       = ipairs
local next         = next
local pathJoin     = pathJoin
local posix        = require('posix')
local remove       = table.remove
local setmetatable = setmetatable
local systemG      = _G
local tostring     = tostring


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
   local idx      = fullModuleName:find('/')
   local localDir = true
   

   local key, extra, modName
   if (idx == nil) then
      key   = fullModuleName
      extra = ''
   else
      key   = fullModuleName:sub(1,idx-1)
      extra = fullModuleName:sub(idx)
   end

   local pathA = mt:locationTbl(key)

   if (pathA == nil or #pathA == 0) then
      dbg.fini()
      return t
   end
   local fn, result, rstripped
   local foundOld = false
   local oldFn_stripped = oldFn:gsub("%.lua$","")

   for ii, vv in ipairs(pathA) do
      local mpath  = vv.mpath
      fn           = pathJoin(vv.file, extra)
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

      dbg.print("(2) result: ", tostring(result), " foundOld: ", tostring(foundOld),"\n")
      if (foundOld) then
         break
      end


      if (result and rstripped == oldFn_stripped) then
         foundOld = true
         result = nil
      end
      dbg.print("(3) result: ", tostring(result), " foundOld: ", tostring(foundOld),"\n")
   end

   dbg.print("fullModuleName: ",fullModuleName, " fn: ", tostring(result),"\n")
   t.modFullName = fullModuleName
   t.fn          = result
   dbg.fini()
   return t
end

return M
