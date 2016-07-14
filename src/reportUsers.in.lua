#!@path_to_lua@/lua
-- -*- lua -*-

--------------------------------------------------------------------------
-- Fixme
-- @script reportUsers

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

package.path  = cmd_dir .. "../tools/?.lua;"  ..
                cmd_dir .. "../shells/?.lua;" ..
                cmd_dir .. "?.lua;"           ..
                sys_lua_path
package.cpath = sys_lua_cpath


require("strict")
require("string_utils")
require("pairsByKeys")
local Optiks = require("Optiks")

blacklistT = {
   abenitez  = 1,
   adamk     = 1,
   akhil     = 1,
   bbarth    = 1,
   bdkim     = 1,
   bijeong   = 1,
   build     = 1,
   bwesting  = 1,
   carlos    = 1,
   cazes     = 1,
   ctjordan  = 1,
   david     = 1,
   dcarver   = 1,
   dgignac   = 1,
   dmontoya  = 1,
   dooley    = 1,
   eijkhout  = 1,
   ewalker   = 1,
   garland   = 1,
   gda       = 1,
   gjost     = 1,
   gregj     = 1,
   hliu      = 1,
   hpctest1  = 1,
   hpctest2  = 1,
   jbsnead   = 1,
   jlockman  = 1,
   jones     = 1,
   jtucker   = 1,
   jwozniak  = 1,
   karl      = 1,
   kelly     = 1,
   lars      = 1,
   lwilson   = 1,
   makoto    = 1,
   maytal    = 1,
   mccalphin = 1,
   mclay     = 1,
   mgonzales = 1,
   milfeld   = 1,
   minyard   = 1,
   mock      = 1,
   mrhanlon  = 1,
   peterson  = 1,
   phurley   = 1,
   pnav      = 1,
   praveen   = 1,
   root      = 1,
   sgeadmin  = 1,
   timm      = 1,
   train00   = 1,
   train101  = 1,
   train103  = 1,
   train104  = 1,
   train108  = 1,
   train110  = 1,
   train111  = 1,
   train112  = 1,
   train113  = 1,
   train114  = 1,
   train115  = 1,
   train116  = 1,
   train118  = 1,
   train120  = 1,
   train121  = 1,
   train124  = 1,
   train125  = 1,
   train126  = 1,
   train129  = 1,
   train130  = 1,
   train132  = 1,
   train133  = 1,
   train135  = 1,
   train136  = 1,
   train137  = 1,
   train139  = 1,
   train140  = 1,
   train319  = 1,
   turban    = 1,
   wsmith    = 1,
   xwj       = 1,
   yye00     = 1,
}

local s_masterTbl = {}

function masterTbl()
   return s_masterTbl
end

function main()
   options()
   local masterTbl  = masterTbl()
   local pargs      = masterTbl.pargs

   local moduleT    = {}   -- Deprecated module list
   local m2u        = {}   -- module to user table
   local u2m        = {}   -- user to module table

   if (masterTbl.moduleListFn == nil) then
      print("No list of deprecated modules, quiting!\n")
      return
   end

   local f     = assert(io.open(masterTbl.moduleListFn))
   local whole = f:read("*all")
   f:close()

   ----------------------------------------------------
   -- Save list of deprecated modules in [[moduleT]]

   for v in whole:split("\n") do
      v = v:trim()
      v = v:gsub("%.lua$","")
      moduleT[v] = 1
   end


   --------------------------------------------------------
   -- Loop over csv files for user using deprecated modules

   for _, fn in ipairs(pargs) do
      f     = assert(io.open(fn))
      whole = f:read("*all")
      f:close()

      for record in whole:split("\n") do
         local a    = fromCSV(record)
         local user = a[1]
         if (blacklistT[user] == nil) then
            for i = 3, #a do
               local module = a[i]:gsub("^.*:","")
               if (moduleT[module]) then
                  if (u2m[user] == nil) then
                     u2m[user] = {}
                  end
                  if (m2u[module] == nil) then
                     m2u[module] = {}
                  end
                  u2m[user][module] = 1
                  m2u[module][user] = 1
               end
            end
         end
      end
   end

   ----------------------------------------------------------
   -- Write out list of deprecated modules and the users that
   -- use them

   if (masterTbl.m2uFn) then
      f = assert(io.open(masterTbl.m2uFn, "w"))
      for module, v in pairsByKeys(m2u) do
         f:write(module)
         for user in pairs(v) do
            f:write(",",user)
         end
         f:write("\n")
      end
      f:close()
   end

   --------------------------------------------------------------
   -- Write out list of users and the deprecated modules they use

   if (masterTbl.u2mFn) then
      f = assert(io.open(masterTbl.u2mFn, "w"))
      for user, v in pairsByKeys(u2m) do
         f:write(user)
         for module in pairs(v) do
            f:write(",",module)
         end
         f:write("\n")
      end
      f:close()
   end

end

function options()
   local masterTbl     = masterTbl()
   local usage         = "Usage:  reportUsers [options] moduleUsage.csv ..."
   local cmdlineParser = Optiks:new{usage=usage, version="1.0"}

   cmdlineParser:add_option{
      name    = {"-d","--debug"},
      dest    = "debug",
      action  = "store_true",
      help    = "Turn on tracing",
      default = false,
   }

   cmdlineParser:add_option{
      name    = {"-f","--file"},
      dest    = "moduleListFn",
      action  = "store",
      help    = "File containing a list of deprecated modules",
      default = false,
   }

   cmdlineParser:add_option{
      name    = {"--m2u"},
      dest    = "m2uFn",
      action  = "store",
      help    = "output file containing list of deprecated modules and the users that use it",
      default = false,
   }

   cmdlineParser:add_option{
      name    = {"--u2m"},
      dest    = "u2mFn",
      action  = "store",
      help    = "output file containing list of users and the list of deprecated modules they use",
      default = false,
   }


   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs

end
function fromCSV (s)
   s = s .. ','        -- ending comma
   local t = {}        -- table to collect fields
   local fieldstart = 1
   repeat
      -- next field is quoted? (start with `"'?)
      if s:find('^"', fieldstart) then
         local a, c
         local i  = fieldstart
         repeat
            -- find closing quote
            a, i, c = s:find('"("?)', i+1)
         until c ~= '"'    -- quote not followed by quote?
         if not i then error('unmatched "') end
         local f = s:sub(fieldstart+1, i-1)
         t[#t + 1] = f:gsub('""', '"')
         fieldstart = s:find(',', i) + 1
      else                -- unquoted; find next comma
         local nexti = s:find(',', fieldstart)
         t[#t + 1] =  s:sub(fieldstart, nexti-1)
         fieldstart = nexti + 1
      end
   until fieldstart > s:len(s)
   return t
end

main()
