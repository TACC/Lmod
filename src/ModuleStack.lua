require("strict")
require("Dbg")

ModuleStack = { }

local Dbg          = Dbg
local next         = next
local remove       = table.remove
local setmetatable = setmetatable

module("ModuleStack")

s_moduleStack = {}

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.stack      = { {name = "lmod_base", loadCnt = 0, setCnt = 0} }
   return o
end

function moduleStack(self)
   if (next(s_moduleStack) == nil) then
      s_moduleStack = new(self)
   end
   return s_moduleStack
end

function loading(self, count)
   count       = count or 1
   local stack = self.stack
   local top   = stack[#stack]

   top.loadCnt = top.loadCnt + count
end

function setting(self)
   local stack = self.stack
   local top   = stack[#stack]

   top.setCnt = top.setCnt + 1
end

function push(self, name)
   local entry = {name = name, loadCnt = 0, setCnt = 0}
   local stack = self.stack

   stack[#stack+1] = entry
end

function pop(self)
   local stack = self.stack
   remove(stack)
end

function moduleType(self)
   local dbg   = Dbg:dbg()
   dbg.start("ModuleStack:moduleType()")

   local stack   = self.stack
   local top     = stack[#stack]
   local results = nil

   if (top.loadCnt > 0) then
      if (top.setCnt > 0) then
         results = "mw"
      else
         results = "m"
      end
   else
      results = "w"
   end
   dbg.print("name: ",top.name," type: ",results,"\n")
   dbg.fini()
   return results
end

function moduleName(self)
   local stack = self.stack
   local top   = stack[#stack]
   return top.name
end
