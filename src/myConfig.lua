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
--  Copyright (C) 2008-2024 Robert McLay
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
require("capture")
local s_configT = {}
function myConfig(key)
   local result = s_configT[key]
   if (result) then
      return result
   end
   local optionTbl = optionTbl()
   if (key == "username") then
      result = optionTbl.rt and "lmodTestUser" or capture("id -u -n 2> /dev/null"):gsub("\n","")
   elseif (key == "usergroups") then
      local s = capture("id -G -n 2> /dev/null"):gsub("\n","")
      local a = {}
      for g in s:split(" ") do
         a[#a+1] = g
      end
      if (optionTbl.rt) then
         a[#a+1] =  "lmodTestGroup"
      end
      result = a
   elseif (key == "shelltype") then
      result = Shell:name()
   end
   s_configT[key] = result
   return result
end
