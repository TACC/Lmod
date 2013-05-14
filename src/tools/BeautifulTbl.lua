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

-- Beautiful_tbl.lua

require("strict")
require("string_split")
local Dbg          = require("Dbg")
local concatTbl	   = table.concat
local max	   = math.max
local strlen       = string.len
local stdout       = io.stdout

local M = { gap = 2}

local blank = ' '

local function prt(...)
   stdout:write(...)
end



function M.new(self, t)
   local tbl = t
   local o = {}
   if (t.tbl) then
      tbl = t.tbl
      o   = t
   end

   setmetatable(o, self)
   self.__index  = self

   o.length   = o.len or strlen
   prt        = t.prt or prt
   o.justifyT = t.justifyT or {}
   o.tbl      = o:__build_tbl(tbl)
   o.column   = o.column  or 0
   o.wrapped  = o.wrapped or false
   return o
end

function M.build_tbl(self)
   local dbg    = Dbg:dbg()
   --dbg.start("BeautifulTbl:build_tbl()")
   local length = self.length
   
   local width = 0
   local simple = true
   if (self.wrapped and self.column > 0) then
      for i = 1, #self.columnCnt-1 do
         width = width + self.columnCnt[i]
      end
      local last = self.columnCnt[#self.columnCnt]
      simple = (width > self.column-20) or (width + last < self.column)
   end

   local a  = {}
   local tt = self.tbl

   if (next(tt) == nil) then
      --dbg.print("Empty Table")
      --dbg.fini("BeautifulTbl:build_tbl")
      return nil
   end

   --dbg.print("simple: ",simple,"\n")

   if (simple) then
      for j = 1,#tt do
         local t = tt[j]
         t[#t] = t[#t]:gsub("%s+$","")
         a[j]  = concatTbl(t,"")
      end
      return concatTbl(a,"\n")
   end

   self.column = self.column - 1
   local gap   = self.column - width
   local fill  = string.rep(" ",width+self.gap*(#self.columnCnt-1))

   --dbg.print("column: ",self.column,", gap: ",gap,"\n")

   -- printing a wrapped last column
   for j = 1, #tt do
      local aa = {}
      local t = tt[j]
      for i = 1, #t-1 do
         aa[#aa+1] = t[i]
      end

      local icnt = width
      local s = t[#t] or ""
      for w in s:split("%s+") do
         local wlen = length(w)+1
         if (w == "") then
            wlen = 0
         elseif (icnt + wlen < self.column or wlen > gap) then
            aa[#aa+1] = w .. " "
         else
            aa[#aa]   = aa[#aa]:gsub("%s+$","")
            aa[#aa+1] = "\n"
            a[#a + 1] = concatTbl(aa,"")
            aa        = {}
            aa[1]     = fill
            icnt      = width
            aa[2]     = w .. " "
         end
         icnt = icnt + wlen
      end
      aa[#aa]   = aa[#aa]:gsub("%s+$","")
      aa[#aa+1] = "\n"
      a[#a + 1] = concatTbl(aa,"")
   end
   --dbg.fini("BeautifulTbl:build_tbl")
   return concatTbl(a,"")
end


function M.__build_tbl(self,tblIn)
   local dbg = Dbg:dbg()
   --dbg.start("BeautifulTbl:__build_tbl(tblIn)")

   local length    = self.length
   local columnCnt = {}
   local maxnc     = 1
   local tbl       = {}
   local icol,irow
   local justifyT  = {}

   for _,a  in ipairs(tblIn) do
      icol = 0
      for _, v in ipairs(a) do
	 icol = icol + 1
	 columnCnt[icol] = max(length(v), columnCnt[icol] or 0)
      end
   end

   maxnc = #columnCnt
   for icol = 1, maxnc do
      local s             = (self.justifyT[icol] or ""):lower():sub(1,1)
      justifyT[icol]      = (s == "r") and "r" or "l"
      self.justifyT[icol] = justifyT[icol]
   end

   local gap = self.gap

   for _,a  in ipairs(tblIn) do
      icol = 0
      irow = #tbl+1
      tbl[irow] = {}

      for _,v in ipairs(a) do
         v = tostring(v)
	 icol = icol + 1
         local nspaces = columnCnt[icol] - length(v)
         if (justifyT[icol] == "l") then
            tbl[irow][icol] = v .. blank:rep(nspaces+gap)
         else
            tbl[irow][icol] = blank:rep(nspaces) .. v .. blank:rep(gap)
         end
      end
   end

   --if (dbg.active()) then
   --   dbg.print("#columnCnt: ",#columnCnt,"\n")
   --   local a = {}
   --   a[#a+1] = "columnCnt:"
   --   for i = 1,#columnCnt do
   --      a[#a+1] = tostring(columnCnt[i])
   --   end
   --   dbg.print(concatTbl(a," "),"\n")
   --
   --   for irow = 1,#tbl do
   --      dbg.print("")
   --      for icol = 1, #tbl[irow] do
   --         io.stderr:write("|",tbl[irow][icol])
   --      end
   --      io.stderr:write("|\n")
   --   end
   --end

   self.columnCnt = columnCnt
   --dbg.fini("BeautifulTbl:__build_tbl")
   return tbl
end

return M
