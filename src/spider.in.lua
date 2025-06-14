#!@path_to_lua@
-- -*- lua -*-

--------------------------------------------------------------------------
-- Use command name to add the command directory to the package.path
-- @script spider

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
--  Copyright (C) 2008-2018 Robert McLay
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

local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end

local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path   = sys_lua_path
package.cpath  = sys_lua_cpath

_G._DEBUG      = false
local arg_0    = arg[0]
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat
local access   = posix.access
local stderr   = io.stderr

local st       = stat(arg_0)
while (st.type == "link") do
   local lnk = readlink(arg_0)
   if (arg_0:find("/") and (lnk:find("^/") == nil)) then
      local dir = arg_0:gsub("/[^/]*$","")
      lnk       = dir .. "/" .. lnk
   end
   arg_0 = lnk
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local LuaCommandName_dir = "./"
if (ia) then
   LuaCommandName_dir = arg_0:sub(1,ja)
end

package.path  = LuaCommandName_dir .. "../tools/?.lua;"      ..
                LuaCommandName_dir .. "../tools/?/init.lua;" ..
                LuaCommandName_dir .. "../shells/?.lua;"     ..
                LuaCommandName_dir .. "?.lua;"               ..
                sys_lua_path

package.cpath = LuaCommandName_dir .. "../lib/?.so;"..
                sys_lua_cpath

function cmdDir()
   return LuaCommandName_dir
end

require("strict")

require("myGlobals")
require("utils")
require("colorize")
require("serializeTbl")
require("pairsByKeys")
require("fileOps")
require("modfuncs")
require("cmdfuncs")
require("deepcopy")
require("parseVersion")
require("declare")
MainControl         = require("MainControl")
Cache               = require("Cache")
MRC                 = require("MRC")
Hub                 = require("Hub")
BaseShell           = require("BaseShell")
Shell               = false
local Optiks        = require("Optiks")
local Spider        = require("Spider")
local Version       = require("Version")
local concatTbl     = table.concat
local cosmic        = require("Cosmic"):singleton()
local dbg           = require("Dbg"):dbg()
local hook          = require("Hook")
local i18n          = require("i18n")
local lfs           = require("lfs")
local sort          = table.sort
local pack          = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat


--      key:  /opt/apps/gcc-4_8/mpich/3.1.1,
--      path: /opt/apps/gcc-4_8/mpich/3.1.1/lib, i: nil, j: nil

--------------------------------------------------------------------------
-- Check path against the *ignoreT* table.  Also it must be "in" dirA if
-- dirA exists.
-- @param path input path.
local function l_keepThisPath(path, dirA, keepA, ignoreA)
   dbg.start{"l_keepThisPath(",path,", dirA)"}

   if (dirA) then
      local match = false
      for k in pairs(dirA) do
         local i, j = path:find(k,1,true)
         dbg.print{"key: \"",k, "\", path: \"",path,"\", i: ",i,", j: ",j,"\n"}
         if ( i == 1) then
            match = true
            break
         end
      end
      if (not match) then
         dbg.print{"No match\n"}
         dbg.fini("l_keepThisPath")
         return false
      end
   end

   for i = 1, #keepA do
      if (path:find(keepA[i],1,true) == 1) then
         dbg.print{"In keepA list: path:",path,"\n"}
         dbg.fini("l_keepThisPath")
         return true
      end
   end

   for i = 1, #ignoreA do
      if (path:find(ignoreA[i],1,true) == 1) then
         dbg.print{"In ignore list: path:",path,"\n"}
         dbg.print{"Keep: false\n"}
         dbg.fini("l_keepThisPath")
         return false
      end
   end
   dbg.print{"Keep: true\n"}
   dbg.fini("l_keepThisPath")
   return true
end

