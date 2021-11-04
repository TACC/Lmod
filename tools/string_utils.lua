--------------------------------------------------------------------------
-- More string utilities.
-- @classmod string

require("strict")

--------------------------------------------------------------------------
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

local isLua51   = _VERSION:match('5%.1$')
local concatTbl = table.concat

--------------------------------------------------------------------------
-- Convert a search string that may have special regular expression and
-- quote them.  This is very useful when trying to match version numbers
-- like "2.4-1" where you want "." and "-" to treated as normal characters
-- and not regular expression ones.
-- @param  self Input string.
-- @return escaped string.

function string.escape(self)
   if (self == nil) then return nil end
   local res = self:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]','%%%1')
   if isLua51 then
      res = res:gsub('%z','%%z')
   end
   return res
end

--------------------------------------------------------------------------
-- An iterator to loop split a pieces.  This code is from the
-- lua-users.org/lists/lua-l/2006-12/msg00414.html
-- @param self input string
-- @param pat pattern to split on.

function string.split(self, pat)
   pat  = pat or "%s+"
   local st, g = 1, self:gmatch("()("..pat..")")
   local function l_getter(myself, segs, seps, sep, cap1, ...)
      st = sep and seps + #sep
      return myself:sub(segs, (seps or 0) - 1), cap1 or sep, ...
   end
   local function l_splitter(myself)
      if st then return l_getter(myself, st, g()) end
   end
   return l_splitter, self
end

function string.trim(self)
   local ja = self:find("%S")
   if (ja == nil) then
      return ""
   end
   local  jb = self:find("%s+$") or 0
   return self:sub(ja,jb-1)
end

--------------------------------------------------------------------------
-- Form a case independent search string pattern.
-- @param self input string
-- @return case independent search string pattern.
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

--------------------------------------------------------------------------
-- Wrap input string with double quotes
-- @param  self Input string
-- @return A string surrounded with double quotes internal double quotes backslashed
-- @return A string where every special character is quoted
function string.multiEscaped(self)
   if (type(self) ~= 'string') then
      self = tostring(self)
   end
   self = self:gsub("[? \\\t{}|<>!;#^$&*\"'`()~%[%]]","\\%1")
   return self
end

-- [ - ]
--------------------------------------------------------------------------
-- Wrap input string with double quotes
-- @param  self Input string
-- @return A string surrounded with double quotes internal double quotes backslashed
function string.doubleQuoteString(self)
   if (type(self) ~= 'string') then
      self = tostring(self)
   else
      self = ('%q'):format(self)
   end
   return self
end

--------------------------------------------------------------------------
-- Escape @ character in input string.
-- @param  self Input string.
-- @return   An escaped @ in output.
function string.atSymbolEscaped(self)
   if (self == nil) then return self end
   self = self:gsub('@','\\@')
   return self
end

--------------------------------------------------------------------------
-- Pass in *line* and convert text to fit space.
-- @param self Input string
-- @param indent A number of spaces use to indent each line
-- @param width terminal width.
-- @return filled and wrap block of lines.
function string.fillWords(self, indent, width)
   local a   = {}
   local ia  = 0
   local len = 0

   ia = ia + 1; a[ia] = indent; len = len + indent:len()

   for word in self:split("[ \n]+") do
      local wlen = word:len()
      if (wlen + len >= width) then
         a[ia] = a[ia]:trim()
         ia = ia + 1; a[ia] = "\n";
         ia = ia + 1; a[ia] = indent; len = indent:len()
      end
      ia = ia + 1; a[ia] = word;
      ia = ia + 1; a[ia] = " ";
      len = len + wlen + 1
   end
   a[ia] = a[ia]:trim()
   return concatTbl(a,"")
end
