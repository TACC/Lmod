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
package.path = LuaCommandName_dir .. "tools/?.lua;" ..
               LuaCommandName_dir .. "?.lua;"       .. package.path

function cmdDir()
   return LuaCommandName_dir
end

require("myGlobals")
require("strict")
require("colorize")
require("border")
require("serializeTbl")
require("pairsByKeys")
require("fileOps")
require("modfuncs")
require("cmdfuncs")
require("parseVersion")
MasterControl       = require("MasterControl")
Cache               = require("Cache")
MT                  = require("MT")
Master              = require("Master")
BaseShell           = require("BaseShell")
local lfs           = require("lfs")
local json          = require("json")
local Dbg           = require("Dbg")
local Optiks        = require("Optiks")
local Spider        = require("Spider")
local concatTbl     = table.concat
local posix         = require("posix")


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

function epoch()
   if (posix.gettimeofday) then
      local t1, t2 = posix.gettimeofday()
      if (t2 == nil) then
         return t1.sec + t1.usec*1.0e-6
      else
         return t1 + t2*1.0e-6
      end
   else
      return os.time()
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

   dbg.start("Spider main()")
   MCP = MasterControl.build("spider")
   mcp = MasterControl.build("spider")
   dbg.print("Setting mpc to ", mcp:name(),"\n")

   readRC()
   local cache = Cache:cache{dontWrite = true, quiet = true}
   
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
   
   for k,v in pairs(moduleT) do
      dbg.print("k: ",k,"\n")
   end

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
      local t2 = epoch()
      local s  = serializeTbl{name="reverseMapT",      value=reverseMapT,   indent=true}
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

   if (masterTbl.outputStyle == "xmlSoftwarePage") then
      local xmlStr = xmlSoftwarePage(dbT)
      print(xmlStr)
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
      help    = "Output Style: list, moduleT, dbT, reverseMapT, spider, spider-json, softwarePage, xmlSoftwarePage"
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

function xmlSoftwarePage(dbT)
   require("LuaXml")  -- This defines xml

   local translateT = { ls4 = "lonestar" }


   local hostName = posix.uname("%n")
   local i        = hostName:find("%.") or 0
   local host     = hostName:sub(i+1,-1)
   host           = host:gsub("%..*","")
   host           = translateT[host] or host


   local top = xml.new{
      [0] = "V4RPSoftwareRP",
      ["xmlns:ns1"] = "https://mds.teragrid.org/2007/02/ctss"
   }

   local root = xml.new{
      [0] = "RPSoftwareList",
      Timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
      UniqueID="localsoft4."..host..".tacc.xsede.org",
   }

   local resourceID = xml.new("ResourceID")
   resourceID[1] = host..".tacc.xsede.org"
   root:append(resourceID)

   local siteID     = xml.new("SiteID")
   siteID[1]        = "tacc.xsede.org"
   root:append(siteID)


   for name, vv in pairs(dbT) do
      for file, v in pairs(vv) do
         local xmlT = localSoftware(xml,name,v)
         root:append(xmlT)
      end
   end

   top:append(root)

   

   return top:str()

end

function splitNV(full)
   local name    = full
   local version = ""
   local i,j     = full:find(".*/")
   if (j) then
      name    = full:sub(1,j-1)
      version = full:sub(j+1)
   end
   return name, version
end

function findLatestV(a)
   local aa = {}
   for i = 1, #a do
      local entry = a[i]
      local b     = {}
      for full in entry:split(":") do
         local name, version = splitNV(full)
         b[#b+1] = name .. "/" .. concatTbl(parseVersion(version), ".")
      end
      aa[i] = { concatTbl(b,":"), entry}
   end

   table.sort(aa, function(a,b) return a[1] > b[1] end)

   local result = aa[1][2]
   if (result ~= "default") then
      result = result:gsub("default:","")
   end

   return result
end


function localSoftware(xml, name, t)
   local dbg = Dbg:dbg()
   dbg.start("localSoftware(xml,",name,",t)")
   
   local root = xml.new("LocalSoftware")

   local value  = "unknown"
   local domain = "unknown"
   local category = t.Category or ""
   for entry in category:split(",") do
      entry        = entry:trim()
      local entryL = entry:lower()
      if (value == "unknown") then
         if (entryL == "library") then
            value = "library"
         elseif (entryL == "application") then
            value = "application"
         end
      end
      if (domain == "unknown") then
         if (entryL ~= "library"     and
             entryL ~= "application" and
             entry  ~= "") then
            domain = entry
         end
      end
   end
   if (value == "unknown") then
      value = "application"
   end

   local Name = xml.new("Type")
   Name[1]    = value
   root:append(Name)
   dbg.print("Type: ",value,"\n")

   local Name = xml.new("Domain")
   Name[1]    = domain
   root:append(Name)
   dbg.print("domain: ",domain,"\n")

   local Name = xml.new("Name")
   Name[1]    = name
   root:append(Name)
   dbg.print("name: ",name,"\n")

   local Description = xml.new("Description")
   Description[1]    = t.Description
   root:append(Description)

   local Flavor = xml.new("Flavor")
   Flavor[1]    = t.full:gsub(".*/","")
   root:append(Flavor)

   local Default = xml.new("Default")
   local result  = "no"
   if (t.default) then result = "yes" end
   Default[1]    = result
   root:append(Default)

   local Handle = xml.new("Handle")
   local HType  = xml.new("HandleType")
   HType[1]     = "module"
   Handle:append(HType)
   local HKey   = xml.new("HandleKey")
   HKey[1]      = t.full
   Handle:append(HKey)
   root:append(Handle)

   local Context = xml.new("Context")
   Context[1] = findLatestV(t.parent)
   root:append(Context)

   dbg.fini()
   return root
end

main()
