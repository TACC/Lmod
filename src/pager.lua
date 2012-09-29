require("strict")
require("TermWidth")
require("string_split")

function pager(f, ...)
   local height = TermHeight()

   local irow   = 0

   local arg = { n = select('#', ...), ...}

   for i = 1, arg.n do
      for s in arg[i]:split("\n") do
         irow = irow + 1
         if (irow > height) then
            irow = 0
            f:write("MORE:")
            local t = io.read(1)
            f:write("\r")
         end
         f:write(s,"\n")
      end
   end
end
   
