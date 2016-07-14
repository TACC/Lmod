#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Fixme
-- @script clearMT_cmd

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
local posix    = require("posix")
local readlink = posix.readlink
local stat     = posix.stat

local st       = stat(arg_0)
while (st.type == "link") do
   arg_0 = readlink(arg_0)
   st    = stat(arg_0)
end

local ia,ja = arg_0:find(".*/")
local cmd_dir = "./"
if (ia) then
   cmd_dir = arg_0:sub(1,ja)
end

package.path  = cmd_dir .. "../tools/?.lua;" ..
                cmd_dir .. "?.lua;"          ..
                sys_lua_path
package.cpath = sys_lua_cpath

require("strict")
require("fileOps")

local concatTbl    = table.concat
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge

function cmdDir()
   return cmd_dir
end
function bash_export(name, value)
   local a = {}
   if (value == "") then
      a[#a+1] = "unset "
      a[#a+1] = name
      a[#a+1] = ";\n"
   else
      a[#a+1] = name
      a[#a+1] = "=\""
      a[#a+1] = value
      a[#a+1] = "\"; export "
      a[#a+1] = name
      a[#a+1] = ";\n"
   end
   io.stdout:write(concatTbl(a,""))
end

function csh_setenv(name, value)
   local a = {}
   if (value == "") then
      a[#a+1] = "unsetenv "
      a[#a+1] = name
      a[#a+1] = ";\n"
   else
      a[#a+1] = "setenv "
      a[#a+1] = name
      a[#a+1] = " \""
      a[#a+1] = value
      a[#a+1] = "\";\n"
   end
   io.stdout:write(concatTbl(a,""))
end

function python_setenv(name, value)
   local a = {}
   if (value == "") then
      a[#a + 1] = "os.environ['"
      a[#a + 1] = name
      a[#a + 1] = "'] = ''\n"
      a[#a + 1] = "del os.environ['"
      a[#a + 1] = name
      a[#a + 1] = "']\n"
   else
      a[#a + 1] = "os.environ['"
      a[#a + 1] = name
      a[#a + 1] = "'] = '"
      a[#a + 1] = value
      a[#a + 1] = "';\n"
   end
   io.stdout:write(concatTbl(a,""))
end

function main()
   local setenv = bash_export
   if ( arg[1] == "csh" ) then
      setenv = csh_setenv
   end

   if ( arg[1] == "python" ) then
      setenv = python_setenv
   end

   for k = 1, huge do
      local name = format("_ModuleTable%03d_",k)
      local v = getenv(name)
      if (v == nil) then break end
      setenv(name,"")
   end
   local mpath = getenv("LMOD_DEFAULT_MODULEPATH") or ""
   setenv("MODULEPATH",              mpath)
   setenv("_ModuleTable_Sz_",        "")
   setenv("LMOD_DEFAULT_MODULEPATH", "")
end

main()
