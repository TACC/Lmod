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

--------------------------------------------------------------------------
-- utils.lua:  This is the file that has miscellaneous utility functions.
--------------------------------------------------------------------------


require("strict")
require("fileOps")
require("string_utils")
require("parseVersion")
require("capture")

local Version   = require("Version")
local base64    = require("base64")
local dbg       = require("Dbg"):dbg()
local lfs       = require("lfs")
local posix     = require("posix")

local concatTbl = table.concat
local decode64  = base64.decode64
local floor     = math.floor
local format    = string.format
local getenv    = os.getenv
local huge      = math.huge

local rep       = string.rep
local T0        = os.time()
local load      = (_VERSION == "Lua 5.1") and loadstring or load

--------------------------------------------------------------------------
-- abspath(): find true path through symlinks.

function abspath_localdir (path)
   if (path == nil) then return nil end
   local cwd = lfs.currentdir()
   path = path:trim()

   if (path:sub(1,1) ~= '/') then
      path = pathJoin(cwd,path)
   end

   local dir    = dirname(path)
   local ival   = lfs.chdir(dir)

   local cdir   = lfs.currentdir()
   if (cdir == nil) then
      dbg.print{"lfs.currentdir(): is nil"}
   end

   dir          = cdir or dir


   path = pathJoin(dir, barefilename(path))
   local result = path

   local attr = lfs.symlinkattributes(path)
   if (attr == nil) then
      lfs.chdir(cwd)
      return nil
   elseif (attr.mode == "link") then
      local rl = posix.readlink(path)
      dbg.print{"path: ",path,", rl: ",rl,"\n"}
      if (not rl) then
         lfs.chdir(cwd)
         return nil
      end
      if (rl:sub(1,1) == "/" or rl:sub(1,3) == "../") then
         lfs.chdir(cwd)
         return result
      end
      if (rl:sub(1,1) == ".") then
         lfs.chdir(cwd)
         return result
      end
      result = abspath_localdir(rl)
   end
   lfs.chdir(cwd)
   return result
end

--------------------------------------------------------------------------
-- argsPack():  This is 5.1 Lua function to cover the table.pack function
--              that is in Lua 5.2 and later.

function argsPack(...)
   local arg = { n = select ("#", ...), ...}
   return arg
end
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack


--------------------------------------------------------------------------
-- build_epoch(): This function builds the "epoch" function.  
--                The epoch function returns the number of seconds since
--                Jan 1, 1970, UTC

function build_epoch()
   if (posix.gettimeofday) then
      local x1, x2 = posix.gettimeofday()
      if (x2 == nil) then
         epoch_type = "posix.gettimeofday() (1)"
         epoch = function()
            local t = posix.gettimeofday()
            return (t.sec - T0) + t.usec*1.0e-6
         end
      else
         epoch_type = "posix.gettimeofday() (2)"
         epoch = function()
            local t1, t2 = posix.gettimeofday()
            return (t1 - T0) + t2*1.0e-6
         end
      end
   else
      epoch_type = "os.time"
      epoch = function()
         return os.time() - T0
      end
   end
end

--------------------------------------------------------------------------
-- build_accept_functions(): Create the accept functions to allow or ignore
--                           TCL files.

function build_accept_functions()
   local allow_tcl = LMOD_ALLOW_TCL_MFILES:lower()

   if (allow_tcl == "no") then
      dbg.print{"Ignoring TCL Files\n"}
      _G.accept_fn = function (fn)
         return fn:find("%.lua$")
      end
      _G.accept_extT = function ()
         return { '.lua' }
      end

   else
      dbg.print{"Accepting TCL Files\n"}
      _G.accept_fn = function (fn)
         return true
      end
      _G.accept_extT = function ()
         return { '.lua', '' }
      end
   end
end

--------------------------------------------------------------------------
-- case_independent_cmp(): What it says.

function case_independent_cmp(a,b)
   local a_lower = a:lower()
   local b_lower = b:lower()

   if (a_lower  == b_lower ) then
      return a < b
   else
      return a_lower < b_lower
   end
end


--------------------------------------------------------------------------
-- expert(): Are we in expert mode?
local __expert = false
function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end

