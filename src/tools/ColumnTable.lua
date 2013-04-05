-- -*- lua -*-
require("strict")
require("TermWidth")
require("Dbg")
local concatTbl = table.concat
local Dbg       = require("Dbg")
local getenv    = os.getenv
local max       = math.max
local min       = math.min
local strlen    = string.len
M = { gap = 3, innerGap = 1 }

local blank = ' '

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
   o.tbl        = o:__build_tbl(tbl)
   o.prt        = t.prt or io.write
   dbg.fini()
   return o
end

function M.__build_tbl(self,tt)

   -- Compute Max possible number of columns
   self:__number_of_columns_rows(tt)

   return tt
end

function M.print_tbl(self)
   local prt = self.prt
   local s   = self:build_tbl()
   prt(s,"\n")
end

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
      local s = concatTbl(t,''):gsub(" +$","")
      a[#a+1] = s
   end
   return concatTbl(a,"\n")
end

function M.__entry_width1(self, t, szA, imin, imax)
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


function M.__entry_width2(self, t, szA, imin, imax)
   local dbg       = Dbg:dbg()
   dbg.start("ColumnTable:__entry_width2()")
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

function M.__columnSum1(self, istart, iend)
   local szA  = self.szA
   local maxV = 0
   for i = istart, iend do
      maxV = max(maxV, szA[i])
   end
   return maxV, {maxV}
end

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

function M.__display1(self, i, icol)
   local width = self.columnCnt[icol]
   local szA   = self.szA
   local s     = self.tbl[i] .. blank:rep(width-szA[i])
   return s
end

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


function M.__number_of_columns_rows(self,t)
   local dbg    = Dbg.dbg()
   dbg.start("ColumnTable:__number_of_columns_rows()")
   local floor  = math.floor
   local ceil   = math.ceil
   local imax   = 0
   local imin   = math.huge
   local gap    = self.gap
   local szA    = {}
   local sz     = #t
   self.sz      = sz
   self.szA     = szA
   
   -------------------------------------------------------------------------
   -- Compute length of each entry in table t
   -------------------------------------------------------------------------
   imin, imax = self:__entry_width(t, szA, imin, imax)
   dbg.print("width: ",tostring(self.term_width)," imin: ",tostring(imin),
             " imax: ",tostring(imax),"\n")

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

return M
