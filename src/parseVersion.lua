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
require("string_split")
local Dbg          = require("Dbg")
local concatTbl    = table.concat

replaceT = {
   pre     = "c",
   preview = "c",
   ['-']   = "zfinal-",
   ['-p']  = "zfinal-",
   p       = "zfinal-",
   rc      = "c",
   dev     = "@",
}

------------------------------------------------------------------------
-- The returned value will be an array of string. Numeric portions of the
-- version are padded to 9 digits so they will compare numerically, but
-- without relying on how numbers compare relative to strings. Dots are dropped,
-- but dashes are retained. Trailing zeros between alpha segments or dashes
-- are suppressed, so that e.g. "2.4.0" is considered the same as "2.4".
-- Alphanumeric parts are lower-cased.

-- The algorithm assumes that strings like "-" and any alpha string that
-- alphabetically follows "final" represents a "patch level". So, "2.4-1"
-- is assumed to be a branch or patch of "2.4", and therefore "2.4.1" is
-- considered newer than "2.4-1", which in turn is newer than "2.4".  Also
-- 2.4p2 and 2.4-p2 are considered to be the same as 2.4-2.

-- Strings like "a", "b", "c", "alpha", "beta", "candidate" and so on
-- (that come before "final" alphabetically) are assumed to be pre-release
-- versions, so that the version "2.4" is considered newer than "2.4a1".
-- Any "-" characters preceding a pre-release indicator are removed.

-- Finally, to handle miscellaneous cases, the strings "pre", "preview",
-- and "rc" are treated as if they were "c", i.e. as though they were
-- release candidates, and therefore are not as new as a version string
-- that does not contain them. And the string "dev" is treated as if it
-- were an "@" sign; that is, a version coming before even "a" or "alpha".

function parseVersion(versionStr)

   local dbg = Dbg:dbg()

   --dbg.start("parseVersion(",versionStr,")")

   local vA = {}
   for part in parseVersionParts(versionStr) do

      if ( part:sub(1,1) == "*") then
         -- Remove extra "-"
         if ( part ~= "*zfinal") then
            while (#vA > 0 and vA[#vA] == "*zfinal-") do
               vA[#vA] = nil
            end
         end

         -- Removing trailing zeros from each series of numerial parts
         while (#vA > 0 and vA[#vA] == "000000000") do
            vA[#vA] = nil
         end

         -- Along with the above code this removes "-0"
         -- This way "3.2-0", "3.2-p0" and "3.2p0" are the
         -- same as "3.2"

         if (part == "*zfinal") then
            while (#vA > 0 and vA[#vA] == "*zfinal-") do
               vA[#vA] = nil
            end
         end
      end
      vA[#vA+1] = part
   end

   --dbg.print("versionStr: ",versionStr," results: ",concatTbl(vA,"."),"\n")
   --dbg.fini()
   return vA
end

function parseVersionParts(versionStr)
   local s     = versionStr:lower()
   local s_end = s:len()
   local ipos  = 1
   local dbg   = Dbg:dbg()
   local i,j, results
   return
      function()
         -- skip over "."
         if (ipos <= s_end and s:sub(ipos,ipos) == ".") then
            ipos = ipos + 1
         end

         -- end iterator
         if (ipos > (s_end + 1)) then
            return nil
         end

         -- end of version string
         if (ipos  == (s_end + 1)) then
            ipos = ipos + 1
            return "*zfinal"
         end

         --dbg.print("s:sub(ipos,-1): ",s:sub(ipos,-1),"\n")

         -- grab all numbers and pad to nine places with zeros
         i,j = s:find("^%d+",ipos)
         if (i) then
            ipos = j + 1
            return string.format("%09d",s:sub(i,j))
         end

         -- grab all letters, then use replaceT table to normalize
         i,j = s:find("^%a+",ipos)
         if (i) then
            ipos = j + 1
            results = s:sub(i,j)
            return "*" .. ( replaceT[results] or results )
         end

         -- grab "-p"
         i,j = s:find("^-p",ipos)
         if (i) then
            ipos = j + 1
            return "*zfinal-"
         end

         -- return any single character as
         results = s:sub(ipos,ipos)

         ipos    = ipos + 1
         return "*" .. (replaceT[results] or results)
      end
end

