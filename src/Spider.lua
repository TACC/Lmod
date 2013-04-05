require("TermWidth")
require("border")
require("lastFileInDir")
require("strict")
require("string_split")
require("string_trim")
require("fileOps")
require("fillWords")
require("capture")
require("pairsByKeys")
require("pager")

local M = {}

local Dbg         = require("Dbg")
local assert      = assert
local border      = border
local capture     = capture
local cmdDir      = cmdDir
local concatTbl   = table.concat
local extname     = extname
local fillWords   = fillWords
local io          = io
local ipairs      = ipairs
local lfs         = require("lfs")
local loadfile    = loadfile
local loadstring  = loadstring
local next        = next
local pairs       = pairs
local pairsByKeys = pairsByKeys 
local pathJoin    = pathJoin
local posix       = require("posix")
local print       = print
local os          = os
local systemG     = _G
local tonumber    = tonumber
local tostring    = tostring
local type        = type

function nothing()
end

local master    = {}

function masterTbl()
   return master
end

local masterTbl = masterTbl

function Spider_setenv(name, value)
   if (name:find("^TACC_.*_LIB")) then
      processLPATH(value)
   end
end   

function Spider_myFileName()
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   return moduleStack[iStack].fn
end

function Spider_myModuleName()
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   return moduleStack[iStack].full
end

function Spider_help(...)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   local path        = moduleStack[iStack].path
   local moduleT     = moduleStack[iStack].moduleT
   moduleT[path].help = concatTbl({...},"")
end

KeyT = {Description=1, Name=1, URL=1, Version=1, Category=1, Keyword=1}

