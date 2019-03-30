--------------------------------------------------------------------------
-- The all the user sub-commands are implemented here.
-- @module cmdfuncs

_G._DEBUG          = false
local posix        = require("posix")

require("strict")

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

require("myGlobals")
require("string_utils")
require("TermWidth")
require("fileOps")
require("utils")
local Banner       = require("Banner")
local BeautifulTbl = require('BeautifulTbl')
local Cache        = require("Cache")
local ColumnTable  = require('ColumnTable')
local FrameStk     = require('FrameStk')
local Master       = require('Master')
local MName        = require("MName")
local Spider       = require("Spider")
local Version      = require("Version")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local getenv       = os.getenv
local hook         = require("Hook")
local i18n         = require("i18n")
local lfs          = require("lfs")
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack  -- luacheck: compat
local unpack       = (_VERSION == "Lua 5.1") and unpack or table.unpack  -- luacheck: compat

local system_name  = cosmic:value("LMOD_SYSTEM_NAME")

--------------------------------------------------------------------------
-- Both Help and Whatis functions funnel their actions through
-- the Access function. MC_Access defines real functions for both M.help
-- and M.access.  The mcp.accessMode function activates one or the other
-- depending on what mode Access is called with.
-- @param mode Whether this function has be called via *Help* or *Whatis*.
local function Access(mode, ...)
   local master    = Master:singleton()
   local shell     = _G.Shell
   local masterTbl = masterTbl()
   dbg.start{"Access(", concatTbl({...},", "),")"}
   mcp = MasterControl.build("access", mode)
   mcp:setAccessMode(mode,true)

   local n = select('#',...)
   if (n < 1) then
      shell:echo(masterTbl.cmdHelpMsg, "\n", Usage(), "\n", version())
      dbg.fini("Access")
      return
   end

   master:access(...)
   mcp:setAccessMode(mode,false)
   dbg.fini("Access")
end

