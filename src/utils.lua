--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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
require("string_split")
require("string_trim")
require("parseVersion")

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

--------------------------------------------------------------------------
-- argsPack():  This is 5.1 Lua function to cover the table.pack function
--              that is in Lua 5.2 and later.

function argsPack(...)
   local arg = { n = select ("#", ...), ...}
   return arg
end
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack

--------------------------------------------------------------------------
-- bannerStr(): This function builds a banner string that is centered
--              and has dashes on the left and right side.

function bannerStr(width, str)
   local a       = {}
   local len     = str:len() + 2
   local lcount  = floor((width - len)/2)
   local rcount  = width - lcount - len
   a[#a+1] = rep("-",lcount)
   a[#a+1] = " "
   a[#a+1] = str
   a[#a+1] = " "
   a[#a+1] = rep("-",rcount)
   return concatTbl(a,"")
end

------------------------------------------------------------------------
-- border(); Build a border string of nspace leading spaces followed 
--           by "-"'s to exactly 4 spaces before the end of the terminal.

local rep=string.rep
borderG = nil
nspacesG = 0
function border(nspaces)
   if (not borderG or nspaces ~= nspacesG) then
      nspacesG = nspaces
      local term_width = TermWidth() - 4
      borderG = rep(" ",nspaces) .. rep("-", term_width) .. "\n"
   end
   return borderG
end

--------------------------------------------------------------------------
-- epoch(): return the number of seconds (and maybe partial seconds) since
--          Jan 1, 1970 12:00:00 Midnight G.M.T (Zulu)


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
-- expert(): Are we in expert mode?
local __expert = false
function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
end

--------------------------------------------------------------------------
-- extractVersion(): Compare the full name of a modulefile with the
--                   shortname. Return nil if the shortname and full name
--                   are the same.

function extractVersion(full, sn)
   if (not full or not sn) then
      return nil
   end
   local pat     = '^' .. escape(sn) .. '/?'
   local version = full:gsub(pat,"")
   if (version == "") then
      version = nil
   end
   return version
end


s_ignoreT = {
   ['.']         = true,
   ['..']        = true,
   ['CVS']       = true,
   ['.DS_Store'] = true,
   ['.git']      = true,
   ['.svn']      = true,
   ['.hg']       = true,
   ['.bzr']      = true,   
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

---------------------------------------------------------------------------
-- lastFileInDir(path): This function finds the latest version of a package
--                      in the directory "path".  It uses the parseVersion()
--                      function to decide which version is the most recent.
--                      It is not a lexigraphical search but uses rules built
--                       into parseVersion().

function lastFileInDir(path)
   dbg.start("lastFileInDir(",path,")")
   local lastKey   = ''
   local lastValue = ''
   local result    = nil
   local fullName  = nil
   local count     = 0

   local attr = lfs.attributes(path)
   if (attr and attr.mode == 'directory' and posix.access(path,"x")) then
      for file in lfs.dir(path) do
         local f = pathJoin(path, file)
         attr = lfs.attributes(f)
         local readable = posix.access(f,"r")
         if (readable and file:sub(1,1) ~= "." and attr.mode == 'file' and file:sub(-1,-1) ~= '~') then
            dbg.print("path: ",path," file: ",file," f: ",f,"\n")
            count = count + 1
            local key = file:gsub("%.lua$","")
            key       = concatTbl(parseVersion(key),".")
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

function readAdmin()

   -- If there is anything in [[adminT]] then return because
   -- this routine has already read in the file.
   if (next (adminT)) then return end

   local adminFn = getenv("LMOD_ADMIN_FILE") or pathJoin(cmdDir(),"../../etc/admin.list")
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
   pathJoin(getenv("HOME"),".lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/.lmodrc.lua"),
   pathJoin(cmdDir(),"../init/.lmodrc.lua"),
   os.getenv("LMOD_RC"),
}

function readRC()
   dbg.start("readRC()")
   if (s_readRC) then
      s_readRC = true
      return
   end
   
   declare("propT",       false)
   declare("scDescriptT", false)
   local results = {}


   for i = 1,#RCFileA do
      local f  = RCFileA[i]
      dbg.print("readRC: f: ",f,"\n")
      local fh = io.open(f)
      if (fh) then
         assert(loadfile(f))()
         fh:close()
         break
      end
   end
   s_propT       = _G.propT         or {}
   s_scDescriptT = _G.scDescriptT   or {}
   dbg.fini("readRC")
end

function getPropT()
   return s_propT
end

function getSCDescriptT()
   return s_scDescriptT
end

--------------------------------------------------------------------------
-- ShowCmdStr(): Build a string of what the command would be. Used by
--               MC_Show and MC_ComputeHash.

function ShowCmdStr(name, ...)
   local a = {}
   local arg = pack(...)
   for i = 1, arg.n do
      local v = arg[i]
      local s = tostring(v)
      if (type(v) ~= "boolean") then
         s = "\"".. s .."\""
      end
      a[#a + 1] = s
   end
   local b = {}
   b[#b+1] = name
   b[#b+1] = "("
   b[#b+1] = concatTbl(a,",")
   b[#b+1] = ")\n"
   return concatTbl(b,"")
end

function ShowCmdA(name, mA)
   local a = {}
   for i = 1, #mA do
      local mname = mA[i]
      a[i] = '"' .. mA[i]:usrName() .. '"'
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

function setWarningFlag()
   s_warning = true
end
function getWarningFlag()
   return s_warning
end


function capture(cmd,level)
   level        = level or 1
   local level2 = level or 2
   dbg.start(level, "capture")
   dbg.print("cwd: ",posix.getcwd(),"\n")
   dbg.print("cmd: ",cmd,"\n")
   local p = io.popen(cmd)
   if p == nil then
      return nil
   end
   local ret = p:read("*all")
   p:close()
   dbg.start(level2,"capture output")
   dbg.print(ret)
   dbg.fini()
   dbg.fini()
   return ret
end


