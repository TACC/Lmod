-- $Id --
require("strict")
require("posix")
require("Dbg")
require("Version")

Error = nil
local Dbg          = Dbg
local arg          = arg
local format       = string.format
local next         = next
local pairs        = pairs
local require      = require
local setenv       = posix.setenv
local setmetatable = setmetatable
local stderr       = io.stderr
local systemG      = _G
local version      = version

Options = {}

module("Options")

s_options = {}

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


function options(self, usage)
   if (next(s_options) == nil) then
      local dbg = Dbg:dbg()

      local Optiks = require("Optiks")
      s_options = new(self)
      local cmdlineParser = Optiks:new{usage   = usage,
                                       error   = dbg.warning,
                                       exit    = nothing,
                                       prt     = prt,
      }

      cmdlineParser:add_option{
         name   = {"-d"},
         dest   = "debug",
         action = "store_true",
         help   = "Print debugging",
      }

      cmdlineParser:add_option{
         name   = {"-D"},
         dest   = "dbglvl",
         action = "store",
         type   = "number",
         help   = "Debug Level",
      }

      cmdlineParser:add_option{
         name   = {"-q","--quiet","--expert"},
         dest   = "expert",
         action = "store_true",
         help   = "Do not print out warnings",
      }

      cmdlineParser:add_option{
         name   = {"--novice"},
         dest   = "novice",
         action = "store_true",
         help   = "Turn off expert flag",
      }

      cmdlineParser:add_option{
         name   = {"--version"},
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


      local optionTbl, pargs = cmdlineParser:parse(arg)

      s_options.pargs = pargs

      for k in pairs(optionTbl) do
         s_options[k] = optionTbl[k]
      end

      if (optionTbl.expert) then
         setenv("LMOD_EXPERT","1")
      end

      if (optionTbl.novice) then
         setenv("LMOD_EXPERT", nil)
      end
   end

   return s_options
end
