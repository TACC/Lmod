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
local Dbg       = require("Dbg")
local lfs       = require("lfs")
local concatTbl = table.concat
local getenv    = os.getenv
local posix     = require("posix")


--------------------------------------------------------------------------
-- compute the length of a string and ignore any string colorization.

function length(s)
   s = s:gsub("\027[^m]+m","")
   return s:len()
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
-- Compare the full name of a modulefile with the shortname.
-- Return nil if the shortname and full name are the same.

function extractVersion(full, sn)
   if (full == nil or sn == nil) then
      return nil
   end
   local pat     = '^' .. escape(sn) .. '/?'
   local version = full:gsub(pat,"")
   if (version == "") then
      version = nil
   end
   return version
end


--------------------------------------------------------------------------
-- Are we in expert mode?
local __expert = false
function expert()
   if (__expert == false) then
      __expert = getenv("LMOD_EXPERT")
   end
   return __expert
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

--------------------------------------------------------------------------
-- read in the system and possible a user lmod configuration file.
-- The system one is read first.  These provide default value
-- The user one can override the default values.

local s_readRC     = false
RCFileA = {
   pathJoin(getenv("HOME"),".lmodrc.lua"),
   pathJoin(cmdDir(),"../../etc/.lmodrc.lua"),
   pathJoin(cmdDir(),"../init/.lmodrc.lua"),
   os.getenv("LMOD_RC"),
}

function readRC()
   if (s_readRC) then
      s_readRC = true
      return
   end

   declare("propT",       false)
   declare("scDescriptT", false)
   local results = {}

   for i = 1,#RCFileA do
      local f  = RCFileA[i]
      local fh = io.open(f)
      if (fh) then
         assert(loadfile(f))()
         fh:close()
         break
      end
   end
   s_propT       = _G.propT         or {}
   s_scDescriptT = _G.scDescriptT   or {}
end

function getPropT()
   return s_propT
end

function getSCDescriptT()
   return s_scDescriptT
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

---------------------------------------------------------------------------
-- lastFileInDir(path): This function finds the latest version of a package
-- in the directory "path".  It uses the parseVersion() function to decide
-- which version is the most recent.  It is not a lexigraphical search but
-- uses rules built into parseVersion().

function lastFileInDir(path)
   local dbg      = Dbg:dbg()
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

------------------------------------------------------------------------
-- Build a border string of nspace leading spaces followed by "-"'s to
-- exactly 4 spaces before the end of the terminal.

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
