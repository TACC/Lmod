require("strict")
require("string_split")
require("pairsByKeys")
require("posix")
local Dbg          = require("Dbg")
local ModulePath   = ModulePath
local io           = io
local ipairs       = ipairs
local os           = os
local pairs        = pairs
local pairsByKeys  = pairsByKeys
local print        = print
local setenv       = posix.setenv
local setmetatable = setmetatable
local systemG      = _G
local table        = table
local type         = type
Var = {}

module("Var")

local function extract(self)
   local myValue = self.value or os.getenv(self.name) or ""
   local pathTbl = {}
   local imax    = 0
   local imin    = 1
   local pathA   = {}

   if (myValue ~= '') then
      for v  in myValue:split(":") do
	 if (v == '' or v:find('^%s+$')) then
	    v = ' '
	 else
	    v = v:gsub("^%s+","")
	    v = v:gsub("%s+$","")
	    v = v:gsub("//+","/")
	    v = v:gsub("/$","")
	 end
         pathA[#pathA + 1] = v
      end

      for i,v in ipairs(pathA) do
	 if (pathTbl[v] == nil) then
	    pathTbl[v] = i
         end
         imax = i
      end
   end
   self.value  = myValue
   self.type   = 'path'
   self.tbl    = pathTbl
   self.imin   = imin
   self.imax   = imax
   self.export = true
end

function new(self, name, value)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.value      = value
   o.name       = name
   extract(o)
   return o
end

function prt(self,title)
   local dbg = Dbg:dbg()
   dbg.print (title,"\n")
   dbg.print ('name:', self.name,"\n")
   dbg.print ('imin:', self.imin,"\n")
   dbg.print ('imax:', self.imax,"\n")
   dbg.print ('value:', self.value,"\n")
   for k in pairs(self.tbl) do
      dbg.print ("   %",k,"%:",self.tbl[k],"\n")
   end
   dbg.print ("\n")
end

local function chkMP(name)
   if (name == ModulePath) then
      local dbg = Dbg:dbg()
      dbg.print("calling reEvalModulePath()\n")
      local mt = systemG.MT:mt()

      mt:changePATH()
      mt:reEvalModulePath()
   end
end

local function regularize(value)
   value = value:gsub("//+","/")
   value = value:gsub("/$","")
   return value
end


function append(self,value)
   if (value == nil) then return end
   for v in value:split(":") do
      v           = regularize(v)
      local imax  = self.imax + 1
      self.tbl[v] = imax
      self.imax   = imax
      chkMP(self.name,false)
   end
   setenv(self.name, self:expand(), true)
end

function remove(self,value)
   if (value == nil) then return end
   for v in value:split(":") do
      v = regularize(v)
      if (self.tbl[v]) then
         self.tbl[v] = nil
         chkMP(self.name, true)
      end
   end
   setenv(self.name, self:expand(), true)
end

function prepend(self,value)
   if (value == nil) then return end
   for v in value:split(":") do
      v           = regularize(v)
      self.imin   = self.imin - 1
      self.tbl[v] = self.imin
      chkMP(self.name,false)
   end
   setenv(self.name, self:expand(), true)
end

function set(self,value)
   self.value = value
   self.type  = 'var'
   setenv(self.name, value, true)
end

function unset(self)
   self.value = ''
   self.type  = 'var'
   setenv(self.name, nil, true)
end

function setLocal(self,value)
   self.value = value
   self.type  = 'local_var'
end

function unsetLocal(self,value)
   self.value = ''
   self.type  = 'local_var'
end

function setAlias(self,value)
   self.value = value
   self.type  = 'alias'
end

function unsetAlias(self,value)
   self.value = ''
   self.type  = 'alias'
end

function myType(self)
   return self.type
end

function expand(self)
   if (self.type ~= 'path') then
      return self.value, self.type
   end

   local t       = {}
   local pathA   = {}
   local pathStr = ""

   for k in pairs(self.tbl) do
      t[self.tbl[k]] = k
   end


   for _,v in pairsByKeys(t) do
      if (v == ' ') then
         v = ''
      end
      v = v:gsub("//","/")
      v = v:gsub("/$","")
      pathA[#pathA+1] = v
   end
   pathStr = table.concat(pathA,":")

   ------------------------------------------------------------------------
   -- Remove leading and trailing ':' from PATH string
   ------------------------------------------------------------------------
   if (self.name == 'PATH') then
      pathStr = pathStr:gsub('^:+','')
      pathStr = pathStr:gsub(':+$','')
      if (pathStr:find('::')) then
         io.stderr:write("Warning: Removing '::' from path variable: ",self.name,"\n")
         pathStr = pathStr:gsub('::+',":")
      end
   end
   return pathStr, self.type
end
