require("strict")
require("string_split")
require("pairsByKeys")
local Dbg           = require("Dbg")
local ModulePath    = ModulePath
local concatTbl     = table.concat
local io            = io
local ipairs        = ipairs
local os            = os
local pairs         = pairs
local pairsByKeys   = pairsByKeys
local print         = print
local posix         = require("posix")
local setenv        = posix.setenv
local setmetatable  = setmetatable
local systemG       = _G
local table         = table
local type          = type
local prepend_order = nil

--module("Var")

local M = {}

function set_prepend_order()
   local order = os.getenv("LMOD_PREPEND_BLOCK") or "no"
   if (order == "no") then
      prepend_order = function (n)
         return 1, n, 1
      end
   else
      prepend_order = function (n)
         return n, 1, -1
      end
   end
end


local function extract(self)
   local dbg = Dbg:dbg()
   local myValue = self.value or os.getenv(self.name) or ""
   local pathTbl = {}
   local imax    = 0
   local imin    = 1
   local pathA   = {}
   local sep     = self.sep

   dbg.start("extract(self)")
   if (myValue ~= '') then
      for v  in myValue:split(sep) do
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
   dbg.print("name: ", self.name,"\n")
   dbg.print("pathTbl: \"", concatTbl(pathTbl,self.sep),"\"\n")
   dbg.fini()
end

function M.new(self, name, value, sep)
   local o = {}
   setmetatable(o,self)
   self.__index = self
   o.value      = value
   o.name       = name
   o.sep        = sep or ":"
   extract(o)
   return o
end

function M.prt(self,title)
   local dbg = Dbg:dbg()
   dbg.print (title,"\n")
   dbg.print ('name:', self.name,"'\n")
   dbg.print ('imin:', self.imin,"'\n")
   dbg.print ('imax:', self.imax,"'\n")
   dbg.print ('value:', self.value,"'\n")
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
   if (value == '') then
      value = ' '
   end
   return value
end


function M.append(self,value)
   if (value == nil) then return end
   local sep = self.sep
   for v in value:split(sep) do
      v           = regularize(v)
      local imax  = self.imax + 1
      self.tbl[v] = imax
      self.imax   = imax
      chkMP(self.name,false)
   end
   setenv(self.name, self:expand(), true)
end

function M.remove(self,value)
   if (value == nil) then return end
   local sep = self.sep
   for v in value:split(sep) do
      v = regularize(v)
      if (self.tbl[v]) then
         self.tbl[v] = nil
         chkMP(self.name, true)
      end
   end
   setenv(self.name, self:expand(), true)
end

function M.prepend(self,value)
   if (value == nil) then return end
   local sep = self.sep
   local a   = {}
   for v in value:split(sep) do
      a[#a+1] = regularize(v)
   end

   local is, ie, iskip = prepend_order(#a)

   for i = is, ie, iskip do
      local v     = a[i]
      self.imin   = self.imin - 1
      self.tbl[v] = self.imin
      chkMP(self.name,false)
   end
   setenv(self.name, self:expand(), true)
end

function M.set(self,value)
   self.value = value
   self.type  = 'var'
   setenv(self.name, value, true)
end

function M.unset(self)
   self.value = ''
   self.type  = 'var'
   setenv(self.name, nil, true)
end

function M.setLocal(self,value)
   self.value = value
   self.type  = 'local_var'
end

function M.unsetLocal(self,value)
   self.value = ''
   self.type  = 'local_var'
end

function M.setAlias(self,value)
   self.value = value
   self.type  = 'alias'
end

function M.unsetAlias(self,value)
   self.value = ''
   self.type  = 'alias'
end

function M.setShellFunction(self,bash_func,csh_func)
   self.value = {bash_func,csh_func}
   self.type  = 'shell_function'
end

function M.unsetShellFunction(self,bash_func,csh_func)
   self.value = ''
   self.type  = 'shell_function'
end

function M.myType(self)
   return self.type
end

function M.expand(self)
   if (self.type ~= 'path') then
      return self.value, self.type
   end

   local t       = {}
   local pathA   = {}
   local pathStr = ""
   local sep     = self.sep

   for k in pairs(self.tbl) do
      t[self.tbl[k]] = k
   end

   local i = 0

   for _,v in pairsByKeys(t) do
      i = i + 1
      if (v == ' ') then
         v = ''
      end

      v = v:gsub("//+","/")
      v = v:gsub("/$","")
      pathA[#pathA+1] = v
   end
   if (#pathA == 1 and pathA[1] == "") then
      pathStr = sep .. sep
   else
      pathStr = table.concat(pathA,sep)
      if (pathA[#pathA] == "") then
         pathStr = pathStr .. sep
      end

   end

   ------------------------------------------------------------------------
   -- Remove leading and trailing ':' from PATH string
   ------------------------------------------------------------------------
   if (self.name == 'PATH') then
      pathStr = pathStr:gsub('^:+','')
      pathStr = pathStr:gsub(':+$','')
      if (pathStr:find('::')) then
         --io.stderr:write("Warning: Removing '::' from path variable: ",self.name,"\n")
         pathStr = pathStr:gsub('::+',":")
      end
   end
   return pathStr, self.type
end

return M
