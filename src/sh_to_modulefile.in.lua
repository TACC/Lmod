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
local replaceStr   = require("replaceStr")
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
   "LMOD_FULL_SETTARG_SUPPORT",
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
      --dbg.print{"envT[",k,"]=",v,"\n"}
      newT[k] = getenv(k)
      --dbg.print{"newT[",k,"]=",newT[k],"\n"}
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

function sh_to_mf(shellName, style, script)

   local validShellT =
      {
         tcsh = "tcsh",
         csh  = "tcsh",
         sh   = "sh",
         dash = "sh",
         bash = "bash",
         zsh  = "zsh",
         fish = "fish",
         rc   = "rc",
         ksh  = "ksh",
      }
         
   shellName = validShellT[shellName] or "bash"

   local shellTemplateT =
      {
         tcsh = { args = "-e -f -c",             flgErr = "",                source = "source", redirect = ">& /dev/stdout", alias = "alias", funcs = "" },
         bash = { args = "--noprofile -norc -c", flgErr = "set -e;",         source = ".",      redirect = "2>&1",           alias = "alias", funcs = "declare -f" },
         ksh  = { args = "-c",                   flgErr = "set -e;",         source = ".",      redirect = "2>&1",           alias = "alias", funcs = "typeset +f | while read f; do typeset -f ${f%\\(\\)}; echo; done" },
         zsh  = { args = "-f -c",                flgErr = "setopt errexit;", source = ".",      redirect = "2>&1",           alias = "alias", funcs = "declare -f" },
      }
   local shellT    = shellTemplateT[shellName]
   if (shellT == nil) then
      shellT    = shellTemplateT.bash
      shellName = "bash"
   end
   
   local ignoreT = {}
   for i = 1, #ignoreA do
      ignoreT[ignoreA[i]] = true
   end

   local sep    = "%__________blk_divider__________%"

   local LuaCmd = findLuaProg()
   local cmdA   = {
      "%{shell}",
      "%{shellArgs}",
      "\"",
      "%{flgErr}",
      "%{printEnvT} oldEnvT;",
      "echo %{sep};",
      "%{alias};",
      "echo %{sep};",
      "%{funcs};",
      "echo %{sep};",
      "%{source} %{script} %{redirect};",
      "echo %{sep};",
      "%{printEnvT} envT;",
      "echo %{sep};",
      "%{alias};",
      "echo %{sep};",
      "%{funcs};",
      "echo %{sep};",
      "\"",
   }

   local t     = {}

   t.shell     = findInPath(shellName)
   t.shellArgs = shellT.args
   t.printEnvT = LuaCmd .. " " .. pathJoin(cmdDir(),"printEnvT.lua")
   t.sep       = sep
   t.flgErr    = shellT.flgErr
   t.alias     = shellT.alias
   t.funcs     = shellT.funcs
   t.source    = shellT.source
   t.script    = script:gsub("\"","\\\\\"")
   t.redirect  = shellT.redirect

   local cmd   = replaceStr(concatTbl(cmdA," "), t)

   local output,status = capture(cmd)

   if (dbg.active()) then
      local f = io.open("s.log","w")
      if (f) then
         f:write(cmd,"\n")
         f:write(output)
         f:close()
      end
   end

   if (not status) then
      io.stderr:write("status: ",tostring(status)," Error in script!\n")
      os.exit(-1)
   end


   local processOrderA = { {"Vars", 1}, {"Aliases", 1}, {"Funcs", 1}, {"SourceScriptOutput", 0},
                           {"Vars", 2}, {"Aliases", 2}, {"Funcs", 2}}

   local resultT = { Vars    = {{},{}},
                     Aliases = {{},{}},
                     Funcs   = {{},{}},
                   }
   sep = sep:escape()

   for i = 1, #processOrderA do
      repeat
         local idx,endIdx  = output:find(sep)
         local blk         = output:sub(1,idx-1)
         output            = output:sub(endIdx+1,-1)
         local blkName     = processOrderA[i][1]
         local irstIdx     = processOrderA[i][2]
         blk               = blk:gsub("^%s+","")
         if (irstIdx == 0) then break end
         resultT[blkName][irstIdx] = blk
      until (true)
   end
   
   local factory = MF_Base.build(style)

   local a, b = factory:process(shellName, ignoreT, resultT)

   if (dbg.active()) then
      io.stderr:write(concatTbl(b,"\n"),"\n")
   end

   return concatTbl(a,"\n")
end

function main()
   ------------------------------------------------------------------------
   -- evaluate command line arguments
   options()
   local masterTbl = masterTbl()
   local pargs     = masterTbl.pargs
   local script    = concatTbl(pargs," ")

   if (masterTbl.debug > 0) then
      dbg:activateDebug(masterTbl.debug)
   end

   if (masterTbl.cleanEnv) then
      cleanEnv()
   end

   local shellName = masterTbl.inStyle:lower()

   local s = sh_to_mf(shellName, masterTbl.style, script)

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
