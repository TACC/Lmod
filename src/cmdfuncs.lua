-------------------------------------------------------------------------
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
local Hub          = require('Hub')
local MName        = require("MName")
local MRC          = require("MRC")
local Spider       = require("Spider")
local Version      = require("Version")
local concatTbl    = table.concat
local cosmic       = require("Cosmic"):singleton()
local dbg          = require("Dbg"):dbg()
local getenv       = os.getenv
local hook         = require("Hook")
local i18n         = require("i18n")
local lfs          = require("lfs")
local sort         = table.sort
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack  -- luacheck: compat
local unpack       = (_VERSION == "Lua 5.1") and unpack or table.unpack  -- luacheck: compat


--------------------------------------------------------------------------
-- Both Help and Whatis functions funnel their actions through
-- the Access function. MC_Access defines real functions for both M.help
-- and M.access.  The mcp.accessMode function activates one or the other
-- depending on what mode Access is called with.
-- @param mode Whether this function has be called via *Help* or *Whatis*.
local function l_Access(mode, ...)
   local hub       = Hub:singleton()
   local shell     = _G.Shell
   local optionTbl = optionTbl()
   dbg.start{"l_Access(", concatTbl({...},", "),")"}
   mcp = MainControl.build("access", mode)
   mcp:setAccessMode(mode,true)

   local n = select('#',...)
   if (n < 1) then
      shell:echo(optionTbl.cmdHelpMsg, "\n", Usage(), "\n", version())
      dbg.fini("l_Access")
      return
   end

   hub:access(...)
   mcp:setAccessMode(mode,false)
   dbg.fini("l_Access")
end

