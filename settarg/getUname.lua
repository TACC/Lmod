require("strict")
require("capture")
local posix = require("posix")

s_t = {}


function getUname()

   local t = s_t
   if (next(t) ~= nil) then
      s_t = t
      return t
   end

   local osName           = posix.uname("%s")
   local machName         = posix.uname("%m")
   osName                 = string.gsub(osName,"[ /]","_")
   if (osName:lower() == "aix") then
      machName = "rs6k"
   elseif (osName:lower():sub(1,4) == "irix") then
      osName   = "Irix"
      machName = "mips"
   end
   t.osName    = osName
   t.machName  = machName
   t.os_mach   = osName .. '-' .. machName
   t.target    = os.getenv("TARGET") or ""
   t.hostName  = capture("hostname -f"):gsub("%s+","")

   s_t = t
   return t
end
