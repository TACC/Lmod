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

local M         = inheritsFrom(MName)
local dbg       = require("Dbg"):dbg()
local concatTbl = table.concat
M.my_name       = "between"


local s_steps = {
   MName.find_marked_default_between,
   MName.find_between,
}


function M.show(self)
   local a = {}
   a[#a+1] = self._actName
   a[#a+1] = "(\""
   a[#a+1] = self:sn() .. '"'
   for i = 1, #self._range do
      a[#a+1] = ",\""
      a[#a+1] = self._range[i] .. '"'
   end
   a[#a+1] = ")"
   return concatTbl(a,"")
end
   
function M.prereq(self)
   local result  = false
   local mt      = MT:mt()
   local sn      = self:sn()
   local usrName = self:usrName()

   if (not mt:have(sn,"active")) then
      result = self:show()
   else
      local left       = parseVersion(self._is)
      local right      = parseVersion(self._ie)
      local full       = mt:fullName(sn)
      local pv         = parseVersion(mt:Version(sn))

      if (pv < left or pv > right) then
         result = self:show()
      end
   end
   return result
end   

function M.steps()
   return s_steps
end

return M
