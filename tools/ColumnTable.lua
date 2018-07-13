--------------------------------------------------------------------------
-- This class is takes a array of strings and produced a multi-column output.
-- Standard usage is:
--
--     local ct = ColumnTable:new{tbl=a, gap=2}
--     io.stderr:write(ct:build_tbl())
--
-- Basic architecture of this class is:
--
--    1.  Use TermWidth to find the width available
--    2.  Chose helper routine depending on if the input table is 1 or 2-D.
--    3.  Compute the size of each row in szA and the min (imin) and max
--        (imax) size for the column.
--    4.  Use imin to compute the maximum number of columns possible.
--    5.  Compute actual number columns that will fit.
--    6.  Knowing the number of rows and columns, build the table.
--
-- @classmod ColumnTable

require("strict")

------------------------------------------------------------------------
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

require("TermWidth")
require("Dbg")
local concatTbl = table.concat
local dbg       = require("Dbg"):dbg()
local getenv    = os.getenv
local max       = math.max
local min       = math.min
local huge      = math.huge
local strlen    = string.len
M = { gap = 3, innerGap = 1 }

local blank = ' '


--------------------------------------------------------------------------
-- compute the number of dimension in input table.
-- @param a
-- @return an array with the number of entries of a in each dimension
local function sizeMe(a)
   local dim = {}
   local rows = #a
   dim[1] = rows
   if (type(a[1]) == "table") then
      local cols = 0
      for i = 1,#a do
         cols = max(cols,#a[i])
      end
      dim[2] = cols
   end
   return dim
end

--------------------------------------------------------------------------
-- Ctor to compute the actual number of rows and columns that will fit.
-- @param self ColumnTable object
-- @param t input table.
function M.new(self,t)
   dbg.start{"ColumnTable:new()"}
   local width
   local tbl   = t
   local o     = {}
   if (t.tbl) then
      tbl = t.tbl
      o   = t
   end

   setmetatable(o, self)
   self.__index  = self
   if (t.width) then
      width = t.width
   else
      width  = TermWidth()
   end

   o.length        = o.len or strlen
   o.term_width    = width
   o.dim           = sizeMe(tbl)
   o._entry_width  = M._entry_width1
   o._display      = M._display1
   o._columnSum    = M._columnSum1
   dbg.print{"dim: ",#o.dim,"\n"}

   if (#o.dim == 2) then
      o._entry_width  = M._entry_width2
      o._display      = M._display2
      o._columnSum    = M._columnSum2
      tbl             = o:_clearEmptyColumns2D(tbl)
      o.dim           = sizeMe(tbl)
   end
   o:_number_of_columns_rows(tbl)
   o.tbl        = tbl
   o.prt        = t.prt or io.write
   dbg.fini("ColumnTable:new")
   return o
end

--------------------------------------------------------------------------
-- This clears empty columns for 2-D tables.
-- @param self ColumnTable object
-- @param tbl input table.
-- @return cleaned up table.
function M._clearEmptyColumns2D(self, tbl)
   local colA = {}
   local length = self.length

   for irow = 1, #tbl do
      local a = tbl[irow]
      for icol = 1, #a do
         colA[icol] = max(colA[icol] or 0, length(a[icol]))
      end
   end

   local movA   = {}
   local icount = 0
   for icol = 1, #colA do
      icount  = icount + 1
      if (colA[icol] > 0) then
         movA[#movA+1] = icount
      end
   end

   local numActiveCol = #movA

   local tt = {}

   for irow = 1, #tbl do
      tt[#tt+1] = {}
      local aa = tt[#tt]
      local a  = tbl[irow]
      for icol = 1, numActiveCol do
         aa[#aa+1] = a[movA[icol]]
      end
   end
   return tt
end

--------------------------------------------------------------------------
-- compute [[szA]] array for a 1-D column.
-- @param self ColumnTable object
-- @param t    input table
-- @param szA  1-D size array
-- @return min length in szA array.
-- @return max length in szA array.
function M._entry_width1(self, t, szA)
   local iminPrt = huge
   local imaxPrt = 0
   local iminWrt = huge
   local imaxWrt = 0

   local length  = self.length
   local sz      = #t
   for i = 1,sz do
      local lenPrt = length(t[i])
      local lenWrt = t[i]:len()
      imaxPrt      = max(imaxPrt, lenPrt)
      iminPrt      = min(iminPrt, lenPrt)
      imaxWrt      = max(imaxWrt, lenWrt)
      iminWrt      = min(iminWrt, lenWrt)
      szA[#szA+1]  = {prt = lenPrt, wrt = lenWrt}
   end
   local imin = {prt = iminPrt, wrt = iminWrt}
   local imax = {prt = imaxPrt, wrt = imaxWrt}
   return imin, imax
end


--------------------------------------------------------------------------
-- compute [[szA]] array for a 2-D column.
-- @param self ColumnTable object
-- @param t    input table
-- @param szA  2-D size array
-- @return min length in szA array.
-- @return max length in szA array.
function M._entry_width2(self, t, szA)
   dbg.start{"ColumnTable:_entry_width2()"}
   local imin   = huge
   local imax   = 0
   local length = self.length
   local minA   = {}
   local maxA   = {}
   local dim2   = self.dim[2]
   local sz     = #t
   for idim = 1, dim2 do
      minA[idim] = {prt = imin, wrt = imin}
      maxA[idim] = {prt = imax, wrt = imax}
   end

   for j = 1, sz do
      local a = t[j]
      local b = {}
      for i = 1,dim2 do
         local entry = a[i] or ""
         b[i]    = {prt = length(entry) or 0,        wrt = entry:len() or 0}
         minA[i] = {prt = min(minA[i].prt,b[i].prt), wrt = min(minA[i].wrt,b[i].wrt)}
         maxA[i] = {prt = max(maxA[i].prt,b[i].prt), wrt = max(maxA[i].wrt,b[i].wrt)}
      end
      szA[#szA+1] = b
   end

   local iminPrt = (dim2-1)*self.innerGap
   local imaxPrt = iminPrt
   local iminWrt = (dim2-1)*self.innerGap
   local imaxWrt = iminWrt

   for idim = 1, dim2 do
      iminPrt = iminPrt + minA[idim].prt
      imaxPrt = imaxPrt + maxA[idim].prt
      iminWrt = iminWrt + minA[idim].wrt
      imaxWrt = imaxWrt + maxA[idim].wrt
   end
   --dbg.printA{name = "minA", a = minA}
   --dbg.printA{name = "maxA", a = maxA}

   imin = {prt = iminPrt, wrt = iminWrt}
   imax = {prt = imaxPrt, wrt = imaxWrt}
   dbg.fini()
   return imin, imax
end

--------------------------------------------------------------------------
-- Use szA to compute max width for a given column range for a 1-D array.
-- @param self ColumnTable object
-- @param istart index to start at in 1-D array.
-- @param iend   index to end at in 1-D array.
-- @return max column width
-- @return An array with the max length in direction
function M._columnSum1(self, istart, iend)
   local szA     = self.szA
   local maxVprt = 0
   local maxVwrt = 0

   for i = istart, iend do
      maxVprt = max(maxVprt, szA[i].prt)
      maxVwrt = max(maxVwrt, szA[i].wrt)
   end
   local maxV = {prt=maxVprt, wrt=maxVwrt}
   return maxV, {maxV}
end

--------------------------------------------------------------------------
-- Use szA to compute max width for a given column range for a 2-D array.
-- @param self ColumnTable object
-- @param istart index to start at in 2-D array.
-- @param iend   index to end at in 2-D array.
-- @return max column width
-- @return An array with the max length in direction
function M._columnSum2(self, istart, iend)
   local szA  = self.szA
   local dim2 = self.dim[2]
   local maxA = {}

   for idim = 1, dim2 do
      maxA[idim] = {prt = 0, wrt = 0}
   end
   for i = istart, iend do
      local a = szA[i]
      for idim = 1, dim2 do

         maxA[idim].prt = max(maxA[idim].prt, a[idim].prt)
         maxA[idim].wrt = max(maxA[idim].wrt, a[idim].wrt)
      end
   end

   local maxVprt  = 0
   local maxVwrt  = 0
   local found    = false
   for idim = dim2, 1, -1 do
      if (found or maxA[idim].prt > 0) then
         found   = true
         maxVprt = maxVprt + self.innerGap
         maxVwrt = maxVwrt + self.innerGap
      end
      maxVprt  = maxVprt + maxA[idim].prt
      maxVwrt  = maxVwrt + maxA[idim].wrt
   end

   --dbg.print{"is: ",istart," ie: ",iend, " maxV: ",maxV, " sum: ",sum}
   --dbg.printA{name = "maxA", a = maxA}
   return {prt=maxVprt, wrt=maxVwrt}, maxA
end

--------------------------------------------------------------------------
-- Pad string with trailing spaces to get to correct width for a 1-D array
-- @param self ColumnTable object
-- @param i the i'th entry to pad in self.tbl
-- @param icol in the column
-- @return s padded entry.
function M._display1(self, i, icol)
   local width = self.columnCnt[icol]
   local szA   = self.szA
   local gap   = self.gap 
   local s     = self.tbl[i] .. blank:rep(width.prt-szA[i].prt+gap)

   return s
end

--------------------------------------------------------------------------
-- Pad string with trailing spaces to get to correct width for a 2-D array
-- @param self ColumnTable object
-- @param i the i'th entry to pad in self.tbl
-- @param icol in the column
-- @return s padded entry.
function M._display2(self,i, icol)
   local width    = self.columnCnt[icol].prt
   local widthA   = self.columnCntI[icol]
   local dim2     = self.dim[2]
   local innerGap = self.innerGap
   local a        = self.tbl[i]
   local szA      = self.szA[i]

   local b        = {}
   local sum      = 0

   local lastCol  = dim2
   for j = dim2, 1, -1 do
      if (widthA[j].prt > 0) then break end
      lastCol = j - 1
   end

   for idim = 1, dim2 do
      b[#b+1]    = a[idim]
      local len1 = szA[idim].prt
      sum        = sum + len1
      local len2 = widthA[idim].prt - len1
      if (idim < lastCol) then
         len2    = len2 + innerGap
      end
      b[#b+1]    = blank:rep(len2)
      sum        = sum + len2
   end
   b[#b+1]       = blank:rep(width - sum)
   local s       = concatTbl(b,"")
   return s
end


--------------------------------------------------------------------------
-- Compute the number of rows and columns that will fit.
-- @param self ColumnTable object
-- @param t input table
function M._number_of_columns_rows(self,t)
   dbg.start{"ColumnTable:_number_of_columns_rows()"}
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
   local imin, imax = self:_entry_width(t, szA)
   dbg.print{"width: ",self.term_width," imin: ",imin.prt,",",imin.wrt,
             " imax: ",imax.prt,", ",imax.wrt,"\n"}

   -------------------------------------------------------------------------
   -- Quit early if max width in table t is bigger than the number of
   -- columns in terminal (self.term_width)
   -------------------------------------------------------------------------
   if (imax.prt >= self.term_width) then
      self.ncols      = 1
      self.nrows      = sz
      self.columnCnt  = {}
      self.columnCntI = {}
      self.columnCnt[1], self.columnCntI[1] = self:_columnSum(1,sz)
      dbg.print{"imax.prt >= self.term_width\n"}
      dbg.fini()
      return
   end


   local columnCnt   = {}
   local columnCntI  = {}
   local max_columns = floor(min(self.term_width/imin.prt, sz))
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
         columnCnt[icol], columnCntI[icol] = self:_columnSum(istart,iend)
         istart = istart + nrows
      end

      local sumWrt = 0
      local sumPrt = 0
      for icol = 1,ncols do
	 sumWrt = sumWrt + columnCnt[icol].wrt
	 sumPrt = sumPrt + columnCnt[icol].prt
      end

      dbg.print{"ncols: ",ncols, " sumWrt: ",sumWrt," sumPrt: ",sumPrt,"\n"}

      ----------------------------------------------------------------------
      -- Use sumPrt to wrap the columns at the number of printed characters.
      -- Use sumWrt to wrap the columns at the number of written characters.

      local sum = sumPrt
      if (sum < self.term_width) then
         results = ncols
         break
      end
   end

   local istart = 1
   local iskip  = nrows - 1
   local ncols  = results or 1
   nrows        = math.ceil(sz/ncols)
   dbg.print{"ncols: ",ncols,", nrows: ",nrows,"\n"}

   self.ncols   = math.ceil(sz/nrows)
   self.nrows   = nrows
   dbg.print{"self.ncols: ",self.ncols,"\n"}
   ncols        = self.ncols
   columnCnt    = {}
   columnCntI   = {}
   for icol = 1, ncols do
      local iend = min(istart + iskip, sz)
      columnCnt[icol], columnCntI[icol] = self:_columnSum(istart,iend)
      istart = istart + nrows
   end

   dbg.print{"ncols: ",ncols,"\n"}
   --dbg.printA{name="columnCnt",  a=columnCnt}
   --dbg.printA{name="columnCntI", a=columnCntI}

   self.columnCnt  = columnCnt
   self.columnCntI = columnCntI
   dbg.fini()
end


--------------------------------------------------------------------------
-- Use actual number of rows in columns that will fit and generate the table.
-- @param self ColumnTable object
-- @return string that is the ColumnTable.
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
	    t[icol] = self:_display(loc, icol)
	 end
      end
      local loc = irow + (ncols - 1) * nrows
      if (loc <= self.sz ) then
	 t[self.ncols] = self:_display(loc, ncols)
      end

      local s = concatTbl(t,''):gsub("%s+$","")
      a[#a+1] = s
   end
   return concatTbl(a,"\n")
end

---- finis -----
return M
