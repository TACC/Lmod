require("strict")

s_pager = false

function bypassPager(f, ...)
   local arg = { n = select('#', ...), ...}
   for i = 1, arg.n do
      f:write(arg[i])
   end
end


function usePager(f, ...)
   if (not s_pager) then
      s_pager = os.getenv("PAGER") or Pager
      if (s_pager == "@PATH_TO_PAGER@") then
         bypassPager(f, ...)
         return
      end
   end
   local p = io.popen(s_pager .. " 1>&2" ,"w")
   local s = table.concat({...},"")
   p:write(s)
   p:close()
end
   

