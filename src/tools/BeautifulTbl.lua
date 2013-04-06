-- Beautiful_tbl.lua

require("strict")
require("string_split")
local Dbg          = require("Dbg")
local setmetatable = setmetatable
local concatTbl	   = table.concat
local ipairs	   = ipairs
local pairs	   = pairs
local type	   = type
local print	   = print
local max	   = math.max
local string	   = string
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
   o.tbl      = o:__build_tbl(tbl)
   o.column   = o.column  or 0
   o.wrapped  = o.wrapped or false
   return o
end

function M.build_tbl(self)
   local dbg    = Dbg:dbg()
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
   if (simple) then
      for j = 1,#tt do
         local aa = {}
         local t = tt[j]
         for i = 1,#t do
            aa[#aa + 1] = t[i]
         end
         a[#a + 1] = concatTbl(aa,"")
      end
      return concatTbl(a,"\n")
   end

   self.column = self.column - 1
   local gap   = self.column - width
   local fill  = string.rep(" ",width+self.gap*(#self.columnCnt-1))

   -- printing a wrapped last column
   for j = 1, #tt do
      local aa = {}
      local t = tt[j]
      for i = 1, #t-1 do
         aa[#aa+1] = t[i]
      end

      local icnt = width
      local s = a[#a]
      for w in s:split("%s+") do
         local wlen = length(w)+1
         if (icnt + wlen < self.column or wlen > gap) then
            aa[#aa+1] = w .. " "
         else
            aa[#aa+1] ="\n"
            a[#a + 1] = concatTbl(aa,"")
            aa    = {}
            aa[1] = fill
            icnt  = width
            aa[2] = w .. " "
         end
         icnt = icnt + wlen
      end
      aa[#aa+1] ="\n"
      a[#a + 1] = concatTbl(aa,"")
   end
   return concatTbl(a,"\n")
end

--function M.print_tbl(self)
--
--   local length = self.length
--   local width  = 0
--   local simple = true
--   if (self.wrapped and self.column > 0) then
--      for i = 1, #self.columnCnt-1 do
--         width = width + self.columnCnt[i]
--      end
--      local last = self.columnCnt[#self.columnCnt]
--      simple = (width > self.column-20) or (width + last < self.column)
--   end
--
--   if (simple) then
--      for _, a in ipairs(self.tbl) do
--         for _, v in ipairs(a) do
--            prt(v)
--         end
--         prt("\n")
--      end
--      return
--   end
--
--   self.column = self.column - 1
--   local gap = self.column - width
--   local fill=string.rep(" ",width+self.gap*(#self.columnCnt-1))
--
--   -- printing a wrapped last column
--   for _, a in ipairs(self.tbl) do
--      local aa = {}
--      for i = 1, #a-1 do
--         aa[#aa+1] = a[i]
--      end
--
--      local icnt = width
--      local s = a[#a]
--      for w in s:split("%s+") do
--         local wlen = length(w)+1
--         if (icnt + wlen < self.column or wlen > gap) then
--            aa[#aa+1] = w .. " "
--         else
--            aa[#aa+1] ="\n"
--            prt(concatTbl(aa,""))
--            aa    = {}
--            aa[1] = fill
--            icnt  = width
--            aa[2] = w .. " "
--         end
--         icnt = icnt + wlen
--      end
--      aa[#aa+1] ="\n"
--      prt(concatTbl(aa,""))
--   end
--end

function M.__build_tbl(self,tblIn)

   local length    = self.length
   local columnCnt = {}
   local maxnc     = 1
   local tbl       = {}
   local icol,irow

   for _,a  in ipairs(tblIn) do
      icol = 0
      for _, v in ipairs(a) do
	 icol = icol + 1
	 columnCnt[icol] = max(length(v), columnCnt[icol] or 0)
      end
   end

   maxnc = #columnCnt
   for _,a  in ipairs(tblIn) do
      icol = 0
      irow = #tbl+1
      tbl[irow] = {}

      for _,v in ipairs(a) do
         v = tostring(v)
	 icol = icol + 1
         if (icol < maxnc) then
            local nspaces = columnCnt[icol] - length(v) + self.gap
            tbl[irow][icol] = v .. blank:rep(nspaces)
         else
            tbl[irow][icol] = v
         end
      end
   end

   self.columnCnt = columnCnt
   return tbl
end

return M
