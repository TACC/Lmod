#!@path_to_lua@/lua
-- -*- lua -*-


-- ancient:   the time in seconds when the cache file is considered old
-- shortTime: the time in seconds when building the cache file is quick
--            enough to be computed every time rather than cached.
ancient        = "@ancient@"
shortTime      = "@short_time@"
sysCacheDir    = os.getenv("LMOD_SPIDER_CACHE_DIR") or "@cacheDir@"
ancient        = tonumber(ancient)   or 86400
shortTime      = tonumber(shortTime) or 10.0
shortLifeCache = ancient/12
BaseShell      = {}
Pager          = "@path_to_pager@"
s_master       = {}
s_warning      = false
s_haveWarnings = true

function masterTbl()
   return s_master
end

------------------------------------------------------------------------
-- Extract directory location of "lmod" command and add it
-- to the lua search path
------------------------------------------------------------------------

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
               LuaCommandName_dir .. "?/init.lua;" ..
               package.path

package.cpath = LuaCommandName_dir .. "../lib/?.so;"..
               package.cpath

------------------------------------------------------------------------
-- Try to load a SitePackage Module,  If it is not there then do not
-- abort.  Sites do not have to have a Site package.
------------------------------------------------------------------------
pcall(require, "SitePackage") 

local term     = false
if (pcall(require, "term")) then
   term = require("term")
end


function cmdDir()
   return LuaCommandName_dir
end

local getenv = os.getenv
local rep    = string.rep

function setWarningFlag()
   s_warning = true
end
function getWarningFlag()
   return s_warning
end

function activateWarning()
   s_haveWarnings = true
end

function deactivateWarning()
   s_haveWarnings = false
end

function haveWarnings()
   s_haveWarnings = false
end


require("strict")
require("myGlobals")
require("pager")
require("fileOps")
require("firstInPath")
MasterControl = require("MasterControl")
MCP           = {}
mcp           = {}
require("modfuncs")
require("cmdfuncs")
require("colorize")
local Dbg       = require("Dbg")

local Version   = require("Version")
local concatTbl = table.concat

RCFileA = {
   pathJoin(os.getenv("HOME"),".lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/.lmodrc.lua"),
   pathJoin(cmdDir(),"../init/.lmodrc.lua"),
   os.getenv("LMOD_RC"),
}

s_propT = false

function deepcopy(orig)
   local t
   if (type(orig) == 'table') then
      t = {}
      for k, v in next, orig, nil do
         t[k] = deepcopy(v)
      end
   else
      t = orig
   end
   return t
end

function readRC()
   if (s_propT) then
      return s_propT
   end

   local results = {}

   for i = 1,#RCFileA do
      local f  = RCFileA[i]
      local fh = io.open(f)
      if (fh) then
         assert(loadfile(f))()
         fh:close()
         results = _G.propT
         break
      end
   end

   s_propT = results
   return s_propT
end

