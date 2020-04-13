#!@path_to_lua@/lua
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
require("serializeTbl")
require("pairsByKeys")
require("fileOps")
require("capture")
require("utils")
MF_Base = require("MF_Base")

local Version      = "0.0"
local dbg          = require("Dbg"):dbg()
local Optiks       = require("Optiks")
local getenv       = os.getenv
local getenv_posix = posix.getenv
local setenv_posix = posix.setenv
local concatTbl    = table.concat
local s_master     = {}
local load         = (_VERSION == "Lua 5.1") and loadstring or load
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

local ignoreA = {
   "BASH_ENV",
   "COLUMNS",
   "DISPLAY",
   "EDITOR",
   "ENV",
   "ENV2",
   "GROUP",
   "HISTFILE",
   "HISTSIZE",
   "HOME",
   "HOST",
   "HOSTTYPE",
   "LC_ALL",
   "LINES",
   "LMOD_CMD",
   "LMOD_DIR",
   "LMOD_PKG",
   "LMOD_ROOT",
   "LMOD_SETTARG_CMD",
   "LMOD_SETTARG_FULL_SUPPORT",
   "LMOD_VERSION",
   "LOGNAME",
   "MACHTYPE",
   "MAILER",
   "MODULESHOME",
   "OLDPWD",
   "OSTYPE",
   "PAGER",
   "PRINTER",
   "PS1",
   "PS2",
   "PWD",
   "REMOTEHOST",
   "REPLYTO",
   "SHELL",
   "SHLVL",
   "SSH_ASKPASS",
   "SSH_CLIENT",
   "SSH_CONNECTION",
   "SSH_TTY",
   "TERM",
   "TTY",
   "TZ",
   "USER",
   "VENDOR",
   "VISUAL",
   "_",
   "module",
}



--------------------------------------------------------------------------
-- Capture output and exit status from *cmd*
-- @param cmd A string that contains a unix command.
-- @param envT A table that contains environment variables to be set/restored when running *cmd*.
function capture(cmd, envT)
   dbg.start{"capture(",cmd,")"}
   if (dbg.active()) then
      dbg.print{"cwd: ",posix.getcwd(),"\n",level=2}
   end

   local newT = {}
   envT = envT or {}

   for k, v in pairs(envT) do
      dbg.print{"envT[",k,"]=",v,"\n"}
      newT[k] = getenv(k)
      dbg.print{"newT[",k,"]=",newT[k],"\n"}
      setenv_posix(k, v, true)
   end

   -- in Lua 5.1, p:close() does not return exit status,
   -- so we append 'echo $?' to the command to determine the exit status
   local ec_msg = "Lmod Capture Exit Code"
   if _VERSION == "Lua 5.1" then
      cmd = cmd .. '; echo "' .. ec_msg .. ': $?"'
   end

   local out
   local status
   local p   = io.popen(cmd)
   if (p ~= nil) then
      out    = p:read("*all")
      status = p:close()
   end

   -- trim 'exit code: <value>' from the end of the output and determine exit status
   if _VERSION == "Lua 5.1" then
      local exit_code = out:match(ec_msg .. ": (%d+)\n$")
      if not exit_code then
         LmodError("Failed to find '" .. ec_msg .. "' in output: " .. out)
      end
      status = exit_code == '0'
      out = out:gsub(ec_msg .. ": %d+\n$", '')
   end

   for k, v in pairs(newT) do
      setenv_posix(k,v, true)
   end

   if (dbg.active()) then
      dbg.start{"capture output()",level=2}
      dbg.print{out}
      dbg.fini("capture output")
   end
   dbg.print{"status: ",status,", type(status): ",type(status),"\n"}
   dbg.fini("capture")
   return out, status
end

function masterTbl()
   return s_master
end

function wrtEnv(fn)
   local envT = getenv_posix()
   local s    = serializeTbl{name="envT", value = envT, indent = true}
   if (fn == "-") then
      io.stdout:write(s)
   else
      local f    = io.open(fn,"w")
      if (f) then
         f:write(s,"\n")
         f:close()
      end
   end
end

