#!@path_to_lua@/lua
-- -*- lua -*-
--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lmod is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2014 Robert McLay
--
--  Permission is hereby granted, free of charge, to any person obtaining
--  a copy of this software and associated documentation files (the
--  "Software"), to deal in the Software without restriction, including
--  without limitation the rights to use, copy, modify, merge, publish,
--  distribute, sublicense, and/or sell copies of the Software, and to
--  permit persons to whom the Software is furnished to do so, subject
--  to the following conditions:
--
--  The above copyright notice and this permission notice shall be
--  included in all copies or substantial portions of the Software.
--
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
--  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
--  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
--  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
--  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
--
--------------------------------------------------------------------------

------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
------------------------------------------------------------------------
local LuaCommandName = arg[0]
local i,j = LuaCommandName:find(".*/")
local LuaCommandName_dir = "./"
if (i) then
   LuaCommandName_dir = LuaCommandName:sub(1,j)
end
package.path = LuaCommandName_dir .. "../tools/?.lua;"  ..
               LuaCommandName_dir .. "../shells/?.lua;" ..
               LuaCommandName_dir .. "?.lua;"           ..
               package.path

function cmdDir()
   return LuaCommandName_dir
end

require("myGlobals")
require("strict")
require("utils")
require("colorize")
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
local dbg           = require("Dbg"):dbg()
local Optiks        = require("Optiks")
local Spider        = require("Spider")
local concatTbl     = table.concat
local posix         = require("posix")
local sort          = table.sort


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
      path = path_regularize(path)
      if (keepThisPath(path) and attr and attr.mode == "directory") then
         path = abspath(path)
         rmapT[path] = {pkg=entry.full, flavor=entry.parent, kind=kind}
      end
   end
end