function colorizePropA(style, moduleName, propT, legendT)
   local resultA
   local propDisplayT = readRC()
   local iprop        = 0
   propT              = propT or {}

   for kk,vv in pairsByKeys(propDisplayT) do
      iprop        = iprop + 1
      local propA  = {}
      local t      = propT[kk]
      local result = ""
      local color  = nil
      if (type(t) == "table") then
         for k in pairs(t) do
            propA[#propA+1] = k
         end

         table.sort(propA);
         local n = concatTbl(propA,":")

         if (vv.displayT[n]) then
            result     = vv.displayT[n][style]
            color      = vv.displayT[n].color
            local k    = colorize(color,result)
            legendT[k] = vv.displayT[n].doc
         end
      end
      if (iprop == 1) then
         resultA = { colorize(color,moduleName), colorize(color,result)}
      else
         resultA[#resultA+1] = colorize(color,result)
      end
   end

   if (iprop == 0) then
      resultA = { moduleName }
   end

   return resultA

end

CmdLineUsage = "module [options] sub-command [args ...]"

Usage = [[
module sub-command [args ...]

Help sub-commands:
  help                                   prints this message
  help               modulefile [...]    print help message from module(s)

Loading/Unloading sub-commands:
  add | load         modulefile [...]    Add module(s)
  try-load | try-add modulefile [...]    Add module(s) , do not complain
                                         if not found
  del | rm | unload  modulefile [...]    Remove module(s), do not complain
                                         if not found
  swap | sw | switch modfile1 modfile2   unload modfile1 and load modfile2
  purge                                  unload all modules

Recovering system environment
  restore system                         Do a module purge and load system defaults


Listing / Searching sub-commands:
  list                                   List loaded modules
  list             s1 s2 ...             List loaded modules that match the s1
                                         pattern or the s2 pattern etc.
  avail | av                             List available modules
  avail | av       string                List available modules that contain
                                         "string".

  spider                                 List all possible modules
  spider           modulefile            List all possible version of that
                                         module file
  spider           string                List all module that contain the
                                         string.  
  spider           modulefile/version    Detailed information about that
                                         version of the module
  whatis           modulefile            print whatis information about module
  keyword | key    string                search all name and whatis that contain
                                         "string". 


Searching with Lmod:
  All searching (spider, list, avail, keyword) support simple regular expressions:

  spider        '^p'                     finds all the modules that start with
                                         `p' or `P'

  spider        mpi                      finds all modules that have "mpi" in
                                         their name.
  spider        'mpi$"                   file all modules that end with "mpi" in
                                         their name.

Handling a collection of modules:
  save       | s | sd                    Save the current list of modules
                                         to a user defined "default".
  save name  | s name                    Save the current list of modules
                                         to "name" collection.

  restore                                Restore modules from the user's "default"
                                         or system default.

  restore  name | r name                 Restore modules from "name" collection.


  restore  system                        restore module state to system defaults.


  savelist                               list of saved collections.


Deprecated commands
   reset                                 The same as "restore system"
   getdefault [name]                     load name collection of modules or
                                         user's "default" if no name given.
                                         ---> Use "restore" instead  <----

   setdefault [name]                     Save current list of modules to
                                         name if given, otherwise save as the
                                         default list for you the user.
                                         ---> Use "save" instead. <----


Miscellaneous sub-commands:
  record                                 save the module table.
  show                modulefile         show the commands in the module file.
  use [-a] [--append] path               Prepend or Append path to MODULEPATH
  unuse path                             remove path from MODULEPATH
  tablelist                              output list of active modules as a table.

----------------------------------------------------------------------------------
See:

   http://www.tacc.utexas.edu/tacc-projects/mclay/lmod

for complete documentation. It contains:

   User Guide                  - How to use.
   Advance User Guide          - How to create you own modules.
   System Administrator Guide  - If you want to install it on your own system.

----------------------------------------------------------------------------------
]]


function version()
   local v = {}
   v[#v + 1] = "\nModules based on Lua: Version " .. Version.name().."\n"
   v[#v + 1] = "    by Robert McLay mclay@tacc.utexas.edu\n\n"
   return concatTbl(v,"")
end

require("border")

require("serializeTbl")
require("string_split")
require("string_trim")
BaseShell          = require("BaseShell")
local ColumnTable  = require("ColumnTable")
local Spider       = require("Spider")
local Var          = require("Var")
local lfs          = require("lfs")
local posix        = require("posix")

local Options = require("Options")


function None()
   print ("None")
   FooBar=1
end

local function Avail(...)
   local master = Master:master()
   local a = {}
   for _,v in ipairs{...} do
      a[#a + 1] = v
   end
   master.avail(a)
end

local function Display(...)
end

local function Update()
   local master = Master:master()
   master:reloadAll()
end

local function TableList()
   local mt = MT:mt()

   local t = {}
   local activeA = mt:list("short","active")
   for i,v  in ipairs(activeA) do
      local w = mt:fullName(v)
      local _, _, name, version = w:find("([^/]*)/?(.*)")
      t[name] = version
   end
   local s = serializeTbl{name="activeList",indent=true, value=t}
   io.stderr:write(s,"\n")

end

function Reset()
   local dbg    = Dbg:dbg()
   dbg.start("Reset()")
   Purge()
   local default = os.getenv("LMOD_SYSTEM_DEFAULT_MODULES") or ""
   dbg.print("default: ",default,"\n")

   default = default:trim()
   default = default:gsub(" *, *",":")
   default = default:gsub(" +",":")

   local a = {}
   for m in default:split(":") do
      dbg.print("m: ",m,"\n")
      a[#a + 1] = m
   end
   if (#a > 0) then
      UsrLoad(unpack(a))
   end
   dbg.fini()
end

local function localvar(localvarA)
   local dbg = Dbg:dbg()
   for _, v in ipairs(localvarA) do
      local i = v:find("=")
      if (i) then
         local k  = v:sub(1,i-1)
         if (varTbl[k] == nil) then
            varTbl[k] = Var:new(k)
         end
         local vv = v:sub(i+1)
         dbg.print("setLocal(\"",k,"\", \"",vv,"\")\n")
         varTbl[k]:setLocal(vv)
      end
   end
end



add	     = None
rm	     = None
use          = None
unuse        = None
prtHdr       = None
avail        = Avail
list         = List

ModuleName = ""
ModuleFn   = ""

function Use(...)
   local dbg = Dbg:dbg()
   local mt  = MT:mt()
   local a = {}
   local op = MCP.prepend_path
   dbg.start("use(", concatTbl({...},", "),")")

   for _,v in ipairs{...} do
      local w = v:lower()
      if (w == "-a" or w == "--append" ) then
         op = MCP.append_path
      else
         a[#a + 1] = v
      end
   end
   for _,v in ipairs(a) do
      v = abspath(v)
      if (v) then
         op(MCP, ModulePath, v)
         op(MCP, DfltModPath, v)
      end
   end
   mt:buildBaseMpathA(varTbl[DfltModPath]:expand())
   mt:reloadAllModules()
   dbg.fini()
end

function UnUse(...)
   local dbg = Dbg:dbg()
   local mt  = MT:mt()
   dbg.start("unuse(", concatTbl({...},", "),")")
   for _,v in ipairs{...} do
      MCP:remove_path( ModulePath,v)
      MCP:remove_path( DfltModPath,v)
   end
   mt:buildBaseMpathA(varTbl[DfltModPath]:expand())
   mt:reloadAllModules()
   dbg.fini()
end

function Show(...)
   local dbg    = Dbg:dbg()
   local master = Master:master()
   dbg.start("Show(", concatTbl({...},", "),")")

   mcp = MasterControl.build("show")
   dbg.print("Setting mpc to ", mcp:name(),"\n")

   prtHdr       = function()
                     io.stderr:write("------------------------------------------------------------\n")
                     io.stderr:write("   ",ModuleFn,":\n")
                     io.stderr:write("------------------------------------------------------------\n")
                  end

   master:access(...)
   dbg.fini()

end

function Access(mode, ...)
   local dbg    = Dbg:dbg()
   local master = Master:master()
   dbg.start("Access(", concatTbl({...},", "),")")
   mcp = MasterControl.build("access", mode)
   dbg.print("Setting mpc to ", mcp:name(),"\n")

   local n = select('#',...)
   if (n < 1) then
      pcall(pager, io.stderr, Usage, "\n", version()) 
      os.exit(1)
   end

   master:access(...)
   dbg.fini()
end

function Help(...)
   local dbg = Dbg:dbg()
   help    = function (...)
      io.stderr:write(...)
      io.stderr:write("\n")
   end

   prtHdr = function()
               io.stderr:write("\n")
               io.stderr:write("----------- Module Specific Help for \"" .. ModuleName .. "\"------------------\n")
            end

   Access("help",...)
end

function Whatis(...)
   local dbg = Dbg:dbg()
   whatis  = function(msg)
                local nm     = ModuleName or ""
                local l      = nm:len()
                local nblnks
                if (l < 20) then
                   nblnks = 20 - l
                else
                   nblnks = l + 2
                end
                local prefix = nm .. string.rep(" ",nblnks) .. ": "
                io.stderr:write(prefix, msg, "\n")
             end
   prtHdr    = dbg.quiet
   Access("whatis",...)
end

function TryUsrLoad(...)
   local master = Master:master()
   local mt     = MT:mt()
   local dbg    = Dbg:dbg()

   dbg.start("TryUsrLoad(",concatTbl({...},", "),")")
   deactivateWarning()
   UsrLoad(...)
   activateWarning()
   dbg.fini()
end

function UsrLoad(...)
   local master = Master:master()
   local mt     = MT:mt()
   local dbg    = Dbg:dbg()

   dbg.start("UsrLoad(",concatTbl({...},", "),")")
   local a = {}
   for _,v in ipairs{...} do
      if (v:sub(1,1) == "-") then
         MCP:unload(v:sub(2))
      else
         if (v:sub(1,1) == "+") then
            v = v:sub(2)
         end
         a[#a + 1] = v
         if (mt:haveSN(v,"active")) then
            MCP:unload(v)
         end
      end
   end

   local mcp_old = mcp
   mcp           = MCP
   local b       = mcp:load(unpack(a))
   mcp           = mcp_old

   
   local aa = {}
   for i = 1,#a do
      if (not mt:have(a[i],"active")) then
         aa[#aa+1] = a[i]
      end
   end
      
   if (#aa > 0) then
      local s = concatTbl(aa," ")
      LmodWarning("Did not find: ",s,"\n\n",
                  "Try: \"module spider ", s,"\"\n" )
   end

   dbg.fini()
   return b
end

function UnLoad(...)
   local dbg    = Dbg:dbg()
   dbg.start("UnLoad(",concatTbl({...},", "),")")
   MCP:unload(...)
   dbg.fini()
end


local function Save(...)
   local mt   = MT:mt()
   local dbg  = Dbg:dbg()
   local a    = select(1, ...) or "default"
   local path = pathJoin(os.getenv("HOME"), LMODdir)
   dbg.start("Save(",concatTbl({...},", "),")")

   if (a == "system") then
      LmodWarning("The named collection 'system' is reserved. Please choose another name.\n")
      dbg.fini()
      return
   end


   local aa = mt:safeToSave()

   if (#aa > 0) then
      LmodWarning("Unable to save module state as a \"default\"\n",
                  "The following module(s):\n",
                  "  ",concatTbl(aa,", "),"\n",
                  "mix load statements with setting of environment variables.\n")
      dbg.fini()
      return
   end

   if (not isDir(path)) then
      os.execute("mkdir ".. path)
   end
   path = pathJoin(path, a)
   if (isFile(path)) then
      os.rename(path, path .. "~")
   end
   mt:setHashSum()
   serializeTbl{name=mt:name(), value=mt, fn = path, indent = true}
   mt:hideHash()
   if (not expert()) then
      io.stderr:write("Saved current collection of modules to: ",a,"\n")
   end
   dbg.fini()
end

local function GetDefault(a)
   local dbg  = Dbg:dbg()
   a          = a or "default"
   dbg.start("GetDefault(",a,")")

   local path = pathJoin(os.getenv("HOME"), ".lmod.d", a)
   local mt   = MT:mt()
   mt:getMTfromFile(path)
   dbg.fini()
end

local function Restore(a)
   local dbg    = Dbg:dbg()
   local prtMsg = false
   if (a == nil) then
      prtMsg = true
   end

   dbg.start("Restore(",tostring(a),")")

   local msg
   local path

   if (a == nil) then
      path = pathJoin(os.getenv("HOME"), ".lmod.d", "default")
      if (not isFile(path)) then
         a = "system"
      end
   elseif (a ~= "system") then
      path = pathJoin(os.getenv("HOME"), ".lmod.d", a)
      if (not isFile(path)) then
         LmodError(" User module collection: \"",a,"\" does not exist.\n",
                   " Try \"module savelist\" for possible choices.\n")
      end
   end


   if (a == "system" ) then
      dbg.print("Restoring System\n")
      msg = "system default"
   else
      a   = a or "default"
      msg = "user's "..a
   end

   local masterTbl = masterTbl()
   if (prtMsg and not masterTbl.initial) then
      io.stderr:write("\nRestoring modules to ",msg,"\n")
   end

   if (a == "system" ) then
      Reset()
   else
      local mt   = MT:mt()
      mt:getMTfromFile(path)
   end
   
   dbg.fini()
end

local function FindDefaults(a,path)
   for file in lfs.dir(path) do
      if (file:sub(1,1) ~= "." and file:sub(-1) ~= "~") then
         local f = pathJoin(path,file)
         if (isDir(f)) then
            FindDefaults(a,f)
         else
            a[#a+1] = f
         end
      end
   end
end

local function SaveList(...)
   local mt   = MT:mt()
   local dbg  = Dbg:dbg()
   local path = pathJoin(os.getenv("HOME"), LMODdir)
   local i    = 0

   local a = {}
   local b = {}

   FindDefaults(b,path)
   for k = 1,#b do
      local name = b[k]
      local i,j  = name:find(path,1,true)
      if (i) then
         name = name:sub(j+2)
      end
      a[#a+1] = "  " .. k .. ") " .. name
   end

   if (#a > 0) then
      io.stderr:write("Possible named collection(s):\n")
      local ct = ColumnTable:new{tbl=a,gap=0}
      io.stderr:write(ct:build_tbl(),"\n")
   end
end

local function Swap(...)
   local dbg = Dbg:dbg()
   local a = select(1, ...) or ""
   local b = select(2, ...) or ""
   local s = {}

   dbg.start("Swap(",concatTbl({...},", "),")")

   local n = select("#", ...)
   if (n ~= 2) then
      LmodError("Wrong number of arguments to swap.\n")
   end

   local mt     = MT:mt()
   if (not mt:haveSN(a,"any")) then
      LmodError("Swap failed: \"",a,"\" is not loaded.\n")
   end

   local mcp_old = mcp
   mcp           = MCP
   mcp:unload(a)
   local aa = mcp:load(b)
   if (not aa[1]) then
      LmodError("Swap failed.\n")
   end
   mcp = mcp_old
   dbg.fini()
end

function UUIDString(epoch)
   local ymd  = os.date("*t", epoch)

   --                                y    m    d    h    m    s
   local uuid_date = string.format("%d_%02d_%02d_%02d_%02d_%02d", 
                                   ymd.year, ymd.month, ymd.day, 
                                   ymd.hour, ymd.min,   ymd.sec)
   
   local uuid_str  = capture("uuidgen"):sub(1,-2)
   local uuid      = uuid_date .. "-" .. uuid_str

   return uuid
end

local function epoch()
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

function getModuleT()

   local dbg        = Dbg:dbg()
   local mt         = MT:mt()
   local moduleT    = {}
   local HOME       = os.getenv("HOME") or ""
   local cacheDir   = pathJoin(HOME,".lmod.d",".cache")
   local errRtn     = LmodError
   local message    = LmodMessage
   local cacheFileA = {
      { file = pathJoin(cacheDir,   "moduleT.lua"),     fileT = "your"  },
      { file = pathJoin(sysCacheDir,"moduleT.lua"),     fileT = "system"},
      { file = pathJoin(sysCacheDir,"moduleT.old.lua"), fileT = "system"},
   }
   local userModuleTFN = pathJoin(cacheDir,"moduleT.lua")

   dbg.start("getModuleT()")

   local mpath = mt:getBaseMPATH()
   if (mpath == nil) then
     LmodError("The Env Variable: \"", DfltModPath, "\" is not set\n")
   end
   local moduleDirA = {}
   for path in mpath:split(":") do
      moduleDirA[#moduleDirA+1] = path
   end

   local buildModuleT = true
   local moduleTFN    = nil
   local fileT        = nil
   local timeDiff     = math.huge
   local idx                        -- The index for the cachefile to use.

   ------------------------------------------------
   -- Search over cacheFile and find the most recent one.
   -- Check for user cache file and system cache file.
   -- Use system file if acceptable?

   ancient = mt:getRebuildTime() or ancient

   for i = 1,#cacheFileA do
      local f = cacheFileA[i].file
      dbg.print("cacheFile: ",f,"\n")
      if (isFile(f)) then
         local attr   = lfs.attributes(f)

         -- Check Time

         local diff   = os.time() - attr.modification
         buildModuleT = diff > ancient  -- rebuild if older than a day
         dbg.print("timeDiff: ",diff," buildModuleT: ", tostring(buildModuleT),"\n")


         if (not buildModuleT) then
         
            -- Check for matching default MODULEPATH.
            assert(loadfile(f))()
            local defaultMpathA = _G.defaultMpathA
            if (#moduleDirA ~= #defaultMpathA) then
               buildModuleT = true -- rebuild because the number of dirs has changed.
               dbg.print("(2) buildModuleT: ", tostring(buildModuleT),"\n")
            else
               for i = 1,#moduleDirA do
                  if (moduleDirA[i] ~= defaultMpathA[i]) then
                     buildModuleT = true
                     break
                  end
               end
               dbg.print("(3) buildModuleT: ", tostring(buildModuleT),"\n")
            end
         end

         if (not buildModuleT and diff < timeDiff) then
            timeDiff = diff
            idx      = i
            dbg.print("Setting idx: ",idx,"\n")
         end
      end
   end

   if (idx) then
      moduleTFN = cacheFileA[idx].file
      fileT     = cacheFileA[idx].fileT
      buildModuleT = false
   else
      buildModuleT = true
   end

   if (moduleTFN) then
      io.stderr:write("Using ",fileT," spider cache file\n")
   end

   if (buildModuleT) then
      LmodError    = dbg.quiet
      LmodMessage  = dbg.quiet
      io.stderr:write("Rebuilding cache file, please wait ...")

      local t1 = epoch()
      Spider.findAllModules(moduleDirA, moduleT)
      local t2 = epoch()
      io.stderr:write(" done\n")
      LmodError    = errRtn
      LmodMessage  = message
      dbg.print("t2-t1: ",t2-t1, " shortTime: ", shortTime, "\n")

      if (t2 - t1 < shortTime) then
         ancient = shortLifeCache
         mt:setRebuildTime(ancient)
      end

      mkdir_recursive(cacheDir)
      local s0 = "-- Date: " .. os.date("%c",os.time()) .. "\n"
      local s1 = "ancient = " .. tostring(math.floor(ancient)) .."\n"
      local s2 = serializeTbl{name="defaultMpathA",value=moduleDirA,indent=true}
      local s3 = serializeTbl{name="moduleT",      value=moduleT,   indent=true}
      local f  = io.open(userModuleTFN,"w")
      f:write(s0,s1,s2,s3)
      f:close()
      dbg.print("Wrote: ",userModuleTFN,"\n")

   else
      dbg.print("Loading: ",moduleTFN,"\n")
      assert(loadfile(moduleTFN))()
      moduleT = _G.moduleT
      ancient = _G.ancient or ancient
      mt:setRebuildTime(ancient)
   end

   -- remove user cache file if old
   if (isFile(userModuleTFN)) then
      local attr   = lfs.attributes(userModuleTFN)
      local diff   = os.time() - attr.modification
      if (diff > ancient) then 
         posix.unlink(userModuleTFN);
         dbg.print("Deleted: ",userModuleTFN,"\n")
      end
   end

   dbg.fini()
   return moduleT
end


function RecordCmd()
   local dbg = Dbg:dbg()
   dbg.start("RecordCmd()")
   local mt   = MT:mt()
   local s    = serializeTbl{indent=true, name="_ModuleTable_", value=_ModuleTable_}
   local uuid = UUIDString(epoch())
   local fn   = pathJoin(getenv("HOME"), ".lmod.d", ".save", uuid .. ".lua")

   local d = dirname(fn)
   if (not isDir(d)) then
      mkdir_recursive(d)
   end 

   local f = io.open(fn,"w")
   if (f) then
      f:write(s)
      f:close()
   end
   dbg.fini()
end


function SpiderCmd(...)
   local dbg = Dbg:dbg()
   dbg.start("SpiderCmd(", concatTbl({...},", "),")")
   mcp           = MasterControl.build("spider")
   dbg.print("Setting mpc to ", mcp:name(),"\n")
   local moduleT = getModuleT()

   local s
   local dbT = {}
   local errorRtn = LmodError
   Spider.buildSpiderDB({"default"},moduleT, dbT)
   LmodError = errorRtn

   local arg = {n=select('#',...),...}

   if (arg.n < 1) then
      s = Spider.Level0(dbT)
   else
      local a = {}
      local help = false
      for i = 1, arg.n do
         if (i == arg.n) then help = true end
         a[#a+1] = Spider.spiderSearch(dbT, arg[i], help)
      end
      s = concatTbl(a,"\n")
   end
   pcall(pager,io.stderr, s, "\n")
   dbg.fini()
end

function Keyword(...)
   local dbg    = Dbg:dbg()
   dbg.start("Keyword(",concatTbl({...},","),")")
   mcp          = MasterControl.build("spider")
   dbg.print("Setting mpc to ", mcp:name(),"\n")

   local master = Master:master()

   local moduleT = getModuleT()
   local s
   local dbT = {}
   Spider.searchSpiderDB({...},{"default"},moduleT, dbT)
   local a = {}
   local ia = 0

   local banner = border(0)

   ia = ia+1; a[ia] = "\n"
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "The following modules match your search criteria: \""
   ia = ia+1; a[ia] = concatTbl({...},"\", \"")
   ia = ia+1; a[ia] = "\"\n"
   ia = ia+1; a[ia] = banner
   ia = ia+1; a[ia] = "\n"

   Spider.Level0Helper(dbT,a)
   pcall(pager,io.stderr,concatTbl(a,""))

   dbg.fini()

end


local __expert = false

function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end

Master = require("Master")
MT     = require("MT")

function main()
   
   local loadTbl      = { name = "load",        checkMPATH = true,  cmd = UsrLoad     }
   local tryAddTbl    = { name = "try-add",     checkMPATH = true,  cmd = TryUsrLoad  }
   local unloadTbl    = { name = "unload",      checkMPATH = true,  cmd = UnLoad      }
   local swapTbl      = { name = "swap",        checkMPATH = true,  cmd = Swap        }
   local purgeTbl     = { name = "purge",       checkMPATH = true,  cmd = Purge       }
   local resetTbl     = { name = "reset",       checkMPATH = true,  cmd = Reset       }
   local availTbl     = { name = "avail",       checkMPATH = false, cmd = Avail       }
   local listTbl      = { name = "list",        checkMPATH = false, cmd = List        }
   local tblLstTbl    = { name = "tablelist",   checkMPATH = false, cmd = TableList   }
   local helpTbl      = { name = "help",        checkMPATH = false, cmd = Help        }
   local whatisTbl    = { name = "whatis",      checkMPATH = false, cmd = Whatis      }
   local showTbl      = { name = "show",        checkMPATH = false, cmd = Show        }
   local useTbl       = { name = "use",         checkMPATH = true,  cmd = Use         }
   local unuseTbl     = { name = "unuse",       checkMPATH = true,  cmd = UnUse       }
   local updateTbl    = { name = "update",      checkMPATH = true,  cmd = Update      }
   local keywordTbl   = { name = "keyword",     checkMPATH = false, cmd = Keyword     }
   local saveTbl      = { name = "save",        checkMPATH = false, cmd = Save        }
   local gdTbl        = { name = "getDefault",  checkMPATH = false, cmd = GetDefault  }
   local restoreTbl   = { name = "restore",     checkMPATH = false, cmd = Restore     }
   local savelistTbl  = { name = "savelist",    checkMPATH = false, cmd = SaveList    }
   local spiderTbl    = { name = "spider",      checkMPATH = true,  cmd = SpiderCmd   }
   local recordTbl    = { name = "record",      checkMPATH = false, cmd = RecordCmd   }

   local cmdTbl = {
      ["try-add"]  = tryAddTbl,
      ["try-load"] = tryAddTbl,
      add          = loadTbl,
      apropos      = keywordTbl,
      av           = availTbl,
      avail        = availTbl,
      del          = unloadTbl,
      delete       = unloadTbl,
      dis          = showTbl,
      display      = showTbl,
      era          = unloadTbl,
      erase        = unloadTbl,
      gd           = gdTbl,
      getd         = gdTbl,
      getdefault   = gdTbl,
      help         = helpTbl,
      key          = keywordTbl,
      keyword      = keywordTbl,
      ld           = savelistTbl,
      li           = listTbl,
      list         = listTbl,
      listdefault  = savelistTbl,
      savelist     = savelistTbl,
      lo           = loadTbl,
      load         = loadTbl,
      purge        = purgeTbl,
      record       = recordTbl,
      refr         = updateTbl,
      refresh      = updateTbl,
      reload       = updateTbl,
      remov        = unloadTbl,
      remove       = unloadTbl,
      reset        = resetTbl,
      restore      = restoreTbl,
      r            = restoreTbl,
      rm           = unloadTbl,
      s            = saveTbl,
      save         = saveTbl,
      sd           = saveTbl,
      setd         = saveTbl,
      setdefault   = saveTbl,
      show         = showTbl,
      spider       = spiderTbl,
      sw           = swapTbl,
      swap         = swapTbl,
      switch       = swapTbl,
      tablelist    = tblLstTbl,
      unlo         = unloadTbl,
      unload       = unloadTbl,
      unuse        = unuseTbl,
      update       = updateTbl,
      use          = useTbl,
      wh           = whatisTbl,
      whatis       = whatisTbl,
   }

   local dbg  = Dbg:dbg()

   MCP = MasterControl.build("load")

   -------------------------------------------------------------------
   -- Is io.stderr connected to a tty or not?
   -- Setup output and pager routines
   colorize = plain
   pager    = bypassPager
   local connectedTerm = false
   
   if (term) then
      if (term.isatty(io.stderr)) then
         colorize = full_colorize
         pager    = usePager
         connectedTerm = true
      end
   end

   dbg.set_prefix(colorize("red","Lmod"))

   local shell = barefilename(arg[1])
   table.remove(arg,1)

   local arg_str   = concatTbl(arg," ")
   local masterTbl = masterTbl()
   Options:options(CmdLineUsage)


   -- Chose prepend_path order normal/reverse
   set_prepend_order()

   if (masterTbl.debug or masterTbl.dbglvl) then
      dbg:activateDebug(masterTbl.dbglvl or 1)
   end

   dbg.start("lmod(", arg_str,")")
   MCP = MasterControl.build("load")
   mcp = MasterControl.build("load")
   dbg.print("Setting mpc to ", mcp:name(),"\n")
   localvar(masterTbl.localvarA)

   local cmdName = masterTbl.pargs[1]
   table.remove(masterTbl.pargs,1)

   ------------------------------------------------------------
   -- Must output local variables even when there is the command
   -- is not a valid command
   --
   -- So set [[checkMPATH]] to false by default and re-define when there
   -- is a valid command:

   local checkMPATH = false
   if (cmdTbl[cmdName] ) then
      checkMPATH = cmdTbl[cmdName].checkMPATH
   end

   -- Create the [[master]] object

   local master = Master:master(checkMPATH)
   master.shell = BaseShell.build(shell)
   local mt     = MT:mt()

   local origMT = deepcopy(mt)

   -- Output local vars
   master.shell:expand(varTbl)

   -- if Help was requested then quit.
   if (masterTbl.Optiks_help) then
      Help()
      os.exit(0)
   end

   -- print version and quit if requested.
   if (masterTbl.version) then
      io.stderr:write(version())
      os.exit(0)
   end

   -- Now quit if command is unknown.

   if (cmdTbl[cmdName] == nil) then
      io.stderr:write(version())
      io.stderr:write(Usage,"\n")
      LmodErrorExit()
   end

   if (cmdTbl[cmdName]) then
      local cmd = cmdTbl[cmdName].cmd
      cmdName   = cmdTbl[cmdName].name
      dbg.print("cmd name: ", cmdName,"\n")
      cmd(unpack(masterTbl.pargs))
   end

   -- Report any changes (worth reporting from original MT)
   if (not expert()) then
      mt:reportChanges(origMT)
   end

   -- Store the Module table in "_ModuleTable_" env. var.
   local n        = mt:name()
   local oldValue = master.shell:getMT() or ""
   local value    = mt:serializeTbl()

   if (oldValue ~= value) then
      varTbl[n] = Var:new(n)
      varTbl[n]:set(value)
   end
   dbg.fini()

   -- Output all newly created path and variables.
   master.shell:expand(varTbl)

   if (getWarningFlag() and not expert() ) then
      LmodErrorExit()
   end
end

main()
