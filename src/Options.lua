--------------------------------------------------------------------------
-- Lmod License
--------------------------------------------------------------------------
--
--  Lmod is licensed under the terms of the MIT license reproduced below.
--  This means that Lua is free software and can be used for both academic
--  and commercial purposes at absolutely no cost.
--
--  ----------------------------------------------------------------------
--
--  Copyright (C) 2008-2013 Robert McLay
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
-- Options: This class is the main options parser for Lmod.  It defines
--          the options it supports and uses Optiks to parse the command
--          line.  All options values are copied to [[masterTbl]] and
--          positional arguments are copied to [[masterTbl.pargs]].
--          The command usage string is retrieved into
--          [[masterTbl.cmdHelpMsg]].

require("strict")

Error = nil
local Dbg          = require("Dbg")
local format       = string.format
local posix        = require("posix")
local setenv       = posix.setenv
local stderr       = io.stderr
local systemG      = _G

local M = {}

s_options = false

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self
   return o
end

local function prt(...)
   stderr:write(...)
end

local function nothing()
end


function M.options(self, usage)
   local dbg = Dbg:dbg()

   local Optiks = require("Optiks")

   s_options = new(self)

   local cmdlineParser  = Optiks:new{usage   = usage,
                                     error   = LmodWarning,
                                     exit    = nothing,
                                     prt     = prt,
   }

   cmdlineParser:add_option{
      name   = {"-h","-?","--help"},
      dest   = "cmdHelp",
      action = "store_true",
      help   = "This help message",
   }

   cmdlineParser:add_option{
      name   = {"-D","--debug"},
      dest   = "debug",
      action = "store_true",
      help   = "Program tracing written to stderr",
   }

   cmdlineParser:add_option{
      name   = {"-d","--default"},
      dest   = "defaultOnly",
      action = "store_true",
      help   = "List default modules only when used with avail"
   }

   cmdlineParser:add_option{
      name   = {"-q","--quiet","--expert"},
      dest   = "expert",
      action = "store_true",
      help   = "Do not print out warnings",
   }

   cmdlineParser:add_option{
      name   = {"-t","--terse"},
      dest   = "terse",
      action = "store_true",
      help   = "Write out in machine readable format for " ..
               "commands: list, avail, spider",
   }

   cmdlineParser:add_option{
      name   = {"--initial_load"},
      dest   = "initial",
      action = "store_true",
      help   = "loading Lmod for first time in a user shell",
   }

   cmdlineParser:add_option{
      name   = {"--latest"},
      dest   = "latest",
      action = "store_true",
      help   = "Load latest (ignore default)",
   }

   cmdlineParser:add_option{
      name   = {"--ignore_cache"},
      dest   = "ignoreCache",
      action = "store_true",
      help   = "Treat the cache file(s) as out-of-date",
   }

   cmdlineParser:add_option{
      name   = {"--novice"},
      dest   = "novice",
      action = "store_true",
      help   = "Turn off expert flag",
   }

   cmdlineParser:add_option{
      name   = {"-v","--version"},
      dest   = "version",
      action = "store_true",
      help   = "Print version info and quit",
   }

   cmdlineParser:add_option{
      name   = {"--localvar"},
      dest   = "localvarA",
      action = "append",
      help   = "local variables needed to be set after this commands execution",
   }

   cmdlineParser:add_option{
      name   = {"--check_syntax", "--checkSyntax"},
      dest   = "checkSyntax",
      action = "store_true",
      help   = "Checking module command syntax: do not load",
   }

   cmdlineParser:add_option{
      name   = {"--config" },
      dest   = "config",
      action = "store_true",
      help   = "Report Lmod Configuration",
   }

   cmdlineParser:add_option{
      name   = {"--force" },
      dest   = "force",
      action = "store_true",
      help   = "force removal of a sticky module",
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)
   local masterTbl        = masterTbl()
   masterTbl.pargs        = pargs


   for k in pairs(optionTbl) do
      masterTbl[k] = optionTbl[k]
   end

   masterTbl.cmdHelpMsg      = ""
   if (masterTbl.cmdHelp or pargs[1] == "help" ) then
      masterTbl.cmdHelpMsg   = cmdlineParser:buildHelpMsg()
   end

   if (optionTbl.expert) then
      setenv("LMOD_EXPERT","1")
   end

   if (optionTbl.novice) then
      setenv("LMOD_EXPERT", nil)
   end
end

return M
