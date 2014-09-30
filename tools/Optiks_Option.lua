------------------------------------------------------------------------
-- This class contains the Option objects.  There is one of these objects
-- for each option specified by Optiks:add_option.
-- @classmod Optiks_Option

require("strict")

------------------------------------------------------------------------
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

-- Option.lua
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


--------------------------------------------------------------------------
-- Find all the option names associated with this option.
-- Treat option with underscores the same as ones with dashes.
-- @param self Optiks_option object.
-- @return an array of option names
function M.optionNames(self)
   local a = self.table.name
   local b = {}
   for i = 1,#a do
      b[#b+1] = a[i]
      if (a[i]:find("_")) then
         b[#b+1] = a[i]:gsub("_","-")
      end
   end
   return b
end

--------------------------------------------------------------------------
-- Test newly build option to see if it is valid.
-- @param self Optiks_option object.
-- @return non-zero means an error
-- @return error message.

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

--------------------------------------------------------------------------
-- Set the default for each option
-- @param self Optiks_option object.
-- @param argTbl The argument table.

function M.setDefault(self, argTbl)
   local t          = self.table
   if     (t.action == "store_true" ) then argTbl[t.dest] = false
   elseif (t.action == "store_false") then argTbl[t.dest] = true
   elseif (t.action == "count"      ) then argTbl[t.dest] = 0
   elseif (t.action == "append"     ) then argTbl[t.dest] = {}
   elseif (t.default ~= nil         ) then argTbl[t.dest] = t.default
   end
end


--------------------------------------------------------------------------
-- Ctor for class
-- @param self Optiks_option object.
-- @param myTable option table.
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
