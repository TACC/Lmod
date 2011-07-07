-- $Id$ --
require("border")
require("strict")
require("string_split")
require("fileOps")
require("fillWords")
require("lfs")
require("Dbg")
require("posix")
require("capture")
require("pairsByKeys")


local Dbg         = Dbg
local LmodError   = LmodError
local assert      = assert
local border      = border
local capture     = capture
local cmdDir      = cmdDir
local concatTbl   = table.concat
local extname     = extname
local fillWords   = fillWords
local io          = io
local ipairs      = ipairs
local lfs         = lfs
local loadfile    = loadfile
local loadstring  = loadstring
local next        = next
local pairs       = pairs
local pairsByKeys = pairsByKeys 
local pathJoin    = pathJoin
local posix       = posix
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

function setenv(name, value)
end

function unsetenv(name, value)
end

function set_alias(name, value)
end

function unset_alias(name, value)
end


function remove_path(name, value)
end

function load(...)
end

function family(...)
end

function firstInPath(...)
end

function unload(...)
end

function prereq(...)
end

function conflict(...)
end



function Spider_help(s)
   local masterTbl   = masterTbl()
   local moduleDirT  = masterTbl.moduleDirT
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   local path        = moduleStack[iStack].path
   local moduleT     = moduleStack[iStack].moduleT
   moduleT[path].help = s
end

KeyT = {Description=1, Name=1, URL=1, Version=1}

function Spider_whatis(s)
   local masterTbl   = masterTbl()
   local moduleDirT  = masterTbl.moduleDirT
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

help   = Spider_help
whatis = Spider_whatis

_MyFileName  = ""

function myFileName()
   return _MyFileName
end

