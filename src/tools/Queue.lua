-- Queue data structure
-- Stolen from PiL v3 p 111

require("strict")

local M = { first = 0, last = -1}

function M.new(self)
   local o = {}
   setmetatable(o, self)
   self.__index  = self
   return o
end

function M.push(self, value)
   local last = self.last + 1
   self.last  = last
   self[last] = value
end

function M.pop(self)
   local first = self.first
   if (first > self.last) then
      error("Queue is empty")
   end
   local value = self[first]
   self[first] = nil               -- to allow garbage collection
   self.first  = first + 1
   return value
end

function M.isempty(self)
   return self.last < self.first
end

return M


------------------------------------------------------------
-- Example test code
------------------------------------------------------------


-- require("strict")
-- local Queue = require("Queue")
-- function main()
-- 
--    local a = { 5, 4, 3, 2, 1}
-- 
-- 
--    local q = Queue:new()
-- 
--    for i = 1,#a do
--       q:push(a[i])
--    end
-- 
--    while (not q:isempty()) do
--       print (q:pop())
--    end
-- end
-- 
-- main()