--------------------------------------------------------------------------
-- quiet(): Are we in quiet mode?
local __quiet = false
function quiet()
   if (__quiet == false) then
      __quiet = getenv("LMOD_QUIET") or getenv("LMOD_EXPERT")
   end
   return __quiet
end

--------------------------------------------------------------------------
-- extractVersion(): Compare the full name of a modulefile with the
--                   shortname. Return nil if the shortname and full name
--                   are the same.

function extractVersion(full, sn)
   if (not full or not sn) then
      return nil
   end

   local i, j = full:find('.*/')

   if (not i) then
      return nil
   end


   full = full:sub(1,j):lower() .. full:sub(j+1,-1)
   sn   = sn:lower()

   local pat     = '^' .. escape(sn) .. '/?'
   local version = full:gsub(pat,"")
   if (version == "") then
      version = nil
   end
   return version
end

-- This table must be include file names that are 8 characters or less.
-- The MT:locationTblDir routine uses it.
s_ignoreT = {
   ['.']         = true,
   ['..']        = true,
   ['CVS']       = true,
   ['.git']      = true,
   ['.svn']      = true,
   ['.hg']       = true,
   ['.bzr']      = true,
   ['.moduler']  = true,
   ['.DS_Stor']  = true,
   ['.version']  = true,
   ['.DS_Store'] = true,
   ['.modulerc'] = true,
}


function ignoreFileT()
   local fileT = s_ignoreT
   return fileT
end



--------------------------------------------------------------------------
-- getMT(): Ask the environment for the _ModuleTable_ value.
--          It is uuencoded and broken into pieces so that the
--          quotes and parens won't confuse the shell's poor little
--          brain.  The number of pieces are stored in the global
--          env. variable _ModuleTable_Sz_.

