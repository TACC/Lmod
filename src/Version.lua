local M={}
function M.tag()  return "8.4.25"   end
function M.git()
   local s = "@git@"
   if (s == "@" .. "git@")     then s = "" end
   if (s == "("..M.tag()..")") then s = "" end
   return s
end
function M.date() return "2021-02-26 16:30 -06:00" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M
