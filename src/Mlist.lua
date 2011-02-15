-- $Id: Mlist.lua 512 2009-07-27 20:26:37Z mclay $
require("strict")
Mlist = {}

local Dbg          = require("Dbg")
local expert       = expert
local capture      = capture
local cmdDir       = cmdDir
local io           = io
local ipairs       = ipairs
local pairs        = pairs
local pathJoin     = pathJoin
local removeTbl    = table.remove
local setmetatable = setmetatable

module ("Mlist")

local function trueName(self, moduleName)
   if (moduleName == nil) then
      return nil, nil
   end
   local idx = self.Dict[moduleName]
   if (idx) then
      return moduleName, idx
   end
   local shortName = moduleName:gsub("([^/]+)/.*","%1")
   idx             = self.Dict[shortName]
   return shortName, idx
end


function haveModuleAny(self,moduleName)
   local modName, idx = trueName(self, moduleName)
   return (idx ~= nil)
end

function defaultModule(self,moduleName)
   local modName, idx = trueName(self, moduleName)
   return self.default[idx] == 1
end

function haveModule(self,moduleName)
   local modName, idx = trueName(self, moduleName)
   if (idx == nil or modName == moduleName) then
      return (idx ~= nil)
   end
   return (self.fullModName[idx] == moduleName)
end

function setHashSum(self, moduleName, value)
   local modName, idx = trueName(self, moduleName)
   if (idx == nil) then
      return
   end
   self._hash[idx] = value
end

function getHashSum(self, moduleName)
   local modName, idx = trueName(self, moduleName)
   if (idx == nil) then
      return nil
   end
   return self._hash[idx]
end

function fileName(self,moduleName)
   local modName, idx = trueName(self, moduleName)
   local fn  = nil
   if (idx  ~= nil) then
      fn = self.FN[idx]
   end
   return fn
end

function assignHashSum(self)
   local dbg   = Dbg:dbg()
   local fnA   = self.FN
   local hashA = self._hash
   dbg.start("assignHashSum(self)")

   for idx,v in ipairs(fnA) do
      local s    = capture(pathJoin(cmdDir(),"computeHashSum").. " " .. v)
      hashA[idx] = s:sub(1,-2)
   end
   dbg.fini()
end


function add(self, t)
   local modName = t.modName
   local idx     = self.Dict[modName]
   if ( idx == nil) then
      idx                = #self.Loaded + 1
      self.Dict[modName] = idx
      self.Loaded[idx]   = modName
   end
   self.FN[idx]          = t.fn
   self.fullModName[idx] = t.modFullName
   self.default[idx]     = t.default
   self.mType[idx]       = t.mType
   self._hash[idx]       = t.hash
end

function remove(self, moduleName)
   local modName, idx = trueName(self, moduleName)
   if (idx == nil) then return end

   self.Dict[modName] = nil
   for k in pairs(self.Dict) do
      i = self.Dict[k]
      if ( i > idx) then
         self.Dict[k] = i - 1
      end
   end
   removeTbl(self.Loaded,      idx)
   removeTbl(self.FN,          idx)
   removeTbl(self.fullModName, idx)
   removeTbl(self.default,     idx)
   removeTbl(self.mType,       idx)
   removeTbl(self._hash,       idx)
end

function modFullName(self,moduleName)
   local modName, idx = trueName(self, moduleName)
   local name  = ''
   local name2 = ''
   if (idx) then
      if (self.default[idx] == 0) then
         name = self.fullModName[idx]
      else
         name = modName
      end
      name2   = self.fullModName[idx]
   end
   return name, name2
end

function list(self)
   return self.Loaded
end

function moduleType(self, moduleName)
   local modName, idx = trueName(self, moduleName)
   local fn  = nil
   local value = nil
   if (idx  ~= nil) then
      value = self.mType[idx]
   end
   return value
end

function new(self)
   local o   = {}
   setmetatable(o, self)
   self.__index = self

   o.Loaded      = {}
   o.FN          = {}
   o.Dict        = {}
   o.fullModName = {}
   o.default     = {}
   o.mType       = {}
   o._hash       = {}
   return o
end

function safeToSave(self)
   local mType  = self.mType
   local Loaded = self.Loaded
   local a     = {}

   for idx,v in ipairs(mType) do
      if (v == "mw") then
         a[#a+1] = Loaded[idx]
      end
   end
   return a
end
