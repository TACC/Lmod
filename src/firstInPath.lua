
local getenv = os.getenv

function firstInPath(name)
   local value = getenv(name) or ""
   local i,j   = value:find(":")
   if (i) then
      value = value:sub(1,i-1)
   end
   return value
end
