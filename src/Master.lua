require("strict")
local InheritModule      = InheritModule
local LmodError          = LmodError
local Load               = Load
local LoadTbl            = LoadTbl
local ModulePath         = ModulePath
local UnLoad             = UnLoad
local UnLoadSys          = UnLoadSys
local UnLoadTbl          = UnLoadTbl
local assert             = assert
local capture            = capture
local cmdDir             = cmdDir
local concatTbl          = table.concat
local firstInPath        = firstInPath
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
local unloadsys          = unloadsys
local expert             = expert
local removeEntry        = table.remove


require("fileOps")
require("string_trim")
require("fillWords")

ModuleName=""
local ColumnTable  = require('ColumnTable')
local Dbg          = require("Dbg")
local InheritTmpl  = require("InheritTmpl")
local M            = {}
local MT           = MT
local ModuleStack  = require("ModuleStack")
local abspath      = abspath
local extname      = extname
--local fillWords    = 
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
   o.reloadT    = {}
   return o
end

function M.formModName(moduleName)
   local idx = moduleName:find('/') or 0
   idx = idx - 1
   local modName = moduleName:sub(1,idx)
   return modName
end

local function lastFileInDir(fn)
   local dbg      = Dbg:dbg()
   dbg.start("lastFileInDir(",fn,")")
   local lastKey   = ''
   local lastValue = ''
   local result    = nil
   local fullName  = nil
   local count     = 0
   
   local attr = lfs.attributes(fn)
   if (attr and attr.mode == 'directory' and posix.access(fn,"x")) then
      for file in lfs.dir(fn) do
         local f = pathJoin(fn, file)
         dbg.print("fn: ",fn," file: ",file," f: ",f,"\n")
         attr = lfs.attributes(f)
         local readable = posix.access(f,"r")
         if (readable and file:sub(1,1) ~= "." and attr.mode == 'file' and file:sub(-1,-1) ~= '~') then
            count = count + 1
            local key = f:gsub(".lua$","")
            if (key > lastKey) then
               lastKey   = key
               lastValue = f
            end
         end
      end
      if (lastKey ~= "") then
         result     = lastValue
      end
   end
   dbg.print("result: ",result,"\n")
   dbg.fini()
   return result, count
end


local searchTbl = {'.lua','', '/default', '/.version'}


