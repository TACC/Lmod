require("strict")
require("parseVersion")
local Dbg       = require("Dbg")
local lfs       = require("lfs")
local posix     = require("posix")
local concatTbl = table.concat

function lastFileInDir(fn)
   local dbg      = Dbg:dbg()
   dbg.start("lastFileInDir(",fn,")")
   local lastKey   = ''
   local lastValue = ''
   local result    = nil
   local fullName  = nil
   local count     = 0
   
   local attr = lfs.attributes(fn)
   if (attr and attr.mode == 'directory' and posix.access(fn,"x")) then
      for file in lfs.dir(fn) do
         local f = pathJoin(fn, file)
         attr = lfs.attributes(f)
         local readable = posix.access(f,"r")
         if (readable and file:sub(1,1) ~= "." and attr.mode == 'file' and file:sub(-1,-1) ~= '~') then
            dbg.print("fn: ",fn," file: ",file," f: ",f,"\n")
            count = count + 1
            local key = file:gsub("%.lua$","")
            key       = concatTbl(parseVersion(key),".")
            if (key > lastKey) then
               lastKey   = key
               lastValue = f
            end
         end
      end
      if (lastKey ~= "") then
         result     = lastValue
      end
   end
   dbg.print("result: ",result,"\n")
   dbg.fini()
   return result, count
end
