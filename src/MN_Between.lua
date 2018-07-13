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

require("parseVersion")

local FrameStk  = require("FrameStk")
local MName     = require("MName")
local M         = inheritsFrom(MName)
local concatTbl = table.concat
M.my_name       = "between"


local s_stepA = {
   MName.find_between,
}

function M.steps()
   return s_stepA
end

--------------------------------------------------------------------------
-- Show the atleast or between modifier.
-- @param self A MName object
function M.show(self)
   local a  = {}
   local nm = self:sn() or self:userName()
   a[#a+1]  = self.__actionNm
   a[#a+1]  = "(\""
   a[#a+1]  = nm .. '"'
   for i = 1, #self.__range do
      if (self.__range[i]) then
         a[#a+1] = ",\""
         a[#a+1] = self.__range[i] .. '"'
      end
   end
   a[#a+1] = ")"
   return concatTbl(a,"")
end

-- Do a prereq check to see name and/or version is loaded.
-- @param self A MName object
function M.prereq(self)
   local mt        = FrameStk:singleton():mt()
   local sn        = self:sn()
   local fullName  = mt:fullName(sn)
   local userName  = self:userName()
   local status    = mt:status(sn)
   local sn_status = ((status == "active") or (status == "pending"))

   if (not sn_status) then
      return self:show()
   end

   local version    = mt:version(sn)
   local pv         = version   and parseVersion(version)   or " "
   local lowerBound = self.__is and parseVersion(self.__is) or " "
   local upperBound = self.__ie and parseVersion(self.__ie) or "~"

   if (pv < lowerBound or pv > upperBound) then
      return self:show()
   end
   return false
end

return M

