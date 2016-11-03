require("strict")
require("deepcopy")
require("myGlobals")
local M           = {}
local MT          = require("MT")
local Var         = require("Var")
local dbg         = require("Dbg"):dbg()
local getenv      = os.getenv
local remove      = table.remove
local s_frameStk  = false

local function new(self)
   dbg.start{"FrameStk:new()"}
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.__count    = 1
   o.__origMT   = MT:singleton()
   o.__stack    = {
      {mname = false, mt = deepcopy(o.__origMT), varT = {} }
   }
   dbg.fini("FrameStk:new")
   return o
end
   
function M.singleton(self)
   if (not s_frameStk) then
      s_frameStk = new(self)
      local mpath = getenv(ModulePath)
      if (mpath) then
         local varT       = s_frameStk:varT()
         varT[ModulePath] = Var:new(ModulePath, mpath)
      end
   end
   return s_frameStk
end

function M.__clear(self)
   s_frameStk = false
end

function M.push(self, mname)
   --dbg.start{"FrameStk:push(mname)"}
   local stack  = self.__stack
   local mt     = deepcopy(self:mt())
   local varT   = deepcopy(self:varT())
   local count  = self.__count + 1
   stack[count] = { mname = deepcopy(mname), mt = mt, varT = varT }
   self.__count = count
   --dbg.fini("FrameStk:push")
end

function M.pop(self)
   --dbg.start{"FrameStk:pop()"}
   local stack           = self.__stack
   local count           = self.__count
   stack[count-1].mt     = stack[count].mt
   stack[count-1].varT   = stack[count].varT
   stack[count]          = nil
   self.__count          = count - 1
   --remove(stack) -- remove last entry in stack
   --dbg.fini("FrameStk:pop")
end

function M.empty(self)
   return (self.__count == 1)
end

function M.atTop(self)
   return (self.__count == 2)
end

function M.count(self)
   return self.__count
end

function M.fullName(self)
   local top   = self.__stack[self.__count]
   local mname = top.mname
   return mname:fullName()
end

function M.sn(self)
   local top   = self.__stack[self.__count]
   local mname = top.mname
   return mname:sn()
end

function M.userName(self)
   local top   = self.__stack[self.__count]
   local mname = top.mname
   return mname:userName()
end
   
function M.fn(self)
   local top   = self.__stack[self.__count]
   local mname = top.mname
   return mname:fn()
end

function M.sn(self)
   local top   = self.__stack[self.__count]
   local mname = top.mname
   return mname:sn()
end

function M.version(self)
   local top   = self.__stack[self.__count]
   local mname = top.mname
   return mname:version()
end
   
function M.mt(self)
   local top   = self.__stack[self.__count]
   return top.mt
end

function M.origMT(self)
   return self.__origMT
end

function M.varT(self)
   local top   = self.__stack[self.__count]
   return top.varT
end

function M.traceBack(self)
   local a      = {}
   local stack  = self.__stack
   local icount = self.__count 
   for i = icount, 2,-1 do
      a[#a+1] = stack[i].mname
   end
   return a
end

return M
