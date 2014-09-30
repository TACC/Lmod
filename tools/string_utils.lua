--------------------------------------------------------------------------
-- More string utilities.
-- @classmod string

require("strict")

--------------------------------------------------------------------------
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
-- remove leading and trailing spaces.
-- @param self input string

function string.trim(self)
   local ja = self:find("%S")
   if (ja == nil) then
      return ""
   end
   local  jb = self:find("%s+$") or 0
   local  s  = self:sub(ja,jb-1)
   return s
end

--------------------------------------------------------------------------
-- An iterator to loop split a pieces.  This code is from the
-- lua-users.org/lists/lua-l/2006-12/msg00414.html
-- @param self input string
-- @param pat pattern to split on.

function string.split(self, pat)
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

--------------------------------------------------------------------------
-- Form a case independent search string pattern.
-- @param self input string

function string.caseIndependent(self)
   local slen = self:len()
   local a    = {}
   for i = 1, slen do
      local c = self:sub(i,i)
      if (c:find("%a")) then
         a[#a+1] = '['..c:upper()..c:lower()..']'
      elseif (c:find('[%-%.%+%[%]%(%)%$%^%%%?%*]')) then
         a[#a+1] = '%'..c
      else
         a[#a+1] = c
      end
   end
   return concatTbl(a,"")
end
