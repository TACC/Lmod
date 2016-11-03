require("strict")

local FrameStk  = require("FrameStk")
local MName     = require("MName")
local M         = inheritsFrom(MName)
local concatTbl = table.concat
local dbg       = require("Dbg"):dbg()
M.my_name       = "latest"


--------------------------------------------------------------------------
-- Show the latest modifier.
-- @param self A MName object
function M.show(self)
   local a = {}
   a[#a+1] = self.__actionNm
   a[#a+1] = "(\""
   a[#a+1] = self:sn()
   a[#a+1] = "\")"
   return concatTbl(a,"")
end

local s_stepA = {
   MName.find_latest,
}

function M.steps()
   return s_stepA
end

--------------------------------------------------------------------------
-- Do a prereq check to see if version is latest one.
-- @param self A MName object.
function M.prereq(self)
   dbg.start{"MN_Latest:prereq()"}
   local mt        = FrameStk:singleton():mt()
   local sn        = self:sn()
   local status    = mt:status(sn)
   local sn_status = ((status == "active") or (status == "pending"))

   if (not sn_status) then
      dbg.fini("MN_Latest:prereq")
      return self:show()
   end

   local mname   = MName:new("load",sn,"latest")
   local version = mname:version()
   if (not version) then
      dbg.fini("MN_Latest:prereq")
      return self:show()
   end
   if (version ~= mt:version(sn)) then
      dbg.fini("MN_Latest:prereq")
      return self:show()
   end
   dbg.fini("MN_Latest:prereq")
   return false
end

return M
