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
--  Copyright (C) 2008-2025 Robert McLay
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

require("strict")
require("fileOps")
local dbg          = require("Dbg"):dbg()
local arg          = arg
local format       = string.format
local next         = next
local pairs        = pairs
local require      = require
local setmetatable = setmetatable

Version            = require("Version")
local version      = Version.name
local M            = {}

local s_CmdLineOptions = {}

local function l_new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self

   return o
end

function  M.options(self)
   if ( next(s_CmdLineOptions) ) then return s_CmdLineOptions end

   s_CmdLineOptions = l_new(self)

   local Optiks = require("Optiks")

   local optionTbl     = optionTbl()
   local usage         = "settarg [options] [dbg|opt|...] [anything_else]"
   local description   = "Dynamically set environment variables"
   local versionStr    = format("Lmod settarg %s",version())
   local cmdlineParser = Optiks:new{usage    = usage,
                                    progName = "settarg",
                                    descript = description,
   }

   cmdlineParser:add_option{
      name   = {"-h","-?","--help"},
      dest   = "cmdHelp",
      action = "store_true",
      help   = "This help message",
   }

   cmdlineParser:add_option{
      name   = {"-v","--version"},
      dest   = "version",
      action = "store_true",
      help   = "Print version info and quit",
   }

   cmdlineParser:add_option{
      name    = {'-s','--shell'},
      dest    = 'shell',
      action  = 'store',
      type    = 'string',
      default = 'bash',
   }

   cmdlineParser:add_option{
      name   = {'-D','--debug'},
      dest   = 'debug',
      action = 'store_true',
   }

   cmdlineParser:add_option{
      name   = {'-t','--target'},
      dest   = 'target',
      action = 'store',
      type   = 'string',
   }

   cmdlineParser:add_option{
      name   = {'-p','--purge'},
      dest   = 'purgeFlag',
      action = 'store_true',
      help   = "purge all extra fields",
   }

   cmdlineParser:add_option{
      name   = {'--destroy'},
      dest   = 'destroyFlag',
      action = 'store_true',
      help   = "Obliterate all settarg environment variables",
   }

   cmdlineParser:add_option{
      name   = {'--report'},
      dest   = 'report',
      action = 'store_true',
      help   = "Report the settarg configuration table ",
   }

   cmdlineParser:add_option{
      name   = {'--stt'},
      dest   = 'stt',
      action = 'store_true',
      help   = "Report the settarg table in the environment",
   }

   cmdlineParser:add_option{
      name   = {'-r', '--remove'},
      dest   = 'remOptions',
      action = 'append',
      type   = 'string',
   }

   cmdlineParser:add_option{
      name   = {'--no_cpu_model'},
      dest   = 'noCpuModel',
      action = 'store_true',
   }

   cmdlineParser:add_option{
      name   = {'--generic_arch'},
      dest   = 'genericArch',
      action = 'store_true',
   }

   cmdlineParser:add_option{
      name   = {'--no_grouping'},
      dest   = 'noGrouping',
      action = 'store_true',
   }

   local optTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optTbl) do
      optionTbl[v] = optTbl[v]
   end
   optionTbl.pargs = pargs

   optionTbl.cmdHelpMsg      = ""
   if (optionTbl.cmdHelp or pargs[1] == "help" ) then
      optionTbl.cmdHelpMsg   = cmdlineParser:buildHelpMsg()
   end


   optionTbl.shell = barefilename(optionTbl.shell)

   return s_CmdLineOptions
end

return M
