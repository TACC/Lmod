--------------------------------------------------------------------------
-- Use tput cols to find the number of columns.  Then check
-- stderr to see if it is connected to a tty.  If not then
-- use 80 columns wide as default.
--
-- @module TermWidth

require("strict")

-----------------------------------------------------------------------
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


require("capture")
local capture = capture or function (s) return nil end
local getenv  = os.getenv
local term    = false
local s_width = false
local min     = math.min
local s_DFLT  = 80
if (pcall(require,"term")) then
   term = require("term")
end

------------------------------------------------------------------------
-- Ask system for width.

local function askSystem(width)

   -- try stty size
   local r_c = capture("stty size 2> /dev/null")
   local i, j, rows, columns = r_c:find('(%d+)%s+(%d+)')
   if (i) then
      return tonumber(columns)
   end

   -- Try env var COLUMNS
   columns = getenv("COLUMNS")
   if (columns) then
      return tonumber(columns)
   end

   -- Try tput cols
   local result = os.execute("tput cols 2> /dev/null")
   if (result) then
      return tonumber(capture("tput cols"))
   end

   return width
end
   
--------------------------------------------------------------------------
-- Return true/false if the *term* interface exists.

function haveTermSupport()
   return (not (not term))
end

--------------------------------------------------------------------------
-- Returns the number of columns to use as the terminal width.

function TermWidth()
   if (s_width) then
      return s_width
   end
   s_DFLT  = tonumber(getenv("LMOD_TERM_WIDTH")) or s_DFLT
   s_width = s_DFLT
   if (getenv("TERM") and term and term.isatty(io.stderr)) then
      s_width = askSystem(s_width)
   end

   local maxW = tonumber(getenv("LMOD_TERM_WIDTH")) or math.huge

   s_width = min(maxW, s_width)

   s_width = (s_width > 30) and s_width or 30

   return s_width
end
