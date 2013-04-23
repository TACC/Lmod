require("strict")
local LmodError          = LmodError
local ModulePath         = ModulePath
local assert             = assert
local capture            = capture
local cmdDir             = cmdDir
local concatTbl          = table.concat
local floor              = math.floor
local getenv             = os.getenv
local io                 = io
local ipairs             = ipairs
local loadfile           = loadfile
local loadstring         = loadstring
local myFileName         = myFileName
local next               = next
local os                 = os
local pairs              = pairs
local print              = print
local prtErr             = prtErr
local setmetatable       = setmetatable
local sort               = table.sort
local string             = string
local systemG            = _G
local tonumber           = tonumber
local tostring           = tostring
local type               = type
local expert             = expert
local removeEntry        = table.remove

require("TermWidth")
require("fileOps")
require("string_trim")
require("fillWords")
require("lastFileInDir")
require("sandbox")

ModuleName=""
local BeautifulTbl = require('BeautifulTbl')
local ColumnTable  = require('ColumnTable')
local Dbg          = require("Dbg")
local Default      = '(D)'
local InheritTmpl  = require("InheritTmpl")
local M            = {}
local MName        = require("MName")
local MT           = MT
local ModuleStack  = require("ModuleStack")
local Optiks       = require("Optiks")
local Spider       = require("Spider")
local abspath      = abspath
local extname      = extname
local hook         = require("Hook")
local isFile       = isFile
local lfs          = require('lfs')
local pathJoin     = pathJoin
local posix        = require("posix")

--module("Master")

s_master = {}

local function new(self,safe)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   o.safe       = safe
   return o
end

local searchTbl = {'.lua', '', '/default', '/.version'}

local function followDefault(path)
   if (path == nil) then return nil end
   local dbg      = Dbg:dbg()
   dbg.start("followDefault(path=\"",path,"\")")
   local attr = lfs.symlinkattributes(path)
   local result = path
   if (attr == nil) then
      result = nil
   elseif (attr.mode == "link") then
      local rl = posix.readlink(path)
      local a  = {}
      local n  = 0
      for s in path:split("/") do
         n = n + 1
         a[n] = s or ""
      end

      a[n] = ""
      local i  = n
      for s in rl:split("/") do
         if (s == "..") then
            i = i - 1
         else
            a[i] = s
            i    = i + 1
         end
      end
      result = concatTbl(a,"/")
   end
   dbg.print("result: ",result,"\n")
   dbg.fini("followDefault")
   return result
end


