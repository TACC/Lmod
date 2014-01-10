#!@path_to_lua@/lua
-- -*- lua -*-


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

-----------------------------------------------------------------
-- getmt:  prints to screen what the value of the ModuleTable is.
--         optionly it writes the state of the ModuleTable is to a
--         dated file.
--
local cmd = arg[0]

local i,j = cmd:find(".*/")
local cmd_dir = "./"
if (i) then
   cmd_dir = cmd:sub(1,j)
end
package.path = cmd_dir .. "../tools/?.lua;" ..
               cmd_dir .. "?.lua;"       .. package.path

function cmdDir()
   return cmd_dir
end

require("strict")
require("fileOps")
require("serializeTbl")
require("myGlobals")
require("capture")
require("utils")
build_epoch()               -- build the epoch function
_ModuleTable_  = ""
local posix    = require("posix")
local Optiks   = require("Optiks")
local lfs      = require("lfs")
local cmd      = abspath(arg[0])
local i,j      = cmd:find(".*/")
local base64   = require("base64")
local concat   = table.concat
local decode64 = base64.decode64
local format   = string.format
local getenv   = os.getenv
local load     = (_VERSION == "Lua 5.1") and loadstring or load

function main()

   local optionTbl = options()

   local s = getMT()
   if (s == nil) then return end

   local t = assert(load(s))()

   local mt = _ModuleTable_
   if (optionTbl.testing) then
      for k,v in pairs(mt) do
         if (k:sub(1,2) == "c_") then
            mt[k] = nil
         end
      end
   end


   local s = serializeTbl{indent=true, name="_ModuleTable_", value= mt}

   local fn = nil
   if (optionTbl.save_state) then
      local uuid = UUIDString(epoch())
      fn = pathJoin(usrSaveDir, uuid .. ".lua")
   elseif (optionTbl.fn) then
      fn = optionTbl.fn
   end

   if (fn) then
      local d = dirname(fn)
      local attr = lfs.attributes(d)
      if (not attr) then
         mkdir_recursive(d)
      end

      local f = io.open(fn,"w")
      if (f) then
         f:write(s)
         f:close()
      end
   else
      local out = io.stdout
      if (optionTbl.errorOut) then
         out = io.stderr
      end
      out:write(s,"\n")
   end
end

function options()
   local usage         = "Usage: getmt [options]"
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{
      name   = {'-f', '--file'},
      dest   = 'fn',
      action = 'store',
   }

   cmdlineParser:add_option{
      name   = {'-2', '--err'},
      dest   = 'errorOut',
      action = 'store_true',
   }

   cmdlineParser:add_option{
      name   = {'--regressionTesting'},
      dest   = 'testing',
      action = 'store_true',
   }

   cmdlineParser:add_option{
      name   = {'-s', '--save_state'},
      dest   = 'save_state',
      action = 'store_true',
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   return optionTbl

end
main()