function Spider_whatis(s)
   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   local path        = moduleStack[iStack].path
   local moduleT     = moduleStack[iStack].moduleT

   local i,j, key, value = s:find('^%s*([^: ]+)%s*:%s*(.*)')
   local k  = KeyT[key]
   if (k) then
      moduleT[path][key] = value
   end
   if (moduleT[path].whatis == nil) then
      moduleT[path].whatis ={}
   end
   moduleT[path].whatis[#moduleT[path].whatis+1] = s
end

function processLPATH(value)
   if (value == nil) then return end
   local masterTbl      = masterTbl()
   local moduleStack    = masterTbl.moduleStack 
   local iStack         = #moduleStack
   local path           = moduleStack[iStack].path
   local moduleT        = moduleStack[iStack].moduleT
   
   local lpathA         = moduleT[path].lpathA or {}
   value                = path_regularize(value)
   lpathA[value]        = 1
   moduleT[path].lpathA = lpathA
end

function processPATH(value)
   if (value == nil) then return end

   local masterTbl     = masterTbl()
   local moduleStack   = masterTbl.moduleStack 
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   
   local pathA         = moduleT[path].pathA or {}
   value               = path_regularize(value)
   pathA[value]        = 1
   moduleT[path].pathA = pathA
end


function Spider_append_path(kind, name, value)
   if (name == "MODULEPATH") then
      local dbg = Dbg:dbg()
      dbg.start(kind,"(MODULEPATH=\"",name,"\", value=\"",value,"\")")
      processNewModulePATH(value)
      dbg.fini()
   elseif (name == "PATH") then
      processPATH(value)
   elseif (name == "LD_LIBRARY_PATH") then
      processLPATH(value)
   end
end

function processNewModulePATH(value)
   if (value == nil) then return end
   local dbg = Dbg:dbg()
   dbg.start("processNewModulePATH(value=\"",value,"\")")

   local masterTbl   = masterTbl()
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   if (masterTbl.no_recursion) then
      dbg.fini()
      return
   end

   for v in value:split(":") do
      v = path_regularize(v)
      dbg.print("v: ", v,"\n")
      local path    = moduleStack[iStack].path
      local full    = moduleStack[iStack].full
      local moduleT = moduleStack[iStack].moduleT
      iStack        = iStack+1
      moduleStack[iStack] = {path = path, full = full, moduleT = moduleT[path].children, fn= v}
      dbg.print("Top of Stack: ",iStack, " Full: ", full, " file: ", path, "\n")
      moduleT[path].children[v] = {}
      moduleT[path].children.version = Cversion
      M.findModulesInDir(v, v, "", moduleT[path].children[v])
      moduleStack[iStack] = nil
   end

   dbg.fini()
end

function Spider_add_property(name,value)
   local dbg = Dbg:dbg()
   dbg.start("Spider_add_property(name=\"",name,"\", value=\"",value,"\")")

   local masterTbl     = masterTbl()
   local moduleStack   = masterTbl.moduleStack 
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   local t             = moduleT[path].propT or {}
   t[name]             = t[name] or {}
   t[name][value]      = 1
   moduleT[path].propT = t
   dbg.fini()
end

function Spider_remove_property(name,value)
   local dbg = Dbg:dbg()
   dbg.start("Spider_remove_property(name=\"",name,"\", value=\"",value,"\")")
   local masterTbl     = masterTbl()
   local moduleStack   = masterTbl.moduleStack 
   local iStack        = #moduleStack
   local path          = moduleStack[iStack].path
   local moduleT       = moduleStack[iStack].moduleT
   local t             = moduleT[path].propT or {}
   t[name]             = t[name] or {}
   t[name][value]      = nil
   moduleT[path].propT = t
   dbg.fini()
end


------------------------------------------------------------
--module("Spider")
------------------------------------------------------------



function versionFile(path)
   local dbg     = Dbg:dbg()
   dbg.start("versionFile(",path,")")
   local f       = io.open(path,"r")
   if (not f)                        then
      dbg.print("could not find: ",path,"\n")
      dbg.fini()
      return nil
   end
   local s       = f:read("*line")
   f:close()
   if (not s:find("^#%%Module"))      then
      dbg.print("could not find: #%Module\n")
      dbg.fini()
      return nil
   end
   local cmd = pathJoin(cmdDir(),"ModulesVersion.tcl") .. " " .. path
   dbg.fini()
   return capture(cmd):trim()
end

local function findAssignedDefault(mpath, path, prefix)
   local dbg      = Dbg:dbg()
   local mt       = MT:mt()
   local localDir = true
   dbg.start("Spider:findAssignedDefault(",mpath,", ", path,", ",prefix,")")

   if (prefix == "") then
      dbg.fini()
      return nil
   end

   local default = abspath(path .. "/default", localDir)
   if (default == nil) then
      local vFn = abspath(pathJoin(path,".version"), localDir)
      if (isFile(vFn)) then
         local vf = versionFile(vFn)
         if (vf) then
            local f = pathJoin(path,vf)
            default = abspath(f,localDir)
            if (default == nil) then
               local fn = vf .. ".lua"
               local f  = pathJoin(path,fn)
               default  = abspath(f,localDir)
               dbg.print("(2) f: ",f," default: ", tostring(default), "\n")
            end
         end
      end
   end

   if (default) then
      default = abspath(default, localDir)
   end
   dbg.print("(4) default: \"",tostring(default),"\"\n")

   dbg.fini()
   return default
end


local function findDefault(mpath, path, prefix)
   local dbg      = Dbg:dbg()
   local mt       = MT:mt()
   local localDir = true
   dbg.start("Spider:findDefault(",mpath,", ", path,", ",prefix,")")

   if (prefix == "") then
      dbg.fini()
      return nil
   end

   local default = abspath(path .. "/default", localDir)
   if (default == nil) then
      local vFn = abspath(pathJoin(path,".version"), localDir)
      if (isFile(vFn)) then
         local vf = versionFile(vFn)
         if (vf) then
            local f = pathJoin(path,vf)
            default = abspath(f,localDir)
            if (default == nil) then
               local fn = vf .. ".lua"
               local f  = pathJoin(path,fn)
               default  = abspath(f,localDir)
               dbg.print("(2) f: ",f," default: ", tostring(default), "\n")
            end
         end
      end
   end
   if (default == nil and prefix ~= "") then
      local result, count = lastFileInDir(path)
      default = result
   end
   if (default) then
      default = abspath(default, localDir)
   end
   dbg.print("(4) default: \"",tostring(default),"\"\n")

   dbg.fini()
   return default
end

local function loadModuleFile(fn)
   local dbg    = Dbg:dbg()
   dbg.start("Spider:loadModuleFile(" .. fn .. ")")
   dbg.flush()

   systemG._MyFileName = fn
   local myType = extname(fn)
   local func
   local msg
   local status
   local whole
   if (myType == ".lua") then
      local f = io.open(fn)
      if (f) then
         whole = f:read("*all")
         f:close()
      end
   else
      local a     = {}
      a[#a + 1]	  = pathJoin(cmdDir(),"tcl2lua.tcl")
      a[#a + 1]	  = "-h"
      a[#a + 1]	  = fn
      local cmd   = concatTbl(a," ")
      whole       = capture(cmd)
   end

   if (whole) then
      status, msg = sandbox_run(whole)
   else
      status = nil
      msg    = "Empty or non-existent file"
   end
      
   if (not status) then 
      LmodWarning("Unable to load file: ",fn,": ",msg,"\n")
   end
   dbg.fini()
end


local function fullName(name)
   local n    = nil
   if (name == nil) then return n end
   local i,j  = name:find('.*/')
   i,j        = name:find('.*%.',j)
   if (i == nil) then
      n = name
   else
      local ext = name:sub(j,-1)
      if (ext == ".lua") then
         n = name:sub(1,j-1)
      else
         n = name
      end
   end
   return n
end


local function shortName(full)
   local i,j = full:find(".*/")
   return full:sub(1,(j or 0) - 1)
end

local function registerModuleT(full, sn, f, defaultModule)
   local t = {}

   t.path       = f
   t.name       = sn
   t.name_lower = sn:lower()
   t.full       = full
   t.full_lower = full:lower()
   t.epoch      = posix.stat(f, "mtime")
   t.default    = (f == defaultModule)
   t.children   = {}

   return t
end


function M.findModulesInDir(mpath, path, prefix, moduleT)
   local dbg  = Dbg:dbg()
   dbg.start("findModulesInDir(mpath=\"",tostring(mpath),"\", path=\"",tostring(path),
             "\", prefix=\"",tostring(prefix),"\")")
   
   local attr = lfs.attributes(path)
   if (not attr or  type(attr) ~= "table" or attr.mode ~= "directory" or
       not posix.access(path,"rx")) then
      dbg.print("Directory: ",path," is non-existant or is not readable\n")
      dbg.fini()
      return
   end
   
   local masterTbl       = masterTbl()
   local moduleStack     = masterTbl.moduleStack
   local iStack          = #moduleStack
   local mt              = MT:mt()
   local mnameT          = {}
   local dirA            = {}

   
   for file in lfs.dir(path) do
      if (file:sub(1,1) ~= "." and file ~= "CVS" and file:sub(-1,-1) ~= "~") then
         local f        = pathJoin(path,file)
         local readable = posix.access(f,"r")
         local full     = pathJoin(prefix, file):gsub("%.lua","")
         attr           = lfs.attributes(f)
         if (not attr or not readable) then
            -- do nothing for this case
         elseif (readable and attr.mode == 'file' and file ~= "default") then
            dbg.print("mnameT[",full,"].file: ",f,"\n")
            mnameT[full] = {file=f, mpath = mpath}
         elseif (attr.mode == "directory") then
            dbg.print("dirA: f:", f,"\n")
            dirA[#dirA + 1] = { fn = f, mname = full } 
         end
      end
   end

   if (#dirA > 0 or prefix == '') then
      for k,v in pairs(mnameT) do
         local full = k
         local sn   = k
         moduleT[v.file] = registerModuleT(full, sn, v.file, false)
         moduleStack[iStack] = {path= v.file, full = full, moduleT = moduleT, fn = v.file}
         dbg.print("Top of Stack: ",iStack, " Full: ", full, " file: ", v.file, "\n")
         
         local t = {fn = v.file, modFullName = k, modName = sn, default = 0, hash = 0}
         mt:add(t,"pending")
         loadModuleFile(v.file)
         mt:setStatus(t.modName,"active")
         dbg.print("Saving: Full: ", k, " Name: ", k, " file: ",v.file,"\n")
      end
      for i = 1, #dirA do
         M.findModulesInDir(mpath, dirA[i].fn, dirA[i].mname .. '/', moduleT)
      end
   else
      local defaultModule   = findAssignedDefault(mpath, path, prefix)
      for full,v in pairs(mnameT) do
         local sn   = shortName(full)
         moduleT[v.file] = registerModuleT(full, sn, v.file, defaultModule)
         moduleStack[iStack] = {path=v.file, full = full, moduleT = moduleT, fn = v.file}
         dbg.print("Top of Stack: ",iStack, " Full: ", full, " file: ", v.file, "\n")
         local t = {fn = v.file, modFullName = full, modName = sn, default = 0, hash = 0}
         mt:add(t,"pending")
         loadModuleFile(v.file)
         mt:setStatus(t.modName,"active")
         dbg.print("Saving: Full: ", full, " Name: ", sn, " file: ",v.file,"\n")
      end
   end
   dbg.fini()
end

function M.findAllModules(moduleDirA, moduleT)
   local dbg    = Dbg:dbg()
   dbg.start("findAllModules(",concatTbl(moduleDirA,", "),")")
   
   if (next(moduleT) == nil) then
      moduleT.version = Cversion
   end

   local masterTbl       = masterTbl()
   local moduleDirT      = {}
   masterTbl.moduleDirT  = moduleDirT
   masterTbl.moduleT     = moduleT
   masterTbl.moduleStack = {{}}
   local exit            = os.exit
   os.exit               = nothing
   local mt              = MT:mt()

   ------------------------------------------------------------
   -- Create a temporary Module Table to spider all modulefiles
   -- clear it when finished.
   mt.cloneMT()    

   for _,v in ipairs(moduleDirA) do
      local mpath = path_regularize(v)
      local attr  = lfs.attributes(mpath)
      if (attr and attr.mode == "directory" and
          posix.access(mpath,"rx") and moduleDirT[v] == nil) then
         moduleDirT[v] = 1
         moduleT[v]    = {}
         M.findModulesInDir(v, v, "", moduleT[v])
      end
   end
   os.exit     = exit

   ------------------------------------------------------------
   -- clear temporary MT
   mt.popMT()
   dbg.fini()
end

function M.buildSpiderDB(a, moduleT, dbT)
   local dbg = Dbg:dbg()
   dbg.start("Spider.buildSpiderDB({",concatTbl(a,","),"},moduleT, dbT)")

   dbg.print("moduleT.version: ",moduleT.version,"\n")

   local version = moduleT.version or 0

   if ( version < Cversion) then
      LmodError("old version moduleT\n")
   else
      dbg.print("Current version moduleT\n")
      for mpath, v in pairs(moduleT) do
         if (type(v) == "table") then
            dbg.print("mpath: ",mpath, "\n")
            M.singleSpiderDB(a,v, dbT)
         end
      end
   end
   dbg.fini()
end

function M.singleSpiderDB(a, moduleT, dbT)
   local dbg = Dbg:dbg()
   dbg.start("Spider.singleSpiderDB({",concatTbl(a,","),"},moduleT, dbT)")
   for path, value in pairs(moduleT) do
      dbg.print("path: ",path,"\n")
      local nameL = value.name_lower or value.name:lower()
      dbT[nameL]  = dbT[nameL] or {}
      local t     = dbT[nameL]

      for k, v in pairs(value) do
         if (t[path] == nil) then
            t[path] = {}
         end
         if (k ~= "children") then
            t[path][k] = v
         end
      end
      local parent = t[path].parent or {}
      local entry  = concatTbl(a,":")
      local found  = false
      for i = 1,#parent do
         if ( entry == parent[i]) then
            found = true
            break;
         end
      end
      if (not found) then
         parent[#parent+1] = entry
      end
      t[path].parent = parent
      if (next(value.children)) then
         a[#a+1] = t[path].full
         M.buildSpiderDB(a, value.children, dbT)
         a[#a]   = nil
      end
   end
   dbg.fini()
end

function M.searchSpiderDB(strA, a, moduleT, dbT)
   local dbg = Dbg:dbg()
   dbg.start("Spider:searchSpiderDB({",concatTbl(a,","),"},moduleT, dbT)")

   local version = moduleT.version or 0

   if (version < Cversion) then
      LmodError("old version moduleT\n")
   else
      dbg.print("Current version moduleT\n")
      for mpath, v in pairs(moduleT) do
         if (type(v) == "table") then
            dbg.print("mpath: ",mpath, "\n")
            M.singleSearchSpiderDB(strA, a, v, dbT)
         end
      end
   end
   dbg.fini()
end

function M.singleSearchSpiderDB(strA, a, moduleT, dbT)
   local dbg = Dbg:dbg()
   dbg.start("Spider.singleSearchSpiderDB()")

   for path, value in pairs(moduleT) do
      local nameL   = value.name_lower or ""
      local full    = value.full
      local whatisT = value.whatis or {}
      local whatisS = concatTbl(whatisT,"\n")

      if (dbT[nameL] == nil) then
         dbT[nameL] = {}
      end
      local t = dbT[nameL]

      local found = false
      for i = 1,#strA do
         local str = strA[i]:lower()
         if (nameL:find(str,1,true) or whatisS:find(str,1,true) or 
             nameL:find(str)        or whatisS:find(str)) then
            dbg.print("found txt in nameL: ",nameL,"\n")
            found = true
            break
         end
      end
      if (found) then
         for k, v in pairs(value) do
            if (t[path] == nil) then
               t[path] = {}
            end
            if (k ~= "children") then
               t[path][k] = v
            end
         end
         local parent = t[path].parent or {}
         parent[#parent+1] = concatTbl(a,":")
         t[path].parent = parent
      end
      if (next(value.children)) then
         a[#a+1] = full
         M.searchSpiderDB(strA, a, value.children, dbT)
         a[#a]   = nil
      end
   end
   dbg.fini()
end

function M.Level0(dbT)

   local a      = {}
   local ia     = 0
   local banner = border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "The following is a list of the modules currently available:\n"
   ia = ia+1; a[ia] = banner

   M.Level0Helper(dbT,a)

   return concatTbl(a,"")
end

function M.Level0Helper(dbT,a)
   local t          = {}
   local term_width = TermWidth() - 4

   for k,v in pairs(dbT) do
      for kk,vv in pairsByKeys(v) do
         if (t[k] == nil) then
            t[k] = { Description = vv.Description, Versions = { }, name = vv.name}
            t[k].Versions[vv.full] = 1
         else
            t[k].Versions[vv.full] = 1
         end
      end
   end

   local ia = #a

   for k,v in pairsByKeys(t) do
      local len = 0
      ia = ia + 1; a[ia] = "  " .. v.name .. ":"
      len = len + a[ia]:len()
      for kk,_ in pairsByKeys(v.Versions) do
         ia = ia + 1; a[ia] = " " .. kk; len = len + a[ia]:len() + 1
         if (len > term_width) then
            a[ia] = " ..."
            ia = ia + 1; a[ia] = ","
            break;
         end
         ia = ia + 1; a[ia] = ","
      end
      a[ia] = "\n"  -- overwrite the last comma
      if (v.Description) then
         ia = ia + 1; a[ia] = fillWords("    ",v.Description, term_width)
         ia = ia + 1; a[ia] = "\n"
      end
      ia = ia + 1; a[ia] = "\n"
   end
   local banner = border(0)
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "To learn more about a package enter:\n\n"
   ia = ia+1; a[ia] = "   $ module spider Foo\n\n"
   ia = ia+1; a[ia] = "where \"Foo\" is the name of a module\n\n"
   ia = ia+1; a[ia] = "To find detailed information about a particular package you\n"
   ia = ia+1; a[ia] = "must enter the version if there is more than one version:\n\n"
   ia = ia+1; a[ia] = "   $ module spider Foo/11.1\n"
   ia = ia+1; a[ia] = banner

end


local function countEntries(t, mname)
   local count   = 0
   local nameCnt = 0
   for k,v in pairs(t) do
      count = count + 1
      if (v.name == mname) then
         nameCnt = nameCnt + 1
      end
   end
   return count, nameCnt
end

function M.spiderSearch(dbT, mname, help)
   local dbg = Dbg:dbg()
   dbg.start("Spider:spiderSearch(dbT,\"",mname,"\")")
   local name   = shortName(mname)
   local nameL  = name:lower()
   local mnameL = mname:lower()
   dbg.print("mname: ", mname, " name: ", name, " nameL: ", nameL, "\n")
   local found  = false
   local a      = {}
   for k,v in pairs(dbT) do
      dbg.print("nameL: ", nameL, " k: ", k, "\n")
      local i,j = k:find(nameL)
      dbg.print("i,j: ", tostring(i)," ", tostring(j), "\n")
      if (k:find(nameL,1,true) or k:find(nameL)) then
         local s
         dbg.print("nameL: ",nameL," mnameL: ", mnameL, " k: ",k,"\n")
         if (nameL ~= mnameL ) then
            if (nameL == k) then
                s = M.Level2(v, mname)
                found = true
            end
         else
            s = M.Level1(dbT, k, help)
            found = true
         end
         if (s) then
            a[#a+1] = s
            s       = nil
         end
      end
   end
   if (not found) then
      io.stderr:write("Unable to find: \"",mname,"\"\n")
   end
   dbg.fini()
   return concatTbl(a,"")
end

function M.Level1(dbT, mname, help)
   local dbg = Dbg:dbg()
   dbg.start("Level1(dbT,\"",mname,"\",help)")
   local name       = shortName(mname)
   local nameL      = name:lower()
   local t          = dbT[nameL]
   local term_width = TermWidth() - 4
   dbg.print("mname: ", mname, ", name: ",name,"\n")

   if (t == nil) then
      dbg.fini()
      return ""
   end

   local cnt, nameCnt = countEntries(t, mname)
   dbg.print("Number of entries: ",cnt ," name count: ",nameCnt, "\n")
   if (cnt == 1 or nameCnt == 1) then
      local k = next(t)
      local v = M.Level2(t, mname, t[k].full)
      dbg.fini()
      return v
   end
      
   local banner = border(2)
   local VersionT = {}
   local exampleV = nil
   local key = nil
   local Description = nil
   for k, v in pairsByKeys(t) do
      if (VersionT[k] == nil) then
         key = v.name
         Description = v.Description 
         VersionT[v.full] = 1
         exampleV = v.full
      else
         VersionT[v.full] = 1
      end
   end

   local a  = {}
   local ia = 0

   ia = ia + 1; a[ia] = "\n"
   ia = ia + 1; a[ia] = banner
   ia = ia + 1; a[ia] = "  " .. key .. ":\n"
   ia = ia + 1; a[ia] = banner
   if (Description) then
      ia = ia + 1; a[ia] = "    Description:\n"
      ia = ia + 1; a[ia] = fillWords("      ",Description,term_width)
      ia = ia + 1; a[ia] = "\n\n"
      
   end
   ia = ia + 1; a[ia] = "     Versions:\n"
   for k, v in pairsByKeys(VersionT) do
      ia = ia + 1; a[ia] = "        " .. k .. "\n"
   end

   if (help) then
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = banner
      ia = ia + 1; a[ia] = "  To find detailed information about "
      ia = ia + 1; a[ia] = key
      ia = ia + 1; a[ia] = " please enter the full name.\n  For example:\n\n"
      ia = ia + 1; a[ia] = "     $ module spider "
      ia = ia + 1; a[ia] = exampleV
      ia = ia + 1; a[ia] = "\n"
      ia = ia + 1; a[ia] = banner
   end

   dbg.fini()
   return concatTbl(a,"")
   
end

function M.Level2(t, mname, full)
   local dbg = Dbg:dbg()
   dbg.start("Level2(t,\"",mname,"\", \"",tostring(full),"\")")
   local a  = {}
   local ia = 0
   local b  = {}
   local c  = {}
   local titleIdx = 0
   
   local propDisplayT = getPropT()
   
   local term_width = TermWidth() - 4
   local tt = nil
   local banner = border(2)
   local availT = {
      "\n    This module can be loaded directly: module load " .. mname .. "\n",
      "\n    This module can only be loaded through the following modules:\n",
      "\n    This module can be loaded directly: module load " .. mname .. "\n" ..
      "\n    Additional variants of this module can also be loaded after the loading the following modules:\n",
   }
   local haveCore = 0
   local haveHier = 0
   local mnameL   = mname:lower()
      
   full = full or ""
   local fullL = full:lower()
   for k,v in pairs(t) do
      dbg.print("vv.full: ",tostring(v.full)," mname: ",mname," k: ",k," full:", tostring(full),"\n")
      local vfullL = v.full_lower or v.full:lower()
      if (vfullL == mnameL or vfullL == fullL) then
         if (tt == nil) then
            tt = v
            ia = ia + 1; a[ia] = "\n"
            ia = ia + 1; a[ia] = banner
            ia = ia + 1; a[ia] = "  " .. tt.name .. ": "
            ia = ia + 1; a[ia] = tt.full 
            ia = ia + 1; a[ia] = "\n"
            ia = ia + 1; a[ia] = banner
            if (tt.Description) then
               ia = ia + 1; a[ia] = "    Description:\n"
               ia = ia + 1; a[ia] = fillWords("      ",tt.Description, term_width)
               ia = ia + 1; a[ia] = "\n"
            end
            if (tt.propT ) then
               ia = ia + 1; a[ia] = "    Properties:\n"
               for kk, vv in pairs(propDisplayT) do
                  if (tt.propT[kk]) then
                     for kkk in pairs(tt.propT[kk]) do
                        if (vv.displayT[kkk]) then
                           ia = ia + 1; a[ia] = fillWords("      ",vv.displayT[kkk].doc, term_width)
                        end
                     end
                  end
               end
               ia = ia + 1; a[ia] = "\n"
            end
            ia = ia + 1; a[ia] = "Avail Title goes here.  This should never be seen\n"
            titleIdx = ia
         end
         if (#v.parent == 1 and v.parent[1] == "default") then
            haveCore = 1
         else
            b[#b+1] = "      "
            haveHier = 2
         end

         for i = 1, #v.parent do
            local entry = v.parent[i]
            for s in entry:split(":") do
               if (s ~= "default") then
                  b[#b+1] = s
                  b[#b+1] = ', '
               end
            end
            b[#b] = "\n      "
         end
         if (#b > 0) then
            b[#b] = "\n" -- Remove final comma add newline instead
            c[#c+1] = concatTbl(b,"")
            b = {}
         end
      end
   end
   a[titleIdx] = availT[haveCore+haveHier]
   if (#c > 0) then

      -- remove any duplicates
      local s = concatTbl(c,"")
      local d = {}
      for k in s:split("\n") do
         d[k] = 1
      end
      c = {}
      for k in pairs(d) do
         c[#c+1] = k
      end
      table.sort(c)
      c[#c+1] = " "
      ia = ia + 1; a[ia] = concatTbl(c,"\n")
   end

   if (tt and tt.help ~= nil) then
      ia = ia + 1; a[ia] = "\n    Help:\n"
      for s in tt.help:split("\n") do
         ia = ia + 1; a[ia] = "      "
         ia = ia + 1; a[ia] = s
         ia = ia + 1; a[ia] = "\n"
      end
   end

   if (tt == nil) then
      LmodSystemError("Unable to find: \"",mname,"\"")
   end

   dbg.fini()
   return concatTbl(a,"")
end

function M.listModules(moduleT, tbl)
   if (moduleT.version == nil) then
      M.listModulesHelper(moduleT, tbl)
   else
      for mpath, v in pairs(moduleT) do
         if (type(v) == "table") then
            M.listModulesHelper(v, tbl)
         end
      end
   end
end



function M.listModulesHelper(moduleT, tbl)
   for kk,vv in pairs(moduleT) do
      tbl[#tbl+1] = vv.path
      if (next(vv.children)) then
         for k, v in pairs(vv.children) do
            if (type(v) == "table") then
               M.listModulesHelper(v, tbl)
            end
         end
      end
   end
end

function M.dictModules(t,tbl)
   for kk,vv in pairs(t) do
      kk      = kk:gsub(".lua$","")
      tbl[kk] = 0
      if (next(vv.children)) then
         for k, v in pairs(vv.children) do
            if (type(v) == "table") then
               M.dictModules(v, tbl)
            end
         end
      end
   end
end

return M
