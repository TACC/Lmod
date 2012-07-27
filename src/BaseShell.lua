-- BaseShell
require("strict")
require("inherits")

local M            = {}

local base64       = require("base64")
local concat       = table.concat
local decode64     = base64.decode64
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge
local print	   = print
local setmetatable = setmetatable
local type	   = type

function doubleQuoteEscaped(s)
   s = s:gsub('"','\\"')
   return s
end

function atSymbolEscaped(s)
   s = s:gsub('@','\\@')
   return s
end

------------------------------------------------------------------------
--module ('BaseShell')
------------------------------------------------------------------------

function M.name(self)
   print ("Shell name:",self.my_name)
end

function M.getMT(self)
   local a    = {}
   local mtSz = getenv("_ModuleTable_Sz_") or huge
   local s    = nil

   for i = 1, mtSz do
      local name = format("_ModuleTable%03d_",i)
      local v    = getenv(name)
      if (v == nil) then break end
      a[#a+1]    = v
   end
   if (#a > 0) then
      s = decode64(concat(a,""))
   end
   return s
end

local function valid_shell(shellTbl, shell_name)
   if (not shellTbl[shell_name]) then
      return shellTbl.bare
   end
   return shellTbl[shell_name]
end

function M.build(shell_name)

   local shellTbl   = {}
   local Csh        = require('Csh')
   local Bash       = require('Bash')
   local Bare       = require('Bare')
   local Perl       = require('Perl')
   shellTbl["sh"]   = Bash
   shellTbl["bash"] = Bash
   shellTbl["zsh"]  = Bash
   shellTbl["csh"]  = Csh
   shellTbl["tcsh"] = Csh
   shellTbl["perl"] = Perl
   shellTbl.bare    = Bare


   local o     = valid_shell(shellTbl, shell_name):create()
   return o
end

return M
