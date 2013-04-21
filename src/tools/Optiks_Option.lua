-- Option.lua
require("strict")
local setmetatable = setmetatable
local pairs=pairs
local Optiks_Error=Optiks_Error
local M = {}


validTable = {
   name    = "required",
   dest    = "required",
   action  = "required",
   type    = "optional",
   default = "optional",
   help    = "optional",
   system  = "optional",
}

validActions = { append = 1,
                 count = 1,
                 store = 1,
                 store_true = 1,
                 store_false = 1,
               }
validTypes =   { number = 1,
                 string = 1,
               }


function M.optionNames(self)
   return self.table.name
end

function M.bless(self)
   local errStr = ""
   local ierr   = 0
   for key in pairs(self.table) do
      if (not validTable[key] ) then
         errStr = errStr .. "Unknown Key: " .. key .. "\n"
         ierr   = ierr + 1
      end
   end

   for key in pairs(validTable) do
      if (validTable[key] == "required" and  not self.table[key]) then
         errStr = errStr .. "Required Key missing: " .. key .. "\n"
         ierr   = ierr + 1
      end
   end

   if ( not validActions[self.table.action] ) then
      errStr = errStr .. "Unknown action: " .. self.table.action .. "\n"
      ierr   = ierr + 1
   end

   if (self.table.type == nil) then self.table.type = "string" end

   if (not validTypes[self.table.type]) then
      errStr = errStr .. "Unknown type: " .. self.table.type .. "\n"
      ierr   = ierr + 1
   end

   return ierr, errStr
end

function M.setDefault(self,argTbl)
   local t          = self.table
   if     (t.action == "store_true" ) then argTbl[t.dest] = false
   elseif (t.action == "store_false") then argTbl[t.dest] = true
   elseif (t.action == "count"      ) then argTbl[t.dest] = 0
   elseif (t.action == "append"     ) then argTbl[t.dest] = {}
   elseif (t.default ~= nil         ) then argTbl[t.dest] = t.default
   end
end


function M.new(self, myTable)
   local o = {} 
   setmetatable(o, self)
   self.__index  = self
   o.table       = myTable
   local ierr , errStr = o:bless();
   if (ierr > 0) then
      Optiks_Error(errStr)
   end
   return o
end   

return M