function hierarchyA(package, levels)
   package = package:gsub("%.lua$","")
   local n = myFileName():gsub("%.lua$","")
   n       = n:gsub(package .. "$","")
   n       = n:gsub("^/","")
   n       = n:gsub("/$","")
   local a = {}

   for dir in n:split("/") do
      a[#a + 1] = dir
   end

   local b = {}
   local j = #a
   
   for i = 1, levels do
      b[#b + 1 ] = pathJoin(a[j-1],a[j])
      j = j - 2
   end

   return b
end

function regularize(value)
   value = value:gsub("//","/")
   value = value:gsub("/$","")
   return value
end

local regularize = regularize

function Spider_prepend_path(name, value)
   if (name == "MODULEPATH") then
      local dbg = Dbg:dbg()
      dbg.start("prepend_path(MODULEPATH=\"",name,"\", value=\"",value,"\")")
      processNewModulePATH(value)
      dbg.fini()
   end
end

prepend_path = Spider_prepend_path

function Spider_append_path(name, value)
   if (name == "MODULEPATH") then
      local dbg = Dbg:dbg()
      dbg.start("append_path(MODULEPATH=\"",name,"\", value=\"",value,"\")")
      processNewModulePATH(value)
      dbg.fini()
   end
end

append_path = Spider_append_path

function processNewModulePATH(value)
   local dbg = Dbg:dbg()
   dbg.start("processNewModulePATH(value=\"",value,"\")")

   local masterTbl   = masterTbl()
   local moduleDirT  = masterTbl.moduleDirT
   local moduleStack = masterTbl.moduleStack 
   local iStack      = #moduleStack
   if (masterTbl.no_recursion) then
      dbg.fini()
      return
   end

   for v in value:split(":") do
      v = regularize(v)
      dbg.print("v: ", v,"\n")
      if (moduleDirT[v] == nil) then
         moduleDirT[v] = 1
         local path    = moduleStack[iStack].path
         local full    = moduleStack[iStack].full
         local moduleT = moduleStack[iStack].moduleT
         iStack        = iStack+1
         moduleStack[iStack] = {path = path, full = full, moduleT = moduleT[path].children}
         dbg.print("Top of Stack: ",iStack, " Full: ", full, " file: ", path, "\n")
         Spider.findModulesInDir(v,"",moduleT[path].children)
         moduleStack[iStack] = nil
      end
   end

   dbg.fini()
end

------------------------------------------------------------
module("Spider")
------------------------------------------------------------

local function loadModuleFile(fn)
   local dbg    = Dbg:dbg()
   dbg.start("loadModuleFile")
   dbg.flush()

   systemG._MyFileName = fn
   local myType = extname(fn)
   if (myType == ".lua") then
      assert(loadfile(fn))()
   else
      local a     = {}
      a[#a + 1]	  = pathJoin(cmdDir(),"tcl2lua.tcl")
      a[#a + 1]	  = "-h"
      a[#a + 1]	  = fn
      local cmd   = concatTbl(a," ")
      local s     = capture(cmd)
      assert(loadstring(s))()
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
      ext = name:sub(j,-1)
      if (ext == ".lua") then
         n = name:sub(1,j-1)
      else
         n = name
      end
   end
   return n
end


local function extractName(full)
   local i, j
   local n = nil
   if (full == nil) then return n end

   -- extract to first directory name
   i, j, n = full:find('([^/]+)/') 
   if (n) then
      return n
   end

   -- Remove any extension
   i, j, n   = full:find('(.*)%.')
   if (n == nil) then
      n = full
   end
   return n
end

function findModulesInDir(path, prefix, moduleT)
   local dbg  = Dbg:dbg()
   dbg.start("findModulesInDir(path=\"",path,"\", prefix=\"",prefix,"\")")

   local attr = lfs.attributes(path)
   if (not attr) then
      dbg.fini()
      return
   end

   assert(type(attr) == "table")
   if ( attr.mode ~= "directory" or not posix.access(path,"rx")) then
      dbg.fini()
      return
   end
   
   local masterTbl       = masterTbl()
   local moduleStack     = masterTbl.moduleStack
   local iStack          = #moduleStack
   
   for file in lfs.dir(path) do
      if (file:sub(1,1) ~= "." and not file ~= "CVS" and file:sub(-1,-1) ~= "~") then
         local f = pathJoin(path,file)
         local readable = posix.access(f,"r")
         attr = lfs.symlinkattributes(f) or {}
         dbg.print("file: ",file," f: ",f," attr.mode: ", attr.mode,"\n")
	 if (readable and (attr.mode == 'file' or attr.mode == 'link') and (file ~= "default")) then
            if (moduleT[f] == nil) then
               local full = fullName(pathJoin(prefix,file))
               local name = extractName(full)
               moduleT[f] = { path = f, name = name, full = full, children = {} }
               moduleStack[iStack] = {path=f, full = full, moduleT = moduleT}
               dbg.print("Top of Stack: ",iStack, " Full: ", full, " file: ", f, "\n")
               loadModuleFile(f)
               dbg.print("Saving: Full: ", full, " Name: ", name, " file: ",f,"\n")
            end
         elseif (attr.mode == 'directory') then
            findModulesInDir(f, prefix .. file..'/',moduleT)
	 end
      end
   end
   dbg.fini()
end

function findAllModules(moduleDirA, moduleT)
   local dbg    = Dbg:dbg()
   dbg.start("findAllModules(",concatTbl(moduleDirA,", "),")")
   
   local masterTbl       = masterTbl()
   local moduleDirT      = {}
   masterTbl.moduleDirT  = moduleDirT
   masterTbl.moduleT     = moduleT
   masterTbl.moduleStack = {{}}
   LmodError             = nothing
   os.exit               = nothing

   for _,v in ipairs(moduleDirA) do
      v             = regularize(v)
      if (moduleDirT[v] == nil) then
         moduleDirT[v] = 1
         findModulesInDir(v, "", moduleT)
      end
   end
   dbg.fini()
end

function buildSpiderDB(a, moduleT, dbT)
   for path, value in pairs(moduleT) do
      local name = value.name
      if (dbT[name] == nil) then
         dbT[name] = {}
      end
      local t = dbT[name]

      for k, v in pairs(value) do
         if (t[path] == nil) then
            t[path] = {}
         end
         if (k ~= "children") then
            t[path][k] = v
         end
      end
      t[path].parent = concatTbl(a,":")
      if (next(value.children)) then
         a[#a+1] = t[path].full
         buildSpiderDB(a, value.children, dbT)
         a[#a]   = nil
      end
   end
end

function searchSpiderDB(strA, a, moduleT, dbT)
   for path, value in pairs(moduleT) do
      local name = value.name
      local full = value.full
      local description = value.Description or ""
      if (dbT[name] == nil) then
         dbT[name] = {}
      end
      local t = dbT[name]

      local found = false
      for i = 1,#strA do
         local str = strA[i]
         if (name:find(str) or description:find(str)) then
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
         t[path].parent = concatTbl(a,":")
      end
      if (next(value.children)) then
         a[#a+1] = full
         searchSpiderDB(strA, a, value.children, dbT)
         a[#a]   = nil
      end
   end
end

function Level0(dbT)

   local a      = {}
   local ia     = 0
   local banner = border(0)


   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "The following is a list of the modules currently available:\n"
   ia = ia+1; a[ia] = banner

   Level0Helper(dbT,a)

   return concatTbl(a,"")
end

function Level0Helper(dbT,a)
   local t          = {}
   local term_width = tonumber(capture("tput cols") or "80") - 4

   for k,v in pairs(dbT) do
      for kk,vv in pairsByKeys(v) do
         if (t[k] == nil) then
            t[k] = { Description = vv.Description, Versions = { }}
            t[k].Versions[vv.full] = 1
         else
            t[k].Versions[vv.full] = 1
         end
      end
   end

   ia = #a

   for k,v in pairsByKeys(t) do
      local len = 0
      ia = ia + 1; a[ia] = "  " .. k .. ":"
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


local function countEntries(t)
   local count = 0
   for k,v in pairs(t) do
      count = count + 1
      if (count > 1) then
         break
      end
   end
   return count
end

function spiderSearch(dbT, mname)
   local dbg = Dbg:dbg()
   dbg.start("spiderSearch(dbT,\"",mname,"\")")
   local found = false
   for k,v in pairs(dbT) do
      if (k:find(mname)) then
         local s = Level1(dbT,k, false)
         io.stderr:write(s,"\n")
         found = true
      end
   end
   if (not found) then
      io.stderr:write("Unable to find: \"",mname,"\"\n")
   end
   dbg.fini()
end

function Level1(dbT, mname, help)
   local dbg = Dbg:dbg()
   dbg.start("Level1(dbT,\"",mname,"\")")
   local name = extractName(mname)
   local t    = dbT[name]
   local term_width = tonumber(capture("tput cols") or "80") - 4
   if (t == nil) then
      spiderSearch(dbT,mname)
      return ""
   end

   if (countEntries(t) == 1) then
      k = next(t)
      mname = t[k].full
      return Level2(t, t[k].full)
   end
      
   if (name ~= mname) then
      return Level2(t, mname)
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

function Level2(t, mname)
   local a  = {}
   local ia = 0
   
   local term_width = tonumber(capture("tput cols") or "80") - 4
   local tt = nil
   banner = border(2)

   for k,v in pairs(t) do
      if (v.full == mname) then
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
            
            ia = ia + 1; a[ia] = "\n    This module can be loaded through the following modules:\n"
         end
         if (v.parent ~= "default") then
            ia = ia + 1; a[ia] = "      "
         end
         for s in v.parent:split(":") do
            if (s ~= "default") then
               ia = ia + 1; a[ia] = s
               ia = ia + 1; a[ia] = ', '
            end
         end
         a[ia] = "\n"  -- Remove final comma
      end
   end

   tt = tt or {}

   if (tt.help ~= nil) then
      ia = ia + 1; a[ia] = "\n    Help:\n"
      for s in tt.help:split("\n") do
         ia = ia + 1; a[ia] = "      "
         ia = ia + 1; a[ia] = s
         ia = ia + 1; a[ia] = "\n"
      end
   end

   if (tt == nil) then
      LmodError("Unable to find: \"",mname,"\"")
   end

   return concatTbl(a,"")
end

function listModules(t,tbl)
   for k,v in pairs(t) do
      tbl[#tbl+1] = v.path
      if (next(v.children)) then
         listModules(v.children,tbl)
      end
   end
end

function dictModules(t,tbl)
   for k,v in pairs(t) do
      tbl[k] = 0
      if (next(v.children)) then
         dictModules(v.children,tbl)
      end
   end
end
