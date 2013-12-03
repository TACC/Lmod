#!@path_to_lua@/lua
-- -*- lua -*-
require("strict")
local epoch = false
local posix = require("posix")
function build_epoch()
   if (posix.gettimeofday) then
      local x1, x2 = posix.gettimeofday()
      if (x2 == nil) then
         epoch = function()
            local t = posix.gettimeofday()
            return t.sec + t.usec*1.0e-6
         end
      else
         epoch = function()
            local t1, t2 = posix.gettimeofday()
            return t1 + t2*1.0e-6
         end
      end
   else
      epoch = function()
         return os.time()
      end
   end
end   

function main()
   build_epoch()
   print (epoch())
end

main()
