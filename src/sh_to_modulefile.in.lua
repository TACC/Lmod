#!@path_to_lua@
-- -*- lua -*-

--------------------------------------------------------------------------
-- This program takes shell scripts (either bash or csh) and converts
-- them to a modulefile (either Lua or TCL).  This program is a "new"
-- but it is based on many design elements from sourceforge.net/projects/env2.
-- The program "env2" also converts shells to modulefiles but it does
-- other conversions as well.  This program is more limited it just does
-- conversions from scripts to tcl or lua modules.
--
--  Basic design:
--     a) capture the output of the supplied script and use this program
--        to generate a lua table of the Environment.
--     b) create an output factory:  MF_Lmod or MF_TCL to generate the
--        output modulefile style.
--     c) Process the before environment with the after environment and
--        generate the appropriate setenv's, prepend_path's and
--        append_path's to convert from the old env to the new.
--
--
--  Tricks:
--     The main problem with doing this is find the overlap in path-like
--     variables.  Suppose you have:
--          PATH="b:c:d"
--     and the result after sourcing the shell script is:
--          PATH="a:b:c:d:e"
--     This program finds the overlap starting with "b" and then can
--     report that "a" needs to be prepended and "e" needs to be appended.
--
-- @script sh_to_modulefile

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

--------------------------------------------------------------------------
--  sh_to_modulefile :

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
   cmd_dir  = arg_0:sub(1,ja)
end

package.path  = cmd_dir .. "../tools/?.lua;"      ..
                cmd_dir .. "../tools/?/init.lua;" ..
                cmd_dir .. "?.lua;"               ..
                sys_lua_path
package.cpath = cmd_dir .. "../lib/?.so;"..
                sys_lua_cpath

require("strict")

function cmdDir()
   return cmd_dir
end

function programName()
   return arg_0
end

require("string_utils")
require("pairsByKeys")
require("fileOps")
require("utils")

local Version      = "0.0"
local dbg          = require("Dbg"):dbg()
local Optiks       = require("Optiks")
local concatTbl    = table.concat
local getenv       = os.getenv
local getenv_posix = posix.getenv
local setenv_posix = posix.setenv
local s_optionTbl  = {}
local pack         = (_VERSION == "Lua 5.1") and argsPack or table.pack -- luacheck: compat
envT               = false

local keepT = {
   ['HOME']            = 'keep',
   ['USER']            = 'keep',
   ['LD_LIBRARY_PATH'] = 'keep',
   ['LUA_CPATH']       = 'keep',
   ['LUA_PATH']        = 'keep',
   ['PATH']            = 'neat',
}

local execT = {
   gcc    = 'keep',
   lua    = 'keep',
   python = 'keep',
   csh    = 'keep',
   bash   = 'keep',
}


function optionTbl()
   return s_optionTbl
end

local function l_cleanPath(value)

   local pathT  = {}
   local pathA  = {}

   local idx = 0
   for path in value:split(':') do
      idx = idx + 1
      path = path_regularize(path)
      if (pathT[path] == nil) then
         pathT[path]     = { idx = idx, keep = false }
         pathA[#pathA+1] = path
      end
   end

   local myPath = concatTbl(pathA,':')
   pathA        = {}

   for execName in pairs(execT) do
      local cmd, found = findInPath(execName, myPath)
      if (found) then
         local dir = dirname(cmd):gsub("/+$","")
         local p = path_regularize(dir)
         if (p and pathT[p]) then
            pathT[p].keep = true
         end
      end
   end

   for path in pairs(pathT) do
      if (value:find('^/usr/')) then
         pathT[path].keep = true
      end
   end

   -- Step 1: Make a sparse array with path as values
   local t = {}

   for k, v in pairs(pathT) do
      if (v.keep) then
         t[v.idx] = k
      end
   end

   -- Step 2: Use pairsByKeys to copy paths into pathA in correct order
   local n = 0
   for _, v in pairsByKeys(t) do
      n = n + 1
      pathA[n] = v
   end

   -- Step 3: rebuild path
   return concatTbl(pathA,':')
end

function l_cleanEnv()
   local envT = getenv_posix()

   for k, v in pairs(envT) do
      local keep = keepT[k]
      if (not keep) then
         setenv_posix(k, nil, true)
      elseif (keep == 'neat') then
         setenv_posix(k, l_cleanPath(v), true)
      end
   end
end

function main()
   ------------------------------------------------------------------------
   -- evaluate command line arguments
   options()
   local optionTbl    = optionTbl()
   local pargs        = optionTbl.pargs
   local script       = concatTbl(pargs," ")
   local convertSh2MF = require("convertSh2MF")

   if (optionTbl.debug > 0) then
      dbg:activateDebug(optionTbl.debug)
   end

   initialize_lmod()
   if (optionTbl.cleanEnv) then
      l_cleanEnv()
   end

   local shellName = optionTbl.inStyle:lower()

   local success, msg, a = convertSh2MF(shellName, optionTbl.style, script)
   if (not success) then
      io.stderr:write(msg,"\n")
      os.exit(1)
   end


   local s = concatTbl(a,"\n")

   if (optionTbl.outFn) then
      local f = io.open(optionTbl.outFn,"w")
      if (f) then
         f:write(s,"\n")
         f:close()
      else
         io.stderr:write("Unable to write modulefile named: ",optionTbl.outFn,"\n")
         os.exit(1);
      end
   else
      print(s)
   end
end

function usage()
   return "Usage: $LMOD_DIR/sh_to_modulefile [options] bash_shell_script [script_options]"
end


function my_error(...)
   local argA = pack(...)
   for i = 1, argA.n do
      io.stderr:write(argA[i])
   end
   io.stderr:write("\n",usage(),"\n")
end



function options()
   local optionTbl     = optionTbl()
   local cmdlineParser = Optiks:new{usage   = usage(),
                                    error   = my_error,
                                    version = Version}


   cmdlineParser:add_option{
      name   = {"-D"},
      dest   = "debug",
      action = "count",
      help   = "Program tracing written to stderr",
   }
   cmdlineParser:add_option{
      name   = {'--saveEnv'},
      dest   = 'saveEnvFn',
      action = 'store',
      help   = "Internal use only",
   }

   cmdlineParser:add_option{
      name   = {'--cleanEnv'},
      dest   = 'cleanEnv',
      action = 'store_true',
      help   = "Create a sterile user environment before analyzing",
   }

   cmdlineParser:add_option{
      name   = {'-o','--output'},
      dest   = 'outFn',
      action = 'store',
      help   = "output modulefile",
   }

   cmdlineParser:add_option{
      name    = {'--to'},
      dest    = 'style',
      action  = 'store',
      help    = "Output style: either TCL or Lua. (default: Lua)",
      default = "Lua",
   }

   cmdlineParser:add_option{
      name    = {'--from'},
      dest    = 'inStyle',
      action  = 'store',
      help    = "Input style: either bash or csh. (default: bash)",
      default = "bash",
   }
   local optTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optTbl) do
      optionTbl[v] = optTbl[v]
   end
   optionTbl.pargs = pargs

end

main()
