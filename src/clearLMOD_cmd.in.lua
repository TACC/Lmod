#!@path_to_lua@
-- -*- lua -*-

--------------------------------------------------------------------------
-- Fixme
-- @script clearLMOD_cmd

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
local getenv   = posix.getenv

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

require("strict")
require("fileOps")

local concatTbl    = table.concat
local strfmt       = string.format
local huge         = math.huge
local s_optionTbl  = {}
local Optiks       = require("Optiks")


function optionTbl()
   return s_optionTbl
end

function cmdDir()
   return cmd_dir
end

function bash_unset(name)
   io.stdout:write("unset -f ",name," 2> /dev/null || true;\n")
end

function csh_unset(name)
   io.stdout:write("unalias ",name,";\n")
end

function python_unset(name)
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

function options()
   local optionTbl     = optionTbl()
   local usage         = "Usage: "
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{ 
      name   = {'-q','--quiet'},
      dest   = 'quiet',
      action = 'store_true',
   }

   cmdlineParser:add_option{ 
      name   = {'--simple'},
      dest   = 'simple',
      action = 'store_true',
   }

   cmdlineParser:add_option{ 
      name   = {'--full'},
      dest   = 'full',
      action = 'store_true',
   }

   cmdlineParser:add_option{ 
      name    = {'-s','--shell'},
      dest    = 'shell',
      action  = 'store',
      default = 'bash',
   }
   local optTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optTbl) do
      optionTbl[v] = optTbl[v]
   end
   optionTbl.pargs = pargs

end

function main()
   local optionTbl     = optionTbl()
   options()
   
   local setenv = bash_export
   local unset  = bash_unset
   if ( optionTbl.shell == "csh" ) then
      setenv = csh_setenv
      unset  = csh_unset
   end

   if ( optionTbl.shell == "python" ) then
      setenv = python_setenv
      unset  = python_unset
   end

   setenv("_ModuleTable_Sz_", "")
   setenv("LOADEDMODULES",    "")
   setenv("_LMFILES_",        "")

   if (not optionTbl.full) then
      for k = 1, huge do
         local name = strfmt("_ModuleTable%03d_",k)
         local v = getenv(name)
         if (v == nil) then break end
         setenv(name,"")
      end
      for key, value in pairs(getenv()) do
         if ( key:find("^__LMOD_REF_COUNT_")) then
            setenv(key,"")
         end
      end
      return
   end
   if (not optionTbl.quiet) then
      io.stderr:write("Executing a module purge and removing all Lmod environment variables, aliases and shell functions\n")
      io.stderr:write("This includes the module and ml commands!\n")
   end

   --------------------------------------------------------------
   -- If here then remove LMOD completely from the environment

   setenv("SETTARG_TAG1",           "")
   setenv("SETTARG_TAG2",           "")
   setenv("MODULESHOME",            "")
   setenv("MODULEPATH",             "")
   setenv("MODULEPATH_ROOT",        "")
   setenv("LMOD_MODULERCFILE",      "")   
   setenv("LMOD_MODULERC",          "")   
   setenv("MODULERCFILE",           "")   
   setenv("TARG_TITLE_BAR_PAREN",   "")   
   setenv("__Init_Default_Modules", "")
   
   unset("module")
   unset("ml")
   unset("clearMT")
   unset("clearLmod")
   unset("xSetTitleLmod")

   for key, value in pairs(getenv()) do
      if ( key:find("^LMOD")                   or
              key:find("^_ModuleTable%d%d+_")   ) then
         setenv(key,"")
      end
   end
end

main()
