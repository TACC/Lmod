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
package.path = LuaCommandName_dir .. "?.lua;"      ..
               package.path

function cmdDir()
   return LuaCommandName_dir
end

require("myGlobals")
require("strict")
require("colorize")
require("firstInPath")
require("border")
require("serializeTbl")
require("pairsByKeys")
require("fileOps")
require("modfuncs")
require("cmdfuncs")
require("parseVersion")
MasterControl       = require("MasterControl")
MT                  = require("MT")
Master              = require("Master")
BaseShell           = require("BaseShell")
local lfs           = require("lfs")
local json          = require("json")
local Dbg           = require("Dbg")
local Optiks        = require("Optiks")
local Spider        = require("Spider")
local concatTbl     = table.concat


function flip(a,t, tbl)
   for k,v in pairs(t) do
      local name = v.name
      if (tbl[name] == nil) then
         tbl[name] = {}
      end
      local s = concatTbl(a,":")
      tbl[name][#tbl[name]+1] = s
      if (next(v.children)) then
         a[#a+1] = name
         flip(a,v.children, tbl)
         a[#a]   = nil
      end
   end
end

local ignoreT     = {
   "^$",
   "^%.$",
   "^%$",
   "^%%",
   "^/bin/",
   "^/bin$",
   "^/sbin$",
   "^/usr/bin$",
   "^/usr/sbin$",
   "^/usr/local/bin$",
   "^/usr/local/share/bin$",
   "^/usr/lib/?",
   "^/opt/local/bin$",
}
      
function keepThisPath(path)
   for i = 1, #ignoreT do
      if (path:find(ignoreT[i])) then
         return false
      end
   end
   return true
end

local function add2map(entry, tbl, rmapT, kind)
   for path in pairs(tbl) do
      local attr = lfs.attributes(path) 
      if (keepThisPath(path) and attr and attr.mode == "directory") then
         path = abspath(path)
         rmapT[path] = {pkg=entry.full, flavor=entry.parent, kind=kind}
      end
   end
end


function main()

   options()
   local masterTbl  = masterTbl()
   local pargs      = masterTbl.pargs
   local moduleT    = {}
   local moduleDirA = {}
   
   local master     = Master:master(false)
   master.shell     = BaseShell.build("bash")

   for _, v in ipairs(pargs) do
      for path in v:split(":") do
         moduleDirA[#moduleDirA+1] = path
      end
   end

   local dbg = Dbg:dbg()

   if (masterTbl.debug) then
      dbg:activateDebug(1)
   end

   dbg.start("main()")
   MCP = MasterControl.build("spider")
   mcp = MasterControl.build("spider")
   dbg.print("Setting mpc to ", tostring(mcp:name()),"\n")

   ------------------------------------------------------------------------
   -- do not colorize output from spider
   colorize = plain

   ------------------------------------------------------------------------
   -- Try to load a SitePackage Module,  If it is not there then do not
   -- abort.  Sites do not have to have a Site package.
   ------------------------------------------------------------------------

   local lmodPath = os.getenv("LMOD_PACKAGE_PATH") or ""
   for path in lmodPath:split(":") do
      path = path .. "/"
      path = path:gsub("//+","/")
      package.path  = path .. "?.lua;"      ..
                      path .. "?/init.lua;" ..
                      package.path

      package.cpath = path .. "../lib/?.so;"..
                      package.cpath
   end

   dbg.print("lmodPath:", lmodPath,"\n")
   require("SitePackage")
   Spider.findAllModules(moduleDirA, moduleT)
   
   if (masterTbl.outputStyle == "moduleT") then
      local s1 = serializeTbl{name="defaultMpathA",value=moduleDirA,indent=true}
      local s2 = serializeTbl{name="moduleT",      value=moduleT,   indent=true}
      io.stdout:write(s1,s2,"\n")
      dbg.fini()
      return
   end

   local tbl = {}
   if (masterTbl.outputStyle == "list") then
      Spider.listModules(moduleT, tbl)
      table.sort(tbl)
      for i = 1,#tbl do
         print(tbl[i])
      end
      dbg.fini()
      return
   end

   local dbT = {}
   Spider.buildSpiderDB({"default"}, moduleT, dbT)

   if (masterTbl.outputStyle == "reverseMap" or masterTbl.outputStyle == "reverseMapT") then
      local reverseMapT = {}

      for kkk,vvv in pairs(dbT) do

         for kk, entry in pairs(vvv) do
            if (entry.pathA) then
               add2map(entry, entry.pathA, reverseMapT,"bin")
            end
            if (entry.lpathA) then
               add2map(entry, entry.lpathA, reverseMapT,"lib")
            end
         end
      end
      local s = serializeTbl{name="reverseMapT",      value=reverseMapT,   indent=true}
      print(s)
      dbg.fini()
      return
   end
      
   if (masterTbl.outputStyle == "softwarePage") then
      local spA = softwarePage(dbT)
      print(json.encode(spA))
      dbg.fini()
      return
   end


   if (masterTbl.outputStyle == "softwarePageLua") then
      local spA = softwarePage(dbT)
      local s   = serializeTbl{name="spA",      value=spA,   indent=true}
      print(s)
      
      dbg.fini()
      return
   end


   if (masterTbl.outputStyle == "spider-json") then
      print(json.encode(dbT))
      dbg.fini()
      return
   end


   local s = serializeTbl{name="dbT",      value=dbT,   indent=true}
   print(s)
   dbg.fini()
end

function softwarePage(dbT)

   local spA = {}
   local idx = 0

   for name, vv in pairs(dbT) do
      convertEntry(name, vv, spA)
   end

   return spA
end

function convertEntry(name, vv, spA)

   local topKeyT = {
      Category    = "categories",
      Description = "description",
      Keyword     = "keywords",
      Name        = "displayName",
      URL         = "url",
   }



   local keyT = {
      Version     = "versionName",
      full        = "full",
      help        = "help",
      parent      = "parent"
   }


   local entry    = {}
   entry.package  = name
   local versionT = {}

   local first    = true
   local epoch    = 0

   for mfPath, v in pairs(vv) do
      local vT = {}

      vT.path = mfPath

      if (first or (v.default and v.epoch > epoch) ) then
         if (not first) then
            epoch = v.epoch
         end
         first = false
         for topKey, newKey in pairs(topKeyT) do
            entry[newKey] = v[topKey]
         end
         entry.defaultVersionName = v.Version
      end

      for key, newKey in pairs(keyT) do
         if (v[key]) then
            vT[newKey] = v[key]
         end
      end
      
      vT.canonicalVersionString = ""
      if (v.Version) then
         vT.canonicalVersionString = concatTbl(parseVersion(v.Version) ,".")
      end

      versionT[#versionT + 1] = vT
   end

   entry.versions = versionT
   spA[#spA+1] = entry
end



function options()
   local masterTbl = masterTbl()
   local usage         = "Usage: spider [options] moduledir ..."
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{ 
      name   = {'-d','--debug'},
      dest   = 'debug',
      action = 'store_true',
      default = false,
   }

   cmdlineParser:add_option{ 
      name   = {'-o','--output'},
      dest   = 'outputStyle',
      action = 'store',
      default = "list",
      help    = "Output Style: list, moduleT, dbT, reverseMapT, spider, spider-json, softwarePage"  
   }

   cmdlineParser:add_option{ 
      name   = {'-n','--no_recursion'},
      dest   = 'no_recursion',
      action = 'store_true',
      default = false,
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end

main()