function getMT()
   local a    = {}
   local mtSz = getenv("_ModuleTable_Sz_") or huge
   local s    = nil

   for i = 1, mtSz do
      local name = format("_ModuleTable%03d_",i)
      local v    = getenv(name)
      if (v == nil) then break end
      a[#a+1]    = v
   end
   if (#a > 0) then
      s = decode64(concatTbl(a,""))
   end
   return s
end

function allVersions(pathA, n)
   local lastKey   = ''
   local lastValue = ''
   local result    = nil
   local fullName  = nil
   local count     = 0
   local a         = {}
   local n         = n or #pathA
   local accept_fn = accept_fn

   for i = 1, n do
      local vv   = pathA[i]
      local path = vv.file
      local attr = lfs.attributes(path)
      if (attr and attr.mode == 'directory' and posix.access(path,"x")) then
         for v in lfs.dir(path) do
            local f = pathJoin(path, v)
            attr    = lfs.attributes(f)
            local readable = posix.access(f,"r") and accept_fn(f)
            if (readable and v:sub(1,1) ~= "." and attr.mode == 'file'
                and v:sub(-1,-1) ~= '~') then
               v       = v:gsub("%.lua$","")
               local pv = parseVersion(v)
               a[#a+1] = {version=v, file=f, idx = i, mpath=vv.mpath, pv=pv}
            end
         end
      end
   end
   return a
end

function indexPath(old, oldA, new, newA)
   dbg.start{"indexPath(",old, ", ", new,")"}
   local oldN = #oldA
   local newN = #newA
   local idxM = newN - oldN + 1

   dbg.print{"oldN: ",oldN,", newN: ",newN,"\n"}

   if (oldN >= newN or newN == 1) then
      if (old == new) then
         dbg.fini("(1) indexPath")
         return 1
      end
      dbg.fini("(2) indexPath")
      return -1
   end

   local icnt = 1

   local idxO = 1
   local idxN = 1

   while (true) do
      local oldEntry = oldA[idxO]
      local newEntry = newA[idxN]

      icnt = icnt + 1
      if (icnt > 5) then
         break
      end


      if (oldEntry == newEntry) then
         idxO = idxO + 1
         idxN = idxN + 1

         if (idxO > oldN) then break end
      else
         idxN = idxN + 2 - idxO
         idxO = 1
         if (idxN > idxM) then
            dbg.fini("indexPath")
            return -1
         end
      end
   end

   idxN = idxN - idxO + 1

   dbg.print{"idxN: ", idxN, "\n"}

   dbg.fini("indexPath")
   return idxN

end

---------------------------------------------------------------------------
-- lastFileInPathA(path): This function finds the latest version of a package
--                        in the directory "path".  It uses the parseVersion()
--                        function to decide which version is the most recent.
--                        It is not a lexigraphical search but uses rules built
--                        into parseVersion().


function lastFileInPathA(pathA, n)
   local lastKey   = ''
   local lastValue = ''
   local result    = nil
   local fullName  = nil
   local a         = allVersions(pathA, n)
   local count     = #a

   for i = 1, count do
      local vv  = a[i]
      if (vv.pv > lastKey) then
         lastKey   = vv.pv
         lastValue = vv
      end
   end
   if (lastKey ~= "") then
      result     = lastValue
   end
   return result, count
end

--------------------------------------------------------------------------
-- length(): compute the length of a string and ignore any string
--           colorization.

function length(s)
   s = s:gsub("\027[^m]+m","")
   return s:len()
end

--------------------------------------------------------------------------
-- masterTbl(): Manage the Master Hash Table.  The command line arguments
--              and the ModuleStack (when using Spider) are stored here.

s_masterTbl = {}
function masterTbl()
   return s_masterTbl
end

--------------------------------------------------------------------------
-- path2pathA(): This function takes a path like variable and breaks
--               it up into an array.  Each path component is
--               standandized by path_regularize().  This function
--               removes leading and trailing spaces and duplicate '/'
--               etc.
--
--               Typically the separator is a colon but it can be
--               anything.  Some env. vars (such as TEXINPUTS and
--               LUA_PATH) use "::" or ";;" to mean that the
--               specified values are prepended to the system ones.
--               To handle that, the path component is converted to
--               a single space.  This single space is later removed
--               when expanding.

function path2pathA(path, sep)
   sep = sep or ":"
   if (not path) then
      return {}
   end
   if (path == '') then
      return { ' ' }
   end

   local is, ie

   -- remove leading and trailing sep
   if (path:sub(1,1) == sep) then
      is = 2
   end
   if (path:sub(-1,-1) == sep) then
      ie = -2
   end
   if (is) then
      path = path:sub(is,ie)
   end

   local pathA = {}
   for v  in path:split(sep) do
      pathA[#pathA + 1] = path_regularize(v)
   end

   return pathA
end

--------------------------------------------------------------------------
--  Read the admin.list file.  It is a Key value pairing of module names
--  and a message.  The module names can be either the full name or the file
--  name.  The message can be multi-line.  A blank line is signifies the
--  end of the message.
--
--  /path/to/modulefile: Blah Blah Blah
--                       Blah Blah Blah
--
--  module/version:      Blah Blah Blah
--                       Blah Blah Blah
--

function findAdminFn()
   local readable    = "no"
   local adminFn     = getenv("LMOD_ADMIN_FILE") or pathJoin(cmdDir(),"../../etc/admin.list")
   local dirName, fn = splitFileName(adminFn)
   if (isDir(dirName)) then
      local cwd      = posix.getcwd()
      posix.chdir(dirName)
      dirName = posix.getcwd()
      adminFn = pathJoin(dirName, fn)
      posix.chdir(cwd)
      if (posix.access(adminFn, 'r')) then
         readable = "yes"
      end
   end
   
   return adminFn, readable
end


function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminT)) then return end

   local adminFn = findAdminFn()
   local f       = io.open(adminFn,"r")

   -- Put something in adminT so that this routine will not be
   -- run again even if the file does not exist.
   adminT["foo"] = "bar"

   if (f) then
      local whole = f:read("*all") .. "\n"
      f:close()

      -- Parse file: ignore "#" comment lines and blank lines
      -- Split lines on ":" module:message

      local state = "init"
      local key   = "unknown"
      local value = nil
      local a     = {}

      for v in whole:split("\n") do

         v = v:trim()

         if (v:sub(1,1) == "#") then
            -- ignore this comment line


         elseif (v:find("^%s*$")) then
            if (state == "value") then
               value       = concatTbl(a, " ")
               a           = {}
               adminT[key] = value
               state       = "init"
            end

            -- Ignore blank lines
         elseif (state == "value") then
            a[#a+1]     = v:trim()
         else
            local i     = v:find(":")
            if (i) then
               key      = v:sub(1,i-1):trim()
               local  s = v:sub(i+1):trim()
               if (s:len() > 0) then
                  a[#a+1]  = s
               end
               state    = "value"
            end
         end
      end
   end
end

--------------------------------------------------------------------------
-- readRC(): read in the system and possible a user lmod configuration file.
--           The system one is read first.  These provide default value
--           The user one can override the default values.

local s_readRC     = false
RCFileA = {
   pathJoin(cmdDir(),"../init/lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/lmodrc.lua"),
   pathJoin(getenv("HOME"),".lmodrc.lua"),
   os.getenv("LMOD_RC"),
}

function readRC()
   dbg.start{"readRC()"}
   if (s_readRC) then
      s_readRC = true
      return
   end

   declare("propT",       false)
   declare("scDescriptT", false)

   for i = 1,#RCFileA do
      local f        = RCFileA[i]
      local fh = io.open(f)
      if (fh) then
         assert(loadfile(f))()
         s_rcFileA[#s_rcFileA+1] = abspath(f)
         fh:close()
      end
      local propT       = _G.propT or {}
      local scDescriptT = _G.scDescriptT   or {}
      for k,v in pairs(propT) do
         s_propT[k] = v
      end
      for k,v in pairs(scDescriptT) do
         s_scDescriptT[k] = v
      end
   end
   dbg.fini("readRC")
end

function getPropT()
   return s_propT
end

function getSCDescriptT()
   return s_scDescriptT
end

function getRCFileA()
   return s_rcFileA
end

local function arg2str(v)
   if (v == nil) then return v end
   local s = tostring(v)
   if (type(v) ~= "boolean") then
      s = "\"".. s .."\""
   end
   return s
end

--------------------------------------------------------------------------
-- ShowCmdStr(): Build a string of what the command would be. Used by
--               MC_Show and MC_ComputeHash.

defaultsT = {
   delim    = ":",
   priority = "0",
}


function ShowCmdStr(name, ...)
   local a       = {}
   local arg     = pack(...)
   local n       = arg.n
   local t       = arg
   local hasKeys = false
   local left    = "("
   local right   = ")\n"
   if (arg.n == 1 and type(arg[1]) == "table") then
      t       = arg[1]
      n       = #t
      hasKeys = true
   end
   for i = 1, n do
      local s = arg2str(t[i])
      if (s ~= nil) then
         a[#a + 1] = s
      end
   end

   if (hasKeys) then
      hasKeys = false
      for k,v in pairs(t) do
         if (type(k) ~= "number") then
            local strV = tostring(v)
            if (defaultsT[k] ~= strV) then
               hasKeys = true
               a[#a+1] = k.."="..arg2str(v)
            end
         end
      end
   end

   if (hasKeys) then
      left    = "{"
      right   = "}\n"
   end

   local b = {}
   b[#b+1] = name
   b[#b+1] = left
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = right 
   return concatTbl(b,"")
end

function ShowCmdA(name, mA)
   local a = {}
   for i = 1, #mA do
      a[i] = mA[i]:show()
   end
   local b = {}
   b[#b+1] = name
   b[#b+1] = "("
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = ")\n"
   return concatTbl(b,"")
end



--------------------------------------------------------------------------
-- UUIDString(epoch): Unique string that combines the current time/date
--                    with a uuid id string.

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
modV = false

function moduleRCFile(current, path)
   dbg.start{"moduleRCFile(",path,")"}
   local f       = io.open(path,"r")
   if (not f)                        then
      dbg.print{"could not find: ",path,"\n"}
      dbg.fini("moduleRCFile")
      return nil
   end
   local s       = f:read("*line")
   f:close()
   if (not s:find("^#%%Module"))      then
      dbg.print{"could not find: #%Module\n"}
      dbg.fini("moduleRCFile")
      return nil
   end
   local cmd = pathJoin(cmdDir(),"RC2lua.tcl") .. " " .. path
   local s = capture(cmd):trim()
   assert(load(s))()
   local version = false
   for i = 1,#modV do
      local entry = modV[i]
      if (entry.module_version == "default") then
         local name = entry.module_name
         local i, j = name:find(current)
         local nLen = name:len()
         if (j+1 < nLen and name:sub(j+1,j+1) == '/') then
            version = name:sub(j+2)
            break
         end
      end
   end

   dbg.print{"version: ",version,"\n"}
   dbg.fini("moduleRCFile")
   return version
   
end
--------------------------------------------------------------------------
-- versionFile(): This routine is given the absolute path to a .version 
--                file.  It checks to make sure that it is a valid TCL
--                file.  It then uses the ModulesVersion.tcl script to 
--                return what the value of "ModulesVersion" is.

function versionFile(v, sn, path, ignoreErrors)
   dbg.start{"versionFile(v: ",v,", sn: ",sn,", path: ",path,")"}
   local f       = io.open(path,"r")
   if (not f)                        then
      dbg.print{"could not find: ",path,"\n"}
      dbg.fini("versionFile")
      return nil
   end
   local s       = f:read("*line")
   f:close()
   if (not s:find("^#%%Module"))      then
      dbg.print{"could not find: #%Module\n"}
      dbg.fini("versionFile")
      return nil
   end
   local version = false

   if (v == "/.modulerc") then
      local cmd = pathJoin(cmdDir(),"RC2lua.tcl") .. " " .. path
      local s = capture(cmd):trim()
      assert(load(s))()
      for i = 1,#modV do
         local entry = modV[i]
         if (entry.module_version == "default") then
            local name = entry.module_name
            local i, j = name:find(sn)
            local nLen = name:len()
            if (j+1 < nLen and name:sub(j+1,j+1) == '/') then
               version = name:sub(j+2)
               break
            end
         end
      end
   elseif (v == "/.version") then
      local cmd = pathJoin(cmdDir(),"ModulesVersion.tcl") .. " " .. path
      local s = capture(cmd):trim()
      assert(load(s))()
      version = modV.version
      if (modV.date ~= "***") then
         local a = {}
         for s in modV.date:split("/") do
            a[#a + 1] = tonumber(s) or 0
         end
         
         if (not ignoreErrors and (a[1] < 2000 or a[2] > 12 )) then
            LmodMessage("The .version file for \"",sn,
                        "\" has the date is written in the wrong format: \"",
                        modV.date,"\".  Please use YYYY/MM/DD.")
         end
         
         local epoch   = os.time{year = a[1], month = a[2], day = a[3]} or 0
         local current = os.time() 
         if (current < epoch) then
            if (not ignoreErrors) then
               LmodMessage("The default version for module \"",myModuleName(),
                           "\" is changing on ", modV.date, " from ",modV.version,
                           " to ", modV.newVersion,"\n")
            end
            version = modV.version
         else
            version = modV.newVersion
         end
      end
   end
   dbg.print{"version: ",version,"\n"}
   dbg.fini("versionFile")
   return version
end

--------------------------------------------------------------------------
-- Push the Lmod Version into the environment
function setenv_lmod_version()
   local nameA = { "LMOD_VERSION_MAJOR",
                   "LMOD_VERSION_MINOR",
                   "LMOD_VERSION_SUBMINOR"
   }

   local versionStr = Version.tag()

   posix.setenv("LMOD_VERSION",versionStr, true)
   local numA = {}

   for s in versionStr:split("%.") do
      numA[#numA+1] = s
   end

   for i = 1, #nameA do
      posix.setenv(nameA[i],numA[i] or "0", true)
   end
end


--------------------------------------------------------------------------
-- Deal with warnings

function activateWarning()
   s_haveWarnings = true
end

function deactivateWarning()
   s_haveWarnings = false
end

function haveWarnings()
   return s_haveWarnings
end

function clearWarningFlag()
   s_warning = false
end

function setWarningFlag()
   s_warning = true
end

function getWarningFlag()
   return s_warning
end
