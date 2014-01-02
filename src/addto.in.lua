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

local cmd = arg[0]

local i,j = cmd:find(".*/")
local cmd_dir = "./"
if (i) then
   cmd_dir = cmd:sub(1,j)
end
package.path = cmd_dir .. "../tools/?.lua;" ..
               cmd_dir .. "?.lua;"       .. package.path

require("strict")
require("string_split")
require("pairsByKeys")
local lfs    = require("lfs")
local Optiks = require("Optiks")
local s_masterTbl = {}

function cmdDir()
   return cmd_dir
end

function masterTbl()
   return s_masterTbl
end

function isDir(d)
   if (d == nil) then return false end

   local attr    = lfs.attributes(d)
   local results = (attr and attr.mode == "directory")

   return result
end

function myInsert(appendFlg, existFlg)
   local insert = table.insert
   if (appendFlg) then
      if (existFlg) then
         return function (arr, v) if (isDir(v)) then insert(arr, v) end end
      else
         return function (arr, v) insert(arr, v) end
      end
   else
      if (existFlg) then
         return function (arr, v) if (isDir(v)) then insert(arr, 1, v) end end
      else
         return function (arr, v) insert(arr, 1, v) end
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
                return path
             end
   else
      return function (path)
                return path
             end
   end
end

function myChkDir(existFlg)
   if (existFlg)  then
      return function(path) return isDir(path) end
   else
      return function(path) return true end
   end
end

function main()

   local remove  = table.remove
   local concat  = table.concat
   local envVarA = {}

   ------------------------------------------------------------------------
   -- evaluate command line arguments
   options()

   local masterTbl = masterTbl()
   local pargs     = masterTbl.pargs
   local cleanFlg  = masterTbl.cleanFlg
   local sep       = masterTbl.sep

   local envVar    = os.getenv(pargs[1])
   local insert    = myInsert(masterTbl.appendFlg, masterTbl.existFlg)
   local cleanPath = myClean(cleanFlg)
   local chkDir    = myChkDir(masterTbl.existFlg)

   if (envVar) then
      for v in envVar:split(sep) do
	 envVarA[#envVarA + 1] = cleanPath(v)
      end
   end

   if (masterTbl.delete) then
      local entry = masterTbl.delete
      local a     = envVarA
      envVarA = {}
      for i = 1,#a do
         if (entry ~= a[i]) then
            envVarA[#envVarA+1] = a[i]
         end
      end
   end

   remove(pargs,1)

   for _,v in ipairs(pargs) do
      v = cleanPath(v)
      for i,path in ipairs(envVarA) do
	 if (v == path) then
	    remove(envVarA, i)
	    break
	 end
      end

      insert(envVarA, v)
   end

   if (cleanFlg) then
      local t = {}
      local tt = {}
      for i,v in ipairs(envVarA) do
         if ( not tt[v] and chkDir(v)) then
            t[i] = v
            tt[v] = i
         end
      end
      envVarA = {}
      for k, v in pairsByKeys(t) do
         envVarA[#envVarA+1] = v
      end
   end

   if (masterTbl.verbosityLevel > 0) then
      for i,v in ipairs(envVarA) do
	 io.stdout:write(i,"%",v,"%\n")
      end
   end

   if (envVarA[#envVarA] == "") then
      envVarA[#envVarA+1] = ""
   end

   io.stdout:write(concat(envVarA,sep),"\n")
end


function options()
   local masterTbl = masterTbl()
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
      action = 'store',
      default = nil,
   }

   cmdlineParser:add_option{
      name   = {'--clean'},
      dest   = 'cleanFlg',
      action = 'store_true',
      default = false,
      help    = "Remove extra '/'s"
   }

   cmdlineParser:add_option{
      name   = {'--sep'},
      dest   = 'sep',
      action = 'store',
      default = ":",
      help    = "separator (default is ':')"
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end

main()