local function find_module_file(mname)
   local dbg      = Dbg:dbg()
   dbg.start("Master:find_module_file(",mname:usrName(),")")

   local t        = { fn = nil, modFullName = nil, modName = nil, default = 0, hash = 0}
   local mt       = MT:mt()
   local fullName = ""
   local modName  = ""
   local sn       = mname:sn()
   dbg.print("sn: ",sn,"\n")

   local pathA = mt:locationTbl(sn)

   if (pathA == nil or #pathA == 0) then
      dbg.print("did not find key: \"",sn,"\" in mt:locationTbl()\n")
      dbg.fini("Master:find_module_file")
      return t
   end
   local fn, result

   for ii, vv in ipairs(pathA) do
      t.default = 0
      local mpath  = vv.mpath
      fn           = pathJoin(vv.file, mname:version())
      result = nil
      local found  = false
      for _,v in ipairs(searchTbl) do
         local f    = fn .. v
         local attr = lfs.attributes(f)
         local readable = posix.access(f,"r")
         dbg.print('(1) fn: ',fn," v: ",v," f: ",f,"\n")

         if (readable and attr and attr.mode == 'file') then
            result    = f
            found     = true
         end
         if (found and v == '/default' and ii == 1) then
            result    = followDefault(result)
            dbg.print("(2) result: ",result, " f: ", f, "\n")
            t.default = 1
         elseif (found and v == '/.version' and ii == 1) then
            local vf = M.versionFile(result)
            if (vf) then
               t         = find_module_file(MName:new("load",pathJoin(sn,vf)))
               t.default = 1
               result    = t.fn
            end
         end
         if (found) then
            local i,j = result:find(mpath,1,true)
            fullName  = result:sub(j+2):gsub("%.lua$","")
            dbg.print("fullName: ",fullName,"\n")
            break
         end
      end

      dbg.print("found:", found, " fn: ",fn,"\n")

      ------------------------------------------------------------
      --  Search for "last" file in directory
      ------------------------------------------------------------

      if (not found and ii == 1) then
         t.default  = 1
         result = lastFileInDir(fn)
         if (result) then
            found = true
            local i, j = result:find(mpath,1,true)
            fullName   = result:sub(j+2):gsub("%.lua$","")
            dbg.print("lastFileInDir mpath: ", mpath," fullName: ",fullName,"\n")
         end
      end
      if (found) then break end
   end

   t.fn          = result
   t.modFullName = fullName
   t.modName     = sn
   dbg.print("modName: ",sn," fn: ", result," modFullName: ", fullName," default: ",t.default,"\n")
   dbg.fini("Master:find_module_file")
   return t
end

function loadModuleFile(t)
   local dbg    = Dbg:dbg()
   dbg.start("loadModuleFile")
   dbg.print("t.file: ",t.file,"\n")
   dbg.flush()

   systemG._MyFileName = t.file

   local myType = extname(t.file)
   local func
   local msg
   local status = true
   local whole
   if (myType == ".lua") then
      local f = io.open(t.file)
      if (f) then
         whole = f:read("*all")
         f:close()
      end
   else
      local mt	   = MT:mt()
      local s      = concatTbl(mt:list("short","active"),":")
      local A      = {}
      A[#A + 1]    = "-l"
      A[#A + 1]    = "\"" .. s .. "\"" 
      A[#A + 1]    = "-f"
      A[#A + 1]    = t.fullName
      A[#A + 1]    = "-u"
      A[#A + 1]    = t.moduleName
      A[#A + 1]    = "-s"
      A[#A + 1]    = s_master.shell:name()
      if (t.help) then
         A[#A + 1] = t.help
      end
      local a      = {}
      a[#a + 1]	   = pathJoin(cmdDir(),"tcl2lua.tcl")
      a[#a + 1]	   = concatTbl(A," ")
      a[#a + 1]	   = t.file
      local cmd    = concatTbl(a," ")
      whole        = capture(cmd) 
   end

   if (whole) then
      status, msg = sandbox_run(whole)
   else
      status = nil
      msg    = "Empty or non-existant file"
   end

   if (not status and t.reportErr) then
      local n = t.moduleName or ""
      
      LmodError("Unable to load module: ",n,"\n    ",t.file,": ", msg,"\n")
   end
   dbg.fini("loadModuleFile")
end

function M.master(self, safe)
   if (next(s_master) == nil) then
      MT       = systemG.MT
      s_master = new(self, safe)
   end
   return s_master
end

function M.safeToUpdate()
   return s_master.safe
end

function M.unload(...)
   local mStack = ModuleStack:moduleStack()
   local mt     = MT:mt()
   local dbg    = Dbg:dbg()
   local a      = {}
   dbg.start("Master:unload(",concatTbl({...},", "),")")

   local mcp_old = mcp

   mcp = MasterControl.build("unload")
   for _, moduleName in ipairs{...} do
      local mname = MName:new("mt", moduleName)
      local sn    = mname:sn()
      dbg.print("Trying to unload: ", moduleName, " sn: ", sn,"\n")
      
      if (mt:have(sn,"inactive")) then
         dbg.print("Removing inactive module: ", moduleName, "\n")
         mt:remove(sn)
         a[#a + 1] = true
      elseif (mt:have(sn,"active")) then
         dbg.print("Mark ", moduleName, " as pending\n")
         mt:setStatus(sn,"pending")
         local f              = mt:fileName(sn)
         local fullModuleName = mt:fullName(sn)
         dbg.print("Master:unload: \"",fullModuleName,"\" from f: ",f,"\n")
         mt:beginOP()
         mStack:push(fullModuleName,f)
	 loadModuleFile{file=f,moduleName=moduleName, 
                        fullName=fullModuleName,reportErr=false}
         mStack:pop()
         mt:endOP()
         dbg.print("calling mt:remove(\"",sn,"\")\n")
         mt:remove(sn)
         a[#a + 1] = true
      else
         a[#a + 1] = false
      end
   end
   if (M.safeToUpdate() and mt:safeToCheckZombies() and mStack:empty()) then
      M.reloadAll()
   end
   mcp = mcp_old
   dbg.print("Resetting mcp to ", mcp:name(),"\n")
   dbg.fini("Master:unload")
   return a
end

function M.versionFile(path)
   local dbg     = Dbg:dbg()
   dbg.start("versionFile(",path,")")
   local f       = io.open(path,"r")
   if (not f)                        then
      dbg.print("could not find: ",path,"\n")
      dbg.fini("versionFile")
      return nil
   end
   local s       = f:read("*line")
   f:close()
   if (not s:find("^#%%Module"))      then
      dbg.print("could not find: #%Module\n")
      dbg.fini("versionFile")
      return nil
   end
   local cmd = pathJoin(cmdDir(),"ModulesVersion.tcl") .. " " .. path
   dbg.fini("versionFile")
   return capture(cmd):trim()
end

local function access_find_module_file(mname)
   local mt    = MT:mt()
   local sn    = mname:sn()
   if (sn == mname:usrName() and mt:have(sn,"any")) then
      local full = mt:fullName(sn) 
      return mt:fileName(sn), full or ""
   end
   
   local t    = find_module_file(mname)
   local full = t.modFullName or ""
   local fn   = t.fn
   return fn, full
end

function M.access(self, ...)
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   local mStack = ModuleStack:moduleStack()
   local prtHdr = systemG.prtHdr
   local help   = nil
   local a      = {}
   local result, t
   io.stderr:write("\n")
   if (systemG.help ~= dbg.quiet) then help = "-h" end
   for _, moduleName in ipairs{...} do
      local mname = MName:new("load", moduleName)
      local fn, full   = access_find_module_file(mname)
      --io.stderr:write("full: ",full,"\n")
      systemG.ModuleFn   = fn
      systemG.ModuleName = full
      if (fn and isFile(fn)) then
         prtHdr()
         mStack:push(full, fn)
	 loadModuleFile{file=fn,help=help,moduleName=moduleName,
                        fullName=full,reportErr=true}
         mStack:pop()
         io.stderr:write("\n")
      else
         a[#a+1] = moduleName
      end
   end

   if (#a > 0) then
      io.stderr:write("Failed to find the following module(s):  \"",concatTbl(a,"\", \""),"\" in your MODULEPATH\n")
      io.stderr:write("Try: \n",
       "    \"module spider ", concatTbl(a," "), "\"\n",
       "\nto see if the module(s) are available across all compilers and MPI implementations.\n")
   end
end



function M.reload()
   local mStack = ModuleStack:moduleStack()
   local mt    = MT:mt()
   local dbg   = Dbg:dbg()
   dbg.start("Master:reload()")

   local activeA = mt:list("short","active")

   for i = 1,#activeA do
      local sn = activeA[i]
      local fn = mt:fileName(sn)
      local full = mt:fullName(sn)
      dbg.print("loading: ",sn," fn: ", fn,"\n")
      loadModuleFile{file = fn, moduleName = sn, fullName = full, reportErr=true}
   end

   dbg.fini("Master:reload")
end


function M.load(...)
   local mStack = ModuleStack:moduleStack()
   local mt    = MT:mt()
   local dbg   = Dbg:dbg()
   local a     = {}

   dbg.start("Master:load(",concatTbl({...},", "),")")

   a   = {}
   for _,moduleName in ipairs{...} do
      moduleName    = moduleName
      local mname   = MName:new("load",moduleName)
      local sn      = mname:sn()
      local loaded  = false
      local t	    = find_module_file(mname)
      local fn      = t.fn
      if (mt:have(sn,"active") and fn  ~= mt:fileName(sn)) then
         dbg.print("Master:load reload module: \"",moduleName,"\" as it is already loaded\n")
         local mcp_old = mcp
         mcp           = MCP
         mcp:unload(moduleName)
         local aa = mcp:load(moduleName)
         mcp           = mcp_old
         loaded = aa[1]
      elseif (fn) then
         dbg.print("Master:loading: \"",moduleName,"\" from f: \"",fn,"\"\n")
         mt:add(t, "pending")
	 mt:beginOP()
         mStack:push(t.modFullName,fn)
	 loadModuleFile{file=fn,moduleName=moduleName,
                        fullName=t.modFullName,reportErr=true}
         t.mType = mStack:moduleType()
         mStack:pop()
	 mt:endOP()
         dbg.print("Making ", t.modName, " active\n")
         mt:setStatus(sn, "active")
         mt:set_mType(sn, t.mType)
         dbg.print("Marked: ",t.modFullName," as loaded\n")
         loaded = true
         hook.apply("load",t)
      end
      a[#a+1] = loaded
   end
   if (M.safeToUpdate() and mt:safeToCheckZombies() and mStack:empty()) then
      dbg.print("Master:load calling reloadAll()\n")
      M.reloadAll()
   end
   dbg.fini("Master:load")
   return a
end

function M.fakeload(...)
   local a   = {}
   local mt  = MT:mt()
   local dbg = Dbg:dbg()
   dbg.start("Master:fakeload(",concatTbl({...},", "),")")

   for _, moduleName in ipairs{...} do
      local loaded = false
      local mname  = MName:new("load", moduleName)
      local t      = find_module_file(mname)
      local fn     = t.fn
      if (fn) then
         t.mType = "m"
         mt:add(t,"active")
         loaded = true
      end
      a[#a+1] = loaded
   end
   dbg.fini("Master:fakeload")
end         


function M.reloadAll()
   local mt   = MT:mt()
   local dbg  = Dbg:dbg()
   dbg.start("Master:reloadAll()")


   local mcp_old = mcp
   mcp = MCP

   local same = true
   local a    = mt:list("userName","any")
   for _, v in ipairs(a) do
      local sn = v.sn
      if (mt:have(sn, "active")) then
         dbg.print("module sn: ",sn," is active\n")
         dbg.print("userName:  ",v.name,"\n")
         local mname    = MName:new("userName", v.name)
         local t        = find_module_file(mname)
         local fn       = mt:fileName(sn)
         local fullName = t.modFullName
         local userName = v.name
         if (t.fn ~= fn) then
            dbg.print("Master:reloadAll t.fn: \"",t.fn or "nil","\"",
                      " mt:fileName(sn): \"",fn or "nil","\"\n")
            dbg.print("Master:reloadAll Unloading module: \"",sn,"\"\n")
            mcp:unloadsys(sn)
            dbg.print("Master:reloadAll Loading module: \"",userName or "nil","\"\n")
            local loadA = mcp:load(userName)
            dbg.print("Master:reloadAll: fn: \"",fn or "nil",
                      "\" mt:fileName(sn): \"", tostring(mt:fileName(sn)), "\"\n")
            if (loadA[1] and fn ~= mt:fileName(sn)) then
               same = false
               dbg.print("Master:reloadAll module: ",fullName," marked as reloaded\n")
            end
         end
      else
         dbg.print("module sn: ", sn, " is inactive\n")
         local fn    = mt:fileName(sn)
         local name  = v.name          -- This name is short for default and
                                       -- Full for specific version.
         dbg.print("Master:reloadAll Loading module: \"", name, "\"\n")
         local aa = mcp:load(name)
         if (aa[1] and fn ~= mt:fileName(sn)) then
            dbg.print("Master:reloadAll module: ", name, " marked as reloaded\n")
         end
         same = not aa[1]
      end
   end
   for _, v in ipairs(a) do
      local sn = v.sn
      if (not mt:have(sn, "active")) then
         local t = { modFullName = v.full, modName = sn, default = v.defaultFlg}
         dbg.print("Master:reloadAll module: ", sn, " marked as inactive\n")
         mt:add(t, "inactive")
      end
   end

   mcp = mcp_old
   dbg.print("Resetting mpc to ", mcp:name(),"\n")
   dbg.fini("Master:reloadAll")
   return same
end

function M.inheritModule()
   local dbg     = Dbg:dbg()
   dbg.start("Master:inherit()")

   local mStack  = ModuleStack:moduleStack()
   local myFn    = mStack:fileName()
   local mName   = mStack:moduleName()
   local inhTmpl = InheritTmpl:inheritTmpl()

   dbg.print("myFn:  ", myFn,"\n")
   dbg.print("mName: ", mName,"\n")

   
   local t = inhTmpl.find_module_file(mName,myFn)
   dbg.print("fn: ", t.fn,"\n")
   if (t.fn == nil) then
      LmodError("Failed to inherit: ",mName,"\n")
   else
      mStack:push(mName,t.fn)
      loadModuleFile{file=t.fn,moduleName=mName,
                     fullName=mName,reportErr=true}
      mStack:pop()
   end
   dbg.fini("Master:inherit")
end

local function dirname(f)
   local result = './'
   for w in f:gmatch('.*/') do
      result = w
      break
   end
   return result
end


local function prtDirName(width,path,a)
   local len     = path:len()
   local lcount  = floor((width - (len + 2))/2)
   local rcount  = width - lcount - len - 2
   a[#a+1] = "\n"
   a[#a+1] = string.rep("-",lcount)
   a[#a+1] = " "
   a[#a+1] = path
   a[#a+1] = " "
   a[#a+1] = string.rep("-",rcount)
   a[#a+1] = "\n"
end




local function findDefault(mpath, sn, versionA)
   local dbg  = Dbg:dbg()
   dbg.start("Master.findDefault(mpath=\"",mpath,"\", "," sn=\"",sn,"\")")
   local mt   = MT:mt()

   local pathA  = mt:locationTbl(sn) 
   local mpath2 = pathA[1].mpath

   if (mpath2 ~= mpath) then
      dbg.print("(1) default: \"nil\"\n")
      dbg.fini("Master.findDefault")
      return nil
   end

   local localDir = true
   local path     = pathJoin(mpath,sn)
   local default  = abspath(pathJoin(path, "default"), localDir)
   if (default == nil) then
      local vFn = abspath(pathJoin(path,".version"), localDir)
      if (isFile(vFn)) then
         local vf = M.versionFile(vFn)
         if (vf) then
            local f = pathJoin(path,vf)
            default = abspath(f,localDir)
            --dbg.print("(1) f: ",f," default: ", default, "\n")
            if (default == nil) then
               local fn = vf .. ".lua"
               local f  = pathJoin(path,fn)
               default  = abspath(f,localDir)
               dbg.print("(2) f: ",f," default: ", default, "\n")
            end
            --dbg.print("(3) default: ", default, "\n")
         end
      end
   end

   if (not default) then
      default = abspath(versionA[#versionA].file, localDir)
   end
   dbg.print("default: ", default,"\n")
   dbg.fini("Master.findDefault")

   return default, #versionA
end

local function availEntry(defaultOnly, terse, szA, searchA, sn, name, f, defaultModule, dbT, legendT, a)
   local dbg      = Dbg:dbg()
   dbg.start("Master:availEntry(defaultOnly, terse, szA, searchA, sn, name, f, defaultModule, dbT, legendT, a)")

   dbg.print("sn:" ,sn, ", name: ", name,", defaultOnly: ",defaultOnly,", szA: ",szA,"\n")
   local dflt     = ""
   local sCount   = #searchA
   local found    = false
   local localdir = true
   local mt       = MT:mt()

   if (sCount == 0) then
      found = true
   else
      for i = 1, sCount do
         local s = searchA[i]
         if (name:find(s, 1, true) or name:find(s) or
             sn:find(s, 1, true)   or sn:find(s)) then
            found = true
            break
         end
      end
   end

   if (defaultOnly and szA > 1 and  defaultModule ~= abspath(f, localdir)) then
      found = false
   end

   if (not found) then
      dbg.print("Not found\n")
      dbg.fini("Master:availEntry")
      return
   end
      


   if (terse) then
      a[#a+1] = name
   else
      if (defaultModule == abspath(f, localdir) and szA > 1 and
          not defaultOnly ) then
         dflt = Default
         legendT[Default] = "Default Module"
      end
      dbg.print("dflt: ",dflt,"\n")
      local aa    = {}
      local propT = {}
      local mname = MName:new("load", name)
      local sn    = mname:sn()
      local entry = dbT[sn]
      if (entry) then
         dbg.print("Found dbT[sn]\n")
         if (entry[f]) then
            propT =  entry[f].propT or {}
         end
      else
         dbg.print("Did not find dbT[sn]\n")
      end
      local resultA = colorizePropA("short", name, propT, legendT)
      aa[#aa + 1] = '  '
      for i = 1,#resultA do
         aa[#aa+1] = resultA[i]
      end
      aa[#aa + 1] = dflt
      a[#a + 1]   = aa
   end
   dbg.fini("Master:availEntry")
end



local function availDir(defaultOnly, terse, searchA, mpath, availT, dbT, a, legendT)
   local dbg    = Dbg:dbg()
   dbg.start("Master.availDir(defaultOnly= ",defaultOnly,", terse= ",terse, ", searchA=(",concatTbl(searchA,", "),
             "), mpath= \"",mpath,"\", ", "availT, dbT, a, legendT)")
   local attr    = lfs.attributes(mpath)
   local mt      = MT:mt()
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory" or not posix.access(mpath,"x")) then
      dbg.print("Skipping non-existant directory: ", mpath,"\n")
      dbg.fini("Master.availDir")
      return
   end


   for sn, versionA in pairsByKeys(availT) do
      local defaultModule = false
      local aa            = {}
      local szA           = #versionA 
      if (szA == 0) then
         availEntry(defaultOnly, terse, szA, searchA, sn, sn, "", defaultModule, dbT, legendT, a)
      else
         defaultModule = findDefault(mpath, sn, versionA)
         for i = 1, #versionA do
            local name = pathJoin(sn, versionA[i].version)
            local f    = versionA[i].file
            availEntry(defaultOnly, terse, szA, searchA, sn, name, f, defaultModule, dbT, legendT, a)
         end
      end
   end
   dbg.fini("Master.availDir")
end

local function availOptions(argA)
   local usage = "Usage: module avail [options] search1 search2 ..."
   local cmdlineParser = Optiks:new{usage=usage, version=""}

   argA[0] = "avail"

   cmdlineParser:add_option{ 
      name   = {'-t', '--terse'},
      dest   = 'terse',
      action = 'store_true',
   }
   cmdlineParser:add_option{ 
      name   = {'-d','--default'},
      dest   = 'defaultOnly',
      action = 'store_true',
   }
   local optionTbl, pargs = cmdlineParser:parse(argA)
   return optionTbl, pargs

end
      


function M.avail(argA)
   local dbg    = Dbg:dbg()
   dbg.start("Master.avail(",concatTbl(argA,", "),")")
   local mt     = MT:mt()
   local mpathA = mt:module_pathA()
   local width  = TermWidth()
   local masterTbl = masterTbl()

   local cache   = Cache:cache{quiet = masterTbl.terse}
   local moduleT = cache:build()
   local dbT     = {}
   Spider.buildSpiderDB({"default"}, moduleT, dbT)

   local legendT = {}
   local availT  = mt:availT()

   local aa = {}

   local optionTbl, searchA = availOptions(argA)

   local defaultOnly = optionTbl.defaultOnly or masterTbl.defaultOnly
   local terse       = optionTbl.terse       or masterTbl.terse


   if (terse) then
      dbg.print("doing --terse\n")
      for ii = 1, #mpathA do
         local mpath = mpathA[ii]
         local a     = {}
         availDir(defaultOnly, terse, searchA, mpath, availT[mpath], dbT, a, legendT)
         if (next(a)) then
            io.stderr:write(mpath,":\n")
            for i=1,#a do
               io.stderr:write(a[i],"\n")
            end
         end
      end
      dbg.fini("Master:avail")
      return
   end

   for _,mpath in ipairs(mpathA) do
      local a = {}
      availDir(defaultOnly, terse, searchA, mpath, availT[mpath], dbT, a, legendT)
      if (next(a)) then
         prtDirName(width, mpath,aa)
         local ct  = ColumnTable:new{tbl=a, gap=1, len=length}
         aa[#aa+1] = ct:build_tbl()
         aa[#aa+1] = "\n"
      end
   end

   if (next(legendT)) then
      local term_width = TermWidth()
      aa[#aa+1] = "\n  Where:\n"
      local a = {}
      for k, v in pairsByKeys(legendT) do
         a[#a+1] = { "   " .. k ..":", v}
      end
      local bt = BeautifulTbl:new{tbl=a, column = term_width-1, len=length}
      aa[#aa+1] = bt:build_tbl()
      aa[#aa+1] = "\n"
   end
   

   if (not expert()) then
      local a = fillWords("","Use \"module spider\" to find all possible modules.",width)
      local b = fillWords("","Use \"module keyword key1 key2 ...\" to search for all " ..
                             "possible modules matching any of the \"keys\".",width)
      aa[#aa+1] = "\n"
      aa[#aa+1] = a
      aa[#aa+1] = "\n"
      aa[#aa+1] = b
      aa[#aa+1] = "\n\n"
   end
   pcall(pager,io.stderr,concatTbl(aa,""))
   dbg.fini("Master.avail")
end

return M
