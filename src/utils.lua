--------------------------------------------------------------------------
-- This is the file that has miscellaneous utility functions.
-- @module utils

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

require("strict")
require("fileOps")
require("string_utils")
require("parseVersion")
require("myGlobals")
require("capture")

_G._DEBUG          = false               -- Required by the new lua posix
local Version      = require("Version")
local base64       = require("base64")
local dbg          = require("Dbg"):dbg()
local lfs          = require("lfs")
local malias       = require("MAlias"):build()
local posix        = require("posix")
local readlink     = posix.readlink
local setenv_posix = posix.setenv
local concatTbl    = table.concat
local decode64     = base64.decode64
local floor        = math.floor
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge
local open         = io.open

local rep          = string.rep
local load         = (_VERSION == "Lua 5.1") and loadstring or load

--------------------------------------------------------------------------
-- find true path through symlinks.
-- @param path A file path
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
      --dbg.print{"path: ",path,", rl: ",rl,"\n"}
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
-- This is 5.1 Lua function to cover the table.pack function
-- that is in Lua 5.2 and later.
function argsPack(...)
   local arg = { n = select("#", ...), ...}
   return arg
end
pack     = (_VERSION == "Lua 5.1") and argsPack or table.pack


--------------------------------------------------------------------------
-- Generate a message that will fix the available terminal width.
-- @param width The terminal width
function buildMsg(width, ... )
   local arg = pack(...)
   local a   = {}
   local len = 0

   for idx = 1, arg.n do
      local block  = arg[idx]
      local done   = false
      while (not done) do
         local hasNL  = false
         local ja, jb = block:find("\n")
         local line
         if (ja) then
            hasNL = true
            line  = block:sub(1,ja-1)
            block = block:sub(ja+1,-1)
         else
            done  = true
            line  = block
         end

         if (#a > 0 and line:sub(1,1) == '"' and a[#a] == " ") then
            a[#a] = nil
         end

         local i,j, lBlnks = line:find("^( +)")
         local rest        = line
         if (i) then
            a[#a+1] = lBlnks
            len     = len + lBlnks:len()
            rest    = line:sub(j+1,-1)
         end

         for word in rest:split(" +") do
            local wlen = word:len()
            if (wlen + len >= width) then
               a[#a]     = "\n"
               len       = 0
            end
            if (wlen > 0) then
               a[#a + 1] = word
               a[#a + 1] = " "
            end
            len = len + wlen + 1
         end
         if (hasNL) then
            local jc = #a+1
            if (a[#a] == " ") then
               jc = #a
            end
            a[jc] = "\n"
            len   = 0
         end
         if (a[#a] == " ") then
            a[#a] = nil
         end
         local last = a[#a]:sub(-1)
         if (last ~= '"' and last ~= "\n") then
            a[#a + 1] = " "
         end
      end
   end

   return concatTbl(a,"")
end


--------------------------------------------------------------------------
-- Convert both argument to lower case and compare.
-- @param a input string
-- @param b input string
function case_independent_cmp(a,b)
   local a_lower = a:lower()
   local b_lower = b:lower()

   if (a_lower  == b_lower ) then
      return a < b
   else
      return a_lower < b_lower
   end
end


local __expert = false
--------------------------------------------------------------------------
-- Return true if in expert mode.
function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end

local __quiet = false
--------------------------------------------------------------------------
-- Return ture if in quiet mode.
function quiet()
   if (__quiet == false) then
      __quiet = getenv("LMOD_QUIET") or getenv("LMOD_EXPERT")
   end
   return __quiet
end

function isActiveMFile(full, sn)
   local version = extractVersion(full, sn) or ""
   if (version:sub(1,1) == ".") then
      return false, version
   end
   if (full:sub(1,1) == ".") then
      return false, version
   end
   if (full:find("/%.")) then
      return false, version
   end
   return true, version
end

--------------------------------------------------------------------------
-- Compare the full name of a modulefile with the
-- shortname. Return nil if the shortname and full name
-- are the same.
-- @param full full module name
-- @param sn   short name
function extractVersion(full, sn)
   if (not full or not sn) then
      return nil
   end

   local i, j = full:find('.*/')

   if (not i) then
      return nil
   end

   local pat     = '^' .. sn:escape() .. '/?'
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
   ['.lua']      = true,
   ['.moduler']  = true,
   ['.version']  = true,
   ['.modulerc'] = true,
   ['.DS_Stor']  = true,
   ['.DS_Store'] = true,

   --@ignore_dirs@--
}

--------------------------------------------------------------------------
-- Return the table of files to ignore when searching for modulefiles.
function ignoreFileT()
   local fileT = s_ignoreT
   return fileT
end



--------------------------------------------------------------------------
-- Ask the environment for the _ModuleTable_ value.
-- It is uuencoded and broken into pieces so that the
-- quotes and parens won't confuse the shell's poor little
-- brain.  The number of pieces are stored in the global
-- env. variable _ModuleTable_Sz_.
function getMT()
   local a    = {}
   local mtSz = getenv("_ModuleTable_Sz_") or huge
   local s    = nil

   --io.stderr:write("mtSz: ",tostring(mtSz),"\n")

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

--------------------------------------------------------------------------
-- Find all the versions in the pathA or at least *n* of them.
-- @param pathA  an array of paths.
-- @param n      a number of paths to check.
function allVersions(pathA, n)
   local lastKey   = ''
   local lastValue = ''
   local result    = nil
   local fullName  = nil
   local count     = 0
   local a         = {}
   n               = n or #pathA

   for i = 1, n do
      local vv = pathA[i]
      for version, fn in pairs(vv.versionT) do
         local pv = parseVersion(version)
         a[#a + 1] = {version = version, file = fn, idx = i, mpath = vv.mpath, pv = pv}
      end
   end
   return a
end

--------------------------------------------------------------------------
-- Compare two path arrays.  Return the index where they start to differ.
-- @param old   Old path as a string
-- @param oldA  An array of old path entries
-- @param new   New path as a string
-- @param newA  An array of new path entries
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
-- This function finds the latest version of a package
-- in the directory "path".  It uses the parseVersion()
-- function to decide which version is the most recent.
-- It is not a lexigraphical search but uses rules built
-- into parseVersion().
-- @param pathA  an array of paths.
-- @param n      a number of paths to check.
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
-- compute the length of a string and ignore any string
-- colorization.
-- @param s input string
function length(s)
   s = s:gsub("\027[^m]+m","")
   return s:len()
end

s_masterTbl = {}
--------------------------------------------------------------------------
-- Manage the Master Hash Table.  The command line arguments
-- and the ModuleStack (when using Spider) are stored here.
function masterTbl()
   return s_masterTbl
end

--------------------------------------------------------------------------
-- This function takes a path like variable and breaks
-- it up into an array.  Each path component is
-- standandized by path_regularize().  This function
-- removes leading and trailing spaces and duplicate '/'
-- etc.
--
-- Typically the separator is a colon but it can be
-- anything.  Some env. vars (such as TEXINPUTS and
-- LUA_PATH) use "::" or ";;" to mean that the
-- specified values are prepended to the system ones.
-- To handle that, the path component is converted to
-- a single space.  This single space is later removed
-- when expanding.
-- @param path A string of *sep* separated paths.
-- @param sep  The separator character.  It is usually
--             a colon.
function path2pathA(path, sep)
   sep = sep or ":"
   if (not path) then
      return {}
   end
   if (path == '') then
      return { ' ' }
   end

   local is, ie

   local pathA = {}
   for v  in path:split(sep) do
      pathA[#pathA + 1] = path_regularize(v)
   end

   local n = #pathA
   local i = n
   while (pathA[i] == "") do
      i = i - 1
   end
   i = i + 2
   for j = i, n do
      pathA[j] = nil
   end

   return pathA
end

--------------------------------------------------------------------------
-- Find the admin file (or nag message file).
function findAdminFn()
   local readable    = "no"
   local adminFn     = LMOD_ADMIN_FILE
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
function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminT)) then return end

   local adminFn = findAdminFn()
   local f       = open(adminFn,"r")

   -- Put something in adminT so that this routine will not be
   -- run again even if the file does not exist.
   adminT["%%_foo_%%"] = "bar"

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
         repeat
            v = v:trim()

            if (v:sub(1,1) == "#") then
               -- ignore this comment line
               break

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
         until true
      end
   end
end

--local s_readRC     = false
--RCFileA = {
--   pathJoin(cmdDir(),"../init/lmodrc.lua"),
--   pathJoin(cmdDir(),"../../etc/lmodrc.lua"),
--   pathJoin("/etc/lmodrc.lua"),
--   pathJoin(getenv("HOME"),".lmodrc.lua"),
--   os.getenv("LMOD_RC"),
--}
--
----------------------------------------------------------------------------
---- Read in the system and possible a user lmod configuration file.
---- The system one is read first.  These provide default value
---- The user one can override the default values.
--function readRC()
--   dbg.start{"readRC()"}
--   if (s_readRC) then
--      s_readRC = true
--      return
--   end
--
--   declare("propT",       false)
--   declare("scDescriptT", false)
--
--   for i = 1,#RCFileA do
--      repeat
--         local f        = RCFileA[i]
--         local fh = open(f)
--         if (not fh) then break end
--            
--         assert(loadfile(f))()
--         s_rcFileA[#s_rcFileA+1] = abspath(f)
--         fh:close()
--
--         local propT       = _G.propT or {}
--         local scDescriptT = _G.scDescriptT   or {}
--         for k,v in pairs(propT) do
--            s_propT[k] = v
--         end
--         for j = 1,#scDescriptT do
--            s_scDescriptT[#s_scDescriptT + 1] = scDescriptT[j]
--         end
--      until true
--   end
--   dbg.fini("readRC")
--end
--
----------------------------------------------------------------------------
---- Return the property table.
--function getPropT()
--   return s_propT
--end
--
----------------------------------------------------------------------------
---- Return the spider cache description table.
--function getSCDescriptT()
--   return s_scDescriptT
--end
--
--
----------------------------------------------------------------------------
---- Return the array of active RC files
--function getRCFileA()
--   return s_rcFileA
--end

--------------------------------------------------------------------------
-- Convert number and string to a quoted string.
-- @param v input number or string.
local function arg2str(v)
   if (v == nil) then return v end
   local s = tostring(v)
   if (type(v) ~= "boolean") then
      s = "\"".. s .."\""
   end
   return s
end

--------------------------------------------------------------------------
-- Build a string of what the command would be. Used by
-- MC_Show and MC_ComputeHash.

defaultsT = {
   delim    = ":",
   priority = "0",
}

--------------------------------------------------------------------------
-- This routine converts a command into a string.  This is used by MC_Show
-- @param name Input command name.
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


--------------------------------------------------------------------------
-- This routine converts a command into a string.  This is used by MC_Show
-- @param name Input command name.
-- @param mA   An array of Module Name objects.
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
-- Unique string that combines the current time/date
-- with a uuid id string.
function UUIDString(epoch)
   local ymd  = os.date("*t", epoch)

   --                                y    m    d    h    m    s
   local uuid_date = string.format("%d_%02d_%02d_%02d_%02d_%02d",
                                   ymd.year, ymd.month, ymd.day,
                                   ymd.hour, ymd.min,   ymd.sec)

   local uuidgen = find_exec_path('uuidgen')
   local uuid_str
   if uuidgen then
       uuid_str = capture('uuidgen'):sub(1,-2)
   else
      -- if uuidgen is not available, fall back to reading /proc/sys/kernel/random/uuid
      -- note: only works on Linux
      local f = open('/proc/sys/kernel/random/uuid', 'r')
      if f then
         uuid_str = f:read('*all'):sub(1,-2)
      else
         LmodError("uuidgen is not available, fallback failed too")
      end
   end

   local uuid      = uuid_date .. "-" .. uuid_str

   return uuid
end

modA = false

function runTCLprog(TCLprog, optStr, fn)
   local a   = {}
   a[#a + 1] = LMOD_TCLSH
   a[#a + 1] = pathJoin(cmdDir(),TCLprog)
   a[#a + 1] = optStr or ""
   a[#a + 1] = fn
   local cmd = concatTbl(a," ")
   local whole, status = capture(cmd)
   return whole, status
end
   
--------------------------------------------------------------------------
-- This routine is given the absolute path to a .version
-- file.  It checks to make sure that it is a valid TCL
-- file.  It then uses the ModulesVersion.tcl script to
-- return what the value of "ModulesVersion" is.
-- @param v The version file name: {.modulerc, .version}
-- @param sn The short name
-- @param path The path to version file
-- @param ignoreErrors If true then ignore errors.
function versionFile(v, sn, path, ignoreErrors)
   dbg.start{"versionFile(v: ",v,", sn: ",sn,", path: ",path,")"}
   local f       = open(path,"r")
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
   dbg.print{"handle file: ",v, "\n"}
   local whole
   local status
   local func
   whole, status = runTCLprog("RC2lua.tcl", "", path)
   if (not status) then
      LmodError("Unable to parse: ",path," Aborting!\n")
   end

   status, func = pcall(load, whole)
   if (not status or not func) then
      LmodError("Unable to parse: ",path," Aborting!\n")
   end
   func()
   malias:parseModA(sn, modA)

   version = malias:getDefaultT(sn) or version

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

   setenv_posix("LMOD_VERSION",versionStr, true)
   local numA = {}

   for s in versionStr:split("%.") do
      numA[#numA+1] = s
   end

   for i = 1, #nameA do
      setenv_posix(nameA[i],numA[i] or "0", true)
   end
end

local defaultFnT = {
   default       = 1,
   ['.modulerc'] = 2,
   ['.version']  = 3,
}

--------------------------------------------------------------------------
-- Find exceptable files. Or mark as false files that should be ignored
-- @param fn input file name

local ignoreT   = ignoreFileT()

--------------------------------------------------------------------------
-- Find exceptable files. Or mark as false files that should be ignored
-- @param fn input file name
function keepFile(fn)
   local fileDflt  = fn:sub(1,8)
   local firstChar = fn:sub(1,1)
   local lastChar  = fn:sub(-1,-1)
   local firstTwo  = fn:sub(1,2)

   local result    = not (ignoreT[fn]      or lastChar == '~' or ignoreT[fileDflt] or
                          firstChar == '#' or lastChar == '#' or firstTwo == '.#')
   if (not result) then
      return result
   end

   if (firstChar == "." and fn:sub(-4,-1) == ".swp") then
      return false
   end

   return result
end

local function checkValidModulefileReal(fn)
   local f = open(fn,"r")
   if (not f) then
      return false
   end
   local line = f:read(20) or ""
   f:close()
   return line:find("^#%%Module")
end

function checkValidModulefileFake(fn)
   return true
end

local checkValidModulefile = (LMOD_CHECK_FOR_VALID_MODULE_FILES == "yes")
                             and checkValidModulefileReal or checkValidModulefileFake


--------------------------------------------------------------------------
-- Walk a single directory for modulefiles and defaults:
-- @param mpath Input modulepath directory
-- @param path Input of the current directory.
-- @param prefix the prefix
-- @param dirA An array of directories found.
-- @param mnameT A table of module names found
-- @return defaultFn the default modulefile.
function walk_directory_for_mf(mpath, path, prefix, dirA, mnameT)
   dbg.start{"walk_directory_for_mf(mpath: ",mpath,", path: ",path,", prefix: \"",prefix,"\", dirA, mnameT)"}
   local attr = lfs.attributes(path)
   if (not attr or type(attr) ~= "table" or attr.mode ~= "directory"
       or not posix.access(path,"x")) then
      dbg.print{"Path: ",path," does not exist\n"}
      dbg.fini("walk_directory_for_mf")
      return false
   end

   local accept_fn  = accept_fn
   local defaultFn  = false
   local defaultIdx = 1000000  -- default idx must be bigger than index for .version
   -----------------------------------------------------------------------------
   -- Read every relevant file in a directory.  Copy directory names into dirA.
   -- Copy files into mnameT.
   ignoreT   = ignoreFileT()

   --local archNameT = {}
   --local archNameT = { ['64'] = true, ['32'] = true, ['x86_64'] = true, ['ia32'] = true, gcc = true,
   --                    ['haswell'] = true, ['ivybridge'] = true, ['sandybridge'] = true, ['ia32'] = true,
   --}

   local a = {}


   for file in lfs.dir(path) do
      repeat
         local idx       = defaultFnT[file] or defaultIdx
         if (idx < defaultIdx) then
            defaultIdx = idx
            defaultFn  = pathJoin(path,file)
         else
            if (keepFile(file))then
               local f        = pathJoin(path,file)
               attr           = lfs.attributes(f)
               local readable = posix.access(f,"r")
               local full     = pathJoin(prefix, file):gsub("%.lua","")

               ------------------------------------------------------------
               -- Since cache files are build by root but read by users
               -- make sure that any user can read a file owned by root.

               if (readable) then
                  local st    = posix.stat(f)
                  if ((not st) or (st.uid == 0 and not st.mode:find("......r.."))) then
                     readable = false
                  end
               end

               if (not readable or not attr) then
                  -- do nothing for non-readable or non-existant files
                  break
               elseif (attr.mode == 'file' and file ~= "default" and accept_fn(file) and
                       full:sub(1,1) ~= '.') then
                  -- Lua modulefiles should always be picked over TCL modulefiles
                  if (not mnameT[full] or not mnameT[full].luaExt) then
                     local luaExt  = f:find("%.lua$")
                     if (luaExt  or checkValidModulefile(f)) then
                        local sn      = prefix:gsub("/$","")
                        local version = file:gsub("%.lua$","")
                        if (sn == "") then
                           sn = full
                           version = false
                        end
                        mnameT[full] = {fn = f, canonical=f:gsub("%.lua$",""), mpath = mpath,
                                        luaExt = luaExt, version=version, sn=sn}
                     end
                  end
               elseif (attr.mode == "directory" and file:sub(1,1) ~= ".") then
                  -- Remember all directories in local array.  We have to know if
                  -- any are "arch" directories.
                  a[#a + 1] = { fullName = f, mname = full, file=file, path=path}
               end
            end
         end
      until true
   end


   for i = 1,#a do
      dirA[#dirA + 1] = a[i]
   end

   if (dbg.active()) then
      for i = 1,#dirA do
         dbg.print{"dirA[",i,"].mname: ", dirA[i].mname,", \tdirA[",i,"].fullName: ",dirA[i].fullName,
                   ", file: ",dirA[i].file,"\n"}
      end
      dbg.print{"\n"}
      for k,v in pairsByKeys(mnameT) do
         dbg.print{"mnameT[",k,"].fn: ",v.fn," sn: ",v.sn,", version: ", v.version,"\n"}
      end
   end

   dbg.fini("walk_directory_for_mf")
   return defaultFn
end

--------------------------------------------------------------------------
-- Use readlink to find the link
-- @param path the path to the module file.
function walk_link(path)
   local attr   = lfs.symlinkattributes(path)
   if (attr == nil) then
      return nil
   end

   if (attr.mode == "link") then
      local rl = readlink(path)
      if (not rl) then
         return nil
      end
      return pathJoin(dirname(path),rl)
   end
   return path
end


--------------------------------------------------------------------------
-- Allow for the generation of warnings.
function activateWarning()
   s_haveWarnings = true
end

--------------------------------------------------------------------------
-- Disallow the generation of warnings.
function deactivateWarning()
   s_haveWarnings = false
end

--------------------------------------------------------------------------
-- Are the generation of warnings allowed?
function haveWarnings()
   return s_haveWarnings
end

--------------------------------------------------------------------------
-- Reset warning flag to false.
function clearWarningFlag()
   s_warning = false
end

--------------------------------------------------------------------------
-- Set warning flags to true.
function setWarningFlag()
   s_warning = true
end

--------------------------------------------------------------------------
-- Get warning flag value.
function getWarningFlag()
   return s_warning
end