--------------------------------------------------------------------------
-- Store an entry in *rmapT*
-- @param entry
-- @param tbl
-- @param rmapT
-- @param kind
local function l_add2map(entry, tbl, dirA, moduleFn, kind, rmapT)
   dbg.start{"l_add2map(entry, tbl, dirA, moduleFn, kind, rmapT)"}
   local keepA, ignoreA = hook.apply("reverseMapPathFilter")

   dbg.printT("ignoreA",ignoreA)
   if (type(keepA) ~= "table" ) then
      LmodError{msg="e_No_table", name = "keepA"}
   end
   if (type(ignoreA) ~= "table" ) then
      LmodError{msg="e_No_table", name = "ignoreA"}
   end

   for path in pairs(tbl) do
      local attr = lfs.attributes(path)
      local a    = attr or {}
      local keep = l_keepThisPath(path,dirA, keepA, ignoreA)
      dbg.print{"path: ",path,", keep: ",keep,", attr.mode: ",a.mode,"\n"}

      if (keep and attr and attr.mode == "directory") then
         local t       = rmapT[path] or {pkg=entry.fullName, kind = kind, moduleFn = moduleFn, flavorT = {}}
         local flavorT = t.flavorT
         if (entry.parentAA == nil) then
            flavorT.default = true
         else
            for i = 1, #entry.parentAA do
               local parentA = entry.parentAA[i]
               local a = {"default"}
               for j = 1, #parentA do
                  a[#a+1] = parentA[j]
               end
               local key = concatTbl(a,':')
               flavorT[key] = true
            end
         end
         dbg.print{"assigning rmapT for path: ",path,"\n"}
         rmapT[path] = t
         local p2 = realpath(path)
         if (p2 and p2 ~= path) then
            dbg.print{"assigning rmapT for path: ",p2,"\n"}
            rmapT[p2] = deepcopy(t)
         end
      end
   end
   dbg.fini("l_add2map")
end

--------------------------------------------------------------------------
-- Build the version string.
function l_version()
   local v = {}
   v[#v + 1] = "\nModules based on Lua: Version " .. Version.name().."\n"
   v[#v + 1] = "    by Robert McLay mclay@tacc.utexas.edu\n\n"
   return concatTbl(v,"")
end
--------------------------------------------------------------------------
--
-- @param moduleDirA
-- @param moduleT
-- @param timestampFn
-- @param dbT
local function l_rptList(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{"l_rptList(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   local spider = Spider:new()
   local tbl    = spider:listModules(dbT)
   for k in pairsByKeys(tbl) do
      print(k)
   end
   dbg.fini("l_rptList")
end

local function l_rptSpiderT(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptSpiderT(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   local mrc = MRC:singleton()
   local ts  = { timestampFn }
   local s1  = serializeTbl{name="timestampFn",   value=ts,         indent=true}
   local s2  = mrc:export()
   local s3  = serializeTbl{name="spiderT",       value=spiderT,    indent=true}
   local s4  = serializeTbl{name="mpathMapT",     value=mpathMapT,  indent=true}
   io.stdout:write(s1,s2,s3,s4,"\n")
   dbg.fini("l_rptSpiderT")
end

local function l_buildReverseMapT(dbT)
   dbg.start{"l_buildReverseMapT(dbT)"}
   local reverseMapT = {}

   for sn,vvv in pairs(dbT) do
      for fn, entry in pairs(vvv) do
         dbg.print{"sn: ",sn,", fn: ",fn,"\n"}
         if (entry.pathA) then
            l_add2map(entry, entry.pathA,  entry.dirA, fn, "bin", reverseMapT)
         end
         if (entry.lpathA) then
            l_add2map(entry, entry.lpathA, entry.dirA, fn, "lib", reverseMapT)
         end
         if (entry.dirA) then
            l_add2map(entry, entry.dirA,   entry.dirA, fn, "dir", reverseMapT)
         end
      end
   end

   for kk, vv in pairs(reverseMapT) do
      local flavor = {}
      local flavorT = vv.flavorT
      for k, v in pairs(flavorT) do
         flavor[#flavor+1] = k
      end
      vv.flavorT = nil
      sort(flavor)
      vv.flavor  = flavor
   end
   dbg.fini("l_buildReverseMapT")
   return reverseMapT
end

local function l_buildXALTrmapT(reverseMapT)
   local rmapT = {}
   for path,entry in pairs(reverseMapT) do
      local value  = entry.pkg
      local flavor = entry.flavor[1] or ""
      flavor       = flavor:gsub("default:?","")
      if (flavor ~= "") then
         value = value .. "(" .. flavor .. ")"
      end
      rmapT[path] = value
   end
   return rmapT
end

local function l_buildLibMapA(reverseMapT)
   local libT = {}
   for path,v in pairs(reverseMapT) do
      local kind = v.kind
      if (kind == "lib") then
         local attr = lfs.attributes(path)
         if (attr and type(attr) == "table" and attr.mode == "directory" and
                access(path,"x")) then
            for file in lfs.dir(path) do
               local ext = extname(file)
               if (ext == ".a" or ext == ".so" or ext == ".dylib") then
                  libT[file] = true
               end
            end
         end
      end
   end

   local libA = {}
   local i    = 0
   for k in pairs(libT) do
      i       = i + 1
      libA[i] = k
   end

   return libA
end



local function l_rptReverseMapT(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptReverseMapT(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   local ts          = { timestampFn }
   local reverseMapT = l_buildReverseMapT(dbT)
   local libA        = l_buildLibMapA(reverseMapT)
   local s1          = serializeTbl{name="timestampFn",   value=ts,
                                    indent=true}
   local s2          = serializeTbl{name="reverseMapT",
                                    value=reverseMapT,   indent=true}
   local s3          = serializeTbl{name="xlibmap", value = libA,
                                    indent = true}
   io.stdout:write(s1,s2,s3,"\n")
   dbg.fini("l_rptReverseMapT")
end

local function l_rptReverseMapTJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptReverseMapTJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   if (_VERSION ~= "Lua 5.1") then
      require("declare")
      declare("loadstring")
      loadstring = load
   end
   local json        = require("json")
   local reverseMapT = l_buildReverseMapT(dbT)
   local libA        = l_buildLibMapA(reverseMapT)
   local t           = { timestampFn = timestampFn,
                         reverseMapT = reverseMapT,
                         xlibmap     = libA}
   print(json.encode(t))
   dbg.fini("l_rptReverseMapTJson")
end

local function l_rptXALTRmapTJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptXALTRmapTJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   if (_VERSION ~= "Lua 5.1") then
      require("declare")
      declare("loadstring")
      loadstring = load
   end
   local json        = require("json")
   local reverseMapT = l_buildReverseMapT(dbT)
   local libA        = l_buildLibMapA(reverseMapT)
   local rmapT       = l_buildXALTrmapT(reverseMapT)
   local t           = { reverseMapT = rmapT,
                         xlibmap     = libA}
   print(json.encode(t))
   dbg.fini("l_rptXALTRmapTJson")
end

local function l_rptSoftwarePageJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptSoftwarePageJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   if (_VERSION ~= "Lua 5.1") then
      require("declare")
      declare("loadstring")
      loadstring = load
   end
   local json = require("json")
   local spA  = softwarePage(dbT)
   print(json.encode(spA))
   dbg.fini("l_rptSoftwarePageJson")
end

local function l_rptSoftwarePageLua(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptSoftwarePageLua(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   local spA = softwarePage(dbT)
   local s   = serializeTbl{name="spA",      value=spA,   indent=true}
   print(s)
   dbg.fini("l_rptSoftwarePageLua")
end

local function l_rptSoftwarePageXml(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptSoftwarePageXml(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   local xmlStr = xmlSoftwarePage(dbT)
   print(xmlStr)
   dbg.fini("l_rptSoftwarePageXml")
end

local function l_rptDbT(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptDbT(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   local ts = { timestampFn }
   local s1 = serializeTbl{name="timestampFn",  value=ts,          indent=true}
   local s2 = serializeTbl{name="dbT",          value=dbT,         indent=true}
   local s3 = serializeTbl{name="provideByT",   value=providedByT, indent=true}
   io.stdout:write(s1,s2,s3,"\n")
   dbg.fini("l_rptDbT")
end

local function l_rptDbTJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)
   dbg.start{ "l_rptDbTJson(mpathMapT, spiderT, timestampFn, dbT, providedByT)"}
   if (_VERSION ~= "Lua 5.1") then
      require("declare")
      declare("loadstring")
      loadstring = load
   end
   local json = require("json")
   print(json.encode(dbT))
   dbg.fini("l_rptDbTJson")
end


function main()

   options()
   local optionTbl  = optionTbl()
   local pargs      = optionTbl.pargs
   local mpathA     = {}
   Shell            = BaseShell:build("bash")

   local hub        = Hub:singleton(false)

   if (optionTbl.version) then
      io.stderr:write(l_version())
      os.exit(0)
   end

   for _, v in ipairs(pargs) do
      for path in v:split(":") do
         local my_path     = path_regularize(path)
         if (my_path:sub(1,1) ~= "/") then
            stderr:write("Each path in MODULEPATH must be absolute: ",path,"\n")
            os.exit(1)
         end
         mpathA[#mpathA+1] = my_path
      end
   end
   local mpath = concatTbl(mpathA,":")
   posix.setenv("MODULEPATH",mpath,true)


   if (optionTbl.debug > 0 or optionTbl.dbglvl) then
      local dbgLevel = math.max(optionTbl.debug, optionTbl.dbglvl or 1)
      dbg:activateDebug(dbgLevel)
   end

   dbg.start{"Spider main()"}
   dbg.print{"mcpStack: ",mcpStack,"\n"}
   MCP  = MainControl.build("spider")
   MCPQ = MainControl.build("quiet")
   mcp  = MainControl.build("spider")

   dbg.print{"LMOD_TRACING: ",cosmic:value("LMOD_TRACING"),"\n"}


   ------------------------------------------------------------------
   -- initialize lmod with SitePackage and /etc/lmod/lmod_config.lua
   initialize_lmod()

   ------------------------------------------------------------------------
   -- do not colorize output from spider
   colorize = plain

   local mrc        = MRC:singleton()

   mrc:set_display_mode("spider")

   -- Make sure that MRC uses $LMOD_MODULERC and ignores ~/.modulerc when building the cache
   local remove_MRC_home         = true
   local cache                   = Cache:singleton{dontWrite = true, quiet = true, buildCache = true,
                                                   buildFresh = true, noMRC=true}
   local spider                  = Spider:new()
   local spiderT, dbT,
         mpathMapT, providedByT  = cache:build()


   if (dbg.active()) then
      for k,v in pairs(spiderT) do
         dbg.print{"k: ",k,"\n"}
      end
   end


   -- This interpT converts user outputstyle into a function call.

   local interpT = {
      list             = l_rptList,
      moduleT          = l_rptSpiderT,
      spiderT          = l_rptSpiderT,
      softwarePage     = l_rptSoftwarePageJson,
      jsonSoftwarePage = l_rptSoftwarePageJson,
      xmlSoftwarePage  = l_rptSoftwarePageXml,
      softwarePageLua  = l_rptSoftwarePageLua,
      reverseMapT      = l_rptReverseMapT,
      reverseMap       = l_rptReverseMapT,
      jsonReverseMapT  = l_rptReverseMapTJson,
      jsonReverseMap   = l_rptReverseMapTJson,
      xalt_rmapT       = l_rptXALTRmapTJson,
      xalt_rmap        = l_rptXALTRmapTJson,
      ["spider-json"]  = l_rptDbTJson,
      dbT              = l_rptDbT,
   }

   -- grap function and run with it.
   local func = interpT[optionTbl.outputStyle]
   if (func) then
      func(mpathMapT, spiderT, optionTbl.timestampFn, dbT, providedByT)
   end
   dbg.fini()
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
      Description = "description",
      fullName    = "full",
      help        = "help",
      parentAA    = "parent",
      wV          = "wV",
      hidden      = "hidden",
      family      = "family",
      propT       = "properties",
      provides    = "provides",
   }


   local entry    = {}
   entry.package  = name
   local versionA = {}

   local wV       = " "  -- This is the lowest possible value for a pV
   local epoch    = 0

   local a        = {}

   --------------------------------------------------------
   -- Sort the version by pV

   for mfPath,v in pairs(vv) do
      a[#a+1] = { mfPath, v.wV }
   end

   local function l_cmp_wV(x,y)
      return x[2] < y[2]
   end
   sort(a,l_cmp_wV)

   ------------------------------------------------------------
   -- Loop over version from lowest to highest version in pv
   -- order.

   for i = 1, #a do
      local mfPath = a[i][1]
      local v      = vv[mfPath]
      local vT = {}

      vT.path = mfPath

      if (v.wV > wV) then
         wV = v.wV
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
         vT.canonicalVersionString = v.pV
      end
      if (v.wV) then
         vT.markedDefault=isMarked(v.wV)
      end

      if (not vT.hidden) then
         versionA[#versionA + 1] = vT
      end
   end

   entry.versions = versionA
   spA[#spA+1] = entry
end

local function l_Error(...)
   local argA   = pack(...)
   for i = 1,argA.n do
      stderr:write(argA[i])
   end
end

local function l_prt(...)
   stderr:write(...)
end

function options()
   local optionTbl = optionTbl()
   local usage         = "Usage: spider [options] moduledir ..."
   local cmdlineParser = Optiks:new{usage   = usage,
                                    version = "1.0",
                                    error   = l_Error,
                                    prt     = l_prt,
   }

   cmdlineParser:add_option{
      name   = {'-v','--version'},
      dest   = 'version',
      action = 'store_true',
      help   = "Version info",
   }

   cmdlineParser:add_option{
      name   = {'-D'},
      dest   = 'debug',
      action = 'count',
      help   = "Program tracing written to stderr",
   }

   cmdlineParser:add_option{
      name   = {"-T", "--trace" },
      dest   = "trace",
      action = "store_true",
      help   = "Tracing",
   }
   cmdlineParser:add_option{
      name   = {'--debug'},
      dest   = 'dbglvl',
      action = 'store',
      help   = "Program tracing written to stderr",
   }

   cmdlineParser:add_option{
      name    = {'-o','--output'},
      dest    = 'outputStyle',
      action  = 'store',
      default = "list",
      help    = "Output Style: list, spiderT, dbT, reverseMapT, "..
                "jsonReverseMapT, spider-json, softwarePage, "..
                "jsonSoftwarePage, xmlSoftwarePage, xalt_rmapT"
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

   cmdlineParser:add_option{
      name    = {'--preload'},
      dest    = 'preload',
      action  = 'store_true',
      default = false,
      help    = "Use preloaded modules to build reverseMapT"
   }

   local optTbl, pargs = cmdlineParser:parse(arg)

   if (optionTbl.trace) then
      cosmic:assign("LMOD_TRACING", "yes")
   end

   for v in pairs(optTbl) do
      optionTbl[v] = optTbl[v]
   end
   optionTbl.pargs = pargs
   Use_Preload     = optionTbl.preload
end

function xmlSoftwarePage(dbT)
   require("LuaXML")  -- This defines xml

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
   if a == nil then
       return "default"
   end
   for i = 1, #a do
      local entryfull = concatTbl(a[i],":")
      local b = {}
      for j = 1, #a[i] do
           local entry = a[i][j]
           local name, version = splitNV(entry)
           b[#b+1] = name .. "/" .. parseVersion(version)
      end
      aa[i] = { concatTbl(b,":"), entryfull}
   end

   table.sort(aa, function(x,y) return x[1] > y[1] end)

   local result = aa[1][2]
   if (result ~= "default") then
      result = result:gsub("default:","")
   end

   return result
end


function localSoftware(xml, name, t)
   dbg.start{"localSoftware(xml,",name,",t)"}

   local root = xml.new("LocalSoftware")

   local Name
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

   Name    = xml.new("Type")
   Name[1] = value
   root:append(Name)
   dbg.print{"Type: ",value,"\n"}

   Name    = xml.new("Domain")
   Name[1] = domain
   root:append(Name)
   dbg.print{"domain: ",domain,"\n"}

   Name    = xml.new("Name")
   Name[1] = name
   root:append(Name)
   dbg.print{"name: ",name,"\n"}

   local Description = xml.new("Description")
   Description[1]    = t.Description
   root:append(Description)

   local Flavor = xml.new("Flavor")
   Flavor[1] = t.Version
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
   HKey[1]      = t.fullName
   Handle:append(HKey)
   root:append(Handle)

   local Context = xml.new("Context")
   Context[1] = findLatestV(t.parentAA)
   root:append(Context)

   dbg.fini()
   return root
end

main()
