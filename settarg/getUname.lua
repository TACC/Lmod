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

   local machFullName     = nil
   local osName           = posix.uname("%s")
   local machName         = posix.uname("%m")
   osName                 = string.gsub(osName,"[ /]","_")
   if (osName:lower() == "aix") then
      machName = "rs6k"
   elseif (osName:lower():sub(1,4) == "irix") then
      osName   = "Irix"
      machName = "mips"
   end
   if (osName == "Linux") then
      local cpu_family
      local model
      local count = 0
      local f = io.open("/proc/cpuinfo","r")
      if (f) then
         while (true) do
            local line = f:read("*line")
            if (line == nil) then break end
            if (line:find("cpu family")) then
               local _, _, v = line:find(".*:%s*(.*)")
               cpu_family = string.format("%02x",v)
               count = count + 1
            elseif (line:find("model name")) then
               local _, _, v = line:find(".*:%s*(.*)")
               machFullName = string.format("%02x",v)
               count = count + 1
            elseif (line:find("model")) then
               local _, _, v = line:find(".*:%s*(.*)")
               model = string.format("%02x",v)
               count = count + 1
            end
            if (count > 2) then break end
         end
      end
      machName = machName .. "_" .. cpu_family .. "_" .. model
   end
   t.osName       = osName
   t.machName     = machName
   t.machFullName = machFullName
   t.os_mach      = osName .. '-' .. machName
   t.target       = os.getenv("TARGET") or ""
   t.hostName     = capture("hostname -f"):gsub("%s+","")

   s_t = t
   return t
end
