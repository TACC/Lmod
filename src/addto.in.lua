#!@path_to_lua@
-- -*- lua -*-

-----------------------------------------------------------------
-- addto:  Add to a path like environment variable.
--
-- Standard usage is Bash:
--
-- $ unset FOO
-- $ export FOO=$(addto --append FOO a b c)
-- $ echo "   FOO: %$FOO%"
--     FOO: %a:b:c%
-- $ export FOO=$(addto --append FOO d e f); echo "   FOO: %$FOO%"
--     FOO: %a:b:c:d:e:f%
-- @script addto

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
_G._DEBUG      = false
local posix    = require("posix")
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

package.path  = cmd_dir .. "../tools/?.lua;"       ..
                cmd_dir .. "../tools/?/init.lua;"  ..
                cmd_dir .. "?.lua;"                ..
                sys_lua_path
package.cpath = cmd_dir .. "../lib/?.so;"..
                sys_lua_cpath

require("strict")
require("string_utils")
require("pairsByKeys")
local dbg       = require("Dbg"):dbg()
local lfs       = require("lfs")
local Optiks    = require("Optiks")
local s_mainTbl = {}

function cmdDir()
   return cmd_dir
end

function optionTbl()
   return s_mainTbl
end

function isDir(d)
   if (d == nil) then return false end
   local attr    = lfs.attributes(d)
   return (attr and attr.mode == "directory")
end

function myInsert(appendFlg, existFlg,maxIdx)
   if (appendFlg) then
      if (existFlg) then
         return function (t, k, v) if (isDir(v)) then t[k] = maxIdx + v end end
      else
         return function (t, k, v) t[k] = maxIdx + v end
      end
   else
      if (existFlg) then
         return function (t, k, v) if (isDir(v)) then t[k] = -v end end
      else
         return function (t, k, v) t[k] = -v end
      end
   end
end

function myClean(cleanFlg)
   if (cleanFlg) then
      return function (path)
                path = path:gsub('//','/')
                if (path:sub(-1,-1) == '/') then
                   path = path:sub(1,-2)
                end
                if (path == "") then path = false end
                return path
             end
   else
      return function (path)
                if (path == "") then path = false end
                return path
             end
   end
end

function main()

   local removeTbl  = table.remove
   local concatTbl  = table.concat
   local envVarA = {}

   ------------------------------------------------------------------------
   -- evaluate command line arguments
   options()

   local optionTbl = optionTbl()
   local pargs     = optionTbl.pargs
   local cleanFlg  = optionTbl.cleanFlg
   local delim     = optionTbl.delim

   local envVarNm  = pargs[1]
   local envVar    = os.getenv(envVarNm)
   local cleanPath = myClean(cleanFlg)

   if (optionTbl.debug) then
      dbg:activateDebug(1)
   end
   dbg.print{"envVarNm: ",envVarNm,"\n"}

   dbg.printT("pargs",pargs)

   removeTbl(pargs,1)

   local function l_build_array(s,A)
      if (s == ":") then
         A[#A + 1] = false
      else
         for path in s:split(':') do
            A[#A+1] = cleanPath(path)
         end
      end
   end

   ------------------------------------------------------------------------
   -- Convert empty string input values into false and clean path if requested
   -- Also separate colons into separate arguments
   local valueA    = {}
   for j = 1,#pargs do
      l_build_array(pargs[j], valueA)
   end

   dbg.printT("valueA",valueA)


   ------------------------------------------------------------------------
   -- Convert empty string envVar values into false and clean path if requested
   if (envVar) then
      l_build_array(envVar, envVarA)
   end

   dbg.printT("envVarA",envVarA)
   ------------------------------------------------------------------------
   -- Make a hash table of input values
   local valueT = {}
   for j = 1, #valueA do
      local path = valueA[j]
      if (not valueT[path]) then
         valueT[path] = j
      end
   end

   dbg.printT("valueT",valueT)

   local envVarT = {}
   local maxIdx  = #envVarA

   for j = 1,#envVarA do
      local path = envVarA[j]
      if (not envVarT[path]) then
         envVarT[path] = j
      end
   end

   dbg.printT("Before envVarT",envVarT)

   local insert = myInsert(optionTbl.appendFlg, optionTbl.existFlg, maxIdx)

   for path, idx in pairs(valueT) do
      insert(envVarT, path, idx)
   end

   dbg.printT("After envVarT",envVarT)

   local a = {}
   for path, idx in pairs(envVarT) do
      a[#a+1] = {path=path, value = idx}
   end

   table.sort(a, function(x,y) return x.value < y.value end)
   local newA = {}
   for i = 1, #a do
      newA[i] = a[i].path or ""
   end
   dbg.printT("newA",newA)

   io.stdout:write(concatTbl(newA,delim),"\n")
end


function options()
   local optionTbl = optionTbl()
   local usage         = "Usage: addto [options] envVar path1 path2 ..."
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{
      name   = {'--append'},
      dest   = 'appendFlg',
      action = 'store_true',
      default = false,
   }

   cmdlineParser:add_option{
      name   = {'-e', '--exist', '--exists'},
      dest   = 'existFlg',
      action = 'store_true',
      default = false,
   }

   cmdlineParser:add_option{
      name   = {'-d', '--delete'},
      dest   = 'delete',
      action = 'store_true',
      default = false,
   }

   cmdlineParser:add_option{
      name   = {'-D', '--debug'},
      dest   = 'debug',
      action = 'store_true',
      default = false,
   }

   cmdlineParser:add_option{
      name   = {'--clean'},
      dest   = 'cleanFlg',
      action = 'store_true',
      default = false,
      help    = "Remove extra '/'s"
   }

   cmdlineParser:add_option{
      name   = {'--sep', '--delim'},
      dest   = 'delim',
      action = 'store',
      default = ":",
      help    = "delimiter (default is ':')"
   }

   local optTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optTbl) do
      optionTbl[v] = optTbl[v]
   end
   optionTbl.pargs = pargs

end

main()