local function rptList(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptList(moduleDirA, moduleT, timestampFn, dbT)"}
   local tbl = {}
   local spider = Spider:new()
   spider:listModules(moduleT, tbl)
   for k in pairsByKeys(tbl) do
      print(k)
   end
   dbg.fini("rptList")
end

local function rptModuleT(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptModuleT(moduleDirA, moduleT, timestampFn, dbT)"}
   local ts = { timestampFn }
   local s1 = serializeTbl{name="timestampFn",   value=ts,         indent=true}
   local s2 = serializeTbl{name="defaultMpathA", value=moduleDirA, indent=true}
   local s3 = serializeTbl{name="moduleT",       value=moduleT,    indent=true}
   io.stdout:write(s1,s2,s3,"\n")
   dbg.fini("rptModuleT")
end

local function buildReverseMapT(moduleDirA, moduleT, dbT)
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
   return reverseMapT
end


local function rptReverseMapT(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptReverseMapT(moduleDirA, moduleT, timestampFn, dbT)"}
   local ts          = { timestampFn }
   local reverseMapT = buildReverseMapT(moduleDirA, moduleT, dbT)
   local s1          = serializeTbl{name="timestampFn",   value=ts,
                                    indent=true}
   local s2          = serializeTbl{name="reverseMapT",
                                    value=reverseMapT,   indent=true}
   io.stdout:write(s1,s2,"\n")
   dbg.fini("rptReverseMapT")
end

local function rptReverseMapTJson(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptReverseMapTJson(moduleDirA, moduleT, timestampFn, dbT)"}
   local reverseMapT = buildReverseMapT(moduleDirA, moduleT, dbT)
   local t           = { timestampFn = timestampFn,
                         reverseMapT = reverseMapT}
   print(json.encode(t))
   dbg.fini("rptReverseMapTJson")
end

local function rptSoftwarePageJson(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptSoftwarePageJson(moduleDirA, moduleT, timestampFn, dbT)"}
   local spA = softwarePage(dbT)
   print(json.encode(spA))
   dbg.fini("rptSoftwarePageJson")
end

local function rptSoftwarePageLua(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptSoftwarePageLua(moduleDirA, moduleT, timestampFn, dbT)"}
   local spA = softwarePage(dbT)
   local s   = serializeTbl{name="spA",      value=spA,   indent=true}
   print(s)
   dbg.fini("rptSoftwarePageLua")
end

local function rptSoftwarePageXml(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptSoftwarePageXml(moduleDirA, moduleT, timestampFn, dbT)"}
   local xmlStr = xmlSoftwarePage(dbT)
   print(xmlStr)
   dbg.fini("rptSoftwarePageXml")
end

local function rptDbT(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptDbT(moduleDirA, moduleT, timestampFn, dbT)"}
   local ts = { timestampFn }
   local s1 = serializeTbl{name="timestampFn",   value=ts,         indent=true}
   local s2 = serializeTbl{name="dbT",      value=dbT,   indent=true}
   io.stdout:write(s1,s2,"\n")
   dbg.fini("rptDbT")
end

local function rptDbTJson(moduleDirA, moduleT, timestampFn, dbT)
   dbg.start{"rptDbTJson(moduleDirA, moduleT, dbT)"}
   print(json.encode(dbT))
   dbg.fini("rptDbTJson")
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
         moduleDirA[#moduleDirA+1] = path_regularize(path)
      end
   end


   if (masterTbl.debug) then
      dbg:activateDebug(1)
   end

   dbg.start{"Spider main()"}
   MCP = MasterControl.build("spider")
   mcp = MasterControl.build("spider")

   readRC()
   build_epoch()            -- build the epoch function
   build_accept_functions() -- functions to accept or ignore TCL mfiles
   local cache = Cache:cache{dontWrite = true, quiet = true}

   ------------------------------------------------------------------------
   -- do not colorize output from spider
   colorize = plain

   setenv_lmod_version() -- push Lmod version info into env for modulefiles.
   
   ------------------------------------------------------------------------
   --  The StandardPackage is where Lmod registers hooks.  Sites may
   --  override the hook functions in SitePackage.
   ------------------------------------------------------------------------
   require("StandardPackage")

   ------------------------------------------------------------------------
   -- Load a SitePackage Module.
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

   dbg.print{"lmodPath:", lmodPath,"\n"}
   require("SitePackage")
   local spider = Spider:new()
   spider:findAllModules(moduleDirA, moduleT)

   if (dbg.active()) then
      for k,v in pairs(moduleT) do
         dbg.print{"k: ",k,"\n"}
      end
   end

   local dbT = {}
   spider:buildSpiderDB({"default"}, moduleT, dbT)

   -- This interpT converts user outputstyle into a function call.

   local interpT = {
      list             = rptList,
      moduleT          = rptModuleT,
      softwarePage     = rptSoftwarePageJson,
      jsonSoftwarePage = rptSoftwarePageJson,
      xmlSoftwarePage  = rptSoftwarePageXml,
      softwarePageLua  = rptSoftwarePageLua,
      reverseMapT      = rptReverseMapT,
      reverseMap       = rptReverseMapT,
      jsonReverseMapT  = rptReverseMapTJson,
      jsonReverseMap   = rptReverseMapTJson,
      ["spider-json"]  = rptDbTJson,
      dbT              = rptDbT,
   }

   -- grap function and run with it.
   local func = interpT[masterTbl.outputStyle]
   if (func) then
      func(moduleDirA, moduleT, masterTbl.timestampFn, dbT)
   end
end

function softwarePage(dbT)
   local spA = {}
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
         vT.canonicalVersionString = parseVersion(v.Version)
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
      name   = {'-D','--debug'},
      dest   = 'debug',
      action = 'store_true',
      default = false,
   }

   cmdlineParser:add_option{
      name    = {'-o','--output'},
      dest    = 'outputStyle',
      action  = 'store',
      default = "list",
      help    = "Output Style: list, moduleT, dbT, reverseMapT, "..
                "jsonReverseMapT, spider, spider-json, softwarePage, "..
                "jsonSoftwarePage, xmlSoftwarePage"
   }

   cmdlineParser:add_option{
      name    = {'--timestampFn'},
      dest    = 'timestampFn',
      action  = 'store',
      default = false,
      help    = "Absolute path to the timestamp file"
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
         b[#b+1] = name .. "/" .. parseVersion(version)
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
   dbg.start{"localSoftware(xml,",name,",t)"}

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
   dbg.print{"Type: ",value,"\n"}

   local Name = xml.new("Domain")
   Name[1]    = domain
   root:append(Name)
   dbg.print{"domain: ",domain,"\n"}

   local Name = xml.new("Name")
   Name[1]    = name
   root:append(Name)
   dbg.print{"name: ",name,"\n"}

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
