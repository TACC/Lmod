-- $Id: firstInPath.lua 419 2009-02-17 16:18:58Z mclay $ --

local getenv = os.getenv

function firstInPath(name)
   local value = getenv(name) or ""
   local i,j   = value:find(":")
   if (i) then
      value = value:sub(1,i-1)
   end
   return value
end
