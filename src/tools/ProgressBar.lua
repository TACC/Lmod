require("strict")
local Dbg          = require("Dbg")

local M = { barWidth = 50 }

s_symbolT = {}

local floor = math.floor

function M.new(self, t)
   local tbl = t
   local o = {}

   setmetatable(o, self)
   self.__index  = self
   o.max      = t.max
   o.barWidth = t.barWidth or o.barWidth
   o.barWidth = math.min(o.barWidth, o.max)
   o.stream   = t.stream or io.stdout
   o.unit     = 100/o.barWidth
   o.fence    = o.unit
   o.mark     = 10

   s_symbolT[10]  = "+"
   s_symbolT[20]  = "+"
   s_symbolT[30]  = "+"
   s_symbolT[40]  = "+"
   s_symbolT[50]  = "|"
   s_symbolT[60]  = "+"
   s_symbolT[70]  = "+"
   s_symbolT[80]  = "+"
   s_symbolT[90]  = "+"
   s_symbolT[100] = "|"

   return o
end

function M.progress(self,i)
   local j = floor(i/self.max*100)
   local k = floor((i+1)/self.max*100)

   if (j >= self.fence) then
      local symbol = "-"
      --print (j, k, l)
      if ((j <= self.mark and k > self.mark) or ((j == k) and j == self.mark)) then
         symbol = s_symbolT[self.mark]
         self.mark = self.mark+10
      end

      self.stream:write(symbol)
      self.stream:flush()
      self.fence = self.fence + self.unit
   end
end

function M.fini(self)
   self.stream:write("\n")
end
   

return M