--------------------------------------------------------------------------
-- This helper function walks the Collection directories and reports back
-- the list of named collections. Note that names that start with "."
-- or end with "~" or start with "__" are ignored.
-- @param a An array containing the results.
-- @param path The Lmod.d directory path.
local function l_findNamedCollections(a,pathA)
   local system_name  = cosmic:value("LMOD_SYSTEM_NAME")
   local t            = {}
   for i = 1,#pathA do
      repeat
         local path = pathA[i]
         if (not isDir(path)) then break end
         for file in lfs.dir(path) do
            if (file:sub(1,1) ~= "." and file:sub(-1) ~= "~" and
                file:sub(1,2) ~= "__") then
               local f    = pathJoin(path,file)
               local attr = lfs.attributes(f)
               if (attr and attr.mode == "directory") then
                  l_findNamedCollections(a,{f})
               else
                  local idx    = file:find("%.")
                  local accept = (not idx) and (not system_name)
                  if (idx and system_name) then
                     accept    = file:sub(idx+1,-1) == system_name
                     f         = pathJoin(path, file:sub(1,idx-1))
                  end
                  if (accept) then
                     t[file] = attr.modification
                  end
               end
            end
         end
      until (true)
   end
   if (next(t) ~= nil) then
      for k in pairsByKeys(t) do
         a[#a+1] = k
      end
      table.sort(a)
   end
end

------------------------------------------------------------------------
-- Just convert the vararg into an actual array and call
-- hub.avail to do the real work.
function Avail(...)
   local shell = _G.Shell
   local a     = hub:avail(pack(...))
   if (next(a) ~= nil) then
      shell:echo(concatTbl(a,""))
   end
end

------------------------------------------------------------------------
function Category(...)
   dbg.start{"Category(", concatTbl({...},", "),")"}
   local shell = _G.Shell
   local mrc   = MRC:singleton()

   mrc:set_display_mode("spider")

   local cache = Cache:singleton{buildCache = true}
   local moduleT, dbT = cache:build()

   local categoryT = {}

   local function add_module(cat, name)
      if (cat == "") then return
      elseif (categoryT[cat] == nil) then
         dbg.print{"found new category: ", cat, "\n"}
         categoryT[cat] = {}
      end

      if (not categoryT[cat][name]) then
         dbg.print{"found new sn: ", name, " in category: ", cat, "\n"}
         categoryT[cat][name] = 1
      else
         categoryT[cat][name] = categoryT[cat][name] + 1
      end
   end

   for sn, v in pairs(dbT) do
      for _, info in pairs(v) do
         local category = info.Category or ""

         for entry in category:split(",") do
            entry = entry:trim()
            add_module(entry, sn)
         end
      end
   end

   local masterTbl = masterTbl()
   local search = ... and true
   local twidth = TermWidth()
   local cwidth = masterTbl.rt and LMOD_COLUMN_TABLE_WIDTH or twidth
   local banner = Banner:singleton()

   local a = {}

   if (not search) then
      dbg.print{"printing category block\n"}
      a[#a+1] = "\n"
      a[#a+1] = [[
To get a list of every module in a category execute:
   $ module category Foo
      ]]
      a[#a+1] = "\n"
      a[#a+1] = banner:bannerStr("List of Categories")
      a[#a+1] = "\n"

      local b = {}
      for cat, _ in pairsByKeys(categoryT) do
         b[#b+1] = cat
      end

      b = hook.apply("category", "simple", b) or b

      local ct = ColumnTable:new{tbl=b, gap=2, len=length, width = cwidth-5}
      a[#a+1] = ct:build_tbl()
      a[#a+1] = "\n"
   else
      local argA = pack(...)
      local searchA = {}

      for i = 1, argA.n do
         searchA[i] = argA[i]:caseIndependent()
      end
      searchA.n = argA.n

      local match = hook.apply("category", "complex", categoryT) or {}

      if (next(match) == nil) then
         for cat, v in pairsByKeys(categoryT) do
            for i = 1, searchA.n do
               if (cat:find(searchA[i])) then
                  match[cat] = v
               end
            end
         end
      end

      a[#a+1] = "\n"
      a[#a+1] = [[
To learn more about a package and how to load it execute:
   $ module spider Bar
      ]]

      if (next(match) == nil) then
         a[#a+1] = "\n"
         a[#a+1] = "No matching category found."
         a[#a+1] = "\n"
      end

      for cat, v in pairsByKeys(match) do
         local b = {}

         for sn, count in pairsByKeys(v) do
            b[#b+1] = { sn, "(" .. tostring(count) .. ")  " }
         end

         dbg.print{"printing category block\n"}
         local ct = ColumnTable:new{tbl = b, gap = 1, len = length, width = cwidth}
         a[#a+1] = "\n"
         a[#a+1] = banner:bannerStr(cat)
         a[#a+1] = "\n"
         a[#a+1] = ct:build_tbl()
         a[#a+1] = "\n"
      end
   end

   if (next(a) ~= nil) then
      shell:echo(concatTbl(a, ""))
   end
   dbg.fini("Category")
end

------------------------------------------------------------------------
-- Just convert the vararg into an actual array and call
-- hub.overview to do the real work.

function Overview(...)
   local shell = _G.Shell
   local a     = hub:overview(pack(...))
   if (next(a) ~= nil) then
      shell:echo(concatTbl(a,""))
   end
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

   l_Access("help",...)
end

function IsAvail(...)
   local mrc  = MRC:singleton()
   mrc:set_display_mode("avail")

   local argA = pack(...)
   for i = 1, argA.n do
      local mname = MName:new("load", argA[i])
      if (not mname:valid()) then
         setStatusFlag()
         break
      end
   end
end

function IsLoaded(...)
   local mrc  = MRC:singleton()
   mrc:set_display_mode("avail")

   local argA = pack(...)
   for i = 1, argA.n do
      local mname = MName:new("mt", argA[i])
      if (not mname:isloaded()) then
         setStatusFlag()
         break
      end
   end
end

--------------------------------------------------------------------------
-- Use the list of user requested keywords to be searched
-- through the spider cache.
function Keyword(...)
   dbg.start{"Keyword(",concatTbl({...},","),")"}

   local mrc                    = MRC:singleton(); mrc:set_display_mode("spider")
   local banner                 = Banner:singleton()
   local border                 = banner:border(0)
   local shell                  = _G.Shell
   local cache                  = Cache:singleton{buildCache=true}
   local moduleT,dbT,
         mpathMapT, providedByT = cache:build()
   local spider                 = Spider:new()
   local a                      = {}
   local ia                     = 0
   local optionTbl              = optionTbl()
   local terse                  = optionTbl.terse
   local kywdT,kywdExtsT        = spider:searchSpiderDB(pack(...), dbT, providedByT)

   if (terse) then
      shell:echo(Spider:Level0_terse(kywdT, providedByT))
      dbg.fini("Keyword")
      return
   end

   ia = ia+1; a[ia] = i18n("keyword_msg",{border=border, module_list = concatTbl({...},"\", \"")})

   dbg.printT("kywdT",kywdT)

   spider:Level0Helper(kywdT,kywdExtsT,a)

   shell:echo(concatTbl(a,""))

   dbg.fini("Keyword")
end

--------------------------------------------------------------------------
-- List the loaded modulefile
function List(...)
   dbg.start{"List(...)"}
   local optionTbl = optionTbl()
   local shell     = _G.Shell
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local kind      = optionTbl.brief and "fullName_Meta" or "fullName"
   local activeA   = mt:list(kind,"active")
   local inactiveA = mt:list(kind,"inactive")
   local total     = #activeA + #inactiveA
   local cwidth    = optionTbl.rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()
   local mrc       = MRC:singleton()

   mrc:set_display_mode("list")

   dbg.print{"#activeA:   ",#activeA,"\n"}
   dbg.print{"#inactiveA: ",#inactiveA,"\n"}
   dbg.print{"kind:       ",kind,"\n"}

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
      if (not optionTbl.regexp) then
         for i = 1, wanted.n do
            wanted[i] = wanted[i]:caseIndependent()
         end
      end
   end

   if (optionTbl.terse) then
      dbg.printT("activeA",activeA)
      for i = 1,#activeA do
         local entry = activeA[i]
         local s = entry.fullName
         if (entry.origUserName) then
            s = s .. "\n" .. entry.origUserName
         end
         dbg.print{"fullName: ",entry.fullName, ", orig: ",entry.origUserName,", s: ",s,"\n"}

         for j = 1, wanted.n do
            local p = wanted[j]
            if (s:find(p)) then
               local aa = {}
               dbg.printT("entry",entry)
               aa[#aa+1] = decorateModule(s, entry, entry.forbiddenT)
               aa[#aa+1] = "\n"
               shell:echo(concatTbl(aa,""))
            end
         end
      end
      dbg.fini("List")
      return
   end

   b[#b+1]            = "\n"
   b[#b+1]            = msg
   b[#b+1]            = msg2
   b[#b+1]            = "\n"
   local kk           = 0
   local legendT      = {}
   local show_hidden  = mrc:show_hidden()
   local have_hiddenL = false

   for i = 1, #activeA do
      local entry    = activeA[i]
      local fullName = entry.fullName
      local origName = entry.origUserName or ""
      local showMe   = true
      if (entry.moduleKindT.hidden_loaded) then
         showMe       = show_hidden
         have_hiddenL = not show_hidden
      end
      for j = 1, wanted.n do
         local p = wanted[j]
         if (showMe and (fullName:find(p) or origName:find(p))) then
            kk = kk + 1
            a[#a + 1] = mt:list_w_property(kk, entry.sn, "short", legendT)
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
   if (have_hiddenL) then
      b[#b+1] = i18n("m_Hidden_loaded")
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
-- Load modules from users. This routine does the work for both
-- Load_Usr() and Load_Try(). If a module name has
-- a minus sign in front of it then unload it.  Do that
-- before loading any other modules.  Also if the
-- shortName of a request module is already loaded then
-- unload it.  This way:
--
--      $ module load foo/1.1; module load foo/1.3
--
-- foo/1.1 will be loaded.  Then loading foo/1.3 will
-- cause foo/1.1 to be unloaded and then Lmod will load foo/1.3.
-- Finally any successful loading of a module is registered
-- with "MT" so that when a user does the above commands
-- it won't get the swap message.

local function l_usrLoad(argA, check_must_load)
   dbg.start{"l_usrLoad(argA, check_must_load: ",check_must_load,")"}
   local frameStk = FrameStk:singleton()
   local mrc      = MRC:singleton()
   mrc:set_display_mode("all")
   local uA   = {}
   local lA   = {}
   for i = 1, argA.n do
      local v = argA[i]
      if (v == "-") then
         LmodMessage{msg="e_Illegal_option",v=v}
         os.exit(1)
      end

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
      local force = false
      unload_usr_internal(uA, force)
   end

   local varT     = frameStk:varT()
   local b
   if (#lA > 0) then
      if (varT[ModulePath] == nil or
          varT[ModulePath]:expand() == false or
          varT[ModulePath]:expand() == "" ) then
         LmodWarning{msg="w_Undef_MPATH"}
      end

      mcpStack:push(mcp)
      mcp           = MCP
      dbg.print{"Setting mcp to ", mcp:name(),"\n"}
      b             = mcp:load_usr(lA)

      if (haveWarnings() and check_must_load) then
         mcp.mustLoad()
      end
      mcp           = mcpStack:pop()
   end

   dbg.fini("l_usrLoad")
   return b
end

------------------------------------------------------------------------
-- Load modules from users but do not issue warnings if the module is
-- not there but failures during load are reported.

function Load_Try(...)
   dbg.start{"Load_Try(",concatTbl({...},", "),")"}
   local check_must_load = false
   local argA            = pack(...)
   l_usrLoad(argA, check_must_load)
   dbg.fini("Load_Try")
end

function Load_Usr(...)
   dbg.start{"Load_Usr(",concatTbl({...},", "),")"}
   local check_must_load = true
   local argA            = pack(...)
   l_usrLoad(argA, check_must_load)
   dbg.fini("Load_Usr")
end

function Purge_Usr()
   dbg.start{"Purge_Usr()"}
   Purge()
   dbg.fini("Purge_Usr")
end


function purgeFlg()
   return s_purgeFlg
end
--------------------------------------------------------------------------
-- Unload all loaded modules.
-- @param force If true then sticky modules are unloaded as well.
function Purge(force)
   dbg.start{"Purge(force = ",force,")"}
   mcp:purge{force=force}
   dbg.fini("Purge")
end

--------------------------------------------------------------------------
-- Reload all loaded modules so that any alias or shell
-- functions are defined.  No other module commands are active.
-- This command exists so that sub-shells will have the aliases
-- defined.
function Refresh()
   dbg.start{"Refresh()"}
   local hub  = Hub:singleton()
   hub:refresh()
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
   local default = cosmic:value("LMOD_SYSTEM_DEFAULT_MODULES")
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
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local oldMpathA = mt:modulePathA()

   -- Change MODULEPATH back to systemBaseMPATH
   frameStk:resetMPATH2system()

   local newMpathA = mt:modulePathA()

   local oldMpathT = {}
   for i = 1, #oldMpathA do
      oldMpathT[oldMpathA[i]] = i
   end

   local b = {}

   for i = 1, #newMpathA do
      oldMpathT[newMpathA[i]] = false
   end

   for k,v in pairs(oldMpathT) do
      if (v) then
         b[#b+1] = {k,v}
      end
   end

   local function cmp(a,b)
      return a[2] < b[2]
   end

   sort(b,cmp)
   local a = {}
   for i = 1,#b do
      a[#a+1] = b[i][1]
   end

   local pathA = "None"
   if (next(a) ~= nil) then
      pathA = concatTbl(a," ")
   end


   dbg.print{"default: \"",default,"\"\n"}

   default = default:trim()
   default = default:gsub(" *, *",":")
   default = default:gsub(" +",":")

   if (msg ~= false and not quiet()) then
      io.stderr:write(i18n("m_Reset_SysDflt",{pathA=pathA}))
   end


   if (default ~= "__NO_SYSTEM_DEFAULT_MODULES__") then
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
end

local function l_collectionDir(mode)
   local a        = {}
   local home     = os.getenv("HOME") or ""
   local dotConfD = pathJoin(home,".config/lmod")
   local dotLmodD = pathJoin(home,".lmod.d")
   if (mode == "write") then
      local configDirOnly = cosmic:value("LMOD_USE_DOT_CONFIG_ONLY")
      if (configDirOnly == "no") then
         a[#a+1] = dotLmodD
      end
      a[#a+1] = dotConfD
   else
      a[#a+1] = dotConfD
      a[#a+1] = dotLmodD
   end
   return a
end



local function l_find_a_collection(collectionName)
   local pathA = l_collectionDir("read")
   local result = nil
   local timeStamp = 0
   for i = 1,#pathA do
      local path = pathJoin(pathA[i], collectionName)
      if (isFile(path)) then
         local attr = lfs.attributes(path)
         if (attr and type(attr) == "table" and attr.modification > timeStamp) then
            timeStamp = attr.modification
            result    = path
         end
      end
   end
   return result
end

--------------------------------------------------------------------------
-- Report the modules in the requested collection
function CollectionLst(collection)
   collection  = collection or "default"
   dbg.start{"CollectionLst(",collection,")"}
   local system_name = cosmic:value("LMOD_SYSTEM_NAME")
   local optionTbl   = optionTbl()
   local sname       = (not system_name) and "" or "." .. system_name
   local mt          = FrameStk:singleton():mt()
   local shell       = _G.Shell
   local cwidth      = optionTbl.rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()
   local path        = l_find_a_collection(collection)

   local a           = mt:reportContents{fn=path, name=collection}
   if (optionTbl.terse) then
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
   collection        = collection or "default"
   dbg.start{"GetDefault(",collection,")"}
   local system_name = cosmic:value("LMOD_SYSTEM_NAME")

   local sname = (not system_name) and "" or "." .. system_name
   local path  = l_find_a_collection(collection .. sname)
   if (not path) then
      LmodError{msg="e_Unknown_Coll", collection = collection}
   end

   local mt    = FrameStk:singleton():mt()
   mt:getMTfromFile{fn=path, name=collection}
   dbg.fini("GetDefault")
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
   local system_name = cosmic:value("LMOD_SYSTEM_NAME")
   local myName      = "default"
   local sname       = system_name
   local msgTail     = ""
   if (not sname) then
      sname   = ""
      myName  = "(empty)"
   else
      msgTail = ", for system: \"".. sname .. "\""
      sname   = "." .. sname
   end

   if (collection == nil) then
      path = l_find_a_collection("default" .. sname)
      if (not path) then
         collection = "system"
         myName = collection
      else
         myName = "default"
      end
   elseif (collection ~= "system") then
      myName = collection
      path   = l_find_a_collection(collection .. sname)
      if (not path) then
         LmodError{msg="e_Unknown_Coll", collection = collection}
      end
   end

   if (barefilename(myName):find("%.")) then
      LmodError{msg="e_No_Period_Allowed", collection = collection}
   end


   local optionTbl = optionTbl()

   if (collection == "system" ) then
      msg = "system default" .. msgTail
   else
      collection = collection or "default"
      msg        = "user's ".. collection .. msgTail
   end

   if (optionTbl.quiet or optionTbl.initial) then
      msg = false
   end

   if (collection == "system" ) then
      Reset(msg)
   else
      local mrc     = MRC:singleton()
      mrc:set_display_mode("all")

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
   local optionTbl = optionTbl()
   local frameStk  = FrameStk:singleton()
   local mt        = frameStk:mt()
   local a         = select(1, ...) or "default"
   local home      = os.getenv("HOME")
   local pathA     = l_collectionDir("write")
   dbg.start{"Save(",concatTbl({...},", "),")"}

   local system_name = cosmic:value("LMOD_SYSTEM_NAME")
   local msgTail     = ""
   local sname       = system_name
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
   local force   = optionTbl.force
   if (#activeA == 0 and not force) then
      LmodWarning{msg="w_Save_Empty_Coll",name=a}
      dbg.fini("Save")
      return
   end

   mt:setHashSum()
   local varT = frameStk:varT()
   mt:setMpathRefCountT(varT[ModulePath]:refCountT())

   local date = os.date()
   for i = 1,#pathA do
      local path = pathA[i]
      local attr = lfs.attributes(path)
      if (not attr) then
         mkdir_recursive(path)
      end
      local fn = pathJoin(path, a .. sname)
      if (isFile(fn)) then
         os.rename(fn, fn .. "~")
      end
      local f  = io.open(fn,"w")
      if (f) then
         f:write("-- -*- lua -*-\n")
         f:write("-- created: ",date," --\n")
         local s0 = "-- Lmod ".. Version.name() .. "\n"
         local s1 = mt:serializeTbl("pretty")
         f:write(s0,s1)
         f:close()
      end
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
   local mt          = FrameStk:singleton():mt()
   local optionTbl   = optionTbl()
   local a           = {}
   local b           = {}
   local shell       = _G.Shell
   local cwidth      = optionTbl.rt and LMOD_COLUMN_TABLE_WIDTH or TermWidth()
   local home        = os.getenv("HOME")
   local pathA       = l_collectionDir("read")
   local system_name = cosmic:value("LMOD_SYSTEM_NAME")

   l_findNamedCollections(b,pathA)
   if (optionTbl.terse) then
      for k = 1,#b do
         local name = b[k]
         shell:echo(name.."\n")
      end
      return
   end


   for k = 1,#b do
      local name = b[k]
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
-- Use the show mode of MainControl to list the active Lmod
-- commands in a module file.  Note that the output is always in Lua
-- even if the modulefile is written in TCL.
function Show(...)
   local hub = Hub:singleton()
   local banner = Banner:singleton()
   dbg.start{"Show(", concatTbl({...},", "),")"}

   mcp = MainControl.build("show")
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
   local exit = os.exit
   sandbox_set_os_exit(show_exit)
   hub:access(...)
   os.exit = exit
   dbg.fini("Show")
end

--------------------------------------------------------------------------
-- Do a level 0 spider report if there are no command line
-- arguments.  Otherwise do a spider search to generate a
-- level 1 or level 2 report on particular modules.
function SpiderCmd(...)
   dbg.start{"SpiderCmd(", concatTbl({...},", "),")"}
   local mrc                    = MRC:singleton() ; mrc:set_display_mode("spider")
   local cache                  = Cache:singleton{buildCache=true}
   local shell                  = _G.Shell
   local optionTbl              = optionTbl()
   local spiderT,dbT,
         mpathMapT, providedByT = cache:build()
   local spider                 = Spider:new()
   local argA                   = pack(...)
   local s
   local srch


   if (argA.n < 1) then
      s = spider:Level0(dbT, providedByT)
   else
      local a       = {}
      for i = 1, argA.n do
         a[#a+1] = spider:spiderSearch(dbT, providedByT, argA[i], i == argA.n)
      end
      s = concatTbl(a,"")
   end
   if (optionTbl.terse) then
      shell:echo(s.."\n")
   else
      local a = {}
      a[#a+1] = s
      a = hook.apply("msgHook","spider",a) or a
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
   local a  = select(1, ...) or ""
   local b  = select(2, ...) or ""
   local s  = {}
   local mt = FrameStk:singleton():mt()

   dbg.start{"Swap(",concatTbl({...},", "),")"}

   local n = select("#", ...)
   if (n ~= 2) then
      b = a
      -- Trim any version info from a
      local sn_match, sn = mt:find_possible_sn(a)
      a = sn
   end

   local mname = MName:new("mt", a)
   local sn    = mname:sn()
   if (not mt:have(sn,"any")) then
      LmodError{msg="e_Swap_Failed", name = a}
   end

   local mA      = {mname}

   local force   = false
   unload_internal(mA, force)
   mA[1]         = MName:new("load",b)
   local status = mcp:load_usr(mA)
   if (not status) then
      mcp.mustLoad()
   end

   ------------------------------------------------------
   -- Register user loads so that Karl will be happy.

   mname       = mA[1]
   sn          = mname:sn()
   local usrN  = (not optionTbl().latest) and b or mt:fullName(sn)
   mt:userLoad(sn,usrN)
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
   local shell       = _G.Shell
   local pathA       = l_collectionDir("read")
   local argA        = pack(...)
   local system_name = cosmic:value("LMOD_SYSTEM_NAME")
   local sname       = (not system_name) and "" or "." .. system_name

   if (argA.n == 0) then
      argA[1] = "default"
      argA.n  = 1
   end

   for i = 1,argA.n do
      local name  = argA[i]
      shell:echo(i18n("m_Collection_disable",{name=name}))
      for j = 1,#pathA do
         local path  = pathA[j]
         local fn    = pathJoin(path,name .. sname)
         local fnNew = fn .. "~"
         os.rename(fn, fnNew)
      end
   end
end


--------------------------------------------------------------------------
--  Reload all modules.
function Update()
   local mrc = MRC:singleton(); mrc:set_display_mode("all")
   local hub = Hub:singleton()
   local force_update = true
   hub:reloadAll(force_update)
end

--------------------------------------------------------------------------
--  Add a directory to MODULEPATH and LMOD_DEFAULT_MODULEPATH.
--  Note that this causes all the modules to be reviewed and
--  possibly reloaded if a module.
function Use(...)
   dbg.start{"Use(", concatTbl({...},", "),")"}
   local mt       = FrameStk:singleton():mt()
   local a        = {}
   --local mcp_old  = mcp
   --local mcp      = MCP
   mcpStack:push(mcp)
   mcp            = MCP

   local op       = mcp.prepend_path

   local argA     = pack(...)
   local iarg     = 1
   local priority = 0

   local mrc      = MRC:singleton()
   mrc:set_display_mode("all")

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
      -- Produce warning if leading minus sign(s) are found.
      if (v:find("^-+")) then
         LmodWarning{msg="w_Possible_Bad_Dir",dir=v}
      end

      if (v:sub(1,1) ~= '/') then
         local old = v
         -- If relative convert to try to convert to absolute path
         v         = realpath(v)
         -- If it doesn't exist then build path with current directory and relative path.
         if (not v) then
            v = pathJoin(posix.getcwd(), old)
         end
      end
      op(mcp, { ModulePath,  v, delim = ":", nodups=true, priority=priority })
   end

   local hub    = Hub:singleton()
   if (mt:changeMPATH()) then
      mt:reset_MPATH_change_flag()
      hub.reloadAll()
   end
   --mcp = mcp_old
   mcp = mcpStack:pop()
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

   local mrc    = MRC:singleton();
   mrc:set_display_mode("all")

   for i = 1, argA.n do
      local v = argA[i]
      MCP:remove_path{ModulePath,  v, delim=":", nodups = true, force = true}
   end
   if (mt:changeMPATH()) then
      mt:reset_MPATH_change_flag()
      hub.reloadAll()
   end
   dbg.fini("UnUse")
end

--------------------------------------------------------------------------
-- Unload all requested modules
function UnLoad(...)
   dbg.start{"UnLoad(",concatTbl({...},", "),")"}
   local force = false
   unload_usr_internal(MName:buildA("mt", pack(...)), force)
   mcp:mustLoad()
   dbg.fini("UnLoad")
end

--------------------------------------------------------------------------
-- Run whatis on all request modules given the the command line.
function Whatis(...)
   prtHdr    = function () return "" end
   l_Access("whatis",...)
end
