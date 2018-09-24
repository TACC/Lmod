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

_G._DEBUG       = false               -- Required by the new lua posix
local posix     = require("posix")

require("strict")
require("fileOps")

local dbg       = require("Dbg"):dbg()
local base64    = require("base64")
local concatTbl = table.concat
local decode64  = base64.decode64
local format    = string.format
local getenv    = os.getenv
local huge      = math.huge


function argsPack(...)
   local argA = { n = select("#", ...), ...}
   return argA
end
local pack        = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat

function findFileInTree(fn)
   local cwd  = posix.getcwd()
   local wd   = cwd
   local prev = ""
   while (wd ~= "/" and wd ~= prev and not posix.access(fn,"r")) do
      posix.chdir("..")
      prev = wd
      wd   = posix.getcwd()
   end

   posix.chdir(cwd)
   if (wd == "/") then
      return nil
   else
      return pathJoin(wd,fn)
   end
end

function STError(...)
   io.stderr:write("\n","Settarg has detected the following error: ")
   local argA = pack(...)
   for i = 1, argA.n do
      io.stderr:write(argA[i])
   end
   io.stderr:write("\n")
end


function getSTT()
   local a    = {}
   local sz   = tonumber(getenv("_SettargTable_Sz_")) or huge
   local s    = nil

   for i = 1, sz do
      local name = format("_SettargTable%03d_",i)
      local v    = getenv(name)
      if (v == nil) then break end
      a[#a+1]    = v
   end
   if (#a > 0) then
      s = decode64(concatTbl(a,""))
   end
   return s
end

