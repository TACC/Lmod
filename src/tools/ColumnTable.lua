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

--------------------------------------------------------------------------
-- ColumnTable: This class is takes a array of strings and produced
--              a multi-column output.  Standard usage is:
-- 
--     local ct = ColumnTable:new{tbl=a, gap=2}
--     io.stderr:write(ct:build_tbl())
--------------------------------------------------------------------------
-- Basic architecture of this class is:
--   a) Use TermWidth to find the width available
--   b) Chose helper routine depending on if the input table is 1 or 2-D.
--   c) Compute the size of each row in szA and the min (imin) and max
--      (imax) size for the column.
--   d) Use imin to compute the maximum number of columns possible.
--   e) Compute actual number columns that will fit.
--   f) Knowing the number of rows and columns, build the table.

require("strict")
require("TermWidth")
require("Dbg")
local concatTbl = table.concat
local Dbg       = require("Dbg")
local getenv    = os.getenv
local max       = math.max
local min       = math.min
local huge      = math.huge
local strlen    = string.len
M = { gap = 3, innerGap = 1 }

local blank = ' '

--------------------------------------------------------------------------
-- sizeMe and sizeMeHelper() : compute the number of dimension in input
--                             tbl.
local function sizeMeHelper(a,dim)
   if (type (a) == "table") then
      dim[#dim+1] = #a
      sizeMeHelper(a[1],dim)
   end
end

local function sizeMe(a)
   local dim = {}
   sizeMeHelper(a,dim)
   return dim
end

--------------------------------------------------------------------------
-- ColumnTable:new(): Compute the actual number of rows and columns that
--                    will fit.
function M.new(self,t)
   local dbg = Dbg:dbg()
   local tbl = t
   local o   = {}
   if (t.tbl) then
      tbl = t.tbl
      o   = t
   end

   dbg.start("ColumnTable:new()")
   setmetatable(o, self)
   self.__index  = self
   local width  = 80
   if (getenv("TERM")) then
      width  = TermWidth()
   end

   o.length        = o.len or strlen
   o.term_width    = width
   o.dim           = sizeMe(tbl)
   o.__entry_width = M.__entry_width1
   o.__display     = M.__display1
   o.__columnSum   = M.__columnSum1
   if (#o.dim == 2) then
      o.__entry_width = M.__entry_width2
      o.__display     = M.__display2
      o.__columnSum   = M.__columnSum2
   end
   o:__number_of_columns_rows(tbl)
   o.tbl        = tbl
   o.prt        = t.prt or io.write
   dbg.fini()
   return o
end

function M.print_tbl(self)
   local prt = self.prt
   local s   = self:build_tbl()
   prt(s,"\n")
end

--------------------------------------------------------------------------
-- ColumnTable:__entry_width1(): compute [[szA]] array for a 1-D column.

function M.__entry_width1(self, t, szA)
   local imin   = huge
   local imax   = 0

   local length = self.length

   local sz     = #t
   for i = 1,sz do
      local len   = length(t[i])
      imax        = max(imax, len)
      imin        = min(imin, len)
      szA[#szA+1] = len
   end
   return imin, imax
end


--------------------------------------------------------------------------
-- ColumnTable:__entry_width2(): compute [[szA]] array for a 2-D column.

function M.__entry_width2(self, t, szA)
   local dbg       = Dbg:dbg()
   dbg.start("ColumnTable:__entry_width2()")
   local imin      = huge
   local imax      = 0
   local length    = self.length
   local len       = 0
   local minA      = {}
   local maxA      = {}
   local dim2      = self.dim[2]
   local sz        = #t
   for idim = 1, dim2 do
      minA[idim] = imin
      maxA[idim] = imax
   end

   for j = 1, sz do
      local a = t[j]
      local b = {}
      for i = 1,#a do
         b[i]    = length(a[i])
         minA[i] = min(minA[i],b[i])
         maxA[i] = max(maxA[i],b[i])
      end
      szA[#szA+1] = b
   end

   imin = dim2*self.innerGap
   imax = imin
   dbg.print("initial imin: ",imin,"\n")

   for idim = 1, dim2 do
      imin = imin + minA[idim]
      imax = imax + maxA[idim]
   end
   dbg.fini()
   return imin, imax
end

--------------------------------------------------------------------------
-- ColumnTable:__columnSum1(): Use szA to compute max width for a given
--                             column range for a 1-D array.


function M.__columnSum1(self, istart, iend)
   local szA  = self.szA
   local maxV = 0
   for i = istart, iend do
      maxV = max(maxV, szA[i])
   end
   return maxV, {maxV}
end

--------------------------------------------------------------------------
-- ColumnTable:__columnSum2(): Use szA to compute max width for a given
--                             column range for a 2-D array.

function M.__columnSum2(self, istart, iend)
   local szA  = self.szA
   local dim2 = self.dim[2]
   local maxA = {}

   for idim = 1, dim2 do
      maxA[idim] = 0
   end
   for i = istart, iend do
      local a = szA[i]
      for idim = 1, dim2 do
         maxA[idim] = max(maxA[idim], a[idim])
      end
   end

   local maxV = 0
   for idim = 1, dim2 do
      maxV = maxV + maxA[idim]
   end
   return maxV + dim2*self.innerGap, maxA
end

--------------------------------------------------------------------------
-- ColumnTable:__display1(): Pad string with trailing spaces to get to
--                           correct width for a 1-D array
function M.__display1(self, i, icol)
   local width = self.columnCnt[icol]
   local szA   = self.szA
   local s     = self.tbl[i] .. blank:rep(width-szA[i])
   return s
end

--------------------------------------------------------------------------
-- ColumnTable:__display2(): Pad string with trailing spaces to get to
--                           correct width for a 2-D array
function M.__display2(self,i, icol)
   local width    = self.columnCnt[icol]
   local widthA   = self.columnCntI[icol]
   local dim2     = self.dim[2]
   local innerGap = self.innerGap
   local a        = self.tbl[i]
   local szA      = self.szA[i]

   local b        = {}
   local sum      = 0
   local len      = 0

   for idim = 1, dim2 do
      b[#b+1]    = a[idim]
      local len1 = szA[idim]
      sum        = sum + len1
      local len2 = widthA[idim] - len1 + innerGap
      b[#b+1]    = blank:rep(len2)
      sum        = sum + len2
   end
   b[#b+1]      = blank:rep(width - sum)

   return concatTbl(b,"")
end


--------------------------------------------------------------------------
-- Compute the number of rows and columns that will fit.

function M.__number_of_columns_rows(self,t)
   local dbg    = Dbg.dbg()
   dbg.start("ColumnTable:__number_of_columns_rows()")
   local floor  = math.floor
   local ceil   = math.ceil
   local gap    = self.gap
   local szA    = {}
   local sz     = #t
   self.sz      = sz
   self.szA     = szA

   -------------------------------------------------------------------------
   -- Compute length of each entry in table t
   -------------------------------------------------------------------------
   local imin, imax = self:__entry_width(t, szA)
   dbg.print("width: ",self.term_width," imin: ",imin," imax: ",imax,"\n")

   -------------------------------------------------------------------------
   -- Quit early if max width in table t is bigger than the number of
   -- columns in terminal (self.term_width)
   -------------------------------------------------------------------------
   if (imax >= self.term_width) then
      self.ncols      = 1
      self.nrows      = sz
      self.columnCnt  = {imax}
      self.columnCntI = {imax}
      dbg.print("imax >= self.term_width\n")
      dbg.fini()
      return
   end


   local sum         = 0
   local columnCnt   = {}
   local columnCntI  = {}
   local max_columns = floor(min(self.term_width/imin, sz))
   local nrows       = ceil(sz/max_columns)
   max_columns       = ceil(sz/nrows)


   -----------------------------------------------------------------------
   -- Start with the max possible number of columns and keep reducing
   -- until it fits. Then quit.

   local results
   for ncols = max_columns, 1, -1  do
      nrows = floor(sz/ncols)
      if ( nrows*ncols < sz ) then
        nrows = nrows + 1
      end

      columnCnt = {}
      local istart = 1
      local iskip  = nrows - 1
      for icol = 1, ncols do
         local iend = min(istart + iskip, sz)
         columnCnt[icol], columnCntI[icol] = self:__columnSum(istart,iend)
         istart = istart + nrows
      end

      sum = 0
      for icol = 1,ncols-1 do
         columnCnt[icol] = columnCnt[icol] + gap
	 sum             = sum + columnCnt[icol]
      end
      sum = sum + columnCnt[ncols]

      if (sum < self.term_width) then
         results = ncols
         break
      end
   end

   local ncols     = results
   local nrows     = math.ceil(sz/ncols)
   self.ncols      = math.ceil(sz/nrows)
   self.nrows      = nrows
   self.columnCnt  = columnCnt
   self.columnCntI = columnCntI
   dbg.fini()
end


--------------------------------------------------------------------------
-- ColumnTable:build_tbl(): Use actual number of rows in columns that will
--                          fit and generate the table.

function M.build_tbl(self)
   local a         = {}
   local columnCnt = self.columnCnt
   local nrows     = self.nrows
   local ncols     = self.ncols

   for irow = 1, nrows do
      local t = {}
      for icol = 1, ncols - 1 do
	 local loc = irow + (icol - 1) * self.nrows
	 if (loc <= self.sz ) then
	    t[icol] = self:__display(loc, icol)
	 end
      end
      local loc = irow + (ncols - 1) * nrows
      if (loc <= self.sz ) then
	 t[self.ncols] = self:__display(loc, ncols)
      end
      local s = concatTbl(t,''):gsub("%s+$","")
      a[#a+1] = s
   end
   return concatTbl(a,"\n")
end

return M
