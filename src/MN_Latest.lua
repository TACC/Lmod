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
