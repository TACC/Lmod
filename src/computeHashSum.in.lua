#!@path_to_lua@/lua
-- -*- lua -*-
------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
------------------------------------------------------------------------
local LuaCommandName = arg[0]
local i,j = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (i) then
   LuaCommandName_dir = LuaCommandName:sub(1,j)
end
package.path = LuaCommandName_dir .. "?.lua;" .. package.path

------------------------------------------------------------------------
-- Try to load a SitePackage Module,  If it is not there then do not
-- abort.  Sites do not have to have a Site package.
------------------------------------------------------------------------
pcall(require, "SitePackage") 

function cmdDir()
   return LuaCommandName_dir
end
package.path = LuaCommandName_dir .. "?.lua;"      ..
               package.path

Version = "1.0"
HashSum = "@path_to_hashsum@"

require("myGlobals")
require("strict")

require("fileOps")
require("capture")
MasterControl = require("MasterControl")
MCP           = {}
mcp           = {}
require("modfuncs")
require("cmdfuncs")

BaseShell       = require("BaseShell")
Dbg             = require("Dbg")
Master          = require("Master")
ModuleStack     = require("ModuleStack")
MT              = require("MT")
local Optiks    = require("Optiks")
local s_master  = {}

local fh        = nil
local getenv    = os.getenv
local concatTbl = table.concat

function masterTbl()
   return s_master
end


function loadModuleFile(obj)
   local f
   if (type(obj) == "table") then
      f = obj.file
   else
      f = obj
   end

   local dbg     = Dbg:dbg()
   dbg.start("computeHashSum-> loadModuleFile(\"",tostring(f),"\")")
   local myType = extname(f)
   local func
   if (myType == ".lua") then
      func = loadfile(f)
   else
      local a     = {}
      a[#a + 1]	  = pathJoin(cmdDir(),"tcl2lua.tcl")
      a[#a + 1]	  = f
      local cmd   = table.concat(a," ")
      local s     = capture(cmd)
      func = loadstring(s)
   end
   if (func) then
      func()
   end
   dbg.fini()
end


function main()
   
   local dbg       = Dbg:dbg()
   local master    = Master:master(false)
   local mStack    = ModuleStack:moduleStack()
   master.shell    = BaseShell.build("bash")
   local fn        = os.tmpname()
   fh              = io.open(fn,"w")
   local i         = 1
   local masterTbl = masterTbl()
   options()
   


   if (masterTbl.debug) then
     dbg:activateDebug()
   end
   dbg.start("computeHashSum()")
   
   MCP           = MasterControl.build("computeHash","load")
   mcp           = MasterControl.build("computeHash","load")
   dbg.print("mcp set to ",mcp:name(),"\n")

   local f = masterTbl.pargs[1]
   mStack:push("something", f)
   loadModuleFile(f)
   mStack:pop()
   local s = concatTbl(ComputeModuleResultsA,"")
   dbg.print("Text to Hash: \n",s,"\n")

   if (masterTbl.verbose) then
      io.stderr:write(s)
   end
   fh:write(s)
   if (HashSum:sub(1,1) == "@" ) then
      HashSum = findInPath("sha1sum")
   end
   fh:close()

   local result = capture(HashSum .. " " .. fn)
   os.remove(fn)
   local i,j = result:find(" ")
   dbg.print("hash value: ",result:sub(1,i-1))
   print (result:sub(1,i-1))
   dbg.fini()
end

function options()
   local masterTbl = masterTbl()
   local usage         = "Usage: computeHashSum [options] file"
   local cmdlineParser = Optiks:new{usage=usage, version=Version}

   cmdlineParser:add_option{ 
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{ 
      name   = {'-d','--debug'},
      dest   = 'debug',
      action = 'store_true',
      default = false,
      help    = "debug flag"
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end

main()