--------------------------------------------------------------------------
-- This helper function walks the ~/.lmod.d directory and reports back
-- the list of named collections. Note that names that start with "."
-- or end with "~" or start with "__" are ignored.
-- @param a An array containing the results.
-- @param path The Lmod.d directory path.
local function findNamedCollections(a,path)
   if (not isDir(path)) then return end
   for file in lfs.dir(path) do
      if (file:sub(1,1) ~= "." and file:sub(-1) ~= "~" and
          file:sub(1,2) ~= "__") then
         local f    = pathJoin(path,file)
         local attr = lfs.attributes(f)
         if (attr and attr.mode == "directory") then
            findNamedCollections(a,f)
         else
            local idx    = file:find("%.")
            local accept = (not idx) and (not system_name)
            if (idx and system_name) then
               accept    = file:sub(idx+1,-1) == system_name
               f         = pathJoin(path, file:sub(1,idx-1))
            end
            if (accept) then
               a[#a+1] = f
            end
         end
      end
   end
   table.sort(a)
end

------------------------------------------------------------------------
-- Just convert the vararg into an actual array and call
-- master.avail to do the real work.
function Avail(...)
   local shell = _G.Shell
   local a     = master:avail(pack(...))
   if (next(a) ~= nil) then
      shell:echo(concatTbl(a,""))
   end
end

--------------------------------------------------------------------------
-- Report the modules in the requested collection
function CollectionLst(collection)
   collection  = collection or "default"
   dbg.start{"CollectionLst(",collection,")"}
   local masterTbl = masterTbl()
   local sname     = (not system_name) and "" or "." .. system_name
   local path      = pathJoin(os.getenv("HOME"), ".lmod.d", collection .. sname)
   local mt        = FrameStk:singleton():mt()
   local a         = mt:reportContents{fn=path, name=collection}
   local shell     = _G.Shell
   local cwidth    = masterTbl.rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()
   if (masterTbl.terse) then
      for i = 1,#a do
         shell:echo(a[i].."\n")
      end
   else
      if (#a < 1) then
         LmodWarning{msg="w_No_Coll",collection=collection}
         dbg.fini("CollectionLst")
         return
      end
      shell:echo(i18n("coll_contains",{collection=collection}))
      local b = {}
      for i = 1,#a do
         b[#b+1] = { "   " .. tostring(i) .. ")", a[i] }
      end
      local ct = ColumnTable:new{tbl=b, gap = 0, width = cwidth}
      shell:echo(ct:build_tbl(),"\n")
   end
   dbg.fini("CollectionLst")
end


--------------------------------------------------------------------------
-- Get the command line argument and use MT:getMTfromFile()
-- to read the module table from the file and use that
-- collections of module to load.  This routine is deprecated
-- and will be removed.  Use restore instead.
-- @param collection The collection name (default="default")
function GetDefault(collection)
   collection  = collection or "default"
   dbg.start{"GetDefault(",collection,")"}

   local sname = (not system_name) and "" or "." .. system_name
   local path  = pathJoin(os.getenv("HOME"), ".lmod.d", collection .. sname)
   local mt    = FrameStk:singleton():mt()
   mt:getMTfromFile{fn=path, name=collection, }
   dbg.fini("GetDefault")
end

--------------------------------------------------------------------------
-- Define the prtHdr function and use the helper function Access()
-- to report the Help message to the user.
function Help(...)

   local banner = Banner:singleton()

   _G.prtHdr = function()
      local middleStr = i18n("specific_hlp",{fullName = _G.FullName})
      local title     = banner:bannerStr(middleStr)
      local a         = {}
      a[#a+1]         = "\n"
      a[#a+1]         = title
      a[#a+1]         = "\n"
      return concatTbl(a,"")
   end

   Access("help",...)
end

function IsAvail(...)
   local argA = pack(...)
   for i = 1, argA.n do
      local mname = MName:new("load", argA[i])
      if (not mname:valid()) then
         setWarningFlag()
         break
      end
   end
end

function IsLoaded(...)
   local argA = pack(...)
   for i = 1, argA.n do
      local mname = MName:new("mt", argA[i])
      if (not mname:isloaded()) then
         setWarningFlag()
         break
      end
   end
end

--------------------------------------------------------------------------
-- Use the list of user requested keywords to be searched
-- through the spider cache.
function Keyword(...)
   dbg.start{"Keyword(",concatTbl({...},","),")"}

   local banner      = Banner:singleton()
   local border      = banner:border(0)
   local shell       = _G.Shell
   local cache       = Cache:singleton{buildCache=true}
   local moduleT,dbT = cache:build()
   local spider      = Spider:new()
   local a           = {}
   local ia          = 0
   local masterTbl   = masterTbl()
   local terse       = masterTbl.terse
   local kywdT       = spider:searchSpiderDB(pack(...), dbT)

   if (terse) then
      shell:echo(Spider:Level0_terse(kywdT))
      dbg.fini("Keyword")
      return
   end

   ia = ia+1; a[ia] = i18n("keyword_msg",{border=border, module_list = concatTbl({...},"\", \"")})

   dbg.printT("kywdT",kywdT)

   spider:Level0Helper(kywdT,a)

   shell:echo(concatTbl(a,""))

   dbg.fini("Keyword")
end

--------------------------------------------------------------------------
-- List the loaded modulefile
function List(...)
   dbg.start{"List(...)"}
   local masterTbl = masterTbl()
   local shell     = _G.Shell
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local activeA   = mt:list("fullName","active")
   local inactiveA = mt:list("fullName","inactive")
   local total     = #activeA + #inactiveA
   local cwidth    = masterTbl.rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()

   dbg.print{"#activeA:   ",#activeA,"\n"}
   dbg.print{"#inactiveA: ",#inactiveA,"\n"}

   activeA = hook.apply("listHook",activeA) or activeA

   if (total < 1) then
      shell:echo(i18n("noModsLoaded"))
      dbg.fini("List")
      return
   end

   local wanted = pack(...)

   local msg     = i18n("currLoadedMods")
   local a       = {}
   local b       = {}
   local msg2    = ":"

   if (wanted.n == 0) then
      wanted[1] = ".*"
      wanted.n  = 1
   else
      msg2 = i18n("matching",{wanted = table.concat(wanted," or ")})
      if (not masterTbl.regexp) then
         for i = 1, wanted.n do
            wanted[i] = wanted[i]:caseIndependent()
         end
      end
   end

   if (masterTbl.terse) then
      for i = 1,#activeA do
         local fullName = activeA[i].fullName
         for j = 1, wanted.n do
            local p = wanted[j]
            if (fullName:find(p)) then
               shell:echo(fullName.."\n")
            end
         end
      end
      dbg.fini("List")
      return
   end

   b[#b+1] = "\n"
   b[#b+1] = msg
   b[#b+1] = msg2
   b[#b+1] = "\n"

   local kk = 0
   local legendT = {}
   for i = 1, #activeA do
      local entry    = activeA[i]
      local fullName = entry.fullName
      for j = 1, wanted.n do
         local p = wanted[j]
         if (fullName:find(p)) then
            kk = kk + 1
            a[#a + 1] = mt:list_property(kk, entry.sn, "short", legendT)
         end
      end
   end

   if (kk == 0) then
      b[#b+1] = i18n("noneFound")
   else
      if (#a > 0) then
         local ct = ColumnTable:new{tbl=a, gap=0, len=length, width=cwidth}
         b[#b+1] = ct:build_tbl()
         b[#b+1] = "\n"
      end
   end

   if (next(legendT)) then
      local term_width = TermWidth()
      b[#b+1] = i18n("Where")
      a = {}
      for k, v in pairsByKeys(legendT) do
         a[#a+1] = { "   " .. k ..":", v}
      end
      local bt = BeautifulTbl:new{tbl=a, column = term_width-1}
      b[#b+1] = bt:build_tbl()
      b[#b+1] = "\n"
   end
   a = {}
   kk = 0

   for i = 1, #inactiveA do
      local entry    = inactiveA[i]
      local fullName = entry.fullName
      local userName = entry.userName
      for j = 1, wanted.n do
         local p = wanted[j]
         if (fullName:find(p)) then
            kk      = kk + 1
            a[#a+1] = {"  " .. tostring(kk).. ")" , userName}
         end
      end
   end

   if (#a > 0) then
      b[#b+1] = i18n("Inactive")
      b[#b+1] = msg2
      b[#b+1] = "\n"
      local ct = ColumnTable:new{tbl=a,gap=0, width = cwidth}
      b[#b+1] = ct:build_tbl()
      b[#b+1] = "\n"
   end

   b = hook.apply("msgHook","list",b) or b

   shell:echo(concatTbl(b,""))
   dbg.fini("List")
end


------------------------------------------------------------------------
-- Load modules from users but do not issue warnings if the module is
-- not there.
function Load_Try(...)
   dbg.start{"Load_Try(",concatTbl({...},", "),")"}
   deactivateWarning()
   Load_Usr(...)
   activateWarning()
   dbg.fini("Load_Try")
end

------------------------------------------------------------------------
-- Load modules from users.  If a module name has
-- a minus sign in front of it then unload it.  Do that
-- before loading any other modules.  Also if the
-- shortName of a request module is already loaded then
-- unload it.  This way:
--
--      $ module load foo/1.1; module load foo/1.3
--
-- the second load of "foo" will not load it twice.
-- Finally any successful loading of a module is registered
-- with "MT" so that when a user does the above commands
-- it won't get the swap message.
function Load_Usr(...)
   local frameStk = FrameStk:singleton()
   dbg.start{"Load_Usr(",concatTbl({...},", "),")"}
   local uA   = {}
   local lA   = {}
   local argA = pack(...)
   for i = 1, argA.n do
      local v = argA[i]
      if (v:sub(1,1) == "-") then
         uA[#uA+1] = MName:new("mt", v:sub(2,-1))
      else
         if (v:sub(1,1) == "+") then
            v = v:sub(2,-1)
         end
         lA[#lA+1]   = MName:new("load",v)
      end
   end

   if (#uA > 0) then
      MCP:unload_usr(uA)
   end

   local varT     = frameStk:varT()
   --dbg.printT("varT[ModulePath]: ",varT[ModulePath])
   local b
   if (#lA > 0) then
      if (varT[ModulePath] == nil or
          varT[ModulePath]:expand() == false or
          varT[ModulePath]:expand() == "" ) then
         LmodWarning{msg="w_Undef_MPATH"}
      end

      local mcp_old = mcp
      mcp           = MCP
      dbg.print{"Setting mcp to ", mcp:name(),"\n"}
      b             = mcp:load_usr(lA)

      if (haveWarnings()) then
         mcp.mustLoad()
      end
      mcp           = mcp_old
   end

   dbg.fini("Load_Usr")
   return b
end

function Purge_Usr()
   dbg.start{"Purge_Usr()"}
   Purge()
   dbg.fini("Purge_Usr")
end


--------------------------------------------------------------------------
-- Unload all loaded modules.
-- @param force If true then sticky modules are unloaded as well.
function Purge(force)
   local frameStk = FrameStk:singleton()
   local mt       = frameStk:mt()
   local totalA   = mt:list("short","any")

   if (#totalA < 1) then
      return
   end

   local mA = {}
   for i = #totalA,1,-1 do
      mA[#mA+1] = MName:new("mt",totalA[i])
   end
   dbg.start{"Purge(",concatTbl(totalA,", "),")"}

   MCP:unload_usr(mA,force)

   -- Make Default Path be the new MODULEPATH
   -- mt:buildMpathA(mt:getBaseMPATH())

   -- A purge should not set the warning flag.
   clearWarningFlag()
   dbg.print{"warningFlag: ", getWarningFlag(),"\n"}
   dbg.fini("Purge")
end

--------------------------------------------------------------------------
-- Reload all loaded modules so that any alias or shell
-- functions are defined.  No other module commands are active.
-- This command exists so that sub-shells will have the aliases
-- defined.
function Refresh()
   dbg.start{"Refresh()"}
   local master  = Master:singleton()
   master:refresh()
   dbg.fini("Refresh")
end

--------------------------------------------------------------------------
-- Reset all module commands back to the system defined default
-- value in env. var. LMOD_SYSTEM_DEFAULT_MODULES.  If that
-- variable is not defined then there are no default modules
-- and this command is the same as a purge.
-- @param msg If true then print resetting message.
function Reset(msg)
   dbg.start{"Reset()"}
   local default = os.getenv("LMOD_SYSTEM_DEFAULT_MODULES") or ""
   if (default == "") then
      if (not quiet()) then
         io.stderr:write(i18n("w_SYS_DFLT_EMPTY",{}))
      end
      LmodErrorExit()
      dbg.fini("Reset")
      return
   end

   local force = true
   Purge(force)

   -- Change MODULEPATH back to systemBaseMPATH
   FrameStk:singleton():resetMPATH2system()

   dbg.print{"default: \"",default,"\"\n"}

   default = default:trim()
   default = default:gsub(" *, *",":")
   default = default:gsub(" +",":")

   if (msg ~= false) then
      io.stderr:write(i18n("m_Reset_SysDflt",{}))
   end


   local a = {}
   for m in default:split(":") do
      dbg.print{"m: ",m,"\n"}
      a[#a + 1] = m
   end
   if (#a > 0) then
      Load_Usr(unpack(a))
   end
   dbg.fini("Reset")
end

--------------------------------------------------------------------------
-- Restore the state of the user's loaded modules original
-- state. If a user has a "default" then use that collection.
-- Otherwise do a "Reset()"
-- @param collection The user supplied collection name. If *nil* the use "default"
function Restore(collection)
   dbg.start{"Restore(",collection,")"}

   local msg
   local path
   local myName  = "default"
   local sname   = system_name
   local msgTail = ""
   if (not sname) then
      sname   = ""
      myName  = "(empty)"
   else
      msgTail = ", for system: \"".. sname .. "\""
      sname   = "." .. sname
   end

   if (collection == nil) then
      path = pathJoin(os.getenv("HOME"), ".lmod.d", "default" .. sname)
      if (not isFile(path)) then
         collection = "system"
         myName = collection
      else
         myName = "default"
      end
   elseif (collection ~= "system") then
      myName = collection
      path   = pathJoin(os.getenv("HOME"), ".lmod.d", collection .. sname)
      if (not isFile(path)) then
         LmodError{msg="e_Unknown_Coll", collection = collection}
      end
   end

   if (barefilename(myName):find("%.")) then
      LmodError{msg="e_No_Period_Allowed", collection = collection}
   end


   local masterTbl = masterTbl()

   if (collection == "system" ) then
      msg = "system default" .. msgTail
   else
      collection = collection or "default"
      msg        = "user's ".. collection .. msgTail
   end

   if (masterTbl.quiet or masterTbl.initial) then
      msg = false
   end

   if (collection == "system" ) then
      Reset(msg)
   else
      local mt      = FrameStk:singleton():mt()
      local results = mt:getMTfromFile{fn=path, name=myName, msg=msg}
      if (not results and collection == "default") then
         Reset(msg)
      end
   end

   local mt      = FrameStk:singleton():mt()
   dbg.print{"mt: ",tostring(mt),"\n"}


   hook.apply("restore", {collection=collection, name=myName, fn=path})

   dbg.fini("Restore")
end

--------------------------------------------------------------------------
-- Save the current list of modules to whatever name the user
-- gave on the command line or "default" if there is none.
-- Note that this function checks to see if any of the currently
-- loaded modules mix load statements with the setting of
-- environment variables.  In that case, Lmod will not save the
-- state of the modules into a collection.  The reasons are
-- complicated but a "manager" module file is "fake" loaded so
-- that any setenv or prepend_path commands will not be executed.
function Save(...)
   local masterTbl = masterTbl()
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local a         = select(1, ...) or "default"
   local path      = pathJoin(os.getenv("HOME"), LMODdir)
   dbg.start{"Save(",concatTbl({...},", "),")"}

   local msgTail = ""
   local sname   = system_name
   if (not sname) then
      sname   = ""
   else
      msgTail = i18n("m_For_System",{sname = sname})
      sname   = "." .. sname
   end

   if (barefilename(a):find("%.")) then
      LmodWarning{msg="w_No_dot_Coll",name=a}
      dbg.fini("Save")
      return
   end

   if (a == "system") then
      LmodWarning{msg="w_System_Reserved"}
      dbg.fini("Save")
      return
   end

   local activeA = mt:list("short","active")
   local force   = masterTbl.force
   if (#activeA == 0 and not force) then
      LmodWarning{msg="w_Save_Empty_Coll",name=a}
      dbg.fini("Save")
      return
   end

   local attr = lfs.attributes(path)
   if (not attr) then
      mkdir_recursive(path)
   end
   path = pathJoin(path, a .. sname)
   if (isFile(path)) then
      os.rename(path, path .. "~")
   end
   mt:setHashSum()
   local varT = frameStk:varT()
   mt:setMpathRefCountT(varT[ModulePath]:refCountT())

   local f  = io.open(path,"w")
   if (f) then
      f:write("-- -*- lua -*-\n")
      f:write("-- created: ",os.date()," --\n")
      local s0 = "-- Lmod ".. Version.name() .. "\n"
      local s1 = serializeTbl{name=mt:name(), value=mt, indent = true}
      f:write(s0,s1)
      f:close()
   end
   mt:hideMpathRefCountT()
   mt:hideHash()
   if (not quiet()) then
      LmodMessage{msg="m_Save_Coll",a=a, msgTail=msgTail}
   end
   dbg.fini("Save")
end


--------------------------------------------------------------------------
-- Report to the user all the named collections he/she has.
function SaveList(...)
   local mt        = FrameStk:singleton():mt()
   local path      = pathJoin(os.getenv("HOME"), LMODdir)
   local masterTbl = masterTbl()
   local a         = {}
   local b         = {}
   local shell     = _G.Shell
   local cwidth    = masterTbl.rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()

   findNamedCollections(b,path)
   if (masterTbl.terse) then
      for k = 1,#b do
         local name = b[k]
         local i,j  = name:find(path,1,true)
         if (i) then
            name = name:sub(j+2)
         end
         shell:echo(name.."\n")
      end
      return
   end


   for k = 1,#b do
      local name = b[k]
      local i,j  = name:find(path,1,true)
      if (i) then
         name = name:sub(j+2)
      end
      local cstr = string.format("%3d) ",k)
      a[#a+1] = cstr .. name
   end

   b            = {}
   local msgHdr = ""
   if (system_name) then
      msgHdr = i18n("lmodSystemName",{name = system_name})
   end

   if (#a > 0) then
      b[#b+1]  = i18n("namedCollList",{msgHdr = msgHdr})
      local ct = ColumnTable:new{tbl=a,gap=0,width=cwidth}
      b[#b+1]  = ct:build_tbl()
      b[#b+1]  = "\n"
      shell:echo(concatTbl(b,""))
   else
      io.stderr:write(i18n("m_No_Named_Coll",{}))
   end
end

--------------------------------------------------------------------------
-- Point users to either spider or keyword
function SearchCmd(...)
   LmodMessage{msg="m_No_Search_Cmd", s = concatTbl({...}, " ")}
end

--------------------------------------------------------------------------
-- Use the show mode of MasterControl to list the active Lmod
-- commands in a module file.  Note that it is always in Lua
-- even if the modulefile is written in TCL.
function Show(...)
   local master = Master:singleton()
   local banner = Banner:singleton()
   dbg.start{"Show(", concatTbl({...},", "),")"}

   mcp = MasterControl.build("show")
   local borderStr = banner:border(0)

   _G.prtHdr     = function()
                     local a = {}
                     a[#a+1] = borderStr
                     a[#a+1] = "   "
                     a[#a+1] = _G.ModuleFn
                     a[#a+1] = ":\n"
                     a[#a+1] = borderStr
                     return concatTbl(a,"")
                  end
   master:access(...)
   dbg.fini("Show")
end

--------------------------------------------------------------------------
-- Do a level 0 spider report if there are no command line
-- arguments.  Otherwise do a spider search to generate a
-- level 1 or level 2 report on particular modules.
function SpiderCmd(...)
   dbg.start{"SpiderCmd(", concatTbl({...},", "),")"}
   local cache       = Cache:singleton{buildCache=true}
   local shell       = _G.Shell
   local masterTbl   = masterTbl()
   local spiderT,dbT = cache:build()
   local spider      = Spider:new()
   local argA        = pack(...)
   local s
   local srch


   if (argA.n < 1) then
      s = spider:Level0(dbT)
   else
      local a       = {}
      local helpFlg = false
      for i = 1, argA.n-1 do
         a[#a+1] = spider:spiderSearch(dbT, argA[i], helpFlg)
      end
      a[#a+1] = spider:spiderSearch(dbT, argA[argA.n], true)
      s = concatTbl(a,"")
   end
   if (masterTbl.terse) then
      shell:echo(s.."\n")
   else
      local a = {}
      a[#a+1] = s
      a = hook.apply("msgHook","spider",a)
      s = concatTbl(a,"")
      shell:echo(s)
   end
   dbg.fini("SpiderCmd")
end

--------------------------------------------------------------------------
--  Swap one module for another.  That is unload the first
--  and load the second.  If the second modulefile is successfully
--  loaded then it is registered with MT so that it won't be
--  reported in a swap message.
function Swap(...)
   local a = select(1, ...) or ""
   local b = select(2, ...) or ""
   local s = {}

   dbg.start{"Swap(",concatTbl({...},", "),")"}

   local n = select("#", ...)
   if (n ~= 2) then
      b = a
   end

   local mt    = FrameStk:singleton():mt()
   local mname = MName:new("mt", a)
   local sn    = mname:sn()
   if (not mt:have(sn,"any")) then
      LmodError{msg="e_Swap_Failed", name = a}
   end

   local mA      = {}
   local mcp_old = mcp
   mcp           = MCP
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   mA[1]         = mname
   mcp:unload(mA)
   mA[1]         = MName:new("load",b)
   local status = mcp:load_usr(mA)
   if (not status) then
      mcp.mustLoad()
   end

   ------------------------------------------------------
   -- Register user loads so that Karl will be happy.

   mname       = mA[1]
   sn          = mname:sn()
   local usrN  = (not masterTbl().latest) and b or mt:fullName(sn)
   mt:userLoad(sn,usrN)
   mcp = mcp_old
   dbg.print{"Setting mcp to ", mcp:name(),"\n"}
   dbg.fini("Swap")
end

--------------------------------------------------------------------------
--  list the loaded modules in a lua table
function TableList()
   dbg.start{"TableList()"}
   local mt  = FrameStk:singleton():mt()

   local t = {}
   local activeA = mt:list("short","active")
   for i,v  in ipairs(activeA) do
      local mname   = MName:new("mt",v)
      local sn      = mname:sn()
      local version = mname:version() or ""
      dbg.print{"sn: ",sn,", version: ",version,"\n"}
      t[sn] = version
   end
   local s = serializeTbl{name="activeList",indent=true, value=t}
   io.stderr:write(s,"\n")
   dbg.fini()
end

--------------------------------------------------------------------------
-- Disable a collection
function Disable(...)
   local shell = _G.Shell
   local path  = pathJoin(os.getenv("HOME"), LMODdir)
   local argA  = pack(...)
   local sname = (not system_name) and "" or "." .. system_name

   if (argA.n == 0) then
      argA[1] = "default"
      argA.n  = 1
   end

   for i = 1,argA.n do
      local name  = argA[i]
      local fn    = pathJoin(path,name .. sname)
      local fnNew = fn .. "~"
      os.rename(fn, fnNew)
      shell:echo(i18n("m_Collection_disable",{name=name}))
   end
end
   

--------------------------------------------------------------------------
--  Reload all modules.
function Update()
   local master = Master:singleton()
   master:reloadAll()
end

--------------------------------------------------------------------------
--  Add a directory to MODULEPATH and LMOD_DEFAULT_MODULEPATH.
--  Note that this causes all the modules to be reviewed and
--  possibly reloaded if a module.
function Use(...)
   dbg.start{"Use(", concatTbl({...},", "),")"}
   local mt  = FrameStk:singleton():mt()
   local a = {}
   local mcp_old = mcp
   local mcp     = MCP
   local op = mcp.prepend_path

   local argA     = pack(...)
   local iarg     = 1
   local priority = 0

   dbg.print{"using mcp: ",mcp:name(), "\n"}

   while (iarg <= argA.n) do
      local v = argA[iarg]
      local w = v:lower()
      if (w == "-a" or w == "--append" ) then
         op = mcp.append_path
      elseif (w == "--priority") then
         iarg     = iarg + 1
         priority = tonumber(argA[iarg])
      else
         a[#a + 1] = v
      end
      iarg = iarg + 1
   end
   for _,v in ipairs(a) do
      op(mcp, { ModulePath,  v, delim = ":", nodups=true, priority=priority })
   end

   local master    = Master:singleton()
   if (mt:changeMPATH()) then
      mt:reset_MPATH_change_flag()
      master.reloadAll()
   end
   mcp = mcp_old
   dbg.fini("Use")
end

--------------------------------------------------------------------------
--  Remove a directory from both MODULEPATH and
--  LMOD_DEFAULT_MODULEPATH.  Note that all currently loaded
--  modules reviewed and possibly reloaded or made inactive.
function UnUse(...)
   dbg.start{"UnUse(", concatTbl({...},", "),")"}
   local mt     = FrameStk:singleton():mt()
   local argA   = pack(...)
   local nodups = true
   for i = 1, argA.n do
      local v = argA[i]
      MCP:remove_path{ModulePath,  v, delim=":", nodups = true, force = true}
   end
   if (mt:changeMPATH()) then
      mt:reset_MPATH_change_flag()
      master.reloadAll()
   end
   dbg.fini("UnUse")
end

--------------------------------------------------------------------------
-- Unload all requested modules
function UnLoad(...)
   dbg.start{"UnLoad(",concatTbl({...},", "),")"}
   MCP:unload_usr(MName:buildA("mt", ...))
   dbg.fini("UnLoad")
end

--------------------------------------------------------------------------
-- Run whatis on all request modules given the the command line.
function Whatis(...)
   prtHdr    = function () return "" end
   Access("whatis",...)
end
