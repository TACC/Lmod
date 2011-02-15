-- BaseShell
-- $Id: BaseShell.lua 463 2009-04-03 19:32:36Z mclay $ --
require("strict")
require("base64")
require("inherits")

BaseShell = {}

local concat       = table.concat
local decode64     = base64.decode64
local format       = string.format
local getenv       = os.getenv
local huge         = math.huge
local print	   = print
local setmetatable = setmetatable
local type	   = type

require('Csh')
require('Bash')
require('Bare')

local Csh  = Csh
local Bash = Bash
local Bare = Bare

------------------------------------------------------------------------
module ('BaseShell')
------------------------------------------------------------------------

function name(self)
   print ("Shell name:",self.my_name)
end

function getMT(self,name)
   local a = {}
   local s = nil
   for i = 1, huge do
      local name = format("_ModuleTable%03d_",i)
      local v = getenv(name)
      if (v == nil) then break end
      a[#a+1] = v
   end
   if (#a > 0) then
      s = decode64(concat(a,""))
   else
      s = getenv(name) 
   end
   return s
end

local shellTbl = {}
shellTbl["sh"]	 = Bash
shellTbl["bash"] = Bash
shellTbl["zsh"]	 = Bash
shellTbl["csh"]	 = Csh
shellTbl["tcsh"] = Csh
shellTbl.bare	 = Bare

local function valid_shell(shell_name)
   if (not shellTbl[shell_name]) then
      return shellTbl.bare
   end
   return shellTbl[shell_name]
end

function build(shell_name)
   local o     = valid_shell(shell_name):create()
   return o
end
