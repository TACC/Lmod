require("strict")
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
   local a = {}
   a[#a+1] = self.__actionNm
   a[#a+1] = "(\""
   a[#a+1] = self:sn() .. '"'
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

