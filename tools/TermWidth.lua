--------------------------------------------------------------------------
-- Use tput cols to find the number of columns.  Then check
-- stderr to see if it is connected to a tty.  If not then
-- use 80 columns wide as default.
--
-- @module TermWidth

require("strict")

-----------------------------------------------------------------------
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


require("haveTermSupport")
require("capture")
local capture = capture or function (s) return nil end
local getenv  = os.getenv
local term    = false
local s_width = false
local min     = math.min
local s_DFLT  = 80

------------------------------------------------------------------------
-- Ask system for width.

local function l_askSystem(width)

   -- try stty size
   local r_c = capture("stty size 2> /dev/null")
   local i, j, rows, columns = r_c:find('(%d+)%s+(%d+)')
   if (i) then
      return tonumber(columns)
   end

   -- Try tput cols
   if (getenv("TERM")) then
      local result  = capture("tput cols 2> /dev/null")
      i, j, columns = result:find("^(%d+)")
      if (i) then
         return tonumber(columns)
      end
   end

   return width
end


--------------------------------------------------------------------------
-- Returns the number of columns to use as the terminal width.

function TermWidth()
   if (s_width) then
      return s_width
   end
   local ltw = tonumber(getenv("LMOD_TERM_WIDTH"))  -- Note tonumber(nil) is nil not zero
   if (ltw) then
      s_width = ltw
      return s_width
   end
   s_DFLT    = ltw or s_DFLT
   s_width   = s_DFLT
   if (haveTermSupport()) then
      s_width = l_askSystem(s_width)
   end

   local maxW = ltw or math.huge

   s_width = min(maxW, s_width)
   s_width = (s_width > 30) and s_width or 30

   return s_width
end
