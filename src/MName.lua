require("strict")

local M   = {}
local Dbg = require("Dbg")
local MT  = require("MT")

local function shorten(name, level)
   if (level == 0) then
      return name
   end

   local i,j = name:find(".*/")
   j = (j or 0) - 1
   return name:sub(1,j)
end

function M.new(self, sType, name)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   local dbg = Dbg:dbg()
   dbg.start("MName:new( ",sType, ", ",tostring(name),")")
   local mt = MT:mt()

   --name = name:gsub("/+$","")  -- remove any trailing '/'
   local sn = false

   if (sType == "load") then
      for level = 0, 1 do
         local n = shorten(name, level)
         dbg.print("n: ",n,"\n")
         if (mt:locationTbl(n)) then
            sn = n
            break
         end
      end
   else
      for level = 0, 1 do
         local n = shorten(name, level)
         if (mt:exists(n)) then
            sn = n
            break
         end
      end
   end

   dbg.print("sn: ",tostring(sn),"\n")
   if (sn) then
      o._sn      = sn
      o._name    = name
      o._version = extractVersion(name, sn)
   end
   dbg.fini()
   return o
end

function M.sn(self)
   return self._sn
end

function M.usrName(self)
   return self._name
end

function M.version(self)
   return self._version 
end

return M