local function find_module_file(moduleName)
   local dbg      = Dbg:dbg()
   dbg.start("find_module_file(",moduleName,")")

   local t        = { fn = nil, modFullName = nil, modName = nil, default = 0, hash = 0}
   local mt       = MT:mt()
   local fullName = moduleName
   local idx      = moduleName:find('/')
   local localDir = true
   local key, extra, modName
   if (idx == nil) then
      key   = moduleName
      extra = ''
   else
      key   = moduleName:sub(1,idx-1)
      extra = moduleName:sub(idx)
   end

   local pathA = mt:locationTbl(key)

   if (pathA == nil or #pathA == 0) then
      dbg.fini()
      return t
   end
   local fn, result

   for ii, vv in ipairs(pathA) do
      t.default = 0
      local mpath  = vv.mpath
      fn           = pathJoin(vv.file, extra)
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
            result    = abspath(result, localDir)
            t.default = 1
         elseif (found and v == '/.version' and ii == 1) then
            local vf = M.versionFile(result)
            if (vf) then
               t         = find_module_file(pathJoin(key,vf))
               t.default = 1
               result    = t.fn
            end
         end
         if (found) then
            local i,j = result:find(fn,1,true)
            if (i and j) then
               extra = result:sub(1,i-1) .. result:sub(j+1)
            else
               extra = result
            end
            extra    = extra:gsub(".lua$","")
            fullName = moduleName .. extra
            break
         end
      end

      dbg.print("found:", tostring(found), " fn: ",fn,"\n")

      ------------------------------------------------------------
      --  Search for "last" file in directory
      ------------------------------------------------------------

      if (not found and ii == 1) then
         t.default  = 1
         result = lastFileInDir(fn)
         if (result) then
            found = true
            local i, j = result:find(mpath,1,true)
            fullName   = result:sub(j+2)
            fullName   = fullName:gsub(".lua$","")
         end
      end
      if (found) then break end
   end

   modName = M.formModName(fullName)

   t.fn          = result
   t.modFullName = fullName
   t.modName     = modName
   dbg.print("modName: ",modName," fn: ", result," modFullName: ", fullName," default: ",tostring(t.default),"\n")
   dbg.fini()
   return t
end

local function loadModuleFile(t)
   local dbg    = Dbg:dbg()
   dbg.start("loadModuleFile")
   dbg.print("t.file: ",t.file,"\n")
   dbg.flush()

   systemG._MyFileName = t.file

   local myType = extname(t.file)
   if (myType == ".lua") then
      if (isFile(t.file)) then
         assert(loadfile(t.file))()
      end
   else
      local mt	  = MT:mt()
      local opt   = "-l \"" .. mt:loadActiveList() .. "\""
      if (t.help) then
         opt      = t.help
      end
      local a     = {}
      a[#a + 1]	  = pathJoin(cmdDir(),"tcl2lua.tcl")
      a[#a + 1]	  = opt
      a[#a + 1]	  = t.file
      local cmd   = concatTbl(a," ")
      local s     = capture(cmd)
      assert(loadstring(s))()
   end
   dbg.fini()
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
   local prevT  = { load = systemG.load, unload = systemG.unload}
   for _,v in ipairs{...} do
      a[#a+1] = v
   end
   dbg.start("Master:unload(",concatTbl(a,", "),")")

   for k in pairs(UnLoadTbl) do
      if ( prevT[k] == nil and systemG[k] ~= UnLoadTbl[k]) then
         prevT[k]   = systemG[k]
      end
      systemG[k] = UnLoadTbl[k]
   end

   a = {}

   for _, moduleName in ipairs{...} do
      if (mt:haveModuleAnyActive(moduleName)) then
         local f              = mt:fileNameActive(moduleName)
         local fullModuleName = mt:modFullNameActive(moduleName)
         dbg.print("Master:unload: \"",fullModuleName,"\" from f: ",f,"\n")
         mt:beginOP()
         mt:removeActive(moduleName)
         mStack:push(fullModuleName)
	 loadModuleFile{file=f}
         mStack:pop()
         mt:endOP()
         a[#a + 1] = true
      else
         a[#a + 1] = false
      end
   end
   if (M.safeToUpdate() and mt:safeToCheckZombies()) then
      M.reloadAll()
   end
   for k in pairs(prevT) do
      systemG[k] = prevT[k]
   end
   dbg.fini()
   return a
end

function M.versionFile(path)
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
   return capture(cmd):trim()
end

local function access_find_module_file(moduleName)
   local mt = MT:mt()
   if (mt:haveModuleTotal(moduleName)) then
      local full = mt:modFullNameTotal(moduleName) 
      return mt:fileNameTotal(moduleName), full or ""
   end
   local fn   = nil
   local full = nil
   if (isFile(moduleName)) then
      fn = moduleName
   else
      fn = moduleName .. ".lua"
      if (not isFile(fn)) then
         local t = find_module_file(moduleName)
         full    = t.modFullName
         fn      = t.fn
      end
   end
   return fn, full
end

function M.access(self, ...)
   local dbg    = Dbg:dbg()
   local mt     = MT:mt()
   local prtHdr = systemG.prtHdr
   local help   = nil
   local a      = {}
   local result, t
   io.stderr:write("\n")
   if (systemG.help ~= dbg.quiet) then help = "-h" end
   for _, moduleName in ipairs{...} do
      local fn, full   = access_find_module_file(moduleName)
      --io.stderr:write("full: ",full,"\n")
      systemG.ModuleFn   = fn
      systemG.ModuleName = full
      if (fn) then
         prtHdr()
	 loadModuleFile{file=fn,help=help}
         io.stderr:write("\n")
      else
         a[#a+1] = moduleName
      end
   end

   if (#a > 0) then
      io.stderr:write("Failed to find the following module(s):  \"",concatTbl(a,"\", \""),"\" in your MODULEPATH\n")
   end
end


function M.load(...)
   local mStack = ModuleStack:moduleStack()
   local mt    = MT:mt()
   local dbg   = Dbg:dbg()
   local a     = {}

   dbg.start("Master:load(",concatTbl({...},", "),")")

   for k in pairs(LoadTbl) do
      systemG[k] = LoadTbl[k]
   end

   a   = {}
   for _,moduleName in ipairs{...} do
      local loaded  = false
      local t	    = find_module_file(moduleName)
      local fn      = t.fn
      if (mt:haveModuleAnyActive(moduleName) and fn  ~= mt:fileNameActive(moduleName)) then
         dbg.print("Master:load reload module: \"",moduleName,"\" as it is already loaded\n")
         UnLoad(moduleName)
         local aa = Load(moduleName)
         loaded = aa[1]
      elseif (fn) then
         dbg.print("Master:loading: \"",moduleName,"\" from f: \"",fn,"\"\n")
	 mt:beginOP()
         mStack:push(t.modFullName)
	 loadModuleFile{file=fn}
         t.mType = mStack:moduleType()
         mStack:pop()
	 mt:endOP()
         mt:addActive(t)
         mt:addTotal(t)
         loaded = true
      elseif (not mt:haveModuleTotal(moduleName)) then
         dbg.warning("Failed to load: ",moduleName,"\n")
      end
      a[#a+1] = loaded
   end
   if (M.safeToUpdate() and mt:safeToCheckZombies()) then
      dbg.print("Master:load calling reloadAll()\n")
      M.reloadAll()
   end
   dbg.fini()
   return a
end

function M.fakeload(...)
   local a   = {}
   local mt  = MT:mt()
   local dbg = Dbg:dbg()
   dbg.start("Master:fakeload(",concatTbl({...},", "),")")

   for _, moduleName in ipairs{...} do
      local loaded = false
      local t      = find_module_file(moduleName)
      local fn     = t.fn
      if (fn) then
         t.mType = "m"
         mt:addActive(t)
         mt:addTotal(t)
         loaded = true
      end
      a[#a+1] = loaded
   end
end         


function M.reloadAll()
   local mt   = MT:mt()
   local dbg  = Dbg:dbg()
   dbg.start("Master:reloadAll()")

   local same = true
   local a    = mt:listTotal()
   for _, v in ipairs(a) do
      if (mt:haveModuleActive(v)) then
         local _, fullName = mt:modFullNameTotal(v)
         local t           = find_module_file(fullName)
         local fn          = mt:fileNameTotal(v)
         if (t.fn ~= fn) then
            dbg.print("Master:reloadAll t.fn: \"",t.fn or "nil","\"",
                      " mt:fileNameTotal(v): \"",fn or "nil","\"\n")
            dbg.print("Master:reloadAll Unloading module: \"",v,"\"\n")
            UnLoadSys(v)
            dbg.print("Master:reloadAll Loading module: \"",fullName or "nil","\"\n")
            local loadA = Load(fullName)
            dbg.print("Master:reloadAll: fn: \"",fn or "nil",
                      "\" mt:fileNameTotal(v): \"", mt:fileNameTotal(v) or "nil","\"\n")
            if (loadA[1] and fn ~= mt:fileNameTotal(v)) then
               same = false
               s_master.reloadT[fullName] = 1
               dbg.print("Master:reloadAll module: ",fullName," marked as reloaded\n")
            end
         end
      else
         local fn          = mt:fileNameTotal(v)
         local _, fullName = mt:modFullNameTotal(v)
         dbg.print("Master:reloadAll Loading module: \"",fullName or "nil","\"\n")
         local aa = Load(fullName)
         if (aa[1] and fn ~= mt:fileNameTotal(v)) then
            s_master.reloadT[fullName] = 1
            dbg.print("Master:reloadAll module: ",fullName," marked as reloaded\n")
         end
         same = not aa[1]
      end
   end
   dbg.fini()
   return same
end

function M.reloadClear(self,name)
   local dbg  = Dbg:dbg()
   dbg.start("Master:reloadClear()")
   dbg.print("removing \"",name,"\" from reload table\n")
   self.reloadT[name] = nil
   dbg.fini()
end



function M.inheritModule()
   local dbg     = Dbg:dbg()
   dbg.start("Master:inherit()")

   local mStack  = ModuleStack:moduleStack()
   local myFn    = myFileName()
   local mName   = mStack:moduleName()
   local inhTmpl = InheritTmpl:inheritTmpl()

   dbg.print("myFn:  ", myFn,"\n")
   dbg.print("mName: ", mName,"\n")

   
   local t = inhTmpl.find_module_file(mName,myFn)
   dbg.print("fn: ", tostring(t.fn),"\n")
   if (t.fn == nil) then
      LmodError("Failed to inherit: ",mName,"\n")
   else
      loadModuleFile{file=t.fn}
   end
   dbg.fini()
end

local function dirname(f)
   local result = './'
   for w in f:gmatch('.*/') do
      result = w
      break
   end
   return result
end


function M.prtReloadT(self)
   if (next(self.reloadT) == nil or expert()) then return end
   local t = self.reloadT
   local a = {}
   local i = 0
   for name in pairs(t) do
      i    = i + 1
      a[i] = "  " .. i .. ") " .. name
   end
   if (i > 0) then
      io.stderr:write("Due to MODULEPATH changes the following modules have been reloaded:\n")
      local ct = ColumnTable:new{tbl=a,prt=prtErr}
      ct:print_tbl()
   end
end

local function prtDirName(width,path)
   local len     = path:len()
   local lcount  = floor((width - (len + 2))/2)
   local rcount  = width - lcount - len - 2
   io.stderr:write("\n",string.rep("-",lcount)," ",path,
                   " ", string.rep("-",rcount),"\n")
end


local function findDefault(mpath, path, prefix)
   local dbg      = Dbg:dbg()
   local mt       = MT:mt()
   local localDir = true
   dbg.start("Master.findDefault(",mpath,", ", path,", ",prefix,")")

   local i,j = path:find(mpath)
   --dbg.print("i: ",tostring(i)," j: ", tostring(j)," path:len(): ",path:len(), "\n")
   if (i and j + 1 < path:len()) then
      local mname = path:sub(j+2)
      i = mname:find("/")
      if (i) then
         mname = mname:sub(1,i-1)
      end
      local pathA  = mt:locationTbl(mname)
      local mpath2 = pathA[1].mpath
      --dbg.print("mname: ", mname, " mpath: ", mpath, " mpath2: ",mpath2,"\n")

      if (mpath ~= mpath2) then
         dbg.print("(1)default: \"nil\"\n")
         dbg.fini()
         return nil
      end
   end

   --dbg.print("abspath(\"", tostring(path .. "/default"), ", \"",tostring(localDir),"\")\n")
   local default = abspath(path .. "/default", localDir)
   --dbg.print("(2) default: ", tostring(default), "\n")
   if (default == nil) then
      local vFn = abspath(pathJoin(path,".version"), localDir)
      if (isFile(vFn)) then
         local vf = M.versionFile(vFn)
         if (vf) then
            local f = pathJoin(path,vf)
            default = abspath(f,localDir)
            --dbg.print("(1) f: ",f," default: ", tostring(default), "\n")
            if (default == nil) then
               local fn = vf .. ".lua"
               local f  = pathJoin(path,fn)
               default  = abspath(f,localDir)
               dbg.print("(2) f: ",f," default: ", tostring(default), "\n")
            end
            --dbg.print("(3) default: ", tostring(default), "\n")
         end
      end
   end
   if (default == nil and prefix ~= "") then
      local result, count = lastFileInDir(path)
      if (count > 1) then
         default = result
      end
   end
   if (default) then
      default = abspath(default, localDir)
   end
   dbg.print("(4) default: \"",tostring(default),"\"\n")

   dbg.fini()
   return default
end


local function availDir(searchA, mpath, path, prefix, a)
   local dbg    = Dbg:dbg()
   dbg.start("Master.availDir(searchA=(",concatTbl(searchA,", "),"), mpath=\"",mpath,"\", ",
             "path=\"",path,"\", prefix=\"",prefix,"\", a=(",concatTbl(a,", "),") )")
   local sCount = #searchA
   local attr = lfs.attributes(path)
   if (not attr) then
      dbg.fini()
      return
   end
   assert(type(attr) == "table")
   if ( attr.mode ~= "directory" or not posix.access(path,"x")) then
      dbg.fini()
      return
   end


   -- Check for default first
   local defaultModuleName = findDefault(mpath, path, prefix)
   local localDir          = true
   dbg.print("defaultModuleName: \"",tostring(defaultModuleName),"\"\n")

   for file in lfs.dir(path) do
      if (file:sub(1,1) ~= "." and not file ~= "CVS" and file:sub(-1,-1) ~= '~') then
         local f = pathJoin(path, file)
	 attr = lfs.symlinkattributes(f) or {}
         dbg.print("file: ",file," f: ",f," attr.mode: ", attr.mode,"\n")
         local readable = posix.access(f,"r")
	 if (readable and (attr.mode == 'file' or attr.mode == 'link') and (file ~= "default")) then
            local n = prefix .. file
            n = n:gsub(".lua","")
            local nn = n
            if (defaultModuleName == abspath(f,localDir)) then
               n = n .. ' (default)'
            end
            if (sCount == 0) then
               a[#a + 1 ] = '  ' .. n .. '  '
            else
               for _,v in ipairs(searchA) do
                  if (nn:find(v)) then
                     a[#a + 1 ] = '  ' .. n .. '  '
                     break
                  end
               end
            end
         elseif (attr.mode == 'directory') then
            availDir(searchA,mpath, f,prefix .. file..'/',a)
	 end
      end
   end
   dbg.fini()
end

function M.avail(searchA)
   local dbg    = Dbg:dbg()
   dbg.start("Master.avail(",concatTbl(searchA,", "),")")
   local mpathA = MT:mt():module_pathA()
   local width  = 80
   if (getenv("TERM")) then
      width  = tonumber(capture("tput cols"))
   end
   for _,path in ipairs(mpathA) do
      local a = {}
      availDir(searchA, path, path, '', a)
      if (next(a)) then
         prtDirName(width, path)
         sort(a)
         local ct  = ColumnTable:new{tbl=a,prt=prtErr}
         ct:print_tbl()
      end
   end
   local a = fillWords("","Use \"module spider\" to find all possible modules.",width)
   local b = fillWords("","Use \"module keyword key1 key2 ...\" to search for all possible modules matching any of the \"keys\".",width)
   io.stderr:write("\n",a,"\n",b, "\n\n")
   dbg.fini()
end

local function spanOneModule(path, name, nameA, fileType, keyA)
   local dbg    = Dbg:dbg()
   dbg.start("spanOneModule(path=\"",path,"\", name=\"",name,"\", nameA=(",concatTbl(nameA,","),"), fileType=\"",fileType,"\", keyA=(",concatTbl(keyA,","),"))")
   if (fileType == "file" and posix.access(path,"r")) then
      for _,v in ipairs(keyA) do
	 SearchString = v
	 nameA[#nameA+1] = name
	 local n = concatTbl(nameA,"/")
	 ModuleName = n
	 systemG.whatis  = function(msg)
			      local nm     = ModuleName or ""
			      local l      = nm:len()
			      local nblnks
			      if (l < 20) then
				 nblnks = 20 - l
			      else
				 nblnks = 2
			      end
			      local prefix = nm .. string.rep(" ",nblnks) .. ": "
			      if (msg:find(SearchString,1,true)) then
				 io.stderr:write(prefix, msg, "\n")
			      end
			   end
	 loadModuleFile{file=path}
      end
   elseif (fileType == "directory" and posix.access(path,"x")) then
      --io.stderr:write("dir: ",path," name: ", name, "\n")
      for file in lfs.dir(path) do
         if (file:sub(1,1) ~= "." and not file ~= "CVS" and file:sub(-1,-1) ~= '~') then
            local f = pathJoin(path, file)
            local readable = posix.access(f,"r")
            if (readable) then
               attr = lfs.symlinkattributes(f)
               if (attr.mode == "directory") then
                  nameA[#nameA+1] = file
               end
               --local n = concatTbl(nameA,"/")
               --io.stderr:write("file: ",file," f: ",f," mode: ",attr.mode, " n: ", n, "\n")
               M.spanOneModule(f, file, nameA, attr.mode,keyA)
               removeEntry(nameA,#nameA)
            end
         end
      end
   end
   dbg.fini()
end


function M.spanAll(self, keyA)
   local dbg    = Dbg:dbg()
   dbg.start("Master:spanAll(keyA=(",concatTbl(keyA,","),"))")
   mpathA = MT:mt():module_pathA()
   for _, path in ipairs(mpathA) do
      local attr = lfs.attributes(path)
      if (attr and attr.mode == "directory" and posix.access(path,"x")) then
         for file in lfs.dir(path) do
	    --io.stderr:write("(1) spanAll: file: ",file,"\n")
            if (file:sub(1,1) ~= "." and not file ~= "CVS" and file:sub(-1,-1) ~= '~') then
               local f = pathJoin(path, file)
               local readable = posix.access(f,"r")
               if (readable) then
                  attr = lfs.attributes(f)
                  local nameA = {}
                  if (attr.mode == "directory") then
                     nameA[#nameA+1] = file
                  end
                  --local n = concatTbl(nameA,"/")
                  --io.stderr:write("(2) spanAll: file: ",file," f: ",f," mode: ", attr.mode," n: ",n,"\n")
                  M.spanOneModule(f, file, nameA, attr.mode, keyA)
               end
	    end
         end
      end
   end
   dbg.fini()
end

return M
