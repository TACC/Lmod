local M={}
function M.tag()  return "8.5.6"   end
function M.git()
   local s = "@git@"
   if (s == "@" .. "git@")     then s = "" end
   if (s == "("..M.tag()..")") then s = "" end
   return s
end
function M.date() return "2021-06-22 08:18 -05:00" end
function M.name()
  local a = {}
  a[#a+1] = M.tag()
  a[#a+1] = M.git()
  a[#a+1] = M.date()
  return table.concat(a," ")
end
return M