function splice(a, is, ie)
   local b = {}
   for i = 1, is-1 do
      b[i] = a[i]
   end

   for i = ie+1, #a do
      b[#b+1] = a[i]
   end
   return b
end

function path_regularize(value)
   if (value == nil) then return nil end
   local tail = (value:sub(-1,-1) == "/") and "/" or ""

   value = value:gsub("^%s+","")
   value = value:gsub("%s+$","")
   value = value:gsub("//+","/")
   value = value:gsub("/%./","/")
   value = value:gsub("/$","")
   return value .. tail
end

function path2pathA(path)
   local sep = ":"
   if (not path) then
      return {}
   end
   if (path == '') then
      return { '' }
   end

   local pathA = {}
   for v  in path:split(sep) do
      pathA[#pathA + 1] = path_regularize(v)
   end
   return pathA
end

local function cleanPath(value)

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

function indexPath(old, oldA, new, newA)
   dbg.start{"indexPath(",old, ", ", new,")"}
   local oldN = #oldA
   local newN = #newA
   local idxM = newN - oldN + 1

   dbg.print{"oldN: ",oldN,", newN: ",newN,"\n"}

   if (oldN >= newN or newN == 1) then
      if (old == new) then
         dbg.fini("(1) indexPath")
         return 1
      end
      dbg.fini("(2) indexPath")
      return -1
   end

   local icnt = 1

   local idxO = 1
   local idxN = 1

   while (true) do
      local oldEntry = oldA[idxO]
      local newEntry = newA[idxN]

      icnt = icnt + 1
      if (icnt > newN) then
         break
      end


      if (oldEntry == newEntry) then
         idxO = idxO + 1
         idxN = idxN + 1

         if (idxO > oldN) then break end
      else
         idxN = idxN + 2 - idxO
         idxO = 1
         if (idxN > idxM) then
            dbg.fini("(3) indexPath")
            return -1
         end
      end
   end

   idxN = idxN - idxO + 1

   dbg.print{"idxN: ", idxN, "\n"}

   dbg.fini("indexPath")
   return idxN

end

function cleanEnv()
   local envT = getenv_posix()

   for k, v in pairs(envT) do
      local keep = keepT[k]
      if (not keep) then
         setenv_posix(k, nil, true)
      elseif (keep == 'neat') then
         setenv_posix(k, cleanPath(v), true)
      end
   end
end



function main()
   ------------------------------------------------------------------------
   -- evaluate command line arguments
   options()
   local masterTbl = masterTbl()
   local pargs     = masterTbl.pargs

   local ignoreT = {}
   for i = 1, #ignoreA do
      ignoreT[ignoreA[i]] = true
   end

   if (masterTbl.debug > 0) then
      dbg:activateDebug(masterTbl.debug)
   end


   if (masterTbl.saveEnvFn) then
      wrtEnv(masterTbl.saveEnvFn)
      os.exit(0)
   end

   local LuaCmd = "@path_to_lua@/lua"
   local found

   if (LuaCmd:sub(1,1) == "@") then
      LuaCmd, found = findInPath("lua")
      if (not found) then
         io.stderr:write("Unable to find lua program")
         return
      end
   end

   if (masterTbl.cleanEnv) then
      cleanEnv()
   end

   local oldEnvT = getenv_posix()
   local cmdA    = false

   if(masterTbl.inStyle:lower() == "csh") then
      cmdA    = {
         "csh", "-f","-c",
         "\"source " ..concatTbl(pargs," ") .. '>& /dev/null; '.. LuaCmd .. " " .. programName() .. " --saveEnv -\""
      }
   else -- Assume bash unless told otherwise
      cmdA    = {
         "bash", "--noprofile","--norc","-c",
         "\". " ..concatTbl(pargs," ") .. '>/dev/null 2>&1; '.. LuaCmd .. " " .. programName() .. " --saveEnv -\""
      }
   end

   dbg.print{"cmd: ",concatTbl(cmdA," "),"\n"}

   local s = capture(concatTbl(cmdA," "))

   if (masterTbl.debug > 0) then
      local f = io.open("s.log","w")
      if (f) then
         f:write(s)
         f:close()
      end
   end

   local factory = MF_Base.build(masterTbl.style)

   assert(load(s))()

   s = concatTbl(factory:process(ignoreT, oldEnvT, envT),"\n")
   if (masterTbl.outFn) then
      local f = io.open(masterTbl.outFn,"w")
      if (f) then
         f:write(s,"\n")
         f:close()
      else
         io.stderr:write("Unable to write modulefile named: ",masterTbl.outFn,"\n")
         os.exit(1);
      end
   else
      print(s)
   end
end

function usage()
   return "Usage: sh_to_modulefile [options] bash_shell_script [script_options]"
end


function my_error(...)
   local argA = pack(...)
   for i = 1, argA.n do
      io.stderr:write(argA[i])
   end
   io.stderr:write("\n",usage(),"\n")
end



function options()
   local masterTbl     = masterTbl()
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
   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end

main()
