require("strict")
require("string_split")
require("pairsByKeys")
local Dbg           = require("Dbg")
local ModulePath    = ModulePath
local concatTbl     = table.concat
local huge          = math.huge
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

--module("Var")

local M = {}

local function regularize(value)
   value = value:gsub("^%s+","")
   value = value:gsub("%s+$","")
   value = value:gsub("//+","/")
   value = value:gsub("/$","")
   if (value == '') then
      value = ' '
   end
   return value
end


local function regularizePath(path, sep)
   if (not path or path == '') then
      return nil
   end

   local is, ie

   -- remove leading and trailing sep
   if (path:sub(1,1) == sep) then
      is = 2
      ie = -1
   end
   if (path:sub(-1,-1) == sep) then
      ie = -2
   end
   if (is) then
      path = path:sub(is,ie)
   end

   local pathA = {}
   for v  in path:split(sep) do
      pathA[#pathA + 1] = regularize(v)
   end

   return pathA
end



local function extract(self)
   local dbg     = Dbg:dbg()
   local myValue = self.value or os.getenv(self.name) or ""
   local pathTbl = {}
   local imax    = 0
   local imin    = 1
   local pathA   = {}
   local sep     = self.sep

   dbg.start("extract(self)")

   dbg.print("myValue: \"",myValue,"\"\n")

   if (myValue ~= '') then
      pathA = regularizePath(myValue, sep)

      for i,v in ipairs(pathA) do
         local a    = pathTbl[v] or {}
         a[#a + 1]  = i
         pathTbl[v] = a
         imax       = i
      end
   end
   self.value  = myValue
   self.type   = 'path'
   self.tbl    = pathTbl
   self.imin   = imin
   self.imax   = imax
   self.export = true
   if (dbg.active()) then
      self:prt("In extract")
   end
   dbg.fini()
end

function M.new(self, name, value, sep)
   local o = {}
   setmetatable(o,self)
   local dbg          = Dbg:dbg()
   dbg.start("Var:new(",name,", \"",tostring(value),"\")")
   self.__index = self
   o.value      = value
   o.name       = name
   o.sep        = sep or ":"
   extract(o)
   dbg.fini()
   return o
end

function M.prt(self,title)
   local dbg = Dbg:dbg()
   dbg.print (title,"\n")
   dbg.print ("name:  \"", tostring(self.name), "\"\n")
   dbg.print ("imin:  \"", tostring(self.imin), "\"\n")
   dbg.print ("imax:  \"", tostring(self.imax), "\"\n")
   dbg.print ("value: \"", tostring(self.value),"\"\n")
   if (not self.tbl or type(self.tbl) ~= "table" or next(self.tbl) == nil) then
      dbg.print("tbl is empty\n")
      return
   end
   for k,v in pairs(self.tbl) do
      dbg.print ("   \"",k,"\":")
      for ii = 1,#v do
         io.stderr:write(" ",v[ii])
      end
      dbg.print ("\n")
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



local function removeAll(a)
   return nil
end

local function removeFirst(a)
   table.remove(a,1)
   if (next(a) == nil) then
      a = nil
   end
   return a
end

local function removeLast(a)
   a[#a] = nil
   if (next(a) == nil) then
      a = nil
   end
   return a
end

whereT = {
   all    = removeAll,
   first  = removeFirst,
   last   = removeLast,
}
   
function M.remove(self, value, where)
   if (value == nil) then return end
   local remFunc = whereT[where] or removeAll
   local pathA   = regularizePath(value, self.sep)
   local tbl     = self.tbl

   for i = 1, #pathA do
      local path = pathA[i]
      if (tbl[path]) then
         tbl[path] = remFunc(self.tbl[path])
         chkMP(self.name, true)
      end
   end
   setenv(self.name, self:expand(), true)
end

function M.pop(self)
   local imin   = self.imin
   local min2   = math.huge
   local result = nil
   for k, idxA in pairs(self.tbl) do
      local v = idxA[1]
      if (idxA[1] == imin) then
         self.tbl[k] = removeFirst(idxA)
         v = idxA[1] or huge
      end
      if (v < min2) then
         min2   = v
         result = k
      end
   end
   self.imin = min2
   return result
end

local function unique(a, value)
   a[1] = value
end

local function first(a, value)
   table.insert(a,1, value)
end

local function last(a, value)
   a[#a+1] = value
end


function M.prepend(self, value, nodups)
   local dbg  = Dbg:dbg()
   dbg.start("Var:prepend(\"",tostring(value),"\")")
   dbg.print("name: ",self.name,"\n")
   if (value == nil) then return end

   local pathA         = regularizePath(value, self.sep)
   local is, ie, iskip = prepend_order(#pathA)
   local insertFunc    = nodups and unique or first

   local tbl  = self.tbl
   local imin = self.imin
   for i = is, ie, iskip do
      local path = pathA[i]
      dbg.print("path: ",path,"\n")
      imin     = imin - 1
      local a  = tbl[path] or {}
      insertFunc(a, imin)
      tbl[path]   = a
      chkMP(self.name, false)
   end
   self.imin = imin
   if (dbg.active()) then self:prt("Var:prepend") end

   setenv(self.name, self:expand(), true)
   dbg.fini()
end

function M.append(self, value, nodups)
   if (value == nil) then return end
   local pathA      = regularizePath(value, self.sep)
   local insertFunc = nodups and unique or last

   local tbl  = self.tbl
   local imax = self.imax
   for i = 1, #pathA do
      local path = pathA[i]
      imax       = imax + 1
      local a    = tbl[path] or {}
      insertFunc(a, imax)
      tbl[path]  = a
      chkMP(self.name,false)
   end
   self.imax  = imax
   setenv(self.name, self:expand(), true)
end

function M.set(self,value)
   self.value = value or ''
   self.type  = 'var'
   if (value == '') then value = nil end
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

   for k, v in pairs(self.tbl) do
      for ii = 1,#v do
         t[v[ii]] = k
      end
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
         pathStr = pathStr:gsub('::+',":")
      end
   end
   return pathStr, self.type
end

return M
