require("strict")
require("fileOps")
local Dbg          = require("Dbg")
local arg          = arg
local format       = string.format
local masterTbl    = masterTbl
local next         = next
local pairs        = pairs
local require      = require
local setmetatable = setmetatable

Version            = require("Version")
local version      = Version.name
local M            = {}

local s_CmdLineOptions = {}

local function new(self)
   local o = {}

   setmetatable(o,self)
   self.__index = self

   return o
end

function  M.options(self)
   if ( next(s_CmdLineOptions) ) then return s_CmdLineOptions end

   s_CmdLineOptions = new(self)

   local Optiks = require("Optiks")

   local masterTbl     = masterTbl()
   local usage         = "Usage: settarg [options] [dbg|opt|...] [compilers] [mpi_stacks] [anything_else]" 
   local cmdlineParser = Optiks:new{usage=usage, version=format("settarg %s",version())}

   cmdlineParser:add_option{ 
      name    = {'-s','--shell'},
      dest    = 'shell',
      action  = 'store',
      type    = 'string',
      default = 'bash',
   }

   cmdlineParser:add_option{ 
      name   = {'-v','--verbose'},
      dest   = 'verbosityLevel',
      action = 'count',
   }

   cmdlineParser:add_option{ 
      name   = {'-d','--debug'},
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
   }

   cmdlineParser:add_option{ 
      name   = {'-r', '--remove'},
      dest   = 'remOptions',
      action = 'append',
      type   = 'string',
   }

   cmdlineParser:add_option{ 
      name   = {'-m', '--mach'},
      dest   = 'mach',
      action = 'store',
      type   = 'string',
      default = ""
   }

   local optionTbl, pargs = cmdlineParser:parse(arg)

   for v in pairs(optionTbl) do
      masterTbl[v] = optionTbl[v]
   end
   masterTbl.pargs = pargs
   
   masterTbl.shell = barefilename(masterTbl.shell)

   return s_CmdLineOptions
end

return M
