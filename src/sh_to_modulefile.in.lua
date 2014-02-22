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

local program = arg[0]

local i,j = program:find(".*/")
local cmd_dir = "./"
if (i) then
   cmd_dir = program:sub(1,j)
end
package.path = cmd_dir .. "../tools/?.lua;" ..
               cmd_dir .. "?.lua;"       .. package.path

require("strict")
require("string_split")
require("serializeTbl")
require("pairsByKeys")

local Version   = "0.0"
local dbg       = require("Dbg"):dbg()
local Optiks    = require("Optiks")
local posix     = require("posix")
local concatTbl = table.concat
local s_master  = {}
envT            = false


local ignoreA = {
   "BASH_ENV", "COLUMNS", "DISPLAY", "ENV", "HOME", "LINES", "LOGNAME", "PWD", "SHELL",
   "SHLVL", "LC_ALL", "SSH_ASKPASS", "SSH_CLIENT", "SSH_CONNECTION", "SSH_TTY", "TERM",
   "USER", "EDITOR", "HISTFILE", "HISTSIZE", "MAILER", "PAGER", "REPLYTO", "VISUAL",
   "_", "ENV2", "OLDPWD", "PS1","PS2", "PRINTER", "TTY", "TZ",
}

function masterTbl()
   return s_master
end

function wrtEnv(fn)
   local envT = posix.getenv()
   local s    = serializeTbl{name="envT", value = envT, indent = true}
   local f    = io.open(fn,"w")
   if (f) then
      f:write(s,"\n")
      f:close()
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
      if (icnt > 5) then
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
            dbg.fini("indexPath")
            return -1
         end
      end
   end

   idxN = idxN - idxO + 1

   dbg.print{"idxN: ", idxN, "\n"}

   dbg.fini("indexPath")
   return idxN

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

   local oldEnvT = posix.getenv()
   local fn      = os.tmpname()
   local cmdA    = {
      "/bin/bash", "--noprofile","--norc","-c",
      "\". " ..concatTbl(pargs," ") .. '; ' .. program .. " --saveEnv ".. fn .. "\""
   }
   
   os.execute(concatTbl(cmdA," "))
   
   assert(loadfile(fn))()

   local s = concatTbl(process(ignoreT, oldEnvT, envT),"\n")
   if (masterTbl.outFn) then
      f = io.open(masterTbl.outFn,"w")
      f:write(s)
      f:close()
   else
      print(s)
   end
end

function process(ignoreT, oldEnvT, envT)

   dbg.start{"process(ignoreT, oldEnvT, envT)"}
   local a = {}

   for k, v in pairsByKeys(envT) do
      dbg.print{"k: ", k, ", v: ", v, ", oldV: ",oldEnvT[k],"\n"}
      if (not ignoreT[k]) then
         local oldV = oldEnvT[k]
         if (not oldV) then
            a[#a+1] = "setenv(\"" .. k .. "\",\"" .. v .. ")"
         else
            local oldA = path2pathA(oldV)
            local newA = path2pathA(v)
            local idx  = indexPath(oldV, oldA, v, newA)
            if (idx < 0) then
               a[#a+1] = "setenv(\"" .. k .. "\",\"" .. v .. ")"
            else
               newA = splice(newA, idx, #oldA + idx - 1)
               for i = idx-1, 1, -1 do
                  a[#a+1] = "prepend_path(\"" .. k .. "\",\"" .. newA[i] .. ")"
               end
               for i = idx, #newA do
                  a[#a+1] = "append_path(\"" .. k .. "\",\"" .. newA[i] .. ")"
               end
            end
         end
      end
   end
                  
   dbg.fini("process")
   return a
end


function options()
   local masterTbl     = masterTbl()
   local usage         = "Usage: sh_to_modulefile [options] bash_shell_script [script_options]"
   local cmdlineParser = Optiks:new{usage=usage, version=Version}


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
      name   = {'-o','--output'},
      dest   = 'outFn',
      action = 'store',
      help   = "output modulefile",
   }
   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end

main()
