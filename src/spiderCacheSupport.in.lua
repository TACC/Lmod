#!@path_to_lua@
-- -*- lua -*-

_G._DEBUG      = false
local posix    = require("posix")

--------------------------------------------------------------------------
-- Fixme
-- @script spiderCacheSupport

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

local sys_lua_path = "@sys_lua_path@"
if (sys_lua_path:sub(1,1) == "@") then
   sys_lua_path = package.path
end

local sys_lua_cpath = "@sys_lua_cpath@"
if (sys_lua_cpath:sub(1,1) == "@") then
   sys_lua_cpath = package.cpath
end

package.path   = sys_lua_path
package.cpath  = sys_lua_cpath

local arg_0    = arg[0]
local readlink = posix.readlink
local stat     = posix.stat

local st       = stat(arg_0)
while (st.type == "link") do
   local lnk = readlink(arg_0)
   if (arg_0:find("/") and (lnk:find("^/") == nil)) then
      local dir = arg_0:gsub("/[^/]*$","")
      lnk       = dir .. "/" .. lnk
   end
   arg_0 = lnk
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local cmd_dir = "./"
if (ia) then
   cmd_dir = arg_0:sub(1,ja)
end


package.path  = cmd_dir .. "../tools/?.lua;"      ..
                cmd_dir .. "../tools/?/init.lua;" ..
                cmd_dir .. "?.lua;"               ..
                sys_lua_path
package.cpath = cmd_dir .. "../lib/?.so;"..
                sys_lua_cpath


function cmdDir()
   return cmd_dir
end

local Optiks = require("Optiks")
local lfs    = require("lfs")
require("strict")
require("utils")
require("fileOps")
require("string_utils")
require("serializeTbl")

function main()

   local optionTbl, pargs = options()

   local scDescriptT = false
   local found       = false

   if (optionTbl.descriptFn and optionTbl.descriptFn ~= "") then
      local attr = lfs.attributes(optionTbl.descriptFn) or {}
      found      = (attr.mode == "file")
   end

   if (found) then
      scDescriptT = buildFromDescript(optionTbl.descriptFn)
   elseif (optionTbl.cacheDirs and optionTbl.cacheDirs ~= "" ) then
      scDescriptT = buildFromEnvVars(optionTbl.cacheDirs,
                                     optionTbl.updateFn)
   end

   if (scDescriptT and next(scDescriptT) ~= nil) then
      local s = serializeTbl{ indent = true, name = "scDescriptT",
                              value = scDescriptT }
      io.stdout:write(s)
   end

end

function buildFromEnvVars(cacheDirs, updateFn)
   local scDescriptT = {}

   if (not updateFn or updateFn == "") then
      updateFn = false
   end

   local i = 0
   for dir in cacheDirs:split(":") do
      dir = path_regularize(dir)
      i = i + 1
      scDescriptT[i] = { dir = dir, timestamp = updateFn}
   end
   return scDescriptT
end

function buildFromDescript(descriptFn)
   local f = io.open(descriptFn,"r")
   if (not f) then
      io.stderr:write("unable open file: ",descriptFn,"\n")
      return nil
   end

   local whole = f:read("*all")
   f:close()

   local scDescriptT = {}

   local i = 0
   for line in whole:split('\n') do
      if (not line:find("^%s*#") and
          not line:find("^%s*$")) then
         local a = {}
         for v in line:split(':') do
            a[#a+1] = path_regularize(v:trim())
         end
         i = i + 1
         scDescriptT[i] = { dir = a[1], timestamp = a[2] or false }
      end
   end
   return scDescriptT
end

function options()
   local usage         = "Usage: spiderCacheSupport [options] descriptFn"
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{
      name   = {'--cacheDirs'},
      dest   = 'cacheDirs',
      action = 'store',
      help   = "Cache directories"
   }

   cmdlineParser:add_option{
      name   = {'--updateFn'},
      dest   = 'updateFn',
      action = 'store',
      help   = "last update file"
   }

   cmdlineParser:add_option{
      name   = {'--descriptFn'},
      dest   = 'descriptFn',
      action = 'store',
      help   = "Cache Description File"
   }

   local optTbl, pargs = cmdlineParser:parse(arg)

   return optTbl, pargs

end

main()
