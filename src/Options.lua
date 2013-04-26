require("strict")

Error = nil
local Dbg          = require("Dbg")
local arg          = arg
local format       = string.format
local next         = next
local pairs        = pairs
local posix        = require("posix")
local require      = require
local setenv       = posix.setenv
local setmetatable = setmetatable
local stderr       = io.stderr
local systemG      = _G
local version      = version

--module("Options")

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
      dest   = "cmdhelp",
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
      name   = {"--novice"},
      dest   = "novice",
      action = "store_true",
      help   = "Turn off expert flag",
   }

   cmdlineParser:add_option{
      name   = {"-v","-V","--version"},
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


   local optionTbl, pargs = cmdlineParser:parse(arg)
   local masterTbl        = masterTbl()
   masterTbl.pargs        = pargs


   for k in pairs(optionTbl) do
      masterTbl[k] = optionTbl[k]
   end

   masterTbl.cmdHelpMsg      = "" 
   if (masterTbl.cmdhelp or pargs[1] == "help" ) then
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
