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

require("strict")

local M         = inheritsFrom(MName)
local MT        = require("MT")
local concatTbl = table.concat
local dbg       = require("Dbg"):dbg()
M.my_name       = "latest"

local s_steps = {
   MName.find_exact_match,
   MName.find_latest,
}

function M.show(self)
   local a = {}
   a[#a+1] = self._actName
   a[#a+1] = "(\""
   a[#a+1] = self:sn()
   a[#a+1] = "\")"
   return concatTbl(a,"")
end

local function latestVersion(self)
   local mt    = MT:mt()
   local sn    = self:sn()
   local pathA = mt:locationTbl(sn)
   if (pathA == nil or #pathA == 0) then
      return false
   end

   local found, t = self:find_latest(pathA)
   return extractVersion(t.modFullName, sn)
end


function M.prereq(self)
   dbg.start{"MN_Latest:prereq()"}
   local mt    = MT:mt()
   local sn    = self:sn()
   if (not mt:have(sn, "active")) then
      return self:show()
   end

   local version = latestVersion(self)
   if (not version) then
      return self:show()
   end
   local sv    = mt:Version(sn)
   if (sv ~= version) then
      return self:show()
   end
   return false
end

function M.isloaded(self)
   local mt    = MT:mt()
   local sn    = self:sn()
   if (not mt:have(sn, "active")) then
      return self:isPending()
   end
   local version = latestVersion(self)
   if (not version) then
      return false
   end
   local mt = MT:mt()
   local sv = mt:Version(self:sn())
   return sv == version
end

function M.isPending(self)
   local mt = MT:mt()
   local sn = self:sn()
   if (not mt:have(sn, "pending")) then
      return false
   end
   local version = latestVersion(self)
   if (not version) then
      return false
   end
   local mt = MT:mt()
   local sv = mt:Version(self:sn())
   return sv == version
end

function M.steps()
   return s_steps
end

return M
