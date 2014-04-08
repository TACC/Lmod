------------------------------------------------------------------------
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

--------------------------------------------------------------------------
-- string:trim(): remove leading and trailing spaces.

function string:trim()
   local ja = self:find("%S")
   if (ja == nil) then
      return ""
   end
   local  jb = self:find("%s+$") or 0
   local  s  = self:sub(ja,jb-1)
   return s
end

--------------------------------------------------------------------------
-- string:split():  An iterator to loop split a pieces.  This code is
--                  from the lua-users.org/lists/lua-l/2006-12/msg00414.html
--

require("strict")
function string:split(pat)
   pat  = pat or "%s+"
   local st, g = 1, self:gmatch("()("..pat..")")
   local function getter(self, segs, seps, sep, cap1, ...)
      st = sep and seps + #sep
      return self:sub(segs, (seps or 0) - 1), cap1 or sep, ...
   end
   local function splitter(self)
      if st then return getter(self, st, g()) end
   end
   return splitter, self
end
