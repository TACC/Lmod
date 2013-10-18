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
local dbg       = require("Dbg"):dbg()
local concatTbl = table.concat
--------------------------------------------------------------------------
-- Pager: This file provides two ways to use the pager.  If stderr is
--        connected to a term and it is configured for it, stderr will be
--        run through the pager.  If not bypassPager is used which just
--        writes all strings to the stream "f".

s_pager = false

--------------------------------------------------------------------------
-- bypassPager(): all input arguments to stream f

function bypassPager(f, ...)
   local arg = { n = select('#', ...), ...}
   for i = 1, arg.n do
      f:write(arg[i])
   end
end


--------------------------------------------------------------------------
-- usePager(): Use pager to present input arguments to user via whatever
--             pager has been chosen.

function usePager(f, ...)
   dbg.start("usePager()")
   if (not s_pager) then
      local pager = os.getenv("PAGER") or Pager
      s_pager = findInPath(pager)
      if (s_pager == "") then
         bypassPager(f, ...)
         return
      end
      if (pager == "more") then
         s_pager = s_pager .. " -f"
      end
   end
   local p = io.popen(s_pager .. " 1>&2" ,"w")
   local s = concatTbl({...},"")
   p:write(s)
   p:close()
   dbg.fini()
end
